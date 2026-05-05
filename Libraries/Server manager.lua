-------------------------------------------------------------------------------------------------------------------------------

local plrs = game:GetService("Players")
local https = game:GetService("HttpService")
local tps = game:GetService("TeleportService")

local plr = plrs.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local req = (syn and syn.request) or (http and http.request) or request
local queuetp = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

-------------------------------------------------------------------------------------------------------------------------------

local serverhandler = {}

-------------------------------------------------------------------------------------------------------------------------------

function serverhandler:rejoin()
	if #plrs:GetPlayers() <= 1 then
		tps:Teleport(game.PlaceId, plr)
	else
		tps:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
	end
end

-------------------------------------------------------------------------------------------------------------------------------

function serverhandler:serverhop()
	if req then
		local servers = {}
		local request = req({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)})
		local body = https:JSONDecode(request.Body)

		if body and body.data then
			for i, v in next, body.data do
				if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
					table.insert(servers, 1, v.id)
				end
			end
		end

		if #servers > 0 then
			tps:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], plr)
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

function serverhandler:savecurrentspot()
	local data = {
		position = {root.Position.X, root.Position.Y, root.Position.Z},
		orientation = {root.Orientation.X, root.Orientation.Y, root.Orientation.Z}
	}

	local json = https:JSONEncode(data)
	writefile("tospot", json)
end

serverhandler.teleportbackscript = [[
local httpservice = game:GetService("HttpService") 
local teleportservice = game:GetService("TeleportService") 
local players = game:GetService("Players") 
local localplayer = players["LocalPlayer"] 

local function loadandteleport() 
	if not isfile("tospot") then return end 
	
	local json = readfile("tospot") 
	local data = httpservice:JSONDecode(json) 
	
	if not data or not data.position or not data.orientation then return end 
	
	local function teleportcharacter() 
		local char = localplayer["Character"] or localplayer["CharacterAdded"]:Wait() 
		local hrp = char:WaitForChild("HumanoidRootPart") 
		
		hrp["CFrame"] = CFrame.new(data.position[1], data.position[2], data.position[3]) * CFrame.Angles(math.rad(data.orientation[1]), math.rad(data.orientation[2]), math.rad(data.orientation[3])) 
		
		if isfile("tospot") then 
			delfile("tospot") 
		end 
	end 
	
	local function waitfornamescript(timeout) 
		local late = true
		local starttime = os.clock() 
		
		task.delay(10, function() late = false end) 
		
		while late do 
			local char = localplayer["Character"] 
			
			if char and char:FindFirstChild("NameScript") then return true end 
			
			if timeout and os.clock() - starttime > timeout then return false end 
			
			task.wait(0.2) 
		end 
	end 
	
	if localplayer["Character"] and localplayer["Character"]:FindFirstChild("HumanoidRootPart") then 
		local hasscript = waitfornamescript(30) 
		
		teleportcharacter() 
	else 
		localplayer["CharacterAdded"]:Connect(function() 
			local hasscript = waitfornamescript(30) 
			
			teleportcharacter() 
		end) 
	end 
end 

loadandteleport()
]]

function serverhandler:rejointeleport()
	serverhandler:savecurrentspot()
	queuetp(serverhandler.teleportbackscript)
	
	serverhandler:rejoin()
end

-------------------------------------------------------------------------------------------------------------------------------

return serverhandler

-------------------------------------------------------------------------------------------------------------------------------
