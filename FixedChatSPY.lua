cloneref = cloneref or function(A)
	return A
end

clonefunction = clonefunction or function(...)
	return ...
end

repeat
	task.wait()
until _G.WindUI and _G.Tabs and _G.Window

local WindUI = _G.WindUI
local Window = _G.Window
local Tabs = _G.Tabs

if args and args[1] then
				if ListenToUnview[PlayerName] and (args[1]:lower() == ":view" or args[1]:lower() == ":unview") then
					ListenToUnview[PlayerName] = nil

					WindUI:Notify({
						Title = "Mod Alerts",
						Content = "You are no longer being viewed by "..PlayerName,
						Duration = 10,
					})

					_G.PushNotification("Yellow", "You are currently being viewed by "..PlayerName, true, false)

					CustomConnections.OnStaffUnview:Fire({
						PlayerName = PlayerName
					})
				end

				if args[2] then
					local playerName = args[2]:lower()

					for _, player in ipairs(Players:GetPlayers()) do
						if player.Name:lower():sub(1, #playerName) == playerName or player.DisplayName:lower():sub(1, #playerName) == playerName or playerName == "all" then
							if _G.AdminLogs then
								local Said = args[1]:lower()

								if Said == ":view" then
									if player ~= LocalPlayer then
										_G.PushNotification("Yellow", PlayerName .. " is now viewing: " .. player.Name)
										ListenToUnview[PlayerName] = nil
									elseif player == LocalPlayer then
										WindUI:Notify({
											Title = "Mod Alerts",
											Content = "You Are Being Viewed by "..PlayerName,
											Duration = 25,
										})

										_G.PushNotification("Yellow", "You are currently being viewed by "..PlayerName, true, true)
										ListenToUnview[PlayerName] = true

										if _G.ViewAction and _G.SelectedViewAction then

											if _G.SelectedViewAction == "Kill" then
												EnviromentRemote:FireServer(math.random(100,200))
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

												HumanoidRootPart.Velocity = Vector3.new(1e3, 1e3, 1e4)
											end

										end

										CustomConnections.OnLocalPlayerViewed:Fire({
											PlayerName = PlayerName
										})
									end
								elseif Said == ":to" then
									if player ~= LocalPlayer then
										_G.PushNotification("Yellow", PlayerName .. " Teleported to: " .. player.Name)
									elseif player == LocalPlayer then
										_G.PushNotification("Yellow", PlayerName .. " Teleported to you")
									end

									if FakeCallsListenTO[PlayerName] then
										FakeCallsListenTO[PlayerName] = nil
									end

									CustomConnections.OnCMDUsed:Fire({
										Command = Said,
										UsedOn = PlayerName
									})
								elseif Said == ":bring" then
									if player ~= LocalPlayer then
										_G.PushNotification("Yellow", PlayerName .. " Brought: " .. player.Name)
									elseif player == LocalPlayer then
										_G.PushNotification("Yellow", PlayerName .. " Brought U to them")
									end

									CustomConnections.OnCMDUsed:Fire({
										Command = Said,
										UsedOn = PlayerName
									})
								elseif Said == ":kill" then
									if player ~= LocalPlayer then
										_G.PushNotification("Yellow", PlayerName .. " Killed: " .. player.Name)
									elseif player == LocalPlayer then
										_G.PushNotification("Yellow", PlayerName .. " Killed u")
									end

									CustomConnections.OnCMDUsed:Fire({
										Command = Said,
										UsedOn = PlayerName
									})
								elseif Said == ":heal" then
									if player ~= LocalPlayer then
										_G.PushNotification("Yellow", PlayerName .. " Healed: " .. player.Name)
									elseif player == LocalPlayer then
										_G.PushNotification("Yellow", PlayerName .. " Healed u")
									end

									CustomConnections.OnCMDUsed:Fire({
										Command = Said,
										UsedOn = PlayerName
									})
								elseif Said == ":kick" then
									_G.PushNotification("Yellow", PlayerName .. " Kicked: " .. player.Name)

									CustomConnections.OnCMDUsed:Fire({
										Command = Said,
										UsedOn = PlayerName
									})
								elseif Said == ":ban" then
									_G.PushNotification("Yellow", PlayerName .. " Banned: " .. player.Name)

									CustomConnections.OnCMDUsed:Fire({
										Command = Said,
										UsedOn = PlayerName
									})
								elseif Said == ":logs" then
									_G.PushNotification("Yellow", PlayerName .. " Is viewing logs")

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

			if Message == "!mod" or Message == "!help" then
				if _G.AdminLogs then
					_G.PushNotification("Red", PlayerName .. " Called !mod")
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
						PlayerName.." has requested\nassistance! Click to go assist them!",
						true,
						true, -- Pinned
						{
							name = "ModHelpTeleport",
							data = {
								PlayerName = PlayerName,
								DORBLX_IS_HOT = true -- :D
							}
						}
					)

					task.spawn(function()
						while FakeCallsListenTO[PlayerName] do
							task.wait()
						end

						_G.PushNotification(
							"Yellow",
							PlayerName.." has requested\nassistance! Click to go assist them!",
							true,
							false -- Pinned
						)
					end)
				end

				return
			end

			if _G.ChatSpy then
				_G.PushNotification("White", PlayerName .. " Said: " .. Message)
			end
		end
	end))
