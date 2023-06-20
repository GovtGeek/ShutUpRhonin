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
	if not self.OptionsPanel then
		local panel = CreateFrame("Frame", "ShutUpRhoninOptionsFrame", nil, BackdropTemplateMixin and "BackdropTemplate")
		self.OptionsPanel = panel
		self.OptionsPanel.name = L.ShutUpRhoninTitle

		-- Title of our options panel
		local text = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLargeLeftTop")
		text:SetSize(290, 0)
		text:SetJustifyV("MIDDLE")
		local _, fontHeight = text:GetFont()
		fontHeight = math.floor(fontHeight)
		text:SetPoint("TOPLEFT", 16, -fontHeight)
		text:SetText(ShutUpRhoninTitle)

		-- Filter text yell checkbox
		cbFilterYellText = CreateFrame("CheckButton", nil, self.OptionsPanel, "InterfaceOptionsCheckButtonTemplate")
		cbFilterYellText:SetPoint("TOPLEFT", text, 0, -fontHeight)
		cbFilterYellText.Text:SetText(L.FilterYellText)
		cbFilterYellText:HookScript("OnClick", function(_, btn, down)
			self.options.FilterYellText = cbFilterYellText:GetChecked()
		end)
		self.OptionsPanel.cbFilterYellText = cbFilterYellText
	end
	-- Add the panel to the interface options
	InterfaceOptions_AddCategory(self.OptionsPanel)
	return self.OptionsPanel
end

function ShutUpRhonin:InitializeOptions()
	self.OptionsPanel.cbFilterYellText:SetChecked(self.options.FilterYellText)
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
		ShutUpRhonin.OptionsPanel = ShutUpRhonin:CreateOptionsFrame()
		ShutUpRhonin:InitializeOptions()
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
end

ShutUpRhoninFrame:RegisterEvent("ADDON_LOADED")
ShutUpRhoninFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ShutUpRhoninFrame:SetScript("OnEvent", ShutUpRhonin.OnEvent)

SLASH_SHUTUPRHONIN1 = "/shutuprhonin"
SlashCmdList.SHUTUPRHONIN = function(msg, editBox)
	-- Call it twice because of a Blizzard bug
	InterfaceOptionsFrame_OpenToCategory(ShutUpRhonin.OptionsPanel)
	InterfaceOptionsFrame_OpenToCategory(ShutUpRhonin.OptionsPanel)
end