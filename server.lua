local tagon = {}
local tagoncheck = {}
local index = 0 -- DONT TOUCH PLEASE!
local DISCORD_NAME = "Staff Duty"
local DISCORD_URL = "https://discord.com/api/webhooks/981441993001537616/x7Nn1E8ueikB6Y9sh7As0e6JkekPrIVgiPscUR4MjYVgjAS4JuHKJiDod1eO0dIyk_3-"
local DISCORD_IMAGE = "https://pbs.twimg.com/profile_images/847824193899167744/J1Teh4Di_400x400.jpg" -- must end with .jpg or .png


RegisterServerEvent("Cheleber:SVstarttag")
AddEventHandler('Cheleber:SVstarttag', function()
    local playerId = source
    if isAdmin(playerId) then
	    dprint('Allowed: ' .. playerId)
	    index = index + 1
	    tagon[index] = {
	        ['id'] = playerId,
	    }
	    CheleberRestartTag1()
	end
end)
	
RegisterServerEvent("Cheleber:SVstarttagjoin")
AddEventHandler('Cheleber:SVstarttagjoin', function()
    local playerId = source
    if isAdmin(playerId) then
	    dprint('Allowed: ' .. playerId)
	    index = index + 1
	    tagoncheck[playerId] = true
	    tagon[index] = {
	        ['id'] = playerId,
	    }
	    CheleberRestartTag1()
	end
end)

function CheleberRestartTag1()
    dprint('Restarting...')
    for i = 1, #tagon,1 do
        if tagoncheck[tagon[i].id] == true then	
    	    TriggerClientEvent("Cheleber:tag1", -1, tagon[i].id, 'true')
	        dprint('Restarted ID: ' .. tagon[i].id)
        else
    	    TriggerClientEvent("Cheleber:tag1", -1, tagon[i].id, 'false')
	        dprint('Restarted ID: ' .. tagon[i].id)
		end
	end
end

function CheleberCleanTagTable()
    dprint("Cleaning...")
    index = 0
	if ModoDebug then
	    for i = 1, #tagon,1 do
		    dprint("Cleaned ID: "  .. tagon[i].id)
	    end
	end
	for k in pairs (tagon) do
        tagon [k] = nil
    end
	TriggerClientEvent("Cheleber:tagclean", -1)
end

RegisterCommand("tag", function(source, args, rawCommand)
    if isAdmin(source) then
	    if tagoncheck[source] == true  then
			tagoncheck[source] = false
			
		    index = 0
		    for k in pairs (tagon) do
        		tagon [k] = nil
    		end
			TriggerClientEvent("Cheleber:tagclean", -1)
		    TriggerClientEvent('chatMessage', source, "Tag OFF!")
	            local playerId = GetPlayerFromServerId(source)
   		    local id = GetPlayerServerId(playerId)
		    local name = GetPlayerName(source)
		    sendToDiscord(name, id "is now Tag OFF! ")
		else
			tagoncheck[source] = true
			index = 0
			for k in pairs (tagon) do
        		tagon [k] = nil
    		end
			TriggerClientEvent("Cheleber:tagclean", -1)
			TriggerClientEvent('chatMessage', source, "Tag ON!")
			    local playerId = GetPlayerFromServerId(source)
			    local id = GetPlayerServerId(playerId)
			    local name = GetPlayerName(source)
		    	sendToDiscord(name,id "is now Tag ON! ")
	    end
	end
end, false)


function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function isAdmin(player)
    local allowed = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

function dprint(msg)
	if ModoDebug then
		print(msg)
	end
end

---THIS CLEAN THE TABLE EVERY MINUTE, YOU CAN CHANGE THIS THIME, OPTIONAL. 
function cleantagstable()
	SetTimeout(60000, CheleberCleanTagTable)  
	SetTimeout(60000, cleantagstable) 
end

cleantagstable()
function sendToDiscord(name, message)
  local date = os.date('*t')
  local connect = {
        {
            ["color"] = "8663711",
            ["title"] = "**" .. name .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Made by Kasra "
            },
        }
    }
  PerformHttpRequest(DISCORD_URL, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end
