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
    SOVICH - TWD3 PRO (DRAWING TRACERS + METROS ESP + SEARCH TELEPORT)
    v3.2 Update: Universal Movement Engine Fix (Supports CFrame / JumpHeight / WalkSpeed)
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local defaultWalkSpeed = 16
local defaultJumpPower = 50
local defaultJumpHeight = 7.2

local settings = {
	aimEnabled = false,
	aimSmoothness = 5,
	aimKey = Enum.UserInputType.MouseButton2,
	espEnabled = false,
	espNamesEnabled = false,
	espTracersEnabled = true,
	espHealthEnabled = true,
	espDistanceEnabled = true,
	flyEnabled = false,
	noclipEnabled = false,
	speedEnabled = false,
	jumpEnabled = false,
	bhopEnabled = false,
	hitboxEnabled = false,
	targetPart = "Head",
	hitboxSize = 5,
	fovRadius = 140,
	flySpeed = 50,
	customSpeed = 32,
	customJump = 100,
	espColor = Color3.fromRGB(170, 0, 255),
	aimbotTargeting = false,
	tpSearchText = ""
}

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
	end
end

if localPlayer.Character then
	setupCharacter(localPlayer.Character)
end
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
titleText.Text = "SOVICH HUB  |  v3.2 Pro"
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

local tabs, currentTab = {}, nil
local function createTabContent(name)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = name .. "Content"
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
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
	if callback then 
		btn.MouseButton1Click:Connect(function() callback(btn) end) 
	end
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

-- CONTROLES
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
		if hum then 
			hum.JumpPower = defaultJumpPower 
			hum.JumpHeight = defaultJumpHeight
		end
	end
end)
createSliderIn(tabMain, 4, settings.customJump, 50, 350, "Altura Salto", function(val) settings.customJump = val end)

createButtonIn(tabCombat, 1, "Aimbot / AimAssist: OFF", function(btn)
	settings.aimEnabled = not settings.aimEnabled
	btn.Text = settings.aimEnabled and "Aimbot / AimAssist: ON" or "Aimbot / AimAssist: OFF"
	btn.BackgroundColor3 = settings.aimEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)
createSliderIn(tabCombat, 2, settings.fovRadius, 50, 300, "Tamaño FOV", function(val)
	settings.fovRadius = val; fovFrame.Size = UDim2.new(0, val * 2, 0, val * 2)
end)
createSliderIn(tabCombat, 3, settings.aimSmoothness, 1, 10, "AimAssist Suavizado (1=Fuerte, 10=Súper Suave)", function(val)
	settings.aimSmoothness = val
end)
createButtonIn(tabCombat, 4, "Hitbox Extender: OFF", function(btn)
	settings.hitboxEnabled = not settings.hitboxEnabled
	btn.Text = settings.hitboxEnabled and "Hitbox Extender: ON" or "Hitbox Extender: OFF"
	btn.BackgroundColor3 = settings.hitboxEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)
createSliderIn(tabCombat, 5, settings.hitboxSize, 2, 20, "Tamaño Hitbox", function(val) settings.hitboxSize = val end)

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

createButtonIn(tabVisuals, 1, "ESP / Chams: OFF", function(btn)
	settings.espEnabled = not settings.espEnabled
	btn.Text = settings.espEnabled and "ESP / Chams: ON" or "ESP / Chams: OFF"
	btn.BackgroundColor3 = settings.espEnabled and Color3.fromRGB(60, 0, 110) or Color3.fromRGB(25, 20, 40)
end)
createButtonIn(tabVisuals, 2, "Mostrar Nombres: OFF", function(btn)
	settings.espNamesEnabled = not settings.espNamesEnabled
	btn.Text = settings.espNamesEnabled and "Mostrar Nombres: ON" or "Mostrar Nombres: OFF"
end)
createButtonIn(tabVisuals, 3, "Mostrar Vida (♥ %): ON", function(btn)
	settings.espHealthEnabled = not settings.espHealthEnabled
	btn.Text = settings.espHealthEnabled and "Mostrar Vida (♥ %): ON" or "Mostrar Vida (♥ %): OFF"
end)
createButtonIn(tabVisuals, 4, "Mostrar Distancia (m): ON", function(btn)
	settings.espDistanceEnabled = not settings.espDistanceEnabled
	btn.Text = settings.espDistanceEnabled and "Mostrar Distancia (m): ON" or "Mostrar Distancia (m): OFF"
end)
createButtonIn(tabVisuals, 5, "Líneas (Tracers): ON", function(btn)
	settings.espTracersEnabled = not settings.espTracersEnabled
	btn.Text = settings.espTracersEnabled and "Líneas (Tracers): ON" or "Líneas (Tracers): OFF"
end)

--// SISTEMA ESP Y TRACERS 2D EXACTOS
local espObjects = {}

local function applyHighlight(player, char)
	if not char then return end
	local espInfo = espObjects[player]
	if not espInfo then return end

	if espInfo.chams then
		espInfo.chams:Destroy()
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = "Chams_" .. player.Name
	highlight.FillColor = settings.espColor
	highlight.FillTransparency = 0.5
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Enabled = settings.espEnabled
	highlight.Parent = char
	espInfo.chams = highlight
end

local function getESP(player)
	if not espObjects[player] then
		local espGui = Instance.new("BillboardGui")
		espGui.Name = "ESP_" .. player.Name
		espGui.AlwaysOnTop = true
		espGui.Size = UDim2.new(0, 200, 0, 60)
		espGui.StudsOffset = Vector3.new(0, 3, 0)
		
		local container = Instance.new("Frame")
		container.Size = UDim2.new(1, 0, 1, 0)
		container.BackgroundTransparency = 1
		container.Parent = espGui

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, 0, 0, 18)
		nameLabel.Position = UDim2.new(0, 0, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.TextStrokeTransparency = 0
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextSize = 13
		nameLabel.Parent = container

		local healthLabel = Instance.new("TextLabel")
		healthLabel.Size = UDim2.new(1, 0, 0, 18)
		healthLabel.Position = UDim2.new(0, 0, 0, 18)
		healthLabel.BackgroundTransparency = 1
		healthLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
		healthLabel.TextStrokeTransparency = 0
		healthLabel.Font = Enum.Font.GothamBold
		healthLabel.TextSize = 13
		healthLabel.Parent = container

		local distLabel = Instance.new("TextLabel")
		distLabel.Size = UDim2.new(1, 0, 0, 36)
		distLabel.Position = UDim2.new(0, 0, 0, 36)
		distLabel.BackgroundTransparency = 1
		distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		distLabel.TextStrokeTransparency = 0
		distLabel.Font = Enum.Font.GothamBold
		distLabel.TextSize = 12
		distLabel.Parent = container

		local tracer = Drawing.new("Line")
		tracer.Visible = false
		tracer.Color = settings.espColor
		tracer.Thickness = 1.5
		tracer.Transparency = 1

		espObjects[player] = {gui = espGui, name = nameLabel, health = healthLabel, dist = distLabel, chams = nil, line = tracer}

		if player.Character then
			applyHighlight(player, player.Character)
		end
		player.CharacterAdded:Connect(function(newChar)
			task.wait(0.2)
			applyHighlight(player, newChar)
		end)
	end
	return espObjects[player]
end

for _, p in ipairs(Players:GetPlayers()) do
	if p ~= localPlayer then getESP(p) end
end
Players.PlayerAdded:Connect(function(p)
	if p ~= localPlayer then getESP(p) end
end)

Players.PlayerRemoving:Connect(function(player)
	if espObjects[player] then
		if espObjects[player].gui then espObjects[player].gui:Destroy() end
		if espObjects[player].chams then espObjects[player].chams:Destroy() end
		if espObjects[player].line then espObjects[player].line:Remove() end
		espObjects[player] = nil
	end
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
					if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
						local targetPos = targetPlayer.Character.HumanoidRootPart.CFrame
						localPlayer.Character.HumanoidRootPart.CFrame = targetPos * CFrame.new(0, 0, 3)
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

--// BÚSQUEDA DE JUGADOR CERCANO
local function getClosestPlayer()
	local closestPlayer = nil
	local shortestDistance = settings.fovRadius
	local mousePos = UserInputService:GetMouseLocation()

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild(settings.targetPart) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
			local targetPos = player.Character[settings.targetPart].Position
			local pos, onScreen = camera:WorldToViewportPoint(targetPos)
			if onScreen then
				local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					closestPlayer = player.Character[settings.targetPart]
				end
			end
		end
	end
	return closestPlayer
end

UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == settings.aimKey and settings.aimEnabled then
		settings.aimbotTargeting = true
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == settings.aimKey then
		settings.aimbotTargeting = false
	end
end)

--// BUCLE PRINCIPAL
RunService.RenderStepped:Connect(function(delta)
	if not camera or not localPlayer.Character then return end
	
	local mousePos = UserInputService:GetMouseLocation()
	fovFrame.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
	fovFrame.Visible = settings.aimEnabled

	-- AIMASSIST SUAVE
	if settings.aimbotTargeting and settings.aimEnabled then
		local target = getClosestPlayer()
		if target then
			local targetCF = CFrame.new(camera.CFrame.Position, target.Position)
			local smoothAlpha = math.clamp(0.15 / (settings.aimSmoothness * 0.8), 0.01, 0.2)
			camera.CFrame = camera.CFrame:Lerp(targetCF, smoothAlpha)
		end
	end

	-- ACTUALIZAR ESP Y TRACERS
	local myRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			local espInfo = getESP(player)
			if settings.espEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
				local root = player.Character.HumanoidRootPart
				local hum = player.Character.Humanoid

				-- Chams
				if espInfo.chams then
					espInfo.chams.Enabled = true
				else
					applyHighlight(player, player.Character)
				end

				-- Textos Cabeza
				espInfo.gui.Parent = player.Character
				espInfo.gui.Adornee = player.Character:FindFirstChild("Head") or root

				-- Nombres
				if settings.espNamesEnabled then
					espInfo.name.Visible = true
					espInfo.name.Text = player.Name
				else
					espInfo.name.Visible = false
				end

				-- Vida
				if settings.espHealthEnabled then
					local hp = math.clamp(math.floor((hum.Health / hum.MaxHealth) * 100), 0, 100)
					espInfo.health.Visible = true
					espInfo.health.Text = "♥ " .. hp .. "%"
				else
					espInfo.health.Visible = false
				end

				-- Distancia en Metros
				if settings.espDistanceEnabled and myRoot then
					local studsDistance = (myRoot.Position - root.Position).Magnitude
					local metersDistance = math.floor(studsDistance / 3.57)
					espInfo.dist.Visible = true
					espInfo.dist.Text = "[" .. metersDistance .. "m]"
				else
					espInfo.dist.Visible = false
				end

				-- TRACERS
				if settings.espTracersEnabled then
					local pos, onScreen = camera:WorldToViewportPoint(root.Position)
					if onScreen then
						espInfo.line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
						espInfo.line.To = Vector2.new(pos.X, pos.Y)
						espInfo.line.Color = settings.espColor
						espInfo.line.Visible = true
					else
						espInfo.line.Visible = false
					end
				else
					espInfo.line.Visible = false
				end
			else
				espInfo.name.Visible = false
				espInfo.health.Visible = false
				espInfo.dist.Visible = false
				espInfo.gui.Parent = nil
				if espInfo.chams then espInfo.chams.Enabled = false end
				if espInfo.line then espInfo.line.Visible = false end
			end
		end
	end

	-- Noclip
	if settings.noclipEnabled then
		for _, part in ipairs(localPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end

	-- Hitbox Extender
	if settings.hitboxEnabled then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				local targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
				if targetPart then
					targetPart.Size = Vector3.new(settings.hitboxSize, settings.hitboxSize, settings.hitboxSize)
					targetPart.Transparency = 0.6
					targetPart.CanCollide = false
				end
			end
		end
	end

	-- Speed / Jump / Bhop (MECANISMO UNIVERSAL)
	local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid and myRoot then
		-- SPEED
		if settings.speedEnabled then
			humanoid.WalkSpeed = settings.customSpeed
			
			-- Forzado por CFrame si el juego bloquea WalkSpeed
			if humanoid.MoveDirection.Magnitude > 0 then
				local moveDir = humanoid.MoveDirection
				myRoot.CFrame = myRoot.CFrame + (moveDir * (settings.customSpeed / 10) * delta * 10)
			end
		end
		
		-- JUMP
		if settings.jumpEnabled then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = settings.customJump
			humanoid.JumpHeight = (settings.customJump / 5)
		end
		
		-- BHOP
		if settings.bhopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			if humanoid.FloorMaterial ~= Enum.Material.Air then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end
end)

-- Fly Function
RunService.Heartbeat:Connect(function()
	if settings.flyEnabled and localPlayer.Character then
		local rootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
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
