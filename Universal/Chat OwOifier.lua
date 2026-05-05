-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local function owoify(text)
	local substitutions = {
		["r"] = "w",
		["l"] = "w",
		["R"] = "W",
		["L"] = "W",
		["no"] = "nyo",
		["No"] = "Nyo",
		["mo"] = "myo",
		["na"] = "nya",
		["ove"] = "uv",
		["th"] = "d",
	}

	for pattern, replacement in pairs(substitutions) do
		text = text:gsub(pattern, replacement)
	end

	local suffixes = { " owo", " UwU", " >w<", " ^w^", " rawr~", " nya~" }
	if math.random() < 0.5 then
		text = text .. suffixes[math.random(1, #suffixes)]
	end

	return text
end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local textchatservice = game:GetService("TextChatService")
local replicatedstorage = game:GetService("ReplicatedStorage")

local localplayer = players["LocalPlayer"]
local coregui = game:GetService("CoreGui")

-------------------------------------------------------------------------------------------------------------------------------

local function gettargetname(targetchip)
	if targetchip and targetchip:IsA("TextButton") then
		local displayname = string.match(targetchip["Text"] or "", "^%[To%s+(.-)%]$")
		if displayname and displayname ~= "" then
			for _, plr in ipairs(players:GetPlayers()) do
				if plr["DisplayName"]:lower() == displayname:lower() then
					return plr["Name"]
				end
			end
		end
	end
	return "All"
end

-------------------------------------------------------------------------------------------------------------------------------

local function sendmessage(message, recipient)
	local owoified = owoify(message)
	local channel = nil

	if recipient and recipient ~= "All" then
		for _, ch in pairs(textchatservice["TextChannels"]:GetChildren()) do
			if ch["Name"]:find("RBXWhisper:") and ch:FindFirstChild(recipient) then
				channel = ch
				break
			end
		end
	end

	if not channel then
		channel = textchatservice["TextChannels"]:FindFirstChild("RBXGeneral")
			or textchatservice["TextChannels"]:FindFirstChild("General")
	end

	if channel then
		channel:SendAsync(owoified)
	else
		local ev = replicatedstorage:FindFirstChild("DefaultChatSystemChatEvents")
		if ev then
			local say = ev:FindFirstChild("SayMessageRequest")
			if say then
				say:FireServer(owoified, "All")
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

task.spawn(function()
	repeat task.wait() until coregui:FindFirstChild("ExperienceChat")

	local experiencechat = coregui:WaitForChild("ExperienceChat")
	local chatinputbar = experiencechat:WaitForChild("appLayout"):WaitForChild("chatInputBar")
	local background = chatinputbar:WaitForChild("Background")
	local container = background:WaitForChild("Container")
	local textcontainer = container:WaitForChild("TextContainer")
	local textboxcontainer = textcontainer:WaitForChild("TextBoxContainer")
	local chatbox = textboxcontainer:WaitForChild("TextBox")
	local targetchip = textcontainer:FindFirstChild("TargetChannelChip")

	if chatbox then
		chatbox["FocusLost"]:Connect(function(enterpressed)
			if enterpressed and chatbox["Text"] ~= "" then
				local msg = chatbox["Text"]
				local recipient = gettargetname(targetchip)
				chatbox["Text"] = ""
				task.defer(function()
					sendmessage(msg, recipient)
				end)
			end
		end)
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
