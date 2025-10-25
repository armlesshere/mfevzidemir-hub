-- Mfevzidemir Hub - Remote Loader Script
-- GitHub: https://github.com/armlesshere/mfevzidemir-hub

local function LoadMfevzidemirHub()
    -- Check if we're in a supported environment
    if not game:GetService("RunService"):IsClient() then
        warn("Mfevzidemir Hub: Must run on client side")
        return false
    end
    
    -- Main script URL
    local scriptUrl = "https://raw.githubusercontent.com/armlesshere/mfevzidemir-hub/main/script.lua"
    
    -- Fallback URLs
    local fallbackUrls = {
        "https://raw.githubusercontent.com/armlesshere/mfevzidemir-hub/main/backup/script.lua",
        "https://gist.githubusercontent.com/armlesshere/[gist-id]/raw/script.lua"
    }
    
    -- Try to load the main script
    local success, result = pcall(function()
        local script = game:HttpGet(scriptUrl, true)
        if script and script ~= "" then
            return loadstring(script)()
        else
            error("Empty script received")
        end
    end)
    
    if success then
        print("Mfevzidemir Hub loaded successfully!")
        return true
    else
        warn("Main script failed: " .. tostring(result))
        
        -- Try fallback URLs
        for i, url in ipairs(fallbackUrls) do
            local fallbackSuccess, fallbackResult = pcall(function()
                local script = game:HttpGet(url, true)
                if script and script ~= "" then
                    return loadstring(script)()
                else
                    error("Empty fallback script")
                end
            end)
            
            if fallbackSuccess then
                print("Mfevzidemir Hub loaded from fallback " .. i .. "!")
                return true
            else
                warn("Fallback " .. i .. " failed: " .. tostring(fallbackResult))
            end
        end
        
        -- Show error notification
        local Players = game:GetService("Players")
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        
        local notification = Instance.new("ScreenGui")
        notification.Parent = PlayerGui
        notification.Name = "MfevzidemirHubError"
        
        local frame = Instance.new("Frame")
        frame.Parent = notification
        frame.Size = UDim2.new(0, 400, 0, 120)
        frame.Position = UDim2.new(0.5, -200, 0.5, -60)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Parent = frame
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Position = UDim2.new(0, 0, 0, 10)
        title.BackgroundTransparency = 1
        title.Text = "Mfevzidemir Hub Error"
        title.TextColor3 = Color3.fromRGB(255, 100, 100)
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        
        local message = Instance.new("TextLabel")
        message.Parent = frame
        message.Size = UDim2.new(1, -20, 0, 60)
        message.Position = UDim2.new(0, 10, 0, 40)
        message.BackgroundTransparency = 1
        message.Text = "Failed to load Mfevzidemir Hub.\nCheck your internet connection and try again."
        message.TextColor3 = Color3.fromRGB(200, 200, 200)
        message.TextScaled = true
        message.Font = Enum.Font.Gotham
        message.TextWrapped = true
        
        -- Auto-destroy after 8 seconds
        task.delay(8, function()
            pcall(function()
                notification:Destroy()
            end)
        end)
        
        return false
    end
end

-- Execute the loader
LoadMfevzidemirHub()
