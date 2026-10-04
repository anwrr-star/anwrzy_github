local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local STEAL_DISTANCE = 10
local REWARD = 100
local COOLDOWN = 3

local cooldowns = {}

local function getEggs()
	local folder = workspace:FindFirstChild("Eggs")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "Eggs"
		folder.Parent = workspace
	end
	return folder
end

local function stealEgg(player, egg)
	if cooldowns[player] then
		return
	end

	if not egg or not egg.Parent then
		return
	end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	if (root.Position - egg.Position).Magnitude > STEAL_DISTANCE then
		return
	end

	cooldowns[player] = true

	local stats = player:FindFirstChild("leaderstats")
	local money = stats and stats:FindFirstChild("Money")

	if money then
		money.Value += REWARD
	end

	egg:Destroy()

	task.delay(COOLDOWN, function()
		cooldowns[player] = nil
	end)
end

RunService.Heartbeat:Connect(function()
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if root then
			for _, egg in ipairs(getEggs():GetChildren()) do
				if egg:IsA("BasePart") then
					local distance = (root.Position - egg.Position).Magnitude

					if distance <= STEAL_DISTANCE then
						stealEgg(player, egg)
						break
					end
				end
			end
		end
	end
end)
