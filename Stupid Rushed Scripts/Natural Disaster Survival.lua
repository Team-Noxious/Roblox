-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local plrs = game:GetService("Players")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local sgui = game:GetService("StarterGui")
local ws = game:GetService("Workspace")
local rst = game:GetService("ReplicatedStorage")
local rs = game:GetService("RunService")

local plr = plrs.LocalPlayer
local cam = workspace.CurrentCamera

local mobile = uis.TouchEnabled

local fireclickdetector = (syn and syn.fireclickdetector) or fireclickdetector
local targetui = (studio and plr.PlayerGui) or gethui() or game:GetService("CoreGui")

-------------------------------------------------------------------------------------------------------------------------------

local exists = targetui:FindFirstChild("natural disaster survival")
if exists then exists:Destroy() end 

local gui = Instance.new("ScreenGui")
gui.Name = "natural disaster survival"
gui.ResetOnSpawn = false
gui.Parent = targetui

-------------------------------------------------------------------------------------------------------------------------------

local afdenabled = false
local afdconnection

local function applyafd(c)
	local r = c:WaitForChild("HumanoidRootPart")
	if not r then return end

	afdconnection = rs.Heartbeat:Connect(function()
		if not afdenabled then return end

		if not r.Parent then
			afdconnection:Disconnect()
			afdconnection = nil
			return
		end

		local v = r.AssemblyLinearVelocity
		r.AssemblyLinearVelocity = Vector3.zero
		rs.RenderStepped:Wait()
		r.AssemblyLinearVelocity = v
	end)
end

function antifalldamage(state)
	if state then
		if afdenabled then return end
		afdenabled = true

		if plr.Character then
			applyafd(plr.Character)
		end
	else
		afdenabled = false

		if afdconnection then
			afdconnection:Disconnect()
			afdconnection = nil
		end
	end
end

plr.CharacterAdded:Connect(function(char)
	if afdenabled then
		applyafd(char)
	end
end)

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
title.Text = "SRS: NDS"
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

local antifalldmgtgl = Instance.new("TextButton")
antifalldmgtgl.Size = UDim2.new(0.5, -1, 0, 32)
antifalldmgtgl.Position = UDim2.new(0, 0, 1, 2)
antifalldmgtgl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
antifalldmgtgl.BorderSizePixel = 0
antifalldmgtgl.BackgroundTransparency = 0.6
antifalldmgtgl.Text = "anti fall dmg"
antifalldmgtgl.Font = Enum.Font.SourceSansBold
antifalldmgtgl.TextSize = 18
antifalldmgtgl.TextColor3 = Color3.fromRGB(255, 255, 255)
antifalldmgtgl.TextYAlignment = Enum.TextYAlignment.Center
antifalldmgtgl.Parent = container
Instance.new("UIPadding", antifalldmgtgl).PaddingBottom = UDim.new(0, 2)

antifalldmgtgl.MouseButton1Click:Connect(function()
	selected.Parent = antifalldmgtgl
	afdenabled = not afdenabled
	
	antifalldamage(afdenabled)
	
	if not afdenabled then
		selected.Parent = nil
	end
end)

local breakgame = Instance.new("TextButton")
breakgame.Size = UDim2.new(0.5, -1, 0, 32)
breakgame.Position = UDim2.new(0.5, 1, 1, 2)
breakgame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
breakgame.BorderSizePixel = 0
breakgame.BackgroundTransparency = 0.6
breakgame.Text = "break game"
breakgame.Font = Enum.Font.SourceSansBold
breakgame.TextSize = 18
breakgame.TextColor3 = Color3.fromRGB(255, 255, 255)
breakgame.TextYAlignment = Enum.TextYAlignment.Center
breakgame.Parent = container
Instance.new("UIPadding", breakgame).PaddingBottom = UDim.new(0, 2)

breakgame.MouseButton1Click:Connect(function()
	local p = plr
	local r, c, h = rst.Remotes.Compass, plr.Backpack:WaitForChild("Compass"), plr.Character:WaitForChild("Humanoid")
	h:EquipTool(c)
	task.wait()
	r:FireServer("Vote Map", 3)
	r:FireServer("Vote Map", 4)
	task.wait()
	h:UnequipTools()
end)

-------------------------------------------------------------------------------------------------------------------------------

local launchrocket = Instance.new("TextButton")
launchrocket.Size = UDim2.new(0.5, -1, 0, 32)
launchrocket.Position = UDim2.new(0, 0, 1, 36)
launchrocket.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
launchrocket.BorderSizePixel = 0
launchrocket.BackgroundTransparency = 0.6
launchrocket.Text = "launch rocket"
launchrocket.Font = Enum.Font.SourceSansBold
launchrocket.TextSize = 18
launchrocket.TextColor3 = Color3.fromRGB(255, 255, 255)
launchrocket.TextYAlignment = Enum.TextYAlignment.Center
launchrocket.Parent = container
Instance.new("UIPadding", launchrocket).PaddingBottom = UDim.new(0, 2)

launchrocket.MouseButton1Click:Connect(function()
	for _, model in ipairs(ws:FindFirstChild("Structure"):GetChildren()) do
		if model:IsA("Model") then
			for _, descendant in ipairs(model:GetDescendants()) do
				if descendant:IsA("ClickDetector") and descendant.Parent then
					fireclickdetector(descendant, 0)
				end
			end
		end
	end 
end)

local nullfire = Instance.new("TextButton")
nullfire.Size = UDim2.new(0.5, -1, 0, 32)
nullfire.Position = UDim2.new(0.5, 1, 1, 36)
nullfire.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
nullfire.BorderSizePixel = 0
nullfire.BackgroundTransparency = 0.6
nullfire.Text = "nullfire"
nullfire.Font = Enum.Font.SourceSansBold
nullfire.TextSize = 18
nullfire.TextColor3 = Color3.fromRGB(255, 255, 255)
nullfire.TextYAlignment = Enum.TextYAlignment.Center
nullfire.Parent = container
Instance.new("UIPadding", nullfire).PaddingBottom = UDim.new(0, 2)

nullfire.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/InfernusScripts/Fire-Hub/main/Loader"))()
end)

-------------------------------------------------------------------------------------------------------------------------------
