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
    -- If your Key System has: Secret = "Leonpro809098"
    -- Then this must also be: SecretKey = "Leonpro809098"
    SecretKey = "Leonpro809098",
    
    -- The name of your Hub (shown in the kick message if they try to bypass)
    HubName = "Sovich V3"
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
    SOVICH - TWD3 PRO (UNIVERSAL 2D DRAWING ESP + SEARCH TELEPORT + SPINBOT)
    v4.0 Update: Silent Aim, Wallbang, Triggerbot, Chams, Skeleton ESP, Anti-AFK & Utilidades
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local defaultWalkSpeed = 16
local defaultJumpPower = 50
local defaultJumpHeight = 7.2
local originalFOV = camera.FieldOfView

local settings = {
	aimEnabled = false,
	aimSmoothness = 5,
	aimKey = Enum.UserInputType.MouseButton2,
	espEnabled = false,
	espBoxesEnabled = true,
	espNamesEnabled = true,
	espTracersEnabled = true,
	espHealthEnabled = true,
	espDistanceEnabled = true,
	flyEnabled = false,
	noclipEnabled = false,
	speedEnabled = false,
	jumpEnabled = false,
	bhopEnabled = false,
	hitboxEnabled = false,
	spinbotEnabled = false,
	spinbotSpeed = 20,
	targetPart = "Head",
	hitboxSize = 5,
	fovRadius = 140,
	flySpeed = 50,
	customSpeed = 32,
	customJump = 100,
	espColor = Color3.fromRGB(170, 0, 255),
	aimbotTargeting = false,
	tpSearchText = "",
	
	-- NUEVAS CONFIGURACIONES
	silentAim = false,
	wallbang = false,
	removeRecoil = false,
	triggerbot = false,
	chamsEnabled = false,
	crosshairEnabled = false,
	skeletonESP = false,
	fovChanger = false,
	customCameraFOV = 70,
	antiAFK = false,
	targetInfoEnabled = false
}

local function setupCharacter(char)
	local humanoid = char:WaitForChild("Humanoid", 5)
	if humanoid then
		if not settings.speedEnabled then defaultWalkSpeed = humanoid.WalkSpeed end
		if not settings.jumpEnabled then
			defaultJumpPower = humanoid.JumpPower
			defaultJumpHeight = humanoid.JumpHeight
		end
	end
end

if localPlayer.Character then setupCharacter(localPlayer.Character) end
localPlayer.CharacterAdded:Connect(setupCharacter)

--// GUI Principal
local gui = Instance.new("ScreenGui")
gui.Name = "SovichHub_" .. math.random(11111, 99999)
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = localPlayer:WaitForChild("PlayerGui")

--// Círculo FOV
local fovFrame = Instance.new("Frame")
fovFrame.Size = UDim2.new(0, settings.fovRadius * 2, 0, settings.fovRadius * 2)
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.BackgroundTransparency = 1
fovFrame.Visible = false
fovFrame.Parent = gui

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = settings.espColor
fovStroke.Thickness = 2
fovStroke.Parent = fovFrame
local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovFrame

--// CROSSHAIR PERSONALIZADO
local crosshairH = Drawing.new("Line")
crosshairH.Thickness = 1.5
crosshairH.Color = Color3.fromRGB(0, 255, 170)
crosshairH.Visible = false

local crosshairV = Drawing.new("Line")
crosshairV.Thickness = 1.5
crosshairV.Color = Color3.fromRGB(0, 255, 170)
crosshairV.Visible = false

--// TARGET INFO CARD
local targetInfoCard = Instance.new("Frame")
targetInfoCard.Size = UDim2.new(0, 180, 0, 65)
targetInfoCard.Position = UDim2.new(0.5, 10, 0.5, 10)
targetInfoCard.BackgroundColor3 = Color3.fromRGB(15, 12, 24)
targetInfoCard.Visible = false
targetInfoCard.Parent = gui

local ticCorner = Instance.new("UICorner")
ticCorner.CornerRadius = UDim.new(0, 6)
ticCorner.Parent = targetInfoCard

local ticStroke = Instance.new("UIStroke")
ticStroke.Color = Color3.fromRGB(170, 0, 255)
ticStroke.Thickness = 1
ticStroke.Parent = targetInfoCard

local targetTextLabel = Instance.new("TextLabel")
targetTextLabel.Size = UDim2.new(1, -10, 1, -10)
targetTextLabel.Position = UDim2.new(0, 5, 0, 5)
targetTextLabel.BackgroundTransparency = 1
targetTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
targetTextLabel.TextSize = 11
targetTextLabel.Font = Enum.Font.GothamMedium
targetTextLabel.TextXAlignment = Enum.TextXAlignment.Left
targetTextLabel.TextYAlignment = Enum.TextYAlignment.Top
targetTextLabel.Parent = targetInfoCard

--// BOTÓN FLOTANTE
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 45, 0, 45)
toggleButton.Position = UDim2.new(0, 25, 0, 150)
toggleButton.BackgroundColor3 = Color3.fromRGB(18, 15, 28)
toggleButton.Text = "S"
toggleButton.TextColor3 = Color3.fromRGB(200, 130, 255)
toggleButton.TextSize = 20
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = gui

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(1, 0)
tbCorner.Parent = toggleButton
local tbStroke = Instance.new("UIStroke")
tbStroke.Color = Color3.fromRGB(160, 0, 240)
tbStroke.Thickness = 2
tbStroke.Parent = toggleButton

local draggingBtn, dragStartBtn, startPosBtn
toggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingBtn = true; dragStartBtn = input.Position; startPosBtn = toggleButton.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if draggingBtn and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStartBtn
		toggleButton.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X, startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingBtn = false end
end)

--// VENTANA PRINCIPAL
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 360)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local mfCorner = Instance.new("UICorner")
mfCorner.CornerRadius = UDim.new(0, 8)
mfCorner.Parent = mainFrame
local mfStroke = Instance.new("UIStroke")
mfStroke.Color = Color3.fromRGB(70, 45, 100)
mfStroke.Thickness = 1.5
mfStroke.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(20, 17, 32)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
local tbCorner2 = Instance.new("UICorner")
tbCorner2.CornerRadius = UDim.new(0, 8)
tbCorner2.Parent = topBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0, 300, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.fromRGB(210, 160, 255)
titleText.TextSize = 13
titleText.Font = Enum.Font.GothamBold
titleText.Text = "SOVICH HUB  |  v4.0 Universal"
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = topBar

local draggingMain, dragInputMain, dragStartMain, startPosMain
topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingMain = true; dragStartMain = input.Position; startPosMain = mainFrame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then draggingMain = false end end)
	end
end)
topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInputMain = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInputMain and draggingMain then
		local delta = input.Position - dragStartMain
		mainFrame.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
	end
end)

local sidebar = Instance.new("ScrollingFrame")
sidebar.Size = UDim2.new(0, 135, 1, -45)
sidebar.Position = UDim2.new(0, 6, 0, 40)
sidebar.BackgroundTransparency = 1
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.ScrollBarThickness = 0
sidebar.Parent = mainFrame
local sbLayout = Instance.new("UIListLayout")
sbLayout.SortOrder = Enum.SortOrder.LayoutOrder
sbLayout.Padding = UDim.new(0, 4)
sbLayout.Parent = sidebar

local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -155, 1, -45)
pagesContainer.Position = UDim2.new(0, 148, 0, 40)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = mainFrame

toggleButton.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

-- Keybind para ocultar/mostrar UI rápida
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and (input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightControl) then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

local tabs, currentTab = {}, nil
local function createTabContent(name)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = name .. "Content"
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.CanvasSize = UDim2.new(0, 0, 0, 800)
	scroll.ScrollBarThickness = 4
	scroll.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 220)
	scroll.Visible = false
	scroll.Parent = pagesContainer
	local list = Instance.new("UIListLayout")
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 8)
	list.Parent = scroll
	return scroll
end

local tabMain = createTabContent("Principal")
local tabCombat = createTabContent("Combate")
local tabMovement = createTabContent("Movimiento")
local tabVisuals = createTabContent("Visuales")
local tabUtils = createTabContent("Utilidades")

local tabTeleport = Instance.new("Frame")
tabTeleport.Name = "TeleportContent"
tabTeleport.Size = UDim2.new(1, 0, 1, 0)
tabTeleport.BackgroundTransparency = 1
tabTeleport.Visible = false
tabTeleport.Parent = pagesContainer

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -10, 0, 32)
searchBox.Position = UDim2.new(0, 0, 0, 0)
searchBox.BackgroundColor3 = Color3.fromRGB(20, 16, 32)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderText = "🔍 Buscar jugador..."
searchBox.PlaceholderColor3 = Color3.fromRGB(130, 120, 150)
searchBox.Text = ""
searchBox.TextSize = 13
searchBox.Font = Enum.Font.GothamMedium
searchBox.Parent = tabTeleport

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 6)
sbCorner.Parent = searchBox

local sbStroke = Instance.new("UIStroke")
sbStroke.Color = Color3.fromRGB(80, 45, 120)
sbStroke.Thickness = 1
sbStroke.Parent = searchBox

local tpScroll = Instance.new("ScrollingFrame")
tpScroll.Size = UDim2.new(1, 0, 1, -40)
tpScroll.Position = UDim2.new(0, 0, 0, 40)
tpScroll.BackgroundTransparency = 1
tpScroll.ScrollBarThickness = 4
tpScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 220)
tpScroll.Parent = tabTeleport

local tpListLayout = Instance.new("UIListLayout")
tpListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tpListLayout.Padding = UDim.new(0, 6)
tpListLayout.Parent = tpScroll

local function switchTab(tabName)
	for name, scroll in pairs(tabs) do scroll.Visible = (name == tabName) end
	currentTab = tabName
end

local function createSidebarButton(order, name, associatedScroll)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(22, 18, 35)
	btn.TextColor3 = Color3.fromRGB(180, 160, 210)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamMedium
	btn.Text = "  " .. name
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.LayoutOrder = order
	btn.Parent = sidebar
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	tabs[name] = associatedScroll
	btn.MouseButton1Click:Connect(function() switchTab(name) end)
	if not currentTab then switchTab(name) end
	return btn
end

createSidebarButton(1, "Principal", tabMain)
createSidebarButton(2, "Combate", tabCombat)
createSidebarButton(3, "Movimiento", tabMovement)
createSidebarButton(4, "Visuales", tabVisuals)
createSidebarButton(5, "Teleport", tabTeleport)
createSidebarButton(6, "Utilidades", tabUtils)

local function createButtonIn(parentScroll, order, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
	btn.TextColor3 = Color3.fromRGB(230, 230, 230)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamBold
	btn.Text = text
	btn.LayoutOrder = order
	btn.Parent = parentScroll
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(60, 35, 90)
	stroke.Thickness = 1
	stroke.Parent = btn
	if callback then btn.MouseButton1Click:Connect(function() callback(btn) end) end
	return btn
end

local function createSliderIn(parentScroll, order, defaultVal, minVal, maxVal, titlePrefix, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -10, 0, 48)
	container.BackgroundColor3 = Color3.fromRGB(20, 16, 32)
	container.LayoutOrder = order
	container.Parent = parentScroll
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 20)
	label.Position = UDim2.new(0, 8, 0, 4)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(210, 210, 210)
	label.TextSize = 12
	label.Font = Enum.Font.GothamBold
	label.Text = titlePrefix .. ": " .. defaultVal
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -20, 0, 6)
	bar.Position = UDim2.new(0, 10, 0, 30)
	bar.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
	bar.Parent = container

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(150, 0, 220)
	fill.Parent = bar

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 14, 0, 14)
	btn.AnchorPoint = Vector2.new(0.5, 0.5)
	btn.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = ""
	btn.Parent = bar

	local dragging = false
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
	end)
	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local mousePos = UserInputService:GetMouseLocation().X
			local barPos = bar.AbsolutePosition.X
			local barSize = bar.AbsoluteSize.X
			local clampPos = math.clamp((mousePos - barPos) / barSize, 0, 1)
			fill.Size = UDim2.new(clampPos, 0, 1, 0)
			btn.Position = UDim2.new(clampPos, 0, 0.5, 0)
			local calculatedVal = math.floor(minVal + (clampPos * (maxVal - minVal)))
			label.Text = titlePrefix .. ": " .. calculatedVal
			callback(calculatedVal)
		end
	end)
	return container
end

-- CONTROLES PRINCIPALES
createButtonIn(tabMain, 1, "SpeedHack: OFF", function(btn)
	settings.speedEnabled = not settings.speedEnabled
	btn.Text = settings.speedEnabled and "SpeedHack: ON" or "SpeedHack: OFF"
	btn.BackgroundColor3 = settings.speedEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
	if not settings.speedEnabled and localPlayer.Character then
		local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = defaultWalkSpeed end
	end
end)
createSliderIn(tabMain, 2, settings.customSpeed, 16, 150, "Velocidad Walk", function(val) settings.customSpeed = val end)

createButtonIn(tabMain, 3, "Super Jump: OFF", function(btn)
	settings.jumpEnabled = not settings.jumpEnabled
	btn.Text = settings.jumpEnabled and "Super Jump: ON" or "Super Jump: OFF"
	btn.BackgroundColor3 = settings.jumpEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
	if not settings.jumpEnabled and localPlayer.Character then
		local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.JumpPower = defaultJumpPower; hum.JumpHeight = defaultJumpHeight end
	end
end)
createSliderIn(tabMain, 4, settings.customJump, 50, 350, "Altura Salto", function(val) settings.customJump = val end)

-- CONTROLES DE COMBATE
createButtonIn(tabCombat, 1, "Aimbot / AimAssist: OFF", function(btn)
	settings.aimEnabled = not settings.aimEnabled
	btn.Text = settings.aimEnabled and "Aimbot / AimAssist: ON" or "Aimbot / AimAssist: OFF"
	btn.BackgroundColor3 = settings.aimEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)
createSliderIn(tabCombat, 2, settings.fovRadius, 50, 300, "Tamaño FOV", function(val)
	settings.fovRadius = val; fovFrame.Size = UDim2.new(0, val * 2, 0, val * 2)
end)
createSliderIn(tabCombat, 3, settings.aimSmoothness, 1, 10, "AimAssist Suavizado", function(val) settings.aimSmoothness = val end)

-- SILENT AIM
createButtonIn(tabCombat, 4, "Silent Aim: OFF", function(btn)
	settings.silentAim = not settings.silentAim
	btn.Text = settings.silentAim and "Silent Aim: ON" or "Silent Aim: OFF"
	btn.BackgroundColor3 = settings.silentAim and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)

-- WALLBANG
local disabledMapCollisions = {}
createButtonIn(tabCombat, 5, "Wallbang / Penetración: OFF", function(btn)
	settings.wallbang = not settings.wallbang
	btn.Text = settings.wallbang and "Wallbang / Penetración: ON" or "Wallbang / Penetración: OFF"
	btn.BackgroundColor3 = settings.wallbang and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
	
	local map = workspace:FindFirstChild("Map") or workspace:FindFirstChild("map")
	if map then
		for _, part in ipairs(map:GetDescendants()) do
			if part:IsA("BasePart") then
				if settings.wallbang then
					if part.CanCollide then
						disabledMapCollisions[part] = true
						part.CanCollide = false
					end
				else
					if disabledMapCollisions[part] then
						part.CanCollide = true
					end
				end
			end
		end
	end
	if not settings.wallbang then table.clear(disabledMapCollisions) end
end)

-- REMOVE RECOIL / SPREAD
createButtonIn(tabCombat, 6, "Remove Recoil / Spread: OFF", function(btn)
	settings.removeRecoil = not settings.removeRecoil
	btn.Text = settings.removeRecoil and "Remove Recoil / Spread: ON" or "Remove Recoil / Spread: OFF"
	btn.BackgroundColor3 = settings.removeRecoil and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)

-- TRIGGERBOT
createButtonIn(tabCombat, 7, "Auto Shoot / Triggerbot: OFF", function(btn)
	settings.triggerbot = not settings.triggerbot
	btn.Text = settings.triggerbot and "Auto Shoot / Triggerbot: ON" or "Auto Shoot / Triggerbot: OFF"
	btn.BackgroundColor3 = settings.triggerbot and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)

local originalHeadSizes = {}
createButtonIn(tabCombat, 8, "Head Hitbox Extender: OFF", function(btn)
	settings.hitboxEnabled = not settings.hitboxEnabled
	btn.Text = settings.hitboxEnabled and "Head Hitbox Extender: ON" or "Head Hitbox Extender: OFF"
	btn.BackgroundColor3 = settings.hitboxEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
	if not settings.hitboxEnabled then
		for p, size in pairs(originalHeadSizes) do
			if p and p.Parent then
				p.Size = size
				p.Transparency = 0
				p.CanCollide = true
			end
		end
		table.clear(originalHeadSizes)
	end
end)
createSliderIn(tabCombat, 9, settings.hitboxSize, 2, 20, "Tamaño Hitbox Cabeza", function(val) settings.hitboxSize = val end)

createButtonIn(tabCombat, 10, "Spinbot: OFF", function(btn)
	settings.spinbotEnabled = not settings.spinbotEnabled
	btn.Text = settings.spinbotEnabled and "Spinbot: ON" or "Spinbot: OFF"
	btn.BackgroundColor3 = settings.spinbotEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
	if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
		localPlayer.Character:FindFirstChildOfClass("Humanoid").AutoRotate = not settings.spinbotEnabled
	end
end)
createSliderIn(tabCombat, 11, settings.spinbotSpeed, 5, 100, "Velocidad Spinbot", function(val) settings.spinbotSpeed = val end)

-- CONTROLES DE MOVIMIENTO
createButtonIn(tabMovement, 1, "Fly (Volar): OFF", function(btn)
	settings.flyEnabled = not settings.flyEnabled
	btn.Text = settings.flyEnabled and "Fly (Volar): ON" or "Fly (Volar): OFF"
	btn.BackgroundColor3 = settings.flyEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)
createSliderIn(tabMovement, 2, settings.flySpeed, 10, 150, "Velocidad Fly", function(val) settings.flySpeed = val end)

createButtonIn(tabMovement, 3, "Noclip (Paredes): OFF", function(btn)
	settings.noclipEnabled = not settings.noclipEnabled
	btn.Text = settings.noclipEnabled and "Noclip (Paredes): ON" or "Noclip (Paredes): OFF"
	btn.BackgroundColor3 = settings.noclipEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)

createButtonIn(tabMovement, 4, "BunnyHop (Bhop): OFF", function(btn)
	settings.bhopEnabled = not settings.bhopEnabled
	btn.Text = settings.bhopEnabled and "BunnyHop (Bhop): ON" or "BunnyHop (Bhop): OFF"
	btn.BackgroundColor3 = settings.bhopEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)

-- CONTROLES VISUALES
createButtonIn(tabVisuals, 1, "ESP Master: OFF", function(btn)
	settings.espEnabled = not settings.espEnabled
	btn.Text = settings.espEnabled and "ESP Master: ON" or "ESP Master: OFF"
	btn.BackgroundColor3 = settings.espEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)
createButtonIn(tabVisuals, 2, "Cajas 2D (Boxes): ON", function(btn)
	settings.espBoxesEnabled = not settings.espBoxesEnabled
	btn.Text = settings.espBoxesEnabled and "Cajas 2D (Boxes): ON" or "Cajas 2D (Boxes): OFF"
end)
createButtonIn(tabVisuals, 3, "Mostrar Nombres: ON", function(btn)
	settings.espNamesEnabled = not settings.espNamesEnabled
	btn.Text = settings.espNamesEnabled and "Mostrar Nombres: ON" or "Mostrar Nombres: OFF"
end)
createButtonIn(tabVisuals, 4, "Mostrar Vida (♥ %): ON", function(btn)
	settings.espHealthEnabled = not settings.espHealthEnabled
	btn.Text = settings.espHealthEnabled and "Mostrar Vida (♥ %): ON" or "Mostrar Vida (♥ %): OFF"
end)
createButtonIn(tabVisuals, 5, "Mostrar Distancia (m): ON", function(btn)
	settings.espDistanceEnabled = not settings.espDistanceEnabled
	btn.Text = settings.espDistanceEnabled and "Mostrar Distancia (m): ON" or "Mostrar Distancia (m): OFF"
end)
createButtonIn(tabVisuals, 6, "Líneas (Tracers): ON", function(btn)
	settings.espTracersEnabled = not settings.espTracersEnabled
	btn.Text = settings.espTracersEnabled and "Líneas (Tracers): ON" or "Líneas (Tracers): OFF"
end)

-- CHAMS (HIGHLIGHT)
local activeChams = {}
createButtonIn(tabVisuals, 7, "Chams (Highlights Equipos): OFF", function(btn)
	settings.chamsEnabled = not settings.chamsEnabled
	btn.Text = settings.chamsEnabled and "Chams: ON" or "Chams: OFF"
	btn.BackgroundColor3 = settings.chamsEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
	
	if not settings.chamsEnabled then
		for _, h in pairs(activeChams) do h:Destroy() end
		table.clear(activeChams)
	end
end)

-- CROSSHAIR PERSONALIZADO
createButtonIn(tabVisuals, 8, "Crosshair Personalizado: OFF", function(btn)
	settings.crosshairEnabled = not settings.crosshairEnabled
	btn.Text = settings.crosshairEnabled and "Crosshair 2D: ON" or "Crosshair 2D: OFF"
	btn.BackgroundColor3 = settings.crosshairEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
	crosshairH.Visible = settings.crosshairEnabled
	crosshairV.Visible = settings.crosshairEnabled
end)

-- SKELETON ESP
createButtonIn(tabVisuals, 9, "Skeleton ESP: OFF", function(btn)
	settings.skeletonESP = not settings.skeletonESP
	btn.Text = settings.skeletonESP and "Skeleton ESP: ON" or "Skeleton ESP: OFF"
	btn.BackgroundColor3 = settings.skeletonESP and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)

-- FOV CHANGER
createButtonIn(tabVisuals, 10, "FOV Changer: OFF", function(btn)
	settings.fovChanger = not settings.fovChanger
	btn.Text = settings.fovChanger and "FOV Changer: ON" or "FOV Changer: OFF"
	btn.BackgroundColor3 = settings.fovChanger and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
	if not settings.fovChanger then camera.FieldOfView = originalFOV end
end)
createSliderIn(tabVisuals, 11, settings.customCameraFOV, 40, 120, "Campo de Visión (FOV)", function(val)
	settings.customCameraFOV = val
	if settings.fovChanger then camera.FieldOfView = val end
end)

-- CONTROLES DE UTILIDADES
createButtonIn(tabUtils, 1, "Anti-AFK Proteccion: OFF", function(btn)
	settings.antiAFK = not settings.antiAFK
	btn.Text = settings.antiAFK and "Anti-AFK: ON" or "Anti-AFK: OFF"
	btn.BackgroundColor3 = settings.antiAFK and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)

createButtonIn(tabUtils, 2, "Crosshair Target Info Card: OFF", function(btn)
	settings.targetInfoEnabled = not settings.targetInfoEnabled
	btn.Text = settings.targetInfoEnabled and "Target Info: ON" or "Target Info: OFF"
	btn.BackgroundColor3 = settings.targetInfoEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
	targetInfoCard.Visible = false
end)

createButtonIn(tabUtils, 3, "Server Hop (Servidor Liviano)", function()
	pcall(function()
		local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
		for _, s in ipairs(servers) do
			if s.playing < s.maxPlayers and s.id ~= game.JobId then
				TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
				break
			end
		end
	end)
end)

createButtonIn(tabUtils, 4, "Rejoin (Reconectar)", function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
end)

-- ANTI AFK SYSTEM
localPlayer.Idled:Connect(function()
	if settings.antiAFK then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

--// ESP ENGINE UNIVERSAL (DRAWING API 2D)
local esp2D = {}

local function createESP2D(player)
	if esp2D[player] then return end

	local box = Drawing.new("Square")
	box.Visible = false
	box.Color = settings.espColor
	box.Thickness = 1.5
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
	line.Thickness = 1.5

	-- Skeleton Lines
	local skelLines = {}
	for i = 1, 6 do
		local l = Drawing.new("Line")
		l.Visible = false
		l.Color = Color3.fromRGB(255, 255, 255)
		l.Thickness = 1
		table.insert(skelLines, l)
	end

	esp2D[player] = {box = box, name = name, info = info, line = line, skel = skelLines}
end

local function removeESP2D(player)
	if esp2D[player] then
		pcall(function()
			esp2D[player].box:Remove()
			esp2D[player].name:Remove()
			esp2D[player].info:Remove()
			esp2D[player].line:Remove()
			for _, l in ipairs(esp2D[player].skel) do l:Remove() end
		end)
		esp2D[player] = nil
	end
end

for _, p in ipairs(Players:GetPlayers()) do if p ~= localPlayer then createESP2D(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= localPlayer then createESP2D(p) end end)
Players.PlayerRemoving:Connect(removeESP2D)

-- BÚSQUEDA ESPECÍFICA DE LA CABEZA
local function getHeadPart(char)
	if not char then return nil end
	return char:FindFirstChild("Head") 
		or char:FindFirstChild("FakeHead") 
		or char:FindFirstChild("head")
end

-- BÚSQUEDA GENERAL DE RAÍZ (Para TP / Movimiento)
local function getRootPart(char)
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart") 
		or char:FindFirstChild("UpperTorso") 
		or char:FindFirstChild("Torso") 
		or getHeadPart(char)
		or char:FindFirstChildOfClass("BasePart")
end

-- HOOK SILENT AIM
local namecall
namecall = hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()
	if settings.silentAim and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
		local targetHead = getClosestPlayer()
		if targetHead then
			return targetHead, targetHead.Position, targetHead.CFrame.LookVector, targetHead.Material
		end
	end
	return namecall(self, ...)
end)

--// LISTA DINÁMICA DE TELEPORT CON BÚSQUEDA
local function updateTeleportList()
	tpScroll:ClearAllChildren()
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 6)
	listLayout.Parent = tpScroll

	local order = 1
	local filter = settings.tpSearchText:lower()

	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer ~= localPlayer then
			local pName = targetPlayer.Name:lower()
			local pDisplayName = targetPlayer.DisplayName:lower()
			
			if filter == "" or pName:find(filter, 1, true) or pDisplayName:find(filter, 1, true) then
				createButtonIn(tpScroll, order, "TP a: " .. targetPlayer.DisplayName .. " (@" .. targetPlayer.Name .. ")", function()
					local tChar = targetPlayer.Character
					local myChar = localPlayer.Character
					local tRoot = getRootPart(tChar)
					local myRoot = getRootPart(myChar)
					if tRoot and myRoot then
						myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
					end
				end)
				order = order + 1
			end
		end
	end
	tpScroll.CanvasSize = UDim2.new(0, 0, 0, order * 42)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	settings.tpSearchText = searchBox.Text
	updateTeleportList()
end)

Players.PlayerAdded:Connect(updateTeleportList)
Players.PlayerRemoving:Connect(updateTeleportList)
updateTeleportList()

--// BÚSQUEDA DE JUGADOR CERCANO (Orientado a la Cabeza)
local function getClosestPlayer()
	local closestPlayer = nil
	local shortestDistance = settings.fovRadius
	local mousePos = UserInputService:GetMouseLocation()

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local head = getHeadPart(player.Character) or getRootPart(player.Character)
			local hum = player.Character:FindFirstChildOfClass("Humanoid")
			if head and (not hum or hum.Health > 0) then
				local pos, onScreen = camera:WorldToViewportPoint(head.Position)
				if onScreen then
					local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
					if distance < shortestDistance then
						shortestDistance = distance
						closestPlayer = head
					end
				end
			end
		end
	end
	return closestPlayer
end

UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == settings.aimKey and settings.aimEnabled then settings.aimbotTargeting = true end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == settings.aimKey then settings.aimbotTargeting = false end
end)

--// BUCLE PRINCIPAL
RunService.RenderStepped:Connect(function(delta)
	if not camera or not localPlayer.Character then return end
	
	local mousePos = UserInputService:GetMouseLocation()
	fovFrame.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
	fovFrame.Visible = settings.aimEnabled

	-- FOV CHANGER
	if settings.fovChanger then camera.FieldOfView = settings.customCameraFOV end

	-- CROSSHAIR DIBUJO
	if settings.crosshairEnabled then
		local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
		crosshairH.From = Vector2.new(center.X - 8, center.Y)
		crosshairH.To = Vector2.new(center.X + 8, center.Y)
		crosshairV.From = Vector2.new(center.X, center.Y - 8)
		crosshairV.To = Vector2.new(center.X, center.Y + 8)
	end

	-- REMOVE RECOIL/SPREAD EN HERRAMIENTAS
	if settings.removeRecoil then
		local tool = localPlayer.Character:FindFirstChildOfClass("Tool")
		if tool then
			for _, v in ipairs(tool:GetDescendants()) do
				if v:IsA("NumberValue") or v:IsA("IntValue") then
					if v.Name:lower():find("recoil") or v.Name:lower():find("spread") then
						v.Value = 0
					end
				end
			end
		end
	end

	-- TRIGGERBOT
	if settings.triggerbot then
		local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
		local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000)
		if raycastResult and raycastResult.Instance then
			local hitModel = raycastResult.Instance:FindFirstAncestorOfClass("Model")
			if hitModel and hitModel ~= localPlayer.Character and Players:GetPlayerFromCharacter(hitModel) then
				mouse1click()
			end
		end
	end

	-- AIMASSIST SUAVE (A la Cabeza)
	if settings.aimbotTargeting and settings.aimEnabled then
		local target = getClosestPlayer()
		if target then
			local targetCF = CFrame.new(camera.CFrame.Position, target.Position)
			local smoothAlpha = math.clamp(0.15 / (settings.aimSmoothness * 0.8), 0.01, 0.2)
			camera.CFrame = camera.CFrame:Lerp(targetCF, smoothAlpha)
		end
	end

	-- TARGET INFO CARD EN CRUZ / RETÍCULA
	if settings.targetInfoEnabled then
		local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
		local result = workspace:Raycast(ray.Origin, ray.Direction * 1000)
		if result and result.Instance then
			local char = result.Instance:FindFirstAncestorOfClass("Model")
			local p = char and Players:GetPlayerFromCharacter(char)
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local myRoot = getRootPart(localPlayer.Character)
			local targetRoot = char and getRootPart(char)

			if p and hum and myRoot and targetRoot then
				local dist = math.floor((myRoot.Position - targetRoot.Position).Magnitude / 3.57)
				local tool = char:FindFirstChildOfClass("Tool")
				local weaponName = tool and tool.Name or "Ninguna"

				targetTextLabel.Text = string.format("Objetivo: %s\nVida: %d/%d\nArma: %s\nDistancia: %dm", p.DisplayName, hum.Health, hum.MaxHealth, weaponName, dist)
				targetInfoCard.Visible = true
			else
				targetInfoCard.Visible = false
			end
		else
			targetInfoCard.Visible = false
		end
	end

	-- SPINBOT
	if settings.spinbotEnabled then
		local myRoot = getRootPart(localPlayer.Character)
		local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if myRoot then
			if hum then hum.AutoRotate = false end
			myRoot.CFrame = myRoot.CFrame * CFrame.Angles(0, math.rad(settings.spinbotSpeed), 0)
		end
	end

	-- ACTUALIZAR ESP 2D, SKELETON Y CHAMS
	local myRoot = getRootPart(localPlayer.Character)

	for player, draw in pairs(esp2D) do
		local char = player.Character
		local root = getRootPart(char)
		local hum = char and char:FindFirstChildOfClass("Humanoid")

		-- CHAMS LOGIC
		if settings.chamsEnabled and char then
			if not activeChams[char] then
				local highlight = Instance.new("Highlight")
				highlight.Parent = char
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				
				local isAlly = (player.Team and localPlayer.Team and player.Team == localPlayer.Team)
				highlight.FillColor = isAlly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 30, 30)
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				activeChams[char] = highlight
			end
		end

		if settings.espEnabled and char and root and (not hum or hum.Health > 0) then
			local pos, onScreen = camera:WorldToViewportPoint(root.Position)

			if onScreen then
				local headPos = camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
				local legPos = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))
				local height = math.abs(headPos.Y - legPos.Y)
				local width = height / 1.8

				-- CAJA
				if settings.espBoxesEnabled then
					draw.box.Size = Vector2.new(width, height)
					draw.box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
					draw.box.Color = settings.espColor
					draw.box.Visible = true
				else
					draw.box.Visible = false
				end

				-- NOMBRE
				if settings.espNamesEnabled then
					draw.name.Text = player.DisplayName or player.Name
					draw.name.Position = Vector2.new(pos.X, (pos.Y - height / 2) - 16)
					draw.name.Visible = true
				else
					draw.name.Visible = false
				end

				-- INFORMACIÓN (VIDA / DISTANCIA)
				local infoText = ""
				if settings.espHealthEnabled and hum then
					local hp = math.clamp(math.floor((hum.Health / hum.MaxHealth) * 100), 0, 100)
					infoText = infoText .. "♥ " .. hp .. "% "
				end
				if settings.espDistanceEnabled and myRoot then
					local dist = math.floor((myRoot.Position - root.Position).Magnitude / 3.57)
					infoText = infoText .. "[" .. dist .. "m]"
				end

				if infoText ~= "" then
					draw.info.Text = infoText
					draw.info.Position = Vector2.new(pos.X, (pos.Y + height / 2) + 2)
					draw.info.Visible = true
				else
					draw.info.Visible = false
				end

				-- LÍNEAS / TRACERS
				if settings.espTracersEnabled then
					draw.line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
					draw.line.To = Vector2.new(pos.X, pos.Y)
					draw.line.Color = settings.espColor
					draw.line.Visible = true
				else
					draw.line.Visible = false
				end

				-- SKELETON ESP
				if settings.skeletonESP then
					local head = char:FindFirstChild("Head")
					local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
					local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
					local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
					local leftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
					local rightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")

					if head and torso then
						local hP = camera:WorldToViewportPoint(head.Position)
						local tP = camera:WorldToViewportPoint(torso.Position)
						draw.skel[1].From = Vector2.new(hP.X, hP.Y); draw.skel[1].To = Vector2.new(tP.X, tP.Y); draw.skel[1].Visible = true

						if leftArm then
							local lAP = camera:WorldToViewportPoint(leftArm.Position)
							draw.skel[2].From = Vector2.new(tP.X, tP.Y); draw.skel[2].To = Vector2.new(lAP.X, lAP.Y); draw.skel[2].Visible = true
						end
						if rightArm then
							local rAP = camera:WorldToViewportPoint(rightArm.Position)
							draw.skel[3].From = Vector2.new(tP.X, tP.Y); draw.skel[3].To = Vector2.new(rAP.X, rAP.Y); draw.skel[3].Visible = true
						end
						if leftLeg then
							local lLP = camera:WorldToViewportPoint(leftLeg.Position)
							draw.skel[4].From = Vector2.new(tP.X, tP.Y); draw.skel[4].To = Vector2.new(lLP.X, lLP.Y); draw.skel[4].Visible = true
						end
						if rightLeg then
							local rLP = camera:WorldToViewportPoint(rightLeg.Position)
							draw.skel[5].From = Vector2.new(tP.X, tP.Y); draw.skel[5].To = Vector2.new(rLP.X, rLP.Y); draw.skel[5].Visible = true
						end
					end
				else
					for _, l in ipairs(draw.skel) do l.Visible = false end
				end
			else
				draw.box.Visible = false; draw.name.Visible = false; draw.info.Visible = false; draw.line.Visible = false
				for _, l in ipairs(draw.skel) do l.Visible = false end
			end
		else
			draw.box.Visible = false; draw.name.Visible = false; draw.info.Visible = false; draw.line.Visible = false
			for _, l in ipairs(draw.skel) do l.Visible = false end
		end
	end

	-- Noclip
	if settings.noclipEnabled then
		for _, part in ipairs(localPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end

	-- HEAD HITBOX EXTENDER
	if settings.hitboxEnabled then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				local head = getHeadPart(player.Character)
				if head then
					if not originalHeadSizes[head] then originalHeadSizes[head] = head.Size end
					head.Size = Vector3.new(settings.hitboxSize, settings.hitboxSize, settings.hitboxSize)
					head.Transparency = 0.6
					head.CanCollide = false
				end
			end
		end
	end

	-- Speed / Jump / Bhop
	local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid and myRoot then
		if settings.speedEnabled then
			humanoid.WalkSpeed = settings.customSpeed
			if humanoid.MoveDirection.Magnitude > 0 then
				local moveDir = humanoid.MoveDirection
				myRoot.CFrame = myRoot.CFrame + (moveDir * (settings.customSpeed / 10) * delta * 10)
			end
		end
		
		if settings.jumpEnabled then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = settings.customJump
			humanoid.JumpHeight = (settings.customJump / 5)
		end
		
		if settings.bhopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			if humanoid.FloorMaterial ~= Enum.Material.Air then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end
end)

-- Fly Function
RunService.Heartbeat:Connect(function()
	if settings.flyEnabled and localPlayer.Character then
		local rootPart = getRootPart(localPlayer.Character)
		local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if rootPart and humanoid then
			humanoid.PlatformStand = true
			local camCF = camera.CFrame
			local moveVector = Vector3.new(0, 0, 0)
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + camCF.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - camCF.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - camCF.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + camCF.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, 1, 0) end
			local vel = moveVector * settings.flySpeed
			rootPart.Velocity = vel; rootPart.AssemblyLinearVelocity = vel
		end
	elseif localPlayer.Character then
		local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.PlatformStand = false end
	end
end)
