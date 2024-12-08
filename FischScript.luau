

if getgenv().Loaded or getgenv().Loading then
    print("silly v2: Script was already ran once!")
    return
end

getgenv().Loading = true

print("silly v2: Loading...")

local cloneref = (cloneref or clonereference) or function(a: any) return a end

repeat task.wait() until game:IsLoaded()

local Repository = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/refs/heads/main/"
local Library = loadstring(game:HttpGet(Repository .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(Repository .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(Repository .. "addons/SaveManager.lua"))()
local FlyUtility = loadstring(game:HttpGet("https://raw.githubusercontent.com/Divinedfl/utils_real/refs/heads/main/fly.luau"))()
FlyUtility.ShouldPlatformStand = true

getgenv()._forceunload = function()
    getgenv().Loading = false
    getgenv().Loaded = false
    task.spawn(Library.Unload)
end

type ServiceTable = {
    Players: Players,
    RunService: RunService,
    UserInputService: UserInputService,
    VirtualUser: VirtualUser,
    ReplicatedStorage: ReplicatedStorage,
    Lighting: Lighting,
    VirtualInputManager: VirtualInputManager
}
local Services: ServiceTable = {
    Players = cloneref(game:GetService("Players")),
    RunService = cloneref(game:GetService("RunService")),
    UserInputService = cloneref(game:GetService("UserInputService")),
    VirtualUser = cloneref(game:GetService("VirtualUser")),
    VirtualInputManager = cloneref(game:GetService("VirtualInputManager")),
    ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage")),
    Lighting = cloneref(game:GetService("Lighting"))
}
local Player = Services.Players.LocalPlayer
local Backpack = Player:WaitForChild("Backpack")
local PlayerGui = Player:WaitForChild("PlayerGui")
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")
local Events: Folder = Services.ReplicatedStorage:WaitForChild("events")
local Drown: RemoteEvent = Events:WaitForChild("drown")
local oldmouse1click = mouse1click
local Functions = {}
local Sell: RemoteFunction = workspace.world.npcs:FindFirstChild("sell", true)
local SellAll: RemoteFunction = workspace.world.npcs:FindFirstChild("sellall", true)
local newtable = {}
local nametable = {}
local parts = {}
for _, v in pairs(workspace.world.spawns:GetChildren()) do
    if v.Name ~= "loading" and v.Name ~= "TeleportDelay" and v.Name ~= "TpSpots" then
        newtable[v.Name] = {SpawnPart = v:FindFirstChildWhichIsA("BasePart")}
        local RealName = (if v.Name == "AncientIsle" then "Ancient Isle" elseif v.Name == "DesolateDeep" then "Desolate Deep" else v.Name)
        table.insert(nametable, RealName)
    end
end

for _, v in pairs(Character:GetChildren()) do
    if v:IsA("BasePart") then
        table.insert(parts, v)
    elseif v:IsA("Model") then
        for _, x in pairs(v:GetChildren()) do
            if x:IsA("BasePart") then
                table.insert(parts, x)
            end
        end
    end
end

function Functions.FindFirstChildMatch(parent: Instance, namematch: string, recursive: boolean)
    local ret = nil
    local list = if recursive then parent:GetDescendants() else parent:GetChildren()

    for _, v in ipairs(list) do
        if v.Name:find(namematch) then
            ret = v
            break
        end
    end

    return ret
end

getgenv().mouse1click = function(...) if iswindowactive() then oldmouse1click(...) else return end end

function Functions.MatchWhichIsA(parent: Instance, namematch: string, class: string, recursive: boolean)
    local ret = nil
    local list = if recursive then parent:GetDescendants() else parent:GetChildren()

    for _, v in ipairs(list) do
        if v.Name:find(namematch) and v:IsA(class) then
            ret = v
            break
        end
    end

    return ret
end

function Functions.ReturnRod()
    return Functions.MatchWhichIsA(Character, "Rod", "Tool")
end

function Functions.AttemptReturnShake()
    return (PlayerGui:FindFirstChild("shakeui") and PlayerGui:FindFirstChild("shakeui"):FindFirstChild("safezone") and PlayerGui:FindFirstChild("shakeui"):FindFirstChild("safezone"):FindFirstChild("button"))
end

function Functions.ReturnShake()
    if Functions.AttemptReturnShake() and Functions.AttemptReturnShake().Name == "button" then
        return Functions.AttemptReturnShake()
    end
end
local ScriptWindow = Library:CreateWindow({
    Title = string.format("%s | %s", "silly v2", "Fisch"),
    Center = true,
    AutoShow = true,
    TabPadding = 2,
    MenuFadeTime = 0.09,
    ShowCustomCursor = true
})

local Tabs = {
    Player = ScriptWindow:AddTab("Player"),
    Automation = ScriptWindow:AddTab("Automation"),
    Locations = ScriptWindow:AddTab("Locations"),
    UISettings = ScriptWindow:AddTab("Configs")
}

local PlayerMovement = Tabs.Player:AddLeftGroupbox("Movement")

PlayerMovement:AddSlider("Walkspeed", {
    Text = "Walkspeed",
    Default = 16,
    Max = 300,
    Min = 0,
    Rounding = 0,
    Compact = true
})

PlayerMovement:AddSlider("JumpPower", {
    Text = "Jump Power",
    Default = Humanoid.JumpPower,
    Max = 300,
    Min = 0,
    Rounding = 0,
    Compact = true
})

PlayerMovement:AddToggle("FlyToggle", {
    Text = "Fly",
    Default = false
}):AddKeyPicker("FlyKey", {
    Text = "Fly",
    Default = "F",
    SyncToggleState = true,
    NoUI = false,
    Mode = "Toggle"
})

PlayerMovement:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 16,
    Max = 300,
    Min = 0,
    Rounding = 0,
    Compact = true
})

PlayerMovement:AddToggle("NoclipToggle", {
    Text = "Noclip",
    Default = false
}):AddKeyPicker("NoclipKey", {
    Text = "Noclip",
    Default = "N",
    SyncToggleState = true,
    NoUI = false,
    Mode = "Toggle"
})

PlayerMovement:AddToggle("AnchorPlayer", {
    Text = "Anchor Player",
    Default = false
})

local PlayerBypasses = Tabs.Player:AddRightGroupbox("Bypasses")

PlayerBypasses:AddToggle("AntiDrown", {
    Text = "Anti-Drown",
    Default = false
})

PlayerBypasses:AddToggle("AntiAfk", {
    Text = "Anti-AFK",
    Default = false
})

PlayerBypasses:AddToggle("WalkOnWater", {
    Text = "Walk On Water",
    Default = false
})

local PlayerVisuals = Tabs.Player:AddRightGroupbox("Visuals")

PlayerVisuals:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = false
})
local AutomationAutoShake = Tabs.Automation:AddLeftGroupbox("Auto-Shake")

AutomationAutoShake:AddToggle("AutoShake", {
    Text = "Auto-Shake",
    Default = false
})

AutomationAutoShake:AddToggle("NoButtonMove", {
    Text = "Freeze Shake Button",
    Default = false
})

local AutomationAutoReel = Tabs.Automation:AddLeftGroupbox("Auto-Reel")

AutomationAutoReel:AddToggle("AutoReel", {
    Text = "Auto-Reel",
    Default = false
})

AutomationAutoReel:AddSlider("PerfectReelChance", {
    Text = "Perfect Reel Chance",
    Default = 50,
    Min = 0,
    Max = 99,
    Rounding = 1,
    Compact = true
})

local AutomationAutoMinigame = Tabs.Automation:AddRightGroupbox("Auto Fish Minigame")

AutomationAutoMinigame:AddToggle("AutoFish", {
    Text = "Skip Fish Minigame",
    Default = false
})

local AutomationInventory = Tabs.Automation:AddRightGroupbox("Inventory")

AutomationInventory:AddButton({
    Text = "Sell Equipped Item",
    Func = function()
        local Tool = Character:FindFirstChildWhichIsA("Tool")

        if Tool then
            Sell:InvokeServer(Tool)
        end
    end,
    DoubleClick = true
})

AutomationInventory:AddDivider()

AutomationInventory:AddButton({
    Text = "Sell All Items",
    Func = function()
        SellAll:InvokeServer()
    end,
    DoubleClick = true
})


local LocationsTeleport = Tabs.Locations:AddLeftGroupbox("Teleport")

LocationsTeleport:AddDropdown("TeleportTo", {
    Text = "",
    Values = nametable,
    Multi = false,
    AllowNull = true
})

LocationsTeleport:AddButton({
    Text = "Teleport",
    Func = function()
        Character:PivotTo(newtable[Options.TeleportTo.Value].SpawnPart:GetPivot())
    end
})

Toggles.FlyToggle:OnChanged(function(value)
    FlyUtility:Set(value)
end)

Options.FlySpeed:OnChanged(function(value)
    FlyUtility.FlySpeed = value
end)

Toggles.AntiDrown:OnChanged(function(value)
    Drown.Name = if value then "_Drown" else "drown"
end)

Toggles.WalkOnWater:OnChanged(function(value)
    for _, v in pairs(workspace.zones.fishing:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = value
        end
    end
end)

Toggles.Fullbright:OnChanged(function(value)
    if value then
        Services.Lighting.Ambient = Color3.new(1, 1, 1)
    else
        Services.Lighting.Ambient = Color3.new()
    end
end)

Library:GiveSignal(Services.RunService.RenderStepped:Connect(function()
    if Functions.ReturnRod() then
        if Toggles.AutoReel.Value then
            if not Functions.ReturnShake() then
                Functions.ReturnRod().events.cast:FireServer(Options.PerfectReelChance.Value)
            end
        end

        if Toggles.AutoShake.Value then
            task.wait()
            if Functions.ReturnShake() then
                if Toggles.NoButtonMove.Value then
                    Functions.ReturnShake().Position = UDim2.new(0.5, 0, 1, 0)
                end
                -- auto shake had me clueless, i made one but it was janky asf, thanks to some guy for the following method
                local pos: Vector2 = Functions.ReturnShake().AbsolutePosition
                local size: Vector2 = Functions.ReturnShake().AbsoluteSize
                Services.VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, true, Player, 0)
                Services.VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, false, Player, 0)
            end
        end

        if Toggles.AutoFish.Value and Functions.ReturnRod() and Functions.ReturnRod().values.bite.Value then
            Events.reelfinished:FireServer(100, false)
        end
    end

    if Humanoid then
        Humanoid.WalkSpeed = if Toggles.AnchorPlayer.Value then 0 else Options.Walkspeed.Value
        Humanoid.JumpPower = Options.JumpPower.Value
    end

    Character.Torso.CanCollide = not Toggles.NoclipToggle.Value
    HRP.CanCollide = not Toggles.NoclipToggle.Value
    Character.Head.CanCollide = not Toggles.NoclipToggle.Value
end))

Library:GiveSignal(Player.Idled:Connect(function()
    if Toggles.AntiAfk.Value then
        Services.VirtualUser:ClickButton2(Vector2.zero, workspace.CurrentCamera.CFrame)
    end
end))

Library:GiveSignal(Services.Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
    if Toggles.Fullbright.Value then
        Services.Lighting.Ambient = Color3.new(1, 1, 1)
    end
end))

Library:OnUnload(function()
    print("silly v2: Unloading Fisch script...")
    Humanoid.WalkSpeed = 16
    Humanoid.JumpPower = 50
    Drown.Name = "drown"
    FlyUtility:Stop()
    for _, v in pairs(Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = true
            v.Anchored = false
        end
    end
    for _, v in pairs(workspace.zones.fishing:GetChildren()) do
        v.CanCollide = true
    end
    Services.Lighting.Ambient = Color3.new(0, 0, 0)
    print("silly v2: Unloaded Fisch script!")
    getgenv().Loading = false
    getgenv().Loaded = false
end)
local MenuGroup = Tabs.UISettings:AddLeftGroupbox("Menu")

MenuGroup:AddButton("Unload", function() task.spawn(Library.Unload) end)
MenuGroup:AddToggle("showKeybinds", {
    Text = "Show Keybinds",
    Default = false,
    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end
})
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu Keybind" })
MenuGroup:AddToggle("CustomCursor", {
    Text = "Show Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end
})
local credits = Tabs.UISettings:AddRightGroupbox("Credits")

credits:AddLabel("mspaint - inspiration")
credits:AddLabel("a random script - auto shake \n(most of it)")
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("silly v2")
SaveManager:SetFolder("silly v2/Fisch")

SaveManager:BuildConfigSection(Tabs.UISettings)


ThemeManager:ApplyToTab(Tabs.UISettings)

SaveManager:LoadAutoloadConfig()

getgenv().Loaded = true
getgenv().Loading = false
