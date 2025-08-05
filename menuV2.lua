local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Crear ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Crear Frame principal (menú)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 350)
Frame.Position = UDim2.new(0.5, -125, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Text = "Steal a Brainrot Menu"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextScaled = true
Title.Parent = Frame

-- Botón para ocultar el menú
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0.2, 0, 0.1, 0)
HideButton.Position = UDim2.new(0.8, 0, 0, 0)
HideButton.Text = "X"
HideButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
HideButton.TextColor3 = Color3.new(1, 1, 1)
HideButton.TextScaled = true
HideButton.Parent = Frame

-- Botón circular para mostrar el menú
local ShowButton = Instance.new("ImageButton")
ShowButton.Size = UDim2.new(0, 50, 0, 50)
ShowButton.Position = UDim2.new(1, -60, 0.5, -25)
ShowButton.BackgroundTransparency = 1
ShowButton.Image = "rbxassetid://0" -- Cambia por un ID de imagen circular si tienes uno
ShowButton.Visible = false
ShowButton.Parent = ScreenGui

-- Alternar visibilidad del menú
HideButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
    ShowButton.Visible = true
end)

ShowButton.MouseButton1Click:Connect(function()
    Frame.Visible = true
    ShowButton.Visible = false
end)

-- Función para crear botones
local buttons = {}
local function createButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0.1, 0)
    button.Position = UDim2.new(0.1, 0, position, 0)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Parent = Frame
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Speed Boost
local speedEnabled = false
buttons.Speed = createButton("Speed Boost: OFF", 0.15, function()
    speedEnabled = not speedEnabled
    buttons.Speed.Text = "Speed Boost: " .. (speedEnabled and "ON" or "OFF")
    humanoid.WalkSpeed = speedEnabled and 50 or 16
end)

-- ESP
local espEnabled = false
local highlights = {}
local function addESP(target)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = target
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = target
    return highlight
end

local function toggleESP()
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                highlights[p] = addESP(p.Character)
            end
        end
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Brainrot" then
                highlights[obj] = addESP(obj)
            end
        end
    else
        for _, highlight in pairs(highlights) do
            highlight:Destroy()
        end
        highlights = {}
    end
end

buttons.ESP = createButton("ESP: OFF", 0.3, function()
    espEnabled = not espEnabled
    buttons.ESP.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    toggleESP()
end)

-- Actualizar ESP para nuevos jugadores
Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(char)
        if espEnabled then
            highlights[newPlayer] = addESP(char)
        end
    end)
end)

-- Auto Lock
local autoLockEnabled = false
buttons.AutoLock = createButton("Auto Lock: OFF", 0.45, function()
    autoLockEnabled = not autoLockEnabled
    buttons.AutoLock.Text = "Auto Lock: " .. (autoLockEnabled and "ON" or "OFF")
    if autoLockEnabled then
        -- Buscar la base del jugador (ajusta según el juego)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Base" and obj:FindFirstChild("Owner") and obj.Owner.Value == player then
                ReplicatedStorage.LockBase:FireServer(obj) -- Ajusta el nombre del evento remoto
                break
            end
        end
    end
end)

-- Auto Hit (Lanzatelarañas)
local autoHitEnabled = false
local function autoHit()
    while autoHitEnabled do
        local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if tool and tool.Name == "WebShooter" then -- Ajusta el nombre de la herramienta
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character.Humanoid and p.Character.Humanoid.Health > 0 then
                    tool:Activate()
                    rootPart.CFrame = CFrame.new(rootPart.Position, p.Character.HumanoidRootPart.Position)
                    wait(0.5)
                end
            end
        end
        wait(0.3)
    end
end

buttons.AutoHit = createButton("Auto Hit: OFF", 0.6, function()
    autoHitEnabled = not autoHitEnabled
    buttons.AutoHit.Text = "Auto Hit: " .. (autoHitEnabled and "ON" or "OFF")
    if autoHitEnabled then
        spawn(autoHit)
    end
end)

-- Control de Altura de Salto
local jumpPower = 50 -- Valor predeterminado
local JumpLabel = Instance.new("TextLabel")
JumpLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
JumpLabel.Position = UDim2.new(0.1, 0, 0.75, 0)
JumpLabel.Text = "Jump Power: " .. jumpPower
JumpLabel.TextColor3 = Color3.new(1, 1, 1)
JumpLabel.BackgroundTransparency = 1
JumpLabel.TextScaled = true
JumpLabel.Parent = Frame

local function updateJumpPower()
    humanoid.JumpPower = jumpPower
    JumpLabel.Text = "Jump Power: " .. jumpPower
end

local JumpUp = createButton("Jump +10", 0.85, function()
    jumpPower = math.min(jumpPower + 10, 200) -- Límite máximo
    updateJumpPower()
end)

local JumpDown = createButton("Jump -10", 0.95, function()
    jumpPower = math.max(jumpPower - 10, 0) -- Límite mínimo
    updateJumpPower()
end)

-- Actualizar personaje si se reinicia
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    if speedEnabled then
        humanoid.WalkSpeed = 50
    end
    updateJumpPower()
    if espEnabled then
        toggleESP()
    end
end)

print("Script cargado para Steal a Brainrot. ¡Disfruta!")
