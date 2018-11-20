--
-- Created by IntelliJ IDEA.
-- User: root
-- Date: 2018/11/19
-- Time: 15:46
-- To change this template use File | Settings | File Templates.
--
local function read_order()
    local resp=ngx.location.capture("/order/get",{method=ngx.HTTP_GET})
    if not resp then
        return
    end
    if resp.status ~= 200 then
        return
    end
    return resp.body
end

ngx.say(read_order())
