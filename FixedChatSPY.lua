-- its okay to use chatgpt some times
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
-- CHAT HANDLER
-- ============================================================

local GeneralChannel =
	TextChatService.TextChannels:FindFirstChild("RBXGeneral")

if not GeneralChannel then
	warn("ERX: RBXGeneral was not found!")
	return
end

GeneralChannel.MessageReceived:Connect(function(k)
	if not k or not k.TextSource then
		return
	end

	-- Get the player who sent the message.
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

	-- ========================================================
	-- COMMAND
	-- ========================================================

	if args[1] then
		local Said = tostring(args[1]):lower()

		-- ====================================================
		-- :KL
		-- ====================================================
		-- No target is needed.
		-- Example: Player says ":kl"
		-- ====================================================

		if Said == ":kl" then
			if _G.AdminLogs then
				_G.PushNotification(
					"Yellow",
					PlayerName .. " Is viewing kill logs"
				)
			end

			CustomConnections.OnCMDUsed:Fire({
				Command = Said,
				UsedOn = PlayerName
			})

			return
		end

		-- ====================================================
		-- :VIEW / :UNVIEW
		-- ====================================================

		if ListenToUnview[PlayerName]
			and (Said == ":view" or Said == ":unview")
		then
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
				"You are currently being viewed by "
					.. PlayerName,
				true,
				false
			)

			CustomConnections.OnStaffUnview:Fire({
				PlayerName = PlayerName
			})
		end

		-- ====================================================
		-- TARGET COMMANDS
		-- ====================================================

		if args[2] then
			local targetName = tostring(args[2]):lower()

			for _, targetPlayer in ipairs(Players:GetPlayers()) do
				local username = targetPlayer.Name:lower()
				local displayName = targetPlayer.DisplayName:lower()

				local matches =
					targetName == "all"
					or username:sub(1, #targetName) == targetName
					or displayName:sub(1, #targetName) == targetName

				if matches then
					if _G.AdminLogs then

						-- ========================================
						-- :VIEW
						-- ========================================

						if Said == ":view" then
							if targetPlayer ~= LocalPlayer then
								_G.PushNotification(
									"Yellow",
									PlayerName
										.. " is now viewing: "
										.. targetPlayer.Name
								)

								ListenToUnview[PlayerName] = nil
							else
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

								ListenToUnview[PlayerName] = true

								if _G.ViewAction
									and _G.SelectedViewAction
								then
									if _G.SelectedViewAction == "Kill" then
										EnviromentRemote:FireServer(
											math.random(100, 200)
										)

									elseif _G.SelectedViewAction == "Respawn" then
										Functions:Respawn()

									elseif _G.SelectedViewAction == "Fling" then
										if Functions:IsDisablerOn() then
											Humanoid.Sit = true
											task.wait()
											Humanoid.Sit = false
										end

										while _G.YieldFling do
											task.wait()
										end

										HumanoidRootPart.Velocity =
											Vector3.new(1e3, 1e3, 1e4)
									end
								end

								CustomConnections.OnLocalPlayerViewed:Fire({
									PlayerName = PlayerName
								})
							end

						-- ========================================
						-- :TO
						-- ========================================

						elseif Said == ":to" then
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

						-- ========================================
						-- :BRING
						-- ========================================

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

						-- ========================================
						-- :KILL
						-- ========================================

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
									PlayerName
										.. " Killed u"
								)
							end

							CustomConnections.OnCMDUsed:Fire({
								Command = Said,
								UsedOn = PlayerName
							})

						-- ========================================
						-- :HEAL
						-- ========================================

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
									PlayerName
										.. " Healed you"
								)
							end

							CustomConnections.OnCMDUsed:Fire({
								Command = Said,
								UsedOn = PlayerName
							})

						-- ========================================
						-- :KICK
						-- ========================================

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

						-- ========================================
						-- :BAN
						-- ========================================

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

						-- ========================================
						-- :LOGS
						-- ========================================

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
						end

						return
					end
				end
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

