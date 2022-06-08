local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
vSERVER = Tunnel.getInterface(GetCurrentResourceName())

Citizen.CreateThread(function()
	Wait(10000)
	local blips = vSERVER.requestCurrentBlips()

	for k, v in pairs(blips) do
		createAreaBlip(k, v.x, v.y, v.z)
	end
end)

function src.addNewBlip(areaID, x, y, z)
	createAreaBlip(areaID, x, y, z)
end

function src.removeBlip(areaID, x, y, z)
	deleteAreaBlip(areaID, x, y, z)
end