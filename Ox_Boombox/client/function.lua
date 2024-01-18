RegisterNetEvent("useBoombox")
AddEventHandler("useBoombox", function()
    useBoombox()
end)

local boxOnFloor = false
local coordsBoombox = nil
function useBoombox()
    boxOnFloor = true
    coordsBoombox = GetEntityCoords(PlayerPedId()) 
    local model = GetHashKey("prop_boombox_01")
    boomboxProp = CreateObject(model, coordsBoombox.x, coordsBoombox.y, coordsBoombox.z-1, true, false, true)
    FreezeEntityPosition(boomboxProp, true)
end

CreateThread(function()
    local options = {
        {
            name = 'removeBoombox',
            icon = 'fa-solid fa-road',
            label = 'Enlever la boombox',
            canInteract = function(entity, distance, coords)
                local entityModel = GetEntityModel(entity)
                return entityModel == GetHashKey("prop_boombox_01")
            end,
            onSelect = function(data)
                DeleteObject(boomboxProp)
                TriggerServerEvent("deleteBoombox", coordsBoombox)
            end
        },
        {
            name = 'openmenuboombox',
            icon = 'fa-solid fa-road',
            label = 'Ouvrir la boombox',
            canInteract = function(entity, distance, coords)
                local entityModel = GetEntityModel(entity)
                return entityModel == GetHashKey("prop_boombox_01")
            end,
            onSelect = function(data)
                lib.showContext('menu_boombox')
            end
        },
    }
    exports.ox_target:addGlobalObject(options)
end)


AddEventHandler('open_boombox_playlist', function()
    MenuPlaylist()
end)

AddEventHandler('selectSongPlaylist', function(args)
    SongPlaylist(args)
end)

function DrawName3D(x,y,z, text, colorR, colorG, colorB) 
    SetDrawOrigin(x, y, z, 0);
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(0.3, 0.3)
	SetTextColour(colorR, colorG, colorB, 240)
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
