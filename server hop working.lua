--[[ AUTO ARREST SERVER HOP mateymetamethod sam kirk dtc dtc dtc dtc dtf ctdtdadasjdasjkd

STRAIGHT OUTTA BIG G
]]
-- _G.key = "ERX-KEY"

task.spawn(function()
	if game.PlaceId == 2534724415 then
		_G.IgnoreWarns = true
		script_key = _G.key
		loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/e72dda22a300c4de5ded1a43123b0e20.lua"))()
	end
end)

repeat task.wait() until _G.Functions


_G.Window.TabModule.Tabs[1].Elements[3].Callback(true)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

local CheckCallsign = ReplicatedStorage:WaitForChild("FE"):WaitForChild("CheckCallsign")
local CanChange = ReplicatedStorage:WaitForChild("FE"):WaitForChild("CanChangeTeam")
local TeamChangeRemote = ReplicatedStorage:WaitForChild("FE"):WaitForChild("TeamChange")
local GetWantedLevel = ReplicatedStorage.FE.GetWantedLevel


local server_hop = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/Cesare0328/my-scripts/refs/heads/main/CachedServerhop.lua")
)
-- server_hop() k ng?



if not CheckCallsign or not TeamChangeRemote or not CanChange or not GetWantedLevel then
	warn("Error during finding required remotes.")
	wait(1)
    server_hop()
    return
end


local function howManyWanted()
	local wantedCount = 0

	for _, plr in ipairs(Players:GetPlayers()) do
		local ok, result = pcall(function()
			return GetWantedLevel:InvokeServer(plr)
		end)

		if ok and result then
			local firstNumber = tonumber(tostring(result):match("^(%d+)"))
			if firstNumber and firstNumber ~= 0 then
				wantedCount += 1
			end
		end
	end

	return wantedCount
end

local server_hop = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/Cesare0328/my-scripts/refs/heads/main/CachedServerhop.lua")
)

local Players = game:GetService("Players")
local player = Players.LocalPlayer



local function checkWantedAndTrigger()
	while task.wait(1) do
		local wanted = howManyWanted()

		warn("Wanted value:", wanted, typeof(wanted))

		if wanted and wanted == 0 then
			warn("[!!]: Waiting 12-46 seconds to hop to byp ur XP getting set to zero :(")
			_G.PushNotification("Red", "Auto Hop: Waiting 12-46s to serverhop!")
			task.wait(math.random(12, 46)) -- sry this is so ur XP isnt set to Zero
			server_hop()

			break
		end
	end
end

task.spawn(checkWantedAndTrigger)


local CoreGui = game:GetService("CoreGui")

local function isKicked()
	local robloxGui = CoreGui:FindFirstChild("RobloxPromptGui")
	if not robloxGui then return false end

	local overlay = robloxGui:FindFirstChild("promptOverlay")
	if not overlay then return false end

	return overlay:FindFirstChild("ErrorPrompt") ~= nil
end

task.spawn(function()
	while task.wait(1) do
		if isKicked() then
			local robloxGui = CoreGui:FindFirstChild("RobloxPromptGui")
			local overlay = robloxGui and robloxGui:FindFirstChild("promptOverlay")
			local errorPrompt = overlay and overlay:FindFirstChild("ErrorPrompt")

			if errorPrompt then
				errorPrompt:Destroy()
			end

			if typeof(server_hop) == "function" then
				pcall(server_hop)
			end
		end
	end
end)


task.spawn(function()
	while task.wait(1) do
		_G.PushNotification("Green", "Wanted left: " .. howManyWanted())

		
	end
end)


task.spawn(function()
	local timeStuck = 0

	while task.wait(1) do
		local team = player:GetAttribute("Team")

		if team == "Civilian" then
			timeStuck += 1
			if timeStuck >= 5 then
				warn("stuck on Civilian for too long. Hopping...")
				server_hop()
			end
		else
			timeStuck = 0
		end
	end
end)




local function generateCallsign()
	local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

	local function randomLetters(count)
		local result = ""
		for _ = 1, count do
			local index = math.random(1, #letters)
			result ..= letters:sub(index, index)
		end
		return result
	end

	local prefix = randomLetters(2)
	local suffix = tostring(math.random(10, 99))

	return prefix .. "-" .. suffix
end


local function enableAutoArrest()
	local ok = pcall(function()
		local tab = _G.Window
			and _G.Window.TabModule
			and _G.Window.TabModule.Tabs
			and _G.Window.TabModule.Tabs[1]

		local el = tab and tab.Elements and tab.Elements[8]

		if el and type(el.Callback) == "function" then
			el.Callback(true)
		else
			warn("NR")
		end
	end)

	return ok
end


task.wait(2)
enableAutoArrest()

player.CharacterAdded:Connect(function()
	task.wait(2)
	enableAutoArrest()
end)




local canChangeTeamRes = CanChange:InvokeServer(game.Teams.Police)

if canChangeTeamRes == "Full" then
	server_hop()
    return
elseif canChangeTeamRes == "Good" then
	_G.PushNotification("Green", "good to go")

	local Callsign = generateCallsign()
	local callsignValid = CheckCallsign:InvokeServer(Callsign)

	if not callsignValid then
		_G.PushNotification("Red", "Callsign rejected.")
		return
	end

	TeamChangeRemote:FireServer(game.Teams.Police, Callsign)

	repeat task.wait() until player.Backpack:FindFirstChild("Handcuffs")

	_G.Window.TabModule.Tabs[1].Elements[8].Callback(true)

elseif canChangeTeamRes == "Wanted" then
	warn("You are wanted or already on the team.")
	return
end


task.spawn(function()
	while task.wait(120) do
		player:Kick()
	end
end)
