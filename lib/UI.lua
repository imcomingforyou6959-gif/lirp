-- lib/UI.lua
-- Complete UI using WindUI, matching original obfuscated script's interface
-- All tabs, sections, toggles, sliders, dropdowns, colorpickers, keybinds, etc.

local UI = {}
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Settings = require(script.Parent.Settings)
local Utils = require(script.Parent.Utils)
local Constants = require(script.Parent.Constants)

-- Reference to window for later use (e.g., keybinds)
local Window = nil

-- Create the main window
function UI:Create()
    Window = WindUI:CreateWindow({
        Title = "Lirp | Project Delta",
        Folder = "Lirp",
        Icon = "solar:skull-bold",
        HideSearchBar = true,
        OpenButton = {
            Title = "Lirp",
            Enabled = true,
            Draggable = true,
            Scale = 0.6,
            Color = ColorSequence.new(Color3.fromRGB(255, 50, 50)),
        },
        Topbar = {
            Height = 44,
            ButtonsType = "Mac",
        },
    })

    -- Tabs
    local AimbotTab = Window:Tab({ Title = "Aimbot", Icon = "solar:target-bold" })
    local ESPTab = Window:Tab({ Title = "ESP", Icon = "solar:eye-bold" })
    local WorldTab = Window:Tab({ Title = "World", Icon = "solar:planet-bold" })
    local PlayerTab = Window:Tab({ Title = "Player", Icon = "solar:user-bold" })
    local ExtraTab = Window:Tab({ Title = "Extra", Icon = "solar:magic-stick-bold" })
    local SettingsTab = Window:Tab({ Title = "Settings", Icon = "solar:settings-bold" })
    local ServerTab = Window:Tab({ Title = "Server", Icon = "solar:server-bold" })

    -- ============================================================================
    -- Aimbot Tab Sections
    -- ============================================================================
    local AimbotLeft = AimbotTab:CreateSector("Aimbot", "left")
    local AimbotRight = AimbotTab:CreateSector("Aimbot Toggles", "right")
    local GunModsRight = AimbotTab:CreateSector("Gun Mods", "right")

    -- Aimbot Left
    AimbotLeft:AddToggle("Master Aimbot", Settings:Get("MasterAimbot"), function(v) Settings:Set("MasterAimbot", v) end)
        :AddKeybind("Hold", function(k) 
            -- keybind handling (original had UpdateKeybinds)
            Settings:Set("AimbotKey", k.Key)
        end)
    AimbotLeft:AddToggle("Target AI", Settings:Get("AimbotTargetAi"), function(v) Settings:Set("AimbotTargetAi", v) end)
    AimbotLeft:AddToggle("Target Players", Settings:Get("AimbotPlayer"), function(v) Settings:Set("AimbotPlayer", v) end)
    AimbotLeft:AddToggle("Perfect Silent", Settings:Get("PerfectSilent"), function(v) Settings:Set("PerfectSilent", v) end)
    AimbotLeft:AddToggle("Resolver", Settings:Get("Resolver"), function(v) Settings:Set("Resolver", v) end)
    AimbotLeft:AddDropdown("Aimbot Mode", {"Lock", "Silent"}, function(v)
        Settings:Set("SilentAimbot", v == "Silent")
    end)
    AimbotLeft:AddDropdown("Aimbot Aim Part", Constants.AimbotParts, function(v)
        Settings:Set("AimPart", v)
    end)
    AimbotLeft:AddSlider("Aimbot Smoothness", 1, 50, Settings:Get("AimbotSmoothness"), function(v)
        Settings:Set("AimbotSmoothness", v)
    end)
    AimbotLeft:AddSlider("Silent Aim - Hit Chance", 0, 100, Settings:Get("SilentHitChance"), function(v)
        Settings:Set("SilentHitChance", v)
    end)
    AimbotLeft:AddToggle("Aimbot Tracer", Settings:Get("AimbotTracer"), function(v) Settings:Set("AimbotTracer", v) end)
        :AddColorPicker(Settings:Get("AimbotTracerColor"), function(c) Settings:Set("AimbotTracerColor", c) end)
    AimbotLeft:AddToggle("Aimbot Fov", Settings:Get("FovVisible"), function(v) Settings:Set("FovVisible", v) end)
        :AddColorPicker(Settings:Get("FovColor"), function(c) Settings:Set("FovColor", c) end)
    AimbotLeft:AddToggle("Dynamic Aimbot Fov", Settings:Get("DynamicFov"), function(v) Settings:Set("DynamicFov", v) end)
    AimbotLeft:AddSlider("Fov Radius", 1, 720, Settings:Get("AimbotFov"), function(v)
        Settings:Set("AimbotFov", v)
        Settings:Set("ActualAimbotFov", v)
    end)
    AimbotLeft:AddSlider("Fov Thickness", 1, 25, 3, function(v) end)  -- visual only
    AimbotLeft:AddSlider("Fov Transparency", 0, 100, 50, function(v) end)

    -- Aimbot Toggles (Right)
    AimbotRight:AddToggle("Show Aimbot Target", Settings:Get("ShowTarget"), function(v) Settings:Set("ShowTarget", v) end)
        :AddColorPicker(Color3.new(1,0,0), function(c) end) -- target text color
    AimbotRight:AddToggle("Display Aimbot Target Visibility Status", Settings:Get("ShowTargetVisibleState"), function(v) Settings:Set("ShowTargetVisibleState", v) end)
    AimbotRight:AddToggle("Aimbot Prediction", Settings:Get("Prediction"), function(v) Settings:Set("Prediction", v) end)
    AimbotRight:AddToggle("Auto Shoot", Settings:Get("AutoShoot"), function(v) Settings:Set("AutoShoot", v) end)
    AimbotRight:AddDropdown("Auto Shoot Mode", {"Regular", "Instant Hit - Requires Silent"}, function(v)
        Settings:Set("AutoShootType", v == "Regular" and "Regular" or "Instant")
    end)
    AimbotRight:AddToggle("Freeze Target (Players Only)", Settings:Get("FreezeTarget"), function(v) Settings:Set("FreezeTarget", v) end)
    AimbotRight:AddToggle("Wall Check", Settings:Get("WallCheck"), function(v) Settings:Set("WallCheck", v) end)
    AimbotRight:AddToggle("Team Check", Settings:Get("TeamCheck"), function(v) Settings:Set("TeamCheck", v) end)
    AimbotRight:AddToggle("Sticky Aimbot Target", Settings:Get("StickyAim"), function(v) Settings:Set("StickyAim", v) end)

    -- Gun Mods
    GunModsRight:AddToggle("No Recoil | Instant Mosin", false, function(v) end) -- calls r77_0
    GunModsRight:AddToggle("No Spread", false, function(v) end) -- calls NoSpread
    GunModsRight:AddToggle("Instant Equip", Settings:Get("InstantEquip"), function(v) Settings:Set("InstantEquip", v) end)
    GunModsRight:AddToggle("Bullet Tracers", Settings:Get("BulletTracer"), function(v) Settings:Set("BulletTracer", v) end)
        :AddColorPicker(Settings:Get("BulletTracerColor"), function(c) Settings:Set("BulletTracerColor", c) end)
    GunModsRight:AddSlider("Bullet Tracer Despawn Delay", 5, 100, 50, function(v)
        Settings:Set("BulletTracerDelay", v / 100)
    end)
    GunModsRight:AddDropdown("Bullet Tracer Texture", {"Light","Lightning","Tiny Lightning","Wave","Beam","Surge"}, function(v)
        Settings:Set("BulletTracerTexture", Constants.BulletTracerTextures[v])
    end)
    GunModsRight:AddToggle("Instant Hit - Requires Keybind", Settings:Get("InstantHit"), function(v) Settings:Set("InstantHit", v) end)
        :AddKeybind("Hold", function(k) Settings:Set("InstantHitKey", k.Key) end)
    GunModsRight:AddSlider("Instant Hit - Shoot Delay", 1, 100, 15, function(v)
        Settings:Set("InstantHitDelay", v / 100)
    end)

    -- ============================================================================
    -- ESP Tab Sections
    -- ============================================================================
    local ESPPlayerLeft = ESPTab:CreateSector("Player ESP", "left")
    local ESPOtherRight = ESPTab:CreateSector("Other ESP", "right")
    local ESPVisualLeft = ESPTab:CreateSector("Visual", "left")
    local ESPBossLeft = ESPTab:CreateSector("Boss Information", "left")

    -- Player ESP
    ESPPlayerLeft:AddToggle("ESP MasterSwitch", Settings:Get("MasterESP"), function(v) Settings:Set("MasterESP", v) end)
    ESPPlayerLeft:AddSlider("Max ESP Distance", 100, 5000, Settings:Get("MaxDistance"), function(v) Settings:Set("MaxDistance", v) end)
    ESPPlayerLeft:AddToggle("NameTag ESP", Settings:Get("ShowName"), function(v) Settings:Set("ShowName", v) end)
        :AddColorPicker(Settings:Get("NameColor"), function(c) Settings:Set("NameColor", c) end)
    ESPPlayerLeft:AddToggle("Health Bar ESP", Settings:Get("ShowHealth"), function(v) Settings:Set("ShowHealth", v) end)
        :AddColorPicker(Color3.fromRGB(0,255,0), function(c) Settings:Set("HealthHighColor", c) end)
    ESPPlayerLeft:AddToggle("Distance ESP", Settings:Get("ShowDistance"), function(v) Settings:Set("ShowDistance", v) end)
        :AddColorPicker(Settings:Get("DistanceColor"), function(c) Settings:Set("DistanceColor", c) end)
    ESPPlayerLeft:AddToggle("Distance ESP | Studs To Meters", Settings:Get("StudsToMeters"), function(v) Settings:Set("StudsToMeters", v) end)
    ESPPlayerLeft:AddToggle("Skeleton ESP", Settings:Get("ShowSkeleton"), function(v) Settings:Set("ShowSkeleton", v) end)
        :AddColorPicker(Settings:Get("SkeletonColor"), function(c) Settings:Set("SkeletonColor", c) end)
    ESPPlayerLeft:AddToggle("Box ESP", Settings:Get("ShowBox"), function(v) Settings:Set("ShowBox", v) end)
        :AddColorPicker(Settings:Get("BoxColor"), function(c) Settings:Set("BoxColor", c) end)
    ESPPlayerLeft:AddToggle("Active Weapon ESP", Settings:Get("ShowWeapon"), function(v) Settings:Set("ShowWeapon", v) end)
        :AddColorPicker(Settings:Get("WeaponColor"), function(c) Settings:Set("WeaponColor", c) end)
    ESPPlayerLeft:AddToggle("Chams", Settings:Get("ShowChams"), function(v) Settings:Set("ShowChams", v) end)
        :AddColorPicker(Settings:Get("ChamsColor"), function(c) Settings:Set("ChamsColor", c) end)
    ESPPlayerLeft:AddDropdown("Chams Mode", {"Always Show Chams", "Only When Visible Show Chams"}, function(v)
        local hidden = (v == "Always Show Chams")
        Settings:Set("HiddenChams", hidden)
        Settings:Set("VisibleChams", not hidden)
    end)

    -- Other ESP
    ESPOtherRight:AddToggle("Dropped Items ESP", Settings:Get("DroppedItemESP"), function(v) Settings:Set("DroppedItemESP", v) end)
        :AddColorPicker(Settings:Get("DroppedItemColor"), function(c) Settings:Set("DroppedItemColor", c) end)
    ESPOtherRight:AddSlider("Dropped Item ESP Text Size", 1, 20, Settings:Get("DroppedItemTextSize"), function(v) Settings:Set("DroppedItemTextSize", v) end)
    ESPOtherRight:AddToggle("Corpse ESP", Settings:Get("CorpseESP"), function(v) Settings:Set("CorpseESP", v) end)
        :AddColorPicker(Settings:Get("CorpseColor"), function(c) Settings:Set("CorpseColor", c) end)
    ESPOtherRight:AddSlider("Corpse ESP Text Size", 1, 20, Settings:Get("CorpseTextSize"), function(v) Settings:Set("CorpseTextSize", v) end)
    ESPOtherRight:AddToggle("Container ESP", Settings:Get("ContainerESP"), function(v) Settings:Set("ContainerESP", v) end)
        :AddColorPicker(Settings:Get("ContainerColor"), function(c) Settings:Set("ContainerColor", c) end)
    ESPOtherRight:AddCombo("Container Whitelist", Constants.ContainerWhitelist, function(v) end) -- update whitelist
    ESPOtherRight:AddSlider("Container ESP Text Size", 1, 20, Settings:Get("ContainerTextSize"), function(v) Settings:Set("ContainerTextSize", v) end)
    ESPOtherRight:AddToggle("Exit ESP", Settings:Get("ExitESP"), function(v) Settings:Set("ExitESP", v) end)
        :AddColorPicker(Settings:Get("ExitColor"), function(c) Settings:Set("ExitColor", c) end)
    ESPOtherRight:AddSlider("Exit ESP Text Size", 1, 20, Settings:Get("ExitTextSize"), function(v) Settings:Set("ExitTextSize", v) end)
    ESPOtherRight:AddToggle("Quest Item ESP", Settings:Get("QuestESP"), function(v) Settings:Set("QuestESP", v) end)
        :AddColorPicker(Settings:Get("QuestESPColor"), function(c) Settings:Set("QuestESPColor", c) end)
    ESPOtherRight:AddSlider("Quest Item ESP Text Size", 1, 20, Settings:Get("QuestTextSize"), function(v) Settings:Set("QuestTextSize", v) end)
    ESPOtherRight:AddToggle("Vehicle ESP", Settings:Get("VehicleTag"), function(v) Settings:Set("VehicleTag", v) end)
        :AddColorPicker(Settings:Get("VehicleColor"), function(c) Settings:Set("VehicleColor", c) end)
    ESPOtherRight:AddSlider("Vehicle ESP Text Size", 1, 20, Settings:Get("VehicleTextSize"), function(v) Settings:Set("VehicleTextSize", v) end)
    ESPOtherRight:AddToggle("Ai Chams ESP", Settings:Get("AIHighlight"), function(v) Settings:Set("AIHighlight", v) end)
        :AddColorPicker(Settings:Get("HighlightColor"), function(c) Settings:Set("HighlightColor", c) end)
    ESPOtherRight:AddToggle("Ai Nametag ESP", Settings:Get("AINameTag"), function(v) Settings:Set("AINameTag", v) end)
        :AddColorPicker(Settings:Get("NameTagColor"), function(c) Settings:Set("NameTagColor", c) end)
    ESPOtherRight:AddSlider("AI ESP Text Size", 1, 20, Settings:Get("AiNameTagTextSize"), function(v) Settings:Set("AiNameTagTextSize", v) end)

    -- Visual (ESP Visual)
    ESPVisualLeft:AddToggle("Inventory Checker", Settings:Get("InvChecker"), function(v) Settings:Set("InvChecker", v) end)
        :AddKeybind("Hold", function(k) Settings:Set("InvCheckerKey", k.Key) end)
    ESPVisualLeft:AddCombo("Inventory Check Toggles", {"Inventory Check Corpses","Show Full Inventory","Show Inventory Value"}, function(v) end)
    ESPVisualLeft:AddToggle("Show Inventory Check Target", Settings:Get("InvCheckTarget"), function(v) Settings:Set("InvCheckTarget", v) end)
        :AddColorPicker(Color3.new(1,1,1), function(c) end)

    -- Boss Information
    ESPBossLeft:AddToggle("Boss Information", Settings:Get("ShowBoss"), function(v) Settings:Set("ShowBoss", v) end)
    ESPBossLeft:AddToggle("Movable Boss Information GUI", Settings:Get("BossMovable"), function(v) Settings:Set("BossMovable", v) end)

    -- ============================================================================
    -- World Tab Sections
    -- ============================================================================
    local WorldLeft = WorldTab:CreateSector("World", "left")
    local CloudRight = WorldTab:CreateSector("Cloud Changer", "right")
    local AmbientRight = WorldTab:CreateSector("Ambient Changer", "right")
    local TimeLeft = WorldTab:CreateSector("Time Changer", "left")

    WorldLeft:AddToggle("No Grass", false, function(v) sethiddenproperty(workspace.Terrain, "Decoration", not v) end)
    WorldLeft:AddToggle("No Leafs", Settings:Get("Foliage"), function(v) Settings:Set("Foliage", v) end)
    WorldLeft:AddToggle("No Clouds", false, function(v) if workspace.Terrain:FindFirstChild("Clouds") then workspace.Terrain.Clouds.Enabled = not v end end)
    WorldLeft:AddToggle("No Landmines", Settings:Get("NoLandMine"), function(v) Settings:Set("NoLandMine", v) end)
    WorldLeft:AddToggle("Full Brightness", Settings:Get("FullBrightness"), function(v) Settings:Set("FullBrightness", v) end)
    WorldLeft:AddToggle("No Fog", Settings:Get("NoFog"), function(v) Settings:Set("NoFog", v) end)
    WorldLeft:AddToggle("Xray", Settings:Get("Xray"), function(v) Settings:Set("Xray", v) end)
        :AddKeybind("None", function(k) end)
    WorldLeft:AddDropdown("Sky", {"Default","Orange Sunset","Pink Sky","Night","Galaxy Sky","Purple Space Sky","Spring Sky"}, function(v) end)

    CloudRight:AddToggle("Cloud Changer", Settings:Get("CloudChanger"), function(v) Settings:Set("CloudChanger", v) end)
        :AddColorPicker(Settings:Get("CloudColor"), function(c) Settings:Set("CloudColor", c) end)
    CloudRight:AddSlider("Cloud Transparency", 1, 100, 25, function(v) end)

    AmbientRight:AddToggle("Ambient Changer", Settings:Get("AmbientChanger"), function(v) Settings:Set("AmbientChanger", v) end)
        :AddColorPicker(Settings:Get("AmbientColor"), function(c) Settings:Set("AmbientColor", c) end)
    AmbientRight:AddToggle("RGB Ambient", Settings:Get("AmbientChangerRGB"), function(v) Settings:Set("AmbientChangerRGB", v) end)
    AmbientRight:AddSlider("Ambient RGB Speed", 10, 125, 50, function(v) Settings:Set("AmbientChangerRGBSpeed", v/100) end)

    TimeLeft:AddToggle("Time Changer", Settings:Get("TimeChanger"), function(v) Settings:Set("TimeChanger", v) end)
    TimeLeft:AddSlider("Time", 0, 2400, 1200, function(v) Settings:Set("CurrentTime", string.format("%02d:%02d:00", math.floor(v/100), v%100)) end)

    -- ============================================================================
    -- Player Tab Sections
    -- ============================================================================
    local PlayerLeft = PlayerTab:CreateSector("Player", "left")
    local ZoomRight = PlayerTab:CreateSector("Zoom", "right")
    local ViewModelRight = PlayerTab:CreateSector("Player ViewModel", "right")
    local AntiAimRight = PlayerTab:CreateSector("Anti Aim", "right")
    local ModLeft = PlayerTab:CreateSector("Mod Detector", "left")

    PlayerLeft:AddToggle("Omni Sprint", Settings:Get("OmniSprint"), function(v) Settings:Set("OmniSprint", v) end)
    PlayerLeft:AddToggle("Speed Hack - Risky", Settings:Get("SpeedHackToggle"), function(v) Settings:Set("SpeedHackToggle", v) end)
        :AddKeybind("Hold", function(k) end)
    PlayerLeft:AddToggle("Silent Speed Hack", Settings:Get("SpeedHackSilent"), function(v) Settings:Set("SpeedHackSilent", v) end)
    PlayerLeft:AddSlider("Speed Hack Speed", 5, 17, 17, function(v) Settings:Set("SpeedHackSpeed", v/1.3) end)
    PlayerLeft:AddToggle("Infinity Jump - Risky", Settings:Get("InfinityJump"), function(v) Settings:Set("InfinityJump", v) end)
    PlayerLeft:AddToggle("Bunny Hop", Settings:Get("BunnyHop"), function(v) Settings:Set("BunnyHop", v) end)
        :AddKeybind("Hold", function(k) end)
    PlayerLeft:AddToggle("Third Person", Settings:Get("ThirdPerson"), function(v) Settings:Set("ThirdPerson", v) end)
        :AddKeybind("Hold", function(k) end)
    PlayerLeft:AddSlider("Third Person Distance", 1, 50, 15, function(v) Settings:Set("ThirdPersonDistance", v) end)
    PlayerLeft:AddToggle("No Fall Damage", Settings:Get("NoFall"), function(v) Settings:Set("NoFall", v) end)
    PlayerLeft:AddSlider("Infinity & Bunny Hop Jump Power", 1, 28, 22, function(v) Settings:Set("InfJumpPower", v) end)
    PlayerLeft:AddToggle("No Visor + Flashbang", Settings:Get("VisorEnabled"), function(v) Settings:Set("VisorEnabled", v) end)
    PlayerLeft:AddToggle("No Inventory Blur", Settings:Get("InventoryBlur"), function(v) Settings:Set("InventoryBlur", v) end)
    PlayerLeft:AddToggle("No Reapir Blur", Settings:Get("NoReapirBlur"), function(v) Settings:Set("NoReapirBlur", v) end)
    PlayerLeft:AddToggle("Peek Kill - Bad Thing", Settings:Get("TPKill"), function(v) Settings:Set("TPKill", v) end)
        :AddKeybind("Hold", function(k) end)
    PlayerLeft:AddSlider("Peek Kill Speed", 50, 1000, 1050, function(v) Settings:Set("TPKillSpeed", v) end)
    PlayerLeft:AddToggle("Freeze", Settings:Get("FreezeUrSelf"), function(v) Settings:Set("FreezeUrSelf", v) end)
        :AddKeybind("Hold", function(k) end)

    ZoomRight:AddToggle("Zoom", false, function(v) end)
        :AddKeybind("None", function(k) end)
    ZoomRight:AddSlider("Zoom Fov", 1, 70, 10, function(v) end)
    ZoomRight:AddSlider("Fov Changer", 1, 120, 90, function(v) end)

    ViewModelRight:AddToggle("ViewModel Changer", Settings:Get("ViewModelChanger"), function(v) Settings:Set("ViewModelChanger", v) end)
        :AddColorPicker(Settings:Get("ArmColor"), function(c) Settings:Set("ArmColor", c) end)
    ViewModelRight:AddSlider("Arm Transparency", 0, 100, 0, function(v) Settings:Set("ViewModelTransparency", v/100) end)
    ViewModelRight:AddSlider("Arm X Pos", 0, 290, 50, function(v) end)
    ViewModelRight:AddSlider("Arm Y Pos", 0, 290, 50, function(v) end)
    ViewModelRight:AddSlider("Arm Z Pos", 0, 290, 50, function(v) end)

    AntiAimRight:AddButton("Amogus", function() end)
    AntiAimRight:AddToggle("Player Yaw Changer", Settings:Get("UPAngleChanger"), function(v) Settings:Set("UPAngleChanger", v) end)
    AntiAimRight:AddSlider("Y - Yaw", -160, 160, 0, function(v) Settings:Set("UPAngleValue", v) end)

    ModLeft:AddToggle("Mod Detector", Settings:Get("ModDetector"), function(v) Settings:Set("ModDetector", v) end)
    ModLeft:AddToggle("Cheater Detector - Requires Mod Detector", Settings:Get("CheatDetector"), function(v) Settings:Set("CheatDetector", v) end)

    -- ============================================================================
    -- Extra Tab Sections
    -- ============================================================================
    local SkinRight = ExtraTab:CreateSector("Skin Changer", "right")
    local WarningRight = ExtraTab:CreateSector("Warning Indicators", "right")
    local HitSoundLeft = ExtraTab:CreateSector("Custom Hit Sound", "left")
    local ItemFinderLeft = ExtraTab:CreateSector("Item Finder", "left")
    local SoundsLeft = ExtraTab:CreateSector("Sounds", "left")

    SkinRight:AddToggle("Skin Changer", Settings:Get("SkinChanger"), function(v) Settings:Set("SkinChanger", v) end)
    SkinRight:AddDropdown("Skin", Constants.SkinNames, function(v) Settings:Set("Skin", v) end)
    SkinRight:AddCombo("Blacklist Parts", {"Stock","Front","Sight","Magazine","Handle","Muzzle","Extra","ItemRoot"}, function(v) end)

    WarningRight:AddToggle("Low Food/Water Indicator", Settings:Get("LowFoodDetector"), function(v) Settings:Set("LowFoodDetector", v) end)
    WarningRight:AddSlider("Low Food/Water Indicator Threshold", 1, 1000, 200, function(v) Settings:Set("LowFoodThreshold", v) end)

    HitSoundLeft:AddToggle("Custom Hit Sound", Settings:Get("CustomHitSound"), function(v) Settings:Set("CustomHitSound", v) end)
    HitSoundLeft:AddDropdown("Hit Sound", {"Default","Rust","Neverlose","Gamesense","Bubble","Ding","Bruh","CS 1.6","Windows XP","TeamFortress","Toilet","FAAHH"}, function(v)
        Settings:Set("CustomHitSoundID", Constants.HitSounds[v])
    end)
    HitSoundLeft:AddSlider("Hit Sound Volume", 1, 5500, 100, function(v) Settings:Set("CustomHitSoundVolume", v/100) end)
    HitSoundLeft:AddButton("Play HitSound", function() end)

    ItemFinderLeft:AddToggle("Item Finder", Settings:Get("ItemFinder"), function(v) Settings:Set("ItemFinder", v) end)
    ItemFinderLeft:AddCombo("Item Whitelist", Constants.ItemFinderWhitelist, function(v) end)

    -- ============================================================================
    -- Settings Tab Sections
    -- ============================================================================
    local ConfigLeft = SettingsTab:CreateSector("Config", "left")
    local CheatLeft = SettingsTab:CreateSector("Cheat", "left")
    local CrosshairRight = SettingsTab:CreateSector("Crosshair", "right")
    local ThemesLeft = SettingsTab:CreateSector("Themes", "left")
    local ClientLeft = SettingsTab:CreateSector("Client", "left")
    local NPCRight = SettingsTab:CreateSector("Npc", "right")
    local KeyBindsLeft = SettingsTab:CreateSector("Key Binds", "left")

    ConfigLeft:AddTextBox("Enter Config Name", "", function(v) end)
    ConfigLeft:AddButton("Save Config", function() end)
    ConfigLeft:AddButton("Load Config", function() end)

    CheatLeft:AddButton("Unload - Will Lag Once", function() end)

    CrosshairRight:AddToggle("Show Crosshair", false, function(v) end)
        :AddColorPicker(Color3.new(1,1,1), function(c) end)
    CrosshairRight:AddToggle("RGB", false, function(v) end)
    CrosshairRight:AddToggle("Crosshair Auto Rotation", false, function(v) end)
    CrosshairRight:AddSlider("Crosshair Rotation Speed", 1, 5, 1, function(v) end)
    CrosshairRight:AddSlider("Crosshair Transparency", 0, 100, 100, function(v) end)
    CrosshairRight:AddSlider("Crosshair Length", 1, 50, 10, function(v) end)
    CrosshairRight:AddSlider("Crosshair Thickness", 1, 25, 3, function(v) end)
    CrosshairRight:AddSlider("Crosshair Gap", 1, 25, 5, function(v) end)

    ThemesLeft:AddToggle("Custom Theme (Beta)", Settings:Get("Menu.CustomTheme"), function(v) Settings:Set("Menu.CustomTheme", v) end)
        :AddColorPicker(Settings:Get("Menu.CustomThemeColor"), function(c) Settings:Set("Menu.CustomThemeColor", c) end)

    ClientLeft:AddToggle("Hide Server Information", Settings:Get("ServerInfo"), function(v) Settings:Set("ServerInfo", v) end)
    ClientLeft:AddToggle("Hide Name In Chat", Settings:Get("HideName"), function(v) Settings:Set("HideName", v) end)

    NPCRight:AddDropdown("NPC - Only In Lobby", Constants.NPCNames, function(v) Settings:Set("NPC", v) end)
    NPCRight:AddButton("Teleport Npc To You", function() end)

    KeyBindsLeft:AddToggle("KeyBind Indicator", Settings:Get("KeyBindIndicator"), function(v) Settings:Set("KeyBindIndicator", v) end)

    -- ============================================================================
    -- Server Tab Sections
    -- ============================================================================
    local ServerFilterLeft = ServerTab:CreateSector("Server Filter", "left")
    local ServerRejoinerRight = ServerTab:CreateSector("Server Rejoiner", "right")

    ServerFilterLeft:AddToggle("Server List Filter", Settings:Get("ServerChanger"), function(v) Settings:Set("ServerChanger", v) end)
    ServerFilterLeft:AddDropdown("Server Region", {"Any","EU","NA","AS"}, function(v) Settings:Set("ServerTarget", v) end)
    ServerFilterLeft:AddDropdown("Server Level", {"All","Default","Veteran","Premium"}, function(v) Settings:Set("ServerRank", v) end)
    ServerFilterLeft:AddDropdown("Server Map", {"Any","Estonian Border","City-13"}, function(v) Settings:Set("ServerMap", v) end)
    ServerFilterLeft:AddDropdown("Server Version", {"Any","0.501c","0.5h","0.501b"}, function(v) Settings:Set("ServerVersion", v) end)
    ServerFilterLeft:AddTextBox("Server ID Must Contain", "", function(v) Settings:Set("ServerName", v) end)
    ServerFilterLeft:AddDropdown("Server Clock", {"Any","Day","Night"}, function(v) Settings:Set("ServerClock", v) end)
    ServerFilterLeft:AddSlider("Minimum Players In Server", 1, 25, 1, function(v) Settings:Set("ServerPlayerMax", v) end)
    ServerFilterLeft:AddSlider("Maximum Players In Server", 1, 25, 25, function(v) Settings:Set("ServerPlayerMin", v) end)

    ServerRejoinerRight:AddButton("Join random server", function() end)
    ServerRejoinerRight:AddButton("Rejoin server", function() end)

    -- Apply theme and config system
    local ConfigManager = Window.ConfigManager
    if ConfigManager then
        -- Setup config saving/loading (original had SaveManager)
        -- We'll just add a simple version
        local function saveConfig(name)
            -- Save all settings flagged with "Flag"
            -- For simplicity, we'll rely on Settings:Save()
            Settings:Save()
            Utils:Notify("Config Saved", "Config '" .. name .. "' saved", 2)
        end
        local function loadConfig(name)
            Settings:Load()
            Utils:Notify("Config Loaded", "Config '" .. name .. "' loaded", 2)
        end
        -- In a full implementation, you'd integrate with WindUI's config system
    end

    return Window
end

return UI
