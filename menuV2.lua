local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Variables para guardar el estado de las opciones
local savedStates = {
    teleportEnabled = false,
    autoFarmEnabled = false,
    antiHitEnabled = false
}

local currentTab = "Stealer"
local debounce = false

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

-- Lógica para las funciones del script
local function activateTeleport()
    -- Esta es una suposición de cómo podría funcionar un teleport
    local targetPosition = Vector3.new(0, 100, 0) -- Reemplazar con la posición deseada
    local remote = ReplicatedStorage:FindFirstChild("TeleportRemoteEvent") -- Nombre de ejemplo
    if remote then
        remote:FireServer(targetPosition)
        print("Intentando teleportar a la posición:", targetPosition)
    else
        print("No se encontró el RemoteEvent de Teleport.")
    end
end

local function activateAutoFarm()
    -- Lógica de auto-farm: buscar objetos para farmear y teletransportarse a ellos
    -- Esto es muy específico del juego, es solo un ejemplo
    local target = game.Workspace:FindFirstChild("Brainrot") -- Nombre de ejemplo
    if target then
        local remote = ReplicatedStorage:FindFirstChild("FarmRemoteEvent") -- Nombre de ejemplo
        if remote then
            remote:FireServer(target)
            print("Activado Auto-Farm en:", target.Name)
        else
            print("No se encontró el RemoteEvent de Auto-Farm.")
        end
    end
end

local function activateAntiHit()
    if antiHitEnabled and not debounce then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local webSlinger = character:FindFirstChildOfClass("Tool") -- Buscar la herramienta
        
        if webSlinger and webSlinger.Name == "WebSlinger" then
            debounce = true
            
            -- La forma más común de usar una herramienta es a través de un RemoteEvent
            -- que se dispara cuando el jugador hace clic.
            -- Hay que encontrar el RemoteEvent correcto. Es solo una suposición.
            local remote = ReplicatedStorage:FindFirstChild("UseToolRemoteEvent") 
            
            if remote then
                -- Simular que el jugador tiene la herramienta equipada
                LocalPlayer.Character.Humanoid:EquipTool(webSlinger)
                
                -- Obtener la posición del personaje para disparar la telaraña hacia sí mismo
                local targetPosition = character.HumanoidRootPart.Position
                
                -- Disparar el RemoteEvent con la posición del objetivo
                remote:FireServer(targetPosition)
                
                print("Anti-Hit activado. Invulnerabilidad por 10 segundos.")
                wait(10)
                
            else
                print("No se encontró el RemoteEvent para el Anti-Hit.")
            end
            
            debounce = false
        else
            print("No se encontró el guante WebSlinger o no es una herramienta.")
        end
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

    -- (El resto del código para la GUI, barra de título, botones de pestañas, etc. es el mismo)
    -- ...
    -- ...
    -- Pestaña Stealer
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
        if savedStates.teleportEnabled then
            activateTeleport()
        end
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
        if savedStates.autoFarmEnabled then
            activateAutoFarm()
        end
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
        if savedStates.antiHitEnabled then
            -- La lógica del Anti-Hit ahora se activa directamente con el botón
            -- La función que usa Heartbeat es lo ideal para esto
            -- Por simplicidad y para la prueba, lo llamaremos aquí
            activateAntiHit() 
        end
    end)
    
    -- El resto del código de pestañas Helper, Player, Finder, Server, Discord!
    -- ...
    
    -- Inicializa la visibilidad de las pestañas
    changeTab(currentTab)
    updateButtonColors(mainFrame)
end

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    initializeScript()
end)

initializeScript()
