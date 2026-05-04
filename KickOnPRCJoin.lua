-- Auto kick when PRC Mod joins your server [needs ERX]
-- og
repeat task.wait() until _G.Functions

local Connections = _G.Connections

Connections.OnPRCStaffJoin.Event:Connect(function(Info)
    game:GetService("Players").LocalPlayer:Kick("!PRC Mod! joined you, Name: "..(Info.Player and Info.Player.Name or "?"))
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
