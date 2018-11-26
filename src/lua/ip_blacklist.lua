--
-- Created by IntelliJ IDEA.
-- User: root
-- Date: 2018/11/20
-- Time: 18:10
-- To change this template use File | Settings | File Templates.
--
--base config
local function redis()
    local redis=require("resty.redis")
    --创建实例
    local red=redis:new()
    --设置超时时间
    red:set_timeout(1000)
    --连接
    local ip="192.168.30.31"
    local port=6379
    local pass="h0hmObKy4Sv1AnGmIffWA17Q4YIhoGIX"
    local ok,err=red:connect(ip,port)
    if not ok then
        ngx.say("connect to redis error:",err)
        return
    end
    --认证
    local ok,err=red:auth(pass)
    if not ok then
        ngx.say("error",err)
        return
    else
        return red
    end
end

--info config
local ttl=60
local key="ip_blacklist"
local client_ip=ngx.var.remote_addr
local share_dict=ngx.shared.ip_blacklist
local last_update_time=share_dict:get("last_update_time")

--如果最新更新时间为空或60秒没刷share_dict区域
if last_update_time == nil or last_update_time < (ngx.now() - ttl) then
    red=redis()
    --获取集合所有数据
    local sets,err=red:smembers(key)
    if err then
        ngx.say("get key fail：",err)
    else
        --清空共享区
        share_dict:flush_all()
        --遍历id+value数据类型
        for id,value in ipairs(sets) do
            share_dict:set(value,true)
        end
        share_dict:set("last_update_time",ngx.now())
    end
end
if share_dict:get(client_ip) then
    return ngx.exit(ngx.HTTP_FORBIDDEN)
end



