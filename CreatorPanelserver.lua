local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EVENT_NAME = "CreatorPanelEvent"

local event = ReplicatedStorage:FindFirstChild(EVENT_NAME)
if not event then
	event = Instance.new("RemoteEvent")
	event.Name = EVENT_NAME
	event.Parent = ReplicatedStorage
end

-- GANTI dengan UserId Roblox kamu
local CREATOR_USER_ID = 123456789

local function isCreator(player)
	return player.UserId == CREATOR_USER_ID
end

local function getMoney(player)
	local stats = player:FindFirstChild("leaderstats")
	return stats and stats:FindFirstChild("Money")
end

local function spawnEgg()
	local folder = workspace:FindFirstChild("Eggs")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "Eggs"
		folder.Parent = workspace
	end

	local egg = Instance.new("Part")
	egg.Name = "Egg"
	egg.Shape = Enum.PartType.Ball
	egg.Size = Vector3.new(3, 3, 3)
	egg.Anchored = true
	egg.Position = Vector3.new(
		math.random(-30, 30),
		3,
		math.random(-30, 30)
	)
	egg.Parent = folder
end

event.OnServerEvent:Connect(function(player, action, targetName, amount)
	if not isCreator(player) then
		return
	end

	if action == "SpawnEgg" then
		spawnEgg()

	elseif action == "RespawnEggs" then
		local folder = workspace:FindFirstChild("Eggs")

		if folder then
			folder:ClearAllChildren()
		end

		for i = 1, 5 do
			spawnEgg()
		end

	elseif action == "GiveMoney" then
		local target = Players:FindFirstChild(targetName)

		if target then
			local money = getMoney(target)

			if money then
				money.Value += tonumber(amount) or 1000
			end
		end

	elseif action == "Kick" then
		local target = Players:FindFirstChild(targetName)

		if target and target ~= player then
			target:Kick("Kicked by Creator")
		end

	elseif action == "Broadcast" then
		if typeof(targetName) == "string" then
			event:FireAllClients("Broadcast", targetName)
		end
	end
end)
