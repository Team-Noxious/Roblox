-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local plrs = game:GetService("Players")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local sgui = game:GetService("StarterGui")
local rs = game:GetService("RunService")

local plr = plrs.LocalPlayer
local cam = workspace.CurrentCamera

local mobile = uis.TouchEnabled

local blacklistrayfilter = Enum.RaycastFilterType.Blacklist
local targetui = (studio and plr.PlayerGui) or gethui() or game:GetService("CoreGui")

-------------------------------------------------------------------------------------------------------------------------------

local exists = targetui:FindFirstChild("arsenal")
if exists then exists:Destroy() end 

local gui = Instance.new("ScreenGui")
gui.Name = "arsenal"
gui.ResetOnSpawn = false
gui.Parent = targetui

-------------------------------------------------------------------------------------------------------------------------------

local tgl = false
local circ = nil

local function mcirc()
	if circ then circ:Destroy() end

	circ = Instance.new("Frame")
	circ.AnchorPoint = Vector2.new(0.5, 0.5)
	circ.Size = mobile and UDim2.new(0, 221, 0, 221) or UDim2.new(0, 421, 0, 421)
	circ.BackgroundTransparency = 1
	circ.ZIndex = 10
	circ.Parent = gui

	local cs = circ.AbsoluteSize

	local centerX = (cam.ViewportSize.X - cs.X) / 2
	local centerY = (cam.ViewportSize.Y - cs.Y) / 2 - 56

	circ.Position = UDim2.fromOffset(centerX + cs.X/2, centerY + cs.Y/2)

	local crn = Instance.new("UICorner")
	crn.CornerRadius = UDim.new(1, 0)
	crn.Parent = circ

	local strk = Instance.new("UIStroke")
	strk.Thickness = 1
	strk.Transparency = 0
	strk.Color = Color3.fromRGB(255, 255, 255)
	strk.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	strk.Parent = circ
end

local function rcirc()
	if circ then circ:Destroy() end
	circ = nil
end

-------------------------------------------------------------------------------------------------------------------------------

local function onch(wp)
	local sp, os = cam:WorldToViewportPoint(wp)
	if not os then return false end

	local cx = cam.ViewportSize.X/2
	local cy = cam.ViewportSize.Y/2

	local d = Vector2.new(sp.X - cx, sp.Y - cy)
	return d.Magnitude <= 3
end

local te = false
local lt = nil
local hon = false
local tc = true

local function gettgt()
	local c = plr.Character
	if not c or not c:FindFirstChild("HumanoidRootPart") then 
		lt = nil
		return nil 
	end

	local hrp = c.HumanoidRootPart
	local mp = hrp.Position
	local lv = cam.CFrame.LookVector

	local function vis(tp, ch)
		local ro = cam.CFrame.Position
		local rd = tp.Position - ro

		local rp = RaycastParams.new()
		rp.FilterDescendantsInstances = {plr.Character, cam, ch}
		rp.FilterType = blacklistrayfilter
		rp.IgnoreWater = true

		local rr = workspace:Raycast(ro, rd, rp)
		if rr then
			local hitPart = rr.Instance
			if hitPart then
				local t = hitPart.Transparency
				local c = hitPart.CanCollide
				local q = hitPart.CanQuery
				if t >= 1 or not c or not q then
					local remainDist = (tp.Position - rr.Position).Magnitude
					if remainDist > 1 then
						local newOrigin = rr.Position + (rd.Unit * 0.05)
						local newDir = tp.Position - newOrigin
						rp.FilterDescendantsInstances = {plr.Character, cam, ch, hitPart}
						local rr2 = workspace:Raycast(newOrigin, newDir, rp)
						if rr2 then
							local hp2 = rr2.Instance
							if hp2 and not hp2:IsDescendantOf(ch) then
								return false
							end
						end
					end
					return true
				elseif not hitPart:IsDescendantOf(ch) then
					return false
				end
			end
		end

		return true
	end

	local function pvis(tp, ch)
		if not tp then return false end
		local sp, os = cam:WorldToViewportPoint(tp.Position)
		if not os then return false end
		return vis(tp, ch)
	end

	if lt and lt.Parent then
		local h = lt.Parent:FindFirstChildOfClass("Humanoid")
		if h and h.Health > 0 and pvis(lt, lt.Parent) then
			local d = (lt.Position - mp).Magnitude
			if d <= 700 then
				return lt
			end
		end
	end

	lt = nil

	local bt = nil
	local cd = math.huge

	for _, p in ipairs(plrs:GetPlayers()) do
		if p == plr then continue end

		local ch = p.Character
		if not ch then continue end

		local h = ch:FindFirstChildOfClass("Humanoid")
		local hrp = ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso")
		local hd = ch:FindFirstChild("HumanoidRootPart")

		if not h or h.Health <= 0 or not hrp then continue end
		if tc and p.Team and p.Team == plr.Team then continue end
		if ch:FindFirstChildOfClass("ForceField") then continue end

		local d = (hrp.Position - mp).Magnitude
		if d > 700 then continue end

		local tp
		if hd and pvis(hd, ch) then
			tp = hd
		elseif pvis(hrp, ch) then
			tp = hrp
		end

		if tp then
			if d < cd then
				cd = d
				bt = tp
			end
		end
	end

	lt = bt
	return bt
end

local ss = 22
local pld = 0.15
local pt = nil
local lst = 0

rs.RenderStepped:Connect(function(dt)
	if not tgl then return end
	local t = gettgt()
	if not t then pt, lst, lt = nil, 0, nil; return end

	if t ~= pt then
		pt, lst = t, tick()
		return
	end
	if tick() - lst < pld then return end

	local cp = cam.CFrame.Position
	local dir = (t.Position - cp).Unit
	local targetCF = CFrame.new(cp, cp + dir)

	local a = math.clamp(dt * ss, 0, 1)
	local ea = a < 0.5 and 4*a*a*a or 1 - ((-2*a+2)^3)/2
	cam.CFrame = cam.CFrame:Lerp(targetCF, ea)
end)

local function tcl(s)
	tgl = s
	if not s then
		lt = nil
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local et = {}
local ee = false

local function mbox(p)
	if p == plr then return end

	local c = p.Character
	if not c then return end

	if et[p] then
		et[p].sg:Destroy()
	end

	local sg = Instance.new("ScreenGui")
	sg.ResetOnSpawn = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sg.IgnoreGuiInset = true
	sg.Parent = targetui

	local bf = Instance.new("Frame")
	bf.BackgroundTransparency = 1
	bf.Size = UDim2.new(0, 100, 0, 200)
	bf.Position = UDim2.new(0, 0, 0, 0)
	bf.Visible = false
	bf.Parent = sg

	local bs = Instance.new("UIStroke")
	bs.Thickness = 2
	bs.Transparency = 0
	bs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	bs.Parent = bf

	if p.Team then
		bs.Color = p.Team.TeamColor.Color
	else
		bs.Color = Color3.fromRGB(255, 255, 255)
	end

	et[p] = {
		sg = sg,
		bf = bf,
		bs = bs,
	}
end

local function resp(p)
	if et[p] then
		et[p].sg:Destroy()
		et[p] = nil
	end
end

local function uesp(p)
	if not ee or p == plr then return end

	local d = et[p]
	if not d then return end

	local c = p.Character
	if not c then
		resp(p)
		return
	end

	local hrp = c:FindFirstChild("HumanoidRootPart")
	if not hrp then
		resp(p)
		return
	end

	local cf, sz = c:GetBoundingBox()

	local crn = {}
	for x = -0.5, 0.5, 1 do
		for y = -0.5, 0.5, 1 do
			for z = -0.5, 0.5, 1 do
				table.insert(crn, (cf.Position + (cf.RightVector * sz.X * x) + (cf.UpVector * sz.Y * y) + (cf.LookVector * sz.Z * z)))
			end
		end
	end

	local mnx, mny, mxx, mxy
	local os = false
	for _, cr in ipairs(crn) do
		local sp, osr = cam:WorldToViewportPoint(cr)
		if osr then
			os = true
			if not mnx or sp.X < mnx then mnx = sp.X end
			if not mxx or sp.X > mxx then mxx = sp.X end
			if not mny or sp.Y < mny then mny = sp.Y end
			if not mxy or sp.Y > mxy then mxy = sp.Y end
		end
	end

	if not os or not mnx then
		d.bf.Visible = false
		return
	end

	d.bf.Visible = true

	local bw = mxx - mnx
	local bh = mxy - mny
	local cx = (mnx + mxx) / 2
	local cy = (mny + mxy) / 2

	d.bf.Size = UDim2.new(0, bw, 0, bh)
	d.bf.Position = UDim2.new(0, cx - bw / 2, 0, cy - bh / 2)

	if p.Team then
		d.bs.Color = p.Team.TeamColor.Color
	else
		d.bs.Color = Color3.fromRGB(255, 255, 255)
	end
end

local function ue()
	for _, p in ipairs(plrs:GetPlayers()) do
		if p ~= plr then
			if ee then
				if not et[p] then
					mbox(p)
				end
				uesp(p)
			else
				resp(p)
			end
		end
	end
end

local function tes(s)
	ee = s
	if not ee then
		for p in pairs(et) do
			resp(p)
		end
	else
		for _, p in ipairs(plrs:GetPlayers()) do
			if p ~= plr and p.Character then
				mbox(p)
			end
		end
	end
end

plrs.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		if ee then
			mbox(p)
		end
	end)
end)

plrs.PlayerRemoving:Connect(resp)
rs.RenderStepped:Connect(ue)

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
title.Text = "SRS: arsenal"
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

local selected2 = Instance.new("UIStroke")
selected2.Color = Color3.fromRGB(102, 141, 226)
selected2.Thickness = 5
selected2.BorderOffset = UDim.new(0, -5)
selected2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
selected2.LineJoinMode = Enum.LineJoinMode.Miter

local aimcircletgl = Instance.new("TextButton")
aimcircletgl.Size = UDim2.new(0.5, -1, 0, 32)
aimcircletgl.Position = UDim2.new(0, 0, 1, 2)
aimcircletgl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
aimcircletgl.BorderSizePixel = 0
aimcircletgl.BackgroundTransparency = 0.6
aimcircletgl.Text = "aim circle"
aimcircletgl.Font = Enum.Font.SourceSansBold
aimcircletgl.TextSize = 18
aimcircletgl.TextColor3 = Color3.fromRGB(255, 255, 255)
aimcircletgl.TextYAlignment = Enum.TextYAlignment.Center
aimcircletgl.Parent = container
Instance.new("UIPadding", aimcircletgl).PaddingBottom = UDim.new(0, 2)

local aimcircletoggled = false

aimcircletgl.MouseButton1Click:Connect(function()
	selected.Parent = aimcircletgl
	aimcircletoggled = not aimcircletoggled
	
	if aimcircletoggled then mcirc() else rcirc() end
	
	if not aimcircletoggled then
		selected.Parent = nil
	end
end)

local camlocktgl = Instance.new("TextButton")
camlocktgl.Size = UDim2.new(0.5, -1, 0, 32)
camlocktgl.Position = UDim2.new(0.5, 1, 1, 2)
camlocktgl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
camlocktgl.BorderSizePixel = 0
camlocktgl.BackgroundTransparency = 0.6
camlocktgl.Text = "camlock"
camlocktgl.Font = Enum.Font.SourceSansBold
camlocktgl.TextSize = 18
camlocktgl.TextColor3 = Color3.fromRGB(255, 255, 255)
camlocktgl.TextYAlignment = Enum.TextYAlignment.Center
camlocktgl.Parent = container
Instance.new("UIPadding", camlocktgl).PaddingBottom = UDim.new(0, 2)

local camlocktoggled = false

camlocktgl.MouseButton1Click:Connect(function()
	selected2.Parent = camlocktgl
	camlocktoggled = not camlocktoggled
	
	tcl(camlocktoggled)
	
	if not camlocktoggled then
		selected2.Parent = nil
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local selected3 = Instance.new("UIStroke")
selected3.Color = Color3.fromRGB(102, 141, 226)
selected3.Thickness = 5
selected3.BorderOffset = UDim.new(0, -5)
selected3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
selected3.LineJoinMode = Enum.LineJoinMode.Miter

local selected4 = Instance.new("UIStroke")
selected4.Color = Color3.fromRGB(102, 141, 226)
selected4.Thickness = 5
selected4.BorderOffset = UDim.new(0, -5)
selected4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
selected4.LineJoinMode = Enum.LineJoinMode.Miter

local esptgl = Instance.new("TextButton")
esptgl.Size = UDim2.new(0.5, -1, 0, 32)
esptgl.Position = UDim2.new(0, 0, 1, 36)
esptgl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
esptgl.BorderSizePixel = 0
esptgl.BackgroundTransparency = 0.6
esptgl.Text = "esp"
esptgl.Font = Enum.Font.SourceSansBold
esptgl.TextSize = 18
esptgl.TextColor3 = Color3.fromRGB(255, 255, 255)
esptgl.TextYAlignment = Enum.TextYAlignment.Center
esptgl.Parent = container
Instance.new("UIPadding", esptgl).PaddingBottom = UDim.new(0, 2)

local esptoggled = false

esptgl.MouseButton1Click:Connect(function()
	selected3.Parent = esptgl
	esptoggled = not esptoggled
	
	tes(esptoggled)
	
	if not esptoggled then
		selected3.Parent = nil
	end
end)

local noteamchecktgl = Instance.new("TextButton")
noteamchecktgl.Size = UDim2.new(0.5, -1, 0, 32)
noteamchecktgl.Position = UDim2.new(0.5, 1, 1, 36)
noteamchecktgl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
noteamchecktgl.BorderSizePixel = 0
noteamchecktgl.BackgroundTransparency = 0.6
noteamchecktgl.Text = "no team check"
noteamchecktgl.Font = Enum.Font.SourceSansBold
noteamchecktgl.TextSize = 18
noteamchecktgl.TextColor3 = Color3.fromRGB(255, 255, 255)
noteamchecktgl.TextYAlignment = Enum.TextYAlignment.Center
noteamchecktgl.Parent = container
Instance.new("UIPadding", noteamchecktgl).PaddingBottom = UDim.new(0, 2)

local noteamchecktoggled = false

noteamchecktgl.MouseButton1Click:Connect(function()
	selected4.Parent = noteamchecktgl
	noteamchecktoggled = not noteamchecktoggled
	
	tc = not noteamchecktoggled
	
	if not noteamchecktoggled then
		selected4.Parent = nil
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
