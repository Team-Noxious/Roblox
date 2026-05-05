-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local textchatservice = game:GetService("TextChatService")
local replicatedstorage = game:GetService("ReplicatedStorage")

local localplayer = players["LocalPlayer"]
local coregui = game:GetService("CoreGui")

-------------------------------------------------------------------------------------------------------------------------------

local function reversestring(str) return string.reverse(str) end

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

local function sendreversedmessage(message, recipient)
	local reversed = reversestring(message)
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
		channel:SendAsync(reversed)
	else
		local ev = replicatedstorage:FindFirstChild("DefaultChatSystemChatEvents")
		if ev then
			local say = ev:FindFirstChild("SayMessageRequest")
			if say then
				say:FireServer(reversed, "All")
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
					sendreversedmessage(msg, recipient)
				end)
			end
		end)
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
