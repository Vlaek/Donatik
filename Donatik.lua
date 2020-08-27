script_name("Donatik")
script_author("bier aka Oleg_Cutov aka Vladanus")
script_version("27/08/2020")
script_version_number(1)
script_url("https://vlaek.github.io/Donatik/")
script.update = false

local sampev, inicfg, imgui, encoding, vkeys, rkeys = require 'lib.samp.events', require 'inicfg', require 'imgui', require 'encoding', require "vkeys", require 'rkeys'
local as_action = require 'moonloader'.audiostream_state
imgui.HotKey = require('imgui_addons').HotKey
require "reload_all"
require "lib.sampfuncs"
require "lib.moonloader"
encoding.default = 'CP1251'
local u8 = encoding.UTF8

local ini1 = {}
local ini2 = {}
local ini3 = {}
local ini4 = {}
local ini5 = {}
local ini6 = {}
local ini7 = {}
local ini8 = {}
local ini9 = {}

local tLastKeys = {}

local main_window_state = imgui.ImBool(false)
local resX, resY = getScreenResolution()
local text_buffer_target = imgui.ImBuffer(256)
local text_buffer_name = imgui.ImBuffer(256)
local text_buffer_nick = imgui.ImBuffer(256)
local text_buffer_summa = imgui.ImBuffer(256)

imgui.BufferingBar = require('imgui_addons').BufferingBar

local main_color = 0xFFFF00
local summa = 0
local nickname = ""
local percent = 0

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	repeat wait(0) until sampGetCurrentServerName() ~= 'SA-MP'
	repeat 
		wait(0)
		for id = 0, 2303 do
			if sampTextdrawIsExists(id) and sampTextdrawGetString(id):find('Samp%-Rp.Ru') then
				samp_rp = true
			end
		end
	until samp_rp ~= nil
	local _, my_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	my_name = sampGetPlayerNickname(my_id)
	my_day = os.date("%d")
	my_month = os.date("%m")
	my_year = os.date("%Y")
	server = sampGetCurrentServerName():gsub('|', '')
	server = (server:find('02') and 'Two' or (server:find('Revolution') and 'Revolution' or (server:find('Legacy') and 'Legacy' or (server:find('Classic') and 'Classic' or ''))))
	if server == '' then thisScript():unload() end
	
	AdressConfig = string.format("%s\\moonloader\\config" , getGameDirectory())
	AdressFolder = string.format("%s\\moonloader\\config\\Donaters\\%s\\%s", getGameDirectory(), server, my_name)
	if not doesDirectoryExist(AdressConfig) then createDirectory(AdressConfig) end
	if not doesDirectoryExist(AdressFolder) then createDirectory(AdressFolder) end
	directIni1 = string.format("Donaters\\%s\\%s\\DonateMoney.ini", server, my_name)
	directIni2 = string.format("Donaters\\%s\\%s\\todayDonateMoney.ini", server, my_name)
	directIni3 = string.format("Donaters\\%s\\%s\\TopDonaters.ini", server, my_name)
	directIni4 = string.format("Donaters\\%s\\%s\\todayTopDonaters.ini", server, my_name)
	directIni5 = string.format("Donaters\\%s\\%s\\Donaters.ini", server, my_name)
	directIni6 = string.format("Donaters\\%s\\%s\\todayDonaters.ini", server, my_name)
	directIni9 = string.format("Donaters\\%s\\%s\\Settings.ini", server, my_name)
	
	Wait = lua_thread.create_suspended(Waiting)
	Wait2 = lua_thread.create_suspended(Waiting2)
	
	sampRegisterChatCommand("donaters", cmd_donaters)
	sampRegisterChatCommand('dHud', menu)
	sampRegisterChatCommand("topdonaters", cmd_topdonaters)
	sampRegisterChatCommand("DonateMoney", cmd_DonateMoney)
	sampRegisterChatCommand("DonateMoneyZiel", cmd_DonateMoneyZiel)
	sampRegisterChatCommand("todayDonateMoney", cmd_todayDonateMoney)
	sampRegisterChatCommand("dHudik", cmd_hud)
	
	DonateMoney = string.format('DonateMoney')
	if ini1[DonateMoney] == nil then
		ini1 = inicfg.load({
			[DonateMoney] = {
				money = tonumber(0),
				count = tonumber(0),
				target = tonumber(1000000),
				hud = false,
				zielName = "Untitled"
			}
		}, directIni1)
		inicfg.save(ini1, directIni1)
	end
	
	todayDonateMoney = string.format('DonateMoney-%s-%s-%s', my_day, my_month, my_year)
	if ini2[todayDonateMoney] == nil then
		ini2 = inicfg.load({
			[todayDonateMoney] = {
				money = tonumber(0),
				count = tonumber(0)
			}
		}, directIni2)
		inicfg.save(ini2, directIni2)
	end	
	
	TopPlayers = string.format('TopPlayers')
	if ini3[TopPlayers] == nil then
		ini3 = inicfg.load({
			[TopPlayers] = {
				firstSumma=tonumber(0),
				thirdName=u8:decode"Пусто",
				firstName=u8:decode"Пусто",
				secondSumma=tonumber(0),
				thirdSumma=tonumber(0),
				secondName=u8:decode"Пусто"
			}
		}, directIni3)
		inicfg.save(ini3, directIni3)
	end	
	
	todayTopPlayers = string.format('TopPlayers-%s-%s-%s', my_day, my_month, my_year)
	if ini4[todayTopPlayers] == nil then
		ini4 = inicfg.load({
			[todayTopPlayers] = {
				firstSumma=tonumber(0),
				thirdName=u8:decode"Пусто",
				firstName=u8:decode"Пусто",
				secondSumma=tonumber(0),
				thirdSumma=tonumber(0),
				secondName=u8:decode"Пусто"
			}
		}, directIni4)
		inicfg.save(ini4, directIni4)
	end
	
	Player = string.format('%s', Niemand)
	if ini5[Player] == nil then
		ini5 = inicfg.load({
			[Player] = {
				nick = tostring(Niemand),
				money = tonumber(0)
			}
		}, directIni5)
		inicfg.save(ini5, directIni5)
	end
	
	todayPlayer = string.format('%s-%s-%s-%s', my_day, my_month, my_year, Niemand)
	if ini6[todayPlayer] == nil then
		ini6 = inicfg.load({
			[todayPlayer] = {
				nick = tostring(Niemand),
				money = tonumber(0)
			}
		}, directIni6)
		inicfg.save(ini6, directIni6)
	end
	
	hotkey = string.format('hotkey')
	if ini9[hotkey] == nil then
		ini9 = inicfg.load({
			[hotkey] = {
				bindDonaters="[18,49]",
				bindTopDonaters="[18,50]",
				bindDonateMoney="[18,51]",
				bindDonateMoneyZiel="[18,52]",
				bindHud="[18,53]"
			}
		}, directIni9)
		inicfg.save(ini9, directIni9)
	end
	
	settings = string.format('settings')
	if ini9[settings] == nil then
		ini9 = inicfg.load({
			[settings] = {
				DonateNotify=true,
				DonatersNotify=true,
				TodayDonatersNotify=true,
				Sound=false,
				TargetNotify=false
			}
		}, directIni9)
		inicfg.save(ini9, directIni9)
	end
	
	ActiveDonaters = {
		v = decodeJson(ini9.hotkey.bindDonaters)
	}

	ActiveTopDonaters = {
		v = decodeJson(ini9.hotkey.bindTopDonaters)
	}
	
	ActiveDonateMoney = {
		v = decodeJson(ini9.hotkey.bindDonateMoney)
	}
	
	ActiveDonateMoneyZiel = {
		v = decodeJson(ini9.hotkey.bindDonateMoneyZiel)
	}
	
	ActiveHud = {
		v = decodeJson(ini9.hotkey.bindHud)
	}
	
	bindDonaters = rkeys.registerHotKey(ActiveDonaters.v, true, cmd_donaters)
	bindTopDonaters = rkeys.registerHotKey(ActiveTopDonaters.v, true, cmd_topdonaters)
	bindDonateMoney = rkeys.registerHotKey(ActiveDonateMoney.v, true, cmd_DonateMoney)
	bindDonateMoneyZiel = rkeys.registerHotKey(ActiveDonateMoneyZiel.v, true, cmd_DonateMoneyZiel)
	bindHud = rkeys.registerHotKey(ActiveHud.v, true, cmd_hud)
	
	AdressFolderZiel = string.format("%s\\moonloader\\config\\Donaters\\%s\\%s\\%s", getGameDirectory(), server, my_name, ini1[DonateMoney].zielName)
	if not doesDirectoryExist(AdressFolderZiel) then createDirectory(AdressFolderZiel) end
	directIni7 = string.format("Donaters\\%s\\%s\\%s\\Donaters.ini", server, my_name, ini1[DonateMoney].zielName)
	directIni8 = string.format("Donaters\\%s\\%s\\%s\\DonateMoney.ini", server, my_name, ini1[DonateMoney].zielName)
	
	PlayerZiel = string.format('%s', Niemand)
	if ini7[PlayerZiel] == nil then
		ini7 = inicfg.load({
			[PlayerZiel] = {
				nick = tostring(Niemand),
				money = tonumber(0)
			}
		}, directIni7)
		inicfg.save(ini7, directIni7)
	end
	
	DonateMoneyZiel = string.format('DonateMoneyZiel')
	if ini8[DonateMoneyZiel] == nil then
		ini8 = inicfg.load({
			[DonateMoneyZiel] = {
				money = tonumber(0),
				target = ini1[DonateMoney].target,
			}
		}, directIni8)
		inicfg.save(ini8, directIni8)
	end
	
	imgui.ApplyCustomStyle()
	imgui.Process = true
		
	ini1 = inicfg.load(DonateMoney, directIni1)
	ini2 = inicfg.load(todayDonateMoney, directIni2)
	ini3 = inicfg.load(TopPlayers, directIni3)
	ini4 = inicfg.load(todayTopPlayers, directIni4)
	ini5 = inicfg.load(Donaters, directIni5)
	ini6 = inicfg.load(todayDonaters, directIni6)
	ini7 = inicfg.load(PlayerZiel, directIni7)
	ini8 = inicfg.load(DonateMoneyZiel, directIni8)
	ini9 = inicfg.load(hotkey, directIni9)
	imgui.initBuffers()
	
	soundManager.loadSound("100k")    -- amahasla
	soundManager.loadSound("75k")     -- yanix
	soundManager.loadSound("50k")     -- yanix
	soundManager.loadSound("25k")     -- far cry 3
	soundManager.loadSound("10k")     -- far cry 3
	soundManager.loadSound("5k")      -- wkolnik
	soundManager.loadSound("1k")      -- wkolnik
	soundManager.loadSound("100")     -- papich
	soundManager.loadSound("0")       -- papich
	soundManager.loadSound("percent") -- 
	
	checkUpdates()
	sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Успешно загрузился!", main_color)
	while true do
		wait(0)
		imgui.ShowCursor = false
		
		percent = (tonumber(ini8[DonateMoneyZiel].money)/tonumber(ini8[DonateMoneyZiel].target))
		
		if isKeyJustPressed(VK_ESCAPE) and main_window_state.v then
			main_window_state.v = false
		end
		
	end
end

function cmd_donaters()
	Wait:run()
end

function menu()
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
end

function cmd_hud()
	ini1[DonateMoney].hud = not ini1[DonateMoney].hud
	sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Отображение HUDa: {40E0D0}" .. (ini1[DonateMoney].hud and '{06940f}ON' or '{d10000}OFF'), main_color)
	inicfg.save(ini1, directIni1)
end

function cmd_target(arg)
	ini1[DonateMoney].target = tonumber(arg)
	inicfg.save(ini1, directIni1)
	ini8[DonateMoneyZiel].target = tonumber(arg)
	inicfg.save(ini8, directIni8)
	sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Установлена новая цель: {40E0D0}" .. ini1[DonateMoney].target, main_color)
end

function cmd_topdonaters()
	Wait2:run()
end

function cmd_DonateMoney()
	sampSendChat(u8:decode"Денег собрано за все время: " .. ini1[DonateMoney].money)
end

function cmd_DonateMoneyZiel()
	sampSendChat(string.format(u8:decode"Денег на цель \"%s\" собрано: %s/%s [%s]", ini1[DonateMoney].zielName, ini8[DonateMoneyZiel].money, ini8[DonateMoneyZiel].target, string.sub(tostring(percent * 100), 1, 5)))
end

function cmd_todayDonateMoney()
	sampSendChat(u8:decode"Всего за день собрано: " .. ini2[todayDonateMoney].money)
end

function Waiting()
	sampSendChat(u8:decode"Список пожертвований от уважаемых людей за сегодня: ")
	wait(1100)
	sampSendChat(u8:decode"1. Господин " .. ini4[todayTopPlayers].firstName .. u8:decode" с суммой " .. ini4[todayTopPlayers].firstSumma .. u8:decode" вирт")
	wait(1100)
	sampSendChat(u8:decode"2. Господин " .. ini4[todayTopPlayers].secondName .. u8:decode" с суммой " .. ini4[todayTopPlayers].secondSumma .. u8:decode" вирт")
	wait(1100)
	sampSendChat(u8:decode"3. Господин " .. ini4[todayTopPlayers].thirdName .. u8:decode" с суммой " .. ini4[todayTopPlayers].thirdSumma .. u8:decode" вирт")
	wait(1100)
	sampSendChat(u8:decode"Чтобы занять определенное место в списке, необходимо пожертвовать больше денег")
end

function Waiting2()
	sampSendChat(u8:decode"Список пожертвований от уважаемых людей за все время: ")
	wait(1100)
	sampSendChat(u8:decode"1. Господин " .. ini3[TopPlayers].firstName .. u8:decode" с суммой " .. ini3[TopPlayers].firstSumma .. u8:decode" вирт")
	wait(1100)
	sampSendChat(u8:decode"2. Господин " .. ini3[TopPlayers].secondName .. u8:decode" с суммой " .. ini3[TopPlayers].secondSumma .. u8:decode" вирт")
	wait(1100)
	sampSendChat(u8:decode"3. Господин " .. ini3[TopPlayers].thirdName .. u8:decode" с суммой " .. ini3[TopPlayers].thirdSumma .. u8:decode" вирт")
	wait(1100)
	sampSendChat(u8:decode"Чтобы занять определенное место в списке, необходимо пожертвовать больше денег")
end

function sampev.onServerMessage(color, text)
	if string.find(text, u8:decode"Вы получили .+ вирт, от .+") and not string.find(text, ":") and not string.find(text, u8:decode".+ Вы получили ") and not string.find(text, u8:decode" сказал") then
		summa, nickname = string.match(text, u8:decode"Вы получили (%d+) вирт, от (.+)%[")
		
		if ini9[settings].DonateNotify then
			if tonumber(summa) == 100000 then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Вы получили {FF0000}100000 {FFFFFF}вирт от {FF0000}" .. nickname, main_color) -- red
				if ini9.settings.Sound then
					soundManager.playSound("100k")
				end
			end
			
			if tonumber(summa) >= 75000 and tonumber(summa) ~= 100000 then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Вы получили {FF1493}" .. summa .. u8:decode" {FFFFFF}вирт от {FF1493}" .. nickname, main_color) -- yellow
				if ini9.settings.Sound then
					soundManager.playSound("75k")
				end
			end
			
			if tonumber(summa) >= 50000 and tonumber(summa) < 75000 then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Вы получили {FF00FF}" .. summa .. u8:decode" {FFFFFF}вирт от {FF00FF}" .. nickname, main_color) -- pink
				if ini9.settings.Sound then
					soundManager.playSound("50k")
				end
			end
			
			if tonumber(summa) >= 25000 and tonumber(summa) < 50000 then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Вы получили {800080}" .. summa .. u8:decode" {FFFFFF}вирт от {800080}" .. nickname, main_color) -- purple
				if ini9.settings.Sound then
					soundManager.playSound("25k")
				end
			end
			
			if tonumber(summa) >= 10000 and tonumber(summa) < 25000 then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Вы получили {0000FF}" .. summa .. u8:decode" {FFFFFF}вирт от {0000FF}" .. nickname, main_color) -- blue
				if ini9.settings.Sound then
					soundManager.playSound("10k")
				end
			end
			
			if tonumber(summa) >= 5000 and tonumber(summa) < 10000 then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Вы получили {00FFFF}" .. summa .. u8:decode" {FFFFFF}вирт от {00FFFF}" .. nickname, main_color) -- aqua
				if ini9.settings.Sound then
					soundManager.playSound("5k")
				end
			end
			
			if tonumber(summa) >= 1000 and tonumber(summa) < 5000 then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Вы получили {00FF00}" .. summa .. u8:decode" {FFFFFF}вирт от {00FF00}" .. nickname, main_color) -- green
				if ini9.settings.Sound then
					soundManager.playSound("1k")
				end
			end
			
			if tonumber(summa) >= 100 and tonumber(summa) < 1000 then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Вы получили {808000}" .. summa .. u8:decode" {FFFFFF}вирт от {808000}" .. nickname, main_color) -- olive
				if ini9.settings.Sound then
					soundManager.playSound("100")
				end
			end
			
			if tonumber(summa) < 100 then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Вы получили {556B2F}" .. summa .. u8:decode" {FFFFFF}вирт от {556B2F}" .. nickname, main_color) -- dark olive
				if ini9.settings.Sound then
					soundManager.playSound("0")
				end
			end
		end
		
		tempSumma = ini8[DonateMoneyZiel].money
		
		ini1[DonateMoney].money = ini1[DonateMoney].money + summa
		inicfg.save(ini1, directIni1)
		
		ini2[todayDonateMoney].money = ini2[todayDonateMoney].money + summa
		inicfg.save(ini2, directIni2)
		
		ini8[DonateMoneyZiel].money = ini8[DonateMoneyZiel].money + summa
		inicfg.save(ini8, directIni8)
		
		if ini9[settings].TargetNotify then
			if tempSumma < ini8[DonateMoneyZiel].target / 4 and ini8[DonateMoneyZiel].money >= ini8[DonateMoneyZiel].target / 4 then
				sampAddChatMessage(u8:decode" [Donatik] {FF0000}На цель накоплено 25 процентов!", main_color)
			end
			
			if tempSumma < ini8[DonateMoneyZiel].target / 2 and ini8[DonateMoneyZiel].money >= ini8[DonateMoneyZiel].target / 2 then
				sampAddChatMessage(u8:decode" [Donatik] {FF0000}На цель накоплено 50 процентов!", main_color)
			end
			
			if tempSumma < ini8[DonateMoneyZiel].target / 4 * 3 and ini8[DonateMoneyZiel].money >= ini8[DonateMoneyZiel].target / 4 * 3 then
				sampAddChatMessage(u8:decode" [Donatik] {FF0000}На цель накоплено 75 процентов!", main_color)
			end
			
			if tempSumma < ini8[DonateMoneyZiel].target and ini8[DonateMoneyZiel].money >= ini8[DonateMoneyZiel].target then
				sampAddChatMessage(u8:decode" [Donatik] {FF0000}Цель достигнута!!!", main_color)
			end
		end
		
		Player = string.format('%s', nickname)
		if ini5[Player] == nil then
			ini5 = inicfg.load({
				[Player] = {
					nick = tostring(nickname),
					money = tonumber(summa)
				}
			}, directIni5)
			if ini9[settings].DonatersNotify then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Господин {40E0D0}" .. nickname .. u8:decode"{FFFFFF} был добавлен с базу данных" , main_color)
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Сумма пожертвований от {40E0D0}" .. nickname .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ini5[Player].money, main_color)
			end
			ini1[DonateMoney].count = ini1[DonateMoney].count + 1
			inicfg.save(ini1, directIni1)
		else
			ini5[Player].money = ini5[Player].money + summa
			if ini9[settings].DonatersNotify then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Сумма пожертвований от {40E0D0}" .. nickname .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ini5[Player].money, main_color)
			end
		end
		inicfg.save(ini5, directIni5)
			
		PlayerZiel = string.format('%s', nickname)
		if ini7[PlayerZiel] == nil then
			ini7 = inicfg.load({
				[PlayerZiel] = {
					nick = tostring(nickname),
					money = tonumber(summa)
				}
			}, directIni7)
		else
			ini7[PlayerZiel].money = ini7[PlayerZiel].money + summa
		end
		inicfg.save(ini7, directIni7)
		
		todayPlayer = string.format('%s-%s-%s-%s', my_day, my_month, my_year, nickname)
		if ini6[todayPlayer] == nil then
			ini6 = inicfg.load({
				[todayPlayer] = {
					nick = tostring(nickname),
					money = tonumber(summa)
				}
			}, directIni6)
			if ini9[settings].TodayDonatersNotify then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Сумма пожертвований за сегодня от {40E0D0}" .. nickname .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ini6[todayPlayer].money, main_color)
			end
			ini2[todayDonateMoney].count = ini2[todayDonateMoney].count + 1
			inicfg.save(ini2, directIni2)
		else
			ini6[todayPlayer].money = ini6[todayPlayer].money + summa
			if ini9[settings].TodayDonatersNotify then
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Сумма пожертвований за сегодня от {40E0D0}" .. nickname .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ini6[todayPlayer].money, main_color)
			end
		end
		inicfg.save(ini6, directIni6)
		
		-- TODAY DONAT --
		
		if tonumber(ini6[todayPlayer].money) >= tonumber(ini4[todayTopPlayers].firstSumma) then
			if ini4[todayTopPlayers].firstName ~= ini6[todayPlayer].nick then
				if ini4[todayTopPlayers].secondName ~= ini6[todayPlayer].nick then
					ini4[todayTopPlayers].thirdSumma = ini4[todayTopPlayers].secondSumma
					ini4[todayTopPlayers].secondSumma = ini4[todayTopPlayers].firstSumma
					ini4[todayTopPlayers].thirdName = ini4[todayTopPlayers].secondName
					ini4[todayTopPlayers].secondName = ini4[todayTopPlayers].firstName
					ini4[todayTopPlayers].firstSumma = ini6[todayPlayer].money
					ini4[todayTopPlayers].firstName = nickname
				else
					ini4[todayTopPlayers].secondName = ini4[todayTopPlayers].firstName
					ini4[todayTopPlayers].secondSumma = ini4[todayTopPlayers].firstSumma
					ini4[todayTopPlayers].firstSumma = ini6[todayPlayer].money
					ini4[todayTopPlayers].firstName = nickname
				end
			else
				ini4[todayTopPlayers].firstSumma = ini6[todayPlayer].money
			end
		end
		if tonumber(ini6[todayPlayer].money) >= tonumber(ini4[todayTopPlayers].secondSumma) and tonumber(ini6[todayPlayer].money) < tonumber(ini4[todayTopPlayers].firstSumma) then
			if ini4[todayTopPlayers].secondName ~= ini6[todayPlayer].nick then
				ini4[todayTopPlayers].thirdSumma = ini4[todayTopPlayers].secondSumma
				ini4[todayTopPlayers].thirdName = ini4[todayTopPlayers].secondName
				ini4[todayTopPlayers].secondSumma = ini6[todayPlayer].money
				ini4[todayTopPlayers].secondName = nickname
			else
				ini4[todayTopPlayers].secondSumma = ini6[todayPlayer].money
			end
		end
		if tonumber(ini6[todayPlayer].money) >= tonumber(ini4[todayTopPlayers].thirdSumma) and tonumber(ini6[todayPlayer].money) < tonumber(ini4[todayTopPlayers].secondSumma) then
			if ini4[todayTopPlayers].thirdName ~= ini6[todayPlayer].nick then
				ini4[todayTopPlayers].thirdSumma = ini6[todayPlayer].money
				ini4[todayTopPlayers].thirdName = nickname
			else
				ini4[todayTopPlayers].thirdSumma = ini6[todayPlayer].money
			end
		end
		inicfg.save(ini4, directIni4)
		
		-- TOP DONAT --
		
		if tonumber(ini5[Player].money) >= tonumber(ini3[TopPlayers].firstSumma) then
			if ini3[TopPlayers].firstName ~= ini5[Player].nick then
				if ini3[TopPlayers].secondName ~= ini5[Player].nick then
					ini3[TopPlayers].thirdSumma = ini3[TopPlayers].secondSumma
					ini3[TopPlayers].secondSumma = ini3[TopPlayers].firstSumma
					ini3[TopPlayers].thirdName = ini3[TopPlayers].secondName
					ini3[TopPlayers].secondName = ini3[TopPlayers].firstName
					ini3[TopPlayers].firstSumma = ini5[Player].money
					ini3[TopPlayers].firstName = nickname
				else
					ini3[TopPlayers].secondName = ini3[TopPlayers].firstName
					ini3[TopPlayers].secondSumma = ini3[TopPlayers].firstSumma
					ini3[TopPlayers].firstSumma = ini5[Player].money
					ini3[TopPlayers].firstName = nickname
				end
			else
				ini3[TopPlayers].firstSumma = ini5[Player].money
			end
		end
		if tonumber(ini5[Player].money) >= tonumber(ini3[TopPlayers].secondSumma) and tonumber(ini5[Player].money) < tonumber(ini3[TopPlayers].firstSumma) then
			if ini3[TopPlayers].secondName ~= ini5[Player].nick then
				ini3[TopPlayers].thirdSumma = ini3[TopPlayers].secondSumma
				ini3[TopPlayers].thirdName = ini3[TopPlayers].secondName
				ini3[TopPlayers].secondSumma = ini5[Player].money
				ini3[TopPlayers].secondName = nickname
			else
				ini3[TopPlayers].secondSumma = ini5[Player].money
			end
		end
		if tonumber(ini5[Player].money) >= tonumber(ini3[TopPlayers].thirdSumma) and tonumber(ini5[Player].money) < tonumber(ini3[TopPlayers].secondSumma) then
			if ini3[TopPlayers].thirdName ~= ini5[Player].nick then
				ini3[TopPlayers].thirdSumma = ini5[Player].money
				ini3[TopPlayers].thirdName = nickname
			else
				ini3[TopPlayers].thirdSumma = ini5[Player].money
			end
		end
		inicfg.save(ini3, directIni3)
		return false
	end
end

function sampev.onSendCommand(cmd)
	local args = {}

	for arg in cmd:gmatch("%S+") do
		table.insert(args, arg)
	end

	if args[1] == '/donater' then
		if args[2] then
			if args[3] then
			
				tempSumma = ini8[DonateMoneyZiel].money
				
				ini1[DonateMoney].money = ini1[DonateMoney].money + args[3]
				inicfg.save(ini1, directIni1)
				
				ini2[todayDonateMoney].money = ini2[todayDonateMoney].money + args[3]
				inicfg.save(ini2, directIni2)
				
				ini8[DonateMoneyZiel].money = ini8[DonateMoneyZiel].money + args[3]
				inicfg.save(ini8, directIni8)
				
				if ini9[settings].TargetNotify then
					if tempSumma < ini8[DonateMoneyZiel].target / 4 and ini8[DonateMoneyZiel].money >= ini8[DonateMoneyZiel].target / 4 then
						sampAddChatMessage(u8:decode" [Donatik] {FF0000}На цель накоплено 25 процентов!", main_color)
					end
					
					if tempSumma < ini8[DonateMoneyZiel].target / 2 and ini8[DonateMoneyZiel].money >= ini8[DonateMoneyZiel].target / 2 then
						sampAddChatMessage(u8:decode" [Donatik] {FF0000}На цель накоплено 50 процентов!", main_color)
					end
					
					if tempSumma < ini8[DonateMoneyZiel].target / 4 * 3 and ini8[DonateMoneyZiel].money >= ini8[DonateMoneyZiel].target / 4 * 3 then
						sampAddChatMessage(u8:decode" [Donatik] {FF0000}На цель накоплено 75 процентов!", main_color)
					end
					
					if tempSumma < ini8[DonateMoneyZiel].target and ini8[DonateMoneyZiel].money >= ini8[DonateMoneyZiel].target then
						sampAddChatMessage(u8:decode" [Donatik] {FF0000}Цель достигнута!!!", main_color)
					end
				end
			
				Player = string.format('%s', args[2])
				if ini5[Player] ~= nil then
					ini5[Player].money = ini5[Player].money + args[3]
					sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Сумма пожертвований от {40E0D0}" .. args[2] .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ini5[Player].money, main_color)
				else
					ini5 = inicfg.load({
						[Player] = {
							nick = tostring(args[2]),
							money = tonumber(args[3])
						}
					}, directIni5)
					sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Господин {40E0D0}" .. args[2] .. u8:decode"{FFFFFF} был добавлен с базу данных" , main_color)
					sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Сумма пожертвований от {40E0D0}" .. args[2] .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. args[3], main_color)
					ini1[DonateMoney].count = ini1[DonateMoney].count + 1
					inicfg.save(ini1, directIni1)
				end
				inicfg.save(ini5, directIni5)
				
				PlayerZiel = string.format('%s', args[2])
				if ini7[PlayerZiel] == nil then
					ini7 = inicfg.load({
						[PlayerZiel] = {
							nick = tostring(args[2]),
							money = tonumber(args[3])
						}
					}, directIni7)
				else
					ini7[PlayerZiel].money = ini7[PlayerZiel].money + args[3]
				end
				inicfg.save(ini7, directIni7)
				
				todayPlayer = string.format('%s-%s-%s-%s', my_day, my_month, my_year, args[2])
				if ini6[todayPlayer] == nil then
					ini6 = inicfg.load({
						[todayPlayer] = {
							nick = tostring(args[2]),
							money = tonumber(args[3])
						}
					}, directIni6)
					ini2[todayDonateMoney].count = ini2[todayDonateMoney].count + 1
					inicfg.save(ini2, directIni2)
					sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Сумма пожертвований за сегодня от {40E0D0}" .. args[2] .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ini6[todayPlayer].money, main_color)
				else
					ini6[todayPlayer].money = ini6[todayPlayer].money + args[3]
					sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Сумма пожертвований за сегодня от {40E0D0}" .. args[2] .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ini6[todayPlayer].money, main_color)
				end
				inicfg.save(ini6, directIni6)
				
				-- TODAY DONAT --
				
				if tonumber(args[3]) >= tonumber(0) then
					if tonumber(ini6[todayPlayer].money) >= tonumber(ini4[todayTopPlayers].firstSumma) then
						if ini4[todayTopPlayers].firstName ~= ini6[todayPlayer].nick then
							if ini4[todayTopPlayers].secondName ~= ini6[todayPlayer].nick then
								ini4[todayTopPlayers].thirdSumma = ini4[todayTopPlayers].secondSumma
								ini4[todayTopPlayers].secondSumma = ini4[todayTopPlayers].firstSumma
								ini4[todayTopPlayers].thirdName = ini4[todayTopPlayers].secondName
								ini4[todayTopPlayers].secondName = ini4[todayTopPlayers].firstName
								ini4[todayTopPlayers].firstSumma = ini6[todayPlayer].money
								ini4[todayTopPlayers].firstName = ini6[todayPlayer].nick
							else
								ini4[todayTopPlayers].secondName = ini4[todayTopPlayers].firstName
								ini4[todayTopPlayers].secondSumma = ini4[todayTopPlayers].firstSumma
								ini4[todayTopPlayers].firstSumma = ini6[todayPlayer].money
								ini4[todayTopPlayers].firstName = ini6[todayPlayer].nick
							end
						else
							ini4[todayTopPlayers].firstSumma = ini6[todayPlayer].money
						end
					end
					if tonumber(ini6[todayPlayer].money) >= tonumber(ini4[todayTopPlayers].secondSumma) and tonumber(ini6[todayPlayer].money) < tonumber(ini4[todayTopPlayers].firstSumma) then
						if ini4[todayTopPlayers].secondName ~= ini6[todayPlayer].nick then
							ini4[todayTopPlayers].thirdSumma = ini4[todayTopPlayers].secondSumma
							ini4[todayTopPlayers].thirdName = ini4[todayTopPlayers].secondName
							ini4[todayTopPlayers].secondSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].secondName = args[2]
						else
							ini4[todayTopPlayers].secondSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].secondName = ini6[todayPlayer].nick
						end
					end
					if tonumber(ini6[todayPlayer].money) >= tonumber(ini4[todayTopPlayers].thirdSumma) and tonumber(ini6[todayPlayer].money) < tonumber(ini4[todayTopPlayers].secondSumma) then
						if ini4[todayTopPlayers].thirdName ~= ini6[todayPlayer].nick then
							ini4[todayTopPlayers].thirdSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].thirdName = args[2]
						else
							ini4[todayTopPlayers].thirdSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].thirdName = ini6[todayPlayer].nick
						end
					end
					inicfg.save(ini4, directIni4)
					
					-- TOP DONAT --
					
					if tonumber(ini5[Player].money) >= tonumber(ini3[TopPlayers].firstSumma) then
						if ini3[TopPlayers].firstName ~= ini5[Player].nick then
							if ini3[TopPlayers].secondName ~= ini5[Player].nick then
								ini3[TopPlayers].thirdSumma = ini3[TopPlayers].secondSumma
								ini3[TopPlayers].secondSumma = ini3[TopPlayers].firstSumma
								ini3[TopPlayers].thirdName = ini3[TopPlayers].secondName
								ini3[TopPlayers].secondName = ini3[TopPlayers].firstName
								ini3[TopPlayers].firstSumma = ini5[Player].money
								ini3[TopPlayers].firstName = args[2]
							else
								ini3[TopPlayers].secondName = ini3[TopPlayers].firstName
								ini3[TopPlayers].secondSumma = ini3[TopPlayers].firstSumma
								ini3[TopPlayers].firstSumma = ini5[Player].money
								ini3[TopPlayers].firstName = args[2]
							end
						else
							ini3[TopPlayers].firstSumma = ini5[Player].money
						end
					end
					if tonumber(ini5[Player].money) >= tonumber(ini3[TopPlayers].secondSumma) and tonumber(ini5[Player].money) < tonumber(ini3[TopPlayers].firstSumma) then
						if ini3[TopPlayers].secondName ~= ini5[Player].nick then
							ini3[TopPlayers].thirdSumma = ini3[TopPlayers].secondSumma
							ini3[TopPlayers].thirdName = ini3[TopPlayers].secondName
							ini3[TopPlayers].secondSumma = ini5[Player].money
							ini3[TopPlayers].secondName = args[2]
						else
							ini3[TopPlayers].secondSumma = ini5[Player].money
						end
					end
					if tonumber(ini5[Player].money) >= tonumber(ini3[TopPlayers].thirdSumma) and tonumber(ini5[Player].money) < tonumber(ini3[TopPlayers].secondSumma) then
						if ini3[TopPlayers].thirdName ~= ini5[Player].nick then
							ini3[TopPlayers].thirdSumma = ini5[Player].money
							ini3[TopPlayers].thirdName = args[2]
						else
							ini3[TopPlayers].thirdSumma = ini5[Player].money
						end
					end
					inicfg.save(ini3, directIni3)
				else -- IF ARGS[3] < 0 THEN --
					if tonumber(ini6[todayPlayer].money) <= tonumber(ini4[todayTopPlayers].firstSumma) and tonumber(ini6[todayPlayer].money) >= tonumber(ini4[todayTopPlayers].secondSumma) then
						ini4[todayTopPlayers].firstSumma = ini6[todayPlayer].money
						ini4[todayTopPlayers].firstName = ini6[todayPlayer].nick
					end 
					if tonumber(ini6[todayPlayer].money) <= tonumber(ini4[todayTopPlayers].secondSumma) and tonumber(ini6[todayPlayer].money) > tonumber(ini4[todayTopPlayers].thirdSumma) then 
						if ini4[todayTopPlayers].firstName == ini6[todayPlayer].nick then
							ini4[todayTopPlayers].firstSumma = ini4[todayTopPlayers].secondSumma
							ini4[todayTopPlayers].firstName = ini4[todayTopPlayers].secondName
							ini4[todayTopPlayers].secondSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].secondName = ini6[todayPlayer].nick
						end
						if ini4[todayTopPlayers].secondName == ini6[todayPlayer].nick then
							ini4[todayTopPlayers].secondSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].secondName = ini6[todayPlayer].nick
						end
					end 
					if tonumber(ini6[todayPlayer].money) <= tonumber(ini4[todayTopPlayers].thirdSumma) then
						if ini4[todayTopPlayers].firstName == ini6[todayPlayer].nick then
							ini4[todayTopPlayers].firstSumma = ini4[todayTopPlayers].secondSumma
							ini4[todayTopPlayers].firstName = ini4[todayTopPlayers].secondName
							ini4[todayTopPlayers].secondSumma = ini4[todayTopPlayers].thirdSumma
							ini4[todayTopPlayers].secondName = ini4[todayTopPlayers].thirdName
							ini4[todayTopPlayers].thirdSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].thirdName = ini6[todayPlayer].nick
						end
						if ini4[todayTopPlayers].secondName == ini6[todayPlayer].nick then
							ini4[todayTopPlayers].secondSumma = ini4[todayTopPlayers].thirdSumma
							ini4[todayTopPlayers].secondName = ini4[todayTopPlayers].thirdName
							ini4[todayTopPlayers].thirdSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].thirdName = ini6[todayPlayer].nick
						end
						if ini4[todayTopPlayers].thirdName == ini6[todayPlayer].nick then
							ini4[todayTopPlayers].thirdSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].thirdName = ini6[todayPlayer].nick
						end
					end
					inicfg.save(ini4, directIni4)
					
					-- TOP DONAT --
					
					if tonumber(ini5[Player].money) <= tonumber(ini3[TopPlayers].firstSumma) and tonumber(ini5[Player].money) >= tonumber(ini3[TopPlayers].secondSumma) then
						ini3[TopPlayers].firstSumma = ini5[Player].money
						ini3[TopPlayers].firstName = ini5[Player].nick
					end 
					if tonumber(ini5[Player].money) <= tonumber(ini3[TopPlayers].secondSumma) and tonumber(ini5[Player].money) > tonumber(ini3[TopPlayers].thirdSumma) then 
						if ini3[TopPlayers].firstName == ini5[Player].nick then
							ini3[TopPlayers].firstSumma = ini3[TopPlayers].secondSumma
							ini3[TopPlayers].firstName = ini3[TopPlayers].secondName
							ini3[TopPlayers].secondSumma = ini5[Player].money
							ini3[TopPlayers].secondName = ini5[Player].nick
						end
						if ini3[TopPlayers].secondName == ini5[Player].nick then
							ini3[TopPlayers].secondSumma = ini5[Player].money
							ini3[TopPlayers].secondName = ini5[Player].nick
						end
					end 
					if tonumber(ini5[Player].money) <= tonumber(ini3[TopPlayers].thirdSumma) then
						if ini3[TopPlayers].firstName == ini5[Player].nick then
							ini3[TopPlayers].firstSumma = ini3[TopPlayers].secondSumma
							ini3[TopPlayers].firstName = ini3[TopPlayers].secondName
							ini3[TopPlayers].secondSumma = ini3[TopPlayers].thirdSumma
							ini3[TopPlayers].secondName = ini3[TopPlayers].thirdName
							ini3[TopPlayers].thirdSumma = ini5[Player].money
							ini3[TopPlayers].thirdName = ini5[Player].nick
						end
						if ini3[TopPlayers].secondName == ini5[Player].nick then
							ini3[TopPlayers].secondSumma = ini3[TopPlayers].thirdSumma
							ini3[TopPlayers].secondName = ini3[TopPlayers].thirdName
							ini3[TopPlayers].thirdSumma = ini5[Player].money
							ini3[TopPlayers].thirdName = ini5[Player].nick
						end
						if ini3[TopPlayers].thirdName == ini5[Player].nick then
							ini3[TopPlayers].thirdSumma = ini5[Player].money
							ini3[TopPlayers].thirdName = ini5[Player].nick
						end
					end
					inicfg.save(ini3, directIni3)
				end
			end
		end
	end
	
	if args[1] == '/dziel' then
		if args[2] then
			if args[3] then
				ini1[DonateMoney].zielName = args[2]
				ini1[DonateMoney].target = args[3]
				inicfg.save(ini1, directIni1)
				sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Новая цель: {40E0D0}" .. args[2] .. u8:decode"{FFFFFF} с суммой {40E0D0}" .. args[3], main_color)
				thisScript():reload()
			end
		end
	end
end

function imgui.OnDrawFrame()
	if ini1[DonateMoney].hud then
		imgui.SetNextWindowPos(vec(498, 134))
		imgui.SetNextWindowSize(vec(83, 8))
		ini1 = inicfg.load(DonateMoney, directIni1)
		imgui.Begin("Donaterka", _,  imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove)
		imgui.BufferingBar(percent, vec(83, 8), false)
		imgui.End()
	end
	if main_window_state.v then
		imgui.SetNextWindowPos(vec(225, 125))
		imgui.SetNextWindowSize(vec(187, 240))
		imgui.ShowCursor = true
		imgui.Begin("Donatik", main_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		
		imgui.BeginChild('top', vec(210, 9), false)
		imgui.BeginChild("##inp101", vec(59, 9), false)
			if imgui.Selectable('		     Функции', imgui.settingsTab == 1) then
				imgui.settingsTab = 1
			end
			imgui.EndChild()
			imgui.SameLine()
			imgui.BeginChild("##inp102",vec(59, 9), false)
			if imgui.Selectable('		    Параметры', imgui.settingsTab == 2) then
				imgui.settingsTab = 2
			end
			imgui.EndChild()
			imgui.SameLine()
			imgui.BeginChild("##inp103",vec(59, 9), false)
			if imgui.Selectable('		 Информация', imgui.settingsTab == 3) then
				imgui.settingsTab = 3
			end
			imgui.EndChild()
		imgui.EndChild()
		
		imgui.BeginChild('bottom', vec(181, 210), true)
		if imgui.settingsTab == 1 then
		
			if imgui.Button("Топ донатеры за день", vec(175/2, 10)) then
				cmd_donaters()
			end
			imgui.SameLine()
			if imgui.Button("Топ донатеры за всё время", vec(175/2, 10)) then
				cmd_topdonaters()
			end
			if imgui.Button("Денег за сегодня собрано", vec(175/2, 10)) then
				cmd_todayDonateMoney()
			end
			imgui.SameLine()
			if imgui.Button("Денег за все время собрано", vec(175/2, 10)) then
				cmd_DonateMoney()
			end
			imgui.PushItemWidth(toScreenX(175/3))
			imgui.InputText("##inp1", text_buffer_nick)
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.PushItemWidth(toScreenX(175/3))
			imgui.InputText("##inp2", text_buffer_summa)
			imgui.PopItemWidth()
			imgui.SameLine()
			if imgui.Button("Добавить донатера", vec(175/3, 10)) then
				if text_buffer_nick.v ~= nil and text_buffer_nick.v ~= "" and text_buffer_summa.v ~= nil and text_buffer_summa.v ~= "" and isNumber(text_buffer_summa.v) then
					sampSendChat("/donater " .. text_buffer_nick.v .. " " .. text_buffer_summa.v)
				else
					sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Ошибка. Введите в первое поле ник игрока, во второе сумму", main_color)
				end
			end
			
			imgui.PushItemWidth(toScreenX(175/3))
			imgui.InputText("##inp3", text_buffer_name)
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.PushItemWidth(toScreenX(175/3))
			imgui.InputText("##inp4", text_buffer_target)
			imgui.PopItemWidth()
			imgui.SameLine()
			if imgui.Button("Установить цель", vec(175/3, 10)) then
				if text_buffer_name.v ~= nil and text_buffer_name.v ~= "" and text_buffer_target.v ~= nil and text_buffer_target.v ~= "" and isNumber(text_buffer_target.v) then
					sampSendChat("/dziel " .. text_buffer_name.v .. " " .. text_buffer_target.v)
				else
					sampAddChatMessage(u8:decode" [Donatik] {FFFFFF}Ошибка. Введите в первое поле название цели, во второе сумму", main_color)
				end
			end
			if imgui.Button("Отображение HUDa", vec(177, 10)) then
				cmd_hud()
			end
			imgui.BufferingBar(percent, vec(180, 10), false)
			
			imgui.Dummy(vec(0, 2.5))
			imgui.BeginChild("AA2", vec(175, 60), true)
			imgui.Columns(1, "Title1", true)
			imgui.Text("За все время:  ".. ini1[DonateMoney].money .. " вирт от " .. ini1[DonateMoney].count .. " игроков")
			imgui.Separator()
			imgui.Columns(3, "Columns2", true)
			imgui.Text("")
			imgui.NextColumn()
			imgui.Text("Имя")
			imgui.NextColumn()
			imgui.Text("Денег")
			imgui.NextColumn()
			imgui.Separator()
			imgui.Text("Господин 1")
			imgui.NextColumn()
			imgui.Text(u8(ini3[TopPlayers].firstName))
			imgui.NextColumn()
			imgui.Text("" .. ini3[TopPlayers].firstSumma)
			imgui.NextColumn()
			imgui.Separator()
			imgui.Text("Господин 2")
			imgui.NextColumn()
			imgui.Text(u8(ini3[TopPlayers].secondName))
			imgui.NextColumn()
			imgui.Text("" .. ini3[TopPlayers].secondSumma)
			imgui.NextColumn()
			imgui.Separator()
			imgui.Text("Господин 3")
			imgui.NextColumn()
			imgui.Text(u8(ini3[TopPlayers].thirdName))
			imgui.NextColumn()
			imgui.Text("" .. ini3[TopPlayers].thirdSumma)
			imgui.EndChild()
			
			imgui.Dummy(vec(0, 2.5))
			imgui.BeginChild("AA", vec(175, 60), true)
			imgui.Columns(1, "Title2", true)
			imgui.Text("За сегодня:  ".. ini2[todayDonateMoney].money .. " вирт от " .. ini2[todayDonateMoney].count .. " игроков")
			imgui.Separator()
			imgui.Columns(3, "Columns", true)
			imgui.Text("")
			imgui.NextColumn()
			imgui.Text("Имя")
			imgui.NextColumn()
			imgui.Text("Денег")
			imgui.NextColumn()
			imgui.Separator()
			imgui.Text("Господин 1")
			imgui.NextColumn()
			imgui.Text(u8(ini4[todayTopPlayers].firstName))
			imgui.NextColumn()
			imgui.Text("" .. ini4[todayTopPlayers].firstSumma)
			imgui.NextColumn()
			imgui.Separator()
			imgui.Text("Господин 2")
			imgui.NextColumn()
			imgui.Text(u8(ini4[todayTopPlayers].secondName))
			imgui.NextColumn()
			imgui.Text("" .. ini4[todayTopPlayers].secondSumma)
			imgui.NextColumn()
			imgui.Separator()
			imgui.Text("Господин 3")
			imgui.NextColumn()
			imgui.Text(u8(ini4[todayTopPlayers].thirdName))
			imgui.NextColumn()
			imgui.Text("" .. ini4[todayTopPlayers].thirdSumma)
			imgui.EndChild()
		
		elseif imgui.settingsTab == 2 then
		
			if imgui.HotKey("##1", ActiveDonaters, tLastKeys, 100) then
				rkeys.changeHotKey(bindDonaters, ActiveDonaters.v)

				ini9.hotkey.bindDonaters = encodeJson(ActiveDonaters.v)
				inicfg.save(ini9, directIni9)
			end
			imgui.SameLine()
			imgui.Text("Вывести список донатеров в чат")

			if imgui.HotKey("##2", ActiveTopDonaters, tLastKeys, 100) then
				rkeys.changeHotKey(bindTopDonaters, ActiveTopDonaters.v)

				ini9.hotkey.bindTopDonaters = encodeJson(ActiveTopDonaters.v)
				inicfg.save(ini9, directIni9)
			end
			imgui.SameLine()
			imgui.Text("Вывести список топ донатеров в чат")
			
			if imgui.HotKey("##3", ActiveDonateMoney, tLastKeys, 100) then
				rkeys.changeHotKey(bindDonateMoney, ActiveDonateMoney.v)

				ini9.hotkey.bindDonateMoney = encodeJson(ActiveDonateMoney.v)
				inicfg.save(ini9, directIni9)
			end
			imgui.SameLine()
			imgui.Text("Вывести собранные деньги за все время в чат")

			if imgui.HotKey("##4", ActiveDonateMoneyZiel, tLastKeys, 100) then
				rkeys.changeHotKey(bindDonateMoneyZiel, ActiveDonateMoneyZiel.v)

				ini9.hotkey.bindDonateMoneyZiel = encodeJson(ActiveDonateMoneyZiel.v)
				inicfg.save(ini9, directIni9)
			end
			imgui.SameLine()
			imgui.Text("Вывести собранные деньги на цель чат")
			
			if imgui.HotKey("##5", ActiveHud, tLastKeys, 100) then
				rkeys.changeHotKey(bindHud, ActiveHud.v)

				ini9.hotkey.bindHud = encodeJson(ActiveHud.v)
				inicfg.save(ini9, directIni9)
			end
			imgui.SameLine()
			imgui.Text("Включить/выключить HUD")
			
			imgui.Text(u8" ")
			
			if imgui.Checkbox("Уведомления о донатах от игрока за все время ", imgui.ImBool(ini9.settings.DonatersNotify)) then
				ini9.settings.DonatersNotify = not ini9.settings.DonatersNotify
				inicfg.save(ini9, directIni9)
			end
			
			if imgui.Checkbox("Уведомления о донатах от игрока за сегодня ", imgui.ImBool(ini9.settings.TodayDonatersNotify)) then
				ini9.settings.DonatersNotify = not ini9.settings.DonatersNotify
				inicfg.save(ini9, directIni9)
			end
			
			if imgui.Checkbox("Уведомления о донатах ", imgui.ImBool(ini9.settings.DonateNotify)) then
				ini9.settings.DonatersNotify = not ini9.settings.DonatersNotify
				inicfg.save(ini9, directIni9)
			end
			
			if imgui.Checkbox("Уведомления о цели", imgui.ImBool(ini9.settings.TargetNotify)) then
				ini9.settings.TargetNotify = not ini9.settings.TargetNotify
				inicfg.save(ini9, directIni9)
			end
			
			if imgui.Checkbox("Звук донатов ", imgui.ImBool(ini9.settings.Sound)) then
				ini9.settings.Sound = not ini9.settings.Sound
				inicfg.save(ini9, directIni9)
			end
			
		else
			if script.update then
				if imgui.Button("Обновить скрипт", vec(174, 0)) then
					imgui.Process = false
					update()
				end
			else
				imgui.Text("Актуальная версия скрипта")
			end
			if imgui.Button("Перезагрузить скрипт", vec(174, 0)) then
				thisScript():reload()
			end
			
			imgui.Text("Страничка Владика:")
			imgui.SameLine()
			if imgui.Button("VK") then
				os.execute("start https://vk.com/vlaeek")
			end

			imgui.SetCursorPos(vec(5, 80))
			imgui.Text("Список команд:")
			imgui.BeginChild('List', vec(174, 90), true)
				imgui.Text("/dHud - включить главное меню скрипта")
				imgui.Text("/dHudik - включить Donatik HUD")
				imgui.Text("/donater [Ник игрока] [Количество денег]")
				imgui.Text("/dZiel [Название цели] [Количество денег]")
				imgui.Text("/donaters - вывести список донатеров за сегодня")
				imgui.Text("/topDonaters - вывести список топ донатеров за все время")
				imgui.Text("/donateMoney - вывести накопленные деньги за все время")
				imgui.Text("/donateMoney - вывести накопленные деньги для текущей цели")
				imgui.Text("/todayDonateMoney - вывести накопленные деньги за сегодня")
			imgui.EndChild()
		end
		imgui.EndChild()
		imgui.End()
	end
end

function imgui.initBuffers()
	imgui.settingsTab = 1
end

function isNumber(n)
    return type(tonumber(n)) == "number"
end

function imgui.ApplyCustomStyle()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

	colors[clr.FrameBg]                = ImVec4(0.48, 0.23, 0.16, 0.25)
	colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.43, 0.26, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.98, 0.43, 0.26, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.48, 0.23, 0.16, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.48, 0.23, 0.16, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.0, 0.00, 0.00, 0.75)
	colors[clr.CheckMark]              = ImVec4(0.98, 0.43, 0.26, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.88, 0.39, 0.24, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.43, 0.26, 1.00)
	colors[clr.Button]                 = ImVec4(0.98, 0.43, 0.26, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.98, 0.43, 0.26, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.98, 0.28, 0.06, 1.00)
	colors[clr.Header]                 = ImVec4(0.98, 0.43, 0.26, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.98, 0.43, 0.26, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.98, 0.43, 0.26, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.25, 0.10, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.75, 0.25, 0.10, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.98, 0.43, 0.26, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.43, 0.26, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.43, 0.26, 0.95)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.50, 0.35, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.43, 0.26, 0.35)
	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00) 
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 1.0)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function toScreenY(gY)
    local x, y = convertGameScreenCoordsToWindowScreenCoords(0, gY)
    return y
end

function toScreenX(gX)
    local x, y = convertGameScreenCoordsToWindowScreenCoords(gX, 0)
    return x
end

function toScreen(gX, gY)
    local s = {}
    s.x, s.y = convertGameScreenCoordsToWindowScreenCoords(gX, gY)
    return s
end

function vec(gX, gY)
    return imgui.ImVec2(convertGameScreenCoordsToWindowScreenCoords(gX, gY))
end

function checkUpdates()
	local fpath = os.tmpname()
	if doesFileExist(fpath) then os.remove(fpath) end
	downloadUrlToFile("https://raw.githubusercontent.com/Vlaek/Donatik/master/version.json", fpath, function(_, status, _, _)
		if status == 58 then
			if doesFileExist(fpath) then
				local file = io.open(fpath, 'r')
				if file then
					local info = decodeJson(file:read('*a'))
					file:close()
					os.remove(fpath)
					if info['version_num'] > thisScript()['version_num'] then
						sampAddChatMessage(u8:decode' [Donatik] {FFFFFF}Доступна новая версия скрипта! /dhud > Информация > Обновить скрипт', main_color)
						script.update = true
					return true
					end
				end
			end
		end
	end)
end

function update()
	downloadUrlToFile("https://raw.githubusercontent.com/Vlaek/Donatik/master/Donatik.lua", thisScript().path, function(_, status, _, _)
		if status == 6 then
			sampAddChatMessage(u8:decode' [Donatik] {FFFFFF}Скрипт обновлён!', main_color)
			thisScript():reload()
		end
	end)
end

soundManager = {}
soundManager.soundsList = {}

function soundManager.loadSound(soundName)
	soundManager.soundsList[soundName] = loadAudioStream(getWorkingDirectory()..'\\rsc\\'..soundName..'.mp3')
end

function soundManager.playSound(soundName)
	if soundManager.soundsList[soundName] then
		setAudioStreamVolume(soundManager.soundsList[soundName], 50/100)
		setAudioStreamState(soundManager.soundsList[soundName], as_action.PLAY)
	end
end
