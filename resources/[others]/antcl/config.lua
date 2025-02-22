local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

Config = {}

Config.DrawingTime = 120*1000 --60 seconds
Config.TextColor = {r=255, g=255,b=255} -- WHITE (Player Data)
Config.AlertTextColor = {r=255, g=0, b=0} -- RED (Player Left Game)
Config.LogSystem = false
Config.UseSteam = true -- If False then use R* License
Config.LogBotName = "Combat-Logging"
Config.AutoDisableDrawing = true
Config.AutoDisableDrawingTime = 30000