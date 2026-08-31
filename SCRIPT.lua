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

-- =================================================================
-- SOVICH v4.0 - FULL SCRIPT CORREGIDO (UI FIX + UISCALE + CHEATS)
-- =================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- Configuración global
local settings = {
    walkSpeed = 16,
    speedEnabled = false,
    jumpPower = 50,
    superJumpEnabled = false,
    infJumpEnabled = false,
    noclipEnabled = false,
    fullbrightEnabled = false,
    espEnabled = false,
    espColor = Color3.fromRGB(255, 50, 50),
    hitboxSize = 2,
    hitboxEnabled = false,
    uiScale = 1.0
}

-- Paleta de colores
local COL = {
    bg = Color3.fromRGB(18, 20, 24),
    panel = Color3.fromRGB(25, 27, 32),
    sidebar = Color3.fromRGB(21, 23, 27),
    accent = Color3.fromRGB(0, 230, 120),
    text = Color3.fromRGB(240, 240, 240),
    muted = Color3.fromRGB(140, 145, 155),
    btn = Color3.fromRGB(32, 35, 42),
    btnActive = Color3.fromRGB(45, 50, 60)
}

-- Limpieza previa
if CoreGui:FindFirstChild("SovichUI") then
    CoreGui.SovichUI:Destroy()
end

-- ScreenGui Principal
local gui = Instance.new("ScreenGui")
gui.Name = "SovichUI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- Marco Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 330)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -165)
MainFrame.BackgroundColor3 = COL.bg
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = MainFrame

-- CONTROLADOR DE ESCALA DE INTERFAZ (UIScale)
local uiScaleObj = Instance.new("UIScale")
uiScaleObj.Scale = settings.uiScale
uiScaleObj.Parent = MainFrame

-- Sistema de Arrastre (Drag)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + (delta.X / uiScaleObj.Scale),
            startPos.Y.Scale, startPos.Y.Offset + (delta.Y / uiScaleObj.Scale)
        )
    end
end)

-- Barra Superior (Header)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = COL.panel
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "SOVICH <font color='#00E678'>v4.0</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = COL.text
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0, 120, 1, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.TextColor3 = COL.muted
CloseBtn.Size = UDim2.new(0, 32, 1, 0)
CloseBtn.Position = UDim2.new(1, -32, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- BARRA LATERAL CORREGIDA (Integrada adentro del panel)
local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Size = UDim2.new(0, 40, 1, -38)
SideBar.Position = UDim2.new(0, 6, 0, 35)
SideBar.BackgroundColor3 = COL.sidebar
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 6)
sideCorner.Parent = SideBar

local sideList = Instance.new("UIListLayout")
sideList.SortOrder = Enum.SortOrder.LayoutOrder
sideList.Padding = UDim.new(0, 4)
sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideList.VerticalAlignment = Enum.VerticalAlignment.Top
sideList.Parent = SideBar

local sidePadding = Instance.new("UIPadding")
sidePadding.PaddingTop = UDim.new(0, 6)
sidePadding.Parent = SideBar

-- Contenedor de Pestañas
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -58, 1, -44)
ContentContainer.Position = UDim2.new(0, 52, 0, 38)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Administrador de Pestañas
local tabs = {}
local tabButtons = {}

local function createTab(id)
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = "Tab_" .. id
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ScrollBarThickness = 2
    tabFrame.ScrollBarImageColor3 = COL.accent
    tabFrame.Visible = false
    tabFrame.Parent = ContentContainer
    
    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 8)
    list.Parent = tabFrame
    
    tabs[id] = tabFrame
    
    -- Botón en el Sidebar
    local btn = Instance.new("TextButton")
    btn.Name = "Btn_" .. id
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Text = id
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = COL.muted
    btn.BackgroundColor3 = COL.btn
    btn.BorderSizePixel = 0
    btn.Parent = SideBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for tId, frame in pairs(tabs) do
            frame.Visible = (tId == id)
        end
        for tId, b in pairs(tabButtons) do
            b.BackgroundColor3 = (tId == id) and COL.btnActive or COL.btn
            b.TextColor3 = (tId == id) and COL.accent or COL.muted
        end
    end)
    
    tabButtons[id] = btn
    return tabFrame
end

-- Crear Pestañas: P (Player), C (Combat), M (Visuals), V (Skins), T (Teleport), S (Settings), A (About)
local tabP = createTab("P")
local tabC = createTab("C")
local tabM = createTab("M")
local tabV = createTab("V")
local tabT = createTab("T")
local tabS = createTab("S")
local tabA = createTab("A")

tabP.Visible = true
tabButtons["P"].BackgroundColor3 = COL.btnActive
tabButtons["P"].TextColor3 = COL.accent

-- =================================================================
-- COMPONENTES DE INTERFAZ (Toggles & Sliders)
-- =================================================================

local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 36)
    frame.BackgroundColor3 = COL.panel
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = COL.text
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local switch = Instance.new("TextButton")
    switch.Text = ""
    switch.Size = UDim2.new(0, 36, 0, 18)
    switch.Position = UDim2.new(1, -44, 0.5, -9)
    switch.BackgroundColor3 = default and COL.accent or COL.btn
    switch.BorderSizePixel = 0
    switch.Parent = frame
    
    local swCorner = Instance.new("UICorner")
    swCorner.CornerRadius = UDim.new(1, 0)
    swCorner.Parent = switch
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    dot.BackgroundColor3 = COL.text
    dot.BorderSizePixel = 0
    dot.Parent = switch
    
    local dCorner = Instance.new("UICorner")
    dCorner.CornerRadius = UDim.new(1, 0)
    dCorner.Parent = dot
    
    local state = default
    switch.MouseButton1Click:Connect(function()
        state = not state
        switch.BackgroundColor3 = state and COL.accent or COL.btn
        dot.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        callback(state)
    end)
end

local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 48)
    frame.BackgroundColor3 = COL.panel
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = COL.text
    label.Position = UDim2.new(0, 10, 0, 6)
    label.Size = UDim2.new(0.6, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valLabel = Instance.new("TextLabel")
    valLabel.Text = tostring(default)
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 12
    valLabel.TextColor3 = COL.accent
    valLabel.Position = UDim2.new(1, -60, 0, 6)
    valLabel.Size = UDim2.new(0, 50, 0, 18)
    valLabel.BackgroundTransparency = 1
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = frame
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 6)
    track.Position = UDim2.new(0, 10, 0, 32)
    track.BackgroundColor3 = COL.btn
    track.BorderSizePixel = 0
    track.Parent = frame
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = track
    
    local fill = Instance.new("Frame")
    local initPct = math.clamp((default - min) / (max - min), 0, 1)
    fill.Size = UDim2.new(initPct, 0, 1, 0)
    fill.BackgroundColor3 = COL.accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0)
    fCorner.Parent = fill
    
    local sliding = false
    local function update(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        if min < 2 and max <= 2 then -- Ajuste de precisión decimal si min/max son flotantes
            val = math.floor((min + (max - min) * pos) * 100) / 100
        end
        valLabel.Text = tostring(val)
        callback(val)
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
            update(input)
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
end

-- =================================================================
-- LLENADO DE PESTAÑAS Y FUNCIONALIDADES
-- =================================================================

-- Pestaña P (Player / Movimiento)
createToggle(tabP, "Activar Speed", settings.speedEnabled, function(v) settings.speedEnabled = v end)
createSlider(tabP, "Velocidad WalkSpeed", 16, 150, settings.walkSpeed, function(v) settings.walkSpeed = v end)
createToggle(tabP, "Super Jump", settings.superJumpEnabled, function(v) settings.superJumpEnabled = v end)
createSlider(tabP, "Potencia Salto", 50, 300, settings.jumpPower, function(v) settings.jumpPower = v end)
createToggle(tabP, "Salto Infinito", settings.infJumpEnabled, function(v) settings.infJumpEnabled = v end)
createToggle(tabP, "Noclip", settings.noclipEnabled, function(v) settings.noclipEnabled = v end)

-- Pestaña C (Combat)
createToggle(tabC, "Expandir Hitbox Cabezas", settings.hitboxEnabled, function(v) settings.hitboxEnabled = v end)
createSlider(tabC, "Tamaño Hitbox", 2, 20, settings.hitboxSize, function(v) settings.hitboxSize = v end)

-- Pestaña M (Visuals)
createToggle(tabM, "ESP 2D / Nombres", settings.espEnabled, function(v) settings.espEnabled = v end)
createToggle(tabM, "Fullbright (Luz Total)", settings.fullbrightEnabled, function(v)
    settings.fullbrightEnabled = v
    if not v then
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
    end
end)

-- Pestaña S (Settings - INCLUYE SLIDER DE ESCALA DE INTERFAZ)
createSlider(tabS, "Escala de Interfaz", 0.5, 1.5, settings.uiScale, function(v)
    settings.uiScale = v
    uiScaleObj.Scale = v
end)

-- Pestaña A (About)
local infoTxt = Instance.new("TextLabel")
infoTxt.Size = UDim2.new(1, -10, 0, 80)
infoTxt.BackgroundColor3 = COL.panel
infoTxt.TextColor3 = COL.muted
infoTxt.Text = "SOVICH Menu UI v4.0\nOptimizaciones visuales y parches integrados.\nEscala dinámica soportada."
infoTxt.Font = Enum.Font.GothamMedium
infoTxt.TextSize = 12
infoTxt.Parent = tabA
local aCorner = Instance.new("UICorner")
aCorner.CornerRadius = UDim.new(0, 6)
aCorner.Parent = infoTxt

-- =================================================================
-- BUCLES DE EJECUCIÓN (CHEATS)
-- =================================================================

-- Movimiento y Noclip
RunService.Stepped:Connect(function()
    if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if settings.speedEnabled then
            hum.WalkSpeed = settings.walkSpeed
        end
        
        if settings.superJumpEnabled then
            hum.JumpPower = settings.jumpPower
        end
        
        if settings.noclipEnabled then
            for _, part in ipairs(localPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
    
    if settings.fullbrightEnabled then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    end
end)

-- Salto Infinito
UserInputService.JumpRequest:Connect(function()
    if settings.infJumpEnabled and localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
        localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Hitbox Expander Seguro
RunService.RenderStepped:Connect(function()
    if settings.hitboxEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                head.Size = Vector3.new(settings.hitboxSize, settings.hitboxSize, settings.hitboxSize)
                head.Transparency = 0.6
                head.CanCollide = false
            end
        end
    end
end)
