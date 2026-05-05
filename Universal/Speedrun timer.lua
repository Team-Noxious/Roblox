----------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end task.wait(1)

-------------------------------------------------------------------------------------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "LiveSplit"
gui.ResetOnSpawn = false
if game["Run Service"]:IsStudio() then gui["Parent"]= game["Players"]["LocalPlayer"]:WaitForChild("PlayerGui") else gui["Parent"] = gethui and gethui() or game["CoreGui"] end

-------------------------------------------------------------------------------------------------------------------------------

function repos(ui, w, h)
	local sw, sh = workspace["CurrentCamera"]["ViewportSize"]["X"], workspace["CurrentCamera"]["ViewportSize"]["Y"]
	local cx, cy = (sw - w) / 2, (sh - h) / 2 - 56
	ui["Position"] = UDim2.new(0, cx, 0, cy)
end

local mainframe = Instance.new("Frame")
mainframe.Size = UDim2.new(0, 200, 0, 50)
mainframe.Position = UDim2.new(0.5, -100, 0, 50)
mainframe.BackgroundTransparency = 0
mainframe.BorderSizePixel = 0
repos(mainframe, 200, 50)
mainframe.BackgroundColor3 = Color3.new(0, 0, 0)
mainframe.Active = true
mainframe.Draggable = true
mainframe.Parent = gui

local bigtime = Instance.new("TextLabel")
bigtime.Size = UDim2.new(0, 150, 1, 0)
bigtime.Position = UDim2.new(0, 0, 0, 0)
bigtime.BackgroundTransparency = 1
bigtime.TextColor3 = Color3.new(1, 1, 1)
bigtime.Font = Enum.Font.SourceSansBold
bigtime.TextSize = 40
bigtime.TextXAlignment = Enum.TextXAlignment.Right
bigtime.Text = "0:00"
bigtime.Parent = mainframe

local smalltime = Instance.new("TextLabel")
smalltime.Size = UDim2.new(0, 50, 1, 0)
smalltime.Position = UDim2.new(1, -50, 0, 3)
smalltime.BackgroundTransparency = 1
smalltime.TextColor3 = Color3.new(1, 1, 1)
smalltime.Font = Enum.Font.SourceSansBold
smalltime.TextSize = 30
smalltime.TextXAlignment = Enum.TextXAlignment.Left
smalltime.Text = ".00"
smalltime.Parent = mainframe

local resetbtn = Instance.new("TextButton")
resetbtn.Size = UDim2.new(0, 50, 0, 11)
resetbtn.Position = UDim2.new(0, 0, 0, 54)
resetbtn.BackgroundTransparency = 1
resetbtn.TextColor3 = Color3.new(1, 1, 1)
resetbtn.Font = Enum.Font.Arimo
resetbtn.TextSize = 10
resetbtn.TextXAlignment = Enum.TextXAlignment.Left
resetbtn.Text = "[R] RESET"
resetbtn.Parent = mainframe

local ctrlbtn = Instance.new("TextButton")
ctrlbtn.Size = UDim2.new(0, 50, 0, 11)
ctrlbtn.Position = UDim2.new(0, 50, 0, 54)
ctrlbtn.BackgroundTransparency = 1
ctrlbtn.TextColor3 = Color3.new(1, 1, 1)
ctrlbtn.Font = Enum.Font.Arimo
ctrlbtn.TextSize = 10
ctrlbtn.TextXAlignment = Enum.TextXAlignment.Left
ctrlbtn.Text = "│ [T] START"
ctrlbtn.Parent = mainframe

-------------------------------------------------------------------------------------------------------------------------------

local greengrad, graygrad, bluegrad, greengrad2, graygrad2, bluegrad2 = nil

function gren()
	if graygrad then 
		graygrad:Destroy()
		graygrad = nil
	end
	if greengrad then 
		greengrad:Destroy()
		greengrad = nil
	end
	if bluegrad then 
		bluegrad:Destroy()
		bluegrad = nil
	end

	if graygrad2 then 
		graygrad2:Destroy()
		graygrad2 = nil
	end
	if greengrad2 then 
		greengrad2:Destroy()
		greengrad2 = nil
	end
	if bluegrad2 then 
		bluegrad2:Destroy()
		bluegrad2 = nil
	end

	greengrad = Instance.new("UIGradient")
	greengrad.Color = ColorSequence.new {
		ColorSequenceKeypoint.new(0, Color3.fromRGB(152, 236, 168)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(89, 176, 100)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(89, 176, 100)),
	}
	greengrad.Rotation = 90
	greengrad.Parent = smalltime

	greengrad2 = Instance.new("UIGradient")
	greengrad2.Color = ColorSequence.new {
		ColorSequenceKeypoint.new(0, Color3.fromRGB(152, 236, 168)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(89, 176, 100)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(89, 176, 100)),
	}
	greengrad2.Rotation = 90
	greengrad2.Parent = bigtime
end

function blu()
	if graygrad then graygrad:Destroy() graygrad = nil end
	if greengrad then greengrad:Destroy() greengrad = nil end
	if bluegrad then bluegrad:Destroy() bluegrad = nil end
	if graygrad2 then graygrad2:Destroy() graygrad2 = nil end
	if greengrad2 then greengrad2:Destroy() greengrad2 = nil end
	if bluegrad2 then bluegrad2:Destroy() bluegrad2 = nil end

	bluegrad = Instance.new("UIGradient")
	bluegrad.Color = ColorSequence.new {
		ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 205, 251)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(47, 148, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(47, 148, 255)),
	}
	bluegrad.Rotation = 90
	bluegrad.Parent = smalltime

	bluegrad2 = Instance.new("UIGradient")
	bluegrad2.Color = ColorSequence.new {
		ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 205, 251)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(47, 148, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(47, 148, 255)),
	}
	bluegrad2.Rotation = 90
	bluegrad2.Parent = bigtime
end

function gre()
	if graygrad then graygrad:Destroy() graygrad = nil end
	if greengrad then greengrad:Destroy() greengrad = nil end
	if bluegrad then bluegrad:Destroy() bluegrad = nil end
	if graygrad2 then graygrad2:Destroy() graygrad2 = nil end
	if greengrad2 then greengrad2:Destroy() greengrad2 = nil end
	if bluegrad2 then bluegrad2:Destroy() bluegrad2 = nil end

	graygrad = Instance.new("UIGradient")
	graygrad.Color = ColorSequence.new {
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 160, 160)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 160, 160)),
	}
	graygrad.Rotation = 90
	graygrad.Parent = smalltime

	graygrad2 = Instance.new("UIGradient")
	graygrad2.Color = ColorSequence.new {
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 160, 160)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 160, 160)),
	}
	graygrad2.Rotation = 90
	graygrad2.Parent = bigtime
end

gre()

-------------------------------------------------------------------------------------------------------------------------------

local running, played = false, false
local starttime, elapsed = 0, 0
local connection

function updatetime(seconds)
	local m = math.floor(seconds / 60)
	local s = math.floor(seconds % 60)
	local ms = math.floor((seconds - math.floor(seconds)) * 100)

	if m == 0 then
		bigtime.Text = string.format("%d:%02d", m, s)
	else
		bigtime.Text = string.format("%d:%02d", m, s)
	end

	smalltime.Text = string.format(".%02d", ms)
end

function start() if running then return end running = true played = true ctrlbtn.Text = "│ [T] PAUSE" gren() starttime = tick() - elapsed connection = game["Run Service"].RenderStepped:Connect(function() elapsed = tick() - starttime updatetime(elapsed) end) end
function pause() if not running then return end running = false if connection then connection:Disconnect() end if played then blu() ctrlbtn.Text = "│ [T] RESUME" end end
function reset() pause() gre() elapsed = 0 updatetime(0) played = false ctrlbtn.Text = "│ [T] START" end

game["UserInputService"].InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.T then
		if running then
			pause()
		else
			start()
		end
	elseif input.KeyCode == Enum.KeyCode.R then
		reset()
	end
end)

resetbtn.MouseButton1Click:Connect(function()
	reset()
end)

ctrlbtn.MouseButton1Click:Connect(function()
	if running then
		pause()
	else
		start()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

updatetime(0)

-------------------------------------------------------------------------------------------------------------------------------
