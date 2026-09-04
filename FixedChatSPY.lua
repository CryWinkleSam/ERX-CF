cloneref = cloneref or function(A)
	return A
end

clonefunction = clonefunction or function(...)
	return ...
end

local Players = cloneref(game:GetService("Players"))
local TextChatService = cloneref(game:GetService("TextChatService"))

local LocalPlayer = Players.LocalPlayer

repeat
	task.wait()
until _G.WindUI and _G.Tabs and _G.Window

local WindUI = _G.WindUI
local Window = _G.Window
local Tabs = _G.Tabs

warn("CFSPY")

-- ============================================================
-- INITIALIZE TABLES
-- ============================================================

ListenToUnview = ListenToUnview or {}
FakeCallsListenTO = FakeCallsListenTO or {}

-- ============================================================
-- CHAT CHANNEL
-- ============================================================

local GeneralChannel =
	TextChatService.TextChannels:FindFirstChild("RBXGeneral")

if not GeneralChannel then
	warn("ERX: RBXGeneral was not found!")
	return
end

-- ============================================================
-- PLAYER LOOKUP
-- ============================================================

local function GetTargetPlayer(targetName)
	if not targetName then
		return nil
	end

	targetName = tostring(targetName):lower()

	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		local username = targetPlayer.Name:lower()
		local displayName = targetPlayer.DisplayName:lower()

		if targetName == "all"
			or username:sub(1, #targetName) == targetName
			or displayName:sub(1, #targetName) == targetName
		then
			return targetPlayer
		end
	end

	return nil
end

-- ============================================================
-- CHAT HANDLER
-- ============================================================

GeneralChannel.MessageReceived:Connect(function(k)
	if not k or not k.TextSource then
		return
	end

	-- ========================================================
	-- GET ACTUAL PLAYER FROM MESSAGE
	-- ========================================================

	local player =
		Players:GetPlayerByUserId(k.TextSource.UserId)

	if not player or player == LocalPlayer then
		return
	end

	local PlayerName = player.Name
	local Message = tostring(k.Text or "")
	local args = string.split(Message, " ")

	if PlayerName == "" then
		return
	end

	local Said = args[1] and tostring(args[1]):lower()

	if not Said then
		return
	end

	-- ========================================================
	-- :KL
	-- ========================================================

	if Said == ":kl" then
		if _G.AdminLogs then
			_G.PushNotification(
				"Yellow",
				PlayerName .. " Checked kill logs!"
			)
		end

		CustomConnections.OnCMDUsed:Fire({
			Command = Said,
			UsedOn = PlayerName
		})

		return
	end

	-- ========================================================
	-- :VIEW
	--
	-- IMPORTANT:
	-- There is NO :unview command.
	--
	-- :view Target
	--     -> starts viewing Target
	--
	-- :view
	--     -> if this same moderator is already viewing us,
	--        clear their view state
	--
	-- :view DifferentTarget
	--     -> if this same moderator is already viewing us,
	--        ALSO clear their view state
	--
	-- Only the SAME moderator can clear their own state.
	-- ========================================================

	if Said == ":view" then

		-- ====================================================
		-- SAME MODERATOR IS ALREADY VIEWING US
		-- ====================================================

		if ListenToUnview[PlayerName] then
			ListenToUnview[PlayerName] = nil

			WindUI:Notify({
				Title = "Mod Alerts",
				Content =
					"You are no longer being viewed by "
					.. PlayerName,
				Duration = 10,
			})

			_G.PushNotification(
				"Yellow",
				"You are no longer being viewed by "
					.. PlayerName,
				true,
				false
			)

			CustomConnections.OnStaffUnview:Fire({
				PlayerName = PlayerName
			})

			return
		end

		-- ====================================================
		-- NO TARGET
		--
		-- If the moderator wasn't already viewing us,
		-- plain :view does nothing.
		-- ====================================================

		if not args[2] then
			return
		end

		-- ====================================================
		-- TARGETED :VIEW
		-- ====================================================

		local targetPlayer = GetTargetPlayer(args[2])

		if not targetPlayer then
			return
		end

		if not _G.AdminLogs then
			return
		end

		-- ====================================================
		-- THEY ARE VIEWING SOMEONE ELSE
		-- ====================================================

		if targetPlayer ~= LocalPlayer then
			_G.PushNotification(
				"Yellow",
				PlayerName
					.. " is now viewing: "
					.. targetPlayer.Name
			)

			return
		end

		-- ====================================================
		-- THEY ARE VIEWING US
		-- ====================================================

		ListenToUnview[PlayerName] = true

		WindUI:Notify({
			Title = "Mod Alerts",
			Content =
				"You Are Being Viewed by "
				.. PlayerName,
			Duration = 25,
		})

		_G.PushNotification(
			"Yellow",
			"You are currently being viewed by "
				.. PlayerName,
			true,
			true
		)

		CustomConnections.OnLocalPlayerViewed:Fire({
			PlayerName = PlayerName
		})

		return
	end

	-- ========================================================
	-- TARGET COMMANDS
	-- ========================================================

	if args[2] then
		local targetPlayer = GetTargetPlayer(args[2])

		if targetPlayer and _G.AdminLogs then

			-- ================================================
			-- :TO
			-- ================================================

			if Said == ":to" then

				if targetPlayer ~= LocalPlayer then
					_G.PushNotification(
						"Yellow",
						PlayerName
							.. " Teleported to: "
							.. targetPlayer.Name
					)
				else
					_G.PushNotification(
						"Yellow",
						PlayerName
							.. " Teleported to you"
					)
				end

				FakeCallsListenTO[PlayerName] = nil

				CustomConnections.OnCMDUsed:Fire({
					Command = Said,
					UsedOn = PlayerName
				})

				return

			-- ================================================
			-- :BRING
			-- ================================================

			elseif Said == ":bring" then

				if targetPlayer ~= LocalPlayer then
					_G.PushNotification(
						"Yellow",
						PlayerName
							.. " Brought: "
							.. targetPlayer.Name
					)
				else
					_G.PushNotification(
						"Yellow",
						PlayerName
							.. " Brought U to them"
					)
				end

				CustomConnections.OnCMDUsed:Fire({
					Command = Said,
					UsedOn = PlayerName
				})

				return

			-- ================================================
			-- :KILL
			--
			-- This is ONLY logging the command:
			-- :kill PlayerName
			-- ================================================

			elseif Said == ":kill" then

				if targetPlayer ~= LocalPlayer then
					_G.PushNotification(
						"Yellow",
						PlayerName
							.. " Killed: "
							.. targetPlayer.Name
					)
				else
					_G.PushNotification(
						"Yellow",
						PlayerName .. " Killed u"
					)
				end

				CustomConnections.OnCMDUsed:Fire({
					Command = Said,
					UsedOn = PlayerName
				})

				return

			-- ================================================
			-- :HEAL
			-- ================================================

			elseif Said == ":heal" then

				if targetPlayer ~= LocalPlayer then
					_G.PushNotification(
						"Yellow",
						PlayerName
							.. " Healed: "
							.. targetPlayer.Name
					)
				else
					_G.PushNotification(
						"Yellow",
						PlayerName .. " Healed you"
					)
				end

				CustomConnections.OnCMDUsed:Fire({
					Command = Said,
					UsedOn = PlayerName
				})

				return

			-- ================================================
			-- :KICK
			-- ================================================

			elseif Said == ":kick" then

				_G.PushNotification(
					"Yellow",
					PlayerName
						.. " Kicked: "
						.. targetPlayer.Name
				)

				CustomConnections.OnCMDUsed:Fire({
					Command = Said,
					UsedOn = PlayerName
				})

				return

			-- ================================================
			-- :BAN
			-- ================================================

			elseif Said == ":ban" then

				_G.PushNotification(
					"Yellow",
					PlayerName
						.. " Banned: "
						.. targetPlayer.Name
				)

				CustomConnections.OnCMDUsed:Fire({
					Command = Said,
					UsedOn = PlayerName
				})

				return

			-- ================================================
			-- :LOGS
			-- ================================================

			elseif Said == ":logs" then

				_G.PushNotification(
					"Yellow",
					PlayerName
						.. " Is viewing cmd logs"
				)

				CustomConnections.OnCMDUsed:Fire({
					Command = Said,
					UsedOn = PlayerName
				})

				return
			end
		end
	end

	-- ============================================================
	-- !MOD / !HELP
	-- ============================================================

	if Message == "!mod" or Message == "!help" then

		if _G.AdminLogs then
			_G.PushNotification(
				"Red",
				PlayerName .. " Called !mod"
			)
		end

		if _G.DisplayModCalls then

			FakeCallsListenTO[PlayerName] = true

			task.delay(200, function()
				if FakeCallsListenTO[PlayerName] then
					FakeCallsListenTO[PlayerName] = nil
				end
			end)

			_G.PushNotification(
				"Yellow",
				PlayerName
					.. " has requested\nassistance! Click to go assist them!",
				true,
				true,
				{
					name = "ModHelpTeleport",
					data = {
						PlayerName = PlayerName,
						DORBLX_IS_HOT = true
					}
				}
			)

			task.spawn(function()
				while FakeCallsListenTO[PlayerName] do
					task.wait()
				end

				_G.PushNotification(
					"Yellow",
					PlayerName
						.. " has requested\nassistance! Click to go assist them!",
					true,
					false
				)
			end)
		end

		return
	end

	-- ============================================================
	-- CHAT SPY
	-- ============================================================

	if _G.ChatSpy then
		_G.PushNotification(
			"White",
			PlayerName .. " Said: " .. Message
		)
	end
end)
