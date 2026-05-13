_G.userIDs = {16222847, 23665982, 387574627, 500161865}

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

if _G.Functions and _G.Connections and _G.Connections.OnPRCStaffJoin then
    _G.Connections.OnPRCStaffJoin.Event:Connect(function(Info)
        local name = Info.Player and Info.Player.Name or "?"
        lp:Kick("!PRC Mod! joined you, Name: " .. name)
    end)
end

Players.PlayerAdded:Connect(function(plr)
    for _, id in ipairs(_G.userIDs) do
        if plr.UserId == id then
            lp:Kick(plr.Name .. " - PRC Mod Joined!")
            return
        end
    end
end)


-- delay option

--[[repeat task.wait() until _G.Functions

local Connections = _G.Connections

Connections.OnPRCStaffJoin.Event:Connect(function(Info)
    local player = game:GetService("Players").LocalPlayer
    local msg = "!PRC Mod! joined you, Name: "..(Info.Player and Info.Player.Name or "?")

    local deltime = _G.Delay

    if typeof(deltime) == "number" and deltime > 0 then
        task.spawn(function()
            for i = deltime, 1, -1 do
                if _G.PushNotification then
                    _G.PushNotification("Red", "ERX: You will be kicked in "..i.."!")
                end
                task.wait(1)
            end

            if player then
                player:Kick(msg)
            end
        end)
    else
        player:Kick(msg)
    end
end)]]
