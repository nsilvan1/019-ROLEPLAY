-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
vTASKBAR = Tunnel.getInterface("vrp_taskbar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
------------------------------------------------------------------------------------------------------------------------------------------
vRP._prepare("vRP/insertHouses","INSERT INTO cfg_residences(name,x,y,z,interiorType,intPrice,slot,trade) VALUES(@name,@x,@y,@z,@interiorType,@intPrice,@slot,@trade)")
vRP._prepare("vRP/selectcHouse","SELECT * FROM cfg_residences WHERE name = @name")
vRP._prepare("vRP/deleteHouse","DELETE FROM cfg_residences WHERE name = @name")
vRP._prepare("vRP/selectAppartment","SELECT * FROM characters_homes WHERE name = @name AND number = @number")
vRP._prepare("vRP/selectOwner","SELECT * FROM characters_homes WHERE name = @name AND number = @number AND owner = 1")
vRP._prepare("vRP/selectAP2","SELECT * FROM characters_homes WHERE name = @name AND number = @number AND user_id = @user_id")
vRP._prepare("vRP/deleteAP","DELETE FROM characters_homes WHERE name = @name AND number = @number")
vRP._prepare("vRP/buyAppartment","INSERT INTO `characters_homes`(`name`,`interior`,`tax`,`price`,`user_id`,`residents`,`vault`,`owner`,`number`) VALUES(@name,@interior,@tax,@price,@user_id,@residents,@vault,1,@number)")
vRP._prepare("vRP/secondOwnerAP","INSERT INTO characters_homes(name,interior,user_id,owner,number) VALUES(@name,@interior,@user_id,@owner,@number)")
vRP._prepare("vRP/updateInterior","UPDATE characters_homes SET interior = @interior WHERE name = @name AND user_id = @user_id")
vRP._prepare("vRP/updateInterior2","UPDATE characters_homes SET interior = @interior WHERE name = @name AND number = @number AND user_id = @user_id")
vRP._prepare("homes/buying","INSERT INTO characters_homes(name,interior,tax,price,user_id,residents,vault,owner) VALUES(@name,@interior,@tax,@price,@user_id,@residents,@vault,1)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEND WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
function generateWebhook(user_id,infos)
	local discords = { 
		["buyAp"] = "",
		["buyHouse"] = "",
		["sell"] = "",
		["transfer"] = "",
		["addmorador"] = "",
		["remmorador"] = "",
		["tax"] = "",
		["garages"] = "",
		["upgrade"] = "",
		["baú"] = "",
	}

	local user_id = parseInt(user_id)
    local identity = vRP.getUserIdentity(user_id)

	PerformHttpRequest(discords[infos["transaction"]], function(err, text, headers)
    end, "POST", json.encode({
        username = "SPACE",
        avatar_url = "",
        embeds = {
            {
            description = "**ID:** "..user_id.."\n**NOME:** "..identity.name.." ".. identity.firstname.." \n("..GetPlayerName(vRP.getUserSource(user_id))..") \n\n"..infos["message"].."\n",
            thumbnail = {
                url = ""
            },
            footer = {
                text = "SPACE | Conectando às "..os.date("%H:%M:%S")
            },
            color = 3092790
        }
    }}), { ["Content-Type"] = "application/json" })

end
