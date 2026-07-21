-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local plrs = game:GetService("Players")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local rs = game:GetService("RunService")
local s = game:GetService("Stats")

local plr = plrs.LocalPlayer
local cam = workspace.CurrentCamera

local t, spwn, cncl = task.wait, task.spawn, task.cancel
local mobile = uis.TouchEnabled
local studio = rs:IsStudio()

local cgui = game:GetService("CoreGui") or nil
local rand = math.random
local firesignal = (syn and syn.firesignal) or firesignal
local targetui = (studio and plr.PlayerGui) or gethui() or cgui

-------------------------------------------------------------------------------------------------------------------------------

local exists = targetui:FindFirstChild("anti memory leak")
if exists then exists:Destroy() end 

local gui = Instance.new("ScreenGui")
gui.Name = "anti memory leak"
gui.ResetOnSpawn = false
gui.Parent = targetui

-------------------------------------------------------------------------------------------------------------------------------

local brightblock = {}

local function norender(state)
	if state then
		if brightblock.sgui2 then brightblock.sgui2:Destroy() end

		brightblock.sgui2 = Instance.new("ScreenGui")
		brightblock.sgui2.Name = "away from keyboard"
		brightblock.sgui2.ResetOnSpawn = false
		brightblock.sgui2.DisplayOrder = 2147483647
		brightblock.sgui2.IgnoreGuiInset = true
		brightblock.sgui2.Parent = targetui

		brightblock.f2 = Instance.new("Frame")		
		brightblock.f2.Parent = brightblock.sgui2
		brightblock.f2.BackgroundColor3 = Color3.new(0, 0, 0)
		brightblock.f2.Size = UDim2.new(1, 0, 1, 60)
		brightblock.f2.Position = UDim2.new(0, 0, 0, -60)
		brightblock.f2.ZIndex = 1

		rs:Set3dRenderingEnabled(false)
	else

		if brightblock.sgui2 then brightblock.sgui2:Destroy() brightblock.sgui2 = nil end
		brightblock.f2 = nil

		rs:Set3dRenderingEnabled(true)
	end
end

local antimemoryleakenabled = false
local antimemoryleakconn = nil
local antimemoryleakthresh = s:GetTotalMemoryUsageMb() + 1200

local function toggleantimemoryleak(state)
	antimemoryleakenabled = state
	if not antimemoryleakenabled then
		norender(false)
		if antimemoryleakconn then
			if typeof(antimemoryleakconn) == "RBXScriptConnection" then
				antimemoryleakconn:Disconnect()
			elseif typeof(antimemoryleakconn) == "thread" then
				task.cancel(antimemoryleakconn)
			end
			antimemoryleakconn = nil
		end
		return
	else
		norender(true)
	end

	antimemoryleakconn = task.spawn(function()
		while antimemoryleakenabled do
			local memValue = s:GetTotalMemoryUsageMb()
			if memValue > antimemoryleakthresh then
				norender(false)
				task.delay(1, function()
					if antimemoryleakenabled then
						norender(true)
					end
				end)
			end
			t(1)
		end
	end)
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
title.Text = "SRS: anti memory leak"
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

-------------------------------------------------------------------------------------------------------------------------------

local aml = Instance.new("TextButton")
aml.Size = UDim2.new(1, 0, 0, 32)
aml.Position = UDim2.new(0, 0, 1, 2)
aml.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
aml.BorderSizePixel = 0
aml.BackgroundTransparency = 0.6
aml.Text = "anti memory leak"
aml.Font = Enum.Font.SourceSansBold
aml.TextSize = 18
aml.TextColor3 = Color3.fromRGB(255, 255, 255)
aml.TextYAlignment = Enum.TextYAlignment.Center
aml.Parent = container
Instance.new("UIPadding", aml).PaddingBottom = UDim.new(0, 2)

local toggled = false

aml.MouseButton1Click:Connect(function()
	toggled = not toggled
	toggleantimemoryleak(toggled)
	
	if toggled then
		selected.Parent = aml
	else
		selected.Parent = nil
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
