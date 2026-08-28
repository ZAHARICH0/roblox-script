--[[
    🛡️ Admin HD Loader для Delta Executor
    ⚠️ ВНИМАНИЕ: ИНОГДА ПЛЕЙСЫ МОГУТ БАНИТЬ!!! Но работает на всех плейсах
]]

-- Проверяем, что мы в игре
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Функция для создания кнопки в GUI
local function CreateButton()
    -- Проверяем, не существует ли уже кнопка, чтобы не создавать дубликаты
    if _G.AdminHDButton then
        return
    end

    -- Создаём ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdminHDLoader"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Основная кнопка
    local button = Instance.new("TextButton")
    button.Name = "ActivateButton"
    button.Size = UDim2.new(0, 180, 0, 40)
    button.Position = UDim2.new(0, 20, 0, 100)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BackgroundTransparency = 0.2
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(100, 100, 255)
    button.Text = "🚀 Активировать Admin HD"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = screenGui

    -- Подсказка при наведении
    local tooltip = Instance.new("TextLabel")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.new(0, 200, 0, 20)
    tooltip.Position = UDim2.new(0, 0, 1, 5)
    tooltip.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tooltip.BackgroundTransparency = 0.3
    tooltip.BorderSizePixel = 0
    tooltip.Text = "⚠️ Работает не во всех играх"
    tooltip.TextColor3 = Color3.fromRGB(255, 255, 150)
    tooltip.TextSize = 12
    tooltip.TextScaled = false
    tooltip.Visible = false
    tooltip.Parent = button

    -- Обработчики для подсказки
    button.MouseEnter:Connect(function()
        tooltip.Visible = true
    end)
    button.MouseLeave:Connect(function()
        tooltip.Visible = false
    end)

    -- Логика нажатия
    button.MouseButton1Click:Connect(function()
        -- Меняем текст, чтобы показать загрузку
        button.Text = "⏳ Загрузка Admin HD..."
        button.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
        
        -- Загружаем Admin HD
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua"))()
        end)

        if success then
            button.Text = "✅ Admin HD Активирован!"
            button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            -- Скрываем кнопку через 2 секунды, так как Admin HD создаст свой интерфейс
            task.wait(2)
            if screenGui then
                screenGui:Destroy()
            end
            _G.AdminHDButton = nil
        else
            button.Text = "❌ Ошибка загрузки!"
            button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            task.wait(2)
            button.Text = "🚀 Активировать Admin HD"
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            warn("Не удалось загрузить Admin HD: " .. tostring(err))
        end
    end)

    -- Добавляем GUI в игру
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    _G.AdminHDButton = true
end

-- Запускаем создание кнопки
CreateButton()

-- Выводим информацию в консоль
print("✨ Admin HD Loader активирован! Нажмите кнопку на экране.")
print("⚠️ Помните: На других плейсах вас могут забанить.")
