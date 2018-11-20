--
-- Created by IntelliJ IDEA.
-- User: root
-- Date: 2018/11/16
-- Time: 17:01
-- To change this template use File | Settings | File Templates.
--
local function close_redis(red)
    if not red then
        return
    end
    local ok,err=red:close()
    if not ok then
        ngx.say("close redis redis:",err)
    end
end

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
end
--set
local ok, err = red:set("msg", "hello world1")
if not ok then
    ngx.say("set msg error:",err)
    return close_redis(red)
end
--get
local res,err=red:get("msg")
if not res then
    ngx.say("get msg error:",err)
    return close_redis(red)

end
if res == ngx.null then

end

ngx.say("msg:",res)

close_redis(red)




