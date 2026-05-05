-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

task.spawn(function()
	local rs = game:GetService("RunService")
	local hb = rs["Heartbeat"]
	local rsd = rs["RenderStepped"]
	local lp = game["Players"]["LocalPlayer"]
	local zero = Vector3.zero
	local function antiflingchar(char)
		local root = char:WaitForChild("HumanoidRootPart")
		if root then
			local con
			con = hb:Connect(function()
				if not root["Parent"] then
					con:Disconnect()
				end
				local vel = root["AssemblyLinearVelocity"]
				root["AssemblyLinearVelocity"] = zero
				rsd:Wait()
				root["AssemblyLinearVelocity"] = vel
			end)
		end
	end
	antiflingchar(lp["Character"])
	lp["CharacterAdded"]:Connect(antiflingchar)
end)

-------------------------------------------------------------------------------------------------------------------------------

local collider = nil

function setcollision(state)
	local chr = game["Players"]["LocalPlayer"]["Character"]
	if not chr then return end

	for _, part in pairs(chr:GetDescendants()) do
		if part:IsA("BasePart") then
			part["CanCollide"] = state
		end
	end
end

function disablecollision()
	if collider then return end
	collider = game:GetService("RunService")["Stepped"]:Connect(function()
		setcollision(false)
	end)
end

function restorecollision()
	if collider then
		collider:Disconnect()
		collider = nil
	end
	setcollision(true)
end

-------------------------------------------------------------------------------------------------------------------------------

local antiflingconn = nil

function enableantifling()
	if antiflingconn then
		antiflingconn:Disconnect()
		antiflingconn = nil
	end
	antiflingconn = game:GetService("RunService")["Stepped"]:Connect(function()
		for _, plr in pairs(game["Players"]:GetPlayers()) do
			if plr ~= game["Players"]["LocalPlayer"] and plr["Character"] then
				for _, part in pairs(plr["Character"]:GetDescendants()) do
					if part:IsA("BasePart") then
						part["CanCollide"] = false
					end
				end
			end
		end
	end)
end

function disableantifling()
	if antiflingconn then
		antiflingconn:Disconnect()
		antiflingconn = nil
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local walkflingenabled = false

function enablewalkfling()
	walkflingenabled = true
	local hum = game["Players"]["LocalPlayer"]["Character"]:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum["Died"]:Connect(function()
			walkflingenabled = false
		end)
	end

	local function getroot(char)
		return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	end

	repeat 
		game:GetService("RunService")["Heartbeat"]:Wait()
		local char = game["Players"]["LocalPlayer"]["Character"]
		local root = getroot(char)
		local vel, movel = nil, 0.1

		while not (char and char["Parent"] and root and root["Parent"]) do
			game:GetService("RunService")["Heartbeat"]:Wait()
			char = game["Players"]["LocalPlayer"]["Character"]
			root = getroot(char)
		end

		vel = root["Velocity"]
		root["Velocity"] = vel * 10000 + Vector3.new(0, 10000, 0)

		game:GetService("RunService")["RenderStepped"]:Wait()
		if char and char["Parent"] and root and root["Parent"] then
			root["Velocity"] = vel
		end

		game:GetService("RunService")["Stepped"]:Wait()
		if char and char["Parent"] and root and root["Parent"] then
			root["Velocity"] = vel + Vector3.new(0, movel, 0)
			movel = movel * -1
		end
	until not walkflingenabled
end

function disablewalkfling()
	walkflingenabled = false
end

-------------------------------------------------------------------------------------------------------------------------------

local lastposition = nil
local loopflingenabled = false

function performfling(targets)
	local players = game:GetService("Players")
	local localplayer = players["LocalPlayer"]
	local alltargets = false

	local function gettarget(name)
		name = name:lower()
		if name == "all" or name == "others" then
			alltargets = true
			return
		elseif name == "random" then
			local validplayers = players:GetPlayers()
			if table.find(validplayers, localplayer) then 
				table.remove(validplayers, table.find(validplayers, localplayer)) 
			end
			return validplayers[math.random(#validplayers)]
		elseif name ~= "random" and name ~= "all" and name ~= "others" then
			for _, plr in next, players:GetPlayers() do
				if plr ~= localplayer then
					if plr["Name"]:lower():match("^"..name) then
						return plr
					elseif plr["DisplayName"]:lower():match("^"..name) then
						return plr
					end
				end
			end
		end
	end

	local function flingtarget(targetplayer)
		task.wait(0.1)
		local char = localplayer["Character"]
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local root = hum and hum["RootPart"]

		local tchar = targetplayer["Character"]
		local thum = tchar and tchar:FindFirstChildOfClass("Humanoid")
		local troot = thum and thum["RootPart"]
		local thead = tchar and tchar:FindFirstChild("Head")
		local accessory = tchar and tchar:FindFirstChildOfClass("Accessory")
		local handle = accessory and accessory:FindFirstChild("Handle")

		if not (char and hum and root) then return end

		if root["Velocity"]["Magnitude"] < 50 then
			lastposition = root["CFrame"]
		end

		if thum and thum["Sit"] and not alltargets then return end

		if thead then
			workspace["CurrentCamera"]["CameraSubject"] = thead
		elseif handle then
			workspace["CurrentCamera"]["CameraSubject"] = handle
		elseif thum then
			workspace["CurrentCamera"]["CameraSubject"] = thum
		end

		if not (tchar and tchar:FindFirstChildWhichIsA("BasePart")) then return end

		local function setflingpos(basepart, pos, ang)
			root["CFrame"] = CFrame.new(basepart["Position"]) * pos * ang
			char:SetPrimaryPartCFrame(CFrame.new(basepart["Position"]) * pos * ang)
			root["Velocity"] = Vector3.new(9e7, 9e7 * 10, 9e7)
			root["RotVelocity"] = Vector3.new(9e8, 9e8, 9e8)
		end

		local function flingbasepart(basepart)
			local timeout = 2
			local starttime = tick()
			local angle = 0

			repeat
				if not (root and thum) then break end
				if basepart["Velocity"]["Magnitude"] < 50 then
					angle = angle + 100

					setflingpos(basepart, CFrame.new(0, 1.5, 0) + thum["MoveDirection"] * basepart["Velocity"]["Magnitude"] / 1.25, CFrame.Angles(math.rad(angle),0 ,0))
					task.wait()

					setflingpos(basepart, CFrame.new(0, -1.5, 0) + thum["MoveDirection"] * basepart["Velocity"]["Magnitude"] / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(2.25, 1.5, -2.25) + thum["MoveDirection"] * basepart["Velocity"]["Magnitude"] / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(-2.25, -1.5, 2.25) + thum["MoveDirection"] * basepart["Velocity"]["Magnitude"] / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(0, 1.5, 0) + thum["MoveDirection"], CFrame.Angles(math.rad(angle), 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(0, -1.5, 0) + thum["MoveDirection"], CFrame.Angles(math.rad(angle), 0, 0))
					task.wait()
				else
					setflingpos(basepart, CFrame.new(0, 1.5, thum["WalkSpeed"]), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(0, -1.5, -thum["WalkSpeed"]), CFrame.Angles(0, 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(0, 1.5, thum["WalkSpeed"]), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(0, 1.5, troot["Velocity"]["Magnitude"] / 1.25), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(0, -1.5, -troot["Velocity"]["Magnitude"] / 1.25), CFrame.Angles(0, 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(0, 1.5, troot["Velocity"]["Magnitude"] / 1.25), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
					task.wait()

					setflingpos(basepart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
					task.wait()
				end
			until basepart["Velocity"]["Magnitude"] > 500 or basepart["Parent"] ~= tchar or targetplayer["Parent"] ~= players or targetplayer["Character"] ~= tchar or (thum and thum["Sit"]) or hum["Health"] <= 0 or tick() > starttime + timeout
		end

		workspace["FallenPartsDestroyHeight"] = 0 / 0

		local bv = Instance.new("BodyVelocity")
		bv["Name"] = "EpixVel"
		bv["Parent"] = root
		bv["Velocity"] = Vector3.new(9e8, 9e8, 9e8)
		bv["MaxForce"] = Vector3.new(math.huge, math.huge, math.huge)

		hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

		if troot and thead then
			flingbasepart((troot["CFrame"].p - thead["CFrame"].p)["Magnitude"] > 5 and thead or troot)
		elseif troot then
			flingbasepart(troot)
		elseif thead then
			flingbasepart(thead)
		elseif handle then
			flingbasepart(handle)
		end

		bv:Destroy()
		hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		workspace["CurrentCamera"]["CameraSubject"] = hum

		if lastposition then
			root["CFrame"] = lastposition * CFrame.new(0, .5, 0)
			char:SetPrimaryPartCFrame(lastposition * CFrame.new(0, .5, 0))
			hum:ChangeState("GettingUp")
		end

		workspace["FallenPartsDestroyHeight"] = -500
	end

	if not targets[1] then return end
	for _, name in next, targets do gettarget(name) end

	if alltargets then
		for _, plr in next, players:GetPlayers() do
			if plr ~= localplayer then
				flingtarget(plr)
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

function safefling()
	performfling({"All"})
end

-------------------------------------------------------------------------------------------------------------------------------

local activeconnections = {}
local isflinging = false
local cooldown = 0.1

function cleancollections()
	for _, conn in pairs(activeconnections) do
		conn:Disconnect()
	end
	activeconnections = {}
end

function runflingloop(char)
	if not loopflingenabled then return end

	local hum = char:WaitForChild("Humanoid", 5)
	if not hum then return end

	activeconnections["death"] = hum["Died"]:Connect(function()
		if loopflingenabled then 
			task.wait(0) 
			stoploopfling() 
			task.wait(0) 
			startloopfling() 
		end
	end)

	while loopflingenabled and hum and hum["Health"] > 0 do
		if not isflinging then
			isflinging = true
			local success
			if game["PlaceId"] == 189707 then 
				success = pcall(safefling) 
			else 
				success = pcall(performfling, {"All"}) 
			end
			isflinging = false

			if not success then
			end
		end
		task.wait(cooldown)
	end
end

function startloopfling()
	if loopflingenabled then return end

	local players = game:GetService("Players")
	local localplayer = players["LocalPlayer"]

	cleancollections()
	loopflingenabled = true

	activeconnections["charadded"] = localplayer["CharacterAdded"]:Connect(function(char)
		if not loopflingenabled then return end

		while isflinging do
			task.wait(0.1)
		end

		runflingloop(char)
	end)

	if localplayer["Character"] then
		runflingloop(localplayer["Character"])
	end
end

function stoploopfling()
	loopflingenabled = false
	cleancollections()
end

-------------------------------------------------------------------------------------------------------------------------------

function createlooptool(name, state)
	local function createtool()
		local backpack = game["Players"]["LocalPlayer"]:WaitForChild("Backpack")

		local existing = backpack:FindFirstChild(name)
		if existing then
			existing:Destroy()
		end

		local tool = Instance.new("Tool")
		tool["Name"] = name
		tool["RequiresHandle"] = false
		tool["CanBeDropped"] = false
		tool["Parent"] = backpack

		tool["Equipped"]:Connect(function()
			task.spawn(function()
				if state then
					if not loopflingenabled then
						task.spawn(startloopfling)
						task.spawn(disablecollision)
						task.spawn(enableantifling)
						if game["PlaceId"] ~= 189707 then task.spawn(enablewalkfling) end
					end
				else
					if loopflingenabled then
						task.spawn(stoploopfling)
						task.spawn(restorecollision)
						task.spawn(disableantifling)
						if game["PlaceId"] ~= 189707 then task.spawn(disablewalkfling) end
					end
				end
			end)
		end)
	end

	createtool()

	game["Players"]["LocalPlayer"]["CharacterAdded"]:Connect(function(char)
		task.wait()
		createtool()
	end)
end

function createflingtool()
	local function createtool()
		local backpack = game["Players"]["LocalPlayer"]:WaitForChild("Backpack")

		local existing = backpack:FindFirstChild("fling all")
		if existing then
			existing:Destroy()
		end

		local tool = Instance.new("Tool")
		tool["Name"] = "fling all"
		tool["RequiresHandle"] = false
		tool["CanBeDropped"] = false
		tool["Parent"] = backpack

		tool["Equipped"]:Connect(function()
			task.spawn(function()
				if game["PlaceId"] == 189707 then 
					task.spawn(safefling) 
				else 
					task.spawn(performfling, {"All"}) 
				end
			end)
		end)
	end

	createtool()

	game["Players"]["LocalPlayer"]["CharacterAdded"]:Connect(function(char)
		task.wait()
		createtool()
	end)
end

-------------------------------------------------------------------------------------------------------------------------------

createlooptool("stop loopfling", false) createlooptool("start loopfling", true) createflingtool()

-------------------------------------------------------------------------------------------------------------------------------
