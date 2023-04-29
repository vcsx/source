__ = 

	"Discord: Actyrn#7104, Server: .gg/wDngb2mv4H"

-- Credits to Elegant and Fulcrum, the original script coders

-- If ur gonna put in vault / showcase, pls don't put the source code directly or loadstring, put the discord

-- DO NOT EDIT BELOW IF YOU DON'T KNOW WHAT YOU'RE DOING!!

repeat wait() until game:IsLoaded()

Drawing = Drawing
Actyrn7104 = Actyrn7104
mousemoverel = mousemoverel
hookmetamethod = hookmetamethod
getnamecallmethod = getnamecallmethod

if game.CorePackages.Packages then
	game.CorePackages.Packages:Destroy()
end

-- Variables

local UiLib = loadstring(game:HttpGet("https://pastebin.com/raw/JFzC7iXS"))()
local NotifyLib = loadstring(game:HttpGet("https://pastebin.com/raw/KRep3e1w"))()

local TargetPlr, CamlockPlr
local TargBindEnabled, CamBindEnabled = false, false

local Player = game.Players.LocalPlayer

local RunService = game.RunService
local UserInputService = game.UserInputService

local AntiCheatNamecall, TargNamecall

local StrafeSpeed = 0

local TargDotCircle = Drawing.new("Circle")
local TargFovCircle = Drawing.new("Circle")
local TargTracerLine = Drawing.new("Line")

local SelfDotCircle = Drawing.new("Circle")
local SelfTracerLine = Drawing.new("Line")

local CamFovCircle = Drawing.new("Circle")
local CamTracerLine = Drawing.new("Line")

local TargStats = Instance.new("ScreenGui", game.CoreGui)

local StatsFrame = Instance.new("Frame", TargStats)

local StatsTop = Instance.new("Frame", StatsFrame)

local StatsPicture = Instance.new("ImageLabel", StatsFrame)

local StatsName = Instance.new("TextLabel", StatsFrame)

local StatsHealthBackground = Instance.new("Frame", StatsFrame)
local StatsHealthBar = Instance.new("Frame", StatsHealthBackground)

local StatsGradient1, StatsGradient2 = Instance.new("UIGradient", StatsTop), Instance.new("UIGradient", StatsFrame)
local StatsGradient3, StatsGradient4 = Instance.new("UIGradient", StatsHealthBackground), Instance.new("UIGradient", StatsHealthBar)

local TargHighlight = Instance.new("Highlight", game.CoreGui)

local CamHighlight = Instance.new("Highlight", game.CoreGui)

local TargetAimbot = {
	Enabled = false, 
	Keybind = nil, 

	Prediction = nil, 
	RealPrediction = nil, 

	Resolver = false, 

	JumpOffset = 0, 
	RealJumpOffset = nil, 

	HitParts = {"HumanoidRootPart"}, 
	RealHitPart = nil, 

	AutoPred = false, 
	Notify = false, 

	KoCheck = false, 

	LookAt = false, 
	ViewAt = false, 

	Dot = false, 
	Tracer = false, 

	DotOnCursor = false, 
	Highlight = false, 

	Stats = false, 

	UseFov = false
}

local TargetStrafe = {
	Enabled = false, 

	Speed = 1, 
	Distance = 1, 
	Height = 1
}

local CameraAimbot = {
	Enabled = false, 
	Keybind = nil, 

	Prediction = nil, 
	RealPrediction = nil, 

	Resolver = false, 

	JumpOffset = 0, 
	RealJumpOffset = nil, 

	HitPart = "HumanoidRootPart", 
	RealHitPart = nil, 

	UseAirPart = false, 
	AirPart = "LowerTorso", 
	AirCheckType = "Once in Air", 

	AutoPred = false, 
	Notify = false, 

	KoCheck = false, 
	Tracer = false, 

	Highlight = false, 

	AimMethod = "Camera", 

	Smoothing = false, 
	Smoothness = nil, 

	UseFov = false
}

local Utilities = {
	NoJumpCooldown = false, 
	NoSlowdown = false, 

	AutoStomp = false, 
	AutoReload = false
}

local Movement = {
	SpeedEnabled = false, 
	SpeedAmount = 1, 

	AutoJump = false, 

	BunnyHop = false, 
	HopAmount = 1, 

	FlightEnabled = false, 
	FlightAmount = 1
}

local SelfDot = {
	Enabled = false, 
	Tracer = false, 

	RandomHitPart = false, 
	Prediction = 1, 

	HitPart = "HumanoidRootPart", 
	RealHitPart = nil
}

local AntiLock = {
	Enabled = false, 
	Mode = "Custom", 

	CustomX = 10000, 
	CustomY = 10000, 
	CustomZ = 10000, 

	PredReverseAmt = 3.5, 
	LookVecAmt = 500, 
	PredChangeAmt = 5, 

	DesyncVel = Vector3.new(9e9, 9e9, 9e9), 
	DesyncAngles = 0.5
}

-- Functions

function ClosestPlr(Part, UseFov, FovCircle)
	local Distance, Closest = math.huge, nil

	for I, Target in pairs(game.Players:GetPlayers()) do
		if Target ~= Player then
			local Pos = workspace.CurrentCamera:WorldToViewportPoint(Target.Character[Part].Position)
			local Magnitude = (Vector2.new(Pos.X, Pos.Y) - UserInputService:GetMouseLocation()).Magnitude

			if UseFov then
				if Magnitude < Distance and Magnitude < FovCircle.Radius then
					Closest = Target
					Distance = Magnitude
				end
			else
				if Magnitude < Distance then
					Closest = Target
					Distance = Magnitude
				end
			end
		end
	end

	return Closest
end

-- GUI

-- Check for errors

UiLib:CheckErrors(true, true, Player, __, Actyrn7104) -- If you remove there's a chance script wont work, DON'T REMOVE!!

-- Window

local Actyrn_7104 = UiLib:CreateWindow("Azure Modded | Actyrn#7104 | .gg/wDngb2mv4H", Vector2.new(500, 600), Enum.KeyCode.RightShift)

-- Tabs

local MainTab = Actyrn_7104:CreateTab("Main")
local MiscTab = Actyrn_7104:CreateTab("Misc")

-- Sectors

-- MAIN

local TargetAimbotSec = MainTab:CreateSector("Target Aimbot", "left")
local TargetStrafeSec = MainTab:CreateSector("Target Strafe", "left")

local CameraAimbotSec = MainTab:CreateSector("Camera Aimbot", "right")

-- MISC

local UtilitiesSec = MiscTab:CreateSector("Utilities", "left")
local MovementSec = MiscTab:CreateSector("Movement", "left")
local SelfDotSec = MiscTab:CreateSector("Self Dot", "left")

local AntiLockSec = MiscTab:CreateSector("Anti Lock", "right")

-- Toggles

-- MAIN

-- Target Aimbot

TargetAimbotSec:AddToggle("Enabled", false, function(Value)
	TargetAimbot.Enabled = Value
end)

TargetAimbotSec:AddKeybind("Keybind", nil, function(Value)
	TargetAimbot.Keybind = Value
end)

TargetAimbotSec:AddTextbox("Prediction", nil, function(Value)
	TargetAimbot.Prediction = Value
	TargetAimbot.RealPrediction = Value
end)

local TargResolverTog = TargetAimbotSec:AddToggle("Antilock Resolver", false, function(Value)
	TargetAimbot.Resolver = Value
end)

TargResolverTog:AddKeybind()

TargetAimbotSec:AddSlider("Jump Offset", -2, 0, 2, 100, function(Value)
	TargetAimbot.JumpOffset = Value
	TargetAimbot.RealJumpOffset = Value
end)

TargetAimbotSec:AddDropdown("Hit Part(s)", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "RightUpperArm", "LeftUpperArm", "RightLowerArm", "LeftLowerArm", "RightUpperLeg", "LeftUpperLeg", "RightLowerLeg", "LeftLowerLeg"}, {"HumanoidRootPart"}, true, function(Value)
	TargetAimbot.HitParts = Value
end)

TargetAimbotSec:AddToggle("Auto Pred", false, function(Value)
	TargetAimbot.AutoPred = Value
end)

TargetAimbotSec:AddToggle("Notify", false, function(Value)
	TargetAimbot.Notify = Value
end)

TargetAimbotSec:AddToggle("KO Check", false, function(Value)
	TargetAimbot.KoCheck = Value
end)

TargetAimbotSec:AddToggle("Look At", false, function(Value)
	TargetAimbot.LookAt = Value
end)

local ViewAtTog = TargetAimbotSec:AddToggle("View At", false, function(Value)
	TargetAimbot.ViewAt = Value
end)

ViewAtTog:AddKeybind()

local TargDotTog = TargetAimbotSec:AddToggle("Dot", false, function(Value)
	TargetAimbot.Dot = Value
end)

TargDotTog:AddColorpicker(Color3.fromRGB(170, 120, 210), function(Value)
	TargDotCircle.Color = Value
	TargTracerLine.Color = Value
end)

TargetAimbotSec:AddToggle("Dot on Cursor", false, function(Value)
	TargetAimbot.DotOnCursor = Value
end)

TargetAimbotSec:AddToggle("Tracer", false, function(Value)
	TargetAimbot.Tracer = Value
end)

local TargHighlightTog = TargetAimbotSec:AddToggle("Highlight", false, function(Value)
	TargetAimbot.Highlight = Value
end)

TargHighlightTog:AddColorpicker(Color3.fromRGB(170, 120, 210), function(Value)
	TargHighlight.FillColor = Value
end)

TargHighlightTog:AddColorpicker(Color3.fromRGB(90, 65, 110), function(Value)
	TargHighlight.OutlineColor = Value
end)

TargetAimbotSec:AddToggle("Stats", false, function(Value)
	TargetAimbot.Stats = Value
end)

TargetAimbotSec:AddToggle("Use FOV", false, function(Value)
	TargetAimbot.UseFov = Value
end)

local TargFovTog = TargetAimbotSec:AddToggle("FOV Visible", false, function(Value)
	TargFovCircle.Visible = Value
end)

TargFovTog:AddColorpicker(Color3.fromRGB(80, 15, 180), function(Value)
	TargFovCircle.Color = Value
end)

TargetAimbotSec:AddToggle("FOV Filled", false, function(Value)
	TargFovCircle.Filled = Value
end)

TargetAimbotSec:AddSlider("FOV Transparency", 0, 0.75, 1, 100, function(Value)
	TargFovCircle.Transparency = Value
end)

TargetAimbotSec:AddSlider("FOV Size", 5, 80, 500, 1, function(Value)
	TargFovCircle.Radius = Value * 2
end)

-- Target Strafe

local TargStrafeTog = TargetStrafeSec:AddToggle("Target Strafe", false, function(Value)
	TargetStrafe.Enabled = Value
end)

TargStrafeTog:AddKeybind()

TargetStrafeSec:AddSlider("Speed", 0.5, 0.5, 10, 2, function(Value)
	TargetStrafe.Speed = Value
end)

TargetStrafeSec:AddSlider("Distance", 1, 1, 20, 2, function(Value)
	TargetStrafe.Distance = Value
end)

TargetStrafeSec:AddSlider("Height", 1, 1, 20, 2, function(Value)
	TargetStrafe.Height = Value
end)

-- Camera Aimbot

CameraAimbotSec:AddToggle("Enabled", false, function(Value)
	CameraAimbot.Enabled = Value
end)

CameraAimbotSec:AddKeybind("Keybind", nil, function(Value)
	CameraAimbot.Keybind = Value
end)

CameraAimbotSec:AddTextbox("Prediction", nil, function(Value)
	CameraAimbot.Prediction = Value
	CameraAimbot.RealPrediction = Value
end)

local CamResolverTog = CameraAimbotSec:AddToggle("Antilock Resolver", false, function(Value)
	CameraAimbot.Resolver = Value
end)

CamResolverTog:AddKeybind()

CameraAimbotSec:AddSlider("Jump Offset", -2, 0, 2, 100, function(Value)
	CameraAimbot.JumpOffset = Value
	CameraAimbot.RealJumpOffset = Value
end)

CameraAimbotSec:AddDropdown("Hit Part", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, "HumanoidRootPart", false, function(Value)
	CameraAimbot.HitPart = Value
	CameraAimbot.RealHitPart = Value
end)

CameraAimbotSec:AddToggle("Use Air Part", false, function(Value)
	CameraAimbot.UseAirPart = Value
end)

CameraAimbotSec:AddDropdown("Air Part", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "RightHand", "LeftHand", "RightFoot", "LeftFoot"}, "LowerTorso", false, function(Value)
	CameraAimbot.AirPart = Value
end)

CameraAimbotSec:AddDropdown("Air Check Type", {"Once in Air", "Once Freefalling"}, "Once in Air", false, function(Value)
	CameraAimbot.AirCheckType = Value
end)

CameraAimbotSec:AddToggle("Auto Pred", false, function(Value)
	CameraAimbot.AutoPred = Value
end)

CameraAimbotSec:AddToggle("Notify", false, function(Value)
	CameraAimbot.Notify = Value
end)

CameraAimbotSec:AddToggle("KO Check", false, function(Value)
	CameraAimbot.KoCheck = Value
end)

local CamTracerTog = CameraAimbotSec:AddToggle("Tracer", false, function(Value)
	CameraAimbot.Tracer = Value
end)

CamTracerTog:AddColorpicker(Color3.fromRGB(170, 120, 210), function(Value)
	CamTracerLine.Color = Value
end)

local CamHighlightTog = CameraAimbotSec:AddToggle("Highlight", false, function(Value)
	CameraAimbot.Highlight = Value
end)

CamHighlightTog:AddColorpicker(Color3.fromRGB(170, 120, 210), function(Value)
	CamHighlight.FillColor = Value
end)

CamHighlightTog:AddColorpicker(Color3.fromRGB(90, 65, 110), function(Value)
	CamHighlight.OutlineColor = Value
end)

if game.PlaceId == 9825515356 then
	CameraAimbotSec:AddDropdown("Aim Method", {"Camera", "Mouse"}, "Mouse", false, function(Value)
		CameraAimbot.AimMethod = Value
	end)
else
	CameraAimbotSec:AddDropdown("Aim Method", {"Camera", "Mouse"}, "Camera", false, function(Value)
		CameraAimbot.AimMethod = Value
	end)
end

CameraAimbotSec:AddToggle("Smoothing", false, function(Value)
	CameraAimbot.Smoothing = Value
end)

CameraAimbotSec:AddTextbox("Smoothness", nil, function(Value)
	CameraAimbot.Smoothness = Value
end)

CameraAimbotSec:AddToggle("Use FOV", false, function(Value)
	CameraAimbot.UseFov = Value
end)

local CamFovTog = CameraAimbotSec:AddToggle("FOV Visible", false, function(Value)
	CamFovCircle.Visible = Value
end)

CamFovTog:AddColorpicker(Color3.fromRGB(80, 15, 180), function(Value)
	CamFovCircle.Color = Value
end)

CameraAimbotSec:AddToggle("FOV Filled", false, function(Value)
	CamFovCircle.Filled = Value
end)

CameraAimbotSec:AddSlider("FOV Transparency", 0, 0.75, 1, 100, function(Value)
	CamFovCircle.Transparency = Value
end)

CameraAimbotSec:AddSlider("FOV Size", 5, 80, 500, 1, function(Value)
	CamFovCircle.Radius = Value * 2
end)

-- MISC

-- Utilities

UtilitiesSec:AddToggle("No Jump Cooldown", false, function(Value)
	Utilities.NoJumpCooldown = Value
end)

UtilitiesSec:AddToggle("No Slowdown", false, function(Value)
	Utilities.NoSlowdown = Value
end)

UtilitiesSec:AddToggle("Auto Stomp", false, function(Value)
	Utilities.AutoStomp = Value
end)

UtilitiesSec:AddToggle("Auto Reload", false, function(Value)
	Utilities.AutoReload = Value
end)

local TrashTalkTog = UtilitiesSec:AddToggle("Trash Talk", false, function(Value)
	if Value then
		local TrashTalkWords = {".gg/wDngb2mv4H", "How to aim pls help", "my lil brother was playing AND HE BEAT U LOLOL :rofl:", "Mobile player beat u lol", "420 ping and u got SLAMMED", "ur bad", "seed", "im not locking ur just bad", "clown", "sonned", "LOLL UR BAD", "dont even try..", "ez", "gg = get good", "my grandmas better than u :skull:", "hop off kid", "bro cannot aim", "u got absolutely DOGGED on", "i run this server son", "what is bro doing :skull:", "no way", "my cat walked across my keyboard and beat u LOLL"}

		game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(TrashTalkWords[math.random(#TrashTalkWords)], "All")
	end
end)

TrashTalkTog:AddKeybind()

-- Self Dot

local SelfDotTog = SelfDotSec:AddToggle("Enabled", false, function(Value)
	SelfDot.Enabled = Value
end)

SelfDotTog:AddColorpicker(Color3.fromRGB(170, 120, 210), function(Value)
	SelfDotCircle.Color = Value
	SelfTracerLine.Color = Value
end)

SelfDotSec:AddToggle("Tracer", false, function(Value)
	SelfDot.Tracer = Value
end)

SelfDotSec:AddToggle("Random Hit Part", false, function(Value)
	SelfDot.RandomHitPart = Value
end)

SelfDotSec:AddSlider("Prediction", 1, 1, 5, 2, function(Value)
	SelfDot.Prediction = Value / 20
end)

SelfDotSec:AddDropdown("Hit Part", {"Head", "Torso"}, "Torso", false, function(Value)
	if Value == "Head" then
		SelfDot.HitPart = "Head"
		SelfDot.RealHitPart = "Head"
	else
		SelfDot.HitPart = "HumanoidRootPart"
		SelfDot.RealHitPart = "HumanoidRootPart"
	end
end)

-- Movement

local SpeedTog = MovementSec:AddToggle("Speed", false, function(Value)
	Movement.SpeedEnabled = Value
end)

SpeedTog:AddKeybind()

MovementSec:AddSlider("Speed Amount", 1, 1, 5000, 1, function(Value)
	Movement.SpeedAmount = Value / 1000
end)

MovementSec:AddToggle("Auto Jump", false, function(Value)
	Movement.AutoJump = Value
end)

MovementSec:AddToggle("Bunny Hop", false, function(Value)
	Movement.BunnyHop = Value
end)

MovementSec:AddSlider("Hop Amount", 1, 1, 50, 1, function(Value)
	Movement.HopAmount = Value / 100
end)

local FlightTog = MovementSec:AddToggle("Flight", false, function(Value)
	Movement.FlightEnabled = Value
end)

FlightTog:AddKeybind()

MovementSec:AddSlider("Flight Amount", 1, 1, 5000, 1, function(Value)
	Movement.FlightAmount = Value / 20
end)

-- Anti Lock

local AntiLockTog = AntiLockSec:AddToggle("Enabled", false, function(Value)
	AntiLock.Enabled = Value
end)

AntiLockTog:AddKeybind()

AntiLockSec:AddDropdown("Mode", {"Custom", "Prediction Changer", "Prediction Disabler", "Up", "Down", "Prediction Tripler", "Prediction Reverser", "LookVector", "AirOrthodox", "Prediction Multiplier", "Spinbot Desync"}, "Custom", false, function(Value)
	AntiLock.Mode = Value
end)

AntiLockSec:AddLabel("Custom")

AntiLockSec:AddSlider("Custom X", -10000, 10000, 10000, 1, function(Value)
	AntiLock.CustomX = Value
end)

AntiLockSec:AddSlider("Custom Y", -10000, 10000, 10000, 1, function(Value)
	AntiLock.CustomY = Value
end)

AntiLockSec:AddSlider("Custom Z", -10000, 10000, 10000, 1, function(Value)
	AntiLock.CustomZ = Value
end)

AntiLockSec:AddLabel("Prediction Reverser")

AntiLockSec:AddSlider("Reverse Amount", 0.5, 3.5, 10, 2, function(Value)
	AntiLock.PredReverseAmt = Value
end)

AntiLockSec:AddLabel("LookVector")

AntiLockSec:AddSlider("LookVector Amount", -10000, 5000, 10000, 1, function(Value)
	AntiLock.LookVecAmt = Value
end)

AntiLockSec:AddLabel("Prediction Changer")

AntiLockSec:AddSlider("Prediction Amount", -20, 5, 20, 1, function(Value)
	AntiLock.PredChangeAmt = Value
end)

AntiLockSec:AddLabel("Spinbot Desync")

AntiLockSec:AddDropdown("Desync Velocity", {"Default", "Sky", "Underground"}, "Default", false, function(Value)
	if Value == "Default" then
		AntiLock.DesyncVel = Vector3.new(9e9, 9e9, 9e9)
	elseif Value == "Sky" then
		AntiLock.DesyncVel = Vector3.new(15, 9e9, 15)
	elseif Value == "Underground" then
		AntiLock.DesyncVel = Vector3.new(15, -9e9, 15)
	end
end)

AntiLockSec:AddSlider("Desync Angles", -50, 0.5, 50, 2, function(Value)
	AntiLock.DesyncAngles = Value
end)

-- Code

spawn(function()
	TargDotCircle.Filled = true
	TargDotCircle.Thickness = 1
	TargDotCircle.Radius = 7

	TargFovCircle.Thickness = 1

	TargTracerLine.Thickness = 2

	SelfDotCircle.Filled = true
	SelfDotCircle.Thickness = 1
	SelfDotCircle.Transparency = 1
	SelfDotCircle.Radius = 7

	SelfTracerLine.Thickness = 2

	CamFovCircle.Thickness = 1

	CamTracerLine.Thickness = 2

	TargStats.Name = "Actyrn#7104"
	TargStats.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	StatsFrame.Name = "Actyrn#7104"
	StatsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	StatsFrame.BorderSizePixel = 0
	StatsFrame.Position = UDim2.new(0.388957828, 0, 0.700122297, 0)
	StatsFrame.Size = UDim2.new(0, 360, 0, 70)

	StatsTop.Name = "Actyrn#7104"
	StatsTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	StatsTop.BorderSizePixel = 0
	StatsTop.Position = UDim2.new(0, 0, -0.101449274, 0)
	StatsTop.Size = UDim2.new(0, 360, 0, 7.5)

	StatsPicture.Name = "Actyrn#7104"
	StatsPicture.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	StatsPicture.BorderSizePixel = 0
	StatsPicture.Position = UDim2.new(0.0279329624, 0, 0.0704225376, 0)
	StatsPicture.Size = UDim2.new(0, 60, 0, 60)
	StatsPicture.Transparency = 1
	StatsPicture.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

	StatsName.Name = "Actyrn#7104"
	StatsName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	StatsName.BackgroundTransparency = 1
	StatsName.Position = UDim2.new(0.220670387, 0, 0.0704225376, 0)
	StatsName.Size = UDim2.new(0, 270, 0, 20)
	StatsName.Font = Enum.Font.Code
	StatsName.TextColor3 = Color3.fromRGB(255, 255, 255)
	StatsName.TextScaled = true
	StatsName.TextSize = 15
	StatsName.TextStrokeTransparency = 0
	StatsName.TextWrapped = true

	StatsHealthBackground.Name = "Actyrn#7104"
	StatsHealthBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	StatsHealthBackground.BorderSizePixel = 0
	StatsHealthBackground.Position = UDim2.new(0.215083793, 0, 0.348234326, 0)
	StatsHealthBackground.Size = UDim2.new(0, 270, 0, 20)
	StatsHealthBackground.Transparency = 1

	StatsHealthBar.Name = "Actyrn#7104"
	StatsHealthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	StatsHealthBar.BorderSizePixel = 0
	StatsHealthBar.Position = UDim2.new(-0.00336122862, 0, 0.164894029, 0)
	StatsHealthBar.Size = UDim2.new(0, 130, 0, 20)

	StatsGradient1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(185, 160, 230)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 90, 155))}
	StatsGradient1.Rotation = 90

	StatsGradient2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))}
	StatsGradient2.Rotation = 90

	StatsGradient3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))}
	StatsGradient3.Rotation = 90

	StatsGradient4.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(185, 160, 230)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 90, 155))}
	StatsGradient4.Rotation = 90
end)

-- Heartbeat Functions

spawn(function()
	RunService.Heartbeat:Connect(function()
		if TargetAimbot.Enabled and TargBindEnabled and TargetAimbot.LookAt then
			Player.Character.HumanoidRootPart.CFrame = CFrame.new(Player.Character.HumanoidRootPart.Position, Vector3.new(TargetPlr.Character.HumanoidRootPart.Position.X, Player.Character.HumanoidRootPart.Position.Y, TargetPlr.Character.HumanoidRootPart.Position.Z))
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		local Pos, OnScreen

		if TargetAimbot.Resolver then
			Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(TargetPlr.Character[TargetAimbot.RealHitPart].Position + Vector3.new(0, TargetAimbot.RealJumpOffset, 0) + (TargetPlr.Character.Humanoid.MoveDirection * TargetAimbot.RealPrediction * TargetPlr.Character.Humanoid.WalkSpeed))
		else
			Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(TargetPlr.Character[TargetAimbot.RealHitPart].Position + Vector3.new(0, TargetAimbot.RealJumpOffset, 0) + (TargetPlr.Character[TargetAimbot.RealHitPart].Velocity * TargetAimbot.RealPrediction))
		end

		if TargetAimbot.Enabled and TargBindEnabled and TargetAimbot.Dot then
			if OnScreen then
				TargDotCircle.Visible = true
				TargDotCircle.Position = Vector2.new(Pos.X, Pos.Y)
			else
				TargDotCircle.Visible = false
			end
		else
			if TargetAimbot.Enabled and not TargBindEnabled and TargetAimbot.Dot and TargetAimbot.DotOnCursor then
				TargDotCircle.Visible = true
				TargDotCircle.Position = UserInputService:GetMouseLocation()
			else
				TargDotCircle.Visible = false
			end
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function() 
		local Pos, OnScreen

		if TargetAimbot.Resolver then
			Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(TargetPlr.Character[TargetAimbot.RealHitPart].Position + Vector3.new(0, TargetAimbot.RealJumpOffset, 0) + (TargetPlr.Character.Humanoid.MoveDirection * TargetAimbot.RealPrediction * TargetPlr.Character.Humanoid.WalkSpeed))
		else
			Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(TargetPlr.Character[TargetAimbot.RealHitPart].Position + Vector3.new(0, TargetAimbot.RealJumpOffset, 0) + (TargetPlr.Character[TargetAimbot.RealHitPart].Velocity * TargetAimbot.RealPrediction))
		end

		if TargetAimbot.Enabled and TargBindEnabled and TargetAimbot.Tracer and OnScreen then
			TargTracerLine.Visible = true
			TargTracerLine.From = UserInputService:GetMouseLocation()
			TargTracerLine.To = Vector2.new(Pos.X, Pos.Y)
		else
			TargTracerLine.Visible = false
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		if TargetAimbot.Enabled and TargBindEnabled and TargetAimbot.Stats then
			StatsFrame.Visible = true
			StatsName.Text = TargetPlr.DisplayName .. " [" .. TargetPlr.Name .. "]"
			StatsPicture.Image = "rbxthumb://type=AvatarHeadShot&id=" .. TargetPlr.UserId .. "&w=420&h=420"
			StatsHealthBar:TweenSize(UDim2.new(TargetPlr.Character.Humanoid.Health / TargetPlr.Character.Humanoid.MaxHealth, 0, 1, 0), "In", "Linear", 0.25)
		else
			StatsFrame.Visible = false
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		if TargetAimbot.Enabled and TargBindEnabled and TargetStrafe.Enabled then
			StrafeSpeed = StrafeSpeed + TargetStrafe.Speed

			Player.Character.HumanoidRootPart.CFrame = TargetPlr.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(StrafeSpeed), 0) * CFrame.new(0, TargetStrafe.Height, TargetStrafe.Distance)
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function() 
		local Pos, OnScreen

		if CameraAimbot.Resolver then
			Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (CamlockPlr.Character.Humanoid.MoveDirection * CameraAimbot.RealPrediction * CamlockPlr.Character.Humanoid.WalkSpeed))
		else
			Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (CamlockPlr.Character[CameraAimbot.RealHitPart].Velocity * CameraAimbot.RealPrediction))
		end

		if CameraAimbot.Enabled and CamBindEnabled and CameraAimbot.Tracer and OnScreen then
			CamTracerLine.Visible = true
			CamTracerLine.From = UserInputService:GetMouseLocation()
			CamTracerLine.To = Vector2.new(Pos.X, Pos.Y)
		else
			CamTracerLine.Visible = false
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		Player.Character.Humanoid.UseJumpPower = not Utilities.NoJumpCooldown
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		if Utilities.NoSlowdown then
			local SlowdownEffects = Player.Character.BodyEffects.Movement:FindFirstChild("NoJumping") or Player.Character.BodyEffects.Movement:FindFirstChild("ReduceWalk") or Player.Character.BodyEffects.Movement:FindFirstChild("NoWalkSpeed")

			if SlowdownEffects then
				SlowdownEffects:Destroy()
			end

			if Player.Character.BodyEffects.Reload.Value then
				Player.Character.BodyEffects.Reload.Value = false
			end
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		if Utilities.AutoStomp then
			game.ReplicatedStorage.MainEvent:FireServer("Stomp")
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		if Movement.SpeedEnabled then
			Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame + Player.Character.Humanoid.MoveDirection * Movement.SpeedAmount
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		if Movement.AutoJump and Player.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall and Player.Character.Humanoid.MoveDirection.Magnitude > 0 then
			Player.Character.Humanoid:ChangeState("Jumping")
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		if Movement.BunnyHop and Player.Character.Humanoid.FloorMaterial == Enum.Material.Air then
			Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame + Player.Character.Humanoid.MoveDirection * Movement.HopAmount
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		pcall(function()
			if Movement.FlightEnabled then
				local FlyVelocity = Vector3.new(0, 0.9, 0)

				if not AntiLock.Enabled then
					if not UserInputService:GetFocusedTextBox() then
						if UserInputService:IsKeyDown(Enum.KeyCode.W) then
							FlyVelocity = FlyVelocity + (workspace.CurrentCamera.CoordinateFrame.lookVector * Movement.FlightAmount)
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.A) then
							FlyVelocity = FlyVelocity + (workspace.CurrentCamera.CoordinateFrame.rightVector * -Movement.FlightAmount)
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.S) then
							FlyVelocity = FlyVelocity + (workspace.CurrentCamera.CoordinateFrame.lookVector * -Movement.FlightAmount)
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.D) then
							FlyVelocity = FlyVelocity + (workspace.CurrentCamera.CoordinateFrame.rightVector * Movement.FlightAmount)
						end
					end

					Player.Character.HumanoidRootPart.Velocity = FlyVelocity
					Player.Character.Humanoid:ChangeState("Freefall")
				end
			else
				Player.Character.Humanoid:ChangeState("Landing")
			end
		end)
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		local Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(Player.Character[SelfDot.RealHitPart].Position + (Player.Character[SelfDot.RealHitPart].AssemblyLinearVelocity * SelfDot.Prediction))

		if SelfDot.Enabled and OnScreen then
			SelfDotCircle.Visible = true
			SelfDotCircle.Position = Vector2.new(Pos.X, Pos.Y)
		else
			SelfDotCircle.Visible = false
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function() 
		local Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(Player.Character[SelfDot.RealHitPart].Position + (Player.Character[SelfDot.RealHitPart].AssemblyLinearVelocity * SelfDot.Prediction))

		if SelfDot.Tracer and OnScreen then
			SelfTracerLine.Visible = true
			SelfTracerLine.From = UserInputService:GetMouseLocation()
			SelfTracerLine.To = Vector2.new(Pos.X, Pos.Y)
		else
			SelfTracerLine.Visible = false
		end
	end)
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		if AntiLock.Enabled then
			local Hrp = Player.Character.HumanoidRootPart
			local Vel, AlVel = Hrp.Velocity, Hrp.AssemblyLinearVelocity

			if AntiLock.Mode == "Custom" then
				Hrp.Velocity = Vector3.new(AntiLock.CustomX, AntiLock.CustomY, AntiLock.CustomZ)
				RunService.RenderStepped:Wait()
				Hrp.Velocity = Vel

			elseif AntiLock.Mode == "Prediction Changer" then
				Hrp.Velocity = Vel * AntiLock.PredChangeAmt
				RunService.RenderStepped:Wait()
				Hrp.Velocity = Vel

			elseif AntiLock.Mode == "Prediction Disabler" then
				Hrp.Velocity = Vel * 0
				RunService.RenderStepped:Wait()
				Hrp.Velocity = Vel

			elseif AntiLock.Mode == "Up" then
				Hrp.Velocity = Vector3.new(0, 9e9, 0)
				RunService.RenderStepped:Wait()
				Hrp.Velocity = Vel

			elseif AntiLock.Mode == "Down" then
				Hrp.Velocity = Vector3.new(0, -9e9, 0)
				RunService.RenderStepped:Wait()
				Hrp.Velocity = Vel

			elseif AntiLock.Mode == "Prediction Tripler" then
				Hrp.Velocity = Vel * 3
				RunService.RenderStepped:Wait()
				Hrp.Velocity = Vel

			elseif AntiLock.Mode == "Prediction Reverser" then
				Hrp.CFrame = Hrp.CFrame - Player.Character.Humanoid.MoveDirection * AntiLock.PredReverseAmt / 10

			elseif AntiLock.Mode == "LookVector" then
				Hrp.Velocity = Hrp.CFrame.lookVector * AntiLock.LookVecAmt
				RunService.RenderStepped:Wait()
				Hrp.Velocity = Vel

			elseif AntiLock.Mode == "AirOrthodox" then
				Hrp.Velocity = Vector3.new(77, 77, 77)
				RunService.RenderStepped:Wait()
				Hrp.Velocity = Vel

			elseif AntiLock.Mode == "Prediction Multiplier" then
				Hrp.Velocity = Vel * 7
				RunService.RenderStepped:Wait()
				Hrp.Velocity = Vel

			elseif AntiLock.Mode == "Spinbot Desync" then
				Hrp.AssemblyLinearVelocity = AntiLock.DesyncVel
				Hrp.CFrame = Hrp.CFrame * CFrame.Angles(0, math.rad(AntiLock.DesyncAngles), 0)
				RunService.RenderStepped:Wait()
				Hrp.AssemblyLinearVelocity = AlVel
			end
		end
	end)
end)

-- Stepped Functions

spawn(function()
	RunService.Stepped:Connect(function()
		if TargetAimbot.Enabled and TargBindEnabled and TargetPlr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
			TargetAimbot.RealJumpOffset = TargetAimbot.JumpOffset
		else
			TargetAimbot.RealJumpOffset = 0
		end
	end)
end)

spawn(function()
	RunService.Stepped:Connect(function()
		if TargetAimbot.Enabled then
			TargetAimbot.RealHitPart = TargetAimbot.HitParts[math.random(#TargetAimbot.HitParts)]
			wait(0.6)
		end
	end)
end)

spawn(function()
	RunService.Stepped:Connect(function()
		if TargetAimbot.Enabled and TargBindEnabled and TargetAimbot.AutoPred then
			local Ping = math.floor(game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

			if Ping < 20 then
				TargetAimbot.RealPrediction = 0.1093312

			elseif Ping < 30 then
				TargetAimbot.RealPrediction = 0.112021

			elseif Ping < 40 then
				TargetAimbot.RealPrediction = 0.125011

			elseif Ping < 50 then
				TargetAimbot.RealPrediction = 0.122543

			elseif Ping < 60 then
				TargetAimbot.RealPrediction = 0.1229213

			elseif Ping < 70 then
				TargetAimbot.RealPrediction = 0.13156

			elseif Ping < 80 then
				TargetAimbot.RealPrediction = 0.134352

			elseif Ping < 90 then
				TargetAimbot.RealPrediction = 0.136785

			elseif Ping < 100 then
				TargetAimbot.RealPrediction = 0.14631

			elseif Ping < 110 then
				TargetAimbot.RealPrediction = 0.147512

			elseif Ping < 120 then
				TargetAimbot.RealPrediction = 0.143765

			elseif Ping < 130 then
				TargetAimbot.RealPrediction = 0.156692

			elseif Ping < 140 then
				TargetAimbot.RealPrediction = 0.1223333

			elseif Ping < 150 then
				TargetAimbot.RealPrediction = 0.15175

			elseif Ping < 160 then
				TargetAimbot.RealPrediction = 0.1625124

			elseif Ping < 170 then
				TargetAimbot.RealPrediction = 0.1923111

			elseif Ping < 180 then
				TargetAimbot.RealPrediction = 0.19284

			elseif Ping < 190 then
				TargetAimbot.RealPrediction = 0.166547

			elseif Ping < 200 then
				TargetAimbot.RealPrediction = 0.165566

			elseif Ping < 210 then
				TargetAimbot.RealPrediction = 0.16780

			elseif Ping < 220 then
				TargetAimbot.RealPrediction = 0.165566

			elseif Ping < 230 then
				TargetAimbot.RealPrediction = 0.15692

			elseif Ping < 240 then
				TargetAimbot.RealPrediction = 0.16780

			elseif Ping < 250 then
				TargetAimbot.RealPrediction = 0.16514

			elseif Ping < 260 then
				TargetAimbot.RealPrediction = 0.175566

			elseif Ping < 270 then
				TargetAimbot.RealPrediction = 0.176535

			elseif Ping < 280 then
				TargetAimbot.RealPrediction = 0.181064

			elseif Ping < 290 then
				TargetAimbot.RealPrediction = 0.180223

			elseif Ping < 300 then
				TargetAimbot.RealPrediction = 0.185351
			end
		else
			TargetAimbot.RealPrediction = TargetAimbot.Prediction
		end
	end)
end)

spawn(function()
	RunService.Stepped:Connect(function()
		if CameraAimbot.Enabled and CamBindEnabled and CamlockPlr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
			CameraAimbot.RealJumpOffset = CameraAimbot.JumpOffset
		else
			CameraAimbot.RealJumpOffset = 0
		end
	end)
end)

spawn(function()
	RunService.Stepped:Connect(function()
		local AirCheckType

		if CameraAimbot.AirCheckType == "Once in Air" then
			AirCheckType = CamlockPlr.Character.Humanoid.FloorMaterial == Enum.Material.Air
		else
			AirCheckType = CamlockPlr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall
		end

		if CameraAimbot.Enabled and CamBindEnabled and AirCheckType then
			CameraAimbot.RealHitPart = CameraAimbot.AirPart
		else
			CameraAimbot.RealHitPart = CameraAimbot.HitPart
		end
	end)
end)

spawn(function()
	RunService.Stepped:Connect(function()
		if CameraAimbot.Enabled and CamBindEnabled and CameraAimbot.AutoPred then
			local Ping = math.floor(game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

			if Ping < 20 then
				CameraAimbot.RealPrediction = 0.1093312

			elseif Ping < 30 then
				CameraAimbot.RealPrediction = 0.112021

			elseif Ping < 40 then
				CameraAimbot.RealPrediction = 0.125011

			elseif Ping < 50 then
				CameraAimbot.RealPrediction = 0.122543

			elseif Ping < 60 then
				CameraAimbot.RealPrediction = 0.1229213

			elseif Ping < 70 then
				CameraAimbot.RealPrediction = 0.13156

			elseif Ping < 80 then
				CameraAimbot.RealPrediction = 0.134352

			elseif Ping < 90 then
				CameraAimbot.RealPrediction = 0.136785

			elseif Ping < 100 then
				CameraAimbot.RealPrediction = 0.14631

			elseif Ping < 110 then
				CameraAimbot.RealPrediction = 0.147512

			elseif Ping < 120 then
				CameraAimbot.RealPrediction = 0.143765

			elseif Ping < 130 then
				CameraAimbot.RealPrediction = 0.156692

			elseif Ping < 140 then
				CameraAimbot.RealPrediction = 0.1223333

			elseif Ping < 150 then
				CameraAimbot.RealPrediction = 0.15175

			elseif Ping < 160 then
				CameraAimbot.RealPrediction = 0.1625124

			elseif Ping < 170 then
				CameraAimbot.RealPrediction = 0.1923111

			elseif Ping < 180 then
				CameraAimbot.RealPrediction = 0.19284

			elseif Ping < 190 then
				CameraAimbot.RealPrediction = 0.166547

			elseif Ping < 200 then
				CameraAimbot.RealPrediction = 0.165566

			elseif Ping < 210 then
				CameraAimbot.RealPrediction = 0.16780

			elseif Ping < 220 then
				CameraAimbot.RealPrediction = 0.165566

			elseif Ping < 230 then
				CameraAimbot.RealPrediction = 0.15692

			elseif Ping < 240 then
				CameraAimbot.RealPrediction = 0.16780

			elseif Ping < 250 then
				CameraAimbot.RealPrediction = 0.16514

			elseif Ping < 260 then
				CameraAimbot.RealPrediction = 0.175566

			elseif Ping < 270 then
				CameraAimbot.RealPrediction = 0.176535

			elseif Ping < 280 then
				CameraAimbot.RealPrediction = 0.181064

			elseif Ping < 290 then
				CameraAimbot.RealPrediction = 0.180223

			elseif Ping < 300 then
				CameraAimbot.RealPrediction = 0.185351
			end
		else
			CameraAimbot.RealPrediction = CameraAimbot.Prediction
		end
	end)
end)

RunService.Stepped:Connect(function()
	if Utilities.AutoReload and Player.Character:FindFirstChildWhichIsA("Tool").Ammo.Value <= 0 then
		game.ReplicatedStorage.MainEvent:FireServer("Reload", Player.Character:FindFirstChildWhichIsA("Tool"))
	end
end)

-- RenderStepped Functions

spawn(function()
	RunService.RenderStepped:Connect(function()
		if TargetAimbot.Enabled and TargBindEnabled and TargetAimbot.KoCheck and (TargetPlr.Character.Humanoid.Health <= 2 or Player.Character.Humanoid.Health <= 2) then
			TargBindEnabled = false
		end
	end)
end)

spawn(function()
	RunService.RenderStepped:Connect(function()
		if TargetAimbot.Enabled and TargBindEnabled and TargetAimbot.ViewAt then
			workspace.CurrentCamera.CameraSubject = TargetPlr.Character.Humanoid
		else
			workspace.CurrentCamera.CameraSubject = Player.Character.Humanoid
		end
	end)
end)

spawn(function()
	RunService.RenderStepped:Connect(function()
		if TargetAimbot.Enabled and TargBindEnabled and TargetAimbot.Highlight then
			TargHighlight.Parent = TargetPlr.Character
		else
			TargHighlight.Parent = game.CoreGui
		end
	end)
end)

spawn(function()
	RunService.RenderStepped:Connect(function()
		TargFovCircle.Position = UserInputService:GetMouseLocation()
	end)
end)

spawn(function()
	RunService.RenderStepped:Connect(function()
		if CameraAimbot.Enabled and CamBindEnabled then
			if CameraAimbot.AimMethod == "Camera" then
				if CameraAimbot.Resolver then
					if CameraAimbot.Smoothing then
						workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.p, CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (CamlockPlr.Character.Humanoid.MoveDirection * CameraAimbot.RealPrediction * CamlockPlr.Character.Humanoid.WalkSpeed)), CameraAimbot.Smoothness, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
					else
						workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (CamlockPlr.Character.Humanoid.MoveDirection * CameraAimbot.RealPrediction * CamlockPlr.Character.Humanoid.WalkSpeed))
					end
				else
					if CameraAimbot.Smoothing then
						workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.p, CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (CamlockPlr.Character[CameraAimbot.RealHitPart].Velocity * CameraAimbot.RealPrediction)), CameraAimbot.Smoothness, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
					else
						workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (CamlockPlr.Character[CameraAimbot.RealHitPart].Velocity * CameraAimbot.RealPrediction))
					end
				end
			else
				local Pos

				if CameraAimbot.Resolver then
					Pos = workspace.CurrentCamera:WorldToViewportPoint(CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (CamlockPlr.Character.Humanoid.MoveDirection * CameraAimbot.RealPrediction * CamlockPlr.Character.Humanoid.WalkSpeed))
				else
					Pos = workspace.CurrentCamera:WorldToViewportPoint(CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (CamlockPlr.Character[CameraAimbot.RealHitPart].Velocity * CameraAimbot.RealPrediction))
				end

				if CameraAimbot.Smoothing then
					mousemoverel((Pos.X - UserInputService:GetMouseLocation().X) * CameraAimbot.Smoothness, (Pos.Y - UserInputService:GetMouseLocation().Y) * CameraAimbot.Smoothness)
				else
					mousemoverel(Pos.X - UserInputService:GetMouseLocation().X, Pos.Y - UserInputService:GetMouseLocation().Y)
				end
			end
		end
	end)
end)

spawn(function()
	RunService.RenderStepped:Connect(function()
		if CameraAimbot.Enabled and CamBindEnabled and CameraAimbot.KoCheck and (CamlockPlr.Character.Humanoid.Health <= 2 or Player.Character.Humanoid.Health <= 2) then
			CamBindEnabled = false
		end
	end)
end)

spawn(function()
	RunService.RenderStepped:Connect(function()
		if CameraAimbot.Enabled and CamBindEnabled and CameraAimbot.Highlight then
			CamHighlight.Parent = CamlockPlr.Character
		else
			CamHighlight.Parent = game.CoreGui
		end
	end)
end)

spawn(function()
	RunService.RenderStepped:Connect(function()
		CamFovCircle.Position = UserInputService:GetMouseLocation()
	end)
end)

spawn(function()
	RunService.RenderStepped:Connect(function()
		if (SelfDot.Enabled or SelfDot.Tracer) and SelfDot.RandomHitPart then
			local RandomHitParts = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "RightUpperArm", "LeftUpperArm", "RightLowerArm", "LeftLowerArm", "RightUpperLeg", "LeftUpperLeg", "RightLowerLeg", "LeftLowerLeg"}

			SelfDot.RealHitPart = RandomHitParts[math.random(#RandomHitParts)]
			wait(0.6)
		else
			SelfDot.RealHitPart = SelfDot.HitPart
		end
	end)
end)

-- InputBegan Functions

spawn(function()
	UserInputService.InputBegan:Connect(function(Key)
		if Key.KeyCode == TargetAimbot.Keybind and TargetAimbot.Enabled and not UserInputService:GetFocusedTextBox() then
			local Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(ClosestPlr(TargetAimbot.RealHitPart, TargetAimbot.UseFov, TargFovCircle).Character[TargetAimbot.RealHitPart].Position)

			if TargBindEnabled then
				TargBindEnabled = false

				if TargetAimbot.Notify then
					NotifyLib.Notify({
						Title = "Azure Modded [Actyrn#7104]", 
						Description = "Untargeting: " .. TargetPlr.DisplayName, 
						Duration = 3
					})
				end
			else
				if OnScreen then
					TargBindEnabled = true
					TargetPlr = ClosestPlr(TargetAimbot.RealHitPart, TargetAimbot.UseFov, TargFovCircle)

					if TargetAimbot.Notify then
						NotifyLib.Notify({
							Title = "Azure Modded [Actyrn#7104]", 
							Description = "Targeting: " .. TargetPlr.DisplayName, 
							Duration = 3
						})
					end
				end
			end
		end
	end)
end)

spawn(function()
	UserInputService.InputBegan:Connect(function(Key)
		if Key.KeyCode == CameraAimbot.Keybind and CameraAimbot.Enabled and not UserInputService:GetFocusedTextBox() then
			local Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(ClosestPlr(CameraAimbot.RealHitPart, CameraAimbot.UseFov, CamFovCircle).Character[CameraAimbot.RealHitPart].Position)

			if CamBindEnabled then
				CamBindEnabled = false

				if CameraAimbot.Notify then
					NotifyLib.Notify({
						Title = "Azure Modded [Actyrn#7104]", 
						Description = "Untargeting: " .. CamlockPlr.DisplayName, 
						Duration = 3
					})
				end
			else
				if OnScreen then
					CamBindEnabled = true
					CamlockPlr = ClosestPlr(CameraAimbot.RealHitPart, CameraAimbot.UseFov, CamFovCircle)

					if CameraAimbot.Notify then
						NotifyLib.Notify({
							Title = "Azure Modded [Actyrn#7104]", 
							Description = "Targeting: " .. CamlockPlr.DisplayName, 
							Duration = 3
						})
					end
				end
			end
		end
	end)
end)

-- Hookmetamethod functions

AntiCheatNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
	local Args = {...}
	local AntiCheatTable = {"BreathingHAMON", "TeleportDetect", "JJARC", "TakePoisonDamage", "CHECKER_1", "CHECKER", "GUI_CHECK", "OneMoreTime", "checkingSPEED", "BANREMOTE", "PERMAIDBAN", "KICKREMOTE", "BR_KICKPC", "FORCEFIELD", "Christmas_Sock", "VirusCough", "Symbiote", "Symbioted", "RequestAFKDisplay"}

	if table.find(AntiCheatTable, Args[1]) then
		return
	end

	return AntiCheatNamecall(Self, ...)
end)

TargNamecall = hookmetamethod(game, "__namecall", function(...)
	local Args = {...}
	local MousePosTable = {"UpdateMousePos", "GetMousePos", "MousePos"}

	if TargetAimbot.Enabled and TargBindEnabled and getnamecallmethod() == "FireServer" and table.find(MousePosTable, Args[2]) then
		if TargetAimbot.Resolver then
			Args[3] = TargetPlr.Character[TargetAimbot.RealHitPart].Position + Vector3.new(0, TargetAimbot.RealJumpOffset, 0) + (TargetPlr.Character.Humanoid.MoveDirection * TargetAimbot.RealPrediction * TargetPlr.Character.Humanoid.WalkSpeed)
		else
			Args[3] = TargetPlr.Character[TargetAimbot.RealHitPart].Position + Vector3.new(0, TargetAimbot.RealJumpOffset, 0) + (TargetPlr.Character[TargetAimbot.RealHitPart].Velocity * TargetAimbot.RealPrediction)
		end

		return TargNamecall(unpack(Args))
	end

	return TargNamecall(...)
end)
