config = {
	-- Configuração relacionadas à comandos
	commands = {
		-- Bloquear a área em que o jogador está situado no momento
		blockCommand = "area",

		-- Limpar todas as áreas bloqueadas
		clearCommand = "clearareas"
	},

	-- Configuração relacionadas à permissões
	permissions = {
		-- Utilizar o comando "commands.blockCommand"
		policePermission = "policia.permissao",

		-- Utilizar o comando  "commands.clearCommand"
		adminPermission = "manager.permissao",
	},
}


local blipCache = {}
function createAreaBlip(areaID, x, y, z)
	if blipCache[areaID] and DoesBlipExist(blipCache[areaID]) then
		RemoveBlip(blipCache[areaID])
	end

	local roadName = "(sem nome especificado)"

	local street, crossStreet = GetStreetNameAtCoord(x, y, z)
	if street then
		roadName = "da rua ^1" .. GetStreetNameFromHashKey(street)
		if crossStreet then
			roadName = "do cruzamento de ^1" .. GetStreetNameFromHashKey(street) .. " ^0com ^1" .. GetStreetNameFromHashKey(crossStreet)
		end
	end

	TriggerEvent('chat:addMessage', {
		color = { 100, 100, 255 },
		multiline = true,
		args = {
			"CAUTION POLICE", 
			"Informamos que a área próxima " .. roadName .. " ^0encontra-se cercada pela polícia da cidade. Qualquer aproximação será considerada hostil e poderá ser recebida a disparos. Mantenham-se distantes até segunda ordem!" 
		}
	})

	blipCache[areaID] = AddBlipForRadius(x, y, z, 100.0)
	SetBlipAlpha(blipCache[areaID], 128)
	SetBlipColour(blipCache[areaID], 1)
	SetBlipHighDetail(blipCache[areaID], true)
end

function deleteAreaBlip(areaID, x, y, z)
	if not blipCache[areaID] then return end

	local roadName = "(sem nome especificado)"

	local street, crossStreet = GetStreetNameAtCoord(x, y, z)
	if street then
		roadName = "da rua ^1" .. GetStreetNameFromHashKey(street)
		if crossStreet then
			roadName = "do cruzamento de ^1" .. GetStreetNameFromHashKey(street) .. " ^0com ^1" .. GetStreetNameFromHashKey(crossStreet)
		end
	end

	TriggerEvent('chat:addMessage', {
		color = { 100, 100, 255 },
		multiline = true,
		args = {
			"CAUTION POLICE", 
			"A área próxima " .. roadName .. " ^0encontra-se segura novamente! Vocês já podem se aproximar sem qualquer risco." 
		}
	})

	if DoesBlipExist(blipCache[areaID]) then
		RemoveBlip(blipCache[areaID])
	end

	blipCache[areaID] = nil
end
