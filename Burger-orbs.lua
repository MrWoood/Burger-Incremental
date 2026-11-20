local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local container = gethui and gethui() or game:GetService("CoreGui")

local Window = Rayfield:CreateWindow({
    Name = "Burger Incremental Orbs farm",
    LoadingTitle = "Burger Incremental",
    LoadingSubtitle = "by Mavr0di",
    Theme = "Default",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
    Parent = container,
})

local OrbTab = Window:CreateTab("Orbs", nil)
local MiscTab = Window:CreateTab("Misc", nil)

local cfg = {
    AntiAfk = false,
}

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local PG = LP:WaitForChild("PlayerGui")
local OrbControl = RS.Assets.Remotes.OrbControl
local VirtualUser = game:GetService("VirtualUser")

local function stopOrb(orbId)
    pcall(function()
        OrbControl:InvokeServer("Stop", orbId, LP:GetAttribute("ProgressResetRevision") or 0)
    end)
end

local function hideOrbGui()
    for _, gui in ipairs(PG:GetDescendants()) do
        if gui:IsA("ScreenGui") and (gui.Name:lower():find("orb") or gui.Name:lower():find("menu")) then
            gui.Enabled = false
        end
    end
end

OrbTab:CreateSection("Background Farming")
OrbTab:CreateButton({ Name = "Start Classic Orb (No GUI)",
    Callback = function()
        hideOrbGui()
        local rev = LP:GetAttribute("ProgressResetRevision") or 0
        pcall(function() OrbControl:InvokeServer("Start", "ClassicOrb", rev) end)
    end })
OrbTab:CreateButton({ Name = "Start Magic Orb (No GUI)",
    Callback = function()
        hideOrbGui()
        local rev = LP:GetAttribute("ProgressResetRevision") or 0
        pcall(function() OrbControl:InvokeServer("Start", "MagicOrb", rev) end)
    end })
OrbTab:CreateButton({ Name = "Stop All Orbs",
    Callback = function()
        stopOrb("ClassicOrb")
        stopOrb("MagicOrb")
    end })

MiscTab:CreateSection("Anti-AFK")
MiscTab:CreateToggle({ Name = "Anti-AFK", CurrentValue = false,
    Callback = function(s) cfg.AntiAfk = s end })

LP.Idled:Connect(function()
    if cfg.AntiAfk then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)