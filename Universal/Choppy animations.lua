-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-------------------------------------------------------------------------------------------------------------------------------

local stepamount = 0.06
local steprate = 0.04

local activetracks = {}

local function choppy(track)
	if activetracks[track] then return end
	activetracks[track] = true

	task.spawn(function()
		while track.Looped or track.IsPlaying do
			pcall(function()
				track:AdjustSpeed(0)

				track.TimePosition += stepamount
			end)

			task.wait(steprate)
		end

		activetracks[track] = nil
	end)
end

-------------------------------------------------------------------------------------------------------------------------------

hum.AnimationPlayed:Connect(function(track)
	choppy(track)
end)

for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
	choppy(t)
end

hum.Died:Connect(function()
	for track in pairs(activetracks) do
		track:Stop()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
