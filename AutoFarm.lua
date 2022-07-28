local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

if _G.Loaded then return end

pcall(function()
    getgenv().rconsoleprint = b
    getgenv().printconsole = a
    getgenv().rconsoleprint = dsadfsdf
    getgenv().setclipboard = a
    getgenv().hookfunction = gdfg
end) 

local FileName = "DizFarm"
local Time = os.time()
_G.Loaded = true

repeat
    task.wait(1)
until game:IsLoaded() or (os.time() - Time) >= 10

task.wait(5)

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local PlayerGui = Player:WaitForChild("PlayerGui")
local ClientToServer = ReplicatedStorage:WaitForChild("endpoints"):WaitForChild("client_to_server")
local UserInputService = game:GetService("UserInputService")
local Units = game:GetService("Workspace")["_UNITS"]
local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AverageFarmer/Silent/master/library.lua"))()
local url = "https://discord.com/api/webhooks/999000287664676927/W0O5Dbs4OEUkuUYlkjpdU8aYlonN3Qs1d2bXy2ULbTNRF9VrrFJK95rGYukTfgpmWY11"
local Lobby = "_lobbytemplategreen1"

local src = game.ReplicatedStorage:WaitForChild("src")
local data = src:WaitForChild("Data")
local Loader = require(src:WaitForChild("Loader"));
local EndpointsClient = Loader.load_client_service(script, "EndpointsClient");
local UnitsInfo = require(data.Units)
local Items = require(data:WaitForChild("ItemsForSale"))
local SavedSettings = (isfile(FileName..tostring(Player.UserId) .. ".lua") and readfile(FileName .. tostring(Player.UserId) .. ".lua")) or {}
local Settings = {
    Map = "namek",
    MapNumber = "1",
    Difficulty = "Normal",
    IsInf = false,
    Pause = true,
    SellAt = 23,
    
    Units = {},
    _Upgrades = {},
    SpawnCaps = {},
    AutoBuy = {"summon_ticket"},

    AntiAFK = false,

    AutoDelete = {
        Enabled = false, 
        Rarities = {"Rare"}, 
        KeepShiny = true,
        KeepTraits = true,
    },

    AutoSummon = {
        Enabled = false, 
        x10 = false,
        SummonFor = {

        }
    },
}


for i,v in pairs(HttpService:JSONDecode(SavedSettings)) do
    Settings[i] = v
end

Settings.AutoDelete.Enabled = false

syn.queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/JuiceWarfare/animeAdv/main/AutoFarm.lua"))

function ChangeSetting(SettingName, Value)
    Settings[SettingName] = Value
    
    Save()
end

function GetUnitInfo(UnitName)
    if not UnitName or UnitName == "None" then return end
    for i, Info in pairs(UnitsInfo) do
        if i == UnitName then
            return Info
        end
    end

    return 
end

function GetMythics()
    local Mythics = {}
    for i, Info in pairs(UnitsInfo) do
        if Info.rarity and Info.rarity == "Mythic" and not string.match(i,"_evolved") then
            if Info.hide_from_banner then continue end
            table.insert(Mythics, i)
        end
    end

    return Mythics
end

function ShopItems()
    local items = {}

    for i,v in pairs(Items) do
        table.insert(items, i)
    end

    return items
end

if game.PlaceId == 8304191830 then -- Lobby
    local Lobbies = game:GetService("Workspace")["_LOBBIES"].Story

    local TeleportAreas = {
        ["Challenges"] = CFrame.new(82.5503769, 194.505249, -373.466858),
        ["Leaderboard"] = CFrame.new(384.928, 195.666, -657.437),
        ["Summon"] = CFrame.new(252.503937, 196.631577, -769.12146),
        ["Traits"] = CFrame.new(418.272, 195.333, -531.499),
        ["Evolve"] = CFrame.new(561.148, 192.849, -527.637),
        ["Play"] = CFrame.new(47.8356, 196.307, -525.739)
    }

    local Maps = {
        "namek",
        --"aot",
        --"demonslayer",
        --"naruto",
        "marineford"
    }
    
    local Numbers = {
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
    }
    
    local Difficulties = {
        "Normal",
        "Hard"
    }

    local Rarities = {
        "Rare",
        "Epic",
        "Legendary"
    }
    local ctrl = false
    
    local UpgradeDropHolder = {
        
    }
    local PlacementDropHolder = {}
    
    local window = SolarisLib:New({
        Name = "DizFarm Version:1.0d",
        FolderToSave = "DizNuts"
    })
    local SettingsWindow = window:Tab("Settings") -- Creates the window
    
    local MapSection = SettingsWindow:Section("MapSettings")
    local TeleportSettings = SettingsWindow:Section("TeleportSettings")
    local UnitSettings = SettingsWindow:Section("UnitSettings")
    local ShopSettings = SettingsWindow:Section("ShopSettings")
    
    local TeleportWindow = window:Tab("Teleports") -- Creates the window
    local Areas = TeleportWindow:Section("Areas")
    
    local SummonSettings = window:Tab("SummonSettings") -- Creates the window
    local AutoSummon = SummonSettings:Section("AutoSummon")
    local AutoDelete = SummonSettings:Section("AutoDelete")

    local Misc = window:Tab("Misc")
    local MiscSection = Misc:Section("Misc")



    --[[
        -- AutoDelete > Toggle
        -- KeepShiny > Toggle
        -- AutoDeleteRarity > MultiDropdown  (Everything but mythic+)
    --]]
    
    MapSection:Dropdown("Map", Maps, Settings.Map, "MapDrop", function(NewMap)
        ChangeSetting("Map", NewMap)
    end)

    MapSection:Dropdown("MapNumber", Numbers, Settings.MapNumber, "Mapnumber", function(NewNumber)
        ChangeSetting("MapNumber", NewNumber)
    end)
    MapSection:Dropdown("Difficulty", Difficulties, Settings.Difficulty, "Difficulty", function(NewDiff)
        ChangeSetting("Difficulty", NewDiff)
    end)
    
    MapSection:Toggle("Infinite", Settings.IsInf, "Infinite", function(bool)
        ChangeSetting("IsInf", bool)
    end)
    
    SellAt = MapSection:Textbox("SellAt", false, tostring(Settings.SellAt), function(Text)
        Text = tonumber(Text) or 1
        ChangeSetting("SellAt", Text)
        SellAt:Set(Text)
    end)
    
    TeleportSettings:Toggle("Pause", Settings.Pause, "Pause", function(bool)
        ChangeSetting("Pause", bool)
    end)

    ShopSettings:MultiDropdown("Shop", ShopItems(), Settings.AutoBuy, "S34hop", function(NewDiff)
        ChangeSetting("AutoBuy", NewDiff)
    end)

    local auto
    auto = AutoSummon:Toggle("AutoSummon", Settings.AutoSummon.Enabled, "AutoSum", function(bool)
        Settings.AutoSummon.Enabled = bool
        Save()

        if bool then
            repeat
                local open = (Settings.AutoSummon.x10 and "gems10") or "gems"
                local CanSummon = game:GetService("ReplicatedStorage").endpoints.client_to_server.buy_random_fighter:InvokeServer("dbz_fighter", open)
                print(CanSummon)
                if not CanSummon then
                    auto:Set(false)
                end
                task.wait(3)
            until not Settings.AutoSummon.Enabled
        end
    end)

    AutoSummon:Toggle("x10", Settings.AutoSummon.x10, "x10", function(bool)
        Settings.AutoSummon.x10 = bool
        Save()
    end)

    AutoSummon:MultiDropdown("SummonFor (Mythic) -- Not Done", GetMythics(), Settings.AutoSummon.SummonFor or {}, "summonfor", function(units)
        Settings.AutoSummon.SummonFor = units
        Save()
    end)

    local URMOM
    URMOM = AutoDelete:Toggle("AutoDelete", Settings.AutoDelete.Enabled, "AutoDelete", function(bool)
        Settings.AutoDelete.Enabled = bool
        Save()
    end)

    AutoDelete:Toggle("KeepTraits", Settings.AutoDelete.KeepTraits, "KeepTraits", function(bool)
        Settings.AutoDelete.KeepTraits = bool
        URMOM:Set(false) -- whatever u wanna set it to
        Settings.AutoDelete.Enabled = false
        Save()
    end)

    AutoDelete:MultiDropdown("Rarities", Rarities, Settings.AutoDelete.Rarities, "Rarities", function(AddedRarities)
        Settings.AutoDelete.Rarities = AddedRarities
        URMOM:Set(false)
        Settings.AutoDelete.Enabled = false
        Save()
    end)

    MiscSection:Toggle("Anti Afk", Settings.AntiAFK, "AntiAfk", function(bool)
        Settings.AntiAFK = bool
        Save()
    end)

    for Area, Position in pairs(TeleportAreas) do
        Areas:Button(Area, function()
            Player.Character:SetPrimaryPartCFrame(Position)
        end)
    end
    
    function GetPlayersLevel()
        local exp = Player._stats.player_xp.Value
        
        return math.floor(0.07142857142857142 * (-179 + math.sqrt(56 * exp + 37249)));
    end
    
    function Save()
        writefile(FileName..tostring(Player.UserId) .. ".lua", HttpService:JSONEncode(Settings))
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and ctrl then
            local Character = Player.Character
            local Humanoid = Character.Humanoid
            
            Character:SetPrimaryPartCFrame(CFrame.new(Mouse.Hit.Position) * CFrame.new(0, 3, 0))
        end
        
        if input.KeyCode == Enum.KeyCode.LeftControl then
            ctrl = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.LeftControl then
            ctrl = false
        end
    end)

    function MakeList(num)
        local list = {}
        for i = 1, num do
            table.insert(list, i)
        end
        return list
    end
    
    function GetUnits()
        repeat
            task.wait()
        until EndpointsClient.session
        task.wait(3)
        local equipped = EndpointsClient.session.collection.collection_profile_data.equipped_units
        local AllUnits = EndpointsClient.session.collection.collection_profile_data.owned_units
        local pets = {}
        local MaxSlots = 5
            
        for Index, uuid in pairs(equipped) do
            if AllUnits[uuid] then
                local info = AllUnits[uuid]
                
                pets[Index] = string.format("%s:%s", uuid, info.unit_id)
            end
        end
        
        table.insert(pets, "None")
        
        for i = 1, MaxSlots do
            local CurrentUnit = Settings.Units[i] or "None"
            local UnitName = (CurrentUnit ~= "None" and  string.split(Settings.Units[i], ":")[2]) or nil
            local UnitData = GetUnitInfo(UnitName)
            local Spawn_Cap = (UnitData and UnitData.spawn_cap or 1)

            UnitSettings:Label("Unit#" .. tostring(i), Color3.new(0.678431, 0.905882, 0.454901))
            
            UnitSettings:Dropdown("Unit", pets, CurrentUnit, "Unit"..tostring(i), function(newUnit)
                CurrentUnit = newUnit
                UnitName = (CurrentUnit ~= "None" and  string.split(newUnit, ":")[2]) or nil
                UnitData = GetUnitInfo(UnitName)
                Spawn_Cap = (CurrentUnit ~= "None" and UnitData.spawn_cap or 3)

                Settings.Units[i] = newUnit
                Save()

                if UpgradeDropHolder[i] then
                    local UpgradeNum = (UnitData and #UnitData.upgrade) or 3
                    
                    UpgradeDropHolder[i]:Set(UpgradeNum)
                    UpgradeDropHolder[i]:Refresh(MakeList(UpgradeNum), true)

                    PlacementDropHolder[i]:Set(Spawn_Cap)
                    PlacementDropHolder[i]:Refresh(MakeList(Spawn_Cap), true)
                end
            end)

            UpgradeDropHolder[i] = UnitSettings:Dropdown("Upgrade",(UnitData and MakeList(#UnitData.upgrade)) or {}, Settings._Upgrades[i] or 1, "Upgrade"..tostring(i), function(newUnit)
                Settings._Upgrades[i] = newUnit
                Save()
            end)

            PlacementDropHolder[i] = UnitSettings:Dropdown("SpawnCap",(CurrentUnit ~= "None" and MakeList(Spawn_Cap)) or {}, Settings.SpawnCaps[i] or 1, "SpawnCap" .. tostring(i), function(newcap)
                Settings.SpawnCaps[i] = newcap
                Save()
            end)
        end
    end

    function DeleteRarityCheck(rarity)
        for _, v in pairs(Settings.AutoDelete.Rarities) do
            if rarity == v then
                return true
            end
        end
        return false
    end

    
    function AutoDelete()
        if Settings.AutoDelete.Enabled then
            local UnitsToDelete = {}
            local allUnits = EndpointsClient.session.collection.collection_profile_data.owned_units
            --equipped_slot
            for _, v in pairs(allUnits) do
                local Info = GetUnitInfo(v.unit_id)
                if v.xp ~= 0 then continue end
                if Info.limited or Info.hide_from_banner then continue end
                if Settings.AutoDelete.KeepTraits and #v.traits > 0 then continue end
                if DeleteRarityCheck(Info.rarity) and not v.equipped_slot then
                    if not Settings.AutoDelete.KeepShiny then
                        table.insert(UnitsToDelete, v.uuid)
                    else
                        if not v.shiny then
                            table.insert(UnitsToDelete, v.uuid)
                        end
                    end
                end
            end
            
            game:GetService("ReplicatedStorage").endpoints.client_to_server.sell_units:InvokeServer(UnitsToDelete)
        end
    end

    function GetShopItems()
        local Items = {}
        local itemShop = PlayerGui:WaitForChild("ItemShop")
        task.wait(1)
        local ItemHolder = itemShop.Window.Outer.ItemFrames:GetChildren()

        for i,v in pairs(ItemHolder) do
            if v:IsA("ImageButton") then
                table.insert(Items, v.Name)
            end
        end

        return Items
    end

    function FindOpenLobby()
        for i,v in pairs(Lobbies:GetChildren()) do
            if not v.Owner.Value and not v.Active.Value and not v.Locked.Value then
                return v.Name
            end
        end
    end

    function join() -- join teleporter
        local args = {
            [1] = Lobby
        }
        
        local InLobby

        repeat
            InLobby = game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(unpack(args))
            task.wait(2)
        until InLobby
    end
        
    function Create() -- Creates the map
        local map = (Settings.IsInf and string.format("%s_infinite", Settings.Map)) or string.format("%s_level_%s", Settings.Map, tostring(Settings.MapNumber))
        local args = {
            [1] = Lobby,
            [2] = map, -- ex 1,2,3 (LOWER THE NUMBER IF ITS TOO HARD)
            [3] = true,
            [4] = (Settings.IsInf and "Hard") or Settings.Difficulty
        }
        
        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(unpack(args))
    end
        
    function start2() -- Starts the teleport
        local args = {
            [1] = Lobby
        }
        
        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(unpack(args))
    end

    function LastCheck()
        for i,v in pairs(Lobbies:GetChildren()) do
            if v.Owner.Value == Player then
                return
            end
        end

        TeleportToMap()
    end

    function TeleportToMap()
        Lobby = FindOpenLobby()
        task.wait()
        join()
        task.wait(.5)
        Create()
        task.wait(2)
        start2()
        task.wait(10)
        LastCheck()
    end

    function teleport()
        task.wait(16)

        repeat
            task.wait()
        until not Settings.Pause
        TeleportToMap()
    end

    local function localTeleportWithRetry(_, retryTime)
        local connection
        connection = TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
            if player == Player then
                print("Teleport failed, TeleportResult: "..teleportResult.Name)
                -- check the teleportResult to ensure it is appropriate to retry
                if teleportResult == Enum.TeleportResult.GameEnded or teleportResult == Enum.TeleportResult.Flooded or teleportResult == Enum.TeleportResult.Failure then
                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_leave_lobby:InvokeServer(Lobby)
                    print("Teleportfailed L")
                    task.delay(retryTime, function()
                        print("Reattempting teleport")
                        TeleportToMap()
                    end)
                end
            end
        end)
    end

    function AutoBuyItems()
        local shopitems = GetShopItems()

        for _,ShopitemName in pairs(shopitems) do
            for _,ItemToBuy in pairs(Settings.AutoBuy) do
                if string.match(ShopitemName, ItemToBuy) then
                    game:GetService("ReplicatedStorage").endpoints.client_to_server.buy_travelling_merchant_item:InvokeServer(ShopitemName)
                end
            end
        end
    end

    localTeleportWithRetry(game.PlaceId, 5)

    --claim quest - nvm lol


    task.spawn(function()
        GetUnits()
    end)

    task.spawn(function()
        repeat
            task.spawn(function()
                AutoBuyItems()
            end)
            task.wait(1)
        until false
    end)

    task.spawn(function()
        repeat
            AutoDelete()
            task.wait(1)
        until false
    end)

    teleport()
elseif game.PlaceId == 8349889591 then
    
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

    local Break = false

    request = http_request or request or HttpPost or syn.request

    local headers = {
        ["content-type"] = "application/json"
    }

    if Settings.Pause then
        return
    end

    task.spawn(function()
        repeat
            task.wait()
            if PlayerGui:WaitForChild("ResultsUI").Enabled == true  then --Checks if reward is ready to claim and claims it
                local button = PlayerGui.ResultsUI.Holder.Buttons.Next
                
                local events = {"MouseButton1Click", "MouseButton1Down", "MouseButton1Up"}
                for i,v in pairs(events) do
                    for i,v in pairs(getconnections(button[v])) do
                        task.wait()
                        v:Fire()
                    end
                end
                print("asd")
                task.wait(1)
                SendWebhook()
                task.wait(1)
                teleport()
                break
            end
        until false
    end)

    if Settings.AntiAFK then
        Player.Character.Parent = game.Lighting
    end

    syn.queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/AverageFarmer/animeAdv/main/AutoFarm.lua"))

    local FarmUnits = {
        
    }

    local SpawnNum = 1
    local hillSpawnNum = 1

    local Maps = {
        ["namek"] = {
            ["Ground"] = {
                CFrame.new(-2948.09, 93.0863, -710.218),
                CFrame.new(-2944.91, 93.7245, -702.243),
                CFrame.new(-2938.52, 93.0863, -700.306),
                CFrame.new(-2947.92, 93.0863, -699.637),
                CFrame.new(-2948.45, 93.0863, -705.009),
                CFrame.new(-2945.11, 93.0863, -707.568),
                CFrame.new(-2943.05, 93.7245, -699.922),
                CFrame.new(-2943.33, 93.7245, -704.45),
                CFrame.new(-2943.34, 93.7245, -709.403),
                CFrame.new(-2938.24, 93.0863, -704.334),
                CFrame.new(-2938.08, 93.0863, -708.257),
                CFrame.new(-2938.08, 93.0863, -714.257),
                CFrame.new(-2953.14, 93.0863, -699.354),
                CFrame.new(-2953.25, 93.0863, -703.934),
                CFrame.new(-2953.28, 93.08, -708.07)
            },

            ["Hill"] = {
                CFrame.new(-2948.11, 95.6987, -715.501),
                CFrame.new(-2950.38, 95.6987, -715.032),
                CFrame.new(-2949.47, 95.6987, -717.193),
                CFrame.new(-2951.92, 95.6987, -716.304)
            }
        },
        ["aot"] = CFrame.new(-3011.77393, 35.0377998, -684.094604),
        ["demonslayer"] = CFrame.new(-2876.57, 35.643, -135.408),
        ["naruto"] = CFrame.new(-890.466, 26.577, 313.911),
        ["marineford"] = {
            ["Ground"] = {
                CFrame.new(-2555.5, 26.5069, -34.7715),
                CFrame.new(-2554.21, 26.4909, -38.005),
                CFrame.new(-2557.89, 26.4909, -40.7217),
                CFrame.new(-2559.47, 26.5069, -36.8724),
                CFrame.new(-2560.72, 26.7268, -45.002),
                CFrame.new(-2562.53, 26.7268, -40.3499),
                CFrame.new(-2564.53, 26.4909, -45.5189),
                CFrame.new(-2554.32, 26.4909, -42.6333),
                CFrame.new(-2562.45, 27.1292, -36.9791),
                CFrame.new(-2557.22, 27.1292, -46.057),
                CFrame.new(-2566.13, 26.5069, -42.2897),
                CFrame.new(-2560.84, 26.4909, -49.0243),
                CFrame.new(-2555.5, 29.5069, -34.7715),
                CFrame.new(-2554.21, 29.4909, -38.005),
                CFrame.new(-2557.89, 29.4909, -40.7217),
                CFrame.new(-2559.47, 29.5069, -36.8724),
            },

            ["Hill"] = {
                CFrame.new(-2573.74, 30.781, -51.5541),
                CFrame.new(-2576.48, 30.781, -53.3122),
                CFrame.new(-2578.58, 29.6381, -56.3211),
                CFrame.new(-2576.05, 29.638, -57.737),
            }
        },
    }

    local Log = {

    }

    function FindUnitData(UnitName)
        for Index, uuid_name in pairs(Settings.Units) do
            if uuid_name == "None" then continue end
            local split = string.split(uuid_name, ":")
            local uuid = split[1]
            local name = split[2]

            if name == UnitName then
                return Settings._Upgrades[Index]
            end
        end
    end

    function SendWebhook()
        task.wait()
        local data = {
            ["embeds"] = {{
                ["author"] = {
                    ["name"] = Player.DisplayName .. ": Lv " .. tostring(GetPlayersLevel()),
                    ["icon_url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=420&height=420&format=png"
                },
        
                ["description"] = "Match finished",
                ["color"] = tostring(0xFF2449),
                ["fields"] = {
                    {
                        ["name"] = "Gems recived:",
                        ["value"] = string.match(PlayerGui.ResultsUI.Holder.GoldGemXP.GemReward.Main.Amount.Text, "%d+"),
                        ["inline"] = true
                    },
        
                    {
                        ["name"] = "Wave ended:",
                        ["value"] = game:GetService("Workspace")["_wave_num"].Value,
                        ["inline"] = true
                    },

                    {
                        ["name"] = "Map:",
                        ["value"] = Settings.Map,
                        ["inline"] = true
                    },

                    {
                        ["name"] = "TimeFinished:",
                        ["value"] = string.match(PlayerGui.ResultsUI.Holder.Middle.Timer.Text, "%d+%p%d+"),
                        ["inline"] = true
                    },

                    {
                        ["name"] = "Total Gems:",
                        ["value"] = Player._stats.gem_amount.Value,
                        ["inline"] = true
                    },
                }
            }}
        }
        local newdata = game:GetService("HttpService"):JSONEncode(data)
        
        local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
        request(abcdef)
    end

    function addUnits()
        for i,v in pairs(Settings.Units) do
            if i == 6 then return end
            if v == "None" then continue end
            local split = string.split(v, ":") -- uuid:name
            local uuid = split[1]
            local UnitName = split[2]


            FarmUnits[i] = {
                ["Name"] = UnitName, 
                ["uuid"] = uuid,
            };
        end
    end

    function GetSpawnCap(UnitName)
        for Index, uuid_name in pairs(Settings.Units) do
            local split = string.split(uuid_name, ":") -- uuid:name
            local uuid = split[1]
            local unitname = split[2]

            if unitname == UnitName then
                return Settings.SpawnCaps[Index]
            end
        end
    end

    function spawnUnit(Index)
        local UnitName = FarmUnits[Index]["Name"]
        local Cap = GetSpawnCap(UnitName)
        local Type = "Ground"
        if Log[Index] and Log[Index] == Cap then return end
        if not Maps[Settings.Map][Type][SpawnNum] then return end
        local args = {
            [1] = FarmUnits[Index]["uuid"],
            [2] = Maps[Settings.Map][Type][SpawnNum]
        }
        
        local placed
        
        repeat
            placed = ClientToServer:WaitForChild("spawn_unit"):InvokeServer(unpack(args))
            task.wait(1)
        until placed

        if placed then
            if not Log[Index] then
                Log[Index] = 1
            else
                Log[Index] += 1
            end

            SpawnNum += 1
        end
    end

    function upgradeUnits()
        for i, v in pairs(Units:GetChildren()) do
            if not v:FindFirstChild("_stats") or v.Name == "aot_generic" then continue end
            if v._stats:FindFirstChild("player") and  v._stats:FindFirstChild("player").Value == Player then
                local MaxUpgrade = FindUnitData(v._stats.id.Value) or 5
                print(MaxUpgrade, v.Name)
                if v._stats.upgrade.Value ~= MaxUpgrade then 

                    local Upgraded 

                    repeat
                        task.wait(3)
                        Upgraded = ClientToServer:WaitForChild("upgrade_unit_ingame"):InvokeServer(v)
                    until Upgraded or Break

                    if Break then return end
                    continue
                end
            end
        end
        task.wait(.1)
        upgradeUnits()
    end

    function GetPlayersLevel()
        local exp = Player._stats.player_xp.Value

        return math.floor(0.07142857142857142 * (-179 + math.sqrt(56 * exp + 37249)));
    end

    function SellAll()
        Break = true
        for i, v in pairs(game:GetService("Workspace")["_UNITS"]:GetChildren()) do
            if not v:FindFirstChild("_stats") or v.Name == "aot_generic" then continue end
            if v._stats.player.Value == Player then
                ClientToServer:WaitForChild("sell_unit_ingame"):InvokeServer(v)
                task.wait(.1)
            end
        end
    end

    function start() -- starts the game
        addUnits()
        task.wait(1.5)

        SolarisLib:Notification("Gems", string.format("You have %s GEMS", tostring(Player._stats.gem_amount.Value)), 60 * 20)
        task.spawn(function()
            ClientToServer:WaitForChild("vote_start"):InvokeServer()
        end)

        for Index, Info in pairs(FarmUnits) do
            local Name = Info["Name"]
            print(Name)
            local Cap = GetSpawnCap(Name) -- Spawn Cap
            for i = 1, Cap do
                task.wait(1)
                spawnUnit(Index)
            end
        end

        game:GetService("Workspace")["_wave_num"].Changed:Connect(function()
            if game:GetService("Workspace")["_wave_num"].Value >= Settings.SellAt then
                SellAll()
            end
        end)

        task.spawn(function()
            repeat
                for i,v in pairs(Units:GetChildren()) do
                    if not v:FindFirstChild("_stats") then continue end
                    if v.Name == "erwin" or v.Name == "shanks" then
                        if v._stats:FindFirstChild("player") then
                            if v._stats.player.Value == Player then
                                ClientToServer.use_active_attack:InvokeServer(v)
                                task.wait(20)
                            end
                        end
                    end
                end
                task.wait()
            until Break
        end)

        upgradeUnits()       
    end

    function teleport()
        ClientToServer.teleport_back_to_lobby:InvokeServer()
        task.wait(10)
        TeleportService:Teleport(8304191830)
    end

    local function localTeleportWithRetry(placeid, retryTime)
        local connection
        connection = TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
            if player == Player then
                print("Teleport failed, TeleportResult: "..teleportResult.Name)
                -- check the teleportResult to ensure it is appropriate to retry
                if teleportResult == Enum.TeleportResult.GameEnded or teleportResult == Enum.TeleportResult.Flooded or teleportResult == Enum.TeleportResult.Failure then
                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_leave_lobby:InvokeServer(Lobby)
                    print("Teleportfailed L")
                    task.delay(retryTime, function()
                        print("Reattempting teleport")
                        TeleportService:Teleport(placeid)
                    end)
                end
            end
        end)
    end

    localTeleportWithRetry(8304191830, 5)

    task.wait(10)
    start()
end