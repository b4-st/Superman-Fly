local UserInputService = game.UserInputService
local TweenService = game.TweenService
local RunService = game["Run Service"]
local CurrentCamera = game.Workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local IdleAnim = Instance.new("Animation")
IdleAnim.AnimationId = "rbxassetid://10921144709"
local FlyAnim = Instance.new("Animation")
FlyAnim.AnimationId = "rbxassetid://10921294559"
local LoadIdle = Humanoid:LoadAnimation(IdleAnim)
local LoadFly = Humanoid:LoadAnimation(FlyAnim)
LoadIdle.Priority = Enum.AnimationPriority.Action
LoadFly.Priority = Enum.AnimationPriority.Action
LoadIdle.Looped = true
LoadFly.Looped = true

local FlyPart = Instance.new("Part")
FlyPart.Anchored = true
FlyPart.CanCollide = false
FlyPart.Transparency = 1
FlyPart.Size = HumanoidRootPart.Size
FlyPart.CFrame = HumanoidRootPart.CFrame
FlyPart.Parent = CurrentCamera

local FlySpeed = 1
local EquipFunction = false
local Equipped = false
local Enabled = false

local FlyTool = Instance.new("Tool")
FlyTool.Name = "Fly"
FlyTool.RequiresHandle = false
FlyTool.CanBeDropped = false
FlyTool.Parent = LocalPlayer.Backpack

FlyTool.Equipped:Connect(function()
	FlyPart.CFrame = HumanoidRootPart.CFrame
	Equipped = true
end)
FlyTool.Unequipped:Connect(function()
	Equipped = false
	Enabled = false
end)
FlyTool.Activated:Connect(function()
	Enabled = true
end)
FlyTool.Deactivated:Connect(function()
	Enabled = false
end)

LocalPlayer.CharacterAdded:Connect(function()
	Character = LocalPlayer.Character or LocalPlayer.CharactedAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	FlyTool.Parent = LocalPlayer.Backpack
	FlyPart.Size = HumanoidRootPart.Size
	FlyPart.CFrame = HumanoidRootPart.CFrame
	EquipFunction = false
	Equipped = false
	Enabled = false
	LoadIdle = Humanoid:LoadAnimation(IdleAnim)
	LoadFly = Humanoid:LoadAnimation(FlyAnim)
	LoadIdle.Priority = Enum.AnimationPriority.Action
	LoadFly.Priority = Enum.AnimationPriority.Action
	LoadFly:AdjustSpeed(0)
	LoadFly.TimePosition = 0.5
end)

LocalPlayer.Chatted:Connect(function(Message)
	local SplitMessage = string.split(Message, " ")
	if string.lower(SplitMessage[1]) == "/e" and string.lower(SplitMessage[2]) == "flyspeed" then
		if tonumber(SplitMessage[3]) ~= nil then
			FlySpeed = tonumber(SplitMessage[3])
		end
	end
end)

RunService.Heartbeat:Connect(function()
	if HumanoidRootPart then
		if Equipped then
			HumanoidRootPart.Anchored = true
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
			Humanoid.AutoRotate = false
			EquipFunction = true

			if not Enabled then
				if not LoadIdle.IsPlaying then
					LoadIdle:Play()
				end
				LoadFly:Stop()
				local Tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.25), {
					CFrame = CFrame.lookAt(HumanoidRootPart.Position, HumanoidRootPart.Position + CurrentCamera.CFrame.LookVector)
				})
				Tween:Play()
			else
				if not LoadFly.IsPlaying then
					LoadFly:Play(0.1)
					LoadFly:AdjustSpeed(0)
					LoadFly.TimePosition = 0.5
				end
				LoadIdle:Stop()
				local LookVector = (Mouse.Hit.Position - CurrentCamera.CFrame.Position).Unit
				local FlyCFrame = CFrame.lookAt(HumanoidRootPart.Position, HumanoidRootPart.Position + LookVector)*CFrame.Angles(math.rad(-65), 0, 0)
				local Tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.25), {
					CFrame = FlyCFrame + LookVector * (6 * FlySpeed)
				})
				Tween:Play()
			end
		else
			if EquipFunction == true then
				EquipFunction = false
				LoadIdle:Stop()
				LoadFly:Stop()
				HumanoidRootPart.Anchored = false
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
				TweenService:Create(HumanoidRootPart, TweenInfo.new(0), {
					CFrame = HumanoidRootPart.CFrame
				}):Play()
				Humanoid.AutoRotate = true
			end
		end
	end
end)
