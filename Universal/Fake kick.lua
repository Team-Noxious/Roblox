-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local l = game:GetService("Lighting")
local ts = game:GetService("TweenService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local root = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local mobile = uis.TouchEnabled

local net = settings():GetService("NetworkSettings")
local getgenv = getgenv() or _G
local hiddenui = gethui() or FindFirstChildOfClass(game, "CoreGui")

-------------------------------------------------------------------------------------------------------------------------------

if getgenv.fakekickui then return end 

-------------------------------------------------------------------------------------------------------------------------------

function disconnect(obj)
	if obj then
		if typeof(obj) == "RBXScriptConnection" then
			obj:Disconnect()
		elseif obj == "Instance" then
			obj:Destroy()
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local blur = Instance.new("BlurEffect")
blur.Size = 24
blur.Parent = l

getgenv.fakekickui = Instance.new("ScreenGui")
getgenv.fakekickui.DisplayOrder = 2147483647
getgenv.fakekickui.ResetOnSpawn = false
getgenv.fakekickui.Parent = hiddenui

local inputblocker = Instance.new("Frame")
inputblocker.ZIndex = 1
inputblocker.BackgroundTransparency = 1
inputblocker.Active = true
inputblocker.Size = UDim2.new(1, 0, 1, 36)
inputblocker.Position = UDim2.fromOffset(0, -36)
inputblocker.Parent = getgenv.fakekickui

local mainframe = Instance.new("Frame")
mainframe.AnchorPoint = Vector2.one * 0.5
mainframe.Position = UDim2.fromScale(0.5, 0.5)
mainframe.Size = UDim2.fromOffset(400, 290)
mainframe.BackgroundColor3 = Color3.fromRGB(57, 59, 61)
mainframe.BorderSizePixel = 0
mainframe.ZIndex = 8
mainframe.Parent = inputblocker

local scale = Instance.new("UIScale", mainframe)
scale.Scale = 0.005

local layout = Instance.new("UIListLayout")
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = mainframe

local titleholder = Instance.new("Frame")
titleholder.LayoutOrder = 1
titleholder.Size = UDim2.new(1, 0, 0, 50)
titleholder.ZIndex = 8
titleholder.BackgroundTransparency = 1
titleholder.Parent = mainframe

local titlepad = Instance.new("UIPadding")
titlepad.PaddingTop = UDim.new(0, 11)
titlepad.PaddingBottom = UDim.new(0, 11)
titlepad.Parent = titleholder

local title = Instance.new("TextLabel")
title.Text = "Disconnected"
title.Size = UDim2.new(1, 0, 0, 28)
title.ZIndex = 8
title.TextSize = 25
title.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = titleholder

local split = Instance.new("Frame")
split.LayoutOrder = 2
split.Size = UDim2.new(0, 360, 0, 1)
split.BackgroundColor3 = Color3.fromRGB(189, 190, 190)
split.ZIndex = 8
split.BorderSizePixel = 0
split.Parent = mainframe

local msgholder = Instance.new("Frame")
msgholder.LayoutOrder = 3
msgholder.ZIndex = 8
msgholder.Size = UDim2.new(1, 0, 1, -52)
msgholder.BackgroundTransparency = 1
msgholder.Parent = mainframe

local msgpadding = Instance.new("UIPadding")
msgpadding.PaddingTop = UDim.new(0, 20)
msgpadding.PaddingBottom = UDim.new(0, 20)
msgpadding.PaddingLeft = UDim.new(0, 20)
msgpadding.PaddingRight = UDim.new(0, 20)
msgpadding.Parent = msgholder

local reasonholder = Instance.new("Frame")
reasonholder.Size = UDim2.fromScale(1, 1)
reasonholder.BackgroundTransparency = 1
reasonholder.ZIndex = 8
reasonholder.Parent = msgholder

local reasonholderlayout = Instance.new("UIListLayout")
reasonholderlayout.Padding = UDim.new(0, 20)
reasonholderlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
reasonholderlayout.SortOrder = Enum.SortOrder.LayoutOrder
reasonholderlayout.Parent = reasonholder

local reason = Instance.new("TextLabel")
reason.LayoutOrder = 1
reason.ZIndex = 8
reason.Text = "You were banned from this experience by the creator. Here's a message from the creator:\n\nYou created or used an account to avoid enforcement taken against another account by the creator of this experience\n(Error Code: 600)"
reason.TextWrapped = true
reason.TextSize = 20
reason.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
reason.TextColor3 = Color3.fromRGB(189, 190, 190)
reason.Size = UDim2.new(0, 400, 1, -56)
reason.BackgroundTransparency = 1
reason.Parent = reasonholder

local buttonholder = Instance.new("Frame")
buttonholder.LayoutOrder = 2
buttonholder.Size = UDim2.new(0, 400, 0, 36)
buttonholder.ZIndex = 8
buttonholder.BackgroundTransparency = 1
buttonholder.Parent = reasonholder

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.fromOffset(360, 36)
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
grid.Parent = buttonholder

local leavebutton = Instance.new("ImageButton")
leavebutton.Image = "rbxasset://textures/ui/ErrorPrompt/PrimaryButton.png"
leavebutton.ScaleType = Enum.ScaleType.Slice
leavebutton.ZIndex = 20
leavebutton.SliceCenter = Rect.new(8, 8, 9, 9)
leavebutton.BackgroundTransparency = 1
leavebutton.Parent = buttonholder

local leavetext = Instance.new("TextLabel")
leavetext.Text = "Leave"
leavetext.TextSize = 20
leavetext.ZIndex = 8
leavetext.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
leavetext.TextColor3 = Color3.fromRGB(35, 37, 39)
leavetext.BackgroundTransparency = 1
leavetext.Size = UDim2.fromScale(1, 1)
leavetext.Parent = leavebutton

local fakeleavebutton = Instance.new("Frame")
fakeleavebutton.AnchorPoint = Vector2.one * 0.5
fakeleavebutton.Position = UDim2.fromScale(0.5, 0.5)
fakeleavebutton.Size = UDim2.fromOffset(360, 36)
fakeleavebutton.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
fakeleavebutton.BorderSizePixel = 0
fakeleavebutton.ZIndex = 7
fakeleavebutton.Parent = leavetext
Instance.new("UICorner", fakeleavebutton).CornerRadius = UDim.new(0, 5)

local buttonanim = Instance.new("ImageLabel")
buttonanim.ZIndex = 20
buttonanim.BackgroundTransparency = 0.6999
buttonanim.BorderSizePixel = 0
buttonanim.ClipsDescendants = true
buttonanim.Visible = false
buttonanim.Size = UDim2.fromScale(1, 1)
buttonanim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
buttonanim.Parent = leavebutton

local buttonoverlay = Instance.new("ImageLabel")
buttonoverlay.Image = "rbxasset://textures/ui/ErrorPrompt/ShimmerOverlay.png"
buttonoverlay.ZIndex = 21
buttonoverlay.BackgroundTransparency = 1
buttonoverlay.BorderSizePixel = 0
buttonoverlay.Size = UDim2.fromScale(1, 1)
buttonoverlay.SliceCenter = Rect.new(8, 8, 9, 9)
buttonoverlay.ScaleType = Enum.ScaleType.Slice
buttonoverlay.ImageColor3 = Color3.fromRGB(57, 59, 61)
buttonoverlay.Parent = buttonanim

local shimmer = Instance.new("ImageLabel")
shimmer.Image = "rbxasset://textures/ui/LuaApp/graphic/shimmer_darkTheme.png"
shimmer.BackgroundTransparency = 1
shimmer.ZIndex = 20
shimmer.BorderSizePixel = 0
shimmer.Size = UDim2.fromScale(1, 2)
shimmer.Position = UDim2.fromScale(-1, 0)
shimmer.Parent = buttonanim

local shimmeranim = ts:Create(
	shimmer,
	TweenInfo.new(1.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
	{ Position = UDim2.fromScale(1, 0) }
)

local freezeconn

ts:Create(scale, TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Scale = mobile and 0.8 or 1}):Play()
local init = ts:Create(inputblocker, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
init.Completed:Wait()

leavebutton.MouseEnter:Connect(function()
	buttonanim.Visible = true
	shimmer.Position = UDim2.fromScale(-1, 0)
	shimmeranim:Play()
end)

leavebutton.MouseLeave:Connect(function()
	shimmeranim:Cancel()
	buttonanim.Visible = false
end)

local function shatterUI()
	net.IncomingReplicationLag = 0
	disconnect(freezeconn) freezeconn = nil
	if root then root.Anchored = false end
	
	task.delay(1, function()
		disconnect(getgenv.fakekickui) getgenv.fakekickui = nil
	end)

	buttonanim:Destroy()
	mainframe.ZIndex = 1
	ts:Create(blur, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()

	root.Anchored = false

	local fragments = {}
	for _, v in ipairs(mainframe:GetDescendants()) do
		if v:IsA("GuiObject") then
			local transparency = 0
			if v:IsA("TextLabel") or v:IsA("TextBox") then transparency = v.TextTransparency
			elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then transparency = v.ImageTransparency
			else transparency = v.BackgroundTransparency end

			if transparency < 1 then table.insert(fragments, v) end
		end
	end
	table.insert(fragments, mainframe)

	for _, v in ipairs(fragments) do
		local abspos = v.AbsolutePosition
		local abssize = v.AbsoluteSize

		v.Parent = getgenv.fakekickui
		v.AnchorPoint = Vector2.new(0.5, 0.5)
		local startX = abspos.X + (abssize.X/2)
		local startY = abspos.Y + (abssize.Y/2) + 36
		v.Position = UDim2.fromOffset(startX, startY)

		for _, child in ipairs(v:GetChildren()) do
			if child:IsA("UIListLayout") or child:IsA("UIGridLayout") or child:IsA("UIPadding") then
				child:Destroy()
			end
		end

		task.spawn(function()
			local valX = Instance.new("NumberValue")
			local valY = Instance.new("NumberValue")
			valX.Value = startX
			valY.Value = startY

			local forceX = math.random(300, 800) 
			if math.random(1, 2) == 1 then
				forceX = -forceX
			end
			local forceY = math.random(-150, -100)
			local gravity = 1300
			local spinDir = math.random(200, 360) 
			if math.random(1, 2) == 1 then
				spinDir = -spinDir
			end

			local connection = rs.Heartbeat:Connect(function()
				v.Position = UDim2.fromOffset(valX.Value, valY.Value)
			end)

			local tweenX = ts:Create(valX, TweenInfo.new(2, Enum.EasingStyle.Linear), {
				Value = startX + forceX
			})

			local popY = ts:Create(valY, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Value = startY + forceY
			})

			local fallY = ts:Create(valY, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
				Value = startY + gravity
			})

			ts:Create(v, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = spinDir * 2}):Play()

			tweenX:Play()
			popY:Play()

			popY.Completed:Wait()
			fallY:Play()

			fallY.Completed:Wait()

			disconnect(connection) connection = nil
			valX:Destroy()
			valY:Destroy()
			v:Destroy()
		end)
	end
end

leavebutton.Activated:Connect(shatterUI)

net.IncomingReplicationLag = 9999

freezeconn = rs.Heartbeat:Connect(function()
	if root then root.Anchored = true end
end)

-------------------------------------------------------------------------------------------------------------------------------
