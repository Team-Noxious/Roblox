-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local plrs = game:GetService("Players")
local vim = game:GetService("VirtualInputManager")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local sgui = game:GetService("StarterGui")

local plr = plrs.LocalPlayer
local cam = workspace.CurrentCamera

local t, spwn, cncl = task.wait, task.spawn, task.cancel
local mobile = uis.TouchEnabled
local studio = game:GetService("RunService"):IsStudio()

local rand = math.random
local firesignal = (syn and syn.firesignal) or firesignal
local targetui = (studio and plr.PlayerGui) or gethui() or game:GetService("CoreGui")

-------------------------------------------------------------------------------------------------------------------------------

local exists = targetui:FindFirstChild("word bomb")
if exists then exists:Destroy() end 

local gui = Instance.new("ScreenGui")
gui.Name = "word bomb"
gui.ResetOnSpawn = false
gui.Parent = targetui

-------------------------------------------------------------------------------------------------------------------------------

local function press(keyorbutton)
	if mobile then
		firesignal(keyorbutton.MouseButton1Down) t()
		firesignal(keyorbutton.MouseButton1Up)
	else
		local keycode = Enum.KeyCode[keyorbutton:upper()]
		if not keycode then return end
		vim:SendKeyEvent(true, keycode, false, game) t()
		vim:SendKeyEvent(false, keycode, false, game)
	end
end

local function randfloat(a, b)
	return a + rand() * (b - a)
end

local function randint(a, b)
	return rand(a, b)
end

local function fetchturn()
	for _, v in pairs(getgc()) do
		if type(v) == "function" and debug.getinfo(v).name == "updateInfoFrame" then
			for __, vv in ipairs(debug.getupvalues(v)) do
				if type(vv) == "table" and vv.PlayerID ~= nil then
					return vv.PlayerID
				end
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local typotable = {
	["Q"] = "WAS", ["W"] = "QASED", ["E"] = "WSRDF", ["R"] = "EDFTG", ["T"] = "RFGYH",
	["Y"] = "TGHUJ", ["U"] = "YHJKI", ["I"] = "UJKLO", ["O"] = "IKLP", ["P"] = "OL",
	["A"] = "QWSZX", ["S"] = "QWEDCXZA", ["D"] = "ERFCXSE", ["F"] = "RTGVCD", ["G"] = "TYHBVF",
	["H"] = "YUJNBG", ["J"] = "UIKMNHJ", ["K"] = "IOLMK", ["L"] = "KOP",
	["Z"] = "ASX", ["X"] = "ZSDC", ["C"] = "XDFV", ["V"] = "CFGB", ["B"] = "VGHN",
	["N"] = "BHJM", ["M"] = "NJK"
}

-------------------------------------------------------------------------------------------------------------------------------

local dictionary = {}
local usedwords = {}
local cancelled = false

local function getprompt()
	local ok, result = pcall(function()
		return plr.PlayerGui.GameUI.Container.GameSpace.DefaultUI.GameContainer.Mobile.MobileContainer.InfoFrame.TextFrame
	end)
	if ok and result then return result end
	return nil
end

local function getwordscore(word)
	local length = #tostring(word)
	local score = 0

	if length >= 12 and length <= 22 then score = score + 1000 end
	if word:find("PNEUMONOULTRAMICROSCOPIC") then score = score + 100 end
	if word:find("ANTIDISESTABLISHMENT") then score = score + 100 end
	if word:find("PSEUDOPSEUDO") then score = score + 100 end
	if word:find("COUNTERCOUNTER") then score = score + 100 end
	if word:find("-") then score = score + 100 end
	if word:find("BOX") then score = score + 100 end
	if word:find("X") then score = score + 100 end
	if word:find("V") then score = score + 100 end
	if word:find("HEXA") then score = score + 100 end
	if word:find("RU") then score = score + 100 end
	if length >= 23 then score = score + 50 end

	score = score + (length / 100)
	return score
end

spwn(function()
	local succ, content = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/lorenbrichter/Words/master/Words/en.txt") end)

	if succ then
		local words = {}

		for word in string.gmatch(content, "[^\r\n]+") do
			local up = word:upper()
			table.insert(words, { word = up, score = getwordscore(up) })
		end

		table.sort(words, function(a, b) return a.score > b.score end)

		for _, data in ipairs(words) do
			table.insert(dictionary, data.word)
		end
		
		local customdictionary = {
			["PSEUDOPSEUDOHYPOPARATHYROIDISM"] = true,
			["PNEUMONOULTRAMICROSCOPICSILICOVOLCANOCONIOSIS"] = true,
			["FLOCCINAUCINIHILIPILIFICATION"] = true,
			["PEBBLEDASHING"] = true,
			["DANDYISHLY"] = true,
			["DANDYLING"] = true,
			["SHELLYCOAT"] = true,
			["KNOCK-DOWN-AND-DRAG-OUT"] = true,
			["COUNTER-COUNTER-MEASURES"] = true,
			["JACKS-IN-THE-BOX"] = true,
		}
		
		for _, words in ipairs(customdictionary) do
			table.insert(dictionary, words)
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local function getletter(obj)
	if not obj then return nil end

	for _, v in ipairs(obj:GetDescendants()) do
		if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Text and v.Text ~= "" then
			return v.Text
		end
	end

	return nil
end

local function getletters()
	local letters = {}
	local prompt = getprompt()
	if not prompt then return letters end

	for _, slot in ipairs(prompt:GetChildren()) do
		if slot:IsA("Frame") or slot:IsA("ImageLabel") or slot:IsA("TextLabel") or slot:IsA("TextButton") then
			if slot.Visible ~= false then
				local letter = getletter(slot)
				if letter and letter ~= "" and #letter == 1 and letter:match("%a") then
					table.insert(letters, letter:upper())
				end
			end
		end
	end

	return letters
end

local function validateword(word, letters)
	local joined = table.concat(letters, ""):upper()
	return string.find(word:upper(), joined, 1, true) ~= nil
end

local function lookforword(letters)
	for _, word in ipairs(dictionary) do
		if not usedwords[word] and validateword(word, letters) then
			return word
		end
	end

	return nil
end

-------------------------------------------------------------------------------------------------------------------------------

local function presskey(char)
	if not mobile then
		local keyname = char:upper()
		if char == "-" then keyname = "Minus" end
		local keycode = Enum.KeyCode[keyname]
		if keycode then
			vim:SendKeyEvent(true, keycode, false, game) t()
			vim:SendKeyEvent(false, keycode, false, game)
		end
		
		return
	end

	local keyboard = plr.PlayerGui.MobileUI.PhoneContainer.BottomBoard.AlphaBoard.Letters
	local symbolboard = plr.PlayerGui.MobileUI.PhoneContainer.BottomBoard.SymbolBoard.Symbols1
	local key = keyboard:FindFirstChild(char:upper()) or symbolboard:FindFirstChild(char)

	if key then
		press(key)
	end
end

local function backspace()
	if not mobile then
		vim:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game) t()
		vim:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
		return
	end
	
	local backspacebtn = plr.PlayerGui.MobileUI.PhoneContainer.BottomBoard.StaticBoard.Backspace
	press(backspacebtn)
end

local function enter()
	if not mobile then
		vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game) t()
		vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
		return
	end
	
	local enterbtn = plr.PlayerGui.MobileUI.PhoneContainer.BottomBoard.StaticBoard.Enter
	press(enterbtn)
end

-------------------------------------------------------------------------------------------------------------------------------

local function getneighboringkey(char)
	local neighbors = typotable[char:upper()]

	if neighbors and #neighbors > 0 then
		local idx = rand(1, #neighbors)
		return neighbors:sub(idx, idx)
	end

	return "E"
end

local function bursttype(word)
	local i = 1
	local len = #tostring(word)
	while i <= len do
		if cancelled then return end

		local speedmultiplier = 1
		if i > len * 0.5 and rand() < 0.5 then
			local progress = (i - len * 0.5) / (len * 0.5)
			speedmultiplier = 1 - (progress * 0.45)
		end

		local burst = randint(3, 5)
		for _ = 1, burst do
			if i > len or cancelled then break end

			presskey(word:sub(i, i))
			t(randfloat(0.01, 0.03) * speedmultiplier)
			i = i + 1
		end

		if i <= len and not cancelled then
			t(randfloat(0.1, 0.18) * speedmultiplier)
		end
	end
end

local function regtype(word)
	local i = 1
	local len = #tostring(word)

	local speedup = rand() < 0.8
	local burst = rand() < 0.3

	while i <= len do
		if cancelled then return end

		local char = word:sub(i, i)

		local baseDelay = randfloat(0.03, 0.09)

		if burst and rand() < 0.7 then
			baseDelay = baseDelay * randfloat(0.5, 0.8)
		end

		local speedmultiplier = 1
		if speedup and i > len * 0.5 then
			local progress = (i - len * 0.5) / (len * 0.5)
			speedmultiplier = 1 - (progress * 0.4)
		end

		if rand() < 0.05 then
			t(randfloat(0.1, 0.25))
		end

		if char:match("%a") and rand() < 0.04 then
			local wrong = (rand() < 0.7) and getneighboringkey(char) or string.char(rand(97,122))
			presskey(wrong)
			t(randfloat(0.05, 0.12))

			local extra = 0
			if rand() < 0.4 and i < len then
				presskey(word:sub(i + 1, i + 1))
				t(randfloat(0.08, 0.18))
				extra = 1
			end

			t(randfloat(0.15, 0.35))

			for _ = 1, extra + 1 do
				backspace()
				t(randfloat(0.04, 0.09))
			end

			presskey(char)
			t(randfloat(0.03, 0.08) * speedmultiplier)

			i = i + 1
		else
			if rand() < 0.02 then
				presskey(char)
				t(randfloat(0.02, 0.05))
				backspace()
				t(randfloat(0.05, 0.1))
			end

			presskey(char)
			t(baseDelay * speedmultiplier)

			i = i + 1
		end
	end
end

local function humantype(word)
	local roll = rand()

	if roll < 0.15 then
		bursttype(word)
	else
		regtype(word)
	end
end

local function solve(typetype)
	cancelled = false

	local prompt = getprompt()
	if not prompt then return end

	local letters = getletters()
	if #letters == 0 then return end

	local word = lookforword(letters)
	if not word then return end

	usedwords[word] = true
	if typetype == "reg" then
		regtype(word)
	elseif typetype == "burst" then
		bursttype(word)
	else
		humantype(word)
	end

	if not cancelled then
		t()
		enter()
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local mainframe = Instance.new("Frame")
mainframe.Size = UDim2.new(0, 200, 0, 98)
mainframe.AnchorPoint = Vector2.new(0.5, 0.5)
mainframe.Position = UDim2.new(0.5, 0, -1, 0)
mainframe.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainframe.BackgroundTransparency = 1
mainframe.BorderSizePixel = 0
mainframe.Draggable = true
mainframe.Active = true
mainframe.Parent = gui

ts:Create(mainframe, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2 - 71)}):Play()

-------------------------------------------------------------------------------------------------------------------------------

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 1, -34)
container.Position = UDim2.new(0, 0, 0, 0)
container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
container.BackgroundTransparency = 0.6
container.BorderSizePixel = 0
container.Parent = mainframe

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, -18)
title.BackgroundTransparency = 1
title.Text = "SRS: word bomb"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = container

local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, 0, 1, 17)
desc.Text = "made by ksu"
desc.TextColor3 = Color3.fromRGB(255, 255, 255)
desc.TextSize = 14
desc.Font = Enum.Font.SourceSans
desc.BackgroundTransparency = 1
desc.BorderSizePixel = 0
desc.TextXAlignment = Enum.TextXAlignment.Center
desc.TextYAlignment = Enum.TextYAlignment.Center
desc.Parent = container

-------------------------------------------------------------------------------------------------------------------------------

local selected = Instance.new("UIStroke")
selected.Color = Color3.fromRGB(102, 141, 226)
selected.Thickness = 5
selected.BorderOffset = UDim.new(0, -5)
selected.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
selected.LineJoinMode = Enum.LineJoinMode.Miter

local typemode
local istyping = false

local function run(mode, button)
	if istyping then
		cancelled = true
		enter()
	end

	istyping = true
	typemode = mode

	selected.Parent = button

	solve(mode)

	istyping = false
	typemode = nil
	selected.Parent = nil
end

local doburst = Instance.new("TextButton")
doburst.Size = UDim2.new(0.5, -1, 0, 32)
doburst.Position = UDim2.new(0, 0, 1, 2)
doburst.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
doburst.BorderSizePixel = 0
doburst.BackgroundTransparency = 0.6
doburst.Text = "burst type"
doburst.Font = Enum.Font.SourceSansBold
doburst.TextSize = 18
doburst.TextColor3 = Color3.fromRGB(255, 255, 255)
doburst.TextYAlignment = Enum.TextYAlignment.Center
doburst.Parent = container
Instance.new("UIPadding", doburst).PaddingBottom = UDim.new(0, 2)

doburst.MouseButton1Click:Connect(function()
	if istyping and typemode == "burst" then
		return
	end

	run("burst", doburst)
end)

local doreg = Instance.new("TextButton")
doreg.Size = UDim2.new(0.5, -1, 0, 32)
doreg.Position = UDim2.new(0.5, 1, 1, 2)
doreg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
doreg.BorderSizePixel = 0
doreg.BackgroundTransparency = 0.6
doreg.Text = "normal type"
doreg.Font = Enum.Font.SourceSansBold
doreg.TextSize = 18
doreg.TextColor3 = Color3.fromRGB(255, 255, 255)
doreg.TextYAlignment = Enum.TextYAlignment.Center
doreg.Parent = container
Instance.new("UIPadding", doreg).PaddingBottom = UDim.new(0, 2)

doreg.MouseButton1Click:Connect(function()
	if istyping and typemode == "reg" then
		return
	end

	run("reg", doreg)
end)

-------------------------------------------------------------------------------------------------------------------------------

local selected2 = Instance.new("UIStroke")
selected2.Color = Color3.fromRGB(102, 141, 226)
selected2.Thickness = 5
selected2.BorderOffset = UDim.new(0, -5)
selected2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
selected2.LineJoinMode = Enum.LineJoinMode.Miter

local autotype = Instance.new("TextButton")
autotype.Size = UDim2.new(1, 0, 0, 32)
autotype.Position = UDim2.new(0, 0, 1, 36)
autotype.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
autotype.BorderSizePixel = 0
autotype.BackgroundTransparency = 0.6
autotype.Text = "auto type"
autotype.Font = Enum.Font.SourceSansBold
autotype.TextSize = 18
autotype.TextColor3 = Color3.fromRGB(255, 255, 255)
autotype.TextYAlignment = Enum.TextYAlignment.Center
autotype.Parent = container
Instance.new("UIPadding", autotype).PaddingBottom = UDim.new(0, 2)

local autotyping = false
local autotypingthread = nil

autotype.MouseButton1Click:Connect(function()
	autotyping = not autotyping
	
	if autotyping then
		selected2.Parent = autotype
		
		autotypingthread = spwn(function()
			while true do
				if autotyping then
					if fetchturn() == plr.UserId then
						solve()
					end
				end
				t(1)
			end
		end)
	else
		selected2.Parent = nil
		
		if autotypingthread then
			cncl(autotypingthread)
			autotypingthread = nil
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
