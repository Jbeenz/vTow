--[[
        
        vTow
        A simple vehicle tow script for FiveM servers.
        Including trailers support.
        
        Copyright © Vespura 2018
        https://www.vespura.com
        
        Example video:
        https://streamable.com/wpk3s
		
		Modified by Jbeenz to suit multi-vehicle trailer.
        
]]

function ShowNotification(text1, text2, text3)
    SetNotificationTextEntry("THREESTRINGS")
    AddTextComponentSubstringPlayerName(text1)
    AddTextComponentSubstringPlayerName(text2)
    AddTextComponentSubstringPlayerName(text3)
    DrawNotification(true, true)
end

local currentSelection = nil
local towtruck = nil
local target1 = nil
local target2 = nil
local target3 = nil
local helpstate = 1
local towSetupMode = false
local towing1 = false
local towing2 = false
local towing3 = false

RegisterCommand("towset", function(source, args)
        ShowNotification("Go to your ~r~towtruck ~s~and when you see the", "~y~yellow ~s~marker, press ~r~~h~HOME~h~", "~s~to select the vehicle.")
        towSetupMode = true
        towtruck = nil
        helpstate = 1
end)

RegisterCommand("tow1", function(source, args)
    ClearAllHelpMessages()
    ClearHelp(true)
    ClearDrawOrigin()
	ShowNotification("script started.")
    Citizen.Wait(2000)
    local targetPos = GetEntityCoords(target1, true)
    local attachPos = GetOffsetFromEntityGivenWorldCoords(towtruck, targetPos.x, targetPos.y, targetPos.z)
    AttachEntityToEntity(target1, towtruck, -1, attachPos.x, attachPos.y, attachPos.z, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    towSetupMode = false
    helpstate = 0
    towing1 = true
end)

RegisterCommand("tow2", function(source, args)
    ClearAllHelpMessages()
    ClearHelp(true)
    ClearDrawOrigin()
	ShowNotification("script started.")
    Citizen.Wait(2000)
    local targetPos = GetEntityCoords(target2, true)
    local attachPos = GetOffsetFromEntityGivenWorldCoords(towtruck, targetPos.x, targetPos.y, targetPos.z)
    AttachEntityToEntity(target2, towtruck, -1, attachPos.x, attachPos.y, attachPos.z, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    towSetupMode = false
    helpstate = 0
    towing2 = true
end)

RegisterCommand("tow3", function(source, args)
    ClearAllHelpMessages()
    ClearHelp(true)
    ClearDrawOrigin()
	ShowNotification("script started.")
    Citizen.Wait(2000)
    local targetPos = GetEntityCoords(target3, true)
    local attachPos = GetOffsetFromEntityGivenWorldCoords(towtruck, targetPos.x, targetPos.y, targetPos.z)
    AttachEntityToEntity(target3, towtruck, -1, attachPos.x, attachPos.y, attachPos.z, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    towSetupMode = false
    helpstate = 0
    towing3 = true
end)

RegisterCommand("untow1", function(source, args)
    ClearAllHelpMessages()
    ClearHelp(true)
    ClearDrawOrigin()
    DetachEntity(target1, true, true)
    local coords = GetOffsetFromEntityInWorldCoords(towtruck, 0.0, -10.0, 0.0)
    SetEntityCoords(target1, coords, false, false, false, false)
    SetVehicleOnGroundProperly(target1)
    target1 = nil
	towing1 = false
end)

RegisterCommand("untow2", function(source, args)
    ClearAllHelpMessages()
    ClearHelp(true)
    ClearDrawOrigin()
    DetachEntity(target2, true, true)
    local coords = GetOffsetFromEntityInWorldCoords(towtruck, 0.0, -10.0, 0.0)
    SetEntityCoords(target2, coords, false, false, false, false)
    SetVehicleOnGroundProperly(target2)
    target2 = nil
	towing2 = false
end)

RegisterCommand("untow3", function(source, args)
    ClearAllHelpMessages()
    ClearHelp(true)
    ClearDrawOrigin()
    DetachEntity(target3, true, true)
    local coords = GetOffsetFromEntityInWorldCoords(towtruck, 0.0, -10.0, 0.0)
    SetEntityCoords(target3, coords, false, false, false, false)
    SetVehicleOnGroundProperly(target3)
    target3 = nil
	towing3 = false
end)


Citizen.CreateThread(function()
    while true do
        if towSetupMode then
            local veh = nil
            if helpstate == 3 then
                helpstate = 0
            end
            if helpstate ~= 0 then
                local pos = GetEntityCoords(PlayerPedId(), true)
                local targetPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, -1.0)
                local rayCast = StartShapeTestCapsule(pos.x, pos.y, pos.z, targetPos.x, targetPos.y, targetPos.z, 2, 10, PlayerPedId(), 7)
                local _,hit,_,_,veh = GetShapeTestResult(rayCast)
                if hit and DoesEntityExist(veh) and IsEntityAVehicle(veh) then
                    currentSelection = veh
                    if (IsControlJustPressed(0, 213)) then
                        if helpstate == 1 then
                            ShowNotification("Go to your ~o~target vehicle~s~ and when you see the", "~y~yellow ~s~marker, press ~r~~h~HOME~h~", "~s~to confirm the vehicle to tow.")
                            towtruck = veh
                            helpstate = 2
                        elseif helpstate == 2 and veh ~= towtruck and not towing1 then
                            ShowNotification("Vehicle has been confirmed.", "~r~/tow1, /tow2 or /tow3 ~s~to start towing, or press", "~r~~h~HOME~h~~s~ to cancel.")
                            target1 = veh
                            helpstate = 3
                        elseif helpstate == 2 and veh ~= towtruck and not towing2 then
                            ShowNotification("Vehicle has been confirmed.", "~r~/tow1, /tow2 or /tow3 ~s~to start towing, or press", "~r~~h~HOME~h~~s~ to cancel.")
                            target2 = veh
                            helpstate = 3
						elseif helpstate == 2 and veh ~= towtruck and not towing3 then
                            ShowNotification("Vehicle has been confirmed.", "~r~/tow1, /tow2 or /tow3 ~s~to start towing, or press", "~r~~h~HOME~h~~s~ to cancel.")
                            target3 = veh
                            helpstate = 3
                        end
                    end
                else
                    currentSelection = nil
                end
            elseif helpstate == 0 and IsControlJustPressed(0, 213) and towtruck ~= nil and towing1 ~= nil then
                target1 = nil
                helpstate = 1
            elseif helpstate == 0 and IsControlJustPressed(0, 213) and towtruck ~= nil and towing2 ~= nil then
                target2 = nil
                helpstate = 1
			elseif helpstate == 0 and IsControlJustPressed(0, 213) and towtruck ~= nil and towing3 ~= nil then
                target3 = nil
                helpstate = 1
            end
            
            DisableControlAction(0, 44)
        else
		    towSetupMode = false
            currentSelection = nil
        end
        Citizen.Wait(0)
        
    end
end)

local markerType = 0
local scale = 0.3
local alpha = 255
local bounce = true
local faceCam = false
local iUnk = 0
local rotate = false
local textureDict = nil
local textureName = nil
local drawOnents = false

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/towset', 'Start/stop the towing setup or attach/detach a towed vehicle.')
    while true do
        Citizen.Wait(0)
        if towSetupMode then
            if (currentSelection ~= nil and currentSelection ~= towtruck) then
                local pos = GetEntityCoords(currentSelection, true)
                local red = 255
                local green = 255
                local blue = 0
                DrawMarker(markerType, pos.x, pos.y, pos.z + 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, scale, scale - 0.1, red, green, blue, alpha, bounce, faceCam, iUnk, rotate, textureDict, textureName, drawOnents)
            end
            if (towtruck ~= nil) then
                local pos = GetEntityCoords(towtruck, true)
                local red = 0
                local green = 50
                local blue = 0
                DrawMarker(markerType, pos.x, pos.y, pos.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, scale, scale - 0.1, red, green, blue, alpha, bounce, faceCam, iUnk, rotate, textureDict, textureName, drawOnents)
            end
            if (target1 ~= nil) then
                local pos = GetEntityCoords(target1, true)
                local red = 255
                local green = 0
                local blue = 50
                DrawMarker(markerType, pos.x, pos.y, pos.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, scale, scale - 0.1, red, green, blue, alpha, bounce, faceCam, iUnk, rotate, textureDict, textureName, drawOnents)
            end
            if (target2 ~= nil) then
                local pos = GetEntityCoords(target2, true)
                local red = 255
                local green = 0
                local blue = 50
                DrawMarker(markerType, pos.x, pos.y, pos.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, scale, scale - 0.1, red, green, blue, alpha, bounce, faceCam, iUnk, rotate, textureDict, textureName, drawOnents)
            end
			if (target3 ~= nil) then
                local pos = GetEntityCoords(target3, true)
                local red = 255
                local green = 0
                local blue = 50
                DrawMarker(markerType, pos.x, pos.y, pos.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, scale, scale - 0.1, red, green, blue, alpha, bounce, faceCam, iUnk, rotate, textureDict, textureName, drawOnents)
            end
        end
    end
end)
