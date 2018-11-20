--
-- Created by IntelliJ IDEA.
-- User: root
-- Date: 2018/11/20
-- Time: 17:27
-- To change this template use File | Settings | File Templates.
--

local limit_req=require("resty.limit.req")
local rate=1    --每秒1个
local burst=2   --延迟队列2个
local error_status=503

local lim,err=limit_req.new("limit_req_store",rate,burst)
if not lim then
    ngx.say(err)
    ngx.exit(error_status)
end

local key=ngx.var.binary_remote_addr
local delay,err=lim:incoming(key,true)
if not delay and err=="rejected" then
    ngx.exit(error_status)
end


