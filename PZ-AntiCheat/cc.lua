RegisterNetEvent("AC:cleanareavehy")
RegisterNetEvent("AC:cleanareapedsy")
RegisterNetEvent("AC:cleanareaentityy")
RegisterNetEvent("AC:invalid")



function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry("FMMC_KEY_TIP1", TextEntry .. ":")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		AddTextEntry("FMMC_KEY_TIP1", "")
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		AddTextEntry("FMMC_KEY_TIP1", "")
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

local function getPlayerIds()
	local players = {}
	for i = 0, GetNumberOfPlayers() do
		if NetworkIsPlayerActive(i) then
			players[#players + 1] = i
		end
	end
	return players
end


function DrawText3D(x, y, z, text, r, g, b)
	SetDrawOrigin(x, y, z, 0)
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.0, 0.20)
	SetTextColour(r, g, b, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

function math.round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
	result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
	result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

	return result
end

local function notify(text, param)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(param, false)
end

local ACIcS = "AceG"
local ACIcZ = titolo
local sMX = "SelfMenu"
local sMXS = "MainMenu"
local TRPM = "TeleportMenu"
local advm = "AdvM"
local VMS = "VehicleMenu"
local OPMS = "OnlinePlayerMenu"
local poms = "PlayerOptionsMenu"
local crds = "Credits"
local MSTC = "MiscTriggers"
local espa = "ESPMenu"

local function DrawTxt(text, x, y)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.4)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function RequestModelSync(mod)
    local model = GetHashKey(mod)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
          Citizen.Wait(0)
    end
end

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function RequestControl(entity)
	local Waiting = 0
	NetworkRequestControlOfEntity(entity)
	while not NetworkHasControlOfEntity(entity) do
		Waiting = Waiting + 100
		Citizen.Wait(100)
		if Waiting > 5000 then
			notify("Hung for 5 seconds, killing to prevent issues...", true)
		end
	end
end

function getEntity(player)
	local result, entity = GetEntityPlayerIsFreeAimingAt(player, Citizen.ReturnResultAnyway())
	return entity
end

function GetInputMode()
	return Citizen.InvokeNative(0xA571D46727E2B718, 2) and "MouseAndKeyboard" or "GamePad"
end



function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end


local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end
	
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
	
		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next
	
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumeratePeds()
		return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
		return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function RotationToDirection(rotation)
	local retz = rotation.z * 0.0174532924
	local retx = rotation.x * 0.0174532924
	local absx = math.abs(math.cos(retx))

	return vector3(-math.sin(retz) * absx, math.cos(retz) * absx, math.sin(retx))
end

function OscillateEntity(entity, entityCoords, position, angleFreq, dampRatio)
	if entity ~= 0 and entity ~= nil then
		local direction = ((position - entityCoords) * (angleFreq * angleFreq)) - (2.0 * angleFreq * dampRatio * GetEntityVelocity(entity))
		ApplyForceToEntity(entity, 3, direction.x, direction.y, direction.z + 0.1, 0.0, 0.0, 0.0, false, false, true, true, false, true)
	end
end



AddEventHandler("AC:cleanareavehy", function()
		for vehicle in EnumerateVehicles() do
			  SetEntityAsMissionEntity(GetVehiclePedIsIn(vehicle, true), 1, 1)
			  DeleteEntity(GetVehiclePedIsIn(vehicle, true))
			  SetEntityAsMissionEntity(vehicle, 1, 1)
			  DeleteEntity(vehicle)
			end
end)

	AddEventHandler("AC:cleanareapedsy", function()
		PedStatus = 0
		for ped in EnumeratePeds() do
			PedStatus = PedStatus + 1
			if not (IsPedAPlayer(ped))then
				RemoveAllPedWeapons(ped, true)
				DeleteEntity(ped)
			end
		end
	end)

	AddEventHandler("AC:cleanareaentityy", function()
		objst = 0
		for obj in EnumerateObjects() do
			objst = objst + 1
				DeleteEntity(obj)
		end
	end)

	AddEventHandler("AC:openmenuy", function()
		LR.OpenMenu(ACIcS)
	end)


	if Config.AntiCheat then
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(1000)	
		SetPedInfiniteAmmoClip(PlayerPedId(), false)
		SetPlayerInvincible(PlayerId(), false)
		SetEntityInvincible(PlayerPedId(), false)
		SetEntityCanBeDamaged(PlayerPedId(), true)
		ResetEntityAlpha(PlayerPedId())
			end
		end)
	end

	if Config.AntiGodmode then
		Citizen.CreateThread(function()
			while true do
				 Citizen.Wait(30000)
					local curPed = PlayerPedId()
					local curHealth = GetEntityHealth( curPed )
					SetEntityHealth( curPed, curHealth-2)
					local curWait = math.random(10,150)
					Citizen.Wait(curWait)
					if not IsPlayerDead(PlayerId()) then
						if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then
							TriggerServerEvent("AC:ViolationDetected", "⚡️ Godmode",true)
						elseif GetEntityHealth(curPed) == curHealth-2 then
							SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
						end
					end
					if GetEntityHealth(PlayerPedId()) > 200 then
						TriggerServerEvent("AC:ViolationDetected", "⚡️ Godmode",true)
					end
					if GetPedArmour(PlayerPedId()) < 200 then
						Wait(50)
						if GetPedArmour(PlayerPedId()) == 200 then
							TriggerServerEvent("AC:ViolationDetected", "⚡️ Godmode",true)
						end
				end
			end
		end)
	end


BlacklistedCmdsxd = {"car","pk","haha","lol","panickey","killmenu","panik","ssssss","brutan","panic","desudo","jd","ham","hammafia","hamhaxia","redstonia, xariesmenu, MainMenu, SelfMenu"}


if Config.AntiBlips then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			local blipcount = 0
			local playerlist = GetActivePlayers()
				for i = 1, #playerlist do
					if i ~= PlayerId() then
					if DoesBlipExist(GetBlipFromEntity(GetPlayerPed(i))) then
						blipcount = blipcount + 1
					end
				end
					if blipcount > 0 then
						TriggerServerEvent("AC:ViolationDetected","⚡️ PlayerBlips Violation",true)
					end
				end
		end
	end)
end

if Config.AntiBlacklistedWeapons then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			for _,theWeapon in ipairs(Config.BlacklistedWeapons) do
				Wait(1)
				if HasPedGotWeapon(PlayerPedId(),GetHashKey(theWeapon),false) == 1 then
						RemoveWeaponFromPed(PlayerPedId(),GetHashKey(theWeapon))
						TriggerServerEvent("AC:ViolationDetected","⚡️ BlacklistedWeapon: "..theWeapon,Config.AntiBlacklistedWeaponsKick)
				end
			end
		end
	end)
end
	
	local isInvincible = false
local isAdmin = false

Citizen.CreateThread(function()
    while true do
        isInvincible = GetPlayerInvincible(PlayerId())
        isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
        Citizen.Wait(500)
    end
end)

function DrawLabel(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

RegisterNetEvent("sendAcePermissionToClient")
AddEventHandler("sendAcePermissionToClient", function(state)
    isAdmin = state
end)

if Config.PlayerProtection then
	SetEntityProofs(GetPlayerPed(-1), false, true, true, false, false, false, false, false)		
end

if Config.AntiSpeedHack then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			local speed = GetEntitySpeed(PlayerPedId())
			if not IsPedInAnyVehicle(GetPlayerPed(-1), 0) then
			if speed > 80 then
				TriggerServerEvent("AC:ViolationDetected","⚡️ SpeedHack",true)
			end
		end
		end
	end)
end

