
-- Mfevzidemir Hub v2.0
-- Enhanced Roblox Exploit Script - Optimized for performance and reliability
-- GitHub: https://github.com/armlesshere/mfevzidemir-hub

-- Remote loading validation
if not game:GetService("RunService"):IsClient() then
    warn("Mfevzidemir Hub: Must run on client side")
    return
end

-- Version check
local MFEVZIDEMIR_VERSION = "2.0"
print("Mfevzidemir Hub v" .. MFEVZIDEMIR_VERSION .. " - Loading...") 

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Error handling and cleanup system
local ErrorHandler = {
    connections = {},
    tweens = {},
    guis = {},
    sounds = {}
}

local function SafeConnect(connection)
    table.insert(ErrorHandler.connections, connection)
    return connection
end

local function SafeTween(tween)
    table.insert(ErrorHandler.tweens, tween)
    return tween
end

local function SafeGui(gui)
    table.insert(ErrorHandler.guis, gui)
    return gui
end

local function SafeSound(sound)
    table.insert(ErrorHandler.sounds, sound)
    return sound
end

local function CleanupAll()
    -- Disconnect all connections
    for _, connection in pairs(ErrorHandler.connections) do
        if connection and connection.Disconnect then
            pcall(connection.Disconnect, connection)
        end
    end
    
    -- Cancel all tweens
    for _, tween in pairs(ErrorHandler.tweens) do
        if tween and tween.Cancel then
            pcall(tween.Cancel, tween)
        end
    end
    
    -- Destroy all GUIs
    for _, gui in pairs(ErrorHandler.guis) do
        if gui and gui.Destroy then
            pcall(gui.Destroy, gui)
        end
    end
    
    -- Stop and destroy all sounds
    for _, sound in pairs(ErrorHandler.sounds) do
        if sound then
            pcall(function()
                sound:Stop()
                sound:Destroy()
            end)
        end
    end
    
    -- Clear tables
    ErrorHandler.connections = {}
    ErrorHandler.tweens = {}
    ErrorHandler.guis = {}
    ErrorHandler.sounds = {}
end

-- Early validation with better error handling
if not LocalPlayer then
    warn("Script Error: Must run as LocalScript")
    return
end

local Player = LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Set up cleanup on player leaving
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == Player then
        CleanupAll()
    end
end)

-- Performance optimization: Cache frequently used values
local tick = tick
local math_random = math.random
local math_sin = math.sin
local math_floor = math.floor
local math_min = math.min
local math_max = math.max
local table_insert = table.insert
local task_spawn = task.spawn
local task_delay = task.delay
local task_wait = task.wait

-- Optimized loading configuration
local LoadingConfig = {
    Duration = 6, -- Reduced from 8 for faster loading
    FadeOutTime = 1.2, -- Faster fade out
BarColor = Color3.fromRGB(200, 0, 255),
BarGlow = Color3.fromRGB(255, 100, 255),
BackgroundColor = Color3.fromRGB(10, 0, 20), 
TextColor = Color3.fromRGB(255, 200, 255),
    ParticleCount = 80, -- Reduced for better performance
    ParticleSpeed = 1.5,
    ParticleSize = 2,
    RectangleCount = 20, -- Reduced rectangle particles
    MaxParticles = 100 -- Global particle limit
}

local LoadingElements = {("Made by Why Developments Team"),
}

local Particles = {}
local AnimationConnections = {}

-- Optimized particle creation with object pooling
local ParticlePool = {}
local ActiveParticles = {}

local function CreateStarParticle(parent, x, y)
    local star, corner, gradient
    
    -- Try to reuse existing particle
    if #ParticlePool > 0 then
        local pooled = ParticlePool[#ParticlePool]
        ParticlePool[#ParticlePool] = nil
        star = pooled.frame
        corner = pooled.corner
        gradient = pooled.gradient
        star.Parent = parent
        star.Visible = true
    else
        star = Instance.new("Frame")
star.Name = "StarParticle"
star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
star.BorderSizePixel = 0
star.ZIndex = 8

        corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = star

        gradient = Instance.new("UIGradient")
gradient.Parent = star
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(147, 51, 234)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
    end
    
    local size = math_random(1, LoadingConfig.ParticleSize)
    star.Size = UDim2.new(0, size, 0, size)
    star.Position = UDim2.new(0, x, 0, y)
    star.BackgroundTransparency = math_random(20, 60) / 100

local particle = {
    frame = star,
        corner = corner,
        gradient = gradient,
        speedX = (math_random(-100, 100) / 100) * LoadingConfig.ParticleSpeed,
        speedY = (math_random(-100, 100) / 100) * LoadingConfig.ParticleSpeed,
        rotationSpeed = math_random(-3, 3),
        pulseSpeed = math_random(1, 2),
        opacity = math_random(40, 80) / 100,
        lastUpdate = tick()
    }
    
    table_insert(ActiveParticles, particle)
return particle
end

local function CreateParticleSystem(parent)
local screenSize = workspace.CurrentCamera.ViewportSize
    local particleCount = math_min(LoadingConfig.ParticleCount, LoadingConfig.MaxParticles)
    
    for i = 1, particleCount do
        local x = math_random(0, screenSize.X)
        local y = math_random(0, screenSize.Y)
    local particle = CreateStarParticle(parent, x, y)
        table_insert(Particles, particle)
end
end

local RectangleParticles = {}
local RectanglePool = {}

local function CreateRectangleParticle(parent, x)
    local rect, corner, gradient
    
    -- Try to reuse existing rectangle
    if #RectanglePool > 0 then
        local pooled = RectanglePool[#RectanglePool]
        RectanglePool[#RectanglePool] = nil
        rect = pooled.frame
        corner = pooled.corner
        gradient = pooled.gradient
        rect.Parent = parent
        rect.Visible = true
    else
        rect = Instance.new("Frame")
rect.Name = "RectangleParticle"
rect.BackgroundColor3 = Color3.fromRGB(200, 0, 255) 
rect.BorderSizePixel = 0
rect.ZIndex = 8
        
        corner = Instance.new("UICorner")
corner.Parent = rect

        gradient = Instance.new("UIGradient")
gradient.Parent = rect
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 51, 234))
})
    end
    
    rect.Size = UDim2.new(0, math_random(6, 20), 0, math_random(12, 40)) 
    rect.Position = UDim2.new(0, x, 0, -50) 
    rect.BackgroundTransparency = math_random(30, 70) / 100
    corner.CornerRadius = UDim.new(0, math_random(2, 6))
    gradient.Rotation = math_random(0, 360)

local particle = {
    frame = rect,
        corner = corner,
        gradient = gradient,
        speedY = math_random(2, 6),
        rotationSpeed = math_random(-1, 1), 
        lastUpdate = tick()
}

return particle
end

local function CreateRectangleSystem(parent)
local screenSize = workspace.CurrentCamera.ViewportSize
    local spacing = 60 -- Increased spacing for better performance
    local columns = math_floor(screenSize.X / spacing) 
    local maxRectangles = math_min(LoadingConfig.RectangleCount, columns * 3)
    
    for i = 1, maxRectangles do
        local x = math_random(0, screenSize.X)
        local delayedSpawn = math_random(0, 200) / 100
        task_delay(delayedSpawn * 0.01, function()
    local particle = CreateRectangleParticle(parent, x)
            table_insert(RectangleParticles, particle)
end)
end
end

local function UpdateRectangles()
local screenSize = workspace.CurrentCamera.ViewportSize
    local currentTime = tick()

    for i = #RectangleParticles, 1, -1 do
        local particle = RectangleParticles[i]
    if particle.frame and particle.frame.Parent then
            local deltaTime = currentTime - particle.lastUpdate
            particle.lastUpdate = currentTime
            
            local newY = particle.frame.Position.Y.Offset + (particle.speedY * deltaTime * 60)
            particle.frame.Rotation = particle.frame.Rotation + (particle.rotationSpeed * deltaTime * 60)
            
            local pulseValue = math_sin(currentTime * 1.5 + i) * 0.15 + 0.4
            particle.frame.BackgroundTransparency = math_min(0.9, particle.frame.BackgroundTransparency + pulseValue * 0.05)
            
        if newY > screenSize.Y + 100 then
                -- Pool the particle instead of destroying
                particle.frame.Visible = false
                particle.frame.Parent = nil
                table_insert(RectanglePool, particle)
                table.remove(RectangleParticles, i)
        else
            particle.frame.Position = UDim2.new(0, particle.frame.Position.X.Offset, 0, newY)
        end
        else
            table.remove(RectangleParticles, i)
    end
end
end

local function UpdateParticles(parentFrame)
local screenSize = workspace.CurrentCamera.ViewportSize
    local currentTime = tick()
    
    for i = #Particles, 1, -1 do
        local particle = Particles[i]
    if particle.frame and particle.frame.Parent then
            local deltaTime = currentTime - particle.lastUpdate
            particle.lastUpdate = currentTime
            
        local currentPos = particle.frame.Position
            local newX = currentPos.X.Offset + (particle.speedX * deltaTime * 60)
            local newY = currentPos.Y.Offset + (particle.speedY * deltaTime * 60)
        
            -- Wrap around screen edges
        if newX < -10 then
            newX = screenSize.X + 10
        elseif newX > screenSize.X + 10 then
            newX = -10
        end
        
        if newY < -10 then
            newY = screenSize.Y + 10
        elseif newY > screenSize.Y + 10 then
            newY = -10
        end
        
        particle.frame.Position = UDim2.new(0, newX, 0, newY)
            particle.frame.Rotation = particle.frame.Rotation + (particle.rotationSpeed * deltaTime * 60)
        
            local pulseValue = math_sin(currentTime * particle.pulseSpeed * 1.5) * 0.3 + 0.7
        particle.frame.BackgroundTransparency = 1 - (particle.opacity * pulseValue)
            
            local sizeMultiplier = 1 + (math_sin(currentTime * particle.pulseSpeed * 0.3) * 0.15)
            local baseSize = LoadingConfig.ParticleSize
            particle.frame.Size = UDim2.new(0, baseSize * sizeMultiplier, 0, baseSize * sizeMultiplier)
        else
            table.remove(Particles, i)
    end
end
end

local function CreateAdvancedBackground(parent)
local bgFrame = Instance.new("Frame")
bgFrame.Name = "AdvancedBackground"
bgFrame.Parent = parent
bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgFrame.BorderSizePixel = 0
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.Position = UDim2.new(0, 0, 0, 0)
bgFrame.ZIndex = 1

local gradient1 = Instance.new("UIGradient")
gradient1.Parent = bgFrame
gradient1.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 20)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(10, 0, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
gradient1.Rotation = 45

local animateGradient = TweenService:Create(
    gradient1,
    TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Rotation = 225}
)
animateGradient:Play()
table.insert(AnimationConnections, animateGradient)

local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Parent = bgFrame
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BorderSizePixel = 0
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.Position = UDim2.new(0, 0, 0, 0)
overlay.ZIndex = 2
overlay.BackgroundTransparency = 0.3

local overlayGradient = Instance.new("UIGradient")
overlayGradient.Parent = overlay
overlayGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 0, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 0, 20))
})
overlayGradient.Rotation = -45

local animateOverlay = TweenService:Create(
    overlayGradient,
    TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Rotation = 315}
)
animateOverlay:Play()
table.insert(AnimationConnections, animateOverlay)

return bgFrame
end

local function CreatePulsingCircles(parent)
for i = 1, 5 do
    local circle = Instance.new("Frame")
    circle.Name = "PulsingCircle" .. i
    circle.Parent = parent
    circle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    circle.BorderSizePixel = 0
    circle.Size = UDim2.new(0, 100 + (i * 50), 0, 100 + (i * 50))
    circle.Position = UDim2.new(0.5, -(50 + (i * 25)), 0.5, -(50 + (i * 25)))
    circle.ZIndex = 3
    circle.BackgroundTransparency = 0.8 + (i * 0.03)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle
    
    local pulseTween = TweenService:Create(
        circle,
        TweenInfo.new(2 + (i * 0.3), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {
            Size = UDim2.new(0, 120 + (i * 60), 0, 120 + (i * 60)),
            Position = UDim2.new(0.5, -(60 + (i * 30)), 0.5, -(60 + (i * 30))),
            BackgroundTransparency = 0.95
        }
    )
    pulseTween:Play()
    table.insert(AnimationConnections, pulseTween)
end
end

local function CreateLoadingScreen()
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumLoadingScreen"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ScreenInsets = Enum.ScreenInsets.None
ScreenGui.IgnoreGuiInset = true

-- Register GUI for cleanup
SafeGui(ScreenGui)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = LoadingConfig.BackgroundColor
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.Position = UDim2.new(0, 0, 0, 0)
MainFrame.ZIndex = 10

local advancedBg = CreateAdvancedBackground(MainFrame)
CreatePulsingCircles(MainFrame)
CreateParticleSystem(MainFrame)
CreateRectangleSystem(MainFrame)

local CenterContainer = Instance.new("Frame")
CenterContainer.Name = "CenterContainer"
CenterContainer.Parent = MainFrame
CenterContainer.BackgroundTransparency = 1
CenterContainer.Size = UDim2.new(0, 600, 0, 400)
CenterContainer.Position = UDim2.new(0.5, -300, 0.5, -100)
CenterContainer.ZIndex = 11

local Icon = Instance.new("ImageLabel")
Icon.Name = "Icon"
Icon.Parent = CenterContainer
Icon.BackgroundTransparency = 1
Icon.Size = UDim2.new(0, 80, 0, 80)
Icon.Position = UDim2.new(0.5, -40, 0, -40)
Icon.Image = "rbxassetid://13458212275"
Icon.ZIndex = 13

local iconRotation = TweenService:Create(
    Icon,
    TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Rotation = 360}
)
iconRotation:Play()
table.insert(AnimationConnections, iconRotation)

local iconPulse = TweenService:Create(
    Icon,
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {
        Size = UDim2.new(0, 90, 0, 90),
        Position = UDim2.new(0.5, -45, 0, -45)
    }
)
iconPulse:Play()
table.insert(AnimationConnections, iconPulse)

local uiStroke = Instance.new("UIStroke")
uiStroke.Parent = Icon
uiStroke.Color = Color3.fromRGB(200, 0, 255)
uiStroke.Thickness = 3
uiStroke.Transparency = 0.3

local strokeGlow = TweenService:Create(
    uiStroke,
    TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Transparency = 0.1, Thickness = 5}
)
strokeGlow:Play()
table.insert(AnimationConnections, strokeGlow)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = CenterContainer
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 0, 80)
TitleLabel.Position = UDim2.new(0, 0, 0, 50)
TitleLabel.Text = "Mfevzidemir Hub is Loading..."
TitleLabel.TextColor3 = LoadingConfig.TextColor
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.ZIndex = 12

local titleStroke = Instance.new("UIStroke")
titleStroke.Parent = TitleLabel
titleStroke.Color = Color3.fromRGB(147, 51, 234)
titleStroke.Thickness = 2
titleStroke.Transparency = 0.5

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Parent = TitleLabel
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(147, 51, 234)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 51, 234))
})

local titleAnimation = TweenService:Create(
    TitleGradient,
    TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Offset = Vector2.new(2, 0)}
)
titleAnimation:Play()
table.insert(AnimationConnections, titleAnimation)

local glowTween = TweenService:Create(
    titleStroke,
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Transparency = 0.1}
)
glowTween:Play()
table.insert(AnimationConnections, glowTween)

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Name = "SubtitleLabel"
SubtitleLabel.Parent = MainFrame
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Size = UDim2.new(0, 400, 0, 40)
SubtitleLabel.Position = UDim2.new(0.5, -600, 1, -50) 
SubtitleLabel.Text = "github.com/armlesshere/mfevzidemir-hub"
SubtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
SubtitleLabel.TextScaled = false
SubtitleLabel.TextSize = 12
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.ZIndex = 12
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
SubtitleLabel.TextYAlignment = Enum.TextYAlignment.Bottom

local ProgressContainer = Instance.new("Frame")
ProgressContainer.Name = "ProgressContainer"
ProgressContainer.Parent = CenterContainer
ProgressContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ProgressContainer.BorderSizePixel = 0
ProgressContainer.Size = UDim2.new(1, 0, 0, 25)
ProgressContainer.Position = UDim2.new(0, 0, 0, 160)
ProgressContainer.ZIndex = 12

local ProgressCorner = Instance.new("UICorner")
ProgressCorner.CornerRadius = UDim.new(0, 12)
ProgressCorner.Parent = ProgressContainer

local ProgressStroke = Instance.new("UIStroke")
ProgressStroke.Parent = ProgressContainer
ProgressStroke.Color = LoadingConfig.BarGlow
ProgressStroke.Thickness = 2
ProgressStroke.Transparency = 0.3

local strokePulse = TweenService:Create(
    ProgressStroke,
    TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Transparency = 0.1}
)
strokePulse:Play()
table.insert(AnimationConnections, strokePulse)

local ProgressBar = Instance.new("Frame")
ProgressBar.Name = "ProgressBar"
ProgressBar.Parent = ProgressContainer
ProgressBar.BackgroundColor3 = LoadingConfig.BarColor
ProgressBar.BorderSizePixel = 0
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.Position = UDim2.new(0, 0, 0, 0)
ProgressBar.ZIndex = 13

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 12)
BarCorner.Parent = ProgressBar

local BarGradient = Instance.new("UIGradient")
BarGradient.Parent = ProgressBar
BarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, LoadingConfig.BarColor),
    ColorSequenceKeypoint.new(0.5, LoadingConfig.BarGlow),
    ColorSequenceKeypoint.new(1, LoadingConfig.BarColor)
})

local barGradientAnim = TweenService:Create(
    BarGradient,
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Offset = Vector2.new(1, 0)}
)
barGradientAnim:Play()
table.insert(AnimationConnections, barGradientAnim)

local PercentageLabel = Instance.new("TextLabel")
PercentageLabel.Name = "PercentageLabel"
PercentageLabel.Parent = CenterContainer
PercentageLabel.BackgroundTransparency = 1
PercentageLabel.Size = UDim2.new(1, 0, 0, 40)
PercentageLabel.Position = UDim2.new(0, 0, 0, 200)
PercentageLabel.Text = "0%"
PercentageLabel.TextColor3 = LoadingConfig.BarColor
PercentageLabel.TextScaled = true
PercentageLabel.Font = Enum.Font.GothamBold
PercentageLabel.ZIndex = 12

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = CenterContainer
StatusLabel.BackgroundTransparency = 1
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 250)
StatusLabel.Text = "Made by Why Developments Team (Loading...)"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.ZIndex = 12

local DotsLabel = Instance.new("TextLabel")
DotsLabel.Name = "DotsLabel"
DotsLabel.Parent = CenterContainer
DotsLabel.BackgroundTransparency = 1
DotsLabel.Size = UDim2.new(0, 60, 0, 30)
DotsLabel.Position = UDim2.new(1, -60, 0, 250)
DotsLabel.Text = ""
DotsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
DotsLabel.TextScaled = true
DotsLabel.Font = Enum.Font.Gotham
DotsLabel.ZIndex = 12

return ScreenGui, ProgressBar, PercentageLabel, StatusLabel, DotsLabel, nil, MainFrame
end

local function AnimateDots(dotsLabel)
local dots = ""
local dotCount = 0

spawn(function()
    while dotsLabel.Parent do
        dotCount = (dotCount + 1) % 4
        dots = string.rep(".", dotCount)
        dotsLabel.Text = dots
        wait(0.4)
    end
end)
end

local function solutionsLoad()
local screenGui, progressBar, percentageLabel, statusLabel, dotsLabel, glowEffect, mainFrame = CreateLoadingScreen()

AnimateDots(dotsLabel)

local particleConnection = RunService.Heartbeat:Connect(function()
UpdateParticles(mainFrame)    
UpdateRectangles()            
end)
table.insert(AnimationConnections, particleConnection)

local startTime = tick()
local currentElementIndex = 1
local lastElementTime = startTime

local function updateProgress()
    local elapsed = tick() - startTime
    local progress = math.min(elapsed / LoadingConfig.Duration, 1)
    local percentage = math.floor(progress * 100)
    
    local barTween = TweenService:Create(
        progressBar,
        TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.new(progress, 0, 1, 0)}
    )
    barTween:Play()
    
    local percentTween = TweenService:Create(
        percentageLabel,
        TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {TextColor3 = Color3.fromRGB(147 + (percentage * 0.5), 51 + (percentage * 0.8), 234)}
    )
    percentTween:Play()
    
    percentageLabel.Text = percentage .. "%"
    
    local elementTime = LoadingConfig.Duration / #LoadingElements
    if tick() - lastElementTime >= elementTime and currentElementIndex <= #LoadingElements then
        statusLabel.Text = LoadingElements[currentElementIndex]
        
        local statusTween = TweenService:Create(
            statusLabel,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {TextTransparency = 0}
        )
        statusTween:Play()
        
        currentElementIndex = currentElementIndex + 1
        lastElementTime = tick()
    end
    
    if progress >= 1 then
        wait(0.8)
        
        for _, connection in pairs(AnimationConnections) do
            if typeof(connection) == "RBXScriptConnection" then
                connection:Disconnect()
            elseif typeof(connection) == "Tween" then
                connection:Cancel()
            end
        end
        
        for _, particle in pairs(Particles) do
            if particle.frame then
                particle.frame:Destroy()
            end
        end
        
        local fadeOutTween = TweenService:Create(
            mainFrame,
            TweenInfo.new(LoadingConfig.FadeOutTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {
                BackgroundTransparency = 1,
                Size = UDim2.new(1.5, 0, 1.5, 0),
                Position = UDim2.new(-0.25, 0, -0.25, 0)
            }
        )
        
        local contentFadeTween = TweenService:Create(
            mainFrame.CenterContainer,
            TweenInfo.new(LoadingConfig.FadeOutTime * 0.7, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }
        )
        
        fadeOutTween:Play()
        contentFadeTween:Play()
        
        fadeOutTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
        
        return
    end
    
    RunService.Heartbeat:Wait()
    updateProgress()
end

updateProgress()
end
-- Enhanced Sound System with Error Handling
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://9085027122"
sound.Volume = 0.8 -- Reduced volume for better user experience
sound.Looped = false
sound.PlaybackSpeed = 1
sound.Parent = SoundService

-- Register sound for cleanup
SafeSound(sound)

-- Safe sound cleanup
local soundConnection = sound.Ended:Connect(function()
    SafeSound(nil) -- Remove from tracking
    pcall(function()
        sound:Destroy()
    end)
end)
SafeConnect(soundConnection)
-- LocalScript

-- Enhanced Execution with Error Handling
local function SafeExecute(func, name)
    task_spawn(function()
        local success, result = pcall(func)
        if not success then
            warn("Error in " .. (name or "unknown function") .. ": " .. tostring(result))
        end
    end)
end

-- Execute loading screen and sound safely
SafeExecute(solutionsLoad, "Loading Screen")
SafeExecute(function()
    pcall(function()
        sound:Play()
    end)
end, "Sound Playback")
-- Global Warning Suppression System
local GlobalSuppression = {
    enabled = true,
    suppressedMessages = {
        "Duplicate named remote",
        "not added to cache",
        "RemoteEvent",
        "RemoteFunction"
    }
}

local function SetupGlobalSuppression()
    if not GlobalSuppression.enabled then return end
    
    local originalWarn = warn
    local originalPrint = print
    
    -- Override warn function globally
    warn = function(message)
        local shouldSuppress = false
        for _, suppressedMsg in ipairs(GlobalSuppression.suppressedMessages) do
            if string.find(message, suppressedMsg) then
                shouldSuppress = true
                break
            end
        end
        
        if not shouldSuppress then
            originalWarn(message)
        end
    end
    
    -- Override print function globally
    print = function(message)
        local shouldSuppress = false
        for _, suppressedMsg in ipairs(GlobalSuppression.suppressedMessages) do
            if string.find(message, suppressedMsg) then
                shouldSuppress = true
                break
            end
        end
        
        if not shouldSuppress then
            originalPrint(message)
        end
    end
end

-- Setup global suppression early
SetupGlobalSuppression()

-- Enhanced Game Detection System
local GameDatabase = {
    -- Popular Games Database
    [4924922222] = { -- Brookhaven
        name = "Brookhaven RP",
        script = "https://scriptsbinsauth.vercel.app/api/scripts/61a69984-9e07-44cc-bf9f-b6720fcee96c/raw",
        secondary = "https://raw.githubusercontent.com/wx-sources/Nytherune/refs/heads/main/LaunchScriptBrookhaven.luau",
        priority = 1
    },
    [7326934954] = { -- Noites99
        name = "Noites99",
        script = "https://scriptsbinsauth.vercel.app/api/scripts/3130fd4f-0a1c-443a-a30f-7f2c74cdb7a3/raw",
        priority = 2
    },
    [142823291] = { -- Murder Mystery 2
        name = "Murder Mystery 2",
        script = "https://raw.githubusercontent.com/example/mm2-script/main/script.lua",
        priority = 3
    },
    [286090429] = { -- Arsenal
        name = "Arsenal",
        script = "https://raw.githubusercontent.com/example/arsenal-script/main/script.lua",
        priority = 4
    },
    [142823291] = { -- Jailbreak
        name = "Jailbreak",
        script = "https://raw.githubusercontent.com/example/jailbreak-script/main/script.lua",
        priority = 5
    }
}

-- Fallback Script URLs
local FallbackScripts = {
    "https://raw.githubusercontent.com/wx-sources/Nytherune/refs/heads/main/UniversalScript.luau",
    "https://scriptsbinsauth.vercel.app/api/scripts/universal/raw"
}

local function GetGameInfo(placeId)
    return GameDatabase[placeId] or GameDatabase[game.GameId]
end

local function LoadScriptSafely(url, retries)
    retries = retries or 3
    
    for attempt = 1, retries do
        local success, result = pcall(function()
            return game:HttpGet(url, true)
        end)
        
        if success and result then
            local loadSuccess, loadResult = pcall(function()
                -- Enhanced error handling for remote conflicts
                local originalWarn = warn
                local originalPrint = print
                
                -- Suppress all duplicate remote warnings globally
                warn = function(message)
                    if not string.find(message, "Duplicate named remote") and 
                       not string.find(message, "not added to cache") then
                        originalWarn(message)
                    end
                end
                
                -- Also suppress print statements that might show warnings
                print = function(message)
                    if not string.find(message, "Duplicate named remote") and 
                       not string.find(message, "not added to cache") then
                        originalPrint(message)
                    end
                end
                
                local scriptResult = loadstring(result)()
                
                -- Restore original functions
                warn = originalWarn
                print = originalPrint
                
                return scriptResult
            end)
            
            if loadSuccess then
                return true, "Script loaded successfully"
            else
                warn("Script execution failed (attempt " .. attempt .. "): " .. tostring(loadResult))
            end
        else
            warn("Failed to fetch script (attempt " .. attempt .. "): " .. tostring(result))
        end
        
        if attempt < retries then
            task_wait(1) -- Wait before retry
        end
    end
    
    return false, "All attempts failed"
end
-- Enhanced Game Detection and Script Loading
task_wait(5)

local currentGame = GetGameInfo(game.PlaceId)
local scriptLoaded = false

if currentGame then
    print("Detected Game: " .. currentGame.name)
    
    -- Try primary script
    local success, message = LoadScriptSafely(currentGame.script)
    if success then
        scriptLoaded = true
        print("Primary script loaded successfully")
        
        -- Load secondary script if available
        if currentGame.secondary then
            task_spawn(function()
                task_wait(0.5) -- Small delay
                LoadScriptSafely(currentGame.secondary)
            end)
        end
    else
        warn("Primary script failed: " .. message)
    end
else
    warn("Unsupported game detected. PlaceId: " .. game.PlaceId .. ", GameId: " .. game.GameId)
end

-- Fallback system
if not scriptLoaded then
    print("Attempting fallback scripts...")
    
    for i, fallbackUrl in ipairs(FallbackScripts) do
        local success, message = LoadScriptSafely(fallbackUrl, 2)
        if success then
            print("Fallback script " .. i .. " loaded successfully")
            scriptLoaded = true
            break
        else
            warn("Fallback script " .. i .. " failed: " .. message)
        end
    end
end

-- Final fallback with memory management
if not scriptLoaded then
    warn("All scripts failed to load. Game may not be supported.")
    
    SafeExecute(function()
        local notification = Instance.new("ScreenGui")
        notification.Parent = PlayerGui
        notification.Name = "ScriptError"
        SafeGui(notification)
        
        local frame = Instance.new("Frame")
        frame.Parent = notification
        frame.Size = UDim2.new(0, 400, 0, 100)
        frame.Position = UDim2.new(0.5, -200, 0.5, -50)
        frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "This game is not supported by Mfevzidemir Hub"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        
        -- Auto-destroy after 5 seconds
        task_delay(5, function()
            pcall(function()
                notification:Destroy()
            end)
        end)
    end, "Error Notification")
end

-- Memory optimization: Clear unused tables after loading
task_delay(10, function()
    Particles = nil
    RectangleParticles = nil
    ParticlePool = nil
    RectanglePool = nil
    ActiveParticles = nil
    LoadingElements = nil
    
    -- Force garbage collection
    collectgarbage("collect")
end)

-- Performance monitoring
local PerformanceMonitor = {
    startTime = tick(),
    frameCount = 0,
    lastFPS = 0
}

local function UpdatePerformanceStats()
    PerformanceMonitor.frameCount = PerformanceMonitor.frameCount + 1
    local currentTime = tick()
    
    if currentTime - PerformanceMonitor.startTime >= 1 then
        PerformanceMonitor.lastFPS = PerformanceMonitor.frameCount
        PerformanceMonitor.frameCount = 0
        PerformanceMonitor.startTime = currentTime
        
        -- Log performance stats (optional)
        if PerformanceMonitor.lastFPS < 30 then
            warn("Performance Warning: Low FPS detected (" .. PerformanceMonitor.lastFPS .. ")")
        end
    end
end

-- Connect performance monitoring
SafeConnect(RunService.Heartbeat:Connect(UpdatePerformanceStats)) 