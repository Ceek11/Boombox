if GetResourceState('es_extended') == 'started' or GetResourceState('es_extended') == 'starting' then
    Framework = 'ESX'
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') == 'started' or GetResourceState('qb-core') == 'starting' then
    Framework = 'qb'
    QBCore = exports['qb-core']:GetCoreObject()
end


lib.registerContext({
    id = 'menu_boombox',
    title = 'Menu Boombox',
    options = {
        {
            title = 'Jouer une musique',
            description = 'Cliquez ici pour lancer une musique',
            arrow = true,
            menu = 'menu_startsong',
        },
        {
            title = 'Playlist',
            description = 'Cliquez ici pour aller dans la playlist',
            arrow = true,
            event = "open_boombox_playlist",
        }
    }
})

if Framework == "ESX" then
    function MenuPlaylist()
        ESX.TriggerServerCallback("fCore:Boombox:GetPlaylist", function(infoPlaylist) 
            local Options = {
                {
                    title = 'Ajouter un musique',
                    description = 'Cliquez ici pour ajouter une musique',
                    onSelect = function()
                        local input = lib.inputDialog("Ajouter un musique", 
                        {{type = 'input', label = "Entrer le URL"}, {type = 'input', label = "Entrer le nom de la musique"}})
                        if input then 
                            local YoutubeURL = input[1]
                            local LabelMusic = input[2]
                            TriggerServerEvent("fCore:Boombox:Playlist", LabelMusic, YoutubeURL)
                        end
                    end,
                }
            }
            if infoPlaylist then 
                for i = 1, #infoPlaylist do 
                    table.insert(Options, {
                        title = infoPlaylist[i].nom,
                        event = "selectSongPlaylist",
                        arrow = true,
                        args = {link = infoPlaylist[i].url, id = infoPlaylist[i].id, label = infoPlaylist[i].nom}
                    })
                end
            end
            lib.registerContext({
                id = 'menu_playlist',
                title = 'Menu Playlist',
                menu = "menu_boombox",
                options = Options
            })
            lib.showContext('menu_playlist')
        end)
    end
elseif Framework == "qb" then
    function MenuPlaylist()
        QBCore.Functions.TriggerCallback('fCore:Boombox:GetPlaylist', function(infoPlaylist)
            local Options = {
                {
                    title = 'Ajouter un musique',
                    description = 'Cliquez ici pour ajouter une musique',
                    onSelect = function()
                        local input = lib.inputDialog("Ajouter un musique", 
                        {{type = 'input', label = "Entrer le URL"}, {type = 'input', label = "Entrer le nom de la musique"}})
                        if input then 
                            local YoutubeURL = input[1]
                            local LabelMusic = input[2]
                            TriggerServerEvent("fCore:Boombox:Playlist", LabelMusic, YoutubeURL)
                        end
                    end,
                }
            }
            if infoPlaylist then 
                for i = 1, #infoPlaylist do 
                    table.insert(Options, {
                        title = infoPlaylist[i].nom,
                        event = "selectSongPlaylist",
                        arrow = true,
                        args = {link = infoPlaylist[i].url, id = infoPlaylist[i].id, label = infoPlaylist[i].nom}
                    })
                end
            end
            lib.registerContext({
                id = 'menu_playlist',
                title = 'Menu Playlist',
                menu = "menu_boombox",
                options = Options
            })
            lib.showContext('menu_playlist')
        end)
    end
end

function SongPlaylist(args)
    lib.registerContext({
            id = 'menu_song_playlist',
            title = args.label,
            menu = "menu_playlist",
            options = {
            {
                title = 'Lancer la musique',
                description = 'Cliquez ici pour lancer la musique',
                onSelect = function()
                    TriggerServerEvent("boombox:playMusic", args.link, GetEntityCoords(PlayerPedId()))
                end,
            },
            {
                title = 'Supprimer la musique',
                description = 'Cliquez ici pour lancer la musique',
                onSelect = function()
                    TriggerServerEvent("fCore:Boombox:DeleteSong", args.id)
                end,
            }
        },
    })
    lib.showContext('menu_song_playlist')
end


lib.registerContext({
    id = 'menu_startsong',
    title = 'Menu Song',
    menu = "menu_boombox",
    onBack = function()
        print('Went back!')
    end,
    options = {
        {
            title = 'Ajouter un lien YouTube',
            description = 'Cliquez ici pour ajouter un lien YouTube',
            onSelect = function()
                local input = lib.inputDialog("Ajouter un lien YouTube", {"Entrez le lien YouTube"})
                if input then 
                    local YoutubeURL = input[1]
                    TriggerServerEvent("boombox:playMusic", YoutubeURL, GetEntityCoords(PlayerPedId()))
                end
            end,
            metadata = {
                {label = 'Volume de la musique: ', value = Boombox.DefaultVolume},
            },
        },
        {
            title = 'Changer le volume',
            onSelect = function()
                local input = lib.inputDialog("Changer le volume", {{type = 'input', label = "Min: 0.01 - Max: 1"}})
                if input then 
                    local volume = input[1]
                    TriggerServerEvent('boombox:changeVolume', tonumber(volume), GetEntityCoords(PlayerPedId()))                
                end
            end,
            metadata = {
                {label = 'Volume de la musique: ', value = Boombox.DefaultVolume},
            },
        },
        {
            title = 'Mettre pause à la musique',
            onSelect = function()
                TriggerServerEvent("boombox:pauseMusic", GetEntityCoords(PlayerPedId()))
            end,
        },
        {
            title = 'Relance la musique',
            onSelect = function()
                TriggerServerEvent("boombox:resumeMusic", GetEntityCoords(PlayerPedId()))
            end,
        },
        {
            title = 'Stopper la musique',
            onSelect = function()
                TriggerServerEvent("boombox:stopMusic", GetEntityCoords(PlayerPedId()))
            end,
        },
    }
})

