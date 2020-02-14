local menu = false
ESX = nil

function getVehData(veh)
    if not DoesEntityExist(veh) then return nil end
    local lvehstats = {
        boost = GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce"),
        fuelmix = GetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia"),
        braking = GetVehicleHandlingFloat(veh ,"CHandlingData", "fBrakeBiasFront"),
        drivetrain = GetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront"),
        brakeforce = GetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeForce")
    }
    return lvehstats
end

function setVehData(veh,data)
    if not DoesEntityExist(veh) or not data then return nil end
    SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", data.boost*1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", data.fuelmix*1.0)
    SetVehicleEnginePowerMultiplier(veh, data.gearchange*1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", data.braking*1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront", data.drivetrain*1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeForce", data.brakeforce*1.0)

    TriggerServerEvent('tuning:SetData',data,ESX.Game.GetVehicleProperties(veh))
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function toggleMenu(b,send)
    menu = b
    SetNuiFocus(b,b)
    local vehData = getVehData(GetVehiclePedIsIn(GetPlayerPed(-1),false))
    if send then SendNUIMessage(({type = "togglemenu", state = b, data = vehData})) end
end

RegisterNUICallback("togglemenu",function(data,cb)
    toggleMenu(data.state,false)
end)

RegisterNUICallback("save",function(data,cb)
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
    if not IsPedInAnyVehicle(GetPlayerPed(-1)) or GetPedInVehicleSeat(veh, -1)~=GetPlayerPed(-1) then return end
    setVehData(veh,data)
    lastVeh = veh
    lastStats = stats
end)

RegisterNetEvent("tuning:useLaptop")
AddEventHandler("tuning:useLaptop", function()
    if not menu then
        exports['progressBars']:startUI(2500, "Connecting Tuner Chip")
        TriggerEvent('esx_inventoryhud:doClose')
        Citizen.Wait(2500)
        TriggerEvent('esx_inventoryhud:doClose')
        local ped = GetPlayerPed(-1)
        toggleMenu(true,true)
        while IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1)==ped do
            Citizen.Wait(100)
        end
        toggleMenu(false,true)
    else
        return
    end
end)

RegisterNetEvent("tuning:closeMenu")
AddEventHandler("tuning:closeMenu",function()
    toggleMenu(false,true)
end)

local lastVeh = false
local lastData = false
local gotOut = false
Citizen.CreateThread(function(...)
    while not ESX do Citizen.Wait(0); end
    while not ESX.IsPlayerLoaded() do Citizen.Wait(0); end
    while true do
        Citizen.Wait(30)
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
            if veh ~= lastVeh or gotOut then
                if gotOut then gotOut = false; end
                local responded = false
                ESX.TriggerServerCallback('tuning:CheckStats', function(doTune,stats)
                    if doTune then
                        setVehData(veh,stats)
                        lastStats = stats
                    else
                        if lastVeh and veh and lastVeh == veh and lastData then
                            setVehData(veh,lastData)
                        end
                    end
                    lastVeh = veh
                    responded = true
                end, ESX.Game.GetVehicleProperties(veh))
                while not responded do Citizen.Wait(0); end
            end
        else
            if not gotOut then
                gotOut = true
            end
        end
    end
end)

RegisterCommand("untune", function(source, args)
  TriggerServerEvent('tuning:UnSetData', ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1),false)))
end)