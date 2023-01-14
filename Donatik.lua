script_name("Donatik")
script_author("bier from Revolution")
script_version("14.01.2023")
script_version_number(23)
script_url("https://vlaek.github.io/Donatik/")
script.update = false
script.reload = false

local main_color = 0xFFFF00
local scriptLoaded = false
local prefix = "{FFFF00} [" .. thisScript().name .. "] {FFFFFF}"

function try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end

try(function()
		sampev 		= require 'lib.samp.events'
		inicfg 		= require 'inicfg'
		imgui 		= require 'imgui'
		vkeys 		= require 'vkeys' 
		rkeys 		= require 'rkeys'
		effil 		= require 'effil'
		multipart 	= require 'multipart-post'
		dkjson    	= require 'dkjson'
		wm 			= require 'lib.windows.message'
		screenshotIsAvailable, screenshot = pcall(require, 'lib.screenshot')
		as_action = require 'moonloader'.audiostream_state
		themes = import 'imgui_themes.lua'
		encoding  		 = require 'encoding'
		encoding.default = 'CP1251'
		u8               = encoding.UTF8
	end,
	function(e)
		sampAddChatMessage(prefix .. "An error occurred while loading libraries", main_color)
		thisScript():unload()
	end)

local donatik = {}
local tg = {}
local statistics_ini, todayTopDonaters_ini, donaters_ini, todayDonaters_ini, donatersZiel_ini, statistics_ziel_ini, settings_ini, donatersRating_ini, donatersRatingZiel_ini = {}, {}, {}, {}, {}, {}, {}, {}, {}
local updateid

local skins = {
	[0]  = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[1]  = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[2]  = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[3]  = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[4]  = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[5]  = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[6]  = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[7]  = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[8]  = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[9]  = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[10] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[11] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[12] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[13] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[14] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[15] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[16] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[17] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[18] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[19] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[20] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[21] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[22] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[23] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[24] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[25] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[26] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[27] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[28] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[29] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[30] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[31] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[32] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[33] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[34] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[35] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[36] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[37] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[38] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[39] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[40] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[41] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[42] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[43] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[44] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[45] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[46] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[47] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[48] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[49] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[50] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[51] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[52] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[53] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[54] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[55] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[56] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[57] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[58] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[59] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[60] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[61] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[62] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[63] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[64] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[65] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[66] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[67] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[68] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[69] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[70] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[71] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[72] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[73] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[74] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[75] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[76] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[77] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[78] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[79] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[80] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[81] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[82] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[83] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[84] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[85] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[86] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[87] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[88] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[89] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[90] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[91] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[92] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[93] = {group = u8:decode("Гражданский"), gender = u8:decode("Женский")},
	[94] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[95] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[96] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[97] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[98] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[99] = {group = u8:decode("Гражданский"), gender = u8:decode("Мужской")},
	[100] = {group = u8:decode("Гражданский"),	gender = u8:decode("Мужской")},
	[101] = {group = u8:decode("Гражданский"),	gender = u8:decode("Мужской")},
	[102] = {group = u8:decode("Баллас"),		gender = u8:decode("Мужской")},
	[103] = {group = u8:decode("Баллас"),		gender = u8:decode("Мужской")},
	[104] = {group = u8:decode("Баллас"),		gender = u8:decode("Мужской")},
	[105] = {group = u8:decode("Грув"),			gender = u8:decode("Мужской")},
	[106] = {group = u8:decode("Грув"),			gender = u8:decode("Мужской")},
	[107] = {group = u8:decode("Грув"),			gender = u8:decode("Мужской")},
	[108] = {group = u8:decode("Вагос"),		gender = u8:decode("Мужской")},
	[109] = {group = u8:decode("Вагос"),		gender = u8:decode("Мужской")},
	[110] = {group = u8:decode("Вагос"),		gender = u8:decode("Мужской")},
	[111] = {group = u8:decode("РМ"), 			gender = u8:decode("Мужской")},
	[112] = {group = u8:decode("РМ"), 			gender = u8:decode("Мужской")},
	[113] = {group = u8:decode("ЛКН"),			gender = u8:decode("Мужской")},
	[114] = {group = u8:decode("Ацтек"),		gender = u8:decode("Мужской")},
	[115] = {group = u8:decode("Ацтек"),		gender = u8:decode("Мужской")},
	[116] = {group = u8:decode("Ацтек"),		gender = u8:decode("Мужской")},
	[117] = {group = u8:decode("Якудза"),		gender = u8:decode("Мужской")},
	[118] = {group = u8:decode("Якудза"),		gender = u8:decode("Мужской")},
	[119] = {group = u8:decode("Гражданский"),	gender = u8:decode("Мужской")},
	[120] = {group = u8:decode("Якудза"),		gender = u8:decode("Мужской")},
	[121] = {group = u8:decode("Гражданский"),	gender = u8:decode("Мужской")},
	[122] = {group = u8:decode("Гражданский"),	gender = u8:decode("Мужской")},
	[123] = {group = u8:decode("Якудза"),		gender = u8:decode("Мужской")},
	[124] = {group = u8:decode("ЛКН"),			gender = u8:decode("Мужской")},
	[125] = {group = u8:decode("РМ"),			gender = u8:decode("Мужской")},
	[126] = {group = u8:decode("РМ"),			gender = u8:decode("Мужской")},
	[127] = {group = u8:decode("ЛКН"),			gender = u8:decode("Мужской")},
	[128] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[129] = {group = u8:decode("Гражданский"),	gender = u8:decode("Женский")},
	[130] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[131] = {group = u8:decode("Гражданский"),	gender = u8:decode("Женский")},
	[132] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[133] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[134] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[135] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[136] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[137] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[138] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[139] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[140] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[141] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[142] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[143] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[144] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[145] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[146] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[147] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[148] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[149] = {group = u8:decode("Грув"), 		gender = u8:decode("Мужской")},
	[150] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[151] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[152] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[153] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[154] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[155] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[156] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[157] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[158] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[159] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[160] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[161] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[162] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[163] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[164] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[165] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[166] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[167] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[168] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[169] = {group = u8:decode("Якудза"), 		gender = u8:decode("Женский")},
	[170] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[171] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[172] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[173] = {group = u8:decode("Рифа"), 		gender = u8:decode("Мужской")},
	[174] = {group = u8:decode("Рифа"), 		gender = u8:decode("Мужской")},
	[175] = {group = u8:decode("Рифа"), 		gender = u8:decode("Мужской")},
	[176] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[177] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[178] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[179] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[180] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[181] = {group = u8:decode("Байкер"), 		gender = u8:decode("Мужской")},
	[182] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[183] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[184] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[185] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[186] = {group = u8:decode("Якудза"), 		gender = u8:decode("Мужской")},
	[187] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[188] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[189] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[190] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[191] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[192] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[193] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[194] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[195] = {group = u8:decode("Баллас"), 		gender = u8:decode("Женский")},
	[196] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[197] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[198] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[199] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[200] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[201] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[202] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[203] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[204] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[205] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[206] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[207] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[208] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[209] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[210] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[211] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[212] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[213] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[214] = {group = u8:decode("РМ"), 			gender = u8:decode("Женский")},
	[215] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[216] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[217] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[218] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[219] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[220] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[221] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[222] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[223] = {group = u8:decode("ЛКН"), 			gender = u8:decode("Мужской")},
	[224] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[225] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[226] = {group = u8:decode("Рифа"), 		gender = u8:decode("Женский")},
	[227] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[228] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[229] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[230] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[231] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[232] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[233] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[234] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[235] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[236] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[237] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[238] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[239] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[240] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[241] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[242] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[243] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[244] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[245] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[246] = {group = u8:decode("Байкер"), 		gender = u8:decode("Женский")},
	[247] = {group = u8:decode("Байкер"), 		gender = u8:decode("Мужской")},
	[248] = {group = u8:decode("Байкер"), 		gender = u8:decode("Мужской")},
	[249] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[250] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[251] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[252] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[253] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[254] = {group = u8:decode("Байкер"), 		gender = u8:decode("Мужской")},
	[255] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[256] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[257] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[258] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[259] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[260] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[261] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[262] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[263] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[264] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[265] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[266] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[267] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[268] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Мужской")},
	[269] = {group = u8:decode("Грув"), 		gender = u8:decode("Мужской")},
	[270] = {group = u8:decode("Грув"), 		gender = u8:decode("Мужской")},
	[271] = {group = u8:decode("Грув"), 		gender = u8:decode("Мужской")},
	[272] = {group = u8:decode("РМ"), 			gender = u8:decode("Мужской")},
	[273] = {group = u8:decode("Рифа"), 		gender = u8:decode("Мужской")},
	[274] = {group = u8:decode("Врач"), 		gender = u8:decode("Мужской")},
	[275] = {group = u8:decode("Врач"), 		gender = u8:decode("Мужской")},
	[276] = {group = u8:decode("Врач"), 		gender = u8:decode("Мужской")},
	[277] = {group = u8:decode("Пожарный"), 	gender = u8:decode("Мужской")},
	[278] = {group = u8:decode("Пожарный"), 	gender = u8:decode("Мужской")},
	[279] = {group = u8:decode("Пожарный"), 	gender = u8:decode("Мужской")},
	[280] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[281] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[282] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[283] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[284] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[285] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[286] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[287] = {group = u8:decode("Военный"), 		gender = u8:decode("Мужской")},
	[288] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[289] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[290] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[291] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[292] = {group = u8:decode("Ацтек"), 		gender = u8:decode("Мужской")},
	[293] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[294] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[295] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[296] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[297] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[298] = {group = u8:decode("Гражданский"), 	gender = u8:decode("Женский")},
	[299] = {group = u8:decode("Гражданский"),  gender = u8:decode("Мужской")},
	[300] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[301] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[302] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[303] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[304] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[305] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[306] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Женский")},
	[307] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Женский")},
	[308] = {group = u8:decode("Врач"), 		gender = u8:decode("Женский")},
	[309] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Женский")},
	[310] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")},
	[311] = {group = u8:decode("Полицейский"), 	gender = u8:decode("Мужской")}
}

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
    repeat wait(0) until sampGetCurrentServerName() ~= "SA-MP"
    repeat wait(0) until sampGetCurrentServerName():find("Samp%-Rp.Ru") or sampGetCurrentServerName():find("SRP")
	repeat wait(0) until sampIsLocalPlayerSpawned()
	server = sampGetCurrentServerName():gsub('|', '')
	server = (server:find('02') and 'Two' or (server:find('Revo') and 'Revolution' or (server:find('Legacy') and 'Legacy' or (server:find('Classic') and 'Classic' or ''))))
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
	
	directStatistics		= string.format("Donatik\\%s\\%s\\DonateMoney.ini", server, my_name)
	directTodayTopDonaters	= string.format("Donatik\\%s\\%s\\todayTopDonaters.ini", server, my_name)
	directDonaters			= string.format("Donatik\\%s\\%s\\Donaters.ini", server, my_name)
	directTodayDonaters		= string.format("Donatik\\%s\\%s\\todayDonaters.ini", server, my_name)
	directSettings			= string.format("Donatik\\%s\\%s\\Settings.ini", server, my_name)
	directDonatersRating	= string.format("Donatik\\%s\\%s\\DonatersRating.ini", server, my_name)
	screenshot_dir = string.format('%s\\SAMP\\%s', screenshot.getUserDirectoryPath(), "Donatik")

	sampRegisterChatCommand("donaters", 		donatik.sendTodayDonaters)		-- список донатеров
	sampRegisterChatCommand("topdonaters", 		donatik.sendTopDonaters)		-- список топ донатеров за все время
	sampRegisterChatCommand("topdonatersziel", 	donatik.sendTopDonatersZiel)	-- список топ донатеров на цель за все время
	sampRegisterChatCommand("todayDonateMoney", donatik.sendTodayDonateMoney)	-- заработанный деньги за сегодня
	sampRegisterChatCommand("DonateMoney", 		donatik.sendDonateMoney)		-- заработанные деньги за все время
	sampRegisterChatCommand("DonateMoneyZiel", 	donatik.sendDonateMoneyZiel)	-- заработанные деньги на цель за все время
	sampRegisterChatCommand("dHudik", 			donatik.hud)					-- полоска худа
	sampRegisterChatCommand("dtop", 			donatik.sendTopToN) 			-- топ донатеров до N
	sampRegisterChatCommand("dtopZiel", 		donatik.sendTopZielToN)			-- топ донатеров на цель до N
	sampRegisterChatCommand('dHud', 
		function() 
			main_window_state.v = not main_window_state.v 
			imgui.Process = main_window_state.v 
		end)
	sampRegisterChatCommand("dcalculate", 
		function()
			sampAddChatMessage("------------------------------------------------------------------------------------------------------------------------------------------------", main_color)
			calculateMoneyForAllTime()
			calculateMoneyForAllTimeOnTheGoal()
			checkDublicates()
			setGenders()
			setAllRanks()
			setAllGroups()
			todayTopDonatersAndMoney()
			script.reload = true
			thisScript():reload()
			sampAddChatMessage("------------------------------------------------------------------------------------------------------------------------------------------------", main_color)
		end)
	
	DonateMoney = string.format('DonateMoney')
	if statistics_ini[DonateMoney] == nil then
		statistics_ini = inicfg.load({
			[DonateMoney] = {
				money    = 0,
				target   = 1000000,
				hud      = false,
				zielName = "1kk"
			}
		}, directStatistics)
		inicfg.save(statistics_ini, directStatistics)
	end
	
	todayTopPlayers = string.format('%s-%s-%s', my_day, my_month, my_year)
	if todayTopDonaters_ini[todayTopPlayers] == nil then
		todayTopDonaters_ini = inicfg.load({
			[todayTopPlayers] = {
				firstName   = u8:decode"Пусто",
				firstSumma  = 0,
				secondName  = u8:decode"Пусто",
				secondSumma = 0,
				thirdName   = u8:decode"Пусто",
				thirdSumma  = 0,
				money = 0,
				count = 0
			}
		}, directTodayTopDonaters)
		inicfg.save(todayTopDonaters_ini, directTodayTopDonaters)
	end
	
	PlayerCount = string.format('Count')
	if donatersRating_ini[PlayerCount] == nil then
		donatersRating_ini = inicfg.load({
			[PlayerCount] = {
				count = 0
			}
		}, directDonatersRating)
		inicfg.save(donatersRating_ini, directDonatersRating)
	end

	resX, resY = getScreenResolution()
	if settings_ini.Settings == nil then
		settings_ini = inicfg.load({
			Settings = {
				DonateNotify        = true,
				DonatersNotify      = true,
				TodayDonatersNotify = true,
				Sound               = false,
				themeId             = 0,
				Switch              = true,
				textLabel           = false,
				DonaterJoined       = false,
				donateSize          = 10000,
				x 					= resX/2,
				y 					= resY/2
			},
			Telegram = {
				token   = " ",
				chat_id	= " ",
				bool	= false
			},
			HotKey = {
				bindDonaters		 = "[18,49]",
				bindTopDonaters		 = "[18,50]",
				bindTopDonatersZiel	 = "[18,51]",
				bindTodayDonateMoney = "[18,52]",
				bindDonateMoney 	 = "[18,53]",
				bindDonateMoneyZiel	 = "[18,54]",
				bindHud 		   	 = "[18,72]"
			},
			MyStyle = {
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
		}, directSettings)
		inicfg.save(settings_ini, directSettings)
	end
	
	AdressFolderZiel = string.format("%s\\moonloader\\config\\Donatik\\%s\\%s\\%s", getGameDirectory(), server, my_name, statistics_ini[DonateMoney].zielName)
	
	if not doesDirectoryExist(AdressFolderZiel) then createDirectory(AdressFolderZiel) end
	
	directDonatersZiel  = string.format("Donatik\\%s\\%s\\%s\\Donaters.ini", server, my_name, statistics_ini[DonateMoney].zielName)
	directStatisticsZiel  = string.format("Donatik\\%s\\%s\\%s\\DonateMoney.ini", server, my_name, statistics_ini[DonateMoney].zielName)
	directDonatersRatingZiel = string.format("Donatik\\%s\\%s\\%s\\DonatersRating.ini", server, my_name, statistics_ini[DonateMoney].zielName)
	
	PlayerZielCount = string.format('Count')
	if donatersRatingZiel_ini[PlayerZielCount] == nil then
		donatersRatingZiel_ini = inicfg.load({
			[PlayerZielCount] = {
				count = 0
			}
		}, directDonatersRatingZiel)
		inicfg.save(donatersRatingZiel_ini, directDonatersRatingZiel)
	end
	
	DonateMoneyZiel = string.format('DonateMoneyZiel')
	if statistics_ziel_ini[DonateMoneyZiel] == nil then
		statistics_ziel_ini = inicfg.load({
			[DonateMoneyZiel] = {
				money  = 0,
				target = statistics_ini[DonateMoney].target,
				count  = 0
			}
		}, directStatisticsZiel)
		inicfg.save(statistics_ziel_ini, directStatisticsZiel)
	end
	
	lua_thread.create(function()
		wait(0)
		imgui.SwitchContext()
		imgui.GetIO().Fonts:Clear()
		glyph_ranges_cyrillic = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
		imgui.GetIO().Fonts:AddFontFromFileTTF("C:/Windows/Fonts/arial.ttf", toScreenX(6), nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
		imgui.RebuildFonts()
		
		imgui.updateMyStyle(settings_ini.Settings.themeId)
	end)

	statistics_ini			= inicfg.load(nil, directStatistics)
	statistics_ziel_ini		= inicfg.load(nil, directStatisticsZiel)
	settings_ini			= inicfg.load(nil, directSettings)
	donaters_ini			= inicfg.load(donaters_ini, directDonaters)
	donatersZiel_ini		= inicfg.load(donatersZiel_ini, directDonatersZiel)
	donatersRating_ini		= inicfg.load(nil, directDonatersRating)
	donatersRatingZiel_ini	= inicfg.load(nil, directDonatersRatingZiel)
	todayDonaters_ini		= inicfg.load(todayDonaters_ini, directTodayDonaters)
	todayTopDonaters_ini	= inicfg.load(nil, directTodayTopDonaters)

	jsonDonaters 			= { v = decodeJson(settings_ini.HotKey.bindDonaters) }
	jsonTopDonaters 		= { v = decodeJson(settings_ini.HotKey.bindTopDonaters) }
	jsonTopDonatersZiel 	= { v = decodeJson(settings_ini.HotKey.bindTopDonatersZiel) }
	jsonTodayDonateMoney 	= { v = decodeJson(settings_ini.HotKey.bindTodayDonateMoney) }
	jsonDonateMoney 		= { v = decodeJson(settings_ini.HotKey.bindDonateMoney) }
	jsonDonateMoneyZiel 	= { v = decodeJson(settings_ini.HotKey.bindDonateMoneyZiel) }
	jsonHud 				= { v = decodeJson(settings_ini.HotKey.bindHud) }
	
	bindDonaters 		 	= rkeys.registerHotKey(jsonDonaters.v, 	  	  true, donatik.sendTodayDonaters)
	bindTopDonaters 	 	= rkeys.registerHotKey(jsonTopDonaters.v, 	  true, donatik.sendTopDonaters)
	bindTopDonatersZiel  	= rkeys.registerHotKey(jsonTopDonatersZiel.v,  true, donatik.sendTopDonatersZiel)
	bindTodayDonateMoney 	= rkeys.registerHotKey(jsonTodayDonateMoney.v, true, donatik.sendTodayDonateMoney)
	bindDonateMoney 	 	= rkeys.registerHotKey(jsonDonateMoney.v, 	  true, donatik.sendDonateMoney)
	bindDonateMoneyZiel  	= rkeys.registerHotKey(jsonDonateMoneyZiel.v,  true, donatik.sendDonateMoneyZiel)
	bindHud 			 	= rkeys.registerHotKey(jsonHud.v, 			  true, donatik.hud)
	
	imgui.initBuffers()
	
	soundManager.loadSound("100k")
	soundManager.loadSound("75k")
	soundManager.loadSound("50k")
	soundManager.loadSound("25k")
	soundManager.loadSound("10k")
	soundManager.loadSound("5k")
	soundManager.loadSound("1k")
	soundManager.loadSound("100")
	soundManager.loadSound("0")
	
	chatManager.initQueue()
	lua_thread.create(chatManager.checkMessagesQueueThread)
	lua_thread.create(tg.getUpdates)
	tg.getLastUpdate()
	checkUpdates()
	donatik.getGroupsCount()
	
	percent = (tonumber(statistics_ziel_ini[DonateMoneyZiel].money)/tonumber(statistics_ziel_ini[DonateMoneyZiel].target))
	
	scriptLoaded = true
	
	imgui.Process = true
	
	sampAddChatMessage(prefix .. u8:decode"Успешно загрузился!", main_color)
	
	if not settings_ini.Settings.Switch then
		sampAddChatMessage(prefix .. u8:decode"Скрипт в данный момент выключен! Включить /dhud > Информация > Включить", main_color)
	end
	
	while true do
		wait(0)
		imgui.ShowCursor = false
		
		if isKeyJustPressed(VK_ESCAPE) and main_window_state.v then
			main_window_state.v = false
		end
		
		if not sampIsDialogActive() and not sampIsChatInputActive() then
			if (isKeyDown(vkeys.VK_MENU) and isKeyJustPressed(vkeys.VK_P)) or isKeyJustPressed(vkeys.VK_PAUSE) then
				sampAddChatMessage(prefix .. u8:decode"Сообщения остановлены", main_color)
				chatManager.initQueue()
			end
		end
		
		donatik.textLabelOverPlayerNickname()
		
		donatik.topDonaterJoined()
	end
end

------------------------------------------ Donatik Functions ------------------------------------------
textlabel = {}
function donatik.textLabelOverPlayerNickname()
	if settings_ini.Settings.textLabel then
		for i = 0, 999 do
			if textlabel[i] ~= nil then
				sampDestroy3dText(textlabel[i])
				textlabel[i] = nil
			end
		end
		for i = 0, 999 do 
			if sampIsPlayerConnected(i) and sampGetPlayerScore(i) ~= 0 then
				donaterNick = sampGetPlayerNickname(i)
				if donaters_ini[donaterNick] ~= nil then
					if donaterNick == donaters_ini[donaterNick].nick then
						if textlabel[i] == nil then
							textlabel[i] = sampCreate3dText(convertNumber(donaters_ini[donaterNick].money) .. " [" .. donatik.getDonaterPlace(donaterNick) .. "]", 0xFFFFFF00, 0.0, 0.0, 0.35, 22, false, i, -1)
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
		for i = 0, 999 do
			if textlabel[i] ~= nil then
				sampDestroy3dText(textlabel[i])
				textlabel[i] = nil
			end
		end
	end
end

donatersOnline = {}
donatersOnlineNickname = {}
function donatik.topDonaterJoined()
	if settings_ini.Settings.DonaterJoined then
		for i = 0, 999 do 
			if sampIsPlayerConnected(i) and sampGetPlayerScore(i) ~= 0 then
				donatersOnlineNickname[i] = sampGetPlayerNickname(i)
				if donaters_ini[donatersOnlineNickname[i]] ~= nil then
					if donatersOnlineNickname[i] == donaters_ini[donatersOnlineNickname[i]].nick then
						if not donatersOnline[i] then
							if tonumber(donaters_ini[donatersOnlineNickname[i]].money) >= tonumber(settings_ini.Settings.donateSize) then
								sampAddChatMessage(prefix .. u8:decode"На сервер зашёл{40E0D0} " .. donaters_ini[donatersOnlineNickname[i]].nick .. " [" .. i .. "]", main_color)
								donatersOnline[i] = true
							end
						end
					end
				end
			else
				if donatersOnline[i] then
					sampAddChatMessage(prefix .. u8:decode"С сервера вышел{40E0D0} " .. donatersOnlineNickname[i], main_color)
					donatersOnline[i] = false
					donatersOnlineNickname[i] = nil
				end
			end
		end
	end
end

function donatik.sortDonatersRating()
	local tempDonaterMoney, tempDonaterNick
	for i = 1, tonumber(donatersRating_ini[PlayerCount].count) do
		for j = 0, tonumber(donatersRating_ini[PlayerCount].count) - i do
			if donatersRating_ini[j] ~= nil and donatersRating_ini[j + 1] ~= nil then
				if tonumber(donatersRating_ini[j].money) < tonumber(donatersRating_ini[j + 1].money) then
					tempDonaterMoney = donatersRating_ini[j].money
					donatersRating_ini[j].money = donatersRating_ini[j + 1].money
					donatersRating_ini[j + 1].money = tempDonaterMoney

					tempDonaterNick = donatersRating_ini[j].nick
					donatersRating_ini[j].nick = donatersRating_ini[j + 1].nick
					donatersRating_ini[j + 1].nick = tempDonaterNick
				end
			end
		end
	end
	inicfg.save(donatersRating_ini, directDonatersRating)
end

function donatik.sortDonatersZielRating()
	local tempDonaterZielMoney, tempDonaterZielNick
	for i = 1, tonumber(donatersRatingZiel_ini[PlayerZielCount].count) do
		for j = 0, tonumber(donatersRatingZiel_ini[PlayerZielCount].count) - i do
			if donatersRatingZiel_ini[j] ~= nil and donatersRatingZiel_ini[j + 1] ~= nil then
				if tonumber(donatersRatingZiel_ini[j].money) < tonumber(donatersRatingZiel_ini[j + 1].money) then
					tempDonaterZielMoney = donatersRatingZiel_ini[j].money
					donatersRatingZiel_ini[j].money = donatersRatingZiel_ini[j + 1].money
					donatersRatingZiel_ini[j + 1].money = tempDonaterZielMoney
					
					tempDonaterZielNick = donatersRatingZiel_ini[j].nick
					donatersRatingZiel_ini[j].nick = donatersRatingZiel_ini[j + 1].nick
					donatersRatingZiel_ini[j + 1].nick = tempDonaterZielNick
				end
			end
		end
	end
	inicfg.save(donatersRatingZiel_ini, directDonatersRatingZiel)
end

function donatik.getDonaterPlace(nickname)
	for i = 0, tonumber(donatersRating_ini[PlayerCount].count) do
		if donatersRating_ini[i] ~= nil then
			if donatersRating_ini[i].nick == nickname then
				return i
			end
		end
	end
end

function donatik.getDonaterZielPlace(nickname)
	for i = 0, tonumber(donatersRatingZiel_ini[PlayerZielCount].count) do
		if donatersRatingZiel_ini[i] ~= nil then
			if donatersRatingZiel_ini[i].nick == nickname then
				return i
			end
		end
	end
end

function donatik.hud()
	statistics_ini[DonateMoney].hud = not statistics_ini[DonateMoney].hud
	printStringNow((statistics_ini[DonateMoney].hud and '~g~DonatikHUD: ON' or '~r~DonatikHUD: OFF'), 2000)
	inicfg.save(statistics_ini, directStatistics)
end

function donatik.sendTodayDonaters()
	chatManager.addMessageToQueue("Список пожертвований от уважаемых людей за сегодня: ", false)
	local rankFirst, rankSecond, rankThird = "Господин", "Господин", "Господин"
	if donaters_ini[todayTopDonaters_ini[todayTopPlayers].firstName] ~= nil then
		rankFirst = u8(donaters_ini[todayTopDonaters_ini[todayTopPlayers].firstName].rank)
	end
	if donaters_ini[todayTopDonaters_ini[todayTopPlayers].secondName] ~= nil then
		rankSecond = u8(donaters_ini[todayTopDonaters_ini[todayTopPlayers].secondName].rank)
	end
	if donaters_ini[todayTopDonaters_ini[todayTopPlayers].thirdName] ~= nil then
		rankThird = u8(donaters_ini[todayTopDonaters_ini[todayTopPlayers].thirdName].rank)
	end

	chatManager.addMessageToQueue("1. " .. rankFirst  .. " " .. u8(todayTopDonaters_ini[todayTopPlayers].firstName)  .. " с суммой " .. convertNumber(todayTopDonaters_ini[todayTopPlayers].firstSumma)  .. " вирт", false)
	chatManager.addMessageToQueue("2. " .. rankSecond .. " " .. u8(todayTopDonaters_ini[todayTopPlayers].secondName) .. " с суммой " .. convertNumber(todayTopDonaters_ini[todayTopPlayers].secondSumma) .. " вирт", false)
	chatManager.addMessageToQueue("3. " .. rankThird  .. " " .. u8(todayTopDonaters_ini[todayTopPlayers].thirdName)  .. " с суммой " .. convertNumber(todayTopDonaters_ini[todayTopPlayers].thirdSumma)  .. " вирт", false)
	chatManager.addMessageToQueue("Чтобы занять определенное место в списке, необходимо пожертвовать больше денег", false)
end

function donatik.sendTopDonaters()
	chatManager.addMessageToQueue("Список пожертвований от уважаемых людей за все время: ", false)
	for i = 1, 3 do
		donatersRating_ini = inicfg.load(i, directDonatersRating)
		if donatersRating_ini[i] ~= nil then
			if donaters_ini[donatersRating_ini[i].nick] ~= nil then
				chatManager.addMessageToQueue(i .. ". " .. u8(donaters_ini[donatersRating_ini[i].nick].rank) .. " " .. donatersRating_ini[i].nick .. " с суммой " .. convertNumber(donatersRating_ini[i].money) .. " вирт", false)
			else
				chatManager.addMessageToQueue(i .. ". Господин " .. donatersRating_ini[i].nick .. " с суммой " .. convertNumber(donatersRating_ini[i].money) .. " вирт", false)
			end
		else
			chatManager.addMessageToQueue(i .. ". Господин Пусто с суммой 0 вирт", false)
		end
	end
	chatManager.addMessageToQueue("Чтобы занять определенное место в списке, необходимо пожертвовать больше денег", false)
end

function donatik.sendTopDonatersZiel()
	chatManager.addMessageToQueue("Список пожертвований от уважаемых людей на \"" .. statistics_ini[DonateMoney].zielName .. "\" за все время", false)
	for i = 1, 3 do
		donatersRatingZiel_ini = inicfg.load(i, directDonatersRatingZiel)
		if donatersRatingZiel_ini[i] ~= nil then
			if donaters_ini[donatersRatingZiel_ini[i].nick] ~= nil then
				chatManager.addMessageToQueue(i .. ". " .. u8(donaters_ini[donatersRatingZiel_ini[i].nick].rank) .. " " .. donatersRatingZiel_ini[i].nick .. " с суммой " .. convertNumber(donatersRatingZiel_ini[i].money) .. " вирт", false)
			else
				chatManager.addMessageToQueue(i .. ". Господин " .. donatersRatingZiel_ini[i].nick .. " с суммой " .. convertNumber(donatersRatingZiel_ini[i].money) .. " вирт", false)
			end
		else
			chatManager.addMessageToQueue(i .. ". Господин Пусто с суммой 0 вирт", false)
		end
	end
	chatManager.addMessageToQueue("Чтобы занять определенное место в списке, необходимо пожертвовать больше денег", false)
end

function donatik.sendTodayDonateMoney()
	chatManager.addMessageToQueue("Всего за день собрано: " .. convertNumber(todayTopDonaters_ini[todayTopPlayers].money), true)
end

function donatik.sendDonateMoney()
	chatManager.addMessageToQueue("Денег собрано за все время: " .. convertNumber(statistics_ini[DonateMoney].money), true)
end

function donatik.sendDonateMoneyZiel()
	chatManager.addMessageToQueue(string.format("Денег на цель \"%s\" собрано: %s/%s [%s]", statistics_ini[DonateMoney].zielName, convertNumber(statistics_ziel_ini[DonateMoneyZiel].money), convertNumber(statistics_ziel_ini[DonateMoneyZiel].target), string.sub(tostring(percent * 100), 1, 5)), true)
end

function donatik.sendTopToN(arg)
	if arg ~= nil and arg ~= "" then
		chatManager.addMessageToQueue("Список пожертвований от уважаемых людей за все время до " .. arg .. " места", false)
		for i = 0, arg do
			donatersRating_ini = inicfg.load(i, directDonatersRating)
			if donatersRating_ini[i] ~= nil then
				if donaters_ini[donatersRating_ini[i].nick] ~= nil then
					chatManager.addMessageToQueue(i .. ". " .. u8(donaters_ini[donatersRating_ini[i].nick].rank) .. " " .. donatersRating_ini[i].nick .. " с суммой " .. convertNumber(donatersRating_ini[i].money) .. " вирт", false)
				end
			end
		end
		chatManager.addMessageToQueue("Всего " .. convertNumber(donatersRating_ini[PlayerCount].count) .. " пожертвующих", false)
	end
end

function donatik.sendTopZielToN(arg)
	if arg ~= nil and arg ~= "" then
		chatManager.addMessageToQueue("Список пожертвований от уважаемых людей на \"" .. statistics_ini[DonateMoney].zielName .. "\" за все время до" .. arg .. " места", false)
		for i = 0, arg do
			donatersRatingZiel_ini = inicfg.load(i, directDonatersRatingZiel)
			if donatersRatingZiel_ini[i] ~= nil then
				if donaters_ini[donatersRatingZiel_ini[i].nick] ~= nil then
					chatManager.addMessageToQueue(i .. ". " .. u8(donaters_ini[donatersRatingZiel_ini[i].nick].rank) .. " " .. donatersRatingZiel_ini[i].nick .. " с суммой " .. convertNumber(donatersRatingZiel_ini[i].money) .. " вирт", false)
				end
			end
		end
		chatManager.addMessageToQueue("Всего " .. convertNumber(donatersRatingZiel_ini[PlayerCount].count) .. " пожертвующих", false)
	end
end

function donatik.sendSelectedDayDonaters(d, m, y, firstName, firstSumma, secondName, secondSumma, thirdName, thirdSumma)
	chatManager.addMessageToQueue(string.format("Список пожертвований от уважаемых людей за %s.%s.%s", d, m, y), false)
	
	local rankFirst, rankSecond, rankThird = "", "", ""
	if donaters_ini[firstName] ~= nil then
		rankFirst = u8(donaters_ini[firstName].rank)
	end
	if donaters_ini[secondName] ~= nil then
		rankSecond = u8(donaters_ini[secondName].rank)
	end
	if donaters_ini[thirdName] ~= nil then
		rankThird = u8(donaters_ini[thirdName].rank)
	end

	chatManager.addMessageToQueue("1. " .. rankFirst  .. " " .. u8(firstName)  .. " с суммой " .. convertNumber(firstSumma)  .. " вирт", false)
	chatManager.addMessageToQueue("2. " .. rankSecond .. " " .. u8(secondName) .. " с суммой " .. convertNumber(secondSumma) .. " вирт", false)
	chatManager.addMessageToQueue("3. " .. rankThird  .. " " .. u8(thirdName)  .. " с суммой " .. convertNumber(thirdSumma)  .. " вирт", false)
end

function donatik.sendDonaterInfo(PlayerName)
	Player = string.format('%s', PlayerName)
	if donaters_ini[Player] == nil then
		chatManager.addMessageToQueue(PlayerName .. " в базе данных не обнаружен", false)
	else
		if donatik.getDonaterZielPlace(donaters_ini[Player].nick) ~= nil then
			chatManager.addMessageToQueue(u8(donaters_ini[Player].rank) .. " " .. donaters_ini[Player].nick .. " находится на " .. donatik.getDonaterPlace(donaters_ini[Player].nick) .. " месте в списке за все время и на " .. donatik.getDonaterZielPlace(donaters_ini[Player].nick) .. " в списке на цель \"" .. statistics_ini[DonateMoney].zielName .. "\"", false)
		else
			chatManager.addMessageToQueue(u8(donaters_ini[Player].rank) .. " " .. donaters_ini[Player].nick .. " находится на " .. donatik.getDonaterPlace(donaters_ini[Player].nick) .. " месте в списке за все время", false)
		end
		
		chatManager.addMessageToQueue("Сумма пожертвований за все время составляет: " .. convertNumber(donaters_ini[Player].money), false)

		if donatersZiel_ini[Player] ~= nil then
			chatManager.addMessageToQueue("На цель \"" .. statistics_ini[DonateMoney].zielName .. "\" составляет: " .. convertNumber(donatersZiel_ini[Player].money), false)
		end
		todayPlayer = string.format('%s-%s-%s-%s', my_day, my_month, my_year, PlayerName)

		if todayDonaters_ini[todayPlayer] == nil then
			chatManager.addMessageToQueue("Сегодня пожертвований не было", false)
		else
			chatManager.addMessageToQueue("За сегодня составляет: " .. convertNumber(todayDonaters_ini[todayPlayer].money), false)
		end
	end
end

function donatik.setRank(nick)
	money = tonumber(donaters_ini[nick].money)
	if money >= 1000000 then
		donaters_ini[nick].rank = u8:decode("Легенда")
	elseif money >= 500000 and money < 1000000 then
		donaters_ini[nick].rank = u8:decode("Меценат")
	elseif money >= 250000 and money < 500000 then
		donaters_ini[nick].rank = u8:decode("Спонсор")
	elseif money >= 100000 and money < 250000 then
		donaters_ini[nick].rank = u8:decode("Щедрая душа")
	elseif money >= 50000 and money < 100000 then
		if donaters_ini[nick].gender == u8:decode("Мужской") then donaters_ini[nick].rank = u8:decode("Покровитель") else donaters_ini[nick].rank = u8:decode("Покровительница") end
	elseif money >= 25000 and money < 50000 then
		donaters_ini[nick].rank = u8:decode("Филантроп")
	elseif money >= 10000 and money < 25000 then
		if donaters_ini[nick].gender == u8:decode("Мужской") then donaters_ini[nick].rank = u8:decode("Господин") else donaters_ini[nick].rank = u8:decode("Госпожа") end
	elseif money >= 5000 and money < 10000 then
		if donaters_ini[nick].gender == u8:decode("Мужской") then donaters_ini[nick].rank = u8:decode("Уважаемый") else donaters_ini[nick].rank = u8:decode("Уважаемая") end
	elseif money >= 1000 and money < 5000 then
		donaters_ini[nick].rank = u8:decode("Доброжелатель")
	elseif money >= 500 and money < 1000 then
		donaters_ini[nick].rank = u8:decode("Добряк")
	elseif money > 0 and money < 500 then
		donaters_ini[nick].rank = u8:decode("Бомжик")
	elseif money == 0 then
		donaters_ini[nick].rank = u8:decode("Нулевый")
	elseif money < 0 then
		donaters_ini[nick].rank = u8:decode("Должник")
	else
		donaters_ini[nick].rank = u8:decode("Неизвестно")
	end
	inicfg.save(donaters_ini, directDonaters)
end

function donatik.getGroupsCount()
	groupsDiagram = {
		{
			v = 0,
			name = u8:decode('Гражданский'),
			color = 0xFFFFFFFF
		},
		{
			v = 0,
			name = u8:decode('Грув'),
			color = 0xFF00FF00
		},
		{
			v = 0,
			name = u8:decode('Баллас'),
			color = 0xFF990099
		},
		{
			v = 0,
			name = u8:decode('Вагос'),
			color = 0xFF00FFFF
		},
		{
			v = 0,
			name = u8:decode('Ацтек'),
			color = 0xFFFFFF00
		},
		{
			v = 0,
			name = u8:decode('Рифа'),
			color = 0xFFFF8000
		},
		{
			v = 0,
			name = u8:decode('РМ'),
			color = 0xFFE0E0E0
		},
		{
			v = 0,
			name = u8:decode('ЛКН'),
			color = 0xFF66B2FF
		},
		{
			v = 0,
			name = u8:decode('Якудза'),
			color = 0xFF0000FF
		},
		{
			v = 0,
			name = u8:decode('Байкер'),
			color = 0xFF606060
		},
		{
			v = 0,
			name = u8:decode('Врач'),
			color = 0xFFFFCCE5
		},
		{
			v = 0,
			name = u8:decode('Военный'),
			color = 0xFF336600
		},
		{
			v = 0,
			name = u8:decode('Полицейский'),
			color = 0xFF8B0000
		}
	}

	gendersDiagram = {
		{
			v = 0,
			name = u8:decode('Женский'),
			color = 0xFFFF66CC
		},
		{
			v = 0,
			name = u8:decode('Мужской'),
			color = 0xFFFF0066
		}
	}
	
	for key, val in pairs(groupsDiagram) do
		local groupCount = 0
		for i = 1, donatersRating_ini.Count.count do
			if donaters_ini[donatersRating_ini[i].nick] ~= nil then
				if val["name"] == donaters_ini[donatersRating_ini[i].nick].group then
					groupCount = groupCount + 1
				end
			end
		end
		val["v"] = groupCount
	end
	
	for key, val in pairs(gendersDiagram) do
		local genderCount = 0
		for i = 1, donatersRating_ini.Count.count do
			if donaters_ini[donatersRating_ini[i].nick] ~= nil then
				if val["name"] == donaters_ini[donatersRating_ini[i].nick].gender then
					genderCount = genderCount + 1
				end
			end
		end
		val["v"] = genderCount
	end
end

------------------------------------------ Control Functions ------------------------------------------
function convertNumber(num)
	minus = false
	if num == nil then
		return 0
	end
	if tonumber(num) < 0 then
		num = -num
		minus = true
	end
	l = string.len(num)
	if l <= 3 then
		return num
	end
	if l <= 6 and l > 3 then
		count = math.floor(num / 1000) ost = math.fmod(num, 1000) zahl = string.format("%s.%s", count, ost)
	end
	if l <= 6 and l > 3 then
		count = math.floor(num / 1000) ost = math.fmod(num, 1000) if ost == 0 then ost = "000" end if tonumber(ost) > 0 and tonumber(ost) < 10 then ost2 = ost ost = string.format("00%s", ost2) end if tonumber(ost) > 10 and tonumber(ost) < 100 then ost2 = ost ost = string.format("0%s", ost2) end zahl = string.format("%s.%s", count, ost)
	end
	if l <= 9 and l > 6 then
		count = math.floor(num / 1000000) ost = math.floor(math.fmod(num, 1000000)/1000)  if ost == 0 then ost = "000" end if tonumber(ost) > 0 and tonumber(ost) < 10 then ost3 = ost ost = string.format("00%s", ost3) end if tonumber(ost) > 10 and tonumber(ost) < 100 then ost3 = ost ost = string.format("0%s", ost3) end ost2 = math.fmod(math.fmod(num, 1000000), 1000) if ost2 == 0 then ost2 = "000" end if tonumber(ost2) > 0 and tonumber(ost2) < 10 then ost4 = ost2 ost2 = string.format("00%s", ost4) end if tonumber(ost2) > 10 and tonumber(ost2) < 100 then ost4 = ost2 ost2 = string.format("0%s", ost4) end zahl = string.format("%s.%s.%s", count, ost, ost2)
	end
	if minus then
		return "-" .. zahl
	else
		return zahl
	end
end

function isNumber(num)
    return type(tonumber(num)) == "number"
end

function round(num)
	if num >= 0 then
		if select(2, math.modf(num)) >= 0.5 then
			return math.ceil(num)
		else
			return math.floor(num)
		end
	else
		if select(2, math.modf(num)) >= 0.5 then
			return math.floor(num)
		else
			return math.ceil(num)
		end
	end
end

function calculateMoneyForAllTime()
	local money = 0
	for i = 1, tonumber(donatersRating_ini[PlayerCount].count) do
		money = money + donatersRating_ini[i].money
	end
	if statistics_ini[DonateMoney].money ~= money then
		sampAddChatMessage(u8:decode(prefix.."Разница денег за все время составляет: " .. statistics_ini[DonateMoney].money - money), main_color)
		statistics_ini[DonateMoney].money = money
		if inicfg.save(statistics_ini, directStatistics) then
			sampAddChatMessage(u8:decode(prefix.."Перезаписано"), main_color)
		end
	else
		sampAddChatMessage(u8:decode(prefix .. "Денег за все время: " .. convertNumber(money) .. " от " .. donatersRating_ini[PlayerCount].count .. " игроков"), main_color)
	end
end

function calculateMoneyForAllTimeOnTheGoal()
	local money = 0
	for i = 1, tonumber(donatersRatingZiel_ini[PlayerZielCount].count) do
		money = money + donatersRatingZiel_ini[i].money
	end
	if statistics_ziel_ini[DonateMoneyZiel].money ~= money then
		sampAddChatMessage(u8:decode(prefix.."Разница денег на цель составляет: " .. statistics_ziel_ini[DonateMoneyZiel].money - money), main_color)
		statistics_ziel_ini[DonateMoneyZiel].money = money
		if inicfg.save(statistics_ziel_ini, directStatisticsZiel) then
			sampAddChatMessage(u8:decode(prefix.."Перезаписано"), main_color)
		end
	else
		sampAddChatMessage(u8:decode(prefix .. "Денег на цель за все время: " .. convertNumber(money) .. " от " .. donatersRatingZiel_ini[PlayerZielCount].count .. " игроков"), main_color)
	end
end

function checkDublicates()
	dublicates = {}
	for i = 1, donatersRating_ini[PlayerCount].count do
		dublicateCount = 0
		for j = 1, donatersRating_ini[PlayerCount].count do
			if donatersRating_ini[i].nick == donatersRating_ini[j].nick then
				dublicateCount = dublicateCount + 1
				if dublicateCount > 1 then
					dublicates[#dublicates + 1] = donatersRating_ini[i].nick
					donatersRating_ini[i].money = -100
				end
			end
		end
	end
	if #dublicates > 0 then
		sampAddChatMessage(prefix..u8:decode"Дубликаты в общем рейтинге: ", main_color)
		donatik.sortDonatersRating()
	else
		sampAddChatMessage(u8:decode(prefix.."Дубликаты в рейтинге за все время не найдены!"), main_color)
	end
	for i = 1, #dublicates do
		sampAddChatMessage(prefix..dublicates[i], main_color)
	end

	dublicates = {}
	for i = 1, donatersRatingZiel_ini[PlayerCount].count do
		dublicateCount = 0
		for j = 1, donatersRatingZiel_ini[PlayerCount].count do
			if donatersRatingZiel_ini[i].nick == donatersRatingZiel_ini[j].nick then
				dublicateCount = dublicateCount + 1
				if dublicateCount > 1 then
					dublicates[#dublicates + 1] = donatersRatingZiel_ini[i].nick
					donatersRatingZiel_ini[i].money = -100
				end
			end
		end
	end
	if #dublicates > 0 then
		sampAddChatMessage(prefix..u8:decode"Дубликаты в рейтинге цели: ", main_color)
		donatik.sortDonatersZielRating()
	else
		sampAddChatMessage(u8:decode(prefix.."Дубликаты в рейтинге на цель не найдены!"), main_color)
	end
	for i = 1, #dublicates do
		sampAddChatMessage(prefix..dublicates[i], main_color)
	end
end

function setAllRanks()
	for i = 1, donatersRating_ini.Count.count do
		if donaters_ini[donatersRating_ini[i].nick] ~= nil then
			donatik.setRank(donatersRating_ini[i].nick)
		end
	end
	sampAddChatMessage(u8:decode(prefix.."Ранги добавлены!"), main_color)
end

function setAllGroups()
	for i = 1, donatersRating_ini.Count.count do
		if donaters_ini[donatersRating_ini[i].nick] ~= nil then
			donaters_ini[donatersRating_ini[i].nick].group = u8:decode("Гражданский")
		end
	end
	inicfg.save(donaters_ini, directDonaters)
	sampAddChatMessage(u8:decode(prefix.."Группы добавлены!"), main_color)
end

function setGenders()
	for i = 1, donatersRating_ini.Count.count do
		if donaters_ini[donatersRating_ini[i].nick] ~= nil then
			if donaters_ini[donatersRating_ini[i].nick].gender == u8:decode("Господин") then
				donaters_ini[donatersRating_ini[i].nick].gender = u8:decode("Мужской")
			elseif donaters_ini[donatersRating_ini[i].nick].gender == u8:decode("Госпожа") then
				donaters_ini[donatersRating_ini[i].nick].gender = u8:decode("Женский")
			else
				donaters_ini[donatersRating_ini[i].nick].gender = u8:decode("Мужской")
			end
		end
	end
	inicfg.save(donaters_ini, directDonaters)
end

function todayTopDonatersAndMoney()
	ini = {}
	directTodayDonateMoney = string.format("Donatik\\%s\\%s\\todayDonateMoney.ini", server, my_name)
	ini	= inicfg.load(ini, directTodayDonateMoney)
	for y = 2038, 2020, -1 do
		for m = 12, 1, -1 do
			for d = 31, 1, -1 do
				if tonumber(d) > 0 and tonumber(d) < 10 then d = string.format('0%d', d) end
				if tonumber(m) > 0 and tonumber(m) < 10 then m = string.format('0%d', m) end
				selectedDay = string.format('%s-%s-%s', d, m, y)
				if todayTopDonaters_ini[selectedDay] ~= nil and todayTopDonaters_ini[selectedDay].firstSumma ~= 0 then
					if todayTopDonaters_ini[selectedDay] ~= nil and todayTopDonaters_ini[selectedDay].money ~= 0 then
						todayTopDonaters_ini[selectedDay].money = ini[selectedDay].money
						todayTopDonaters_ini[selectedDay].count = ini[selectedDay].count
					end
				end
			end
		end
	end
	sampAddChatMessage(u8:decode(prefix.."Файлы объединены!"), main_color)
	inicfg.save(todayTopDonaters_ini, directTodayTopDonaters)
end

function sampev.onServerMessage(color, text)
	if scriptLoaded then
		if settings_ini.Settings.Switch then
			if string.find(text, u8:decode"^ Вы получили .+ вирт, от .+%[%d+%]$") or string.find(text, u8:decode"^ Вы получили .+ вирт, на счет от .+$") then
				local donater = {}
				donater.money = string.match(text, u8:decode"Вы получили (%d+) вирт")
				donater.gender = u8:decode("Мужской")
				donater.rank = u8:decode("Господин")
				
				if string.find(text, u8:decode"^ Вы получили .+ вирт, на счет от .+$") then 
					sampAddChatMessage(prefix .. u8:decode"Денежный перевод на счет!", main_color)
					donater.nick = string.match(text, u8:decode"от (.+)% %[")
				elseif string.find(text, u8:decode"^ Вы получили .+ вирт, от .+$") then
					donater.nick = string.match(text, u8:decode"от (.+)%[")
					peds = getAllChars()
					for k, ped in pairs(peds) do
						if doesCharExist(ped) then
							result, pedID = sampGetPlayerIdByCharHandle(ped)
							if result and sampGetPlayerNickname(pedID) == donater.nick then
								idSkin = getCharModel(ped)
								donater.gender = skins[idSkin].gender
								donater.group  = skins[idSkin].group
								break
							end
						end
					end
				end
				
				if settings_ini.Telegram.bool then
					tg.sendPhoto(text)
				end
				
				if settings_ini.Settings.DonateNotify then
					if tonumber(donater.money) >= 1000000 then
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {FF0000}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {FF0000}" .. donater.nick), main_color) -- red
						if settings_ini.Settings.Sound then soundManager.playSound("1k") end				
					elseif tonumber(donater.money) >= 500000 and tonumber(donater.money) < 1000000 then
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {FF0000}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {FF0000}" .. donater.nick), main_color) -- red
						if settings_ini.Settings.Sound then soundManager.playSound("500k") end
					elseif tonumber(donater.money) >= 250000 and tonumber(donater.money) < 500000 then
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {FF0000}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {FF0000}" .. donater.nick), main_color) -- red
						if settings_ini.Settings.Sound then soundManager.playSound("250k") end
					elseif tonumber(donater.money) >= 100000 and tonumber(donater.money) < 250000 then
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {FF0000}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {FF0000}" .. donater.nick), main_color) -- red
						if settings_ini.Settings.Sound then soundManager.playSound("100k") end
					elseif tonumber(donater.money) >= 75000 and tonumber(donater.money) < 100000 then
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {FF1493}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {FF1493}" .. donater.nick), main_color) -- yellow
						if settings_ini.Settings.Sound then soundManager.playSound("75k") end
					elseif tonumber(donater.money) >= 50000 and tonumber(donater.money) < 75000 then
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {FF00FF}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {FF00FF}" .. donater.nick), main_color) -- pink
						if settings_ini.Settings.Sound then soundManager.playSound("50k") end
					elseif tonumber(donater.money) >= 25000 and tonumber(donater.money) < 50000 then
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {800080}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {800080}" .. donater.nick), main_color) -- purple
						if settings_ini.Settings.Sound then soundManager.playSound("25k") end
					elseif tonumber(donater.money) >= 10000 and tonumber(donater.money) < 25000 then
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {0000FF}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {0000FF}" .. donater.nick), main_color) -- blue
						if settings_ini.Settings.Sound then soundManager.playSound("10k") end
					elseif tonumber(donater.money) >= 5000 and tonumber(donater.money) < 10000 then
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {00FFFF}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {00FFFF}" .. donater.nick), main_color) -- aqua
						if settings_ini.Settings.Sound then soundManager.playSound("5k") end
					elseif tonumber(donater.money) >= 1000 and tonumber(donater.money) < 5000 then
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {00FF00}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {00FF00}" .. donater.nick), main_color) -- green
						if settings_ini.Settings.Sound then soundManager.playSound("1k") end
					elseif tonumber(donater.money) >= 100 and tonumber(donater.money) < 1000 then
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {808000}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {808000}" .. donater.nick), main_color) -- olive
						if settings_ini.Settings.Sound then soundManager.playSound("100") end
					elseif tonumber(donater.money) < 100 then
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {556B2F}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {556B2F}" .. donater.nick), main_color) -- dark olive
						if settings_ini.Settings.Sound then soundManager.playSound("0") end
					else
						sampAddChatMessage(u8:decode(prefix .. "Вы получили {FF00FF}" .. convertNumber(donater.money) .. " {FFFFFF}вирт от {FF00FF}" .. donater.nick), main_color) -- purple Magenta
					end
				end
				
				statistics_ini[DonateMoney].money = statistics_ini[DonateMoney].money + donater.money
				inicfg.save(statistics_ini, directStatistics)
				
				todayTopDonaters_ini[todayTopPlayers].money = todayTopDonaters_ini[todayTopPlayers].money + donater.money
				inicfg.save(todayTopDonaters_ini, directTodayTopDonaters)
				
				statistics_ziel_ini[DonateMoneyZiel].money = statistics_ziel_ini[DonateMoneyZiel].money + donater.money
				inicfg.save(statistics_ziel_ini, directStatisticsZiel)
				
				Player = string.format('%s', donater.nick)
				if donaters_ini[Player] == nil then
					donaters_ini = inicfg.load({
						[Player] = {
							nick   = donater.nick,
							money  = donater.money,
							gender = donater.gender,
							group  = donater.group,
							rank   = donater.rank,
							sms    = false
						}
					}, directDonaters)
					if settings_ini.Settings.DonatersNotify then
						--if u8:decode(gender) == u8:decode"Господин" then 
						--	sampAddChatMessage(u8:decode(prefix .. "Господин {40E0D0}" .. donater.nick .. "{FFFFFF} был добавлен в базу данных"), main_color)
						--else
						--	sampAddChatMessage(u8:decode(prefix .. "Госпожа {40E0D0}" .. donater.nick .. "{FFFFFF} была добавлена в базу данных"), main_color)
						--end
						sampAddChatMessage(u8:decode(prefix .. "Сумма пожертвований от {40E0D0}" .. donater.nick .. "{FFFFFF} составляет: {40E0D0}" .. convertNumber(donaters_ini[Player].money)), main_color)
					end
					
					PlayerRating = string.format('%d', donatersRating_ini[PlayerCount].count + 1)
					if donatersRating_ini[PlayerRating] == nil then
						donatersRating_ini = inicfg.load({
							[PlayerRating] = {
								nick  = donater.nick,
								money = donater.money,
							}
						}, directDonatersRating)
						
						donatersRating_ini[PlayerCount].count = donatersRating_ini[PlayerCount].count + 1
						inicfg.save(donatersRating_ini, directDonatersRating)
						donatersRating_ini = inicfg.load(donatersRating_ini[PlayerCount].count, directDonatersRating)
					else
						lua_thread.create(function() 
							for i = 0, tonumber(donatersRating_ini[PlayerCount].count + 1) do
								if donatersRating_ini[i] ~= nil then
									if donatersRating_ini[i].nick == donater.nick then
										donatersRating_ini[i].money = donatersRating_ini[i].money + donater.money
										inicfg.save(donatersRating_ini, directDonatersRating)
									end
								end
							end 
						end)
					end
				else
					donaters_ini[Player].money = donaters_ini[Player].money + donater.money
					donaters_ini[Player].group = donater.group
					if settings_ini.Settings.DonatersNotify then
						sampAddChatMessage(u8:decode(prefix .. "Сумма пожертвований за все время от {40E0D0}" .. donater.nick .. "{FFFFFF} составляет: {40E0D0}" .. convertNumber(donaters_ini[Player].money)), main_color)
					end
					lua_thread.create(function() 
						for i = 0, tonumber(donatersRating_ini[PlayerCount].count + 1) do
							if donatersRating_ini[i] ~= nil then
								if donatersRating_ini[i].nick == donater.nick then
									donatersRating_ini[i].money = donatersRating_ini[i].money + donater.money
									inicfg.save(donatersRating_ini, directDonatersRating)
								end
							end
						end 
					end)
				end
				donatik.setRank(donater.nick)
				inicfg.save(donaters_ini, directDonaters)
					
				PlayerZiel = string.format('%s', donater.nick)
				if donatersZiel_ini[PlayerZiel] == nil then
					donatersZiel_ini = inicfg.load({
						[PlayerZiel] = {
							nick  = donater.nick,
							money = donater.money
						}
					}, directDonatersZiel)
					
					PlayerZielRating = string.format('%d', donatersRatingZiel_ini[PlayerZielCount].count + 1)
					if donatersRatingZiel_ini[PlayerZielRating] == nil then
						donatersRatingZiel_ini = inicfg.load({
							[PlayerZielRating] = {
								nick  = donater.nick,
								money = donater.money
							}
						}, directDonatersRatingZiel)
					end
					donatersRatingZiel_ini[PlayerZielCount].count = donatersRatingZiel_ini[PlayerZielCount].count + 1
					inicfg.save(donatersRatingZiel_ini, directDonatersRatingZiel)
					statistics_ziel_ini[DonateMoneyZiel].count = statistics_ziel_ini[DonateMoneyZiel].count + 1
					inicfg.save(statistics_ziel_ini, directStatisticsZiel)
					donatersRatingZiel_ini = inicfg.load(donatersRatingZiel_ini[PlayerZielCount].count, directDonatersRatingZiel)
				else
					donatersZiel_ini[PlayerZiel].money = donatersZiel_ini[PlayerZiel].money + donater.money
					lua_thread.create(function() for i = 0, tonumber(donatersRatingZiel_ini[PlayerZielCount].count + 1) do
						if donatersRatingZiel_ini[i] ~= nil then
							if donatersRatingZiel_ini[i].nick == donater.nick then
								donatersRatingZiel_ini[i].money = donatersRatingZiel_ini[i].money + donater.money
								inicfg.save(donatersRatingZiel_ini, directDonatersRatingZiel)
							end
						end
					end end)
				end
				
				inicfg.save(donatersZiel_ini, directDonatersZiel)
				
				todayPlayer = string.format('%s-%s-%s-%s', my_day, my_month, my_year, donater.nick)
				if todayDonaters_ini[todayPlayer] == nil then
					todayDonaters_ini = inicfg.load({
						[todayPlayer] = {
							nick  = donater.nick,
							money = donater.money
						}
					}, directTodayDonaters)
					if settings_ini.Settings.TodayDonatersNotify then
						sampAddChatMessage(u8:decode(prefix .. "Сумма пожертвований за сегодня от {40E0D0}" .. donater.nick .. "{FFFFFF} составляет: {40E0D0}" .. convertNumber(todayDonaters_ini[todayPlayer].money)), main_color)
					end
					todayTopDonaters_ini[todayTopPlayers].count = todayTopDonaters_ini[todayTopPlayers].count + 1
					inicfg.save(todayTopDonaters_ini, directTodayTopDonaters)
				else
					todayDonaters_ini[todayPlayer].money = todayDonaters_ini[todayPlayer].money + donater.money
					if settings_ini.Settings.TodayDonatersNotify then
						sampAddChatMessage(u8:decode(prefix .. "Сумма пожертвований за сегодня от {40E0D0}" .. donater.nick .. "{FFFFFF} составляет: {40E0D0}" .. convertNumber(todayDonaters_ini[todayPlayer].money)), main_color)
					end
				end
				inicfg.save(todayDonaters_ini, directTodayDonaters)
				
				if tonumber(todayDonaters_ini[todayPlayer].money) > tonumber(todayTopDonaters_ini[todayTopPlayers].firstSumma) then
					if todayTopDonaters_ini[todayTopPlayers].firstName ~= todayDonaters_ini[todayPlayer].nick then
						if todayTopDonaters_ini[todayTopPlayers].secondName ~= todayDonaters_ini[todayPlayer].nick then
							todayTopDonaters_ini[todayTopPlayers].thirdSumma = todayTopDonaters_ini[todayTopPlayers].secondSumma
							todayTopDonaters_ini[todayTopPlayers].secondSumma = todayTopDonaters_ini[todayTopPlayers].firstSumma
							todayTopDonaters_ini[todayTopPlayers].thirdName = todayTopDonaters_ini[todayTopPlayers].secondName
							todayTopDonaters_ini[todayTopPlayers].secondName = todayTopDonaters_ini[todayTopPlayers].firstName
							todayTopDonaters_ini[todayTopPlayers].firstSumma = todayDonaters_ini[todayPlayer].money
							todayTopDonaters_ini[todayTopPlayers].firstName = donater.nick
						else
							todayTopDonaters_ini[todayTopPlayers].secondName = todayTopDonaters_ini[todayTopPlayers].firstName
							todayTopDonaters_ini[todayTopPlayers].secondSumma = todayTopDonaters_ini[todayTopPlayers].firstSumma
							todayTopDonaters_ini[todayTopPlayers].firstSumma = todayDonaters_ini[todayPlayer].money
							todayTopDonaters_ini[todayTopPlayers].firstName = donater.nick
						end
					else
						todayTopDonaters_ini[todayTopPlayers].firstSumma = todayDonaters_ini[todayPlayer].money
					end
				elseif tonumber(todayDonaters_ini[todayPlayer].money) > tonumber(todayTopDonaters_ini[todayTopPlayers].secondSumma) and tonumber(todayDonaters_ini[todayPlayer].money) <= tonumber(todayTopDonaters_ini[todayTopPlayers].firstSumma) then
					if todayTopDonaters_ini[todayTopPlayers].secondName ~= todayDonaters_ini[todayPlayer].nick then
						todayTopDonaters_ini[todayTopPlayers].thirdSumma = todayTopDonaters_ini[todayTopPlayers].secondSumma
						todayTopDonaters_ini[todayTopPlayers].thirdName = todayTopDonaters_ini[todayTopPlayers].secondName
						todayTopDonaters_ini[todayTopPlayers].secondSumma = todayDonaters_ini[todayPlayer].money
						todayTopDonaters_ini[todayTopPlayers].secondName = donater.nick
					else
						todayTopDonaters_ini[todayTopPlayers].secondSumma = todayDonaters_ini[todayPlayer].money
					end
				elseif tonumber(todayDonaters_ini[todayPlayer].money) > tonumber(todayTopDonaters_ini[todayTopPlayers].thirdSumma) and tonumber(todayDonaters_ini[todayPlayer].money) <= tonumber(todayTopDonaters_ini[todayTopPlayers].secondSumma) then
					if todayTopDonaters_ini[todayTopPlayers].thirdName ~= todayDonaters_ini[todayPlayer].nick then
						todayTopDonaters_ini[todayTopPlayers].thirdSumma = todayDonaters_ini[todayPlayer].money
						todayTopDonaters_ini[todayTopPlayers].thirdName = donater.nick
					else
						todayTopDonaters_ini[todayTopPlayers].thirdSumma = todayDonaters_ini[todayPlayer].money
					end
				end
				
				inicfg.save(todayTopDonaters_ini, directTodayTopDonaters)
				
				donatik.sortDonatersRating()
				
				donatik.sortDonatersZielRating()
				
				donatik.getGroupsCount()
				
				percent = (tonumber(statistics_ziel_ini[DonateMoneyZiel].money)/tonumber(statistics_ziel_ini[DonateMoneyZiel].target))

				return false 
			end
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
			donatik.sendDonaterInfo(args[2])
		end
	end
	if args[1] == '/donaterid' then
		if args[2] and isNumber(args[2]) and tonumber(args[2]) >= 0 and tonumber(args[2]) < 1000 and math.fmod(tonumber(args[2]), 1) == 0 and sampIsPlayerConnected(args[2]) then
			donatik.sendDonaterInfo(sampGetPlayerNickname(args[2]))
		else
			sampAddChatMessage(prefix .. u8:decode"Ошибка", main_color)
		end
	end
	if args[1] == '/donater' then
		if args[2] then
			if args[3] == nil then
				Player = string.format('%s', args[2])
				if donaters_ini[Player] == nil then
					sampAddChatMessage(u8:decode(prefix .. "{40E0D0}" .. args[2] .. " {FFFFFF}в базе данных не обнаружен"), main_color)
				else
					if donatik.getDonaterZielPlace(donaters_ini[Player].nick) ~= nil then
						sampAddChatMessage(u8:decode(prefix .. donaters_ini[Player].gender .. " {40E0D0}" .. donaters_ini[Player].nick .. " {FFFFFF}находится на " .. donatik.getDonaterPlace(donaters_ini[Player].nick) .. " месте в списке за все время"), main_color)
						sampAddChatMessage(u8:decode(prefix .. "и на " .. donatik.getDonaterZielPlace(donaters_ini[Player].nick) .. " в списке на цель {40E0D0}\"" .. statistics_ini[DonateMoney].zielName .. "\""), main_color)
					else
						sampAddChatMessage(u8:decode(prefix .. donaters_ini[Player].gender .. " {40E0D0}" .. donaters_ini[Player].nick .. " {FFFFFF}находится на " .. donatik.getDonaterPlace(donaters_ini[Player].nick) .. " {FFFFFF}месте в списке за все время"), main_color)
					end
					sampAddChatMessage(prefix .. u8:decode"Сумма пожертвований за все время составляет: {40E0D0}" .. convertNumber(donaters_ini[Player].money), main_color)
					if donatersZiel_ini[Player] ~= nil then
						sampAddChatMessage(u8:decode(prefix .. "На цель {40E0D0}\"" .. statistics_ini[DonateMoney].zielName .. "\"{FFFFFF} составляет: {40E0D0}" .. convertNumber(donatersZiel_ini[Player].money)), main_color)
					end
					todayPlayerNickName = string.format('%s-%s-%s-%s', my_day, my_month, my_year, args[2])
					if todayDonaters_ini[todayPlayerNickName] == nil then
						sampAddChatMessage(prefix .. u8:decode"Сегодня пожертвований не было", main_color)
					else
						sampAddChatMessage(prefix .. u8:decode"За сегодня составляет: {40E0D0}" .. convertNumber(todayDonaters_ini[todayPlayerNickName].money), main_color)
					end
				end
			elseif args[3] ~= nil and args[3] ~= "" and isNumber(args[3]) and math.fmod(tonumber(args[3]), 1) == 0 then
			
				statistics_ini[DonateMoney].money = statistics_ini[DonateMoney].money + tonumber(args[3])
				inicfg.save(statistics_ini, directStatistics)
			
				todayTopDonaters_ini[todayTopPlayers].money = todayTopDonaters_ini[todayTopPlayers].money + args[3]
				inicfg.save(todayTopDonaters_ini, directTodayTopDonaters)
				
				statistics_ziel_ini[DonateMoneyZiel].money = statistics_ziel_ini[DonateMoneyZiel].money + args[3]
				inicfg.save(statistics_ziel_ini, directStatisticsZiel)
			
				playerNickName = string.format('%s', args[2])
				
				if donaters_ini[playerNickName] ~= nil then
					donaters_ini[playerNickName].money = donaters_ini[playerNickName].money + args[3]
					sampAddChatMessage(u8:decode(prefix .. "Сумма пожертвований от {40E0D0}" .. args[2] .. "{FFFFFF} составляет: {40E0D0}" .. convertNumber(donaters_ini[playerNickName].money)), main_color)
					for i = 1, tonumber(donatersRating_ini[PlayerCount].count) do
						if donatersRating_ini[i] ~= nil then
							if donatersRating_ini[i].nick == args[2] then
								donatersRating_ini[i].money = donatersRating_ini[i].money + args[3]
								inicfg.save(donatersRating_ini, directDonatersRating)
								break
							end
						end
					end
				else
					donaters_ini = inicfg.load({
						[playerNickName] = {
							nick   = tostring(args[2]),
							money  = tonumber(args[3]),
							gender = u8:decode("Мужской"),
							group  = u8:decode("Гражданский"),
							rank   = u8:decode("Господин"),
							sms    = false
						}
					}, directDonaters)
					sampAddChatMessage(u8:decode(prefix .. "Господин {40E0D0}" .. args[2] .. "{FFFFFF} был добавлен в базу данных"), main_color)
					sampAddChatMessage(u8:decode(prefix .. "Сумма пожертвований за все время от {40E0D0}" .. args[2] .. "{FFFFFF} составляет: {40E0D0}" .. convertNumber(args[3])), main_color)
					
					PlayerRating = string.format('%d', donatersRating_ini[PlayerCount].count + 1)
					if donatersRating_ini[PlayerRating] == nil then
						donatersRating_ini = inicfg.load({
							[PlayerRating] = {
								nick = tostring(args[2]),
								money = tonumber(args[3])
							}
						}, directDonatersRating)
					end
					donatersRating_ini[PlayerCount].count = donatersRating_ini[PlayerCount].count + 1
					inicfg.save(donatersRating_ini, directDonatersRating)
					donatersRating_ini = inicfg.load(donatersRating_ini[PlayerCount].count, directDonatersRating)
				end
				donatik.setRank(args[2])
				inicfg.save(donaters_ini, directDonaters)
				
				if donatersZiel_ini[playerNickName] ~= nil then
					donatersZiel_ini[playerNickName].money = donatersZiel_ini[playerNickName].money + args[3]
					for i = 1, tonumber(donatersRatingZiel_ini[PlayerZielCount].count) do
						if donatersRatingZiel_ini[i] ~= nil then
							if donatersRatingZiel_ini[i].nick == args[2] then
								donatersRatingZiel_ini[i].money = donatersRatingZiel_ini[i].money + args[3]
								inicfg.save(donatersRatingZiel_ini, directDonatersRatingZiel)
								break
							end
						end
					end
				else
					donatersZiel_ini = inicfg.load({
						[playerNickName] = {
							nick = tostring(args[2]),
							money = tonumber(args[3])
						}
					}, directDonatersZiel)
					statistics_ziel_ini[DonateMoneyZiel].count = statistics_ziel_ini[DonateMoneyZiel].count + 1
					inicfg.save(statistics_ziel_ini, directStatisticsZiel)
					
					PlayerZielRating = string.format('%d', donatersRatingZiel_ini[PlayerZielCount].count + 1)
					if donatersRatingZiel_ini[PlayerZielRating] == nil then
						donatersRatingZiel_ini = inicfg.load({
							[PlayerZielRating] = {
								nick = tostring(args[2]),
								money = tonumber(args[3])
							}
						}, directDonatersRatingZiel)
					end
					donatersRatingZiel_ini[PlayerZielCount].count = donatersRatingZiel_ini[PlayerZielCount].count + 1
					inicfg.save(donatersRatingZiel_ini, directDonatersRatingZiel)
					donatersRatingZiel_ini = inicfg.load(donatersRatingZiel_ini[PlayerZielCount].count, directDonatersRatingZiel)
				end
				inicfg.save(donatersZiel_ini, directDonatersZiel)
				
				todayPlayerNickName = string.format('%s-%s-%s-%s', my_day, my_month, my_year, args[2])
				if todayDonaters_ini[todayPlayerNickName] == nil then
					todayDonaters_ini = inicfg.load({
						[todayPlayerNickName] = {
							nick = tostring(args[2]),
							money = tonumber(args[3])
						}
					}, directTodayDonaters)
					todayTopDonaters_ini[todayTopPlayers].count = todayTopDonaters_ini[todayTopPlayers].count + 1
					inicfg.save(todayTopDonaters_ini, directTodayTopDonaters)
					sampAddChatMessage(u8:decode(prefix .. "Сумма пожертвований за сегодня от {40E0D0}" .. args[2] .. "{FFFFFF} составляет: {40E0D0}" .. convertNumber(todayDonaters_ini[todayPlayerNickName].money)), main_color)
				else
					todayDonaters_ini[todayPlayerNickName].money = todayDonaters_ini[todayPlayerNickName].money + args[3]
					sampAddChatMessage(u8:decode(prefix .. "Сумма пожертвований за сегодня от {40E0D0}" .. args[2] .. "{FFFFFF} составляет: {40E0D0}" .. convertNumber(todayDonaters_ini[todayPlayerNickName].money)), main_color)
				end
				inicfg.save(todayDonaters_ini, directTodayDonaters)
				
				if tonumber(args[3]) >= tonumber(0) then
					if tonumber(todayDonaters_ini[todayPlayerNickName].money) > tonumber(todayTopDonaters_ini[todayTopPlayers].firstSumma) then
						if todayTopDonaters_ini[todayTopPlayers].firstName ~= todayDonaters_ini[todayPlayerNickName].nick then
							if todayTopDonaters_ini[todayTopPlayers].secondName ~= todayDonaters_ini[todayPlayerNickName].nick then
								todayTopDonaters_ini[todayTopPlayers].thirdSumma = todayTopDonaters_ini[todayTopPlayers].secondSumma
								todayTopDonaters_ini[todayTopPlayers].secondSumma = todayTopDonaters_ini[todayTopPlayers].firstSumma
								todayTopDonaters_ini[todayTopPlayers].thirdName = todayTopDonaters_ini[todayTopPlayers].secondName
								todayTopDonaters_ini[todayTopPlayers].secondName = todayTopDonaters_ini[todayTopPlayers].firstName
								todayTopDonaters_ini[todayTopPlayers].firstSumma = todayDonaters_ini[todayPlayerNickName].money
								todayTopDonaters_ini[todayTopPlayers].firstName = todayDonaters_ini[todayPlayerNickName].nick
							else
								todayTopDonaters_ini[todayTopPlayers].secondName = todayTopDonaters_ini[todayTopPlayers].firstName
								todayTopDonaters_ini[todayTopPlayers].secondSumma = todayTopDonaters_ini[todayTopPlayers].firstSumma
								todayTopDonaters_ini[todayTopPlayers].firstSumma = todayDonaters_ini[todayPlayerNickName].money
								todayTopDonaters_ini[todayTopPlayers].firstName = todayDonaters_ini[todayPlayerNickName].nick
							end
						else
							todayTopDonaters_ini[todayTopPlayers].firstSumma = todayDonaters_ini[todayPlayerNickName].money
						end
					elseif tonumber(todayDonaters_ini[todayPlayerNickName].money) > tonumber(todayTopDonaters_ini[todayTopPlayers].secondSumma) and tonumber(todayDonaters_ini[todayPlayerNickName].money) <= tonumber(todayTopDonaters_ini[todayTopPlayers].firstSumma) then
						if todayTopDonaters_ini[todayTopPlayers].secondName ~= todayDonaters_ini[todayPlayerNickName].nick then
							todayTopDonaters_ini[todayTopPlayers].thirdSumma = todayTopDonaters_ini[todayTopPlayers].secondSumma
							todayTopDonaters_ini[todayTopPlayers].thirdName = todayTopDonaters_ini[todayTopPlayers].secondName
							todayTopDonaters_ini[todayTopPlayers].secondSumma = todayDonaters_ini[todayPlayerNickName].money
							todayTopDonaters_ini[todayTopPlayers].secondName = args[2]
						else
							todayTopDonaters_ini[todayTopPlayers].secondSumma = todayDonaters_ini[todayPlayerNickName].money
							todayTopDonaters_ini[todayTopPlayers].secondName = todayDonaters_ini[todayPlayerNickName].nick
						end
					elseif tonumber(todayDonaters_ini[todayPlayerNickName].money) > tonumber(todayTopDonaters_ini[todayTopPlayers].thirdSumma) and tonumber(todayDonaters_ini[todayPlayerNickName].money) <= tonumber(todayTopDonaters_ini[todayTopPlayers].secondSumma) then
						if todayTopDonaters_ini[todayTopPlayers].thirdName ~= todayDonaters_ini[todayPlayerNickName].nick then
							todayTopDonaters_ini[todayTopPlayers].thirdSumma = todayDonaters_ini[todayPlayerNickName].money
							todayTopDonaters_ini[todayTopPlayers].thirdName = args[2]
						else
							todayTopDonaters_ini[todayTopPlayers].thirdSumma = todayDonaters_ini[todayPlayerNickName].money
							todayTopDonaters_ini[todayTopPlayers].thirdName = todayDonaters_ini[todayPlayerNickName].nick
						end
					end
					inicfg.save(todayTopDonaters_ini, directTodayTopDonaters)
				else 
					if tonumber(todayDonaters_ini[todayPlayerNickName].money) <= tonumber(todayTopDonaters_ini[todayTopPlayers].firstSumma) and tonumber(todayDonaters_ini[todayPlayerNickName].money) >= tonumber(todayTopDonaters_ini[todayTopPlayers].secondSumma) then
						todayTopDonaters_ini[todayTopPlayers].firstSumma = todayDonaters_ini[todayPlayerNickName].money
						todayTopDonaters_ini[todayTopPlayers].firstName = todayDonaters_ini[todayPlayerNickName].nick
					end 
					if tonumber(todayDonaters_ini[todayPlayerNickName].money) <= tonumber(todayTopDonaters_ini[todayTopPlayers].secondSumma) and tonumber(todayDonaters_ini[todayPlayerNickName].money) > tonumber(todayTopDonaters_ini[todayTopPlayers].thirdSumma) then 
						if todayTopDonaters_ini[todayTopPlayers].firstName == todayDonaters_ini[todayPlayerNickName].nick then
							todayTopDonaters_ini[todayTopPlayers].firstSumma = todayTopDonaters_ini[todayTopPlayers].secondSumma
							todayTopDonaters_ini[todayTopPlayers].firstName = todayTopDonaters_ini[todayTopPlayers].secondName
							todayTopDonaters_ini[todayTopPlayers].secondSumma = todayDonaters_ini[todayPlayerNickName].money
							todayTopDonaters_ini[todayTopPlayers].secondName = todayDonaters_ini[todayPlayerNickName].nick
						end
						if todayTopDonaters_ini[todayTopPlayers].secondName == todayDonaters_ini[todayPlayerNickName].nick then
							todayTopDonaters_ini[todayTopPlayers].secondSumma = todayDonaters_ini[todayPlayerNickName].money
							todayTopDonaters_ini[todayTopPlayers].secondName = todayDonaters_ini[todayPlayerNickName].nick
						end
					end 
					if tonumber(todayDonaters_ini[todayPlayerNickName].money) <= tonumber(todayTopDonaters_ini[todayTopPlayers].thirdSumma) then
						if todayTopDonaters_ini[todayTopPlayers].firstName == todayDonaters_ini[todayPlayerNickName].nick then
							todayTopDonaters_ini[todayTopPlayers].firstSumma = todayTopDonaters_ini[todayTopPlayers].secondSumma
							todayTopDonaters_ini[todayTopPlayers].firstName = todayTopDonaters_ini[todayTopPlayers].secondName
							todayTopDonaters_ini[todayTopPlayers].secondSumma = todayTopDonaters_ini[todayTopPlayers].thirdSumma
							todayTopDonaters_ini[todayTopPlayers].secondName = todayTopDonaters_ini[todayTopPlayers].thirdName
							todayTopDonaters_ini[todayTopPlayers].thirdSumma = todayDonaters_ini[todayPlayerNickName].money
							todayTopDonaters_ini[todayTopPlayers].thirdName = todayDonaters_ini[todayPlayerNickName].nick
						end
						if todayTopDonaters_ini[todayTopPlayers].secondName == todayDonaters_ini[todayPlayerNickName].nick then
							todayTopDonaters_ini[todayTopPlayers].secondSumma = todayTopDonaters_ini[todayTopPlayers].thirdSumma
							todayTopDonaters_ini[todayTopPlayers].secondName = todayTopDonaters_ini[todayTopPlayers].thirdName
							todayTopDonaters_ini[todayTopPlayers].thirdSumma = todayDonaters_ini[todayPlayerNickName].money
							todayTopDonaters_ini[todayTopPlayers].thirdName = todayDonaters_ini[todayPlayerNickName].nick
						end
						if todayTopDonaters_ini[todayTopPlayers].thirdName == todayDonaters_ini[todayPlayerNickName].nick then
							todayTopDonaters_ini[todayTopPlayers].thirdSumma = todayDonaters_ini[todayPlayerNickName].money
							todayTopDonaters_ini[todayTopPlayers].thirdName = todayDonaters_ini[todayPlayerNickName].nick
						end
					end
					inicfg.save(todayTopDonaters_ini, directTodayTopDonaters)
				end
				
				donatik.sortDonatersRating()
				
				donatik.sortDonatersZielRating()
				
				donatik.getGroupsCount()
				
				percent = tonumber(statistics_ziel_ini[DonateMoneyZiel].money)/tonumber(statistics_ziel_ini[DonateMoneyZiel].target)
				
			else
				sampAddChatMessage(prefix .. u8:decode"Ошибка.", main_color)
			end
		end
	end
	if args[1] == '/dziel' then
		if args[2] then
			if args[3] then
				statistics_ini[DonateMoney].zielName = args[2]
				statistics_ini[DonateMoney].target = args[3]
				inicfg.save(statistics_ini, directStatistics)
				sampAddChatMessage(u8:decode(prefix .. "Новая цель: {40E0D0}" .. args[2] .. "{FFFFFF} с суммой {40E0D0}" .. args[3]), main_color)
				script.reload = true
				thisScript():reload()
			end
		end
	end
end

function sampev.onSendChat(message)
    chatManager.lastMessage = message
    chatManager.updateAntifloodClock()
end

function imgui.OnDrawFrame()
	if statistics_ini[DonateMoney].hud and scriptLoaded then
		if buffering_bar_position_fixed then
			imgui.SetNextWindowPos(imgui.ImVec2(settings_ini.Settings.x, settings_ini.Settings.y))
		end
		imgui.SetNextWindowSize(vec(83, 8))
		imgui.Begin("Donaterka", _,  imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		if not buffering_bar_position_fixed then
			buffering_bar_position = imgui.GetWindowPos()
			if buffering_bar_position.x ~= settings_ini.Settings.x or buffering_bar_position.y ~= settings_ini.Settings.y then
				settings_ini.Settings.x = buffering_bar_position.x
				settings_ini.Settings.y = buffering_bar_position.y
				inicfg.save(settings_ini, directSettings)
			end
		end
		imgui.bufferingBar(percent, vec(83, 8), false)
		imgui.End()
	end
	if main_window_state.v and scriptLoaded then
		imgui.ShowCursor = true
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(vec(436, 225), imgui.Cond.FirstUseEver)
		imgui.Begin("Donatik " .. thisScript().version, main_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		
		imgui.BeginChild('top', vec(70, 208), true)
			imgui.CustomMenu({'Функции', 'Список донатеров', 'Список донатеров цель', 'История донатов', 'Информация', 'Своя тема'}, tab, vec(65, 20), _, true)
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild('bottom', vec(358.5, 208), true)
		if tab.v == 1 then
			if imgui.Button("Топ донатеры за день", vec(133.5/1.5, 10)) then
				donatik.sendTodayDonaters()
			end
			imgui.SameLine()
			if NewHotKey("##1", jsonDonaters, tLastKeys, toScreenX(25)) then
				rkeys.changeHotKey(bindDonaters, jsonDonaters.v)
				settings_ini.HotKey.bindDonaters = encodeJson(jsonDonaters.v)
				inicfg.save(settings_ini, directSettings)
			end
			imgui.SameLine()
			if imgui.Button("Топ донатеры за всё время", vec(133.5/1.5, 10)) then
				donatik.sendTopDonaters()
			end
			imgui.SameLine()
			if NewHotKey("##2", jsonTopDonaters, tLastKeys, toScreenX(25)) then
				rkeys.changeHotKey(bindTopDonaters, jsonTopDonaters.v)
				settings_ini.HotKey.bindTopDonaters = encodeJson(jsonTopDonaters.v)
				inicfg.save(settings_ini, directSettings)
			end
			imgui.SameLine()
			if imgui.Button("Топ донатеры на \"" .. statistics_ini[DonateMoney].zielName .. "\"", vec(133.5/1.5, 10)) then
				donatik.sendTopDonatersZiel()
			end
			imgui.SameLine()
			if NewHotKey("##3", jsonTopDonatersZiel, tLastKeys, toScreenX(25)) then
				rkeys.changeHotKey(bindTopDonatersZiel, jsonTopDonatersZiel.v)
				settings_ini.HotKey.bindTopDonatersZiel = encodeJson(jsonTopDonatersZiel.v)
				inicfg.save(settings_ini, directSettings)
			end
			if imgui.Button("Денег за сегодня собрано", vec(133.5/1.5, 10)) then
				donatik.sendTodayDonateMoney()
			end
			imgui.SameLine()
			if NewHotKey("##4", jsonTodayDonateMoney, tLastKeys, toScreenX(25)) then
				rkeys.changeHotKey(bindTodayDonateMoney, jsonTodayDonateMoney.v)
				settings_ini.HotKey.bindTodayDonateMoney = encodeJson(jsonTodayDonateMoney.v)
				inicfg.save(settings_ini, directSettings)
			end
			imgui.SameLine()
			if imgui.Button("Денег за все время собрано", vec(133.5/1.5, 10)) then
				donatik.sendDonateMoney()
			end
			imgui.SameLine()
			if NewHotKey("##5", jsonDonateMoney, tLastKeys, toScreenX(25)) then
				rkeys.changeHotKey(bindDonateMoney, jsonDonateMoney.v)
				settings_ini.HotKey.bindDonateMoney = encodeJson(jsonDonateMoney.v)
				inicfg.save(settings_ini, directSettings)
			end
			imgui.SameLine()
			if imgui.Button("Денег на \"" .. statistics_ini[DonateMoney].zielName .."\" собрано", vec(133.5/1.5, 10)) then
				donatik.sendDonateMoneyZiel()
			end
			imgui.SameLine()
			if NewHotKey("##6", jsonDonateMoneyZiel, tLastKeys, toScreenX(25)) then
				rkeys.changeHotKey(bindDonateMoneyZiel, jsonDonateMoneyZiel.v)
				settings_ini.HotKey.bindDonateMoneyZiel = encodeJson(jsonDonateMoneyZiel.v)
				inicfg.save(settings_ini, directSettings)
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
				imgui.TextUnformatted("Текущая цель \"" .. statistics_ini[DonateMoney].zielName .. "\" с суммой: \n" .. convertNumber(statistics_ini[DonateMoney].target))
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			if buffering_bar_position_fixed then
				if imgui.Button("Фиксация HUDa", vec(116, 10)) then
					buffering_bar_position_fixed = not buffering_bar_position_fixed
					inicfg.save(settings_ini, directSettings)
				end
			else
				if imgui.Button("Зафиксировать HUD", vec(116, 10)) then
					buffering_bar_position_fixed = not buffering_bar_position_fixed
					inicfg.save(settings_ini, directSettings)
				end
			end
			imgui.SameLine()
			if imgui.Button("Отображение HUDa", vec(116, 10)) then
				donatik.hud()
			end
			imgui.SameLine()
			if NewHotKey("##7", jsonHud, tLastKeys, toScreenX(116)) then
				rkeys.changeHotKey(bindHud, jsonHud.v)
				settings_ini.HotKey.bindHud = encodeJson(jsonHud.v)
				inicfg.save(settings_ini, directSettings)
			end
			imgui.bufferingBar(percent, vec(354, 10), false)
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted(string.format("Денег на цель \"%s\" собрано: \n%s/%s [%s]", statistics_ini[DonateMoney].zielName, convertNumber(statistics_ziel_ini[DonateMoneyZiel].money), convertNumber(statistics_ziel_ini[DonateMoneyZiel].target), string.sub(tostring(percent * 100), 1, 5)))
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			
			imgui.Dummy(vec(0, 2.5))
			imgui.BeginChild("AA2", vec(175, 60), true)
			imgui.Columns(1, "Title1", true)
			imgui.Text("За все время: ".. convertNumber(statistics_ini[DonateMoney].money) .. " вирт от " .. convertNumber(donatersRating_ini["Count"].count) .. " игроков")
			imgui.Separator()
			imgui.Columns(3, "Columns2", true)
			imgui.Text("")
			imgui.NextColumn()
			imgui.Text("Имя")
			imgui.NextColumn()
			imgui.Text("Денег")
			imgui.NextColumn()
			imgui.Separator()
			
			if donatersRating_ini[1] ~= nil then
				imgui.Text(u8("1. " .. donaters_ini[donatersRating_ini[1].nick].rank))
			else
				imgui.Text("1. Неизвестно")
			end
			imgui.NextColumn()
			if donatersRating_ini[1] ~= nil then
				imgui.Text(u8(donatersRating_ini[1].nick))
				imgui.NextColumn()
				imgui.Text("" .. convertNumber(donatersRating_ini[1].money))
			else
				imgui.Text("Пусто")
				imgui.NextColumn()
				imgui.Text("0")
			end
			imgui.NextColumn()
			imgui.Separator()
			
			if donatersRating_ini[2] ~= nil then
				imgui.Text(u8("2. " .. donaters_ini[donatersRating_ini[2].nick].rank))
			else
				imgui.Text("2. Неизвестно")
			end
			imgui.NextColumn()		
			if donatersRating_ini[2] ~= nil then
				imgui.Text(u8(donatersRating_ini[2].nick))
				imgui.NextColumn()
				imgui.Text("" .. convertNumber(donatersRating_ini[2].money))
			else
				imgui.Text("Пусто")
				imgui.NextColumn()
				imgui.Text("0")
			end
			imgui.NextColumn()
			imgui.Separator()
			
			if donatersRating_ini[3] ~= nil then
				imgui.Text(u8("3. " .. donaters_ini[donatersRating_ini[3].nick].rank))
			else
				imgui.Text("3. Неизвестно")
			end
			imgui.NextColumn()
			if donatersRating_ini[3] ~= nil then
				imgui.Text(u8(donatersRating_ini[3].nick))
				imgui.NextColumn()
				imgui.Text("" .. convertNumber(donatersRating_ini[3].money))
			else
				imgui.Text("Пусто")
				imgui.NextColumn()
				imgui.Text("0")
			end
			imgui.EndChild()
			
			imgui.SameLine()
			imgui.BeginChild("AA3", vec(175, 60), true)
			imgui.Columns(1, "Title3", true)
			imgui.Text("На цель \"" .. statistics_ini[DonateMoney].zielName .. "\" за все время: ".. convertNumber(statistics_ziel_ini[DonateMoneyZiel].money) .. " вирт от " .. convertNumber(donatersRatingZiel_ini["Count"].count) .. " игроков")
			imgui.Separator()
			imgui.Columns(3, "Columns3", true)
			imgui.Text("")
			imgui.NextColumn()
			imgui.Text("Имя")
			imgui.NextColumn()
			imgui.Text("Денег")
			imgui.NextColumn()
			imgui.Separator()
			
			if donatersRatingZiel_ini[1] ~= nil then
				imgui.Text(u8("1. " .. donaters_ini[donatersRatingZiel_ini[1].nick].rank))
			else
				imgui.Text("1. Неизвестно")
			end
			imgui.NextColumn()
			if donatersRatingZiel_ini[1] ~= nil then
				imgui.Text(u8(donatersRatingZiel_ini[1].nick))
				imgui.NextColumn()
				imgui.Text("" .. convertNumber(donatersRatingZiel_ini[1].money))
			else
				imgui.Text("Пусто")
				imgui.NextColumn()
				imgui.Text("0")
			end
			imgui.NextColumn()
			imgui.Separator()
			
			if donatersRatingZiel_ini[2] ~= nil then
				imgui.Text(u8("2. " .. donaters_ini[donatersRatingZiel_ini[2].nick].rank))
			else
				imgui.Text("2. Неизвестно")
			end
			imgui.NextColumn()
			if donatersRatingZiel_ini[2] ~= nil then
				imgui.Text(u8(donatersRatingZiel_ini[2].nick))
				imgui.NextColumn()
				imgui.Text("" .. convertNumber(donatersRatingZiel_ini[2].money))
			else
				imgui.Text("Пусто")
				imgui.NextColumn()
				imgui.Text("0")
			end
			imgui.NextColumn()
			imgui.Separator()
			
			if donatersRatingZiel_ini[3] ~= nil then
				imgui.Text(u8("3. " .. donaters_ini[donatersRatingZiel_ini[3].nick].rank))
			else
				imgui.Text("3. Неизвестно")
			end
			imgui.NextColumn()
			if donatersRatingZiel_ini[3] ~= nil then
				imgui.Text(donatersRatingZiel_ini[3].nick)
				imgui.NextColumn()
				imgui.Text("" .. convertNumber(donatersRatingZiel_ini[3].money))
			else
				imgui.Text("Пусто")
				imgui.NextColumn()
				imgui.Text("0")
			end
			imgui.EndChild()
			
			imgui.Dummy(vec(0, 2.5))
			imgui.BeginChild("AA", vec(175, 60), true)
			imgui.Columns(1, "Title2", true)
			imgui.Text("За сегодня: " .. convertNumber(todayTopDonaters_ini[todayTopPlayers].money) .. " вирт от " .. todayTopDonaters_ini[todayTopPlayers].count .. " игроков")
			imgui.Separator()
			imgui.Columns(3, "Columns", true)
			imgui.Text("")
			imgui.NextColumn()
			imgui.Text("Имя")
			imgui.NextColumn()
			imgui.Text("Денег")
			imgui.NextColumn()
			imgui.Separator()
			if donaters_ini[todayTopDonaters_ini[todayTopPlayers].firstName] ~= nil then
				imgui.Text(u8("1. " .. donaters_ini[todayTopDonaters_ini[todayTopPlayers].firstName].rank))
			else
				imgui.Text("1. Неизвестно")
			end
			imgui.NextColumn()
			imgui.Text(u8(todayTopDonaters_ini[todayTopPlayers].firstName))
			imgui.NextColumn()
			imgui.Text("" .. convertNumber(todayTopDonaters_ini[todayTopPlayers].firstSumma))
			imgui.NextColumn()
			imgui.Separator()
			if donaters_ini[todayTopDonaters_ini[todayTopPlayers].secondName] then
				imgui.Text(u8("2. " .. donaters_ini[todayTopDonaters_ini[todayTopPlayers].secondName].rank))
			else
				imgui.Text("2. Неизвестно")
			end
			imgui.NextColumn()
			imgui.Text(u8(todayTopDonaters_ini[todayTopPlayers].secondName))
			imgui.NextColumn()
			imgui.Text("" .. convertNumber(todayTopDonaters_ini[todayTopPlayers].secondSumma))
			imgui.NextColumn()
			imgui.Separator()
			if donaters_ini[todayTopDonaters_ini[todayTopPlayers].thirdName] then
				imgui.Text(u8("3. " .. donaters_ini[todayTopDonaters_ini[todayTopPlayers].thirdName].rank))
			else
				imgui.Text("3. Неизвестно")
			end
			imgui.NextColumn()
			imgui.Text(u8(todayTopDonaters_ini[todayTopPlayers].thirdName))
			imgui.NextColumn()
			imgui.Text("" .. convertNumber(todayTopDonaters_ini[todayTopPlayers].thirdSumma))
			imgui.EndChild()
			
			imgui.SetCursorPos(vec(180, 143))
			
			if imgui.Checkbox("Уведомления о донатах от игрока за все время. ", imgui.ImBool(settings_ini.Settings.DonatersNotify)) then
				settings_ini.Settings.DonatersNotify = not settings_ini.Settings.DonatersNotify
				inicfg.save(settings_ini, directSettings)
			end
			imgui.SetCursorPos(vec(180, 155))
			if imgui.Checkbox("Уведомления о донатах от игрока за сегодня. ", imgui.ImBool(settings_ini.Settings.TodayDonatersNotify)) then
				settings_ini.Settings.DonatersNotify = not settings_ini.Settings.DonatersNotify
				inicfg.save(settings_ini, directSettings)
			end
			imgui.SetCursorPos(vec(180, 167))
			if imgui.Checkbox("Уведомления о донатах. ", imgui.ImBool(settings_ini.Settings.DonateNotify)) then
				settings_ini.Settings.DonateNotify = not settings_ini.Settings.DonateNotify
				inicfg.save(settings_ini, directSettings)
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
				settings_ini.Settings.themeId = combo_select.v
				inicfg.save(settings_ini, directSettings)
				imgui.updateMyStyle(combo_select.v)
			end
			imgui.PopItemWidth()
			imgui.SetCursorPos(vec(180, 179))
			if imgui.Checkbox("Уведомление о заходе донатера от суммы: ", imgui.ImBool(settings_ini.Settings.DonaterJoined)) then
				settings_ini.Settings.DonaterJoined = not settings_ini.Settings.DonaterJoined
				inicfg.save(settings_ini, directSettings)
			end
			imgui.SameLine()
			imgui.PushItemWidth(toScreenX(40))
			if imgui.InputInt("##inp5", imgui.donateSize, 0, 1) then
				if imgui.donateSize.v ~= nil and imgui.donateSize.v ~= "" and imgui.donateSize.v >= 0 then
					settings_ini.Settings.donateSize = imgui.donateSize.v
					inicfg.save(settings_ini, directSettings)
				end
			end
			imgui.PopItemWidth()
			imgui.SetCursorPos(vec(180, 191))
			if imgui.Checkbox("Звук донатов. ", imgui.ImBool(settings_ini.Settings.Sound)) then
				settings_ini.Settings.Sound = not settings_ini.Settings.Sound
				inicfg.save(settings_ini, directSettings)
			end
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted("Если звук отсутствует, требуется выставить минимальную громкость игрового радио и перезагрузить игру.")
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			imgui.SameLine()
			if imgui.Checkbox("Отображение доната сверху игрока. ", imgui.ImBool(settings_ini.Settings.textLabel)) then
				settings_ini.Settings.textLabel = not settings_ini.Settings.textLabel
				inicfg.save(settings_ini, directSettings)
			end
		elseif tab.v == 2 then
			imgui.Columns(1, "Title23", true)
			imgui.Text("Список донатеров за все время: ".. convertNumber(statistics_ini[DonateMoney].money) .. " вирт от " .. convertNumber(donatersRating_ini["Count"].count) .. " игроков")
			imgui.Separator()
			imgui.Columns(3, "Columns", true)
			imgui.Text("Место")
			imgui.NextColumn()
			imgui.Text("Имя")
			imgui.NextColumn()
			imgui.Text("Денег")
			imgui.NextColumn()
			for i = 1, tonumber(donatersRating_ini[PlayerCount].count) do
				if donatersRating_ini[i] ~= nil then
					imgui.Separator()
					if donaters_ini[donatersRating_ini[i].nick] ~= nil then
						imgui.Text("" .. i .. ". " .. u8(donaters_ini[donatersRating_ini[i].nick].rank))
					else
						imgui.Text("" .. i .. ". Неизвестно")
					end
					imgui.NextColumn()
					imgui.Text(u8(donatersRating_ini[i].nick))
					imgui.NextColumn()
					imgui.Text("" .. convertNumber(donatersRating_ini[i].money))
					imgui.NextColumn()
				end
			end
		elseif tab.v == 3 then
			imgui.Columns(1, "Title23", true)
			imgui.Text("На цель \"" .. statistics_ini[DonateMoney].zielName .. "\" за все время: ".. convertNumber(statistics_ziel_ini[DonateMoneyZiel].money) .. " вирт от " .. convertNumber(donatersRatingZiel_ini["Count"].count) .. " игроков")
			imgui.Separator()
			imgui.Columns(3, "Columns", true)
			imgui.Text("Место")
			imgui.NextColumn()
			imgui.Text("Имя")
			imgui.NextColumn()
			imgui.Text("Денег")
			imgui.NextColumn()
			for i = 1, tonumber(donatersRatingZiel_ini[PlayerCount].count) do
				if donatersRatingZiel_ini[i] ~= nil then
					imgui.Separator()
					if donaters_ini[donatersRatingZiel_ini[i].nick] ~= nil then
						imgui.Text("" .. i .. ". " .. u8(donaters_ini[donatersRatingZiel_ini[i].nick].rank))
					else
						imgui.Text("" .. i .. ". Неизвестно")
					end
					imgui.NextColumn()
					imgui.Text(u8(donatersRatingZiel_ini[i].nick))
					imgui.NextColumn()
					imgui.Text("" .. convertNumber(donatersRatingZiel_ini[i].money))
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
			
			local historyDonatersCount = 0
			for i = 0, 1000 do
				if sampIsPlayerConnected(i) then
					donaterNick = sampGetPlayerNickname(i)
					if donaters_list then
						if donaters_ini ~= nil and donaters_ini[donaterNick] ~= nil then
							if donaterNick == donaters_ini[donaterNick].nick and donaters_ini[donaterNick].money >= donaters_list_silder.v then
								historyDonatersCount = historyDonatersCount + 1
							end
						end
					else
						if donatersZiel_ini[donaterNick] ~= nil then
							if donaterNick == donatersZiel_ini[donaterNick].nick and donatersZiel_ini[donaterNick].money >= donaters_list_silder.v then
								historyDonatersCount = historyDonatersCount + 1
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
			imgui.Text(" Донатеры онлайн " .. historyDonatersCount .. "	")
			imgui.BeginChild('History', vec(175, 190), true)
				for y = 2038, 2020, -1 do
					for m = 12, 1, -1 do
						for d = 31, 1, -1 do
							if tonumber(d) > 0 and tonumber(d) < 10 then d = string.format('0%d', d) end
							if tonumber(m) > 0 and tonumber(m) < 10 then m = string.format('0%d', m) end
							todayTopPlayersSelectedDay = string.format('%s-%s-%s', d, m, y)
							todayDonateMoneySelectedDay = string.format('%s-%s-%s', d, m, y)
							if todayTopDonaters_ini[todayTopPlayersSelectedDay] ~= nil and todayTopDonaters_ini[todayTopPlayersSelectedDay].firstSumma ~= 0 then
								if todayTopDonaters_ini[todayDonateMoneySelectedDay] ~= nil and todayTopDonaters_ini[todayDonateMoneySelectedDay].money ~= 0 then
									if imgui.CollapsingHeader(string.format(u8:decode'%s.%s.%s - %s', d, m, y, convertNumber(todayTopDonaters_ini[todayDonateMoneySelectedDay].money))) then
										imgui.PushTextWrapPos(toScreenX(185))
										imgui.BeginChild(string.format(u8:decode'%s-%s-%s', d, m, y), vec(163, 60), true)
										imgui.Columns(1, "Title2", true)
										imgui.Text("За весь день: ".. convertNumber(todayTopDonaters_ini[todayDonateMoneySelectedDay].money) .. " вирт от " .. todayTopDonaters_ini[todayDonateMoneySelectedDay].count .. " игроков")
										imgui.Separator()
										imgui.Columns(3, "Columns", true)
										imgui.Text("")
										imgui.NextColumn()
										imgui.Text("Имя")
										imgui.NextColumn()
										imgui.Text("Денег")
										imgui.NextColumn()
										imgui.Separator()
										if donaters_ini[todayTopDonaters_ini[todayTopPlayersSelectedDay].firstName] ~= nil then
											imgui.Text(u8("1. " .. donaters_ini[todayTopDonaters_ini[todayTopPlayersSelectedDay].firstName].rank))
										else
											imgui.Text("1. Неизвестно")
										end
										imgui.NextColumn()
										imgui.Text(u8(todayTopDonaters_ini[todayTopPlayersSelectedDay].firstName))
										imgui.NextColumn()
										imgui.Text("" .. convertNumber(todayTopDonaters_ini[todayTopPlayersSelectedDay].firstSumma))
										imgui.NextColumn()
										imgui.Separator()
										if donaters_ini[todayTopDonaters_ini[todayTopPlayersSelectedDay].secondName] ~= nil then
											imgui.Text(u8("2. " .. donaters_ini[todayTopDonaters_ini[todayTopPlayersSelectedDay].secondName].rank))
										else
											imgui.Text("2. Неизвестно")
										end
										imgui.NextColumn()
										imgui.Text(u8(todayTopDonaters_ini[todayTopPlayersSelectedDay].secondName))
										imgui.NextColumn()
										imgui.Text("" .. convertNumber(todayTopDonaters_ini[todayTopPlayersSelectedDay].secondSumma))
										imgui.NextColumn()
										imgui.Separator()
										if donaters_ini[todayTopDonaters_ini[todayTopPlayersSelectedDay].thirdName] ~= nil then
											imgui.Text(u8("3. " .. donaters_ini[todayTopDonaters_ini[todayTopPlayersSelectedDay].thirdName].rank))
										else
											imgui.Text("3. Неизвестно")
										end
										imgui.NextColumn()
										imgui.Text(u8(todayTopDonaters_ini[todayTopPlayersSelectedDay].thirdName))
										imgui.NextColumn()
										imgui.Text("" .. convertNumber(todayTopDonaters_ini[todayTopPlayersSelectedDay].thirdSumma))
										imgui.EndChild()
										if imgui.Button(string.format('Вывести список топ донатеров за %s.%s.%s', d, m, y), vec(163, 10)) then
											donatik.sendSelectedDayDonaters(d, m, y, 
												todayTopDonaters_ini[todayTopPlayersSelectedDay].firstName, todayTopDonaters_ini[todayTopPlayersSelectedDay].firstSumma, 
												todayTopDonaters_ini[todayTopPlayersSelectedDay].secondName, todayTopDonaters_ini[todayTopPlayersSelectedDay].secondSumma, 
												todayTopDonaters_ini[todayTopPlayersSelectedDay].thirdName, todayTopDonaters_ini[todayTopPlayersSelectedDay].thirdSumma)
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
				for id = 0, 1000 do
					if sampIsPlayerConnected(id) then
						donaterNick = sampGetPlayerNickname(id)
						if donaters_list then
							if donaters_ini ~= nil and donaters_ini[donaterNick] ~= nil then
								if donaterNick == donaters_ini[donaterNick].nick and donaters_ini[donaterNick].money >= donaters_list_silder.v then
									if imgui.CollapsingHeader(string.format('%s [%s]', donaters_ini[donaterNick].nick, id)) then
										imgui.PushTextWrapPos(toScreenX(185))
										imgui.BeginChild(string.format('%s', donaters_ini[donaterNick].nick), vec(163, 40), true)
										imgui.Text(" За всё время: " .. convertNumber(donaters_ini[donaterNick].money))
										imgui.Separator()
										if donatersZiel_ini[donaterNick] ~= nil then
											imgui.Text(" На цель: " .. convertNumber(donatersZiel_ini[donaterNick].money))
										else
											imgui.Text(" На цель: нет")
										end
										imgui.Separator()
										todayDonaterNick = string.format('%s-%s-%s-%s', my_day, my_month, my_year, donaterNick)
										if todayDonaters_ini[todayDonaterNick] ~= nil then
											imgui.Text(" За сегодня: " .. convertNumber(todayDonaters_ini[todayDonaterNick].money))
										else
											imgui.Text(" За сегодня: нет")
										end
										imgui.EndChild()
										if imgui.Button("Вывести информацию о донатере", vec(163, 0)) then	
											donatik.sendDonaterInfo(donaterNick)
										end
										--if not donaters_ini[donaterNick].sms then
										--	if imgui.Button("Отправить сообщение", vec(163, 0)) then	
										--		chatManager.addMessageToQueue("/sms " .. id .. " Привет, ты попал в список донатеров в видео на ютуб!", false)
										--		chatManager.addMessageToQueue("/sms " .. id .. " Видео называется: SAMP RP Revolution 2022 - Благодарность работягам №3", false)
										--		donaters_ini[donaterNick].sms = true
										--		inicfg.save(donaters_ini, directDonaters)
										--	end
										--end
										imgui.PopTextWrapPos()
										imgui.Separator()
									end
								end
							end
						else
							if donatersZiel_ini[donaterNick] ~= nil then
								if donaterNick == donatersZiel_ini[donaterNick].nick and donatersZiel_ini[donaterNick].money >= donaters_list_silder.v then
									if imgui.CollapsingHeader(string.format('%s [%s]', donatersZiel_ini[donaterNick].nick, i)) then
										imgui.PushTextWrapPos(toScreenX(185))
										imgui.BeginChild(string.format('%s', donatersZiel_ini[donaterNick].nick), vec(163, 40), true)
										imgui.Text(" За всё время: " .. convertNumber(donaters_ini[donaterNick].money))
										imgui.Separator()
										if donatersZiel_ini[donaterNick] ~= nil then
											imgui.Text(" На цель: " .. convertNumber(donatersZiel_ini[donaterNick].money))
										else
											imgui.Text(" На цель: нет")
										end
										imgui.Separator()
										todayDonaterNick = string.format('%s-%s-%s-%s', my_day, my_month, my_year, donaterNick)
										if todayDonaters_ini[todayDonaterNick] ~= nil then
											imgui.Text(" За сегодня: " .. convertNumber(todayDonaters_ini[todayDonaterNick].money))
										else
											imgui.Text(" За сегодня: нет")
										end
										imgui.EndChild()
										if imgui.Button("Вывести информацию о донатере", vec(163, 0)) then	
											donatik.sendDonaterInfo(donaterNick)
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
				if imgui.Button("Обновить скрипт", vec(175, 18)) then
					imgui.Process = false
					updateScript()
				end
			else
				if imgui.Button("Актуальная версия скрипта", vec(175, 18)) then
					sampAddChatMessage(prefix .. u8:decode("Обновление не требуется"), main_color)
				end
			end
			imgui.SameLine()
			if imgui.Button("Перезагрузить", vec(86.5, 18)) then 
				script.reload = true
				thisScript():reload()
			end
			imgui.SameLine()
			if settings_ini.Settings.Switch then
				if imgui.Button("Прекратить работу скрипта", vec(86.5, 18)) then
					settings_ini.Settings.Switch = not settings_ini.Settings.Switch
				end
			else
				if imgui.Button("Включить скрипт", vec(86.5, 18)) then
					settings_ini.Settings.Switch = not settings_ini.Settings.Switch
				end
			end
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(toScreenX(100))
				imgui.TextUnformatted("Если выключить, то запись донатов прекратится")
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
			
			local found = false
			for i = 0, 1000 do 
				if sampIsPlayerConnected(i) and sampGetPlayerScore(i) ~= 0 then
					if sampGetPlayerNickname(i) == "bier" then
						if imgui.Button("bier [" .. i .. "] сейчас в сети", vec(175, 18)) then
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
				if imgui.Button("bier сейчас не в сети", vec(175, 18)) then
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
			imgui.SameLine()
			if settings_ini.Telegram.bool then
				if imgui.Button("Выключить телегу", vec(86.5, 18)) then 
					settings_ini.Telegram.bool = not settings_ini.Telegram.bool
					inicfg.save(settings_ini, directSettings)
				end
			else
				if imgui.Button("Включить телегу", vec(86.5, 18)) then 
					settings_ini.Telegram.bool = not settings_ini.Telegram.bool
					inicfg.save(settings_ini, directSettings)
				end
			end
			imgui.SameLine()
			if imgui.Button("VK", vec(86.5, 18)) then
				os.execute("start https://vk.com/vlaeek")
			end
			
			if imgui.Button("Токен", vec(48.25, 10)) then
				settings_ini.Telegram.token = text_buffer_token.v
				inicfg.save(settings_ini, directSettings)
				sampAddChatMessage(u8:decode(prefix .. "Токен сохранен, перезагрузите скрипт"), main_color)
			end
			imgui.SameLine()
			imgui.PushItemWidth(toScreenX(125))
			imgui.InputText("##token", text_buffer_token)
			imgui.PopItemWidth()
			imgui.SameLine()
			if imgui.Button("Чат айди", vec(48.25, 10)) then
				settings_ini.Telegram.chat_id = text_buffer_chat_id.v
				inicfg.save(settings_ini, directSettings)
				sampAddChatMessage(u8:decode(prefix .. "Чат айди сохранен, перезагрузите скрипт"), main_color)
			end
			imgui.SameLine()
			imgui.PushItemWidth(toScreenX(125))
			imgui.InputText("##chat_id", text_buffer_chat_id)
			imgui.PopItemWidth()
			
			imgui.Separator()
			
			imgui.SetCursorPos(vec(5, 65))
			imgui.RoundDiagram(groupsDiagram, 120, 360, 0)
			
			imgui.SetCursorPos(vec(180, 65))
			imgui.RoundDiagram(gendersDiagram, 120, 360, 525)
			--[[
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
			
			]]
			
		elseif tab.v == 6 then
			if imgui.ColorEdit4("Text", color_text) then 
				rgba = imgui.ImColor(color_text.v[1], color_text.v[2], color_text.v[3], color_text.v[4])
				settings_ini.MyStyle.Text_R, settings_ini.MyStyle.Text_G, settings_ini.MyStyle.Text_B, settings_ini.MyStyle.Text_A = rgba:GetRGBA()
				inicfg.save(settings_ini, directSettings)
				imgui.updateMyStyle(combo_select.v)
			end
			if imgui.ColorEdit4("Button", color_button) then 
				rgba = imgui.ImColor(color_button.v[1], color_button.v[2], color_button.v[3], color_button.v[4])
				settings_ini.MyStyle.Button_R, settings_ini.MyStyle.Button_G, settings_ini.MyStyle.Button_B, settings_ini.MyStyle.Button_A = rgba:GetRGBA()
				inicfg.save(settings_ini, directSettings)
				imgui.updateMyStyle(combo_select.v)
			end
			if imgui.ColorEdit4("ButtonActive", color_button_active) then 
				rgba = imgui.ImColor(color_button_active.v[1], color_button_active.v[2], color_button_active.v[3], color_button_active.v[4])
				settings_ini.MyStyle.ButtonActive_R, settings_ini.MyStyle.ButtonActive_G, settings_ini.MyStyle.ButtonActive_B, settings_ini.MyStyle.ButtonActive_A = rgba:GetRGBA()
				inicfg.save(settings_ini, directSettings)
				imgui.updateMyStyle(combo_select.v)
			end
			if imgui.ColorEdit4("FrameBg", color_frame) then 
				rgba = imgui.ImColor(color_frame.v[1], color_frame.v[2], color_frame.v[3], color_frame.v[4])
				settings_ini.MyStyle.FrameBg_R, settings_ini.MyStyle.FrameBg_G, settings_ini.MyStyle.FrameBg_B, settings_ini.MyStyle.FrameBg_A = rgba:GetRGBA()
				inicfg.save(settings_ini, directSettings)
				imgui.updateMyStyle(combo_select.v)
			end
			if imgui.ColorEdit4("FrameBgHovered", color_frame_hovered) then 
				rgba = imgui.ImColor(color_frame_hovered.v[1], color_frame_hovered.v[2], color_frame_hovered.v[3], color_frame_hovered.v[4])
				settings_ini.MyStyle.FrameBgHovered_R, settings_ini.MyStyle.FrameBgHovered_G, settings_ini.MyStyle.FrameBgHovered_B, settings_ini.MyStyle.FrameBgHovered_A = rgba:GetRGBA()
				inicfg.save(settings_ini, directSettings)
				imgui.updateMyStyle(combo_select.v)
			end
			if imgui.ColorEdit4("Title", color_title) then 
				rgba = imgui.ImColor(color_title.v[1], color_title.v[2], color_title.v[3], color_title.v[4])
				settings_ini.MyStyle.Title_R, settings_ini.MyStyle.Title_G, settings_ini.MyStyle.Title_B, settings_ini.MyStyle.Title_A = rgba:GetRGBA()
				inicfg.save(settings_ini, directSettings)
				imgui.updateMyStyle(combo_select.v)
			end
			if imgui.ColorEdit4("Separator", color_separator) then 
				rgba = imgui.ImColor(color_separator.v[1], color_separator.v[2], color_separator.v[3], color_separator.v[4])
				settings_ini.MyStyle.Separator_R, settings_ini.MyStyle.Separator_G, settings_ini.MyStyle.Separator_B, settings_ini.MyStyle.Separator_A = rgba:GetRGBA()
				inicfg.save(settings_ini, directSettings)
				imgui.updateMyStyle(combo_select.v)
			end
			if imgui.ColorEdit4("WindowBg", color_windowbg) then 
				rgba = imgui.ImColor(color_windowbg.v[1], color_windowbg.v[2], color_windowbg.v[3], color_windowbg.v[4])
				settings_ini.MyStyle.WindowBg_R, settings_ini.MyStyle.WindowBg_G, settings_ini.MyStyle.WindowBg_B, settings_ini.MyStyle.WindowBg_A = rgba:GetRGBA()
				inicfg.save(settings_ini, directSettings)
				imgui.updateMyStyle(combo_select.v)
			end
			if imgui.ColorEdit4("CheckMark", color_checkmark) then 
				rgba = imgui.ImColor(color_checkmark.v[1], color_checkmark.v[2], color_checkmark.v[3], color_checkmark.v[4])
				settings_ini.MyStyle.CheckMark_R, settings_ini.MyStyle.CheckMark_G, settings_ini.MyStyle.CheckMark_B, settings_ini.MyStyle.CheckMark_A = rgba:GetRGBA()
				inicfg.save(settings_ini, directSettings)
				imgui.updateMyStyle(combo_select.v)
			end
			imgui.Separator()
			if imgui.Button("Вернуть значения по умолчанию", vec(352, 20)) then
				settings_ini.MyStyle.Text_R           = 1.00
				settings_ini.MyStyle.Text_G           = 1.00
				settings_ini.MyStyle.Text_B           = 1.00
				settings_ini.MyStyle.Text_A           = 1.00
				settings_ini.MyStyle.Button_R         = 0.98
				settings_ini.MyStyle.Button_G         = 0.43
				settings_ini.MyStyle.Button_B         = 0.26
				settings_ini.MyStyle.Button_A         = 0.40
				settings_ini.MyStyle.ButtonActive_R   = 0.98
				settings_ini.MyStyle.ButtonActive_G   = 0.43
				settings_ini.MyStyle.ButtonActive_B   = 0.26
				settings_ini.MyStyle.ButtonActive_A   = 1.00
				settings_ini.MyStyle.FrameBg_R        = 0.48
				settings_ini.MyStyle.FrameBg_G        = 0.23
				settings_ini.MyStyle.FrameBg_B        = 0.16
				settings_ini.MyStyle.FrameBg_A        = 0.25
				settings_ini.MyStyle.FrameBgHovered_R = 0.98
				settings_ini.MyStyle.FrameBgHovered_G = 0.43
				settings_ini.MyStyle.FrameBgHovered_B = 0.26
				settings_ini.MyStyle.FrameBgHovered_A = 0.40
				settings_ini.MyStyle.Title_R          = 0.48
				settings_ini.MyStyle.Title_G          = 0.23
				settings_ini.MyStyle.Title_B          = 0.16
				settings_ini.MyStyle.Title_A          = 1.00
				settings_ini.MyStyle.Separator_R      = 0.43
				settings_ini.MyStyle.Separator_G      = 0.43
				settings_ini.MyStyle.Separator_B      = 0.50
				settings_ini.MyStyle.Separator_A      = 0.50
				settings_ini.MyStyle.CheckMark_R      = 0.98
				settings_ini.MyStyle.CheckMark_G      = 0.43
				settings_ini.MyStyle.CheckMark_B      = 0.26
				settings_ini.MyStyle.CheckMark_A      = 1.00
				settings_ini.MyStyle.WindowBg_R       = 0.06
				settings_ini.MyStyle.WindowBg_G       = 0.06
				settings_ini.MyStyle.WindowBg_B       = 0.06
				settings_ini.MyStyle.WindowBg_A       = 0.94
				inicfg.save(settings_ini, directSettings)
				imgui.updateMyStyle()
			end
		end
		imgui.EndChild()
		imgui.End()
	end
end

function imgui.RoundDiagram(valTable, radius, segments, plusX)
    local draw_list = imgui.GetWindowDrawList()
    local default = imgui.GetStyle().AntiAliasedShapes
    imgui.GetStyle().AntiAliasedShapes = false
    local center = imgui.ImVec2(imgui.GetCursorScreenPos().x + radius, imgui.GetCursorScreenPos().y + radius)

    local sum = 0
    local q = {}
 
    for k, v in ipairs(valTable) do
        sum = sum + v.v
    end

    for k, v in ipairs(valTable) do
        if k > 1 then
            q[k] = q[k-1] + round(valTable[k].v/sum*segments)
        else
            q[k] = round(valTable[k].v/sum*segments)
        end
    end

    local current = 1
    local count = 1
    local theta = 0
    local step = 2*math.pi/segments

    for i = 1, segments do -- theta < 2*math.pi
        if q[current] < count then
            current = current + 1
        end
        draw_list:AddTriangleFilled(center, imgui.ImVec2(center.x + radius*math.cos(theta), center.y + radius*math.sin(theta)), imgui.ImVec2(center.x + radius*math.cos(theta+step), center.y + radius*math.sin(theta+step)), valTable[current].color)
        theta = theta + step
        count = count + 1
    end

    local fontsize = imgui.GetFontSize()
    local indented = 2*(radius + imgui.GetStyle().ItemSpacing.x)
    imgui.Indent(indented)

    imgui.SameLine(0)
    imgui.NewLine() -- awful fix for first line padding
    imgui.SetCursorScreenPos(imgui.ImVec2(imgui.GetCursorScreenPos().x, center.y - imgui.GetTextLineHeight() * #valTable / 2))
    for k, v in ipairs(valTable) do
		imgui.SetCursorPosX(imgui.GetCursorPosX() + fontsize*1.3 + 5 + plusX)
        draw_list:AddRectFilled(imgui.ImVec2(imgui.GetCursorScreenPos().x, imgui.GetCursorScreenPos().y), imgui.ImVec2(imgui.GetCursorScreenPos().x + fontsize, imgui.GetCursorScreenPos().y + fontsize), v.color)
        imgui.SetCursorPosX(imgui.GetCursorPosX() + fontsize*1.3 + 5)
		imgui.Text(u8(v.name .. ' - ' .. v.v .. ' (' .. string.format('%.2f', v.v/sum*100) .. '%)'))
    end
    imgui.Unindent(indented)
    imgui.SetCursorScreenPos(imgui.ImVec2(imgui.GetCursorScreenPos().x, center.y + radius + imgui.GetTextLineHeight()))
    imgui.GetStyle().AntiAliasedShapes = default
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

function imgui.bufferingBar(value, size_arg, circle)
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

function imgui.initBuffers()
	sw, sh = getScreenResolution()
	buffering_bar_position = nil
	imgui.bufferingBarHovered = false
	tab = imgui.ImInt(1)
	main_window_state = imgui.ImBool(false)
	text_buffer_target, text_buffer_name, text_buffer_nick, text_buffer_summa = imgui.ImBuffer(256), imgui.ImBuffer(256), imgui.ImBuffer(256), imgui.ImBuffer(256)
	text_buffer_token, text_buffer_chat_id = imgui.ImBuffer(256), imgui.ImBuffer(256)
	buffering_bar_position_fixed = true
	donaters_list_silder = imgui.ImInt(1)
	donaters_list = true
	tLastKeys = {}
	imgui.SettingsTab   = 1
	imgui.donateSize    = imgui.ImInt(settings_ini.Settings.donateSize)
	combo_select        = imgui.ImInt(settings_ini.Settings.themeId)
	color_text          = imgui.ImFloat4(settings_ini.MyStyle.Text_R, settings_ini.MyStyle.Text_G, settings_ini.MyStyle.Text_B, settings_ini.MyStyle.Text_A)
	color_button 	    = imgui.ImFloat4(settings_ini.MyStyle.Button_R, settings_ini.MyStyle.Button_G, settings_ini.MyStyle.Button_B, settings_ini.MyStyle.Button_A)
	color_button_active = imgui.ImFloat4(settings_ini.MyStyle.ButtonActive_R, settings_ini.MyStyle.ButtonActive_G, settings_ini.MyStyle.ButtonActive_B, settings_ini.MyStyle.ButtonActive_A)
	color_frame         = imgui.ImFloat4(settings_ini.MyStyle.FrameBg_R, settings_ini.MyStyle.FrameBg_G, settings_ini.MyStyle.FrameBg_B, settings_ini.MyStyle.FrameBg_A)
	color_frame_hovered = imgui.ImFloat4(settings_ini.MyStyle.FrameBgHovered_R, settings_ini.MyStyle.FrameBgHovered_G, settings_ini.MyStyle.FrameBgHovered_B, settings_ini.MyStyle.FrameBgHovered_A)
	color_title         = imgui.ImFloat4(settings_ini.MyStyle.Title_R, settings_ini.MyStyle.Title_G, settings_ini.MyStyle.Title_B, settings_ini.MyStyle.Title_A)
	color_separator     = imgui.ImFloat4(settings_ini.MyStyle.Separator_R, settings_ini.MyStyle.Separator_G, settings_ini.MyStyle.Separator_B, settings_ini.MyStyle.Separator_A)
	color_windowbg      = imgui.ImFloat4(settings_ini.MyStyle.WindowBg_R, settings_ini.MyStyle.WindowBg_G, settings_ini.MyStyle.WindowBg_B, settings_ini.MyStyle.WindowBg_A)
	color_checkmark     = imgui.ImFloat4(settings_ini.MyStyle.CheckMark_R, settings_ini.MyStyle.CheckMark_G, settings_ini.MyStyle.CheckMark_B, settings_ini.MyStyle.CheckMark_A)
end

function imgui.updateMyStyle(themaId)
	themes.SwitchColorTheme(themaId, settings_ini.MyStyle.Text_R, settings_ini.MyStyle.Text_G, settings_ini.MyStyle.Text_B, settings_ini.MyStyle.Text_A,
		settings_ini.MyStyle.Button_R, settings_ini.MyStyle.Button_G, settings_ini.MyStyle.Button_B, settings_ini.MyStyle.Button_A,
		settings_ini.MyStyle.ButtonActive_R, settings_ini.MyStyle.ButtonActive_G, settings_ini.MyStyle.ButtonActive_B, settings_ini.MyStyle.ButtonActive_A,
		settings_ini.MyStyle.FrameBg_R, settings_ini.MyStyle.FrameBg_G, settings_ini.MyStyle.FrameBg_B, settings_ini.MyStyle.FrameBg_A,
		settings_ini.MyStyle.FrameBgHovered_R, settings_ini.MyStyle.FrameBgHovered_G, settings_ini.MyStyle.FrameBgHovered_B, settings_ini.MyStyle.FrameBgHovered_A,
		settings_ini.MyStyle.Title_R, settings_ini.MyStyle.Title_G, settings_ini.MyStyle.Title_B, settings_ini.MyStyle.Title_A,
		settings_ini.MyStyle.Separator_R, settings_ini.MyStyle.Separator_G, settings_ini.MyStyle.Separator_B, settings_ini.MyStyle.Separator_A,
		settings_ini.MyStyle.CheckMark_R, settings_ini.MyStyle.CheckMark_G, settings_ini.MyStyle.CheckMark_B, settings_ini.MyStyle.CheckMark_A,
		settings_ini.MyStyle.WindowBg_R, settings_ini.MyStyle.WindowBg_G, settings_ini.MyStyle.WindowBg_B, settings_ini.MyStyle.WindowBg_A)
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

------------------------------------------ SoundManager ------------------------------------------
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

------------------------------------------ ChatManager ------------------------------------------
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

function chatManager.updateAntifloodClock()
    chatManager.antifloodClock = os.clock()
    if string.sub(chatManager.lastMessage, 1, 5) == "/sms " or string.sub(chatManager.lastMessage, 1, 3) == "/t " then
        chatManager.antifloodClock = chatManager.antifloodClock + 0.5
    end
end

------------------------------------------ HotKey ------------------------------------------
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

local xz = {}
	xz._Settings = {
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
			sKeys = tHotKeyData.tickState and xz._Settings.noKeysMessage or " "
		else
			sKeys = table.concat(getKeysName(tKeys), " + ")
		end
	end
    imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.FrameBg])
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.FrameBgHovered])
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.FrameBgActive])
    if imgui.Button((tostring(sKeys):len() == 0 and xz._Settings.noKeysMessage or sKeys) .. name, imgui.ImVec2(width, 0)) then
        tHotKeyData.edit = name
    end
    imgui.PopStyleColor(3)
    return bool
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

function getKeyNumber(id)
	for k, v in ipairs(tKeys) do
		if v == id then
			return k
		end
	end
	return -1
end

function reloadKeysList()
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

------------------------------------------ Telegram ------------------------------------------
function tg.threadHandle(runner, url, args, resolve, reject)
    local t = runner(url, args)
    local r = t:get(0)
    while not r do
        r = t:get(0)
        wait(0)
    end
    local status = t:status()
    if status == 'completed' then
        local ok, result = r[1], r[2]
        if ok then resolve(result) else reject(result) end
    elseif err then
        reject(err)
    elseif status == 'canceled' then
        reject(status)
    end
    t:cancel(0)
end

function tg.requestRunner()
    return effil.thread(function(u, a)
        local https = require 'ssl.https'
        local ok, result = pcall(https.request, u, a)
        if ok then
            return {true, result}
        else
            return {false, result}
        end
    end)
end

function tg.async_http_request(url, args, resolve, reject)
    local runner = tg.requestRunner()
    if not reject then reject = tg.reject() end
    lua_thread.create(function()
        tg.threadHandle(runner, url, args, resolve, reject)
    end)
end

function tg.reject() end

function tg.encodeUrl(str)
    str = str:gsub(' ', '%+')
    str = str:gsub('\n', '%%0A')
    return u8:encode(str, 'CP1251')
end

function tg.sendNotification(msg)
    msg = msg:gsub('{......}', '')
    msg = tg.encodeUrl(msg)
    tg.async_http_request('https://api.telegram.org/bot' .. settings_ini.Telegram.token .. '/sendMessage?chat_id=' .. settings_ini.Telegram.chat_id .. '&text=' .. msg, '', function(result) end)
end

function tg.getUpdates()
    while not updateid do wait(1) end
    local runner = tg.requestRunner()
    local reject = tg.reject()
    local args = ''
    while true do
        url = 'https://api.telegram.org/bot' .. settings_ini.Telegram.token .. '/getUpdates?chat_id=' .. settings_ini.Telegram.chat_id .. '&offset=-1'
        tg.threadHandle(runner, url, args, tg.processingMessages, reject)
        wait(0)
    end
end

function tg.processingMessages(result)
    if result then	
        local proc_table = decodeJson(result)
        if proc_table.ok then
            if #proc_table.result > 0 then
                local res_table = proc_table.result[1]
                if res_table then
                    if res_table.update_id ~= updateid then
                        updateid = res_table.update_id
                        local message_from_user = res_table.message.text					
                        if message_from_user then
                            local text = u8:decode(message_from_user) .. ' '
							if text == "/showDonations " then
								settings_ini.Telegram.bool = not settings_ini.Telegram.bool
								if settings_ini.Telegram.bool then 
									sampAddChatMessage(prefix .. u8:decode"Пожертвования транслируются в чат бота", main_color)
								else
									sampAddChatMessage(prefix .. u8:decode"Пожертвования больше не транслируются в чат бота", main_color)
								end
								inicfg.save(settings_ini, directSettings)
							elseif text == "/showdonaters " then
								tg.donaters()
							elseif text == "/showtopdonaters " then
								tg.topDonaters()
							elseif text == "/showtopdonatersZiel " then
								tg.topDonatersZiel()
							elseif text == "/showtodaydonatemoney " then
								tg.todayDonateMoney()
							elseif text == "/showdonatemoney " then
								tg.DonateMoney()
							elseif text == "/showdonatemoneyziel " then
								tg.DonateMoneyZiel()
							elseif text == "/donaters " then
								donatik.sendTodayDonaters()
							elseif text == "/topdonaters " then
								donatik.sendTopDonaters()
							elseif text == "/topdonatersziel " then
								donatik.sendTopDonatersZiel()
							elseif text == "/todaydonatemoney " then
								donatik.sendTodayDonateMoney()
							elseif text == "/donatemoney " then
								donatik.sendDonateMoney()
							elseif text == "/donatemoneyziel " then
								donatik.sendDonateMoneyZiel()
							elseif text:match("/s ") then
								local arg = text:gsub('/s ', '')
								if #arg > 0 then
									sampSendChat(arg)
								end
							elseif text == "/help " then
								tg.sendNotification("/showdonations - донаты из игры в чат")
								tg.sendNotification("/showdonaters - [тг] донатеры за день")
								tg.sendNotification("/showtopdonaters - [тг] донатеры за все время")
								tg.sendNotification("/showtopdonatersziel - [тг] донатеры на цель")
								tg.sendNotification("/showtodaydonatemoney - [тг] донат за сегодня")
								tg.sendNotification("/showdonatemoney - [тг] донат за все время")
								tg.sendNotification("/showdonatemoneyziel - [тг] донат на цель")
								tg.sendNotification("/donaters - [игра] донатеры за день")
								tg.sendNotification("/topdonaters - [игра] донатеры за все время")
								tg.sendNotification("/topdonatersziel - [игра] донатеры на цель")
								tg.sendNotification("/todaydonatemoney - [игра] донат за сегодня")
								tg.sendNotification("/donatemoney - [игра] донат за все время")
								tg.sendNotification("/donatemoneyziel - [игра] донат на цель")
								tg.sendNotification("/s - [игра] сообщение в чат")
							end
                        end
                    end
                end
            end
        end
    end
end

function tg.getLastUpdate()
    tg.async_http_request('https://api.telegram.org/bot' .. settings_ini.Telegram.token .. '/getUpdates?chat_id=' .. settings_ini.Telegram.chat_id .. '&offset=-1', '', function(result)
        if result then
            local proc_table = decodeJson(result)
            if proc_table.ok then
                if #proc_table.result > 0 then
                    local res_table = proc_table.result[1]
                    if res_table then
                        updateid = res_table.update_id
                    end
                else
                    updateid = 1
                end
            end
        end
    end)
end

function tg.donaters()
	local rankFirst, rankSecond, rankThird = "Господин", "Господин", "Господин"
	if donaters_ini[todayTopDonaters_ini[todayTopPlayers].firstName] ~= nil then
		rankFirst = u8(donaters_ini[todayTopDonaters_ini[todayTopPlayers].firstName].rank)
	end
	if donaters_ini[todayTopDonaters_ini[todayTopPlayers].secondName] ~= nil then
		rankSecond = u8(donaters_ini[todayTopDonaters_ini[todayTopPlayers].secondName].rank)
	end
	if donaters_ini[todayTopDonaters_ini[todayTopPlayers].thirdName] ~= nil then
		rankThird = u8(donaters_ini[todayTopDonaters_ini[todayTopPlayers].thirdName].rank)
	end

	lua_thread.create(function()
		tg.sendNotification(u8:decode("1. " .. rankFirst  .. " " .. u8(todayTopDonaters_ini[todayTopPlayers].firstName)  .. " с суммой " .. convertNumber(todayTopDonaters_ini[todayTopPlayers].firstSumma)  .. " вирт"))
		wait(500)
		tg.sendNotification(u8:decode("2. " .. rankSecond .. " " .. u8(todayTopDonaters_ini[todayTopPlayers].secondName) .. " с суммой " .. convertNumber(todayTopDonaters_ini[todayTopPlayers].secondSumma) .. " вирт"))
		wait(500)
		tg.sendNotification(u8:decode("3. " .. rankThird  .. " " .. u8(todayTopDonaters_ini[todayTopPlayers].thirdName)  .. " с суммой " .. convertNumber(todayTopDonaters_ini[todayTopPlayers].thirdSumma)  .. " вирт"))
		wait(500)
	end)
end

function tg.topDonaters()
	lua_thread.create(function()
		for i = 1, 3 do
			donatersRating_ini = inicfg.load(i, directDonatersRating)
			if donatersRating_ini[i] ~= nil then
				tg.sendNotification(u8:decode(i .. ". " .. donaters_ini[donatersRating_ini[i].nick].rank .. " " .. donatersRating_ini[i].nick .. " с суммой " .. convertNumber(donatersRating_ini[i].money) .. " вирт"))
			else
				tg.sendNotification(u8:decode(i .. ". Господин Пусто с суммой 0 вирт"))
			end
			wait(500)
		end
	end)
end

function tg.topDonatersZiel()
	lua_thread.create(function()
		for i = 1, 3 do
			donatersRatingZiel_ini = inicfg.load(i, directDonatersRatingZiel)
			if donatersRatingZiel_ini[i] ~= nil then
				tg.sendNotification(u8:decode(i .. ". " .. donaters_ini[donatersRatingZiel_ini[i].nick].rank .. " " .. donatersRatingZiel_ini[i].nick .. " с суммой " .. convertNumber(donatersRatingZiel_ini[i].money) .. " вирт"))
			else
				tg.sendNotification(u8:decode(i .. ". Господин Пусто с суммой 0 вирт"))
			end
			wait(500)
		end
	end)
end

function tg.todayDonateMoney()
	tg.sendNotification(u8:decode("Всего за день собрано: " .. convertNumber(todayTopDonaters_ini[todayTopPlayers].money)))
end

function tg.DonateMoney()
	tg.sendNotification(u8:decode("Денег собрано за все время: " .. convertNumber(statistics_ini[DonateMoney].money)))
end

function tg.DonateMoneyZiel()
	tg.sendNotification(u8:decode(string.format("Денег на цель \"%s\" собрано: %s/%s [%s]", statistics_ini[DonateMoney].zielName, convertNumber(statistics_ziel_ini[DonateMoneyZiel].money), convertNumber(statistics_ziel_ini[DonateMoneyZiel].target), string.sub(tostring(percent * 100), 1, 5))))
end

function tg.sendPhoto(caption)
	if screenshotIsAvailable then
		lua_thread.create(function()
			wait(1000)
			screenshot.requestEx(screenshot_dir, "screenshot")
			wait(1000)
			local result, response = tg.request(
				'POST',
				'sendPhoto',
				{
					['chat_id'] = tostring(settings_ini.Telegram.chat_id),
					['caption'] = u8(tostring(caption))
				},
				{
					['photo'] = string.format('%s\\%s', screenshot_dir, "screenshot.png")
				},
				tostring(settings_ini.Telegram.token)
			)
		end)
	else
		sampAddChatMessage(prefix .. u8:decode("Библиотека не обнаружена!"), main_color)
	end
end

function tg.request(requestMethod, telegramMethod, requestParameters, requestFile, botToken, debugMode)
    local requestMethod = requestMethod or 'POST'
    if (type(requestMethod) ~= 'string') then
        error('[MoonGram Error] In Function "tg.request", Argument #1(requestMethod) Must Be String.')
    end
    if (requestMethod ~= 'POST' and requestMethod ~= 'GET' and requestMethod ~= 'PUT' and requestMethod ~= 'DETELE') then
        error('[MoonGram Error] In Function "tg.request", Argument #1(requestMethod) Dont Have "%s" Request Method.', tostring(requestMethod))
    end
	
    local telegramMethod = telegramMethod or nil
    if (type(telegramMethod) ~= 'string') then
        error('[MoonGram Error] In Function "tg.request", Argument #2(telegramMethod) Must Be String.\nCheck: https://core.telegram.org/bots/api')
    end
	
    local requestParameters = requestParameters or {}
    if (type(requestParameters) ~= 'table') then
        error('[MoonGram Error] In Function "tg.request", Argument #3(requestParameters) Must Be Table.')
    end
    for key, value in ipairs(requestParameters) do
        if (#requestParameters ~= 0) then
            requestParameters[key] = tostring(value)
        else
            requestParameters = {''}
        end
    end
	
    local botToken = botToken or nil
    if (type(botToken) ~= 'string') then
        error('[MoonGram Error] In Function "tg.request", Argument #4(botToken) Must Be String.')
    end
	
    local debugMode = debugMode or false
    if (type(debugMode) ~= 'boolean') then
        error('[MoonGram Error] In Function "tg.request", Argument #5(debugMode) Must Be Boolean.')
    end

    if (requestFile and next(requestFile) ~= nil) then
        local fileType, fileName = next(requestFile)
        local file = io.open(fileName, 'rb')
        if (file) then
            lua_thread.create(function ()
                requestParameters[fileType] = {
                    filename = fileName,
                    data = file:read('*a')
                }
            end)
            file:close()
        else
			if fileType ~= nil then
				sampAddChatMessage(tostring(requestParameters[fileType]), -1)
				sampAddChatMessage(tostring(fileType), -1)
				requestParameters[fileType] = fileName
			end
        end
    end

    local requestData = {
        ['method'] = tostring(requestMethod),
        ['url']    = string.format('https://api.telegram.org/bot%s/%s', tostring(botToken), tostring(telegramMethod))
    }
	
    local body, boundary = multipart.encode(requestParameters)
	
    local thread = effil.thread(function (requestData, body, boundary)
        local response = {}

        --[[ Include Libraries ]]--
        local channel_library_requests = require('ssl.https')
        local channel_library_ltn12    = require('ltn12')

        --[[ Manipulations ]]--
        local _, source = pcall(channel_library_ltn12.source.string, body)
        local _, sink   = pcall(channel_library_ltn12.sink.table, response)

        --[[ Request ]]--
        local result, _ = pcall(channel_library_requests.request, {
                ['url']     = requestData['url'],
                ['method']  = requestData['method'],
                ['headers'] = {
                    ['Accept']          = '*/*',
                    ['Accept-Encoding'] = 'gzip, deflate',
                    ['Accept-Language'] = 'en-us',
                    ['Content-Type']    = string.format('multipart/form-data; boundary=%s', tostring(boundary)),
                    ['Content-Length']  = #body
                },
                ['source']  = source,
                ['sink']    = sink
        })
        if (result) then
            return { true, response }
        else
            return { false, response }
        end
    end)(requestData, body, boundary)

    local result = thread:get(0)
    while (not result) do
        result = thread:get(0)
        wait(0)
    end
	
    local status, error = thread:status()
    if (not error) then
        if (status == 'completed') then
            local response = dkjson.decode(result[2][1])
            --[[ result[1] = boolean ]]--
            if (result[1]) then
                return true, response
            else
                return false, response
            end
        elseif (status ~= 'running' and status ~= 'completed') then
            return false, string.format('[TelegramLibrary] Error; Effil Thread Status was: %s', tostring(status))
        end
    else
        return false, error
    end
    thread:cancel(0)
end

------------------------------------------ UPDATE ------------------------------------------
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

------------------------------------------ onScriptTerminate ------------------------------------------
function onScriptTerminate(LuaScript, quitGame)
	if LuaScript == thisScript() then
		for i = 0, 1000 do
			if textlabel[i] ~= nil then
				sampDestroy3dText(textlabel[i])
				textlabel[i] = nil
			end
		end
		imgui.Process = false
		if not script.reload then
			if not script.update then 
				sampAddChatMessage(prefix .. u8:decode"Скрипт крашнулся!", main_color) 
			else
				sampAddChatMessage(prefix .. u8:decode"Старый скрипт был выгружен, загружаю обновлённую версию...", main_color) 
			end
		else
			sampAddChatMessage(prefix .. u8:decode"Скрипт перезагружается!", main_color)
		end
	end
end	
