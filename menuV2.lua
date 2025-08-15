local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Variables para guardar el estado de las opciones
local savedStates = {
    teleportEnabled = false,
    autoFarmEnabled = false,
    antiHitEnabled = false
}

-- Función para aplicar las opciones guardadas
local function applySavedStates()
    -- Aquí iría la lógica para activar las funciones si savedStates.teleportEnabled, etc. es true
    -- Por ejemplo: if savedStates.teleportEnabled then activateTeleport() end
end

-- Función para inicializar el script
local function initializeScript()
    if PlayerGui:FindFirstChild("CustomMenu") then
        PlayerGui.CustomMenu:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomMenu"
    screenGui.Parent = PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.2, 0, 0.4, 0)
    mainFrame.Position = UDim2.new(0.5, -mainFrame.Size.X.Scale * 0.5, 0.5, -mainFrame.Size.Y.Scale * 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 2
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Text = "Menú Secreto del Cerebro Podrido"
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.Parent = mainFrame

    local hideButton = Instance.new("TextButton")
    hideButton.Size = UDim2.new(0.2, 0, 0.1, 0)
    hideButton.Position = UDim2.new(0.8, 0, 0, 0)
    hideButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    hideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    hideButton.Text = "Ocultar"
    hideButton.Font = Enum.Font.SourceSansBold
    hideButton.TextSize = 16
    hideButton.Parent = mainFrame

    local iconButton = Instance.new("TextButton")
    iconButton.Size = UDim2.new(0.05, 0, 0.05, 0)
    iconButton.Position = UDim2.new(1, -iconButton.Size.X.Scale, 0.5, -iconButton.Size.Y.Scale * 0.5)
    iconButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    iconButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
    iconButton.BorderSizePixel = 2
    iconButton.CornerRadius = UDim.new(0.5, 0)
    iconButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconButton.Text = "🧠"
    iconButton.Font = Enum.Font.SourceSansBold
    iconButton.TextSize = 24
    iconButton.Visible = false
    iconButton.Parent = screenGui

    local function hideMenu()
        mainFrame.Visible = false
        iconButton.Visible = true
    end

    local function showMenu()
        mainFrame.Visible = true
        iconButton.Visible = false
    end

    hideButton.MouseButton1Click:Connect(hideMenu)
    iconButton.MouseButton1Click:Connect(showMenu)

    -- Botón de Teleport
    local optionButton1 = Instance.new("TextButton")
    optionButton1.Size = UDim2.new(0.8, 0, 0.1, 0)
    optionButton1.Position = UDim2.new(0.1, 0, 0.2, 0)
    optionButton1.BackgroundColor3 = savedStates.teleportEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 80, 80)
    optionButton1.TextColor3 = Color3.fromRGB(255, 255, 255)
    optionButton1.Text = "Activar Teleport"
    optionButton1.Parent = mainFrame
    optionButton1.MouseButton1Click:Connect(function()
        savedStates.teleportEnabled = not savedStates.teleportEnabled
        optionButton1.BackgroundColor3 = savedStates.teleportEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 80, 80)
        print("Teleport ha sido " .. (savedStates.teleportEnabled and "activado" or "desactivado"))
    end)

    -- Botón de Auto-Farm
    local optionButton2 = Instance.new("TextButton")
    optionButton2.Size = UDim2.new(0.8, 0, 0.1, 0)
    optionButton2.Position = UDim2.new(0.1, 0, 0.35, 0)
    optionButton2.BackgroundColor3 = savedStates.autoFarmEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 80, 80)
    optionButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
    optionButton2.Text = "Auto-Farm"
    optionButton2.Parent = mainFrame
    optionButton2.MouseButton1Click:Connect(function()
        savedStates.autoFarmEnabled = not savedStates.autoFarmEnabled
        optionButton2.BackgroundColor3 = savedStates.autoFarmEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 80, 80)
        print("Auto-Farm ha sido " .. (savedStates.autoFarmEnabled and "activado" or "desactivado"))
    end)

    -- Nuevo botón para el Anti-Hit
    local antiHitButton = Instance.new("TextButton")
    antiHitButton.Size = UDim2.new(0.8, 0, 0.1, 0)
    antiHitButton.Position = UDim2.new(0.1, 0, 0.5, 0)
    antiHitButton.BackgroundColor3 = savedStates.antiHitEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 80, 80)
    antiHitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    antiHitButton.Text = "Anti-Hit"
    antiHitButton.Parent = mainFrame
    antiHitButton.MouseButton1Click:Connect(function()
        savedStates.antiHitEnabled = not savedStates.antiHitEnabled
        antiHitButton.BackgroundColor3 = savedStates.antiHitEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 80, 80)
        print("Anti-Hit ha sido " .. (savedStates.antiHitEnabled and "activado" or "desactivado"))
    end)

    if not mainFrame.Visible and iconButton.Visible then
        hideMenu()
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    initializeScript()
    applySavedStates()
end)

-- Primera inicialización del script
initializeScript()
applySavedStates()
