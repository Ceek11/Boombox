
if GetResourceState('es_extended') == 'started' or GetResourceState('es_extended') == 'starting' then
    Framework = 'ESX'
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') == 'started' or GetResourceState('qb-core') == 'starting' then
    Framework = 'qb'
    QBCore = exports['qb-core']:GetCoreObject()
end

local xSound = exports.xsound
if Framework == "ESX" then 
    ESX.RegisterUsableItem("boombox", function(source)
        local _src = source 
        local xPlayer = ESX.GetPlayerFromId(_src)
        TriggerClientEvent("useBoombox", -1)
        xPlayer.removeInventoryItem("boombox", 1)
    end)
elseif Framework == "qb" then 
    QBCore.Functions.CreateUseableItem("boombox", function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.GetItemByName(item.name) ~= nil then
            TriggerClientEvent("useBoombox", -1)
            Player.Functions.RemoveItem('boombox', 1)        
        end
    end)
end

RegisterNetEvent("boombox:playMusic")
AddEventHandler("boombox:playMusic", function(YoutubeURL, coords)
    local defaultVolume = Boombox.DefaultVolume
    local _src = source
    local ped = GetPlayerPed(_src)
    local posPlayer = GetEntityCoords(ped)
    local dist = #(posPlayer - coords)
    if dist < Boombox.Distance then
        xSound:PlayUrlPos(-1, "Boombox", YoutubeURL, Boombox.DefaultVolume, coords)
        xSound:Distance(-1, "Boombox", Boombox.radius)
        Boombox.isPlaying = true
    end
end)


RegisterNetEvent('boombox:changeVolume', function(volume, coords)
    local src = source
    local ped = GetPlayerPed(src)
    local posPlayer = GetEntityCoords(ped)
    local dist = #(coords - posPlayer)
    if dist < Boombox.Distance then
        if not tonumber(volume) then return end
        if Boombox.isPlaying then 
            xSound:setVolume(-1, "Boombox", volume)
        end
    end
end)

RegisterNetEvent('boombox:pauseMusic', function(coords)
    local src = source
    local ped = GetPlayerPed(src)
    local PlayerPos = GetEntityCoords(ped)
    local dist = #(coords - PlayerPos)
    if dist < Boombox.Distance then
        if Boombox.isPlaying then
            Boombox.isPlaying = false
            xSound:Pause(-1, "Boombox")
        end
    end
end)

RegisterNetEvent('boombox:resumeMusic', function(coords)
    local src = source
    local ped = GetPlayerPed(src)
    local PlayerPos = GetEntityCoords(ped)
    local dist = #(coords - PlayerPos)
    if dist < Boombox.Distance then
        if not Boombox.isPlaying then
            Boombox.isPlaying = true
            xSound:Resume(-1, "Boombox")
        end
    end
end)

RegisterNetEvent('boombox:stopMusic', function(coords)
    local src = source
    local ped = GetPlayerPed(src)
    local PlayerPos = GetEntityCoords(ped)
    local dist = #(coords - PlayerPos)
    if dist < Boombox.Distance then
        if Boombox.isPlaying then
            Boombox.isPlaying = false
            xSound:Destroy(-1, "Boombox")
        end
    end
end)


RegisterNetEvent("deleteBoombox")
AddEventHandler("deleteBoombox", function(coords)
    print(json.encode(coords))
    local _src = source 
    local xPlayer
    if Framework == "ESX" then 
        xPlayer = ESX.GetPlayerFromId(_src)
    elseif Framework == "qb" then  
        xPlayer = QBCore.Functions.GetPlayer(_src)
    end
    if not xPlayer then return end 
    local ped = GetPlayerPed(_src)
    local PlayerPos = GetEntityCoords(ped)
    local dist = #(coords - PlayerPos)

    if dist <= Boombox.Distance then 
        if Framework == "ESX" then
            xPlayer.addInventoryItem("boombox", 1)
        elseif Framework == "qb" then  
            xPlayer.Functions.AddItem('boombox', 1)
        end
        if Boombox.isPlaying then
            Boombox.isPlaying = false
            xSound:Destroy(-1, "Boombox")
        end
    end
end)



RegisterNetEvent("fCore:Boombox:Playlist")
AddEventHandler("fCore:Boombox:Playlist", function(nameMusic, UrlMusic)
    local _src = source
    if Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(_src)
        local query = "INSERT INTO playlist_boombox (identifier, nom, url) VALUES (@identifier, @nom, @url)"
        local param = {
            ["@identifier"] = xPlayer.identifier,
            ["@nom"] = nameMusic,
            ["@url"] = UrlMusic
        }
        MySQL.Async.execute(query, param)
    elseif Framework == "qb" then
        local xPlayer = QBCore.Functions.GetPlayer(_src)
        local query = "INSERT INTO playlist_boombox (citizenid, nom, url) VALUES (@citizenid, @nom, @url)"
        local param = {
            ["@citizenid"] = xPlayer.PlayerData.citizenid,
            ["@nom"] = nameMusic,
            ["@url"] = UrlMusic
        }
        MySQL.Async.execute(query, param)
    end
end)


RegisterNetEvent("fCore:Boombox:DeleteSong")
AddEventHandler("fCore:Boombox:DeleteSong", function(id)
    local query = "DELETE FROM playlist_boombox WHERE id = @id"
    local param = {["@id"] = id}
    MySQL.Async.execute(query, param)
end)

if Framework == "ESX" then 
    ESX.RegisterServerCallback("fCore:Boombox:GetPlaylist", function(source, cb)
        local _src = source 
        local xPlayer = ESX.GetPlayerFromId(_src)
        local query = "SELECT * FROM playlist_boombox WHERE identifier = @identifier"
        local param = {["@identifier"] = xPlayer.identifier}
        MySQL.Async.fetchAll(query, param, function(result)
            local infoPlaylist = {}
            for i = 1, #result do
                table.insert(infoPlaylist, {
                    nom = result[i].nom, 
                    url = result[i].url,
                    id = result[i].id
                })
            end
            cb(infoPlaylist)
        end)
    end)
elseif Framework == "qb" then 
    QBCore.Functions.CreateCallback('fCore:Boombox:GetPlaylist', function(source, cb)
        local _src = source 
        local xPlayer = QBCore.Functions.GetPlayer(_src)
        local query = "SELECT * FROM playlist_boombox WHERE citizenid = @citizenid"
        local param = {["@citizenid"] = xPlayer.PlayerData.citizenid}
        MySQL.Async.fetchAll(query, param, function(result)
            local infoPlaylist = {}
            for i = 1, #result do
                table.insert(infoPlaylist, {
                    nom = result[i].nom, 
                    url = result[i].url,
                    id = result[i].id
                })
            end
            cb(infoPlaylist)
        end)
    end)
end