local skynet = require "skynet"
local sock_mgr = require "sock_mgr"
local player_mgr  = require "player_mgr"
local login_mgr = require "login_mgr"

local CMD = {}

function CMD.start(conf)
    sock_mgr:start(conf)
    player_mgr:init()
    login_mgr:init()
end

skynet.start(function()
    skynet.dispatch("lua", function(_, session, cmd, subcmd, ...)
        if cmd == "socket" then
            sock_mgr[subcmd](sock_mgr, ...)
            return
        end

        local f = CMD[cmd]
        assert(f, "can't find dispatch handler cmd = "..cmd)

        if session > 0 then
            return skynet.ret(skynet.pack(f(subcmd, ...)))
        else
            f(subcmd, ...)
        end
    end)
end)
