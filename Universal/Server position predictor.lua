-------------------------------------------------------------------------------------------------------------------------------

-- made by X_ORA
if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local stats = game:GetService("Stats")

local networkstats = stats:FindFirstChild("Network", false) or stats:WaitForChild("Network", 60)
local serverstatsitem = networkstats:FindFirstChild("ServerStatsItem", false) or networkstats:WaitForChild("ServerStatsItem", 60)
local dataping = serverstatsitem:FindFirstChild("Data Ping", false) or serverstatsitem:WaitForChild("Data Ping", 60)

local localplayer = players["LocalPlayer"]
local localcharacter = localplayer["Character"] or localplayer["CharacterAdded"]:Wait()
local localhumanoid = localcharacter:FindFirstChildWhichIsA("Humanoid", false) or localcharacter:WaitForChild("Humanoid", 60)
local localrootpart = localhumanoid and (localhumanoid["RootPart"] or localcharacter:WaitForChild("HumanoidRootPart", 60))

-------------------------------------------------------------------------------------------------------------------------------

local localcharacterclone = nil
local pingdivisionfactor = 500 -- 500 for the server and 1000 for the client
local connections = {}
local posehistory = {}

local function createcharacterclone()
	if localcharacterclone then
		localcharacterclone:Destroy()
	end

	task.wait(1)

	localcharacter["Archivable"] = true
	localcharacterclone = localcharacter:Clone()
	localcharacterclone["Name"] = `{localcharacter["Name"]} Clone`
	localcharacterclone["Parent"] = localcharacter["Parent"]
	localcharacter["Archivable"] = false

	for _, descendant in localcharacterclone:GetDescendants() do
		if descendant:IsA("Motor6D") then
			descendant["Enabled"] = false
		end
	end

	for _, descendant in localcharacterclone:GetDescendants() do
		if descendant:IsA("BillboardGui") then
			descendant:Destroy()
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local function recordpose(deltatime)
	if not localcharacter or not localrootpart then return end
	local currenttime = tick()
	local bodypartscframes = {}

	for _, descendant in localcharacter:GetDescendants() do
		if not descendant:IsA("BasePart") or descendant == localrootpart then continue end
		bodypartscframes[descendant["Name"]] = localrootpart["CFrame"]:ToObjectSpace(descendant["CFrame"])
	end

	table.insert(posehistory, {
		time = currenttime,
		pivot = localcharacter:GetPivot(),
		bodypartscframes = bodypartscframes
	})

	while #posehistory > 0 and (currenttime - posehistory[1]["time"]) > (1 / deltatime) do
		table.remove(posehistory, 1)
	end
end

local function updateclonepose()
	if not (localcharacterclone and localcharacter) then return end

	local currenttime = tick()
	local pingdelay = math.clamp(dataping:GetValue() / pingdivisionfactor, 0, math.huge)
	local targettime = currenttime - pingdelay
	local targetpose = nil

	for index = #posehistory, 1, -1 do
		if posehistory[index]["time"] <= targettime then
			targetpose = posehistory[index]
			break
		end
	end

	if targetpose then
		localcharacterclone:PivotTo(targetpose["pivot"])

		for _, child in localcharacterclone:GetChildren() do
			if not child:IsA("BasePart") or child == localcharacterclone["Humanoid"]["RootPart"] then continue end
			local relativecframe = targetpose["bodypartscframes"][child["Name"]]
			if not relativecframe then continue end
			child["CFrame"] = localcharacterclone["Humanoid"]["RootPart"]["CFrame"] * relativecframe
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

runservice:BindToRenderStep("Server Position Predictor", 1, function(deltatime)
	recordpose(deltatime)
	updateclonepose()

	if localcharacterclone then
		localcharacterclone["Humanoid"]["DisplayDistanceType"] = "None"
		localcharacterclone["Humanoid"]["PlatformStand"] = true

		for _, animation in localcharacterclone["Humanoid"]:GetPlayingAnimationTracks() do
			animation:Stop()
		end

		for _, descendant in localcharacterclone:GetDescendants() do
			if descendant:IsA("BasePart") then
				descendant["CanCollide"] = false
				descendant["CanTouch"] = false
				descendant["CanQuery"] = false
				descendant["Anchored"] = false
				if descendant["Transparency"] ~= 1 then descendant["Transparency"] = 0.5 end
			elseif descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ForceField") then
				descendant:Destroy()
			end
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

localplayer["CharacterAdded"]:Connect(function(character)
	localcharacter = character
	localhumanoid = localcharacter:FindFirstChildWhichIsA("Humanoid", false) or localcharacter:WaitForChild("Humanoid", 60)
	localrootpart = localhumanoid["RootPart"] or localcharacter:WaitForChild("HumanoidRootPart", 60)
	createcharacterclone()
end)

localplayer["CharacterRemoving"]:Connect(function()
	localcharacter = nil
	localhumanoid = nil
	localrootpart = nil
	if localcharacterclone then
		localcharacterclone:Destroy()
		localcharacterclone = nil
	end
	posehistory = {}
end)

-------------------------------------------------------------------------------------------------------------------------------

createcharacterclone()

-------------------------------------------------------------------------------------------------------------------------------
