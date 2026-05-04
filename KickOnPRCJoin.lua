-- Auto kick when PRC Mod joins your server [needs ERX]
repeat task.wait() until _G.Functions

local Connections = _G.Connections

Connections.OnPRCStaffJoin.Event:Connect(function(Info)
    game:GetService("Players").LocalPlayer:Kick("!PRC Mod! joined you, Name: "..(Info.Player and Info.Player.Name or "?"))
end)
