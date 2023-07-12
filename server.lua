-- Server-Side (server.lua)

-- Function to check if a player is in a vehicle with fuel
local function hasFuel(player)
    local vehicle = GetVehiclePedIsIn(player, false)
    return vehicle ~= 0 and GetVehicleFuelLevel(vehicle) > 0.0
end

-- Function to steal fuel from a player's vehicle
local function stealFuel(source, target)
    local sourcePlayer = tonumber(source)
    local targetPlayer = tonumber(target)

    -- Make sure both players are online and in a vehicle with fuel
    if sourcePlayer and targetPlayer and sourcePlayer ~= targetPlayer and hasFuel(sourcePlayer) and hasFuel(targetPlayer) then
        local sourceVehicle = GetVehiclePedIsIn(sourcePlayer, false)
        local targetVehicle = GetVehiclePedIsIn(targetPlayer, false)

        -- Calculate the amount of fuel to steal (10% of the target vehicle's fuel level)
        local targetFuelLevel = GetVehicleFuelLevel(targetVehicle)
        local fuelToSteal = targetFuelLevel * 0.1

        -- Reduce fuel from the target vehicle
        SetVehicleFuelLevel(targetVehicle, targetFuelLevel - fuelToSteal)

        -- Increase fuel in the source player's vehicle
        local sourceFuelLevel = GetVehicleFuelLevel(sourceVehicle)
        SetVehicleFuelLevel(sourceVehicle, sourceFuelLevel + fuelToSteal)

        -- Notify the players about the successful fuel theft
        TriggerClientEvent('chatMessage', sourcePlayer, '^2Success:', {255, 255, 255}, 'You successfully stole fuel from the target player\'s vehicle!')
        TriggerClientEvent('chatMessage', targetPlayer, '^1Warning:', {255, 255, 255}, 'Someone stole fuel from your vehicle!')
    else
        -- Notify the source player that the fuel theft failed
        TriggerClientEvent('chatMessage', sourcePlayer, '^3Warning:', {255, 255, 255}, 'Failed to steal fuel. Make sure both players are online and in a vehicle with fuel!')
    end
end

-- Event handler for when a player attempts to steal fuel
RegisterServerEvent('stealFuel')
AddEventHandler('stealFuel', stealFuel)
