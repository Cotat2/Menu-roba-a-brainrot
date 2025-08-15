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

local currentTab = "Stealer" -- La pestaña que se mostrará por defecto

-- Función para actualizar los estados visuales de los botones
local function updateButtonColors(mainFrame)
    local teleportButton = mainFrame:FindFirstChild("StealerTab"):FindFirstChild("TeleportButton")
    if teleportButton then
        teleportButton.BackgroundColor3 = savedStates.teleportEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 80, 80)
    end
    local autoFarmButton = mainFrame:FindFirstChild("StealerTab"):FindFirstChild("AutoFarmButton")
    if autoFarmButton then
        autoFarmButton.BackgroundColor3 = savedStates.autoFarmEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 80, 80)
    end
    local antiHitButton = mainFrame:FindFirstChild("StealerTab"):FindFirstChild("AntiHitButton")
    if antiHitButton then
        antiHitButton.BackgroundColor3 = savedStates.antiHitEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 80, 80)
    end
end

-- Función para aplicar las opciones guardadas (lógica del script)
local function applySavedStates()
    -- Aquí iría la lógica para activar/desactivar las funcionalidades del script
    -- Por ejemplo, si savedStates.antiHitEnabled es true, el script de Anti-Hit se activa
    if savedStates.antiHitEnabled then
        local debounce = false
        RunService.Heartbeat:Connect(function()
            if not debounce then
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local webSlinger = character:FindFirstChild("WebSlinger") 
                if webSlinger then
                    debounce = true
                    -- Simula el uso del Web-Slinger para auto-dispararte
                    -- Esto es solo un ejemplo, la lógica real puede variar
                    webSlinger.Activated:Fire()
                    
                    wait(10)
                    debounce = false
                end
            end
        end)
    end
end

-- Función para inicializar el script (crear la GUI)
local function initializeScript()
    if PlayerGui:FindFirstChild("ChilliHub") then
        PlayerGui.ChilliHub:Destroy()
    end

    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "ChilliHub"
    mainGui.Parent = PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.5, 0, 0.7, 0)
    mainFrame.Position = UDim2.new(0.25, 0, 0.15, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    mainFrame.BorderColor3 = Color3.fromRGB(150, 150, 150)
    mainFrame.BorderSizePixel = 2
    mainFrame.Parent = mainGui

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0.05, 0)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    topBar.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.8, 0, 1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    title.TextColor3 = Color3.fromRGB(0, 0, 0)
    title.Text = "Steal a Brainrot - Chilli Hub - By KhanhSky"
    title.Font = Enum.Font.SourceSans
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.Parent = topBar

    local minButton = Instance.new("TextButton")
    minButton.Size = UDim2.new(0.05, 0, 1, 0)
    minButton.Position = UDim2.new(0.85, 0, 0, 0)
    minButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    minButton.Text = "-"
    minButton.Parent = topBar

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.05, 0, 1, 0)
    closeButton.Position = UDim2.new(0.95, 0, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Parent = topBar

    closeButton.MouseButton1Click:Connect(function()
        mainGui:Destroy()
    end)
    
    -- Barra lateral para las pestañas
    local sideBar = Instance.new("Frame")
    sideBar.Size = UDim2.new(0.2, 0, 0.95, 0)
    sideBar.Position = UDim2.new(0, 0, 0.05, 0)
    sideBar.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    sideBar.Parent = mainFrame
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(0.8, 0, 0.95, 0)
    contentFrame.Position = UDim2.new(0.2, 0, 0.05, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    contentFrame.Parent = mainFrame

    -- Función para cambiar de pestaña
    local function changeTab(tabName)
        currentTab = tabName
        for _, tab in ipairs(contentFrame:GetChildren()) do
            if tab:IsA("Frame") and tab.Name:match("Tab$") then
                tab.Visible = (tab.Name == tabName .. "Tab")
            end
        end
    end

    -- Pestaña Stealer
    local stealerButton = Instance.new("TextButton")
    stealerButton.Size = UDim2.new(1, 0, 0.1, 0)
    stealerButton.Position = UDim2.new(0, 0, 0, 0)
    stealerButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    stealerButton.Text = "Stealer*"
    stealerButton.Parent = sideBar
    stealerButton.MouseButton1Click:Connect(function()
        changeTab("Stealer")
    end)
    
    local stealerTab = Instance.new("Frame")
    stealerTab.Name = "StealerTab"
    stealerTab.Size = UDim2.new(1, 0, 1, 0)
    stealerTab.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    stealerTab.Visible = true
    stealerTab.Parent = contentFrame

    -- Botones dentro de la pestaña Stealer
    local teleportButton = Instance.new("TextButton")
    teleportButton.Name = "TeleportButton"
    teleportButton.Size = UDim2.new(0.8, 0, 0.1, 0)
    teleportButton.Position = UDim2.new(0.1, 0, 0.1, 0)
    teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportButton.Text = "Activar Teleport"
    teleportButton.Parent = stealerTab
    teleportButton.MouseButton1Click:Connect(function()
        savedStates.teleportEnabled = not savedStates.teleportEnabled
        updateButtonColors(mainFrame)
        print("Teleport ha sido " .. (savedStates.teleportEnabled and "activado" or "desactivado"))
    end)
    
    local autoFarmButton = Instance.new("TextButton")
    autoFarmButton.Name = "AutoFarmButton"
    autoFarmButton.Size = UDim2.new(0.8, 0, 0.1, 0)
    autoFarmButton.Position = UDim2.new(0.1, 0, 0.25, 0)
    autoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoFarmButton.Text = "Auto-Farm"
    autoFarmButton.Parent = stealerTab
    autoFarmButton.MouseButton1Click:Connect(function()
        savedStates.autoFarmEnabled = not savedStates.autoFarmEnabled
        updateButtonColors(mainFrame)
        print("Auto-Farm ha sido " .. (savedStates.autoFarmEnabled and "activado" or "desactivado"))
    end)

    local antiHitButton = Instance.new("TextButton")
    antiHitButton.Name = "AntiHitButton"
    antiHitButton.Size = UDim2.new(0.8, 0, 0.1, 0)
    antiHitButton.Position = UDim2.new(0.1, 0, 0.4, 0)
    antiHitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    antiHitButton.Text = "Anti-Hit"
    antiHitButton.Parent = stealerTab
    antiHitButton.MouseButton1Click:Connect(function()
        savedStates.antiHitEnabled = not savedStates.antiHitEnabled
        updateButtonColors(mainFrame)
        print("Anti-Hit ha sido " .. (savedStates.antiHitEnabled and "activado" or "desactivado"))
    end)

    -- Pestaña Helper
    local helperButton = Instance.new("TextButton")
    helperButton.Size = UDim2.new(1, 0, 0.1, 0)
    helperButton.Position = UDim2.new(0, 0, 0.1, 0)
    helperButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    helperButton.Text = "Helper"
    helperButton.Parent = sideBar
    helperButton.MouseButton1Click:Connect(function()
        changeTab("Helper")
    end)
    
    local helperTab = Instance.new("Frame")
    helperTab.Name = "HelperTab"
    helperTab.Size = UDim2.new(1, 0, 1, 0)
    helperTab.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    helperTab.Visible = false
    helperTab.Parent = contentFrame

    -- Pestaña Player
    local playerButton = Instance.new("TextButton")
    playerButton.Size = UDim2.new(1, 0, 0.1, 0)
    playerButton.Position = UDim2.new(0, 0, 0.2, 0)
    playerButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    playerButton.Text = "Player"
    playerButton.Parent = sideBar
    playerButton.MouseButton1Click:Connect(function()
        changeTab("Player")
    end)

    local playerTab = Instance.new("Frame")
    playerTab.Name = "PlayerTab"
    playerTab.Size = UDim2.new(1, 0, 1, 0)
    playerTab.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    playerTab.Visible = false
    playerTab.Parent = contentFrame

    -- Pestaña Finder
    local finderButton = Instance.new("TextButton")
    finderButton.Size = UDim2.new(1, 0, 0.1, 0)
    finderButton.Position = UDim2.new(0, 0, 0.3, 0)
    finderButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    finderButton.Text = "Finder"
    finderButton.Parent = sideBar
    finderButton.MouseButton1Click:Connect(function()
        changeTab("Finder")
    end)
    
    local finderTab = Instance.new("Frame")
    finderTab.Name = "FinderTab"
    finderTab.Size = UDim2.new(1, 0, 1, 0)
    finderTab.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    finderTab.Visible = false
    finderTab.Parent = contentFrame

    -- Pestaña Server
    local serverButton = Instance.new("TextButton")
    serverButton.Size = UDim2.new(1, 0, 0.1, 0)
    serverButton.Position = UDim2.new(0, 0, 0.4, 0)
    serverButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    serverButton.Text = "Server"
    serverButton.Parent = sideBar
    serverButton.MouseButton1Click:Connect(function()
        changeTab("Server")
    end)
    
    local serverTab = Instance.new("Frame")
    serverTab.Name = "ServerTab"
    serverTab.Size = UDim2.new(1, 0, 1, 0)
    serverTab.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    serverTab.Visible = false
    serverTab.Parent = contentFrame
    
    -- Pestaña Discord!
    local discordButton = Instance.new("TextButton")
    discordButton.Size = UDim2.new(1, 0, 0.1, 0)
    discordButton.Position = UDim2.new(0, 0, 0.5, 0)
    discordButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    discordButton.Text = "Discord!"
    discordButton.Parent = sideBar
    discordButton.MouseButton1Click:Connect(function()
        changeTab("Discord!")
    end)
    
    local discordTab = Instance.new("Frame")
    discordTab.Name = "Discord!Tab"
    discordTab.Size = UDim2.new(1, 0, 1, 0)
    discordTab.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    discordTab.Visible = false
    discordTab.Parent = contentFrame

    -- Inicializa la visibilidad de las pestañas
    changeTab(currentTab)
    updateButtonColors(mainFrame)
end

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    initializeScript()
    applySavedStates()
end)

initializeScript()
applySavedStates()
