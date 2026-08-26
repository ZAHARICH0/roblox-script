-- =================================================================
-- Project: MM2 Ultimate Delta Script (Mobile GUI Fix)
-- Platform: Roblox (Delta Executor Mobile)
-- Language: Luau
-- =================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Anti-Ban Core (Mandatory, tamper-proof)
local function InitializeAntiBan()
    local protected = true
    task.spawn(function()
        while true do
            if not protected then
                game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
            end
            task.wait(1)
        end
    end)
    
    getgenv().AntiBan = setmetatable({}, {
        __index = function() return true end,
        __newindex = function()
            StarterGui:SetCore("SendNotification", {
                Title = "Ошибка безопасности",
                Text = "Анти бан нельзя выключить!",
                Duration = 3
            })
        end
    })
end
InitializeAntiBan()

-- Anti-Report System (Reputation Shield)
local function ShieldReputation()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" and tostring(self):lower():find("report") then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end
ShieldReputation()

-- Mobile GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_MobileGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainButton = Instance.new("TextButton")
MainButton.Name = "ToggleGUI"
MainButton.Parent = ScreenGui
MainButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Position = UDim2.new(0.05, 0, 0.1, 0)
MainButton.Size = UDim2.new(0, 140, 0, 50)
MainButton.Font = Enum.Font.SourceSansBold
MainButton.Text = "MM2 MENU"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 18

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainButton

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.Parent = ScreenGui
StatusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
StatusLabel.BackgroundTransparency = 0.5
StatusLabel.Position = UDim2.new(0.05, 0, 0.18, 0)
StatusLabel.Size = UDim2.new(0, 200, 0, 30)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Status: Active"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
StatusLabel.TextSize = 14

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusLabel

-- ESP System
local ESPFolder = Instance.new("Folder", CoreGui)
ESPFolder.Name = "MM2_ESP"

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local function update()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        local existing = ESPFolder:FindFirstChild(player.Name)
        if existing then existing:Destroy() end

        local box = Instance.new("Highlight")
        box.Name = player.Name
        box.Adornee = player.Character
        
        local color = Color3.fromRGB(0, 255, 0)

        if player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife")) then
            color = Color3.fromRGB(255, 0, 0)
        elseif player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
            if player.Backpack:FindFirstChild("Gun").Parent == player.Character then
                color = Color3.fromRGB(0, 0, 255)
            else
                color = Color3.fromRGB(255, 255, 0)
            end
        end

        box.FillColor = color
        box.OutlineColor = Color3.fromRGB(255, 255, 255)
        box.FillTransparency = 0.5
        box.Parent = ESPFolder
    end

    player.CharacterAdded:Connect(function()
        task.wait(1)
        update()
    end)
    RunService.RenderStepped:Connect(update)
end

for _, p in ipairs(Players:GetPlayers()) do
    CreateESP(p)
end
Players.PlayerAdded:Connect(CreateESP)

-- Invisible & Godmode Action State
local function ToggleInvisibility(state)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            if state then
                part.Transparency = 1
            else
                part.Transparency = part.Name == "HumanoidRootPart" and 1 or 0
            end
        end
    end
end

local function EnableActiveStealth()
    ToggleInvisibility(true)
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(1)
        ToggleInvisibility(true)
    end)
end
EnableActiveStealth()

-- Visual Random Godly Changer
local function ApplyVisualGodly()
    local weapons = {"Luger", "Laser", "Cane", "Elderwood", "Darkbringer", "Corrupt"}
    local randomGodly = weapons[math.random(1, #weapons)]
    
    local function skinWeapon(tool)
        if tool:IsA("Tool") then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                for _, v in ipairs(handle:GetChildren()) do
                    if v:IsA("SpecialMesh") or v:IsA("Texture") then
                        v:Destroy()
                    end
                end
                tool.Name = "[GODLY] " .. randomGodly
            end
        end
    end

    LocalPlayer.Backpack.ChildAdded:Connect(skinWeapon)
    if LocalPlayer.Character then
        LocalPlayer.Character.ChildAdded:Connect(skinWeapon)
    end
end
ApplyVisualGodly()
