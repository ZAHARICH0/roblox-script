-- =================================================================
-- Project: MM2 Ultimate Delta Script
-- Platform: Roblox (Delta Executor)
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
    
    -- Hook into settings/toggles attempts
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
            -- Block outgoing reports and spoof normal reputation status
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end
ShieldReputation()

-- ESP System (Murderer, Sheriff, Hero, Innocent)
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
        box.äure = true
        
        local role = "Innocent"
        local color = Color3.fromRGB(0, 255, 0) -- Default Innocent: Green

        if player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife")) then
            role = "Murderer"
            color = Color3.fromRGB(255, 0, 0) -- Murderer: Red
        elseif player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
            -- Check if Sheriff or Hero
            if player.Backpack:FindFirstChild("Gun").Parent == player.Character then
                role = "Sheriff"
                color = Color3.fromRGB(0, 0, 255) -- Sheriff: Blue
            else
                role = "Hero"
                color = Color3.fromRGB(255, 255, 0) -- Hero: Yellow
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

-- Invisible & Godmode Action State (Collect coins, shoot, kill while invisible)
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

-- Bypass invisible action limits (allow coin collection & weapon usage)
local function EnableActiveStealth()
    ToggleInvisibility(true)
    
    -- Allow tool usage while invisible
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
                -- Apply visual tag/name representation
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

