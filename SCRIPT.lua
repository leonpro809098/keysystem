--[[
    ================================================================
    [ SCRIPT INFORMATION ]
    Project: Custom Script
    Author: OYB
    YouTube: https://www.youtube.com/channel/UCAlXXV1Hbvf7WbfXARuVtiQ
    
    [ TERMS AND CONDITIONS ]
    - You ARE allowed to use and modify this script for your own games.
    - You ARE NOT allowed to re-upload, redistribute, or claim 
      ownership of this script.
    - Removing or altering these credits is strictly prohibited.
    
    Copyright (c) 2026 OYB. All rights reserved.
    ================================================================
]]

-- ⚠️ IMPORTANT: Put this code at the VERY TOP of your Main Script (before obfuscating) ⚠️

local ProtectionConfig = {
    -- 🔴 CRITICAL: This MUST exactly match the 'Secret' value in your Key System's Config!
    -- If your Key System has: Secret = "Test"
    -- Then this must also be: SecretKey = "Test"
    SecretKey = "Leonpro809098",
    
    -- The name of your Hub (shown in the kick message if they try to bypass)
    HubName = "Sovich HUB"
}

-- Anti-Bypass Logic: Checks if the Key System successfully set the global variable
if not _G[ProtectionConfig.SecretKey] then
    local player = game:GetService("Players").LocalPlayer
    if player then
        player:Kick("\n🛡️ Unauthorized Execution 🛡️\n\nPlease use the official Key System to run " .. ProtectionConfig.HubName)
    end
    return -- Stops the rest of the script from loading!
end

-------------------------------------------------------------------------------
-- 👇 YOUR MAIN SCRIPT CODE STARTS HERE 👇
-------------------------------------------------------------------------------

print(ProtectionConfig.HubName .. " Loaded Successfully!") 

--[[
    SOVICH HUB  v4.0
    Universal overlay · TWD3
    UI profesional, inf jump, restore de hitbox/noclip/fly, unload limpio
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RS = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local COL = {
	bg = Color3.fromRGB(7, 8, 10),
	surface = Color3.fromRGB(16, 18, 22),
	elevated = Color3.fromRGB(23, 27, 33),
	fg = Color3.fromRGB(236, 236, 236),
	muted = Color3.fromRGB(138, 144, 152),
	subtle = Color3.fromRGB(92, 99, 108),
	border = Color3.fromRGB(42, 46, 53),
	accent = Color3.fromRGB(216, 220, 226),
	ok = Color3.fromRGB(121, 214, 165),
	danger = Color3.fromRGB(224, 139, 139),
}

local settings = {
	aimEnabled = false,
	aimSmoothness = 5,
	aimKey = Enum.UserInputType.MouseButton2,
	aimbotTargeting = false,
	targetPart = "Head",
	fovRadius = 140,
	fovCircle = true,
	espEnabled = false,
	espBoxesEnabled = true,
	espNamesEnabled = true,
	espTracersEnabled = true,
	espHealthEnabled = true,
	espDistanceEnabled = true,
	espColor = Color3.fromRGB(216, 220, 226),
	flyEnabled = false,
	noclipEnabled = false,
	speedEnabled = false,
	jumpEnabled = false,
	infJump = false,
	bhopEnabled = false,
	noFall = false,
	hitboxEnabled = false,
	spinbotEnabled = false,
	spinbotSpeed = 20,
	hitboxSize = 5,
	flySpeed = 50,
	customSpeed = 32,
	customJump = 100,
	tpSearchText = "",
	skinsEnabled = false,
	skinMaterial = Enum.Material.Neon,
	weaponColor = Color3.fromRGB(125, 255, 180),
	watermark = true,
	crosshair = false,
	fullbright = false,
	antiAfk = true,
}

local defaultWalkSpeed = 16
local defaultJumpPower = 50
local defaultJumpHeight = 7.2
local lightingBackup = {
	Ambient = Lighting.Ambient,
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
}

local okWeapon, WeaponConfig = pcall(function()
	return require(RS:WaitForChild("Config", 2):WaitForChild("WeaponConfig", 2))
end)
if not okWeapon then
	WeaponConfig = nil
end

local knifeBases = {
	"ButterflyKnife", "ClassKnife", "CordKnife", "FlipKnife", "GutKnife",
	"OutDoorKnife", "TacticalKnife", "Karambit", "Kukri", "Wakizashi",
	"CrookSword", "Axe", "Chainsaw", "Shovel", "Skeleton", "RadishBlade",
	"Lollipop", "Trumpet", "Bayonet_M9", "BeamSaber", "PrismTwins",
	"ScalySawTeeth", "Glove",
}
local sniperBases = {
	"SSG", "Kar98k", "AWP", "M82A1", "M200", "DSR1", "NTW20", "WA2000",
	"Sniper1", "Sniper2", "Specter", "Crossbow",
}

local function isKnifeBase(base)
	for _, b in ipairs(knifeBases) do
		if base == b then
			return true
		end
	end
	return false
end

local backups = {}
local function backupBase(baseKey)
	if backups[baseKey] or not WeaponConfig or not WeaponConfig[baseKey] then
		return
	end
	local base = WeaponConfig[baseKey]
	local b = {
		Display = base.Display,
		Image = base.Image,
		SoundGroup = base.SoundGroup,
		MeleeSeq = base.MeleeSeq,
		ControllerComponents = base.ControllerComponents,
	}
	local parent = base.FirstPersonModel and base.FirstPersonModel.Parent
	if parent then
		b.FP = parent:FindFirstChild("FirstPerson") or parent:FindFirstChild("PrimeraPersona")
		b.TP = parent:FindFirstChild("ThirdPerson") or parent:FindFirstChild("TerceraPersona")
	end
	b.FakeArmAnims = {}
	for n, a in pairs(base.FakeArmAnims or {}) do
		if typeof(a) == "Instance" then
			b.FakeArmAnims[n] = a
		end
	end
	b.CharacterAnims = {}
	for n, a in pairs(base.CharacterAnims or {}) do
		if typeof(a) == "Instance" then
			b.CharacterAnims[n] = a
		end
	end
	backups[baseKey] = b
end

local function resetBase(baseKey)
	if not WeaponConfig or not WeaponConfig[baseKey] or not backups[baseKey] then
		return
	end
	local base = WeaponConfig[baseKey]
	local b = backups[baseKey]
	local parent = base.FirstPersonModel and base.FirstPersonModel.Parent
	if parent then
		local fp = parent:FindFirstChild("FirstPerson") or parent:FindFirstChild("PrimeraPersona")
		local tp = parent:FindFirstChild("ThirdPerson") or parent:FindFirstChild("TerceraPersona")
		if fp and fp ~= b.FP then
			fp:Destroy()
		end
		if tp and tp ~= b.TP then
			tp:Destroy()
		end
		if b.FP then
			b.FP.Name = "FirstPerson"
			b.FP.Parent = parent
		end
		if b.TP then
			b.TP.Name = "ThirdPerson"
			b.TP.Parent = parent
		end
	end
	base.FirstPersonModel = b.FP
	base.Display = b.Display
	base.Image = b.Image
	base.SoundGroup = b.SoundGroup
	base.MeleeSeq = b.MeleeSeq
	base.ControllerComponents = b.ControllerComponents
	if b.FakeArmAnims then
		for n, a in pairs(b.FakeArmAnims) do
			base.FakeArmAnims[n] = a
		end
	end
	if b.CharacterAnims then
		for n, a in pairs(b.CharacterAnims) do
			base.CharacterAnims[n] = a
		end
	end
end

local function swapWeapon(baseKey, exoticKey)
	if not WeaponConfig then
		return
	end
	local base = WeaponConfig[baseKey]
	local exotic = WeaponConfig[exoticKey]
	if not base or not exotic then
		return
	end
	local baseFP = base.FirstPersonModel
	local exoFP = exotic.FirstPersonModel
	if typeof(baseFP) ~= "Instance" or typeof(exoFP) ~= "Instance" then
		return
	end
	local baseParent = baseFP.Parent
	local exoParent = exoFP.Parent
	local oldFP = baseParent:FindFirstChild("FirstPerson") or baseParent:FindFirstChild("PrimeraPersona")
	local oldTP = baseParent:FindFirstChild("ThirdPerson") or baseParent:FindFirstChild("TerceraPersona")
	local newFP = exoParent:FindFirstChild("FirstPerson") or exoParent:FindFirstChild("PrimeraPersona") or exoFP
	local newTP = exoParent:FindFirstChild("ThirdPerson") or exoParent:FindFirstChild("TerceraPersona")
	if oldFP and oldFP ~= newFP then
		oldFP.Name = "FirstPerson_OLD"
	end
	if oldTP and oldTP ~= newTP then
		oldTP.Name = "ThirdPerson_OLD"
	end
	local clonedFP = newFP:Clone()
	clonedFP.Name = "FirstPerson"
	clonedFP.Parent = baseParent
	base.FirstPersonModel = clonedFP
	if newTP then
		local clonedTP = newTP:Clone()
		clonedTP.Name = "ThirdPerson"
		clonedTP.Parent = baseParent
	end
	if exotic.FakeArmAnims then
		for name, anim in pairs(exotic.FakeArmAnims) do
			if typeof(anim) == "Instance" then
				base.FakeArmAnims[name] = anim
			end
		end
	end
	if exotic.CharacterAnims then
		for name, anim in pairs(exotic.CharacterAnims) do
			if typeof(anim) == "Instance" then
				base.CharacterAnims[name] = anim
			end
		end
	end
	base.Display = exotic.Display
	base.Image = exotic.Image
	if exotic.SoundGroup and typeof(exotic.SoundGroup) == "Instance" then
		base.SoundGroup = exotic.SoundGroup:Clone()
	end
	if exotic.MeleeSeq then
		base.MeleeSeq = exotic.MeleeSeq
	end
	if exotic.ControllerComponents then
		base.ControllerComponents = exotic.ControllerComponents
	end
end

local function applySkin(skinKey)
	if not WeaponConfig or not WeaponConfig[skinKey] then
		return
	end
	local allBases = {}
	for k, v in pairs(WeaponConfig) do
		if type(k) == "string" and not k:find("%.") and v.FirstPersonModel then
			allBases[k] = true
		end
	end
	local function getBaseKey(sKey)
		if allBases[sKey] then
			return sKey
		end
		for segment in sKey:gmatch("[^%.]+") do
			if allBases[segment] then
				return segment
			end
		end
		return sKey:match("^([^%.]+)")
	end
	local baseKey = getBaseKey(skinKey)
	if not baseKey or not WeaponConfig[baseKey] then
		return
	end
	if isKnifeBase(baseKey) then
		baseKey = "ClassKnife"
	end
	if not WeaponConfig[baseKey] then
		return
	end
	backupBase(baseKey)
	swapWeapon(baseKey, skinKey)
end

local function getHeadPart(char)
	if not char then
		return nil
	end
	return char:FindFirstChild("Head") or char:FindFirstChild("FakeHead") or char:FindFirstChild("head")
end

local function getRootPart(char)
	if not char then
		return nil
	end
	return char:FindFirstChild("HumanoidRootPart")
		or char:FindFirstChild("UpperTorso")
		or char:FindFirstChild("Torso")
		or getHeadPart(char)
		or char:FindFirstChildOfClass("BasePart")
end

local function getTargetPart(char)
	if settings.targetPart == "Torso" then
		return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or getHeadPart(char)
	end
	return getHeadPart(char) or getRootPart(char)
end

local function setupCharacter(char)
	local humanoid = char:WaitForChild("Humanoid", 5)
	if humanoid then
		if not settings.speedEnabled then
			defaultWalkSpeed = humanoid.WalkSpeed
		end
		if not settings.jumpEnabled then
			defaultJumpPower = humanoid.JumpPower
			defaultJumpHeight = humanoid.JumpHeight
		end
		humanoid.AutoRotate = not settings.spinbotEnabled
		if settings.noFall then
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		end
	end
end

if localPlayer.Character then
	task.spawn(setupCharacter, localPlayer.Character)
end
localPlayer.CharacterAdded:Connect(setupCharacter)

local connections = {}
local function bind(conn)
	table.insert(connections, conn)
	return conn
end

local function getGuiParent()
	local ok, hui = pcall(function()
		return gethui()
	end)
	if ok and hui then
		return hui
	end
	return localPlayer:WaitForChild("PlayerGui")
end

for _, g in ipairs(getGuiParent():GetChildren()) do
	if g.Name:match("^SovichHub_") then
		g:Destroy()
	end
end

local gui = Instance.new("ScreenGui")
gui.Name = "SovichHub_" .. tostring(math.random(11111, 99999))
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = getGuiParent()

local function corner(inst, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = inst
	return c
end

local function stroke(inst, color, t)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = t or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = inst
	return s
end

local function pad(inst, p)
	local u = Instance.new("UIPadding")
	u.PaddingTop = UDim.new(0, p)
	u.PaddingBottom = UDim.new(0, p)
	u.PaddingLeft = UDim.new(0, p)
	u.PaddingRight = UDim.new(0, p)
	u.Parent = inst
	return u
end

local notifyHolder = Instance.new("Frame")
notifyHolder.Name = "Toasts"
notifyHolder.AnchorPoint = Vector2.new(1, 1)
notifyHolder.Position = UDim2.new(1, -16, 1, -16)
notifyHolder.Size = UDim2.new(0, 240, 0, 200)
notifyHolder.BackgroundTransparency = 1
notifyHolder.Parent = gui
local notifyLayout = Instance.new("UIListLayout")
notifyLayout.FillDirection = Enum.FillDirection.Vertical
notifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifyLayout.Padding = UDim.new(0, 6)
notifyLayout.Parent = notifyHolder

local function notify(text)
	local f = Instance.new("TextLabel")
	f.Size = UDim2.new(1, 0, 0, 32)
	f.BackgroundColor3 = COL.elevated
	f.Text = text
	f.TextColor3 = COL.fg
	f.Font = Enum.Font.GothamMedium
	f.TextSize = 12
	f.Parent = notifyHolder
	corner(f, 6)
	stroke(f, COL.border, 1)
	task.delay(2.2, function()
		if f.Parent then
			TweenService:Create(f, TweenInfo.new(0.18), { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
			task.wait(0.2)
			f:Destroy()
		end
	end)
end

local watermark = Instance.new("TextLabel")
watermark.BackgroundTransparency = 1
watermark.Position = UDim2.new(0, 16, 0, 12)
watermark.Size = UDim2.new(0, 160, 0, 28)
watermark.Font = Enum.Font.GothamMedium
watermark.Text = "SOVICH   v4.0"
watermark.TextColor3 = COL.muted
watermark.TextSize = 11
watermark.TextXAlignment = Enum.TextXAlignment.Left
watermark.Parent = gui

local cross = Instance.new("Frame")
cross.Name = "Crosshair"
cross.AnchorPoint = Vector2.new(0.5, 0.5)
cross.Position = UDim2.new(0.5, 0, 0.5, 0)
cross.Size = UDim2.new(0, 16, 0, 16)
cross.BackgroundTransparency = 1
cross.Visible = false
cross.Parent = gui
local function hair(pos, size)
	local h = Instance.new("Frame")
	h.BackgroundColor3 = COL.fg
	h.BorderSizePixel = 0
	h.Position = pos
	h.Size = size
	h.Parent = cross
end
hair(UDim2.new(0.5, -1, 0, 0), UDim2.new(0, 2, 0, 5))
hair(UDim2.new(0.5, -1, 1, -5), UDim2.new(0, 2, 0, 5))
hair(UDim2.new(0, 0, 0.5, -1), UDim2.new(0, 5, 0, 2))
hair(UDim2.new(1, -5, 0.5, -1), UDim2.new(0, 5, 0, 2))

local fovFrame = Instance.new("Frame")
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Size = UDim2.new(0, settings.fovRadius * 2, 0, settings.fovRadius * 2)
fovFrame.BackgroundTransparency = 1
fovFrame.Visible = false
fovFrame.Parent = gui
corner(fovFrame, 999)
local fovStroke = stroke(fovFrame, settings.espColor, 1)

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 42, 0, 42)
toggleButton.Position = UDim2.new(0, 22, 0, 120)
toggleButton.BackgroundColor3 = COL.bg
toggleButton.Text = "S"
toggleButton.TextColor3 = COL.fg
toggleButton.TextSize = 15
toggleButton.Font = Enum.Font.GothamBold
toggleButton.AutoButtonColor = false
toggleButton.Parent = gui
corner(toggleButton, 12)
stroke(toggleButton, COL.border, 1)

local draggingBtn, dragStartBtn, startPosBtn, btnMoved = false, nil, nil, false
bind(toggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingBtn = true
		btnMoved = false
		dragStartBtn = input.Position
		startPosBtn = toggleButton.Position
	end
end))
bind(UserInputService.InputChanged:Connect(function(input)
	if draggingBtn and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStartBtn
		if math.abs(delta.X) + math.abs(delta.Y) > 4 then
			btnMoved = true
		end
		toggleButton.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X, startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
	end
end))

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 540, 0, 360)
mainFrame.Position = UDim2.new(0.5, -270, 0.5, -180)
mainFrame.BackgroundColor3 = COL.surface
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
corner(mainFrame, 14)
stroke(mainFrame, COL.border, 1)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 42)
topBar.BackgroundColor3 = COL.surface
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
corner(topBar, 14)

local titleText = Instance.new("TextLabel")
titleText.BackgroundTransparency = 1
titleText.Position = UDim2.new(0, 14, 0, 0)
titleText.Size = UDim2.new(0, 210, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "SOVICH v4.0"
titleText.TextColor3 = COL.fg
titleText.TextSize = 12
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = topBar

local liveTag = Instance.new("TextLabel")
liveTag.BackgroundTransparency = 1
liveTag.AnchorPoint = Vector2.new(1, 0.5)
liveTag.Position = UDim2.new(1, -70, 0.5, 1)
liveTag.Size = UDim2.new(0, 34, 0, 16)
liveTag.Font = Enum.Font.GothamMedium
liveTag.Text = "LIVE"
liveTag.TextColor3 = COL.ok
liveTag.TextSize = 9
liveTag.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -10, 0.5, 0)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.BackgroundColor3 = COL.elevated
closeBtn.Text = "x"
closeBtn.TextColor3 = COL.muted
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.AutoButtonColor = false
closeBtn.Parent = topBar
corner(closeBtn, 6)

local draggingMain, dragStartMain, startPosMain = false, nil, nil
bind(topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingMain = true
		dragStartMain = input.Position
		startPosMain = mainFrame.Position
	end
end))
bind(UserInputService.InputChanged:Connect(function(input)
	if draggingMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStartMain
		mainFrame.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
	end
end))
bind(UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingMain = false
		if draggingBtn then
			draggingBtn = false
			if not btnMoved then
				mainFrame.Visible = not mainFrame.Visible
			end
		end
	end
end))

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.new(0, 0, 0, 42)
sidebar.Size = UDim2.new(0, 60, 1, -42)
sidebar.BackgroundColor3 = COL.surface
sidebar.BorderSizePixel = 0
sidebar.ClipsDescendants = true
sidebar.Parent = mainFrame
local sideLine = Instance.new("Frame")
sideLine.BackgroundColor3 = COL.border
sideLine.BorderSizePixel = 0
sideLine.Position = UDim2.new(1, -1, 0, 0)
sideLine.Size = UDim2.new(0, 1, 1, 0)
sideLine.Parent = sidebar
local sideList = Instance.new("UIListLayout")
sideList.Padding = UDim.new(0, 6)
sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideList.Parent = sidebar
local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 10)
sidePad.PaddingLeft = UDim.new(0, 10)
sidePad.PaddingRight = UDim.new(0, 10)
sidePad.Parent = sidebar

local pagesContainer = Instance.new("Frame")
pagesContainer.Position = UDim2.new(0, 60, 0, 42)
pagesContainer.Size = UDim2.new(1, -60, 1, -42)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = mainFrame

local tabs, currentTab, tabButtons = {}, nil, {}

local function createTabContent(name)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = name
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 3
	scroll.ScrollBarImageColor3 = COL.border
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.Visible = false
	scroll.Parent = pagesContainer
	local list = Instance.new("UIListLayout")
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 10)
	list.Parent = scroll
	pad(scroll, 14)
	return scroll
end

local function switchTab(name)
	for n, scroll in pairs(tabs) do
		scroll.Visible = n == name
	end
	currentTab = name
	for n, btn in pairs(tabButtons) do
		btn.TextColor3 = n == name and COL.fg or COL.subtle
		btn.BackgroundColor3 = n == name and COL.elevated or COL.surface
	end
end

local function createSidebarButton(order, name, glyph, associated)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 36, 0, 36)
	btn.BackgroundColor3 = COL.surface
	btn.Text = glyph
	btn.TextColor3 = COL.subtle
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.LayoutOrder = order
	btn.AutoButtonColor = false
	btn.Parent = sidebar
	corner(btn, 10)
	stroke(btn, COL.border, 1)
	tabs[name] = associated
	tabButtons[name] = btn
	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)
	if not currentTab then
		switchTab(name)
	end
	return btn
end

local tabMain = createTabContent("Principal")
local tabCombat = createTabContent("Combate")
local tabMovement = createTabContent("Movimiento")
local tabVisuals = createTabContent("Visuales")
local tabTeleport = createTabContent("Teleport")
local tabSkins = createTabContent("Skins")
local tabConfig = createTabContent("Ajustes")

createSidebarButton(1, "Principal", "P", tabMain)
createSidebarButton(2, "Combate", "C", tabCombat)
createSidebarButton(3, "Movimiento", "M", tabMovement)
createSidebarButton(4, "Visuales", "V", tabVisuals)
createSidebarButton(5, "Teleport", "T", tabTeleport)
createSidebarButton(6, "Skins", "S", tabSkins)
createSidebarButton(7, "Ajustes", "A", tabConfig)

local function sectionLabel(parent, order, text)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, -4, 0, 16)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.GothamMedium
	l.Text = string.upper(text)
	l.TextColor3 = COL.subtle
	l.TextSize = 10
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.LayoutOrder = order
	l.Parent = parent
	return l
end

local function rowFrame(parent, order, h)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1, -4, 0, h or 44)
	f.BackgroundColor3 = COL.elevated
	f.LayoutOrder = order
	f.Parent = parent
	corner(f, 8)
	stroke(f, COL.border, 1)
	return f
end

local function createToggle(parent, order, label, get, set)
	local row = rowFrame(parent, order, 44)
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Position = UDim2.new(0, 12, 0, 0)
	t.Size = UDim2.new(1, -70, 1, 0)
	t.Font = Enum.Font.GothamMedium
	t.Text = label
	t.TextColor3 = COL.fg
	t.TextSize = 13
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = row
	local track = Instance.new("TextButton")
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Position = UDim2.new(1, -12, 0.5, 0)
	track.Size = UDim2.new(0, 36, 0, 20)
	track.BackgroundColor3 = get() and COL.accent or COL.bg
	track.Text = ""
	track.AutoButtonColor = false
	track.Parent = row
	corner(track, 10)
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = get() and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
	knob.BackgroundColor3 = get() and COL.bg or COL.muted
	knob.BorderSizePixel = 0
	knob.Parent = track
	corner(knob, 7)
	local function render()
		local on = get()
		TweenService:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = on and COL.accent or COL.bg }):Play()
		TweenService:Create(knob, TweenInfo.new(0.15), {
			Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
			BackgroundColor3 = on and COL.bg or COL.muted,
		}):Play()
	end
	track.MouseButton1Click:Connect(function()
		set(not get())
		render()
	end)
	return row
end

local function createSlider(parent, order, label, minV, maxV, get, set)
	local row = rowFrame(parent, order, 56)
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Position = UDim2.new(0, 12, 0, 6)
	t.Size = UDim2.new(0.7, 0, 0, 18)
	t.Font = Enum.Font.GothamMedium
	t.Text = label
	t.TextColor3 = COL.fg
	t.TextSize = 12
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = row
	local val = Instance.new("TextLabel")
	val.BackgroundTransparency = 1
	val.Position = UDim2.new(0.7, 0, 0, 6)
	val.Size = UDim2.new(0.3, -12, 0, 18)
	val.Font = Enum.Font.GothamMedium
	val.Text = tostring(get())
	val.TextColor3 = COL.muted
	val.TextSize = 12
	val.TextXAlignment = Enum.TextXAlignment.Right
	val.Parent = row
	local bar = Instance.new("Frame")
	bar.Position = UDim2.new(0, 12, 0, 34)
	bar.Size = UDim2.new(1, -24, 0, 4)
	bar.BackgroundColor3 = COL.bg
	bar.BorderSizePixel = 0
	bar.Parent = row
	corner(bar, 2)
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((get() - minV) / (maxV - minV), 0, 1, 0)
	fill.BackgroundColor3 = COL.accent
	fill.BorderSizePixel = 0
	fill.Parent = bar
	corner(fill, 2)
	local dragging = false
	local function applyFromX(x)
		local alpha = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
		local v = math.floor(minV + alpha * (maxV - minV) + 0.5)
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		val.Text = tostring(v)
		set(v)
	end
	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			applyFromX(input.Position.X)
		end
	end)
	bind(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end))
	bind(UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			applyFromX(input.Position.X)
		end
	end))
	return row
end

local function createAction(parent, order, label, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -4, 0, 40)
	btn.BackgroundColor3 = COL.elevated
	btn.Text = label
	btn.TextColor3 = COL.fg
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.LayoutOrder = order
	btn.AutoButtonColor = false
	btn.Parent = parent
	corner(btn, 8)
	stroke(btn, COL.border, 1)
	btn.MouseButton1Click:Connect(function()
		callback(btn)
	end)
	return btn
end

-- Principal
sectionLabel(tabMain, 1, "Movimiento rapido")
createToggle(tabMain, 2, "Speed", function()
	return settings.speedEnabled
end, function(v)
	settings.speedEnabled = v
	if not v and localPlayer.Character then
		local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = defaultWalkSpeed
		end
	end
	notify(v and "Speed ON" or "Speed OFF")
end)
createSlider(tabMain, 3, "WalkSpeed", 16, 150, function()
	return settings.customSpeed
end, function(v)
	settings.customSpeed = v
end)
createToggle(tabMain, 4, "Super Jump", function()
	return settings.jumpEnabled
end, function(v)
	settings.jumpEnabled = v
	if not v and localPlayer.Character then
		local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.JumpPower = defaultJumpPower
			hum.JumpHeight = defaultJumpHeight
		end
	end
end)
createToggle(tabMain, 5, "Salto infinito", function()
	return settings.infJump
end, function(v)
	settings.infJump = v
	notify(v and "Inf Jump ON" or "Inf Jump OFF")
end)
createSlider(tabMain, 6, "Potencia de salto", 50, 350, function()
	return settings.customJump
end, function(v)
	settings.customJump = v
end)

-- Combate
sectionLabel(tabCombat, 1, "Aim")
createToggle(tabCombat, 2, "Aim assist (RMB)", function()
	return settings.aimEnabled
end, function(v)
	settings.aimEnabled = v
end)
createToggle(tabCombat, 3, "Circulo FOV", function()
	return settings.fovCircle
end, function(v)
	settings.fovCircle = v
end)
createSlider(tabCombat, 4, "Radio FOV", 50, 300, function()
	return settings.fovRadius
end, function(v)
	settings.fovRadius = v
	fovFrame.Size = UDim2.new(0, v * 2, 0, v * 2)
end)
createSlider(tabCombat, 5, "Suavizado (1 fuerte / 10 suave)", 1, 10, function()
	return settings.aimSmoothness
end, function(v)
	settings.aimSmoothness = v
end)
createAction(tabCombat, 6, "Objetivo: " .. settings.targetPart, function(btn)
	settings.targetPart = settings.targetPart == "Head" and "Torso" or "Head"
	btn.Text = "Objetivo: " .. settings.targetPart
end)
sectionLabel(tabCombat, 7, "Hitbox")
createToggle(tabCombat, 8, "Extender cabeza", function()
	return settings.hitboxEnabled
end, function(v)
	settings.hitboxEnabled = v
	if not v then
		-- restore happens in loop via flag
	end
end)
createSlider(tabCombat, 9, "Tamano hitbox", 2, 20, function()
	return settings.hitboxSize
end, function(v)
	settings.hitboxSize = v
end)
sectionLabel(tabCombat, 10, "Spin")
createToggle(tabCombat, 11, "Spinbot", function()
	return settings.spinbotEnabled
end, function(v)
	settings.spinbotEnabled = v
	local char = localPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.AutoRotate = not v
	end
end)
createSlider(tabCombat, 12, "Velocidad spin", 5, 100, function()
	return settings.spinbotSpeed
end, function(v)
	settings.spinbotSpeed = v
end)

-- Movimiento
sectionLabel(tabMovement, 1, "Aereo")
createToggle(tabMovement, 2, "Fly  (WASD + Space/Shift)", function()
	return settings.flyEnabled
end, function(v)
	settings.flyEnabled = v
	if not v and localPlayer.Character then
		local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.PlatformStand = false
		end
	end
end)
createSlider(tabMovement, 3, "Velocidad fly", 10, 150, function()
	return settings.flySpeed
end, function(v)
	settings.flySpeed = v
end)
createToggle(tabMovement, 4, "Noclip", function()
	return settings.noclipEnabled
end, function(v)
	settings.noclipEnabled = v
end)
sectionLabel(tabMovement, 5, "Suelo")
createToggle(tabMovement, 6, "Bunny hop", function()
	return settings.bhopEnabled
end, function(v)
	settings.bhopEnabled = v
end)
createToggle(tabMovement, 7, "Salto infinito", function()
	return settings.infJump
end, function(v)
	settings.infJump = v
end)
createToggle(tabMovement, 8, "Sin caida / ragdoll", function()
	return settings.noFall
end, function(v)
	settings.noFall = v
	local char = localPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not v)
		hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not v)
	end
end)

-- Visuales
sectionLabel(tabVisuals, 1, "ESP")
createToggle(tabVisuals, 2, "ESP master", function()
	return settings.espEnabled
end, function(v)
	settings.espEnabled = v
end)
createToggle(tabVisuals, 3, "Cajas 2D", function()
	return settings.espBoxesEnabled
end, function(v)
	settings.espBoxesEnabled = v
end)
createToggle(tabVisuals, 4, "Nombres", function()
	return settings.espNamesEnabled
end, function(v)
	settings.espNamesEnabled = v
end)
createToggle(tabVisuals, 5, "Vida", function()
	return settings.espHealthEnabled
end, function(v)
	settings.espHealthEnabled = v
end)
createToggle(tabVisuals, 6, "Distancia", function()
	return settings.espDistanceEnabled
end, function(v)
	settings.espDistanceEnabled = v
end)
createToggle(tabVisuals, 7, "Tracers", function()
	return settings.espTracersEnabled
end, function(v)
	settings.espTracersEnabled = v
end)
sectionLabel(tabVisuals, 8, "Overlay")
createToggle(tabVisuals, 9, "Watermark", function()
	return settings.watermark
end, function(v)
	settings.watermark = v
	watermark.Visible = v
end)
createToggle(tabVisuals, 10, "Crosshair", function()
	return settings.crosshair
end, function(v)
	settings.crosshair = v
	cross.Visible = v
end)
createToggle(tabVisuals, 11, "Fullbright", function()
	return settings.fullbright
end, function(v)
	settings.fullbright = v
	if v then
		Lighting.Ambient = Color3.fromRGB(180, 180, 180)
		Lighting.Brightness = 2
		Lighting.FogEnd = 1e6
	else
		Lighting.Ambient = lightingBackup.Ambient
		Lighting.Brightness = lightingBackup.Brightness
		Lighting.FogEnd = lightingBackup.FogEnd
	end
end)

-- Teleport
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -4, 0, 36)
searchBox.BackgroundColor3 = COL.elevated
searchBox.TextColor3 = COL.fg
searchBox.PlaceholderText = "Buscar jugador"
searchBox.PlaceholderColor3 = COL.subtle
searchBox.Text = ""
searchBox.TextSize = 13
searchBox.Font = Enum.Font.Gotham
searchBox.ClearTextOnFocus = false
searchBox.LayoutOrder = 1
searchBox.Parent = tabTeleport
corner(searchBox, 8)
stroke(searchBox, COL.border, 1)

local tpList = Instance.new("Frame")
tpList.BackgroundTransparency = 1
tpList.Size = UDim2.new(1, 0, 0, 10)
tpList.AutomaticSize = Enum.AutomaticSize.Y
tpList.LayoutOrder = 2
tpList.Parent = tabTeleport
local tpLayout = Instance.new("UIListLayout")
tpLayout.Padding = UDim.new(0, 6)
tpLayout.Parent = tpList

local function updateTeleportList()
	for _, ch in ipairs(tpList:GetChildren()) do
		if not ch:IsA("UIListLayout") then
			ch:Destroy()
		end
	end
	local filter = settings.tpSearchText:lower()
	local order = 1
	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer ~= localPlayer then
			local pName = targetPlayer.Name:lower()
			local pDisplay = targetPlayer.DisplayName:lower()
			if filter == "" or string.find(pName, filter, 1, true) or string.find(pDisplay, filter, 1, true) then
				createAction(tpList, order, "TP  " .. targetPlayer.DisplayName .. "  @" .. targetPlayer.Name, function()
					local tRoot = getRootPart(targetPlayer.Character)
					local myRoot = getRootPart(localPlayer.Character)
					if tRoot and myRoot then
						myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
						notify("TP → " .. targetPlayer.DisplayName)
					end
				end)
				order = order + 1
			end
		end
	end
end

bind(searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	settings.tpSearchText = searchBox.Text
	updateTeleportList()
end))
bind(Players.PlayerAdded:Connect(updateTeleportList))
bind(Players.PlayerRemoving:Connect(updateTeleportList))
updateTeleportList()

-- Skins
sectionLabel(tabSkins, 1, "Changer visual")
createToggle(tabSkins, 2, "Color / Neon en viewmodel", function()
	return settings.skinsEnabled
end, function(v)
	settings.skinsEnabled = v
end)
createSlider(tabSkins, 3, "Rojo", 0, 255, function()
	return math.floor(settings.weaponColor.R * 255)
end, function(v)
	local c = settings.weaponColor
	settings.weaponColor = Color3.fromRGB(v, math.floor(c.G * 255), math.floor(c.B * 255))
end)
createSlider(tabSkins, 4, "Verde", 0, 255, function()
	return math.floor(settings.weaponColor.G * 255)
end, function(v)
	local c = settings.weaponColor
	settings.weaponColor = Color3.fromRGB(math.floor(c.R * 255), v, math.floor(c.B * 255))
end)
createSlider(tabSkins, 5, "Azul", 0, 255, function()
	return math.floor(settings.weaponColor.B * 255)
end, function(v)
	local c = settings.weaponColor
	settings.weaponColor = Color3.fromRGB(math.floor(c.R * 255), math.floor(c.G * 255), v)
end)
createAction(tabSkins, 6, "Restaurar skins por defecto", function()
	for b in pairs(backups) do
		resetBase(b)
	end
	notify("Skins restauradas")
end)

if WeaponConfig then
	local goodSkins = { knives = {}, snipers = {} }
	local allBases = {}
	for k, v in pairs(WeaponConfig) do
		if type(k) == "string" and not k:find("%.") and v.FirstPersonModel then
			allBases[k] = true
		end
	end
	local function getBaseKey(skinKey)
		if allBases[skinKey] then
			return skinKey
		end
		for segment in skinKey:gmatch("[^%.]+") do
			if allBases[segment] then
				return segment
			end
		end
		return skinKey:match("^([^%.]+)")
	end
	for k, v in pairs(WeaponConfig) do
		if type(k) == "string" then
			local sec = v.SecondaryRarity or ""
			if v.Rarity == "Mistico" or v.Rarity == "Místico" or sec == "Exotico" or sec == "Exótico" or sec == "Secreto" or sec == "Recuerdo" then
				local base = getBaseKey(k)
				if base and WeaponConfig[base] then
					local entry = { key = k, display = v.Display or k, base = base }
					if isKnifeBase(base) then
						table.insert(goodSkins.knives, entry)
					else
						for _, b in ipairs(sniperBases) do
							if base == b then
								table.insert(goodSkins.snipers, entry)
								break
							end
						end
					end
				end
			end
		end
	end
	table.sort(goodSkins.knives, function(a, b)
		return a.display < b.display
	end)
	table.sort(goodSkins.snipers, function(a, b)
		return a.display < b.display
	end)
	sectionLabel(tabSkins, 7, "Skins reales (re-equipar al morir)")
	local order = 8
	for _, s in ipairs(goodSkins.knives) do
		createAction(tabSkins, order, "Knife  " .. s.display, function()
			applySkin(s.key)
			notify("Skin: " .. s.display)
		end)
		order = order + 1
	end
	for _, s in ipairs(goodSkins.snipers) do
		createAction(tabSkins, order, "Sniper  " .. s.display, function()
			applySkin(s.key)
			notify("Skin: " .. s.display)
		end)
		order = order + 1
	end
end

-- Ajustes
sectionLabel(tabConfig, 1, "Sistema")
createToggle(tabConfig, 2, "Anti-AFK", function()
	return settings.antiAfk
end, function(v)
	settings.antiAfk = v
end)
createAction(tabConfig, 3, "Unload (limpiar todo)", function()
	gui:Destroy()
end)

-- ESP
local hasDrawing = pcall(function()
	local d = Drawing.new("Line")
	d.Visible = false
	d:Remove()
end)

local esp2D = {}
local function createESP2D(player)
	if esp2D[player] then
		return
	end
	if hasDrawing then
		local box = Drawing.new("Square")
		box.Visible = false
		box.Color = settings.espColor
		box.Thickness = 1
		box.Filled = false
		local name = Drawing.new("Text")
		name.Visible = false
		name.Color = Color3.fromRGB(255, 255, 255)
		name.Size = 13
		name.Center = true
		name.Outline = true
		local info = Drawing.new("Text")
		info.Visible = false
		info.Color = Color3.fromRGB(200, 200, 200)
		info.Size = 12
		info.Center = true
		info.Outline = true
		local line = Drawing.new("Line")
		line.Visible = false
		line.Color = settings.espColor
		line.Thickness = 1
		esp2D[player] = { kind = "draw", box = box, name = name, info = info, line = line }
	else
		local holder = Instance.new("Folder")
		holder.Name = "ESP_" .. player.Name
		holder.Parent = gui
		local box = Instance.new("Frame")
		box.Visible = false
		box.BackgroundTransparency = 1
		box.Parent = holder
		local boxStroke = Instance.new("UIStroke")
		boxStroke.Thickness = 1
		boxStroke.Color = settings.espColor
		boxStroke.Parent = box
		local name = Instance.new("TextLabel")
		name.Visible = false
		name.BackgroundTransparency = 1
		name.Font = Enum.Font.GothamMedium
		name.TextSize = 12
		name.TextColor3 = COL.fg
		name.Parent = holder
		local info = Instance.new("TextLabel")
		info.Visible = false
		info.BackgroundTransparency = 1
		info.Font = Enum.Font.GothamMedium
		info.TextSize = 11
		info.TextColor3 = COL.muted
		info.Parent = holder
		esp2D[player] = { kind = "gui", holder = holder, box = box, name = name, info = info, line = info }
	end
end

local function hideESP(draw)
	if draw.kind == "draw" then
		draw.box.Visible = false
		draw.name.Visible = false
		draw.info.Visible = false
		draw.line.Visible = false
	else
		draw.box.Visible = false
		draw.name.Visible = false
		draw.info.Visible = false
		draw.line.Visible = false
	end
end

local function removeESP2D(player)
	local draw = esp2D[player]
	if not draw then
		return
	end
	if draw.kind == "draw" then
		pcall(function()
			draw.box:Remove()
			draw.name:Remove()
			draw.info:Remove()
			draw.line:Remove()
		end)
	elseif draw.holder then
		draw.holder:Destroy()
	end
	esp2D[player] = nil
end

for _, p in ipairs(Players:GetPlayers()) do
	if p ~= localPlayer then
		createESP2D(p)
	end
end
bind(Players.PlayerAdded:Connect(function(p)
	if p ~= localPlayer then
		createESP2D(p)
		updateTeleportList()
	end
end))
bind(Players.PlayerRemoving:Connect(function(p)
	removeESP2D(p)
	updateTeleportList()
end))

local function getClosestPlayer()
	local closest, shortest = nil, settings.fovRadius
	local mousePos = UserInputService:GetMouseLocation()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local part = getTargetPart(player.Character)
			local hum = player.Character:FindFirstChildOfClass("Humanoid")
			if part and (not hum or hum.Health > 0) then
				local pos, onScreen = camera:WorldToViewportPoint(part.Position)
				if onScreen then
					local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
					if distance < shortest then
						shortest = distance
						closest = part
					end
				end
			end
		end
	end
	return closest
end

bind(UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then
		return
	end
	if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightControl then
		mainFrame.Visible = not mainFrame.Visible
	end
	if input.UserInputType == settings.aimKey and settings.aimEnabled then
		settings.aimbotTargeting = true
	end
end))
bind(UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == settings.aimKey then
		settings.aimbotTargeting = false
	end
end))

bind(UserInputService.JumpRequest:Connect(function()
	if not settings.infJump then
		return
	end
	local char = localPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end))

bind(localPlayer.Idled:Connect(function()
	if not settings.antiAfk then
		return
	end
	pcall(function()
		local vu = game:GetService("VirtualUser")
		vu:CaptureController()
		vu:ClickButton2(Vector2.new())
	end)
end))

local function applyVisualSkins()
	if not settings.skinsEnabled then
		return
	end
	local viewModel = camera:FindFirstChild("ViewModel") or camera:FindFirstChildOfClass("Model")
	if not viewModel then
		return
	end
	for _, part in ipairs(viewModel:GetDescendants()) do
		if part:IsA("BasePart") then
			local partName = part.Name:lower()
			for _, child in ipairs(part:GetChildren()) do
				if child:IsA("Texture") or child:IsA("Decal") then
					child.Transparency = 1
				end
			end
			if not partName:find("arm") and not partName:find("hand") and not partName:find("glove") then
				part.Material = settings.skinMaterial
				part.Color = settings.weaponColor
			end
		end
	end
end

local headBackup = {}
local function restoreHitboxes()
	for head, data in pairs(headBackup) do
		if head and head.Parent then
			head.Size = data.Size
			head.Transparency = data.Transparency
			head.CanCollide = data.CanCollide
		end
		headBackup[head] = nil
	end
end

local noclipWasOn = false
local flyWasOn = false

local renderConn = RunService.RenderStepped:Connect(function()
	if not camera or not localPlayer.Character then
		return
	end
	local mousePos = UserInputService:GetMouseLocation()
	fovFrame.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
	fovFrame.Visible = settings.aimEnabled and settings.fovCircle
	fovStroke.Color = settings.espColor
	applyVisualSkins()

	if settings.aimbotTargeting and settings.aimEnabled then
		local target = getClosestPlayer()
		if target then
			local targetCF = CFrame.new(camera.CFrame.Position, target.Position)
			local smoothAlpha = math.clamp(0.15 / (settings.aimSmoothness * 0.8), 0.01, 0.2)
			camera.CFrame = camera.CFrame:Lerp(targetCF, smoothAlpha)
		end
	end

	if settings.spinbotEnabled then
		local myRoot = getRootPart(localPlayer.Character)
		local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if myRoot then
			if hum then
				hum.AutoRotate = false
			end
			myRoot.CFrame = myRoot.CFrame * CFrame.Angles(0, math.rad(settings.spinbotSpeed), 0)
		end
	end

	local myRoot = getRootPart(localPlayer.Character)
	for player, draw in pairs(esp2D) do
		local char = player.Character
		local root = getRootPart(char)
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if settings.espEnabled and char and root and (not hum or hum.Health > 0) then
			local pos, onScreen = camera:WorldToViewportPoint(root.Position)
			if onScreen then
				local headPos = camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
				local legPos = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))
				local height = math.abs(headPos.Y - legPos.Y)
				local width = height / 1.8
				if draw.kind == "draw" then
					if settings.espBoxesEnabled then
						draw.box.Size = Vector2.new(width, height)
						draw.box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
						draw.box.Color = settings.espColor
						draw.box.Visible = true
					else
						draw.box.Visible = false
					end
					if settings.espNamesEnabled then
						draw.name.Text = player.DisplayName or player.Name
						draw.name.Position = Vector2.new(pos.X, (pos.Y - height / 2) - 16)
						draw.name.Visible = true
					else
						draw.name.Visible = false
					end
					local infoText = ""
					if settings.espHealthEnabled and hum then
						local hp = math.clamp(math.floor((hum.Health / hum.MaxHealth) * 100), 0, 100)
						infoText = infoText .. hp .. "%  "
					end
					if settings.espDistanceEnabled and myRoot then
						local dist = math.floor((myRoot.Position - root.Position).Magnitude / 3.57)
						infoText = infoText .. dist .. "m"
					end
					if infoText ~= "" then
						draw.info.Text = infoText
						draw.info.Position = Vector2.new(pos.X, (pos.Y + height / 2) + 2)
						draw.info.Visible = true
					else
						draw.info.Visible = false
					end
					if settings.espTracersEnabled then
						draw.line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
						draw.line.To = Vector2.new(pos.X, pos.Y)
						draw.line.Color = settings.espColor
						draw.line.Visible = true
					else
						draw.line.Visible = false
					end
				elseif draw.kind == "gui" then
					if settings.espBoxesEnabled then
						draw.box.Position = UDim2.fromOffset(pos.X - width / 2, pos.Y - height / 2)
						draw.box.Size = UDim2.fromOffset(width, height)
						draw.box.Visible = true
						local st = draw.box:FindFirstChildOfClass("UIStroke")
						if st then
							st.Color = settings.espColor
						end
					else
						draw.box.Visible = false
					end
					if settings.espNamesEnabled then
						draw.name.Text = player.DisplayName or player.Name
						draw.name.Position = UDim2.fromOffset(pos.X - 70, pos.Y - height / 2 - 18)
						draw.name.Size = UDim2.fromOffset(140, 16)
						draw.name.TextXAlignment = Enum.TextXAlignment.Center
						draw.name.Visible = true
					else
						draw.name.Visible = false
					end
					local infoText = ""
					if settings.espHealthEnabled and hum then
						local hp = math.clamp(math.floor((hum.Health / hum.MaxHealth) * 100), 0, 100)
						infoText = infoText .. hp .. "%  "
					end
					if settings.espDistanceEnabled and myRoot then
						local dist = math.floor((myRoot.Position - root.Position).Magnitude / 3.57)
						infoText = infoText .. dist .. "m"
					end
					if infoText ~= "" then
						draw.info.Text = infoText
						draw.info.Position = UDim2.fromOffset(pos.X - 70, pos.Y + height / 2 + 2)
						draw.info.Size = UDim2.fromOffset(140, 16)
						draw.info.TextXAlignment = Enum.TextXAlignment.Center
						draw.info.Visible = true
					else
						draw.info.Visible = false
					end
				end
			else
				hideESP(draw)
			end
		else
			hideESP(draw)
		end
	end

	if settings.noclipEnabled then
		noclipWasOn = true
		for _, part in ipairs(localPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	elseif noclipWasOn then
		for _, part in ipairs(localPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") and (part.Name == "HumanoidRootPart" or part.Name == "Torso" or part.Name == "UpperTorso" or part.Name == "LowerTorso") then
				part.CanCollide = true
			end
		end
		noclipWasOn = false
	end

	if settings.hitboxEnabled then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				local head = getHeadPart(player.Character)
				if head then
					if not headBackup[head] then
						headBackup[head] = { Size = head.Size, Transparency = head.Transparency, CanCollide = head.CanCollide }
					end
					head.Size = Vector3.new(settings.hitboxSize, settings.hitboxSize, settings.hitboxSize)
					head.Transparency = 0.6
					head.CanCollide = false
				end
			end
		end
	else
		restoreHitboxes()
	end

	local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid and myRoot then
		if settings.speedEnabled then
			humanoid.WalkSpeed = settings.customSpeed
		end
		if settings.jumpEnabled then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = settings.customJump
			humanoid.JumpHeight = settings.customJump / 5
		end
		if settings.bhopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			if humanoid.FloorMaterial ~= Enum.Material.Air then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)
bind(renderConn)

local heartbeatConn = RunService.Heartbeat:Connect(function()
	if settings.flyEnabled and localPlayer.Character then
		flyWasOn = true
		local rootPart = getRootPart(localPlayer.Character)
		local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if rootPart and humanoid then
			humanoid.PlatformStand = true
			local camCF = camera.CFrame
			local moveVector = Vector3.new(0, 0, 0)
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveVector = moveVector + camCF.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveVector = moveVector - camCF.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveVector = moveVector - camCF.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveVector = moveVector + camCF.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveVector = moveVector + Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				moveVector = moveVector - Vector3.new(0, 1, 0)
			end
			local vel = moveVector * settings.flySpeed
			rootPart.AssemblyLinearVelocity = vel
		end
	elseif flyWasOn and localPlayer.Character then
		local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.PlatformStand = false
		end
		flyWasOn = false
	end
end)
bind(heartbeatConn)

local unloading = false
local function unload()
	if unloading then
		return
	end
	unloading = true
	restoreHitboxes()
	if settings.fullbright then
		Lighting.Ambient = lightingBackup.Ambient
		Lighting.Brightness = lightingBackup.Brightness
		Lighting.FogEnd = lightingBackup.FogEnd
	end
	if localPlayer.Character then
		local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.PlatformStand = false
			hum.AutoRotate = true
			hum.WalkSpeed = defaultWalkSpeed
			hum.JumpPower = defaultJumpPower
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
		end
	end
	for player in pairs(esp2D) do
		removeESP2D(player)
	end
	for _, c in ipairs(connections) do
		pcall(function()
			c:Disconnect()
		end)
	end
	if gui and gui.Parent then
		gui:Destroy()
	end
end

gui.Destroying:Connect(unload)
notify("SOVICH v4 listo  ·  Insert para el menu")

