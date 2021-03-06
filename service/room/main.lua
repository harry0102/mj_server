local skynet = require "skynet"
local player_mgr = require "player_mgr"
local table_mgr = require "table_mgr"
local mjlib = require "mjlib"

local room_id = ...
room_id = tonumber(room_id)

local CMD = {}

function CMD.enter()
    player_mgr:init()

    table_mgr:init()
end

function CMD.leave()

end

skynet.start(function ()
    skynet.dispatch("lua", function (_, session, cmd, ...)
        local f = CMD[cmd]
        assert(f, cmd)

        if session == 0 then
            f(...)
        else
            skynet.ret(skynet.pack(f(...)))
        end
    end)

    if room_id == 1 then
        mjlib.test()
    end
end)
