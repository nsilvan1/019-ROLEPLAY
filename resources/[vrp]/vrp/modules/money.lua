---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CACHE
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local cache = {}
cache["getMoney"] = {}
cache["getBankMoney"] = {}
cache["getPaypal"] = {}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- QUERYS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/money_init_user","INSERT IGNORE INTO vrp_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
vRP.prepare("vRP/get_money","SELECT wallet,bank,paypal FROM vrp_user_moneys WHERE user_id = @user_id")
vRP.prepare("vRP/set_money","UPDATE vrp_user_moneys SET wallet = @wallet WHERE user_id = @user_id")
vRP.prepare("vRP/set_bank_money","UPDATE vrp_user_moneys SET bank = @bank WHERE user_id = @user_id")

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE PAYPAL
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function vRP.getPaypal(user_id)
	if cache["getPaypal"][user_id] == nil then
		local rows = vRP.query("vRP/get_money",{ user_id = user_id })
		if #rows > 0 then
			cache["getPaypal"][parseInt(user_id)] = rows[1].paypal
			return cache["getPaypal"][parseInt(user_id)]
		end
	else
		return cache["getPaypal"][parseInt(user_id)]
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE CARTEIRA
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function vRP.getMoney(user_id)
	if cache["getMoney"][user_id] == nil then
		local rows = vRP.query("vRP/get_money",{ user_id = user_id })
		if #rows > 0 then
			cache["getMoney"][parseInt(user_id)] = rows[1].wallet
			return cache["getMoney"][parseInt(user_id)]
		end
	else
		return cache["getMoney"][parseInt(user_id)]
	end
end


function vRP.setMoney(user_id,value)
	if user_id then
		cache["getMoney"][parseInt(user_id)] = value
		vRP.execute("vRP/set_money",{ user_id = user_id, wallet = cache["getMoney"][user_id] })
	end
end

function vRP.tryPayment(user_id,amount)
	if amount >= 0 then
		local money = vRP.getMoney(user_id)
		if amount >= 0 and money >= amount then
			vRP.setMoney(user_id,money-amount)
			return true
		else
			return false
		end
	end
	return false
end

function vRP.giveMoney(user_id,amount)
	if amount >= 0 then
		local money = vRP.getMoney(user_id)
		vRP.setMoney(user_id,money+amount)
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE BANCO 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function vRP.getBankMoney(user_id)
	if cache["getBankMoney"][parseInt(user_id)] == nil then
		local rows = vRP.query("vRP/get_money",{ user_id = user_id })
		if #rows > 0 then
			cache["getBankMoney"][parseInt(user_id)] = rows[1].bank
			return cache["getBankMoney"][parseInt(user_id)]
		end
	else
		return cache["getBankMoney"][parseInt(user_id)]
	end
end

function vRP.setBankMoney(user_id,value)
	if user_id then
		cache["getBankMoney"][parseInt(user_id)] = value
		vRP.execute("vRP/set_bank_money",{ user_id = user_id, bank = cache["getBankMoney"][parseInt(user_id)] })
	end
end

function vRP.giveBankMoney(user_id,amount)
	if amount >= 0 then
		local money = vRP.getBankMoney(user_id)
		vRP.setBankMoney(user_id,money+amount)
	end
end

function vRP.tryWithdraw(user_id,amount)
	local money = vRP.getBankMoney(user_id)
	if amount >= 0 and money >= amount then
		vRP.setBankMoney(user_id,money-amount)
		vRP.giveMoney(user_id,amount)
		return true
	else
		return false
	end
end

function vRP.tryDeposit(user_id,amount)
	if amount >= 0 and vRP.tryPayment(user_id,amount) then
		vRP.giveBankMoney(user_id,amount)
		return true
	else
		return false
	end
end

function vRP.tryFullPayment(user_id,amount)
	if amount >= 0 then
		local money = vRP.getMoney(user_id)
		if money >= amount then
			return vRP.tryPayment(user_id,amount)
		else
			if vRP.tryWithdraw(user_id, amount-money) then
				return vRP.tryPayment(user_id,amount)
			end
		end
	end
	return false
end

AddEventHandler("vRP:playerJoin",function(user_id,source,name)
	vRP.execute("vRP/money_init_user",{ user_id = user_id, wallet = 2000, bank = 3000 })
end) 

AddEventHandler("vRP:playerLeave",function(user_id,source)
	if user_id then
		cache["getMoney"][parseInt(user_id)] = nil
		cache["getBankMoney"][parseInt(user_id)] = nil
	end
end)

function vRP.injectMoneyLimpo(user_id,amount)
    vRP.giveMoney(user_id,amount)
    local source = vRP.getUserSource(user_id)
    if(source~=nil)then
        TriggerEvent("MQCU:InjectMoney",source,parseInt(amount),false)
    end
end

function vRP.injectMoneySujo(user_id,item,amount)
    vRP.giveInventoryItem(user_id,item,amount)
    local source = vRP.getUserSource(user_id)
    if(source~=nil)then
        TriggerEvent("MQCU:InjectMoney",source,parseInt(amount),true)
    end
end


function vRP.injectBankMoneyLimpo(user_id,amount)
    vRP.giveBankMoney(user_id,amount)
    local source = vRP.getUserSource(user_id)
    if(source~=nil)then
        TriggerEvent("MQCU:InjectMoney",source,parseInt(amount),false)
    end
end