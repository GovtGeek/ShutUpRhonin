local addonName, ShutUpRhonin = ...
local L = ShutUpRhonin.L -- populated in ShutUpRhoninStrings.lua
ShutUpRhonin.addonName = "ShutUpRhonin"


local defaultOptions = {
	FilterYellText = true
}

ShutUpRhoninSettings = {
	options = defaultOptions
}

ShutUpRhonin.options = ShutUpRhoninSettings.options or defaultOptions

-- The frame used for the addon to catch events
local ShutUpRhoninFrame = CreateFrame("Frame", "ShutUpRhoninFrame")

-- The interface options panel
function ShutUpRhonin:CreateOptionsFrame()

	local category, layout = Settings.RegisterVerticalLayoutCategory(L.ShutUpRhoninTitle)

	local yellSetting = Settings.RegisterProxySetting(category, "FilterYellCheckbox", Settings.VarType.Boolean, L.FilterYellText, true,
		function () return ShutUpRhoninSettings.options.FilterYellText end,
		function (value) ShutUpRhoninSettings.options.FilterYellText = value end)
	Settings.CreateCheckbox(category, yellSetting)
	Settings.RegisterAddOnCategory(category)
	return nil
end

function ShutUpRhonin:VariablesLoaded()
	ShutUpRhonin.options = ShutUpRhoninSettings.options or defaultOptions
end

local function RhoninFilter(self, event, msg, author, ...)
	if ShutUpRhonin.options.FilterYellText then
		local zone = C_Map.GetBestMapForUnit("player")
		if (zone == 125 or zone == 126) and author == L.Rhonin then -- we're in Dalaran and Rhonin is yelling
			return true -- filter it
		end
	end
	return false, msg, author, ... -- let it pass
end

function ShutUpRhonin:OnEvent(event, ...)
	local addonName = ...
	local isLogin, isReload = ...
	if event == "ADDON_LOADED" then
		if addonName ~= ShutUpRhonin.addonName then return end -- bail fast
			ShutUpRhonin:VariablesLoaded()
			ShutUpRhonin:MuteSounds()
        	ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", RhoninFilter)
		return
	elseif isLogin or isReload then
		ShutUpRhonin:MuteSounds()
	end
end

function ShutUpRhonin:MuteSounds()
	local RhoninEvent = { 559126, 559127, 559128, 559129, 559130, 559131, 559132, 559133, }
	for _, yell in pairs(RhoninEvent) do
		MuteSoundFile(yell)
	end
	local KalecgosEvent = { 552973, 552998, 552962, 552999, 552979, 553004, 553012, 552968, 552992, }
	for _, yell in pairs(KalecgosEvent) do
		MuteSoundFile(yell)
	end
end

ShutUpRhoninFrame:RegisterEvent("ADDON_LOADED")
ShutUpRhoninFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ShutUpRhoninFrame:SetScript("OnEvent", ShutUpRhonin.OnEvent)

SLASH_SHUTUPRHONIN1 = "/shutuprhonin"
SlashCmdList.SHUTUPRHONIN = function(msg, editBox)
	Settins.OpenToCategory(L.ShutUpRhoninTitle)
end
