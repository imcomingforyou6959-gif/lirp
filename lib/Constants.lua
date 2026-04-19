-- lib/Constants.lua
-- Complete constants extracted from the original obfuscated script
-- Includes the character mapping table, hostile/civilian patterns, hit sounds, container whitelist, etc.

local Constants = {}

-- ============================================================================
-- OBFUSCATED CHARACTER MAPPING TABLE (from original r1_0)
-- ============================================================================
Constants.CharMap = {
    a = "$512@",
    b = "*8#74",
    c = "#9$63",
    d = "/2$34",
    e = "%7!86",
    f = "@1$45",
    g = "!67#8",
    h = "&90!1",
    i = "~4$32",
    j = "+7#89",
    k = "|2@10",
    l = "^5$43",
    m = "=87#6",
    n = "(32!1)",
    o = "[6$54]",
    p = "]98@7[",
    q = "$1#23",
    r = "#4$56",
    s = "%7#89",
    t = "+2$34",
    u = "&5$67",
    v = "@8$90",
    w = "^32#1",
    x = "~65$4",
    y = "[9#87]",
    z = "$43@2",
    A = "!12#5",
    B = "$67#8",
    C = "#9$01",
    D = "%4#32",
    E = "~78$9",
    F = "&21@0",
    G = "^5$43",
    H = "@87#6",
    I = "!3$21",
    J = "+6#54",
    K = "=9$87",
    L = "[1$23]",
    M = "$4#56",
    N = "&7$89",
    O = "#2$34",
    P = "%5$67",
    Q = "~8$90",
    R = "$3#21",
    S = "^6$54",
    T = "#9$87",
    U = "&4$32",
    V = "+7$65",
    W = "[8$76]",
    X = "~1$23",
    Y = "[2#34]",
    Z = "!3$45",
    ["0"] = "+6$78",
    ["1"] = "/9$01",
    ["2"] = "^4#32",
    ["3"] = "|7$89",
    ["4"] = "#2@10",
    ["5"] = "~5$43",
    ["6"] = "-8$76",
    ["7"] = "=3#21",
    ["8"] = "%6$54",
    ["9"] = "*9$87",
    ["!"] = "$/1#25",
    ["@"] = "+$2#15",
    ["#"] = "^8$76",
    ["$"] = "*+4$32",
    ["%"] = "-5#43",
    ["^"] = "|=2$34",
    ["&"] = "~9$87",
    ["*"] = "#|6$78",
    ["("] = "><3$21",
    [")"] = "[9$87]",
}

-- ============================================================================
-- HOSTILE & CIVILIAN PATTERNS
-- ============================================================================
Constants.HostilePatterns = {
    "Hostile", "TaskForce", "Enemy", "Sniper", "Gunner", "Boss", "Combatant", "Raider", "Mercenary"
}

Constants.CivilianPatterns = {
    "Civilian", "Civillain", "Civ", "NPC", "Friendly", "Passive"
}

-- ============================================================================
-- HIT SOUNDS (ID mappings)
-- ============================================================================
Constants.HitSounds = {
    Default = "rbxassetid://4585351098",
    Rust = "rbxassetid://1255040462",
    Gamesense = "rbxassetid://4817809188",
    Neverlose = "rbxassetid://8726881116",
    Bubble = "rbxassetid://198598793",
    Ding = "rbxassetid://2868331684",
    Bruh = "rbxassetid://4275842574",
    ["Windows XP"] = "rbxassetid://130840811",
    Discord = "rbxassetid://6501486918",
    TeamFortress = "rbxassetid://296102734",
    ["CS 1.6"] = "rbxassetid://18362692980",
    Toilet = "rbxassetid://8430024127",
    FAAHH = "rbxassetid://72298953503422"
}

-- ============================================================================
-- BULLET TRACER TEXTURES
-- ============================================================================
Constants.BulletTracerTextures = {
    Light = "rbxassetid://90961491521758",
    Lightning = "rbxassetid://247707396",
    ["Tiny Lightning"] = "rbxassetid://7151778302",
    Wave = "rbxassetid://123453630521207",
    Beam = "rbxassetid://6376702661",
    Surge = "rbxassetid://12652034914",
}

-- ============================================================================
-- SKYBOX PRESETS
-- ============================================================================
Constants.SkyPresets = {
    Default = {
        Value = "rbxassetid://0",
    },
    ["Orange Sunset"] = {
        SkyboxBk = "rbxassetid://458016711",
        SkyboxDn = "rbxassetid://458016826",
        SkyboxFt = "rbxassetid://458016532",
        SkyboxLf = "rbxassetid://458016655",
        SkyboxRt = "rbxassetid://458016782",
        SkyboxUp = "rbxassetid://458016792",
    },
    ["Pink Sky"] = {
        SkyboxBk = "rbxassetid://271042516",
        SkyboxDn = "rbxassetid://271077243",
        SkyboxFt = "rbxassetid://271042556",
        SkyboxLf = "rbxassetid://271042310",
        SkyboxRt = "rbxassetid://271042467",
        SkyboxUp = "rbxassetid://271077958",
    },
    Night = {
        SkyboxBk = "rbxassetid://15470149279",
        SkyboxDn = "rbxassetid://15470151245",
        SkyboxFt = "rbxassetid://15470153860",
        SkyboxLf = "rbxassetid://15470155938",
        SkyboxRt = "rbxassetid://15470158022",
        SkyboxUp = "rbxassetid://15470160563",
    },
    ["Galaxy Sky"] = {
        SkyboxBk = "rbxassetid://159454299",
        SkyboxDn = "rbxassetid://159454296",
        SkyboxFt = "rbxassetid://159454293",
        SkyboxLf = "rbxassetid://159454286",
        SkyboxRt = "rbxassetid://159454300",
        SkyboxUp = "rbxassetid://159454288",
    },
    ["Purple Space Sky"] = {
        SkyboxBk = "rbxassetid://14543264135",
        SkyboxDn = "rbxassetid://14543358958",
        SkyboxFt = "rbxassetid://14543257810",
        SkyboxLf = "rbxassetid://14543275895",
        SkyboxRt = "rbxassetid://14543280890",
        SkyboxUp = "rbxassetid://14543371676",
    },
    ["Spring Sky"] = {
        SkyboxBk = "rbxassetid://12216109205",
        SkyboxDn = "rbxassetid://12216109875",
        SkyboxFt = "rbxassetid://12216109489",
        SkyboxLf = "rbxassetid://12216110170",
        SkyboxRt = "rbxassetid://12216110471",
        SkyboxUp = "rbxassetid://12216108877",
    },
}

-- ============================================================================
-- CONTAINER WHITELIST (for Container ESP)
-- ============================================================================
Constants.ContainerWhitelist = {
    "MilitaryCrate",
    "SmallMilitaryBox",
    "LargeMilitaryBox",
    "LargeABPOPABox",
    "Safe",
    "CashRegister",
    "GrenadeCrate",
    "HiddenCache",
    "KGBBag",
    "Toolbox",
    "SportBag",
    "SmallShippingCrate",
    "LargeShippingCrate",
    "FilingCabinet",
    "Fridge",
    "MedBag",
    "SatchelBag",
    "SupplyDropMilitary",
}

-- ============================================================================
-- SKIN NAMES (for Skin Changer)
-- ============================================================================
Constants.SkinNames = {
    "Anton", "Banana", "SpaceSuit", "Valentine", "Crusader", "Freedom",
    "Artic", "Nutcracker", "Watergun", "Serpant", "Galaxy", "Hunter",
    "Permafrost", "Thunder", "GiftWrap", "Shoreline", "Ancient", "AnodizedRed",
    "DeltaAnime", "PeaceWalker", "Anarchy", "Blackout", "Tan", "TigerStripe",
    "VOLK", "Woodland", "Pineapple", "Apollo", "Shark", "Devil", "Dialbo",
    "Melon", "WhiteDeath",
}

-- ============================================================================
-- ITEM FINDER WHITELIST
-- ============================================================================
Constants.ItemFinderWhitelist = {
    "TFZ98S", "R700", "M4", "AsVal", "PKM", "FlareGun", "SPSh44",
    "Gold", "GoldWatch", "RepairKit"
}

-- ============================================================================
-- NPC NAMES (for teleport feature)
-- ============================================================================
Constants.NPCNames = {
    "Mihkel", "Seryozha", "Tarmo", "Nurse", "Blaze", "Boss", "Designer", "Anna"
}

-- ============================================================================
-- SERVER REGIONS, MAPS, VERSIONS, CLOCKS, RANKS
-- ============================================================================
Constants.ServerRegions = {"EU", "NA", "AS"}
Constants.ServerRanks = {"Default", "Veteran", "Premium"}
Constants.ServerMaps = {"Estonian Border", "City-13"}
Constants.ServerVersions = {"0.501c", "0.5h", "0.501b"}
Constants.ServerClocks = {"Day", "Night"}

-- ============================================================================
-- AIMBOT PARTS (full list from dropdown)
-- ============================================================================
Constants.AimbotParts = {
    "Head", "FaceHitBox", "HeadTopHitBox", "UpperTorso", "LowerTorso",
    "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm",
    "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg",
    "RightLowerLeg", "RightFoot"
}

-- ============================================================================
-- CONTAINER PART NAMES (for hitbox expander)
-- ============================================================================
Constants.HitboxParts = {
    "Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso",
    "Left Arm", "Right Arm", "Left Leg", "Right Leg"
}

-- ============================================================================
-- DEFAULT CROSSHAIR SETTINGS
-- ============================================================================
Constants.DefaultCrosshair = {
    Size = 10,
    Gap = 5,
    Color = Color3.new(1, 1, 1),
    Thickness = 3,
    Visible = false,
    Transparency = 1,
    Rotation = 0,
    RotateSpeed = 1,
    RotateAuto = false,
    RGB = false,
}

-- ============================================================================
-- SKELETON CONNECTIONS (R6)
-- ============================================================================
Constants.SkeletonConnections = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"},
}

-- ============================================================================
-- R15 SKELETON CONNECTIONS (fallback)
-- ============================================================================
Constants.R15SkeletonConnections = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"UpperTorso", "RightUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LowerTorso", "RightUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"RightLowerLeg", "RightFoot"},
}

-- ============================================================================
-- BOSS NAMES & ZONES (for boss info)
-- ============================================================================
Constants.BossInfo = {
    Sawmill = { Name = "Anton", Attribute = nil },
    Factory = { Name = "Dozer", Attribute = nil },
    Whisper = { Name = "Whisper", Attribute = "DodgeStamina" },
    Death = { Name = "Death", Attribute = "Death" },
}

return Constants
