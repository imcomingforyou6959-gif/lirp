-- lib/Settings.lua
-- Complete settings manager extracted from the original obfuscated script
-- Handles default values, config saving/loading, and settings API

local Settings = {}

-- ============================================================================
-- DEFAULT SETTINGS (mirroring original r39_0 table)
-- ============================================================================
Settings.Defaults = {
    -- General
    Loaded = true,
    Menu = {
        CustomTheme = false,
        CustomThemeColor = Color3.fromRGB(255, 255, 255),
        CustomThemeBorderColor = Color3.fromRGB(15, 15, 15),
    },
    
    -- Aimbot
    MasterAimbot = false,
    AimbotEnabled = false,
    AimPart = "Head",
    RealAimPart = "Head",
    AimbotTracer = false,
    AimbotRandomizeHitPart = false,
    AimbotNearestPartToCursor = false,
    AimbotTracerColor = Color3.fromRGB(129, 210, 255),
    AimbotTargetAi = false,
    AimbotPlayer = false,
    AimbotSmoothness = 1,
    SilentHitChance = 100,
    Prediction = false,
    StickyAim = false,
    SilentAimbot = false,
    PerfectSilent = false,
    Resolver = false,
    ResolverCache = {},
    InstantHit = false,
    InstantHitActive = false,
    InstantHitDelay = 0.00000005,
    AutoShoot = false,
    AutoShootType = "Regular",
    WallCheck = false,
    TeamCheck = false,
    ShowTarget = false,
    ShowTargetVisibleState = false,
    FreezeTarget = false,
    Freeze = {},
    FreezeUrSelf = false,
    FreezeUrSelfActive = false,
    
    -- Visuals
    NoFog = false,
    FOVCircle = nil,  -- Drawing object, created at runtime
    AimbotFov = 100,
    ActualAimbotFov = 100,
    DynamicFov = false,
    FovVisible = false,
    FovColor = Color3.fromRGB(129, 210, 255),
    LastTarget = nil,
    
    -- Movement
    OmniSprint = false,
    InvChecker = false,
    FullInventoryChecker = false,
    InventoryCheckCorpse = false,
    InvCheckerActive = false,
    InvCheckTarget = false,
    InvCheckValue = false,
    KeyBindIndicator = false,
    
    -- ESP (various types)
    DroppedItemESP = false,
    DroppedItemColor = Color3.fromRGB(255, 100, 0),
    DroppedItemTextSize = 11,
    ExitESP = false,
    ExitColor = Color3.fromRGB(255, 0, 255),
    ExitTextSize = 11,
    QuestESP = false,
    QuestESPColor = Color3.fromRGB(45, 150, 99),
    QuestTextSize = 11,
    CorpseESP = false,
    CorpseColor = Color3.fromRGB(0, 255, 0),
    CorpseTextSize = 11,
    ContainerESP = false,
    ContainerColor = Color3.fromRGB(0, 255, 255),
    ContainerTextSize = 11,
    AINameTag = false,
    NameTagColor = Color3.fromRGB(255, 255, 0),
    AiNameTagTextSize = 11,
    VehicleTag = false,
    VehicleColor = Color3.fromRGB(95, 25, 21),
    VehicleTextSize = 11,
    AIHighlight = false,
    HighlightColor = Color3.fromRGB(255, 0, 0),
    
    -- World
    CloudChanger = false,
    CloudColor = Color3.fromRGB(50, 15, 95),
    ViewModelChanger = false,
    ViewModelTransparency = 0,
    ArmColor = Color3.fromRGB(79, 155, 121),
    ShowBoss = false,
    BossMovable = false,
    Foliage = false,
    
    -- Player
    InfinityJump = false,
    BunnyHop = false,
    BunnyHopActive = false,
    Chams = false,
    VisibleChams = false,
    HiddenChams = true,
    ChamColor = Color3.fromRGB(255, 255, 255),
    ModDetector = false,
    CheatDetector = false,
    NoFall = false,
    InstantEquip = false,
    SpeedHackToggle = false,
    SpeedHackSilent = false,
    SpeedHackActive = false,
    SpeedHackSpeed = 17,
    HideName = false,
    LastSpeed = 0,
    LastModCheck = 0,
    NoLandMine = false,
    Xray = false,
    XrayActive = false,
    lastJumpTime = 0,
    
    -- Crosshair (drawing objects)
    HorizontalLine1 = nil,
    HorizontalLine2 = nil,
    VerticalLine1 = nil,
    VerticalLine2 = nil,
    
    -- Premium/Account
    PremiumLevel = 0,
    LastLocation = {},
    
    -- Visual effects
    InventoryBlur = false,
    NoReapirBlur = false,
    VisorEnabled = false,
    TPKill = false,
    TPKillActive = false,
    TPKillSpeed = 350,
    BlackListTree = {},
    AmbientChanger = false,
    AmbientChangerRGB = false,
    AmbientChangerRGBSpeed = 0.5,
    AmbientColor = Color3.fromRGB(129, 5, 255),
    TimeChanger = false,
    CurrentTime = "12:00:00",
    FullBrightness = false,
    InfJumpPower = 22,
    GasMaskSound = false,
    ServerInfo = false,
    ItemFinder = false,
    LastItemFinderCheck = 0,
    ItemFinderList = {},
    CustomHitSound = false,
    CustomHitSoundVolume = 1,
    CustomHitSoundID = "Default",
    BulletTracer = false,
    BulletTracerTexture = "rbxassetid://90961491521758",
    BulletTracerColor = Color3.fromRGB(255, 255, 255),
    BulletTracerDelay = 0.5,
    ThirdPerson = false,
    ThirdPersonActive = false,
    ThirdPersonDistance = 10,
    
    -- Lobby/Server
    Lobby = false,
    ServerChanger = false,
    ServerTarget = "Any",
    ServerRank = "All",
    ServerMap = "Any",
    ServerClock = "Any",
    ServerVersion = "Any",
    ServerName = "",
    ServerPlayerMax = 1,
    ServerPlayerMin = 25,
    ServerListCopy = {},
    NPC = "Mihkel",
    UPAngleChanger = false,
    UPAngleValue = 0,
    LowFoodDetector = false,
    LowFoodThreshold = 200,
    AnimDown = false,
    AnimDownHolding = false,
    FlipMode = false,
    FlipModeEnabled = false,
    OriginalHipHeight = 0,
    FlipModeConnection = nil,
    
    -- Skin changer
    SkinChanger = false,
    Skin = "Anton",
    ItemRoot = true,
    Stock = true,
    Front = true,
    Sight = true,
    Magazine = true,
    Handle = true,
    Muzzle = true,
    Extra = true,
}

-- Current settings (will be merged with defaults)
Settings.Current = {}

-- ============================================================================
-- CONFIG FILE PATHS
-- ============================================================================
local ConfigFolder = "LirpConfig"
local ConfigFile = ConfigFolder .. "/settings.json"

-- Create config folder if it doesn't exist
pcall(function()
    if not isfolder(ConfigFolder) then
        makefolder(ConfigFolder)
    end
end)

-- ============================================================================
-- HELPER FUNCTIONS (for serializing/deserializing Color3, UDim2, etc.)
-- ============================================================================
local function sanitize(t, seen)
    seen = seen or {}
    if type(t) ~= "table" then
        if t == nil then
            return nil
        elseif typeof(t) == "Color3" then
            return {t.r, t.g, t.b}
        elseif typeof(t) == "UDim2" then
            return {t.X.Scale, t.X.Offset, t.Y.Scale, t.Y.Offset}
        elseif typeof(t) == "EnumItem" then
            return tostring(t)
        elseif type(t) == "function" or type(t) == "thread" or type(t) == "userdata" then
            return nil
        elseif type(t) == "number" or type(t) == "string" or type(t) == "boolean" then
            return t
        else
            return nil
        end
    end
    if seen[t] then
        return nil
    end
    seen[t] = true
    local new = {}
    for k, v in pairs(t) do
        local sk = sanitize(k, seen)
        local sv = sanitize(v, seen)
        if sk ~= nil and sv ~= nil and type(sk) ~= "function" then
            new[sk] = sv
        end
    end
    return new
end

local function deserialize(t)
    if type(t) ~= "table" then return t end
    -- Check if it's a Color3 (table with 3 numbers)
    if t[1] and t[2] and t[3] and #t == 3 and type(t[1]) == "number" then
        return Color3.new(t[1], t[2], t[3])
    end
    -- Check if it's a UDim2 (table with 4 numbers)
    if t[1] and t[2] and t[3] and t[4] and #t == 4 and type(t[1]) == "number" then
        return UDim2.new(t[1], t[2], t[3], t[4])
    end
    for k, v in pairs(t) do
        t[k] = deserialize(v)
    end
    return t
end

-- ============================================================================
-- SAVE / LOAD FUNCTIONS
-- ============================================================================
function Settings:Save()
    local success, err = pcall(function()
        local clean = sanitize(self.Current)
        if not clean then clean = {} end
        local data = game:GetService("HttpService"):JSONEncode(clean)
        writefile(ConfigFile, data)
    end)
    if not success then
        warn("Failed to save settings: " .. tostring(err))
    end
end

function Settings:Load()
    if not isfile(ConfigFile) then
        -- No config file, use defaults
        for k, v in pairs(self.Defaults) do
            self.Current[k] = v
        end
        self:Save()
        return
    end
    local success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(ConfigFile))
    end)
    if success and type(data) == "table" then
        data = deserialize(data)
        -- Merge loaded data into defaults (preserve new defaults)
        for k, v in pairs(self.Defaults) do
            if data[k] ~= nil then
                self.Current[k] = data[k]
            else
                self.Current[k] = v
            end
        end
    else
        -- Failed to load, use defaults
        for k, v in pairs(self.Defaults) do
            self.Current[k] = v
        end
    end
end

-- ============================================================================
-- GETTER / SETTER
-- ============================================================================
function Settings:Get(key)
    return self.Current[key]
end

function Settings:Set(key, value)
    self.Current[key] = value
    self:Save()
end

-- ============================================================================
-- INITIAL LOAD
-- ============================================================================
Settings:Load()

return Settings
