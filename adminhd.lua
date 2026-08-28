--[[
    📱 Admin HD Loader для Delta Executor (Mobile/Tablet)
    ⚠️ ВНИМАНИЕ: ИНОГДА ПЛЕЙСЫ МОГУТ БАНИТЬ!!! Но работает на всех плейсах
    💡 ИДЕЯ: Нажал → кнопка пропала → Admin HD активирован (чисто и красиво)
]]

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local function CreateButton()
    if _G.AdminHDButton then
        return
    end

    local viewportSize = workspace.CurrentCamera.ViewportSize
    local screenWidth = viewportSize.X

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdminHDLoader"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local isMobile = screenWidth < 800
    local buttonWidth = isMobile and 200 or 180
    local buttonHeight = isMobile and 50 or 40
    local fontSize = isMobile and 14 or 18
    
    local button = Instance.new("TextButton")
    button.Name = "ActivateButton"
    button.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
    button.Position = UDim2.new(0.5, -buttonWidth/2, 0, isMobile and 50 or 100)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BackgroundTransparency = 0.2
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(100, 100, 255)
    button.Text = "🚀 Активировать Admin HD"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = fontSize
    button.TextScaled = false
    button.Font = Enum.Font.SourceSansBold
    button.Parent = screenGui

    local tooltip = Instance.new("TextLabel")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.new(0, buttonWidth + 20, 0, 25)
    tooltip.Position = UDim2.new(0.5, -buttonWidth/2 - 10, 0, buttonHeight + 5)
    tooltip.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tooltip.BackgroundTransparency = 0.3
    tooltip.BorderSizePixel = 1
    tooltip.BorderColor3 = Color3.fromRGB(200, 200, 200)
    tooltip.Text = "⚠️ Нажми → Admin HD активируется"
    tooltip.TextColor3 = Color3.fromRGB(255, 255, 150)
    tooltip.TextSize = isMobile and 11 or 12
    tooltip.TextScaled = false
    tooltip.Visible = true
    tooltip.Parent = screenGui

    -- Анимация появления
    button.BackgroundTransparency = 1
    tooltip.BackgroundTransparency = 1
    
    task.wait(0.1)
    
    for i = 0, 1, 0.05 do
        button.BackgroundTransparency = 0.2 * (1 - i)
        tooltip.BackgroundTransparency = 0.3 * (1 - i)
        task.wait(0.02)
    end

    button.MouseButton1Click:Connect(function()
        -- ⭐ ГЛАВНАЯ ИДЕЯ: GUI пропадает МГНОВЕННО при нажатии
        screenGui:Destroy()
        _G.AdminHDButton = nil
        
        -- Загружаем Admin HD в фоне
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua"))()
        end)
        
        print("✅ Admin HD активирован! ГУИ пропал, как и задумано.")
    end)

    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        local newSize = workspace.CurrentCamera.ViewportSize
        local newIsMobile = newSize.X < 800
        
        local newWidth = newIsMobile and 200 or 180
        local newHeight = newIsMobile and 50 or 40
        button.Size = UDim2.new(0, newWidth, 0, newHeight)
        button.Position = UDim2.new(0.5, -newWidth/2, 0, newIsMobile and 50 or 100)
        tooltip.Size = UDim2.new(0, newWidth + 20, 0, 25)
        tooltip.Position = UDim2.new(0.5, -newWidth/2 - 10, 0, newHeight + 5)
        tooltip.TextSize = newIsMobile and 11 or 12
        button.TextSize = newIsMobile and 14 or 18
    end)
    
    _G.AdminHDButton = true
end

CreateButton()
print("📱 Admin HD Loader готов! Нажми на кнопку — она пропадёт, а Admin HD активируется.")
