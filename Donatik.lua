script_name("Donatik")
script_author("bier")
script_version("09.02.2022")
script_version_number(14)
script_url("https://vlaek.github.io/Donatik/")
script.update = false

local main_color = 0xFFFF00
local prefix = "{FFFF00} [" .. thisScript().name .. "] {FFFFFF}"

function try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end

try(function()
	sampev, inicfg, imgui, encoding, vkeys, rkeys =
	require "lib.samp.events",
	require "inicfg",
	require 'imgui',
	require 'encoding',
	require "vkeys",
	require 'rkeys'

	require "reload_all"
	require "lib.sampfuncs"
	require "lib.moonloader"
	
	as_action, themes = 
	require 'moonloader'.audiostream_state, 
	import "imgui_themes.lua"
	
	encoding.default = 'CP1251'
	u8 = encoding.UTF8

	end, function(e)
	sampAddChatMessage(prefix .. "An error occurred while loading libraries", main_color)
	thisScript():unload()
end)

local ini1, ini2, ini3, ini4, ini5, ini6, ini7, ini8, ini9, ini10, ini11, ini12 = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
local tLastKeys = {}
local tab = imgui.ImInt(1)
local main_window_state, help_window_state, diagram_window_state = imgui.ImBool(false), imgui.ImBool(false), imgui.ImBool(false)
local text_buffer_target, text_buffer_name, text_buffer_nick, text_buffer_summa = imgui.ImBuffer(256), imgui.ImBuffer(256), imgui.ImBuffer(256), imgui.ImBuffer(256)
local buffering_bar_position = true
local donaters_list_silder = imgui.ImInt(1)
local donaters_list = true

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
    repeat wait(0) until sampGetCurrentServerName() ~= "SA-MP"
    repeat wait(0) until sampGetCurrentServerName():find("Samp%-Rp.Ru") or sampGetCurrentServerName():find("SRP")
	
	server = sampGetCurrentServerName():gsub('|', '')
	server = (server:find('02') and 'Two' or (server:find('Revolution') and 'Revolution' or (server:find('Legacy') and 'Legacy' or (server:find('Classic') and 'Classic' or ''))))
	if server == '' then thisScript():unload() end
	
	local _, my_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	my_name = sampGetPlayerNickname(my_id)
	
	my_day   = os.date("%d")
	my_month = os.date("%m")
	my_year  = os.date("%Y")

	AdressConfig = string.format("%s\\moonloader\\config" , getGameDirectory())
	AdressFolder = string.format("%s\\moonloader\\config\\Donatik\\%s\\%s", getGameDirectory(), server, my_name)
	
	if not doesDirectoryExist(AdressConfig) then createDirectory(AdressConfig) end
	if not doesDirectoryExist(AdressFolder) then createDirectory(AdressFolder) end
	
	directIni1  = string.format("Donatik\\%s\\%s\\DonateMoney.ini", server, my_name)
	directIni2  = string.format("Donatik\\%s\\%s\\todayDonateMoney.ini", server, my_name)
	directIni3  = string.format("Donatik\\%s\\%s\\TopDonaters.ini", server, my_name)
	directIni4  = string.format("Donatik\\%s\\%s\\todayTopDonaters.ini", server, my_name)
	directIni5  = string.format("Donatik\\%s\\%s\\Donaters.ini", server, my_name)
	directIni6  = string.format("Donatik\\%s\\%s\\todayDonaters.ini", server, my_name)
	directIni9  = string.format("Donatik\\%s\\%s\\Settings.ini", server, my_name)
	directIni11 = string.format("Donatik\\%s\\%s\\DonatersRating.ini", server, my_name)
	
	chatManager.initQueue()
	lua_thread.create(chatManager.checkMessagesQueueThread)
	
	sampRegisterChatCommand('dHud', menu)								-- меню
	sampRegisterChatCommand("donaters", cmd_donaters)					-- список донатеров
	sampRegisterChatCommand("topdonaters", cmd_topDonaters)				-- список топ донатеров за все время
	sampRegisterChatCommand("topdonatersziel", cmd_topDonatersZiel)		-- список топ донатеров на цель за все время
	sampRegisterChatCommand("todayDonateMoney", cmd_todayDonateMoney)	-- заработанный деньги за сегодня
	sampRegisterChatCommand("DonateMoney", cmd_DonateMoney)				-- заработанные деньги за все время
	sampRegisterChatCommand("DonateMoneyZiel", cmd_DonateMoneyZiel)		-- заработанные деньги на цель за все время
	sampRegisterChatCommand("dHudik", cmd_hud)							-- полоска худа
	sampRegisterChatCommand("dtop", cmd_topN) 							-- топ донатеров до N
	sampRegisterChatCommand("dtopZiel", cmd_topZielN)					-- топ донатеров на цель до N

	DonateMoney = string.format('DonateMoney')
	if ini1[DonateMoney] == nil then
		ini1 = inicfg.load({
			[DonateMoney] = {
				money    = tonumber(0),
				count    = tonumber(0),
				target   = tonumber(1000000),
				hud      = false,
				zielName = "Untitled",
			}
		}, directIni1)
		inicfg.save(ini1, directIni1)
	end
	
	todayDonateMoney = string.format('%s-%s-%s', my_day, my_month, my_year)
	if ini2[todayDonateMoney] == nil then
		ini2 = inicfg.load({
			[todayDonateMoney] = {
				money = tonumber(0),
				count = tonumber(0)
			}
		}, directIni2)
		inicfg.save(ini2, directIni2)
	end	
	
	todayTopPlayers = string.format('%s-%s-%s', my_day, my_month, my_year)
	if ini4[todayTopPlayers] == nil then
		ini4 = inicfg.load({
			[todayTopPlayers] = {
				firstName   = u8:decode"Пусто",
				firstSumma  = tonumber(0),
				secondName  = u8:decode"Пусто",
				secondSumma = tonumber(0),
				thirdName   = u8:decode"Пусто",
				thirdSumma  = tonumber(0)
			}
		}, directIni4)
		inicfg.save(ini4, directIni4)
	end
	
	Player = string.format('%s', Niemand)
	if ini5[Player] == nil then
		ini5 = inicfg.load({
			[Player] = {
				nick  = tostring(Niemand),
				money = tonumber(0)
			}
		}, directIni5)
		inicfg.save(ini5, directIni5)
	end
	
	PlayerCount = string.format('Count')
	if ini11[PlayerCount] == nil then
		ini11 = inicfg.load({
			[PlayerCount] = {
				count = tonumber(0)
			}
		}, directIni11)
		inicfg.save(ini11, directIni11)
	end
	
	todayPlayer = string.format('%s-%s-%s-%s', my_day, my_month, my_year, Niemand)
	if ini6[todayPlayer] == nil then
		ini6 = inicfg.load({
			[todayPlayer] = {
				nick  = tostring(Niemand),
				money = tonumber(0)
			}
		}, directIni6)
		inicfg.save(ini6, directIni6)
	end
	
	settings = "Settings"
	MyStyle = "MyStyle"
	if ini9[settings] == nil then
		ini9 = inicfg.load({
			['Settings'] = {
				DonateNotify        = true,
				DonatersNotify      = true,
				TodayDonatersNotify = true,
				Sound               = false,
				x                   = tonumber(0),
				y                   = tonumber(0),
				themeId             = tonumber(0),
				Switch              = true,
				textLabel           = false,
				DonaterJoined       = false,
				donateSize          = tonumber(10000)
			},
			['HotKey'] = {
				bindDonaters		 = "[18,49]",
				bindTopDonaters		 = "[18,50]",
				bindTopDonatersZiel	 = "[18,51]",
				bindTodayDonateMoney = "[18,52]",
				bindDonateMoney 	 = "[18,53]",
				bindDonateMoneyZiel	 = "[18,54]",
				bindHud 		   	 = "[18,72]"
			},
			['MyStyle'] = {
				Text_R           = 1.00,
				Text_G           = 1.00,
				Text_B           = 1.00,
				Text_A           = 1.00,
				Button_R         = 0.98,
				Button_G         = 0.43,
				Button_B         = 0.26,
				Button_A         = 0.40,
				ButtonActive_R   = 0.98,
				ButtonActive_G   = 0.43,
				ButtonActive_B   = 0.26,
				ButtonActive_A   = 1.00,
				FrameBg_R        = 0.48,
				FrameBg_G        = 0.23,
				FrameBg_B        = 0.16,
				FrameBg_A        = 0.25,
				FrameBgHovered_R = 0.98,
				FrameBgHovered_G = 0.43,
				FrameBgHovered_B = 0.26,
				FrameBgHovered_A = 0.40,
				Title_R          = 0.48,
				Title_G          = 0.23,
				Title_B          = 0.16,
				Title_A          = 1.00,
				Separator_R      = 0.43,
				Separator_G      = 0.43,
				Separator_B      = 0.50,
				Separator_A      = 0.50,
				CheckMark_R      = 0.98,
				CheckMark_G      = 0.43,
				CheckMark_B      = 0.26,
				CheckMark_A      = 1.00,
				WindowBg_R       = 0.06,
				WindowBg_G       = 0.06,
				WindowBg_B       = 0.06,
				WindowBg_A       = 0.94
			}
		}, directIni9)
		inicfg.save(ini9, directIni9)
	end
	
	AdressFolderZiel = string.format("%s\\moonloader\\config\\Donatik\\%s\\%s\\%s", getGameDirectory(), server, my_name, ini1[DonateMoney].zielName)
	
	if not doesDirectoryExist(AdressFolderZiel) then createDirectory(AdressFolderZiel) end
	
	directIni7  = string.format("Donatik\\%s\\%s\\%s\\Donaters.ini", server, my_name, ini1[DonateMoney].zielName)
	directIni8  = string.format("Donatik\\%s\\%s\\%s\\DonateMoney.ini", server, my_name, ini1[DonateMoney].zielName)
	directIni10 = string.format("Donatik\\%s\\%s\\%s\\TopDonaters.ini", server, my_name, ini1[DonateMoney].zielName)
	directIni12 = string.format("Donatik\\%s\\%s\\%s\\DonatersRating.ini", server, my_name, ini1[DonateMoney].zielName)
	
	PlayerZiel = string.format('%s', Niemand)
	if ini7[PlayerZiel] == nil then
		ini7 = inicfg.load({
			[PlayerZiel] = {
				nick  = tostring(Niemand),
				money = tonumber(0)
			}
		}, directIni7)
		inicfg.save(ini7, directIni7)
	end
	
	PlayerZielCount = string.format('Count')
	if ini12[PlayerZielCount] == nil then
		ini12 = inicfg.load({
			[PlayerZielCount] = {
				count = tonumber(0)
			}
		}, directIni12)
		inicfg.save(ini12, directIni12)
	end
	
	DonateMoneyZiel = string.format('DonateMoneyZiel')
	if ini8[DonateMoneyZiel] == nil then
		ini8 = inicfg.load({
			[DonateMoneyZiel] = {
				money  = tonumber(0),
				target = ini1[DonateMoney].target,
				count  = tonumber(0)
			}
		}, directIni8)
		inicfg.save(ini8, directIni8)
	end
	
	imgui.GetIO().Fonts:AddFontFromFileTTF("C:/Windows/Fonts/arial.ttf", toScreenX(6), nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	imgui.Process = true
	
	imgui.SwitchContext()
	themes.SwitchColorTheme(ini9[settings].themeId,
		ini9[MyStyle].Text_R, ini9[MyStyle].Text_G, ini9[MyStyle].Text_B, ini9[MyStyle].Text_A,
		ini9[MyStyle].Button_R, ini9[MyStyle].Button_G, ini9[MyStyle].Button_B, ini9[MyStyle].Button_A,
		ini9[MyStyle].ButtonActive_R, ini9[MyStyle].ButtonActive_G, ini9[MyStyle].ButtonActive_B, ini9[MyStyle].ButtonActive_A,
		ini9[MyStyle].FrameBg_R, ini9[MyStyle].FrameBg_G, ini9[MyStyle].FrameBg_B, ini9[MyStyle].FrameBg_A,
		ini9[MyStyle].FrameBgHovered_R, ini9[MyStyle].FrameBgHovered_G, ini9[MyStyle].FrameBgHovered_B, ini9[MyStyle].FrameBgHovered_A,
		ini9[MyStyle].Title_R, ini9[MyStyle].Title_G, ini9[MyStyle].Title_B, ini9[MyStyle].Title_A,
		ini9[MyStyle].Separator_R, ini9[MyStyle].Separator_G, ini9[MyStyle].Separator_B, ini9[MyStyle].Separator_A,
		ini9[MyStyle].CheckMark_R, ini9[MyStyle].CheckMark_G, ini9[MyStyle].CheckMark_B, ini9[MyStyle].CheckMark_A,
		ini9[MyStyle].WindowBg_R, ini9[MyStyle].WindowBg_G, ini9[MyStyle].WindowBg_B, ini9[MyStyle].WindowBg_A)
			
	ini1  = inicfg.load(DonateMoney, directIni1)
	ini2  = inicfg.load(todayDonateMoney, directIni2)
	ini3  = inicfg.load(TopPlayers, directIni3)
	ini4  = inicfg.load(todayTopPlayers, directIni4)
	ini5  = inicfg.load(Donaters, directIni5)
	ini6  = inicfg.load(todayDonaters, directIni6)
	ini7  = inicfg.load(PlayerZiel, directIni7)
	ini8  = inicfg.load(DonateMoneyZiel, directIni8)
	ini9  = inicfg.load(settings, directIni9)
	ini10 = inicfg.load(TopPlayersZiel, directIni10)
	ini11 = inicfg.load(PlayerCount, directIni11)
	ini12 = inicfg.load(PlayerZielCount, directIni12)
	
	ActiveDonaters = {
		v = decodeJson(ini9['HotKey'].bindDonaters)
	}

	ActiveTopDonaters = {
		v = decodeJson(ini9['HotKey'].bindTopDonaters)
	}
	
	ActiveTopDonatersZiel = {
		v = decodeJson(ini9['HotKey'].bindTopDonatersZiel)
	}
	
	ActiveTodayDonateMoney = {
		v = decodeJson(ini9['HotKey'].bindTodayDonateMoney)
	}
	
	ActiveDonateMoney = {
		v = decodeJson(ini9['HotKey'].bindDonateMoney)
	}
	
	ActiveDonateMoneyZiel = {
		v = decodeJson(ini9['HotKey'].bindDonateMoneyZiel)
	}
	
	ActiveHud = {
		v = decodeJson(ini9['HotKey'].bindHud)
	}
	
	bindDonaters 		 = rkeys.registerHotKey(ActiveDonaters.v, 	  	  true, cmd_donaters)
	bindTopDonaters 	 = rkeys.registerHotKey(ActiveTopDonaters.v, 	  true, cmd_topDonaters)
	bindTopDonatersZiel  = rkeys.registerHotKey(ActiveTopDonatersZiel.v,  true, cmd_topDonatersZiel)
	bindTodayDonateMoney = rkeys.registerHotKey(ActiveTodayDonateMoney.v, true, cmd_todayDonateMoney)
	bindDonateMoney 	 = rkeys.registerHotKey(ActiveDonateMoney.v, 	  true, cmd_DonateMoney)
	bindDonateMoneyZiel  = rkeys.registerHotKey(ActiveDonateMoneyZiel.v,  true, cmd_DonateMoneyZiel)
	bindHud 			 = rkeys.registerHotKey(ActiveHud.v, 			  true, cmd_hud)
	
	imgui.initBuffers()
	
	soundManager.loadSound("100k")    -- AMAHASLA
	soundManager.loadSound("75k")     -- YANIX
	soundManager.loadSound("50k")     -- YANIX
	soundManager.loadSound("25k")     -- FAR CRY 3
	soundManager.loadSound("10k")     -- FAR CRY 3
	soundManager.loadSound("5k")      -- WKOLNIK
	soundManager.loadSound("1k")      -- WKOLNIK
	soundManager.loadSound("100")     -- PAPICH
	soundManager.loadSound("0")       -- PAPICH
	
	checkUpdates()
	
	percent = (tonumber(ini8[DonateMoneyZiel].money)/tonumber(ini8[DonateMoneyZiel].target))
	
	sampAddChatMessage(prefix .. u8:decode"Успешно загрузился!", main_color)
	
	if not ini9[settings].Switch then
		sampAddChatMessage(prefix .. u8:decode"Скрипт в данный момент выключен! Включить /dhud > Информация > Включить", main_color)
	end
	
	while true do
		wait(0)
		imgui.ShowCursor = false
		
		if isKeyJustPressed(VK_ESCAPE) and main_window_state.v then
			main_window_state.v = false
		end
		
		textLabelOverPlayerNickname()
		topDonaterJoined()
		
	end
end

local textlabel = {}

function textLabelOverPlayerNickname()
	if ini9[settings].textLabel then
		for i = 0, 1000 do 
			if sampIsPlayerConnected(i) then
				donaterNick = sampGetPlayerNickname(i)
				if ini5[donaterNick] ~= nil then
					if donaterNick == ini5[donaterNick].nick then
						if textlabel[i] == nil then
							textlabel[i] = sampCreate3dText(ConvertNumber(ini5[donaterNick].money) .. " [" .. donaterPlace(donaterNick) .. "]", 0xFFFFFF00, 0.0, 0.0, 0.35, 22, false, i, -1)
						end
					end
				end
			else
				if textlabel[i] ~= nil then
					sampDestroy3dText(textlabel[i])
					textlabel[i] = nil
				end
			end
		end
	else
		for i = 0, 1000 do
			if textlabel[i] ~= nil then
				sampDestroy3dText(textlabel[i])
				textlabel[i] = nil
			end
		end
	end
end

local donaterOnline = {}
local donaterNickInGame = {}

function topDonaterJoined()
	if ini9[settings].DonaterJoined then
		for i = 0, 1000 do 
			if sampIsPlayerConnected(i) and sampGetPlayerScore(i) ~= 0 then
				donaterNickInGame[i] = sampGetPlayerNickname(i)
				if ini5[donaterNickInGame[i]] ~= nil then
					if donaterNickInGame[i] == ini5[donaterNickInGame[i]].nick then
						if not donaterOnline[i] then
							if tonumber(ini5[donaterNickInGame[i]].money) >= tonumber(ini9[settings].donateSize) then
								sampAddChatMessage(prefix .. u8:decode"На сервер зашёл{40E0D0} " .. ini5[donaterNickInGame[i]].nick .. " [" .. i .. "]", main_color)
								donaterOnline[i] = true
							end
						end
					end
				end
			else
				if donaterOnline[i] then
					sampAddChatMessage(prefix .. u8:decode"С сервера вышел{40E0D0} " .. donaterNickInGame[i], main_color)
					donaterOnline[i] = false
					donaterNickInGame[i] = nil
				end
			end
		end
	end
end

function restartTextLabelOverPlayerNickname()
	for i = 0, 1000 do
		if textlabel[i] ~= nil then
			sampDestroy3dText(textlabel[i])
			textlabel[i] = nil
		end
	end
	for i = 0, 1000 do 
		if sampIsPlayerConnected(i) then
			donaterNick = sampGetPlayerNickname(i)
			if ini5[donaterNick] ~= nil then
				if donaterNick == ini5[donaterNick].nick then
					if textlabel[i] == nil then
						textlabel[i] = sampCreate3dText(ConvertNumber(ini5[donaterNick].money) .. " [" .. donaterPlace(donaterNick) .. "]", 0xFFFFFF00, 0.0, 0.0, 0.35, 22, false, i, -1)
					end
				end
			end
		else
			if textlabel[i] ~= nil then
				sampDestroy3dText(textlabel[i])
				textlabel[i] = nil
			end
		end
	end
end

function donatersRating()
	local tempDonaterMoney, tempDonaterNick
	for i = 1, tonumber(ini11[PlayerCount].count) do
		for j = 0, tonumber(ini11[PlayerCount].count) - i do
			if ini11[j] ~= nil and ini11[j + 1] ~= nil then
				if tonumber(ini11[j].money) < tonumber(ini11[j + 1].money) then
					tempDonaterMoney = ini11[j].money
					ini11[j].money = ini11[j + 1].money
					ini11[j + 1].money = tempDonaterMoney

					tempDonaterNick = ini11[j].nick
					ini11[j].nick = ini11[j + 1].nick
					ini11[j + 1].nick = tempDonaterNick
				end
			end
		end
	end
	inicfg.save(ini11, directIni11)
end

function donatersZielRating()
	local tempDonaterZielMoney, tempDonaterZielNick
	for i = 1, tonumber(ini12[PlayerZielCount].count) do
		for j = 0, tonumber(ini12[PlayerZielCount].count) - i do
			if ini12[j] ~= nil and ini12[j + 1] ~= nil then
				if tonumber(ini12[j].money) < tonumber(ini12[j + 1].money) then
					tempDonaterZielMoney = ini12[j].money
					ini12[j].money = ini12[j + 1].money
					ini12[j + 1].money = tempDonaterZielMoney
					
					tempDonaterZielNick = ini12[j].nick
					ini12[j].nick = ini12[j + 1].nick
					ini12[j + 1].nick = tempDonaterZielNick
				end
			end
		end
	end
	inicfg.save(ini12, directIni12)
end

function donaterPlace(nickname)
	for i = 0, tonumber(ini11[PlayerCount].count) do
		if ini11[i] ~= nil then
			if ini11[i].nick == nickname then
				return i
			end
		end
	end
end

function donaterZielPlace(nickname)
	for i = 0, tonumber(ini12[PlayerZielCount].count) do
		if ini12[i] ~= nil then
			if ini12[i].nick == nickname then
				return i
			end
		end
	end
end

function menu()
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
end

function cmd_hud()
	ini1[DonateMoney].hud = not ini1[DonateMoney].hud
	sampAddChatMessage(prefix .. u8:decode"Отображение HUDa: {40E0D0}" .. (ini1[DonateMoney].hud and '{06940f}ON' or '{d10000}OFF'), main_color)
	inicfg.save(ini1, directIni1)
end

function cmd_target(arg)
	ini1[DonateMoney].target = tonumber(arg)
	inicfg.save(ini1, directIni1)
	ini8[DonateMoneyZiel].target = tonumber(arg)
	inicfg.save(ini8, directIni8)
	sampAddChatMessage(prefix .. u8:decode"Установлена новая цель: {40E0D0}" .. ini1[DonateMoney].target, main_color)
end

function cmd_donaters()
	chatManager.addMessageToQueue("Список пожертвований от уважаемых людей за сегодня: ", false)
	chatManager.addMessageToQueue("1. Господин " .. u8(ini4[todayTopPlayers].firstName)  .. " с суммой " .. ConvertNumber(ini4[todayTopPlayers].firstSumma)  .. " вирт", false)
	chatManager.addMessageToQueue("2. Господин " .. u8(ini4[todayTopPlayers].secondName) .. " с суммой " .. ConvertNumber(ini4[todayTopPlayers].secondSumma) .. " вирт", false)
	chatManager.addMessageToQueue("3. Господин " .. u8(ini4[todayTopPlayers].thirdName)  .. " с суммой " .. ConvertNumber(ini4[todayTopPlayers].thirdSumma)  .. " вирт", false)
	chatManager.addMessageToQueue("Чтобы занять определенное место в списке, необходимо пожертвовать больше денег", false)
end

function cmd_topDonaters()
	chatManager.addMessageToQueue("Список пожертвований от уважаемых людей за все время: ", false)
	for i = 1, 3 do
		ini11 = inicfg.load(i, directIni11)
		if ini11[i] ~= nil then
			chatManager.addMessageToQueue(i .. ". Господин " .. ini11[i].nick .. " с суммой " .. ConvertNumber(ini11[i].money) .. " вирт", false)
		else
			chatManager.addMessageToQueue(i .. ". Господин Пусто с суммой 0 вирт", false)
		end
	end
	chatManager.addMessageToQueue("Чтобы занять определенное место в списке, необходимо пожертвовать больше денег", false)
end

function cmd_topDonatersZiel()
	chatManager.addMessageToQueue("Список пожертвований от уважаемых людей на \"" .. ini1[DonateMoney].zielName .. "\" за все время", false)
	for i = 1, 3 do
		ini12 = inicfg.load(i, directIni12)
		if ini12[i] ~= nil then
			chatManager.addMessageToQueue(i .. ". Господин " .. ini12[i].nick .. " с суммой " .. ConvertNumber(ini12[i].money) .. " вирт", false)
		else
			chatManager.addMessageToQueue(i .. ". Господин Пусто с суммой 0 вирт", false)
		end
	end
	chatManager.addMessageToQueue("Чтобы занять определенное место в списке, необходимо пожертвовать больше денег", false)
end

function cmd_todayDonateMoney()
	chatManager.addMessageToQueue("Всего за день собрано: " .. ConvertNumber(ini2[todayDonateMoney].money), true)
end

function cmd_DonateMoney()
	chatManager.addMessageToQueue("Денег собрано за все время: " .. ConvertNumber(ini1[DonateMoney].money), true)
end

function cmd_DonateMoneyZiel()
	chatManager.addMessageToQueue(string.format("Денег на цель \"%s\" собрано: %s/%s [%s]", ini1[DonateMoney].zielName, ConvertNumber(ini8[DonateMoneyZiel].money), ConvertNumber(ini8[DonateMoneyZiel].target), string.sub(tostring(percent * 100), 1, 5)), true)
end

function cmd_topN(arg)
	if arg ~= nil and arg ~= "" then
		chatManager.addMessageToQueue("Список пожертвований от уважаемых людей за все время до " .. arg .. " места", false)
		for i = 0, arg do
			ini11 = inicfg.load(i, directIni11)
			if ini11[i] ~= nil then
				chatManager.addMessageToQueue(i .. ". Господин " .. ini11[i].nick .. " с суммой " .. ConvertNumber(ini11[i].money) .. " вирт", false)
			end
		end
		chatManager.addMessageToQueue("Всего " .. ConvertNumber(ini11[PlayerCount].count) .. " пожертвующих", false)
	end
end

function cmd_topZielN(arg)
	if arg ~= nil and arg ~= "" then
		chatManager.addMessageToQueue("Список пожертвований от уважаемых людей на \"" .. ini1[DonateMoney].zielName .. "\" за все время до" .. arg .. " места", false)
		for i = 0, arg do
			ini12 = inicfg.load(i, directIni12)
			if ini12[i] ~= nil then
				chatManager.addMessageToQueue(i .. ". Господин " .. ini12[i].nick .. " с суммой " .. ConvertNumber(ini12[i].money) .. " вирт", false)
			end
		end
		chatManager.addMessageToQueue("Всего " .. ConvertNumber(ini12[PlayerCount].count) .. " пожертвующих", false)
	end
end

function WaitingSelectedDay(d, m, y, firstName, firstSumma, secondName, secondSumma, thirdName, thirdSumma)
	chatManager.addMessageToQueue(string.format("Список пожертвований от уважаемых людей за %s.%s.%s", d, m, y), false)
	chatManager.addMessageToQueue("1. Господин " .. u8(firstName)  .. " с суммой " .. ConvertNumber(firstSumma)  .. " вирт", false)
	chatManager.addMessageToQueue("2. Господин " .. u8(secondName) .. " с суммой " .. ConvertNumber(secondSumma) .. " вирт", false)
	chatManager.addMessageToQueue("3. Господин " .. u8(thirdName)  .. " с суммой " .. ConvertNumber(thirdSumma)  .. " вирт", false)
end

function WaitingDonaterInfo(PlayerName)
	Player = string.format('%s', PlayerName)
	if ini5[Player] == nil then
		chatManager.addMessageToQueue("Господин " .. PlayerName .. " в базе данных не обнаружен", false)
	else
		if donaterZielPlace(ini5[Player].nick) ~= nil then
			chatManager.addMessageToQueue("Господин " .. ini5[Player].nick .. " находится на " .. donaterPlace(ini5[Player].nick) .. " месте в списке за все время и на " .. donaterZielPlace(ini5[Player].nick) .. " в списке на цель \"" .. ini1[DonateMoney].zielName .. "\"", false)
		else
			chatManager.addMessageToQueue("Господин " .. ini5[Player].nick .. " находится на " .. donaterPlace(ini5[Player].nick) .. " месте в списке за все время", false)
		end
		
		chatManager.addMessageToQueue("Сумма пожертвований за все время составляет: " .. ConvertNumber(ini5[Player].money), false)

		if ini7[Player] ~= nil then
			chatManager.addMessageToQueue("На цель \"" .. ini1[DonateMoney].zielName .. "\" составляет: " .. ConvertNumber(ini7[Player].money), false)
		end
		todayPlayer = string.format('%s-%s-%s-%s', my_day, my_month, my_year, PlayerName)

		if ini6[todayPlayer] == nil then
			chatManager.addMessageToQueue("Сегодня пожертвований не было", false)
		else
			chatManager.addMessageToQueue("За сегодня составляет: " .. ConvertNumber(ini6[todayPlayer].money), false)
		end
	end
end

function sampev.onServerMessage(color, text)
	if ini9[settings].Switch then
		if string.find(text, u8:decode"^ Вы получили .+ вирт, от .+$") or string.find(text, u8:decode"^ Вы получили .+ вирт, на счет от .+$") then
			summa = string.match(text, u8:decode"Вы получили (%d+) вирт")
			
			if string.find(text, u8:decode"^ Вы получили .+ вирт, на счет от .+$") then 
				sampAddChatMessage(prefix .. u8:decode"Денежный перевод на счет!", main_color)
				nickname = string.match(text, u8:decode"от (.+)% %[")
			elseif string.find(text, u8:decode"^ Вы получили .+ вирт, от .+$") then
				nickname = string.match(text, u8:decode"от (.+)%[")
			end
			
			if ini9[settings].DonateNotify then
				if tonumber(summa) == 100000 then
					sampAddChatMessage(prefix .. u8:decode"Вы получили {FF0000}100.000 {FFFFFF}вирт от {FF0000}" .. nickname, main_color) -- red
					if ini9[settings].Sound then
						soundManager.playSound("100k")
					end
				end
				
				if tonumber(summa) >= 75000 and tonumber(summa) < 100000 then
					sampAddChatMessage(prefix .. u8:decode"Вы получили {FF1493}" .. ConvertNumber(summa) .. u8:decode" {FFFFFF}вирт от {FF1493}" .. nickname, main_color) -- yellow
					if ini9[settings].Sound then
						soundManager.playSound("75k")
					end
				end
				
				if tonumber(summa) >= 50000 and tonumber(summa) < 75000 then
					sampAddChatMessage(prefix .. u8:decode"Вы получили {FF00FF}" .. ConvertNumber(summa) .. u8:decode" {FFFFFF}вирт от {FF00FF}" .. nickname, main_color) -- pink
					if ini9[settings].Sound then
						soundManager.playSound("50k")
					end
				end
				
				if tonumber(summa) >= 25000 and tonumber(summa) < 50000 then
					sampAddChatMessage(prefix .. u8:decode"Вы получили {800080}" .. ConvertNumber(summa) .. u8:decode" {FFFFFF}вирт от {800080}" .. nickname, main_color) -- purple
					if ini9[settings].Sound then
						soundManager.playSound("25k")
					end
				end
				
				if tonumber(summa) >= 10000 and tonumber(summa) < 25000 then
					sampAddChatMessage(prefix .. u8:decode"Вы получили {0000FF}" .. ConvertNumber(summa) .. u8:decode" {FFFFFF}вирт от {0000FF}" .. nickname, main_color) -- blue
					if ini9[settings].Sound then
						soundManager.playSound("10k")
					end
				end
				
				if tonumber(summa) >= 5000 and tonumber(summa) < 10000 then
					sampAddChatMessage(prefix .. u8:decode"Вы получили {00FFFF}" .. ConvertNumber(summa) .. u8:decode" {FFFFFF}вирт от {00FFFF}" .. nickname, main_color) -- aqua
					if ini9[settings].Sound then
						soundManager.playSound("5k")
					end
				end
				
				if tonumber(summa) >= 1000 and tonumber(summa) < 5000 then
					sampAddChatMessage(prefix .. u8:decode"Вы получили {00FF00}" .. ConvertNumber(summa) .. u8:decode" {FFFFFF}вирт от {00FF00}" .. nickname, main_color) -- green
					if ini9[settings].Sound then
						soundManager.playSound("1k")
					end
				end
				
				if tonumber(summa) >= 100 and tonumber(summa) < 1000 then
					sampAddChatMessage(prefix .. u8:decode"Вы получили {808000}" .. ConvertNumber(summa) .. u8:decode" {FFFFFF}вирт от {808000}" .. nickname, main_color) -- olive
					if ini9[settings].Sound then
						soundManager.playSound("100")
					end
				end
				
				if tonumber(summa) < 100 then
					sampAddChatMessage(prefix .. u8:decode"Вы получили {556B2F}" .. ConvertNumber(summa) .. u8:decode" {FFFFFF}вирт от {556B2F}" .. nickname, main_color) -- dark olive
					if ini9[settings].Sound then
						soundManager.playSound("0")
					end
				end
			end
			
			ini1[DonateMoney].money = ini1[DonateMoney].money + summa
			inicfg.save(ini1, directIni1)
			
			ini2[todayDonateMoney].money = ini2[todayDonateMoney].money + summa
			inicfg.save(ini2, directIni2)
			
			ini8[DonateMoneyZiel].money = ini8[DonateMoneyZiel].money + summa
			inicfg.save(ini8, directIni8)
			
			Player = string.format('%s', nickname)
			if ini5[Player] == nil then
				ini5 = inicfg.load({
					[Player] = {
						nick = tostring(nickname),
						money = tonumber(summa)
					}
				}, directIni5)
				if ini9[settings].DonatersNotify then
					sampAddChatMessage(prefix .. u8:decode"Господин {40E0D0}" .. nickname .. u8:decode"{FFFFFF} был добавлен в базу данных" , main_color)
					sampAddChatMessage(prefix .. u8:decode"Сумма пожертвований от {40E0D0}" .. nickname .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ConvertNumber(ini5[Player].money), main_color)
				end
				ini1[DonateMoney].count = ini1[DonateMoney].count + 1
				inicfg.save(ini1, directIni1)
				
				PlayerRating = string.format('%d', ini11[PlayerCount].count + 1)
				if ini11[PlayerRating] == nil then
					ini11 = inicfg.load({
						[PlayerRating] = {
							nick  = tostring(nickname),
							money = tonumber(summa)
						}
					}, directIni11)
					
					ini11[PlayerCount].count = ini11[PlayerCount].count + 1
					inicfg.save(ini11, directIni11)
					ini11 = inicfg.load(ini11[PlayerCount].count, directIni11)
				else
					lua_thread.create(
					function() 
						for i = 0, tonumber(ini11[PlayerCount].count + 1) do
							if ini11[i] ~= nil then
								if ini11[i].nick == nickname then
									ini11[i].money = ini11[i].money + summa
									inicfg.save(ini11, directIni11)
								end
							end
						end 
					end)
				end
			else
				ini5[Player].money = ini5[Player].money + summa
				if ini9[settings].DonatersNotify then
					sampAddChatMessage(prefix .. u8:decode"Сумма пожертвований за все время от {40E0D0}" .. nickname .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ConvertNumber(ini5[Player].money), main_color)
				end
				lua_thread.create(function() for i = 0, tonumber(ini11[PlayerCount].count + 1) do
					if ini11[i] ~= nil then
						if ini11[i].nick == nickname then
							ini11[i].money = ini11[i].money + summa
							inicfg.save(ini11, directIni11)
						end
					end
				end end)
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
				
				PlayerZielRating = string.format('%d', ini12[PlayerZielCount].count + 1)
				if ini12[PlayerZielRating] == nil then
					ini12 = inicfg.load({
						[PlayerZielRating] = {
							nick = tostring(nickname),
							money = tonumber(summa)
						}
					}, directIni12)
				end
				ini12[PlayerZielCount].count = ini12[PlayerZielCount].count + 1
				inicfg.save(ini12, directIni12)
				ini8[DonateMoneyZiel].count = ini8[DonateMoneyZiel].count + 1
				inicfg.save(ini8, directIni8)
				ini12 = inicfg.load(ini12[PlayerZielCount].count, directIni12)
			else
				ini7[PlayerZiel].money = ini7[PlayerZiel].money + summa
				lua_thread.create(function() for i = 0, tonumber(ini12[PlayerZielCount].count + 1) do
					if ini12[i] ~= nil then
						if ini12[i].nick == nickname then
							ini12[i].money = ini12[i].money + summa
							inicfg.save(ini12, directIni12)
						end
					end
				end end)
				
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
					sampAddChatMessage(prefix .. u8:decode"Сумма пожертвований за сегодня от {40E0D0}" .. nickname .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ConvertNumber(ini6[todayPlayer].money), main_color)
				end
				ini2[todayDonateMoney].count = ini2[todayDonateMoney].count + 1
				inicfg.save(ini2, directIni2)
			else
				ini6[todayPlayer].money = ini6[todayPlayer].money + summa
				if ini9[settings].TodayDonatersNotify then
					sampAddChatMessage(prefix .. u8:decode"Сумма пожертвований за сегодня от {40E0D0}" .. nickname .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ConvertNumber(ini6[todayPlayer].money), main_color)
				end
			end
			inicfg.save(ini6, directIni6)
			
			if tonumber(ini6[todayPlayer].money) > tonumber(ini4[todayTopPlayers].firstSumma) then
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
			elseif tonumber(ini6[todayPlayer].money) > tonumber(ini4[todayTopPlayers].secondSumma) and tonumber(ini6[todayPlayer].money) <= tonumber(ini4[todayTopPlayers].firstSumma) then
				if ini4[todayTopPlayers].secondName ~= ini6[todayPlayer].nick then
					ini4[todayTopPlayers].thirdSumma = ini4[todayTopPlayers].secondSumma
					ini4[todayTopPlayers].thirdName = ini4[todayTopPlayers].secondName
					ini4[todayTopPlayers].secondSumma = ini6[todayPlayer].money
					ini4[todayTopPlayers].secondName = nickname
				else
					ini4[todayTopPlayers].secondSumma = ini6[todayPlayer].money
				end
			elseif tonumber(ini6[todayPlayer].money) > tonumber(ini4[todayTopPlayers].thirdSumma) and tonumber(ini6[todayPlayer].money) <= tonumber(ini4[todayTopPlayers].secondSumma) then
				if ini4[todayTopPlayers].thirdName ~= ini6[todayPlayer].nick then
					ini4[todayTopPlayers].thirdSumma = ini6[todayPlayer].money
					ini4[todayTopPlayers].thirdName = nickname
				else
					ini4[todayTopPlayers].thirdSumma = ini6[todayPlayer].money
				end
			end
			inicfg.save(ini4, directIni4)
			
			donatersRating()
			
			donatersZielRating()
			
			restartTextLabelOverPlayerNickname()
			
			percent = (tonumber(ini8[DonateMoneyZiel].money)/tonumber(ini8[DonateMoneyZiel].target))
			
			return false 
		end
	end
end

function sampev.onSendCommand(cmd)

	chatManager.lastMessage = cmd
    chatManager.updateAntifloodClock()

	local args = {}

	for arg in cmd:gmatch("%S+") do
		table.insert(args, arg)
	end
	
	if args[1] == '/donatername' then
		if args[2] then
			WaitingDonaterInfo(args[2])
		end
	end
	if args[1] == '/donaterid' then
		if args[2] and isNumber(args[2]) and tonumber(args[2]) >= 0 and tonumber(args[2]) < 1000 and math.fmod(tonumber(args[2]), 1) == 0 and sampIsPlayerConnected(args[2]) then
			WaitingDonaterInfo(sampGetPlayerNickname(args[2]))
		else
			sampAddChatMessage(prefix .. u8:decode"Ошибка", main_color)
		end
	end
	if args[1] == '/donater' then
		if args[2] then
			if args[3] == nil then
				Player = string.format('%s', args[2])
				if ini5[Player] == nil then
					sampAddChatMessage(prefix .. u8:decode"Господин {40E0D0}" .. args[2] .. u8:decode" {FFFFFF}в базе данных не обнаружен", main_color)
				else
					if donaterZielPlace(ini5[Player].nick) ~= nil then
						sampAddChatMessage(prefix .. u8:decode"Господин {40E0D0}" .. ini5[Player].nick .. u8:decode" {FFFFFF}находится на " .. donaterPlace(ini5[Player].nick) .. u8:decode" месте в списке за все время ", main_color)
						sampAddChatMessage(prefix .. u8:decode"и на " .. donaterZielPlace(ini5[Player].nick) .. u8:decode" в списке на цель {40E0D0}\"" .. ini1[DonateMoney].zielName .. "\"", main_color)
					else
						sampAddChatMessage(prefix .. u8:decode"Господин {40E0D0}" .. ini5[Player].nick .. u8:decode" {FFFFFF}находится на " .. donaterPlace(ini5[Player].nick) .. u8:decode" {FFFFFF}месте в списке за все время", main_color)
					end
					sampAddChatMessage(prefix .. u8:decode"Сумма пожертвований за все время составляет: {40E0D0}" .. ConvertNumber(ini5[Player].money), main_color)
					if ini7[Player] ~= nil then
						sampAddChatMessage(prefix .. u8:decode"На цель {40E0D0}\"" .. ini1[DonateMoney].zielName .. u8:decode"\"{FFFFFF} составляет: {40E0D0}" .. ConvertNumber(ini7[Player].money), main_color)
					end
					todayPlayer = string.format('%s-%s-%s-%s', my_day, my_month, my_year, args[2])
					if ini6[todayPlayer] == nil then
						sampAddChatMessage(prefix .. u8:decode"Сегодня пожертвований не было", main_color)
					else
						sampAddChatMessage(prefix .. u8:decode"За сегодня составляет: {40E0D0}" .. ConvertNumber(ini6[todayPlayer].money), main_color)
					end
				end
			elseif args[3] ~= nil and args[3] ~= "" and isNumber(args[3]) and math.fmod(tonumber(args[3]), 1) == 0 then
				
				tempSumma = ini8[DonateMoneyZiel].money
				
				ini1[DonateMoney].money = ini1[DonateMoney].money + args[3]
				inicfg.save(ini1, directIni1)
				
				ini2[todayDonateMoney].money = ini2[todayDonateMoney].money + args[3]
				inicfg.save(ini2, directIni2)
				
				ini8[DonateMoneyZiel].money = ini8[DonateMoneyZiel].money + args[3]
				inicfg.save(ini8, directIni8)
			
				Player = string.format('%s', args[2])
				if ini5[Player] ~= nil then
					ini5[Player].money = ini5[Player].money + args[3]
					sampAddChatMessage(prefix .. u8:decode"Сумма пожертвований от {40E0D0}" .. args[2] .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ConvertNumber(ini5[Player].money), main_color)
					for i = 0, tonumber(ini11[PlayerCount].count + 1) do
						if ini11[i] ~= nil then
							if ini11[i].nick == args[2] then
								ini11[i].money = ini11[i].money + args[3]
								inicfg.save(ini11, directIni11)
							end
						end
					end
				else
					ini5 = inicfg.load({
						[Player] = {
							nick = tostring(args[2]),
							money = tonumber(args[3])
						}
					}, directIni5)
					sampAddChatMessage(prefix .. u8:decode"Господин {40E0D0}" .. args[2] .. u8:decode"{FFFFFF} был добавлен в базу данных" , main_color)
					sampAddChatMessage(prefix .. u8:decode"Сумма пожертвований за все время от {40E0D0}" .. args[2] .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ConvertNumber(args[3]), main_color)
					ini1[DonateMoney].count = ini1[DonateMoney].count + 1
					inicfg.save(ini1, directIni1)
					
					PlayerRating = string.format('%d', ini11[PlayerCount].count + 1)
					if ini11[PlayerRating] == nil then
						ini11 = inicfg.load({
							[PlayerRating] = {
								nick = tostring(args[2]),
								money = tonumber(args[3])
							}
						}, directIni11)
					end
					ini11[PlayerCount].count = ini11[PlayerCount].count + 1
					inicfg.save(ini11, directIni11)
					ini11 = inicfg.load(ini11[PlayerCount].count, directIni11)
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
					ini8[DonateMoneyZiel].count = ini8[DonateMoneyZiel].count + 1
					inicfg.save(ini8, directIni8)
					
					PlayerZielRating = string.format('%d', ini12[PlayerZielCount].count + 1)
					if ini12[PlayerZielRating] == nil then
						ini12 = inicfg.load({
							[PlayerZielRating] = {
								nick = tostring(args[2]),
								money = tonumber(args[3])
							}
						}, directIni12)
					end
					ini12[PlayerZielCount].count = ini12[PlayerZielCount].count + 1
					inicfg.save(ini12, directIni12)
					ini12 = inicfg.load(ini12[PlayerZielCount].count, directIni12)
				else
					ini7[PlayerZiel].money = ini7[PlayerZiel].money + args[3]
					for i = 0, tonumber(ini12[PlayerZielCount].count + 1) do
						if ini12[i] ~= nil then
							if ini12[i].nick == args[2] then
								ini12[i].money = ini12[i].money + args[3]
								inicfg.save(ini12, directIni12)
							end
						end
					end
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
					sampAddChatMessage(prefix .. u8:decode"Сумма пожертвований за сегодня от {40E0D0}" .. args[2] .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ConvertNumber(ini6[todayPlayer].money), main_color)
				else
					ini6[todayPlayer].money = ini6[todayPlayer].money + args[3]
					sampAddChatMessage(prefix .. u8:decode"Сумма пожертвований за сегодня от {40E0D0}" .. args[2] .. u8:decode"{FFFFFF} составляет: {40E0D0}" .. ConvertNumber(ini6[todayPlayer].money), main_color)
				end
				inicfg.save(ini6, directIni6)
				
				if tonumber(args[3]) >= tonumber(0) then
					if tonumber(ini6[todayPlayer].money) > tonumber(ini4[todayTopPlayers].firstSumma) then
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
					elseif tonumber(ini6[todayPlayer].money) > tonumber(ini4[todayTopPlayers].secondSumma) and tonumber(ini6[todayPlayer].money) <= tonumber(ini4[todayTopPlayers].firstSumma) then
						if ini4[todayTopPlayers].secondName ~= ini6[todayPlayer].nick then
							ini4[todayTopPlayers].thirdSumma = ini4[todayTopPlayers].secondSumma
							ini4[todayTopPlayers].thirdName = ini4[todayTopPlayers].secondName
							ini4[todayTopPlayers].secondSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].secondName = args[2]
						else
							ini4[todayTopPlayers].secondSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].secondName = ini6[todayPlayer].nick
						end
					elseif tonumber(ini6[todayPlayer].money) > tonumber(ini4[todayTopPlayers].thirdSumma) and tonumber(ini6[todayPlayer].money) <= tonumber(ini4[todayTopPlayers].secondSumma) then
						if ini4[todayTopPlayers].thirdName ~= ini6[todayPlayer].nick then
							ini4[todayTopPlayers].thirdSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].thirdName = args[2]
						else
							ini4[todayTopPlayers].thirdSumma = ini6[todayPlayer].money
							ini4[todayTopPlayers].thirdName = ini6[todayPlayer].nick
						end
					end
					inicfg.save(ini4, directIni4)
				else 
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
				end
				
				donatersRating()
				
				donatersZielRating()
				
				restartTextLabelOverPlayerNickname()
				
				percent = (tonumber(ini8[DonateMoneyZiel].money)/tonumber(ini8[DonateMoneyZiel].target))
				
			else
				sampAddChatMessage(prefix .. u8:decode"Ошибка.", main_color)
			end
		end
	end
	if args[1] == '/dziel' then
		if args[2] then
			if args[3] then
				ini1[DonateMoney].zielName = args[2]
				ini1[DonateMoney].target = args[3]
				inicfg.save(ini1, directIni1)
				sampAddChatMessage(prefix .. u8:decode"Новая цель: {40E0D0}" .. args[2] .. u8:decode"{FFFFFF} с суммой {40E0D0}" .. args[3], main_color)
				thisScript():reload()
			end
		end
	end
end

function imgui.OnDrawFrame()
	if ini1[DonateMoney].hud then
		if buffering_bar_position == true then
			imgui.SetNextWindowPos(imgui.ImVec2(ini9[settings].x, ini9[settings].y))
			inicfg.save(ini9, directIni9)
		end
		imgui.SetNextWindowSize(vec(83, 8))
		ini1 = inicfg.load(DonateMoney, directIni1)
		imgui.Begin("Donaterka", _,  imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		local pos = imgui.GetWindowPos()
		ini9[settings].x = pos.x
		ini9[settings].y = pos.y
		inicfg.save(ini9, directIni9)
		BufferingBar(percent, vec(83, 8), false)
		imgui.End()
	end
	if main_window_state.v then
		imgui.ShowCursor = true
		imgui.SetNextWindowPos(vec(137, 125), 2)
		imgui.SetNextWindowSize(vec(437, 230))
		imgui.Begin("Donatik " .. thisScript().version, main_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		
		imgui.BeginChild('top', vec(70, 213), true)
			imgui.CustomMenu({'Функции', 'Список донатеров', 'Список донатеров цель', 'История донатов', 'Информация', 'Своя тема'}, tab, vec(65, 20), _, true)
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild('bottom', vec(358.5, 213), true)
		if tab.v == 1 then
			if imgui.Button("Топ донатеры за день", vec(133.5/1.5, 10)) then
				cmd_donaters()
			end
			imgui.SameLine()
			if NewHotKey("##1", ActiveDonaters, tLastKeys, toScreenX(25)) then
				rkeys.changeHotKey(bindDonaters, ActiveDonaters.v)
				ini9['HotKey'].bindDonaters = encodeJson(ActiveDonaters.v)
				inicfg.save(ini9, directIni9)
			end
			imgui.SameLine()
			if imgui.Button("Топ донатеры за всё время", vec(133.5/1.5, 10)) then
				cmd_topDonaters()
			end
			imgui.SameLine()
			if NewHotKey("##2", ActiveTopDonaters, tLastKeys, toScreenX(25)) then
				rkeys.changeHotKey(bindTopDonaters, ActiveTopDonaters.v)

				ini9['HotKey'].bindTopDonaters = encodeJson(ActiveTopDonaters.v)
				inicfg.save(ini9, directIni9)
			end
			imgui.SameLine()
			if imgui.Button("Топ донатеры на \"" .. ini1[DonateMoney].zielName .. "\"", vec(133.5/1.5, 10)) then
				cmd_topDonatersZiel()
			end
			imgui.SameLine()
			if NewHotKey("##3", ActiveTopDonatersZiel, tLastKeys, toScreenX(25)) then
				rkeys.changeHotKey(bindTopDonatersZiel, ActiveTopDonatersZiel.v)

				ini9['HotKey'].bindTopDonatersZiel = encodeJson(ActiveTopDonatersZiel.v)
				inicfg.save(ini9, directIni9)
			end
			if imgui.Button("Денег за сегодня собрано", vec(133.5/1.5, 10)) then
				cmd_todayDonateMoney()
			end
			imgui.SameLine()
			if NewHotKey("##4", ActiveTodayDonateMoney, tLastKeys, toScreenX(25)) then
				rkeys.changeHotKey(bindTodayDonateMoney, ActiveTodayDonateMoney.v)

				ini9['HotKey'].bindTodayDonateMoney = encodeJson(ActiveTodayDonateMoney.v)
				inicfg.save(ini9, directIni9)
			end
			imgui.SameLine()
			if imgui.Button("Денег за все время собрано", vec(133.5/1.5, 10)) then
				cmd_DonateMoney()
			end
			imgui.SameLine()
			if NewHotKey("##5", ActiveDonateMoney, tLastKeys, toScreenX(25)) then
				rkeys.changeHotKey(bindDonateMoney, ActiveDonateMoney.v)

				ini9['HotKey'].bindDonateMoney = encodeJson(ActiveDonateMoney.v)
				inicfg.save(ini9, directIni9)
			end
			imgui.SameLine()
			if imgui.Button("Денег на \"" .. ini1[DonateMoney].zielName .."\" собрано", vec(133.5/1.5, 10)) then
				cmd_DonateMoneyZiel()
			end
			imgui.SameLine()
			if NewHotKey("##6", ActiveDonateMoneyZiel, tLastKeys, toScreenX(25)) then
				rkeys.changeHotKey(bindDonateMoneyZiel, ActiveDonateMoneyZiel.v)

				ini9['HotKey'].bindDonateMoneyZiel = encodeJson(ActiveDonateMoneyZiel.v)
				inicfg.save(ini9, directIni9)
			end
			imgui.PushItemWidth(toScreenX(116))
			imgui.InputText("##inp1", text_buffer_nick)
			imgui.PopItemWidth()
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted("Имя донатера")
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.SameLine()
			imgui.PushItemWidth(toScreenX(116))
			imgui.InputText("##inp2", text_buffer_summa)
			imgui.PopItemWidth()
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted("Сумма доната")
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.SameLine()
			if imgui.Button("Добавить донатера", vec(116, 10)) then
				if text_buffer_nick.v ~= nil and text_buffer_nick.v ~= "" and text_buffer_summa.v ~= nil and text_buffer_summa.v ~= "" and isNumber(text_buffer_summa.v) and math.fmod(tonumber(text_buffer_summa.v), 1) == 0 then
					sampSendChat("/donater " .. text_buffer_nick.v .. " " .. text_buffer_summa.v)
				else
					sampAddChatMessage(prefix .. u8:decode"Ошибка. Введите в первое поле ник игрока, во второе сумму", main_color)
				end
			end
			imgui.PushItemWidth(toScreenX(116))
			imgui.InputText("##inp3", text_buffer_name)
			imgui.PopItemWidth()
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted("Название цели")
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.SameLine()
			imgui.PushItemWidth(toScreenX(116))
			imgui.InputText("##inp4", text_buffer_target)
			imgui.PopItemWidth()
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted("Сумма цели")
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.SameLine()
			if imgui.Button("Установить цель", vec(116, 10)) then
				if text_buffer_name.v ~= nil and text_buffer_name.v ~= "" and text_buffer_target.v ~= nil and text_buffer_target.v ~= "" and isNumber(text_buffer_target.v) and math.fmod(tonumber(text_buffer_target.v), 1) == 0 then
					sampSendChat("/dziel " .. text_buffer_name.v .. " " .. text_buffer_target.v)
				else
					sampAddChatMessage(prefix .. u8:decode"Ошибка. Введите в первое поле название цели, во второе сумму", main_color)
				end
			end
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted("Текущая цель \"" .. ini1[DonateMoney].zielName .. "\" с суммой:			" .. ConvertNumber(ini1[DonateMoney].target))
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			if buffering_bar_position then
				if imgui.Button("Фиксация HUDa", vec(116, 10)) then
					buffering_bar_position = not buffering_bar_position
					inicfg.save(ini9, directIni9)
				end
			else
				if imgui.Button("Зафиксировать HUD", vec(116, 10)) then
					buffering_bar_position = not buffering_bar_position
					inicfg.save(ini9, directIni9)
				end
			end
			imgui.SameLine()
			if imgui.Button("Отображение HUDa", vec(116, 10)) then
				cmd_hud()
			end
			imgui.SameLine()
			if NewHotKey("##7", ActiveHud, tLastKeys, toScreenX(116)) then
				rkeys.changeHotKey(bindHud, ActiveHud.v)

				ini9['HotKey'].bindHud = encodeJson(ActiveHud.v)
				inicfg.save(ini9, directIni9)
			end
			BufferingBar(percent, vec(354, 10), false)
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted(string.format("Денег на цель \"%s\" собрано: 			%s/%s [%s]", ini1[DonateMoney].zielName, ConvertNumber(ini8[DonateMoneyZiel].money), ConvertNumber(ini8[DonateMoneyZiel].target), string.sub(tostring(percent * 100), 1, 5)))
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			
			imgui.Dummy(vec(0, 2.5))
			imgui.BeginChild("AA2", vec(175, 60), true)
			imgui.Columns(1, "Title1", true)
			imgui.Text("За все время: ".. ConvertNumber(ini1[DonateMoney].money) .. " вирт от " .. ConvertNumber(ini11["Count"].count) .. " игроков")
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
			if ini11[1] ~= nil then
				imgui.Text(u8(ini11[1].nick))
				imgui.NextColumn()
				imgui.Text("" .. ConvertNumber(ini11[1].money))
			else
				imgui.Text("Пусто")
				imgui.NextColumn()
				imgui.Text("0")
			end
			imgui.NextColumn()
			imgui.Separator()
			
			imgui.Text("Господин 2")
			imgui.NextColumn()		
			if ini11[2] ~= nil then
				imgui.Text(u8(ini11[2].nick))
				imgui.NextColumn()
				imgui.Text("" .. ConvertNumber(ini11[2].money))
			else
				imgui.Text("Пусто")
				imgui.NextColumn()
				imgui.Text("0")
			end
			imgui.NextColumn()
			imgui.Separator()
			
			imgui.Text("Господин 3")
			imgui.NextColumn()
			if ini11[3] ~= nil then
				imgui.Text(u8(ini11[3].nick))
				imgui.NextColumn()
				imgui.Text("" .. ConvertNumber(ini11[3].money))
			else
				imgui.Text("Пусто")
				imgui.NextColumn()
				imgui.Text("0")
			end
			imgui.EndChild()
			
			imgui.SameLine()
			imgui.BeginChild("AA3", vec(175, 60), true)
			imgui.Columns(1, "Title3", true)
			imgui.Text("На цель \"" .. ini1[DonateMoney].zielName .. "\" за все время: ".. ConvertNumber(ini8[DonateMoneyZiel].money) .. " вирт от " .. ConvertNumber(ini12["Count"].count) .. " игроков")
			imgui.Separator()
			imgui.Columns(3, "Columns3", true)
			imgui.Text("")
			imgui.NextColumn()
			imgui.Text("Имя")
			imgui.NextColumn()
			imgui.Text("Денег")
			imgui.NextColumn()
			imgui.Separator()
			
			imgui.Text("Господин 1")
			imgui.NextColumn()
			if ini12[1] ~= nil then
				imgui.Text(u8(ini12[1].nick))
				imgui.NextColumn()
				imgui.Text("" .. ConvertNumber(ini12[1].money))
			else
				imgui.Text("Пусто")
				imgui.NextColumn()
				imgui.Text("0")
			end
			imgui.NextColumn()
			imgui.Separator()
			
			imgui.Text("Господин 2")
			imgui.NextColumn()
			if ini12[2] ~= nil then
				imgui.Text(u8(ini12[2].nick))
				imgui.NextColumn()
				imgui.Text("" .. ConvertNumber(ini12[2].money))
			else
				imgui.Text("Пусто")
				imgui.NextColumn()
				imgui.Text("0")
			end
			imgui.NextColumn()
			imgui.Separator()
			
			imgui.Text("Господин 3")
			imgui.NextColumn()
			if ini12[3] ~= nil then
				imgui.Text(u8(ini12[3].nick))
				imgui.NextColumn()
				imgui.Text("" .. ConvertNumber(ini12[3].money))
			else
				imgui.Text("Пусто")
				imgui.NextColumn()
				imgui.Text("0")
			end
			imgui.EndChild()
			
			imgui.Dummy(vec(0, 2.5))
			imgui.BeginChild("AA", vec(175, 60), true)
			imgui.Columns(1, "Title2", true)
			imgui.Text("За сегодня: " .. ConvertNumber(ini2[todayDonateMoney].money) .. " вирт от " .. ini2[todayDonateMoney].count .. " игроков")
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
			imgui.Text("" .. ConvertNumber(ini4[todayTopPlayers].firstSumma))
			imgui.NextColumn()
			imgui.Separator()
			imgui.Text("Господин 2")
			imgui.NextColumn()
			imgui.Text(u8(ini4[todayTopPlayers].secondName))
			imgui.NextColumn()
			imgui.Text("" .. ConvertNumber(ini4[todayTopPlayers].secondSumma))
			imgui.NextColumn()
			imgui.Separator()
			imgui.Text("Господин 3")
			imgui.NextColumn()
			imgui.Text(u8(ini4[todayTopPlayers].thirdName))
			imgui.NextColumn()
			imgui.Text("" .. ConvertNumber(ini4[todayTopPlayers].thirdSumma))
			imgui.EndChild()
			
			imgui.SetCursorPos(vec(180, 147))
			
			if imgui.Checkbox("Уведомления о донатах от игрока за все время. ", imgui.ImBool(ini9[settings].DonatersNotify)) then
				ini9[settings].DonatersNotify = not ini9[settings].DonatersNotify
				inicfg.save(ini9, directIni9)
			end
			imgui.SetCursorPos(vec(180, 159))
			if imgui.Checkbox("Уведомления о донатах от игрока за сегодня. ", imgui.ImBool(ini9[settings].TodayDonatersNotify)) then
				ini9[settings].DonatersNotify = not ini9[settings].DonatersNotify
				inicfg.save(ini9, directIni9)
			end
			imgui.SetCursorPos(vec(180, 171))
			if imgui.Checkbox("Уведомления о донатах. ", imgui.ImBool(ini9[settings].DonateNotify)) then
				ini9[settings].DonatersNotify = not ini9[settings].DonatersNotify
				inicfg.save(ini9, directIni9)
			end
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted("Показывать количество полученных денег и ник донатера. Цвет доната меняется в зависимости от размера суммы.")
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.SameLine()
			imgui.Text("Выбор темы: ")
			imgui.SameLine()
			imgui.PushItemWidth(toScreenX(43))
			if imgui.Combo("##Combo", combo_select, "Коричневая\0Синяя\0Красная\0Фиолетовая\0Зелёная\0Голубая\0Жёлтая\0Монохром\0Своя\0") then --0, 1...
				ini9[settings].themeId = combo_select.v
				inicfg.save(ini9, directIni9)
				themes.SwitchColorTheme(combo_select.v,ini9[MyStyle].Text_R, ini9[MyStyle].Text_G, ini9[MyStyle].Text_B, ini9[MyStyle].Text_A,
					ini9[MyStyle].Button_R, ini9[MyStyle].Button_G, ini9[MyStyle].Button_B, ini9[MyStyle].Button_A,
					ini9[MyStyle].ButtonActive_R, ini9[MyStyle].ButtonActive_G, ini9[MyStyle].ButtonActive_B, ini9[MyStyle].ButtonActive_A,
					ini9[MyStyle].FrameBg_R, ini9[MyStyle].FrameBg_G, ini9[MyStyle].FrameBg_B, ini9[MyStyle].FrameBg_A,
					ini9[MyStyle].FrameBgHovered_R, ini9[MyStyle].FrameBgHovered_G, ini9[MyStyle].FrameBgHovered_B, ini9[MyStyle].FrameBgHovered_A,
					ini9[MyStyle].Title_R, ini9[MyStyle].Title_G, ini9[MyStyle].Title_B, ini9[MyStyle].Title_A,
					ini9[MyStyle].Separator_R, ini9[MyStyle].Separator_G, ini9[MyStyle].Separator_B, ini9[MyStyle].Separator_A,
					ini9[MyStyle].CheckMark_R, ini9[MyStyle].CheckMark_G, ini9[MyStyle].CheckMark_B, ini9[MyStyle].CheckMark_A,
					ini9[MyStyle].WindowBg_R, ini9[MyStyle].WindowBg_G, ini9[MyStyle].WindowBg_B, ini9[MyStyle].WindowBg_A)
			end
			imgui.PopItemWidth()
			imgui.SetCursorPos(vec(180, 183))
			if imgui.Checkbox("Уведомление о заходе донатера от суммы: ", imgui.ImBool(ini9[settings].DonaterJoined)) then
				ini9[settings].DonaterJoined = not ini9[settings].DonaterJoined
				inicfg.save(ini9, directIni9)
			end
			imgui.SameLine()
			imgui.PushItemWidth(toScreenX(40))
			if imgui.InputInt("##inp5", imgui.donateSize, 0, 1) then
				if imgui.donateSize.v ~= nil and imgui.donateSize.v ~= "" and imgui.donateSize.v >= 0 then
					ini9[settings].donateSize = imgui.donateSize.v
					inicfg.save(ini9, directIni9)
				end
			end
			imgui.PopItemWidth()
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted("Показывать количество полученных денег и ник донатера. Цвет доната меняется в зависимости от размера суммы.")
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.SetCursorPos(vec(180, 195))
			if imgui.Checkbox("Звук донатов. ", imgui.ImBool(ini9[settings].Sound)) then
				ini9[settings].Sound = not ini9[settings].Sound
				inicfg.save(ini9, directIni9)
			end
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted("Если звук отсутствует, требуется выставить минимальную громкость игрового радио и перезагрузить игру.")
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.SameLine()
			if imgui.Checkbox("Отображение доната сверху игрока. ", imgui.ImBool(ini9[settings].textLabel)) then
				ini9[settings].textLabel = not ini9[settings].textLabel
				inicfg.save(ini9, directIni9)
			end
		elseif tab.v == 2 then
			imgui.Columns(1, "Title23", true)
			imgui.Text("Список донатеров за все время: ".. ConvertNumber(ini1[DonateMoney].money) .. " вирт от " .. ConvertNumber(ini11["Count"].count) .. " игроков")
			imgui.Separator()
			imgui.Columns(3, "Columns", true)
			imgui.Text("Место")
			imgui.NextColumn()
			imgui.Text("Имя")
			imgui.NextColumn()
			imgui.Text("Денег")
			imgui.NextColumn()
			for i = 1, tonumber(ini11[PlayerCount].count) do
				if ini11[i] ~= nil then
					imgui.Separator()
					imgui.Text("" .. i)
					imgui.NextColumn()
					imgui.Text(u8(ini11[i].nick))
					imgui.NextColumn()
					imgui.Text("" .. ConvertNumber(ini11[i].money))
					imgui.NextColumn()
				end
			end
		elseif tab.v == 3 then
			imgui.Columns(1, "Title23", true)
			imgui.Text("На цель \"" .. ini1[DonateMoney].zielName .. "\" за все время: ".. ConvertNumber(ini8[DonateMoneyZiel].money) .. " вирт от " .. ConvertNumber(ini12["Count"].count) .. " игроков")
			imgui.Separator()
			imgui.Columns(3, "Columns", true)
			imgui.Text("Место")
			imgui.NextColumn()
			imgui.Text("Имя")
			imgui.NextColumn()
			imgui.Text("Денег")
			imgui.NextColumn()
			for i = 1, tonumber(ini12[PlayerCount].count) do
				if ini12[i] ~= nil then
					imgui.Separator()
					imgui.Text("" .. i)
					imgui.NextColumn()
					imgui.Text(u8(ini12[i].nick))
					imgui.NextColumn()
					imgui.Text("" .. ConvertNumber(ini12[i].money))
					imgui.NextColumn()
				end
			end
		elseif tab.v == 4 then
			imgui.Text(" История донатов:")
			imgui.SameLine()
			imgui.SetCursorPosX(toScreenX(180))
			
			if donaters_list then
				if imgui.Button("Все", vec(20, 0)) then
					donaters_list = not donaters_list
				end
			else
				if imgui.Button("Цель", vec(20, 0)) then
					donaters_list = not donaters_list
				end
			end
			
			local donatersCount = 0
			for i = 0, 1000 do
				if sampIsPlayerConnected(i) then
					donaterNick = sampGetPlayerNickname(i)
					if donaters_list then
						if ini5[donaterNick] ~= nil then
							if donaterNick == ini5[donaterNick].nick and ini5[donaterNick].money >= donaters_list_silder.v then
								donatersCount = donatersCount + 1
							end
						end
					else
						if ini7[donaterNick] ~= nil then
							if donaterNick == ini7[donaterNick].nick and ini7[donaterNick].money >= donaters_list_silder.v then
								donatersCount = donatersCount + 1
							end
						end

					end
				end
			end
			
			imgui.SameLine()
			imgui.PushItemWidth(toScreenX(90))
			if imgui.SliderInt("##inp7", donaters_list_silder, 1, 100000) then end
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.Text(" Донатеры онлайн " .. donatersCount .. "	")
			
			imgui.BeginChild('History', vec(175, 190), true)
				for y = 2020, 2038 do
					for m = 0, 12 do
						for d = 0, 31 do
							if tonumber(d) > 0 and tonumber(d) < 10 then d = string.format('0%d', d) end
							if tonumber(m) > 0 and tonumber(m) < 10 then m = string.format('0%d', m) end
							todayTopPlayersSelectedDay = string.format('%s-%s-%s', d, m, y)
							todayDonateMoneySelectedDay = string.format('%s-%s-%s', d, m, y)
							if ini4[todayTopPlayersSelectedDay] ~= nil and ini4[todayTopPlayersSelectedDay].firstSumma ~= 0 then
								if ini2[todayDonateMoneySelectedDay] ~= nil and ini2[todayDonateMoneySelectedDay].money ~= 0 then
									if imgui.CollapsingHeader(string.format(u8:decode'%s.%s.%s - %s', d, m, y, ConvertNumber(ini2[todayDonateMoneySelectedDay].money))) then
										imgui.PushTextWrapPos(toScreenX(185))
										imgui.BeginChild(string.format(u8:decode'%s-%s-%s', d, m, y), vec(163, 60), true)
										imgui.Columns(1, "Title2", true)
										imgui.Text("За весь день: ".. ConvertNumber(ini2[todayDonateMoneySelectedDay].money) .. " вирт от " .. ini2[todayDonateMoneySelectedDay].count .. " игроков")
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
										imgui.Text(u8(ini4[todayTopPlayersSelectedDay].firstName))
										imgui.NextColumn()
										imgui.Text("" .. ConvertNumber(ini4[todayTopPlayersSelectedDay].firstSumma))
										imgui.NextColumn()
										imgui.Separator()
										imgui.Text("Господин 2")
										imgui.NextColumn()
										imgui.Text(u8(ini4[todayTopPlayersSelectedDay].secondName))
										imgui.NextColumn()
										imgui.Text("" .. ConvertNumber(ini4[todayTopPlayersSelectedDay].secondSumma))
										imgui.NextColumn()
										imgui.Separator()
										imgui.Text("Господин 3")
										imgui.NextColumn()
										imgui.Text(u8(ini4[todayTopPlayersSelectedDay].thirdName))
										imgui.NextColumn()
										imgui.Text("" .. ConvertNumber(ini4[todayTopPlayersSelectedDay].thirdSumma))
										imgui.EndChild()
										if imgui.Button(string.format('Вывести список топ донатеров за %s-%s-%s', d, m, y), vec(163, 10)) then
											WaitingSelectedDay(d, m, y, ini4[todayTopPlayersSelectedDay].firstName, ini4[todayTopPlayersSelectedDay].firstSumma, ini4[todayTopPlayersSelectedDay].secondName, ini4[todayTopPlayersSelectedDay].secondSumma, ini4[todayTopPlayersSelectedDay].thirdName, ini4[todayTopPlayersSelectedDay].thirdSumma)
										end
										imgui.PopTextWrapPos()
									end
								end
							end
						end
					end
				end
			imgui.EndChild()
			
			imgui.SameLine()
			
			imgui.BeginChild('DonatersOnline', vec(175, 190), true)
				for i = 0, 1000 do
					if sampIsPlayerConnected(i) then
						donaterNick = sampGetPlayerNickname(i)
						if donaters_list then
							if ini5[donaterNick] ~= nil then
								if donaterNick == ini5[donaterNick].nick and ini5[donaterNick].money >= donaters_list_silder.v then
									if imgui.CollapsingHeader(string.format('%s [%s]', ini5[donaterNick].nick, i)) then
										imgui.PushTextWrapPos(toScreenX(185))
										imgui.BeginChild(string.format('%s', ini5[donaterNick].nick), vec(163, 40), true)
										imgui.Text(" За всё время: " .. ConvertNumber(ini5[donaterNick].money))
										imgui.Separator()
										if ini7[donaterNick] ~= nil then
											imgui.Text(" На цель: " .. ConvertNumber(ini7[donaterNick].money))
										else
											imgui.Text(" На цель: нет")
										end
										imgui.Separator()
										todayDonaterNick = string.format('%s-%s-%s-%s', my_day, my_month, my_year, donaterNick)
										if ini6[todayDonaterNick] ~= nil then
											imgui.Text(" За сегодня: " .. ConvertNumber(ini6[todayDonaterNick].money))
										else
											imgui.Text(" За сегодня: нет")
										end
										imgui.EndChild()
										if imgui.Button("Вывести информацию о донатере", vec(163, 0)) then	
											WaitingDonaterInfo(donaterNick)
										end
										imgui.PopTextWrapPos()
									end
								end
							end
						else
							if ini7[donaterNick] ~= nil then
								if donaterNick == ini7[donaterNick].nick and ini7[donaterNick].money >= donaters_list_silder.v then
									if imgui.CollapsingHeader(string.format('%s [%s]', ini7[donaterNick].nick, i)) then
										imgui.PushTextWrapPos(toScreenX(185))
										imgui.BeginChild(string.format('%s', ini7[donaterNick].nick), vec(163, 40), true)
										imgui.Text(" За всё время: " .. ConvertNumber(ini5[donaterNick].money))
										imgui.Separator()
										if ini7[donaterNick] ~= nil then
											imgui.Text(" На цель: " .. ConvertNumber(ini7[donaterNick].money))
										else
											imgui.Text(" На цель: нет")
										end
										imgui.Separator()
										todayDonaterNick = string.format('%s-%s-%s-%s', my_day, my_month, my_year, donaterNick)
										if ini6[todayDonaterNick] ~= nil then
											imgui.Text(" За сегодня: " .. ConvertNumber(ini6[todayDonaterNick].money))
										else
											imgui.Text(" За сегодня: нет")
										end
										imgui.EndChild()
										if imgui.Button("Вывести информацию о донатере", vec(163, 0)) then	
											WaitingDonaterInfo(donaterNick)
										end
										imgui.PopTextWrapPos()
									end
								end
							end
						end
					end
				end
			imgui.EndChild() 
			
		elseif tab.v == 5 then
			if script.update then
				if imgui.Button("Обновить скрипт", vec(175, 20)) then
					imgui.Process = false
					updateScript()
				end
			else
				if imgui.Button("Актуальная версия скрипта", vec(175, 20)) then
					sampAddChatMessage(prefix .. "Обновление не требуется", main_color)
				end
			end
			imgui.SameLine()
			if imgui.Button("Перезагрузить", vec(175, 20)) then 
				thisScript():reload()
			end
			if imgui.Button("График", vec(175, 20)) then 
				diagram_window_state.v = not diagram_window_state.v
			end
			imgui.SameLine()
			if ini9[settings].Switch then
				if imgui.Button("Прекратить работу скрипта", vec(175, 20)) then
					ini9[settings].Switch = not ini9[settings].Switch
				end
			else
				if imgui.Button("Включить скрипт", vec(175, 20)) then
					ini9[settings].Switch = not ini9[settings].Switch
				end
			end
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted("Если выключить, то запись донатов прекратится")
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			if imgui.Button("VK", vec(86.5, 20)) then
				os.execute("start https://vk.com/vlaeek")
			end
			imgui.SameLine()
			if imgui.Button("GitHub", vec(86.5, 20)) then
				os.execute("start https://vlaek.github.io/Donatik/")
			end
			local found = false
			imgui.SameLine()
			for i = 0, 1000 do 
				if sampIsPlayerConnected(i) and sampGetPlayerScore(i) ~= 0 then
					if sampGetPlayerNickname(i) == "bier" then
						if imgui.Button("bier [" .. i .. "] сейчас в сети", vec(175, 20)) then
							sampSendChat("/sms " .. i .. u8:decode" Привет, мой хороший")
						end
						if imgui.IsItemHovered() then
							imgui.BeginTooltip()
							imgui.PushTextWrapPos(toScreenX(100))
							imgui.TextUnformatted("Да да я")
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
						end
						found = true
					end
				end
			end
			if not found then
				if imgui.Button("bier сейчас не в сети", vec(175, 20)) then
					sampAddChatMessage(prefix .. u8:decode"bier играет на Revolution (сейчас не онлайн)", main_color)
				end
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(toScreenX(100))
					imgui.TextUnformatted("Да да я")
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
			end
			
			imgui.Separator()
			
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/dhud {FFFFFF}- включить главное меню скрипта")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/dhudik {FFFFFF}- включить Donatik HUD")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/donater [Ник игрока] [Количество денег] {FFFFFF}- добавить донатера")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/donater [Ник игрока] {FFFFFF}- вывести информацию о игроке (только себе)")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/dziel [Название цели] [Количество денег] {FFFFFF}- установить цель сбора")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/donaters {FFFFFF}- вывести список донатеров за сегодня")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/topdonaters {FFFFFF}- вывести список топ донатеров за все время")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/topdonatersZiel {FFFFFF}- вывести топ донатеров за все время для цели")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/todaydonateMoney {FFFFFF}- вывести накопленные деньги за сегодня")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/donatemoney {FFFFFF}- вывести накопленные деньги за все время")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/donatemoneyziel {FFFFFF}- вывести накопленные деньги для текущей цели")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/donatername [Ник игрока] {FFFFFF}- вывести в общий чат информацию о игроке")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/donaterid [id игрока] {FFFFFF}- вывести в общий чат информацию о игроке")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/dtop [N] {FFFFFF}- вывести в общий чат N-список донатеров")
			imgui.TextColoredRGB(u8:decode"  {40E0D0}/dtopZiel [N] {FFFFFF}- вывести в общий чат N-список донатеров для текущей цели")
			

		elseif tab.v == 6 then
			if imgui.ColorEdit4("Text", color_text) then 
				rgba = imgui.ImColor(color_text.v[1], color_text.v[2], color_text.v[3], color_text.v[4])
				ini9[MyStyle].Text_R, ini9[MyStyle].Text_G, ini9[MyStyle].Text_B, ini9[MyStyle].Text_A = rgba:GetRGBA()
				inicfg.save(ini9, directIni9)
				updateMyStyle()
			end
			if imgui.ColorEdit4("Button", color_button) then 
				rgba = imgui.ImColor(color_button.v[1], color_button.v[2], color_button.v[3], color_button.v[4])
				ini9[MyStyle].Button_R, ini9[MyStyle].Button_G, ini9[MyStyle].Button_B, ini9[MyStyle].Button_A = rgba:GetRGBA()
				inicfg.save(ini9, directIni9)
				updateMyStyle()
			end
			if imgui.ColorEdit4("ButtonActive", color_button_active) then 
				rgba = imgui.ImColor(color_button_active.v[1], color_button_active.v[2], color_button_active.v[3], color_button_active.v[4])
				ini9[MyStyle].ButtonActive_R, ini9[MyStyle].ButtonActive_G, ini9[MyStyle].ButtonActive_B, ini9[MyStyle].ButtonActive_A = rgba:GetRGBA()
				inicfg.save(ini9, directIni9)
				updateMyStyle()
			end
			if imgui.ColorEdit4("FrameBg", color_frame) then 
				rgba = imgui.ImColor(color_frame.v[1], color_frame.v[2], color_frame.v[3], color_frame.v[4])
				ini9[MyStyle].FrameBg_R, ini9[MyStyle].FrameBg_G, ini9[MyStyle].FrameBg_B, ini9[MyStyle].FrameBg_A = rgba:GetRGBA()
				inicfg.save(ini9, directIni9)
				updateMyStyle()
			end
			if imgui.ColorEdit4("FrameBgHovered", color_frame_hovered) then 
				rgba = imgui.ImColor(color_frame_hovered.v[1], color_frame_hovered.v[2], color_frame_hovered.v[3], color_frame_hovered.v[4])
				ini9[MyStyle].FrameBgHovered_R, ini9[MyStyle].FrameBgHovered_G, ini9[MyStyle].FrameBgHovered_B, ini9[MyStyle].FrameBgHovered_A = rgba:GetRGBA()
				inicfg.save(ini9, directIni9)
				updateMyStyle()
			end
			if imgui.ColorEdit4("Title", color_title) then 
				rgba = imgui.ImColor(color_title.v[1], color_title.v[2], color_title.v[3], color_title.v[4])
				ini9[MyStyle].Title_R, ini9[MyStyle].Title_G, ini9[MyStyle].Title_B, ini9[MyStyle].Title_A = rgba:GetRGBA()
				inicfg.save(ini9, directIni9)
				updateMyStyle()
			end
			if imgui.ColorEdit4("Separator", color_separator) then 
				rgba = imgui.ImColor(color_separator.v[1], color_separator.v[2], color_separator.v[3], color_separator.v[4])
				ini9[MyStyle].Separator_R, ini9[MyStyle].Separator_G, ini9[MyStyle].Separator_B, ini9[MyStyle].Separator_A = rgba:GetRGBA()
				inicfg.save(ini9, directIni9)
				updateMyStyle()
			end
			if imgui.ColorEdit4("WindowBg", color_windowbg) then 
				rgba = imgui.ImColor(color_windowbg.v[1], color_windowbg.v[2], color_windowbg.v[3], color_windowbg.v[4])
				ini9[MyStyle].WindowBg_R, ini9[MyStyle].WindowBg_G, ini9[MyStyle].WindowBg_B, ini9[MyStyle].WindowBg_A = rgba:GetRGBA()
				inicfg.save(ini9, directIni9)
				updateMyStyle()
			end
			if imgui.ColorEdit4("CheckMark", color_checkmark) then 
				rgba = imgui.ImColor(color_checkmark.v[1], color_checkmark.v[2], color_checkmark.v[3], color_checkmark.v[4])
				ini9[MyStyle].CheckMark_R, ini9[MyStyle].CheckMark_G, ini9[MyStyle].CheckMark_B, ini9[MyStyle].CheckMark_A = rgba:GetRGBA()
				inicfg.save(ini9, directIni9)
				updateMyStyle()
			end
			imgui.Separator()
			if imgui.Button("Вернуть значения по умолчанию", vec(352, 20)) then
				ini9[MyStyle].Text_R           = 1.00
				ini9[MyStyle].Text_G           = 1.00
				ini9[MyStyle].Text_B           = 1.00
				ini9[MyStyle].Text_A           = 1.00
				ini9[MyStyle].Button_R         = 0.98
				ini9[MyStyle].Button_G         = 0.43
				ini9[MyStyle].Button_B         = 0.26
				ini9[MyStyle].Button_A         = 0.40
				ini9[MyStyle].ButtonActive_R   = 0.98
				ini9[MyStyle].ButtonActive_G   = 0.43
				ini9[MyStyle].ButtonActive_B   = 0.26
				ini9[MyStyle].ButtonActive_A   = 1.00
				ini9[MyStyle].FrameBg_R        = 0.48
				ini9[MyStyle].FrameBg_G        = 0.23
				ini9[MyStyle].FrameBg_B        = 0.16
				ini9[MyStyle].FrameBg_A        = 0.25
				ini9[MyStyle].FrameBgHovered_R = 0.98
				ini9[MyStyle].FrameBgHovered_G = 0.43
				ini9[MyStyle].FrameBgHovered_B = 0.26
				ini9[MyStyle].FrameBgHovered_A = 0.40
				ini9[MyStyle].Title_R          = 0.48
				ini9[MyStyle].Title_G          = 0.23
				ini9[MyStyle].Title_B          = 0.16
				ini9[MyStyle].Title_A          = 1.00
				ini9[MyStyle].Separator_R      = 0.43
				ini9[MyStyle].Separator_G      = 0.43
				ini9[MyStyle].Separator_B      = 0.50
				ini9[MyStyle].Separator_A      = 0.50
				ini9[MyStyle].CheckMark_R      = 0.98
				ini9[MyStyle].CheckMark_G      = 0.43
				ini9[MyStyle].CheckMark_B      = 0.26
				ini9[MyStyle].CheckMark_A      = 1.00
				ini9[MyStyle].WindowBg_R       = 0.06
				ini9[MyStyle].WindowBg_G       = 0.06
				ini9[MyStyle].WindowBg_B       = 0.06
				ini9[MyStyle].WindowBg_A       = 0.94
				inicfg.save(ini9, directIni9)
				updateMyStyle()
			end
		end
		imgui.EndChild()
		imgui.End()
	end
	if help_window_state.v then
		imgui.SetNextWindowPos(vec(100, 100), 2)
		imgui.SetNextWindowSize(vec(207, 175))
		imgui.Begin("Команды ", help_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		
		imgui.BeginChild('Help', vec(200, 155), true)
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/dhud {FFFFFF}- включить главное меню скрипта")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/dhudik {FFFFFF}- включить Donatik HUD")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/donater [Ник игрока] [Количество денег] {FFFFFF}- добавить донатера")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/donater [Ник игрока] {FFFFFF}- вывести информацию о игроке (только себе)")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/dziel [Название цели] [Количество денег] {FFFFFF}- установить цель сбора")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/donaters {FFFFFF}- вывести список донатеров за сегодня")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/topdonaters {FFFFFF}- вывести список топ донатеров за все время")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/topdonatersZiel {FFFFFF}- вывести топ донатеров за все время для цели")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/todaydonateMoney {FFFFFF}- вывести накопленные деньги за сегодня")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/donatemoney {FFFFFF}- вывести накопленные деньги за все время")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/donatemoneyziel {FFFFFF}- вывести накопленные деньги для текущей цели")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/donatername [Ник игрока] {FFFFFF}- вывести в общий чат информацию о игроке")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/donaterid [id игрока] {FFFFFF}- вывести в общий чат информацию о игроке")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/dtop [N] {FFFFFF}- вывести в общий чат N-список донатеров")
		imgui.TextColoredRGB(u8:decode"  {40E0D0}/dtopZiel [N] {FFFFFF}- вывести в общий чат N-список донатеров для текущей цели")
		imgui.EndChild()
		
		imgui.End()
	end
		if diagram_window_state.v then
		imgui.SetNextWindowPos(vec(100, 100), 2)
		imgui.SetNextWindowSize(vec(417, 330))
		imgui.Begin("График ", diagram_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		
		local diagramSumma = 0
		local diagramPercent = 0
		local days = 0
		
		imgui.BeginChild('Diagram', vec(410, 300), true)

		if tostring(my_month) == tostring("01") or tostring(my_month) == tostring("03") or tostring(my_month) == tostring("05") or tostring(my_month) == tostring("07") or tostring(my_month) == tostring("08") or tostring(my_month) == tostring("10") or tostring(my_month) == tostring("12") then
			days = 31
		end
		if tostring(my_month) == tostring("04") or tostring(my_month) == tostring("06") or tostring(my_month) == tostring("09") or tostring(my_month) == tostring("11") then
			days = 30
		end
		if tostring(my_month) == tostring("02") and isNumber(my_year/4) and math.fmod(tonumber(my_year/4), 1) == 0 then
			days = 29
		else
			if tostring(my_month) == tostring("02") then
				days = 28
			end
		end
		
		for i = 1, days do
			if tonumber(i) > 0 and tonumber(i) < 10 then i = string.format('0%d', i) end
			todayDonateMoneySelectedDay = string.format('%s-%s-%s', i, my_month, my_year)
			if ini2[todayDonateMoneySelectedDay] ~= nil and ini2[todayDonateMoneySelectedDay].money ~= 0 then
				diagramSumma = diagramSumma + ini2[todayDonateMoneySelectedDay].money
			end
		end
		
		for i = 1, days do
			if tonumber(i) > 0 and tonumber(i) < 10 then i = string.format('0%d', i) end
			todayDonateMoneySelectedDay = string.format('%s-%s-%s', i, my_month, my_year)
			if ini2[todayDonateMoneySelectedDay] ~= nil and ini2[todayDonateMoneySelectedDay].money ~= 0 then
				diagramSumma = diagramSumma + ini2[todayDonateMoneySelectedDay].money
			end
			if tonumber(i) == tonumber(os.date("%d")) and tonumber(my_month) == tonumber(os.date("%m")) then
				imgui.TextColoredRGB("{FF0000}" .. string.format('%s.%s.%s  {FFFFFF}- ', i, my_month, my_year))
			else
				imgui.Text(string.format('%s.%s.%s  - ', i, my_month, my_year))
			end
			imgui.SameLine()
			if ini2[todayDonateMoneySelectedDay] ~= nil and ini2[todayDonateMoneySelectedDay].money ~= 0 and ini2[todayDonateMoneySelectedDay].money > 0 then
				diagramPercent = ini2[todayDonateMoneySelectedDay].money / diagramSumma * 100
				imgui.TextColoredRGB("{FFFF00}[")
				imgui.SameLine()
				for j = 1, round(diagramPercent, 1) do
					imgui.TextColoredRGB("{FFFF00}|")
					imgui.SameLine()
				end
				local ost = 100 - round(diagramPercent, 1)
				for j = 1, ost do
					imgui.TextColoredRGB("{FFFFFF}|")
					imgui.SameLine()
				end
				imgui.TextColoredRGB("{FFFF00}]")
				imgui.SameLine()
				imgui.Text(" -  " .. ConvertNumber(ini2[todayDonateMoneySelectedDay].money))
			else
				imgui.TextColoredRGB("{FFFF00}[")
				imgui.SameLine()
				for j = 1, 100 do
					imgui.TextColoredRGB("{FFFFFF}|")
					imgui.SameLine()
				end
				imgui.TextColoredRGB("{FFFF00}]")
				imgui.SameLine()
				imgui.Text(" -  0")
			end
		end

		imgui.EndChild()
		
			if imgui.Button("Назад", vec(170/3, 0)) then
				if tonumber(my_year) >= tonumber(2020) and tonumber(my_month) >= 2 then
					my_month = my_month - 1
					if tonumber(my_month) > 0 and tonumber(my_month) < 10 then my_month = string.format('0%d', my_month) end
					if tonumber(my_month) == 0 then my_month = string.format('12') my_year = my_year - 1 end
				end
			end
			imgui.SameLine()
			if imgui.Button("Вперед", vec(170/3, 0)) then
				if tonumber(my_month) < tonumber(os.date("%m")) then
					my_month = my_month + 1
					if tonumber(my_month) > 0 and tonumber(my_month) < 10 then my_month = string.format('0%d', my_month) end
					if tonumber(my_month) == 13 then my_month = string.format('01') my_year = my_year + 1 end
				end
			end
		imgui.End()
	end
end

function imgui.initBuffers()
	imgui.settingsTab   = 1
	imgui.donateSize    = imgui.ImInt(ini9[settings].donateSize)
	combo_select        = imgui.ImInt(ini9[settings].themeId)
	color_text          = imgui.ImFloat4(ini9[MyStyle].Text_R, ini9[MyStyle].Text_G, ini9[MyStyle].Text_B, ini9[MyStyle].Text_A)
	color_button 	    = imgui.ImFloat4(ini9[MyStyle].Button_R, ini9[MyStyle].Button_G, ini9[MyStyle].Button_B, ini9[MyStyle].Button_A)
	color_button_active = imgui.ImFloat4(ini9[MyStyle].ButtonActive_R, ini9[MyStyle].ButtonActive_G, ini9[MyStyle].ButtonActive_B, ini9[MyStyle].ButtonActive_A)
	color_frame         = imgui.ImFloat4(ini9[MyStyle].FrameBg_R, ini9[MyStyle].FrameBg_G, ini9[MyStyle].FrameBg_B, ini9[MyStyle].FrameBg_A)
	color_frame_hovered = imgui.ImFloat4(ini9[MyStyle].FrameBgHovered_R, ini9[MyStyle].FrameBgHovered_G, ini9[MyStyle].FrameBgHovered_B, ini9[MyStyle].FrameBgHovered_A)
	color_title         = imgui.ImFloat4(ini9[MyStyle].Title_R, ini9[MyStyle].Title_G, ini9[MyStyle].Title_B, ini9[MyStyle].Title_A)
	color_separator     = imgui.ImFloat4(ini9[MyStyle].Separator_R, ini9[MyStyle].Separator_G, ini9[MyStyle].Separator_B, ini9[MyStyle].Separator_A)
	color_windowbg      = imgui.ImFloat4(ini9[MyStyle].WindowBg_R, ini9[MyStyle].WindowBg_G, ini9[MyStyle].WindowBg_B, ini9[MyStyle].WindowBg_A)
	color_checkmark     = imgui.ImFloat4(ini9[MyStyle].CheckMark_R, ini9[MyStyle].CheckMark_G, ini9[MyStyle].CheckMark_B, ini9[MyStyle].CheckMark_A)
end

function imgui.CustomMenu(labels, selected, size, speed, centering)
    local bool = false
    speed = speed and speed or 0.2
    local radius = size.y * 0.50
    local draw_list = imgui.GetWindowDrawList()
    if LastActiveTime == nil then LastActiveTime = {} end
    if LastActive == nil then LastActive = {} end
    local function ImSaturate(f)
        return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
    end
    for i, v in ipairs(labels) do
        local c = imgui.GetCursorPos()
        local p = imgui.GetCursorScreenPos()
        if imgui.InvisibleButton(v..'##'..i, size) then
            selected.v = i
            LastActiveTime[v] = os.clock()
            LastActive[v] = true
            bool = true
        end
        imgui.SetCursorPos(c)
        local t = selected.v == i and 1.0 or 0.0
        if LastActive[v] then
            local time = os.clock() - LastActiveTime[v]
            if time <= 0.3 then
                local t_anim = ImSaturate(time / speed)
                t = selected.v == i and t_anim or 1.0 - t_anim
            else
                LastActive[v] = false
            end
        end
        local col_bg = imgui.GetColorU32(selected.v == i and imgui.GetStyle().Colors[imgui.Col.ButtonActive] or imgui.ImVec4(0,0,0,0))
        local col_box = imgui.GetColorU32(selected.v == i and imgui.GetStyle().Colors[imgui.Col.Button] or imgui.ImVec4(0,0,0,0))
        local col_hovered = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
        local col_hovered = imgui.GetColorU32(imgui.ImVec4(col_hovered.x, col_hovered.y, col_hovered.z, (imgui.IsItemHovered() and 0.2 or 0)))
        draw_list:AddRectFilled(imgui.ImVec2(p.x-size.x/6, p.y), imgui.ImVec2(p.x + (radius * 0.65) + t * size.x, p.y + size.y), col_bg, 10.0)
        draw_list:AddRectFilled(imgui.ImVec2(p.x-size.x/6, p.y), imgui.ImVec2(p.x + (radius * 0.65) + size.x, p.y + size.y), col_hovered, 10.0)
        draw_list:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x+5, p.y + size.y), col_box)
        imgui.SetCursorPos(imgui.ImVec2(c.x+(centering and (size.x-imgui.CalcTextSize(v).x)/2 or 15), c.y+(size.y-imgui.CalcTextSize(v).y)/2))
        imgui.Text(v)
        imgui.SetCursorPos(imgui.ImVec2(c.x, c.y+size.y))
    end
    return bool
end

function isNumber(n)
    return type(tonumber(n)) == "number"
end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end

    render_text(text)
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
	local x, y = convertGameScreenCoordsToWindowScreenCoords(gX, gY)
	return imgui.ImVec2(x, y)
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
						sampAddChatMessage(prefix .. u8:decode'Доступна новая версия скрипта! /dhud > Информация > Обновить скрипт', main_color)
						script.update = true
					return true
					end
				end
			end
		end
	end)
end

function updateScript()
	downloadUrlToFile("https://raw.githubusercontent.com/Vlaek/Donatik/master/Donatik.lua", thisScript().path, function(_, status, _, _)
		if status == 6 then
			sampAddChatMessage(prefix .. u8:decode'Скрипт обновлён!', main_color)
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

function ConvertNumber(number)
	l = string.len(number)
	if l <= 3 then
		return number
	end
	if l <= 6 and l > 3 then
		count = math.floor(number / 1000) ost = math.fmod(number, 1000) zahl = string.format("%s.%s", count, ost)
	end
	if l <= 6 and l > 3 then
		count = math.floor(number / 1000) ost = math.fmod(number, 1000) if ost == 0 then ost = "000" end if tonumber(ost) > 0 and tonumber(ost) < 10 then ost2 = ost ost = string.format("00%s", ost2) end if tonumber(ost) > 10 and tonumber(ost) < 100 then ost2 = ost ost = string.format("0%s", ost2) end zahl = string.format("%s.%s", count, ost)
	end
	if l <= 9 and l > 6 then
		count = math.floor(number / 1000000) ost = math.floor(math.fmod(number, 1000000)/1000)  if ost == 0 then ost = "000" end if tonumber(ost) > 0 and tonumber(ost) < 10 then ost3 = ost ost = string.format("00%s", ost3) end if tonumber(ost) > 10 and tonumber(ost) < 100 then ost3 = ost ost = string.format("0%s", ost3) end ost2 = math.fmod(math.fmod(number, 1000000), 1000) if ost2 == 0 then ost2 = "000" end if tonumber(ost2) > 0 and tonumber(ost2) < 10 then ost4 = ost2 ost2 = string.format("00%s", ost4) end if tonumber(ost2) > 10 and tonumber(ost2) < 100 then ost4 = ost2 ost2 = string.format("0%s", ost4) end zahl = string.format("%s.%s.%s", count, ost, ost2)
	end
	return zahl
end

function round(exact, quantum)
    local quant,frac = math.modf(exact/quantum)
    return quantum * (quant + (frac > 0.5 and 1 or 0))
end

chatManager = {}

chatManager.messagesQueue = {}
chatManager.messagesQueueSize = 1000
chatManager.antifloodClock = os.clock()
chatManager.lastMessage = ""
chatManager.antifloodDelay = 0.8

function chatManager.initQueue()
    for messageIndex = 1, chatManager.messagesQueueSize do
        chatManager.messagesQueue[messageIndex] = {
            message = "",
        }
    end
end

function chatManager.addMessageToQueue(string, _nonRepeat)
    local isRepeat = false
    local nonRepeat = _nonRepeat or false

    if nonRepeat then
        for messageIndex = 1, chatManager.messagesQueueSize do
            if string == chatManager.messagesQueue[messageIndex].message then
                isRepeat = true
            end
        end
    end

    if not isRepeat then
        for messageIndex = 1, chatManager.messagesQueueSize - 1 do
            chatManager.messagesQueue[messageIndex].message = chatManager.messagesQueue[messageIndex + 1].message
        end
        chatManager.messagesQueue[chatManager.messagesQueueSize].message = string
    end
end

function chatManager.checkMessagesQueueThread()
    while true do
        wait(0)
        for messageIndex = 1, chatManager.messagesQueueSize do
            local message = chatManager.messagesQueue[messageIndex]
            if message.message ~= "" then
                if string.sub(chatManager.lastMessage, 1, 1) ~= "/" and string.sub(message.message, 1, 1) ~= "/" then
                    chatManager.antifloodDelay = chatManager.antifloodDelay + 0.5
                end
                if os.clock() - chatManager.antifloodClock > chatManager.antifloodDelay then

                    local sendMessage = true

                    local command = string.match(message.message, "^(/[^ ]*).*")

                    if sendMessage then
                        chatManager.lastMessage = u8:decode(message.message)
                        sampSendChat(u8:decode(message.message))
                    end

                    message.message = ""
                end
                chatManager.antifloodDelay = 0.8
            end
        end
    end
end

function sampev.onSendChat(message)
    chatManager.lastMessage = message
    chatManager.updateAntifloodClock()
end

function chatManager.updateAntifloodClock()
    chatManager.antifloodClock = os.clock()
    if string.sub(chatManager.lastMessage, 1, 5) == "/sms " or string.sub(chatManager.lastMessage, 1, 3) == "/t " then
        chatManager.antifloodClock = chatManager.antifloodClock + 0.5
    end
end

function explode_argb(argb)
  local a = bit.band(bit.rshift(argb, 24), 0xFF)
  local r = bit.band(bit.rshift(argb, 16), 0xFF)
  local g = bit.band(bit.rshift(argb, 8), 0xFF)
  local b = bit.band(argb, 0xFF)
  return a, r, g, b
end

function join_argb(a, r, g, b)
  local argb = b  -- b
  argb = bit.bor(argb, bit.lshift(g, 8))  -- g
  argb = bit.bor(argb, bit.lshift(r, 16)) -- r
  argb = bit.bor(argb, bit.lshift(a, 24)) -- a
  return argb
end

function argb_to_rgba(argb)
  local a, r, g, b = explode_argb(argb)
  return join_argb(r, g, b, a)
end

function onScriptTerminate(LuaScript, quitGame)
	if LuaScript == thisScript() then
		for i = 0, 1000 do
			if textlabel[i] ~= nil then
				sampDestroy3dText(textlabel[i])
				textlabel[i] = nil
			end
		end
		imgui.Process = false
		sampAddChatMessage(prefix .. u8:decode"Скрипт завершил свою работу", main_color)
	end
end

function updateMyStyle()
	themes.SwitchColorTheme(combo_select.v,ini9[MyStyle].Text_R, ini9[MyStyle].Text_G, ini9[MyStyle].Text_B, ini9[MyStyle].Text_A,
		ini9[MyStyle].Button_R, ini9[MyStyle].Button_G, ini9[MyStyle].Button_B, ini9[MyStyle].Button_A,
		ini9[MyStyle].ButtonActive_R, ini9[MyStyle].ButtonActive_G, ini9[MyStyle].ButtonActive_B, ini9[MyStyle].ButtonActive_A,
		ini9[MyStyle].FrameBg_R, ini9[MyStyle].FrameBg_G, ini9[MyStyle].FrameBg_B, ini9[MyStyle].FrameBg_A,
		ini9[MyStyle].FrameBgHovered_R, ini9[MyStyle].FrameBgHovered_G, ini9[MyStyle].FrameBgHovered_B, ini9[MyStyle].FrameBgHovered_A,
		ini9[MyStyle].Title_R, ini9[MyStyle].Title_G, ini9[MyStyle].Title_B, ini9[MyStyle].Title_A,
		ini9[MyStyle].Separator_R, ini9[MyStyle].Separator_G, ini9[MyStyle].Separator_B, ini9[MyStyle].Separator_A,
		ini9[MyStyle].CheckMark_R, ini9[MyStyle].CheckMark_G, ini9[MyStyle].CheckMark_B, ini9[MyStyle].CheckMark_A,
		ini9[MyStyle].WindowBg_R, ini9[MyStyle].WindowBg_G, ini9[MyStyle].WindowBg_B, ini9[MyStyle].WindowBg_A)
end

-- BufferingBar:
function BufferingBar(value, size_arg, circle)
    local style = imgui.GetStyle()
    local size = size_arg;

    local DrawList = imgui.GetWindowDrawList()
    size.x = size.x - (style.FramePadding.x * 2);

    local pos = imgui.GetCursorScreenPos()

    imgui.Dummy(imgui.ImVec2(size.x, size.y))

    if circle then
        local circleStart = size.x * 0.85;
        local circleEnd = size.x;
        local circleWidth = circleEnd - circleStart;
        
        DrawList:AddRectFilled(pos, imgui.ImVec2(pos.x + circleStart, pos.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.Button]))
        DrawList:AddRectFilled(pos, imgui.ImVec2(pos.x + circleStart * value, pos.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]))
        
        local t = imgui.GetTime()
        local r = size.y / 2;
        local speed = 1.5;
        
        local a = speed * 0;
        local b = speed * 0.333;
        local c = speed * 0.666;
    
        local o1 = (circleWidth+r) * (t+a - speed * math.floor((t+a) / speed)) / speed;
        local o2 = (circleWidth+r) * (t+b - speed * math.floor((t+b) / speed)) / speed;
        local o3 = (circleWidth+r) * (t+c - speed * math.floor((t+c) / speed)) / speed;
        
        DrawList:AddCircleFilled(imgui.ImVec2(pos.x + circleEnd - o1, pos.y + r), r, imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.Button]))
        DrawList:AddCircleFilled(imgui.ImVec2(pos.x + circleEnd - o2, pos.y + r), r, imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.Button]))
        DrawList:AddCircleFilled(imgui.ImVec2(pos.x + circleEnd - o3, pos.y + r), r, imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.Button]))
    else
        local circleStart = size.x;

        DrawList:AddRectFilled(pos, imgui.ImVec2(pos.x + circleStart, pos.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.Button]))
        DrawList:AddRectFilled(pos, imgui.ImVec2(pos.x + circleStart * value, pos.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]))
    end

    return true
end

-- HotKey:
local tBlockKeys = {[vkeys.VK_RETURN] = true, [vkeys.VK_T] = true, [vkeys.VK_F6] = true, [vkeys.VK_F8] = true}
local tBlockChar = {[116] = true, [84] = true}
local tModKeys = {[vkeys.VK_MENU] = true, [vkeys.VK_SHIFT] = true, [vkeys.VK_CONTROL] = true}
local tBlockNextDown = {}

local tHotKeyData = {
    edit = nil,
	save = {},
   lastTick = os.clock(),
   tickState = false
}
local tKeys = {}

local wm = require 'lib.windows.message'

local xz = {}
xz._SETTINGS = {
    noKeysMessage = "No"
}

function NewHotKey(name, keys, lastkeys, width)
    local width = width or 90
    local name = tostring(name)
    local lastkeys = lastkeys or {}
    local keys, bool = keys or {}, false
    lastkeys.v = keys.v

    local sKeys = table.concat(getKeysName(keys.v), " + ")

    if #tHotKeyData.save > 0 and tostring(tHotKeyData.save[1]) == name then
        keys.v = tHotKeyData.save[2]
        sKeys = table.concat(getKeysName(keys.v), " + ")
        tHotKeyData.save = {}
        bool = true
    elseif tHotKeyData.edit ~= nil and tostring(tHotKeyData.edit) == name then
		if #tKeys == 0 then
			if os.clock() - tHotKeyData.lastTick > 0.5 then
            tHotKeyData.lastTick = os.clock()
            tHotKeyData.tickState = not tHotKeyData.tickState
         end
         sKeys = tHotKeyData.tickState and xz._SETTINGS.noKeysMessage or " "
        else
            sKeys = table.concat(getKeysName(tKeys), " + ")
        end
    end

    imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.FrameBg])
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.FrameBgHovered])
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.FrameBgActive])
    if imgui.Button((tostring(sKeys):len() == 0 and xz._SETTINGS.noKeysMessage or sKeys) .. name, imgui.ImVec2(width, 0)) then
        tHotKeyData.edit = name
    end
    imgui.PopStyleColor(3)
    return bool
end

function getCurrentEdit()
    return tHotKeyData.edit ~= nil
end

function getKeysList(bool)
   local bool = bool or false
   local tKeysList = {}
   if bool then
      for k, v in ipairs(tKeys) do
         tKeysList[k] = vkeys.id_to_name(v)
      end
   else
      tKeysList = tKeys
   end
   return tKeysList
end

function getKeysName(keys)
    if type(keys) ~= "table" then
       return false
    else
       local tKeysName = {}
       for k, v in ipairs(keys) do
          tKeysName[k] = vkeys.id_to_name(v)
       end
       return tKeysName
    end
 end

local function getKeyNumber(id)
   for k, v in ipairs(tKeys) do
      if v == id then
         return k
      end
   end
   return -1
end

local function reloadKeysList()
    local tNewKeys = {}
    for k, v in pairs(tKeys) do
       tNewKeys[#tNewKeys + 1] = v
    end
    tKeys = tNewKeys
    return true
 end

function isKeyModified(id)
if type(id) ~= "number" then
   return false
end
return (tModKeys[id] or false) or (tBlockKeys[id] or false)
end

addEventHandler("onWindowMessage", function (msg, wparam, lparam)
    if tHotKeyData.edit ~= nil and msg == wm.WM_CHAR then
        if tBlockChar[wparam] then
            consumeWindowMessage(true, true)
        end
    end
    if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
        if tHotKeyData.edit ~= nil and wparam == vkeys.VK_ESCAPE then
            tKeys = {}
            tHotKeyData.edit = nil
            consumeWindowMessage(true, true)
        end
        if tHotKeyData.edit ~= nil and wparam == vkeys.VK_BACK then
            tHotKeyData.save = {tHotKeyData.edit, {}}
            tHotKeyData.edit = nil
            consumeWindowMessage(true, true)
        end
        local num = getKeyNumber(wparam)
        if num == -1 then
            tKeys[#tKeys + 1] = wparam
            if tHotKeyData.edit ~= nil then
                if not isKeyModified(wparam) then
                    tHotKeyData.save = {tHotKeyData.edit, tKeys}
                    tHotKeyData.edit = nil
                    tKeys = {}
                    consumeWindowMessage(true, true)
                end
            end
        end
        reloadKeysList()
        if tHotKeyData.edit ~= nil then
            consumeWindowMessage(true, true)
        end
    elseif msg == wm.WM_KEYUP or msg == wm.WM_SYSKEYUP then
        local num = getKeyNumber(wparam)
        if num > -1 then
            tKeys[num] = nil
        end
        reloadKeysList()
        if tHotKeyData.edit ~= nil then
            consumeWindowMessage(true, true)
        end
    end
end)
