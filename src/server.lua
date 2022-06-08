local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())

local blockedAreas = {}

-- Police command
RegisterCommand(config.commands.blockCommand, function(source, args)
	local source = source
	local user_id = vRP.getUserId(source)
	
	if vRP.hasPermission(user_id, config.permissions.policePermission) then
		if blockedAreas[user_id] then
			vCLIENT.removeBlip(-1, user_id, blockedAreas[user_id].x, blockedAreas[user_id].y, blockedAreas[user_id].z)
			sendUnblockedWebhook(user_id, blockedAreas[user_id].x, blockedAreas[user_id].y, blockedAreas[user_id].z, 1)
			blockedAreas[user_id] = nil
			return
		end
		
		local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(source)))
		vCLIENT.addNewBlip(-1, user_id, x, y, z)

		blockedAreas[user_id] = {
			x = x, y = y, z = z
		}

		sendBlockedWebhook(x, y, z)

		TriggerClientEvent("Notify",source,"sucesso","Área atual definida como bloqueada.")
	end
end)

-- Admin command
RegisterCommand(config.commands.clearCommand, function(source, args)
	local source = source
	local user_id = vRP.getUserId(source)
	
	if vRP.hasPermission(user_id, config.permissions.adminPermission) then
		for blipName, blipData in pairs(blockedAreas) do
			vCLIENT.removeBlip(-1, blipName, blipData.x, blipData.y, blipData.z)
			sendUnblockedWebhook(blipName, blipData.x, blipData.y, blipData.z, 4)

			blockedAreas[blipName] = nil
		end
		TriggerClientEvent("Notify",source,"sucesso","Todos os blips de ação foram removidos.")
	end
end)

exports('removeArea', function(areaID)
	if not blockedAreas[areaID] then return end 

	vCLIENT.removeBlip(-1, areaID, blockedAreas[areaID].x, blockedAreas[areaID].y, blockedAreas[areaID].z)	
	sendUnblockedWebhook(areaID, blockedAreas[areaID].x, blockedAreas[areaID].y, blockedAreas[areaID].z, 2)

	blockedAreas[areaID] = nil
end)

AddEventHandler("vRP:playerLeave", function(user_id, source)
	if not blockedAreas[user_id] then return end 

	vCLIENT.removeBlip(-1, user_id, blockedAreas[user_id].x, blockedAreas[user_id].y, blockedAreas[user_id].z)	
	sendUnblockedWebhook(user_id, blockedAreas[user_id].x, blockedAreas[user_id].y, blockedAreas[user_id].z, 3)

	blockedAreas[user_id] = nil
end)

function src.requestCurrentBlips()
	return blockedAreas
end
