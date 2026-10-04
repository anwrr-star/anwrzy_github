local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local event = ReplicatedStorage:WaitForChild("CreatorPanelEvent")

local CREATOR_USER_ID = 123456789

if player.UserId ~= CREATOR_USER_ID then
	script.Parent.Enabled = false
	return
end

local gui = script.Parent
local frame = gui:WaitForChild("MainFrame")

frame.SpawnEgg.MouseButton1Click:Connect(function()
	event:FireServer("SpawnEgg")
end)

frame.RespawnEggs.MouseButton1Click:Connect(function()
	event:FireServer("RespawnEggs")
end)

frame.GiveMoney.MouseButton1Click:Connect(function()
	local target = frame.PlayerName.Text
	local amount = tonumber(frame.Amount.Text) or 1000

	event:FireServer("GiveMoney", target, amount)
end)

frame.Kick.MouseButton1Click:Connect(function()
	event:FireServer("Kick", frame.PlayerName.Text)
end)

frame.Broadcast.MouseButton1Click:Connect(function()
	event:FireServer("Broadcast", frame.Message.Text)
end)

frame.Close.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

event.OnClientEvent:Connect(function(action, message)
	if action == "Broadcast" then
		print("[CREATOR] " .. message)
	end
end)
