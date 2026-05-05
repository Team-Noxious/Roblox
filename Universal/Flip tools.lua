-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local plr = game["Players"]["LocalPlayer"]

function performflip(character, flipdirection)
	local hum = character:WaitForChild("Humanoid")
	local rootpart = character:WaitForChild("HumanoidRootPart")

	hum:ChangeState(Enum.HumanoidStateType.Jumping)
	hum["Sit"] = true

	local lookvector = rootpart["CFrame"]["LookVector"]
	local spindirection = Vector3.new(-lookvector["Z"], 0, lookvector["X"])

	local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	if torso then
		local bodyvelocity = Instance.new("BodyAngularVelocity", torso)
		bodyvelocity["MaxTorque"] = Vector3.new(math.huge, math.huge, math.huge)
		bodyvelocity["AngularVelocity"] = spindirection * (flipdirection * 10)
		bodyvelocity["P"] = 1000

		wait(0.4)
		bodyvelocity:Destroy()
	end

	wait(0.2)
	hum["Sit"] = false
end

-------------------------------------------------------------------------------------------------------------------------------

function ontoolactivated(tool)
	local char = plr["Character"]
	if char then
		if tool["Name"] == "frontflip" then
			performflip(char, -1)
		elseif tool["Name"] == "backflip" then
			performflip(char, 1)
		end
	end
end

function connecttoolevents(tool)
	if tool:IsA("Tool") then
		tool["RequiresHandle"] = false
		tool["Activated"]:Connect(function()
			ontoolactivated(tool)
		end)
	end
end

function givetools()
	local backpack = plr:FindFirstChild("Backpack")
	if not backpack then return end

	if not backpack:FindFirstChild("FrontFlipTool") then
		local frontfliptool = Instance.new("Tool")
		frontfliptool["Name"] = "frontflip"
		frontfliptool["RequiresHandle"] = false
		frontfliptool["Parent"] = backpack
		connecttoolevents(frontfliptool)
	end

	if not backpack:FindFirstChild("BackFlipTool") then
		local backfliptool = Instance.new("Tool")
		backfliptool["Name"] = "backflip"
		backfliptool["RequiresHandle"] = false
		backfliptool["Parent"] = backpack
		connecttoolevents(backfliptool)
	end
end

function initializecharacter(char)
	char:WaitForChild("Humanoid")
	char:WaitForChild("HumanoidRootPart")

	givetools()

	local backpack = plr:WaitForChild("Backpack")
	for _, tool in pairs(backpack:GetChildren()) do
		connecttoolevents(tool)
	end

	backpack["ChildAdded"]:Connect(function(tool)
		connecttoolevents(tool)
	end)
end

plr["CharacterAdded"]:Connect(function(char) initializecharacter(char) end)
if plr["Character"] then initializecharacter(plr["Character"]) end

-------------------------------------------------------------------------------------------------------------------------------

game["StarterGui"]:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)

-------------------------------------------------------------------------------------------------------------------------------
