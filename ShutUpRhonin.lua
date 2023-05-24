local addonName, ShutUpRhonin = ...
local L = ShutUpRhonin.L -- populated in ShutUpRhoninStrings.lua

local defaultOptions = {
	FilterTextYell = true
}

ShutUpRhoninSettings = {
	options = defaultOptions
}

ShutUpRhonin.options = ShutUpRhoninSettings.options or defaultOptions

-- The frame used for the addon to catch events
local ShutUpRhoninFrame = CreateFrame("Frame", "ShutUpRhoninFrame")

local function RhoninFilter(self, event, msg, author, ...)
	if ShutUpRhonin.options.FilterTextYell then
		local zone = C_Map.GetBestMapForUnit("player")
    	if zone == 125 and author == L["Rhonin"] then -- we're in Dalaran and Rhonin is yelling
        	return true -- filter it
        else
        	return false, msg, author, ... -- let it pass
    	end
	end
	return false, msg, author, ... -- let it pass
end

-- The interface options panel
function ShutUpRhonin:CreateOptionsFrame()
	if not self.OptionsPanel then
		local panel = CreateFrame("Frame", "ShutUpRhoninOptionsFrame", nil, BackdropTemplateMixin and "BackdropTemplate")
		self.OptionsPanel = panel
		self.OptionsPanel.name = L["Title"]

		-- Title of our options panel
		local text = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLargeLeftTop")
		text:SetSize(290, 0)
		text:SetJustifyV("MIDDLE")
		local _, fontHeight = text:GetFont()
		fontHeight = math.floor(fontHeight)
		text:SetPoint("TOPLEFT", 16, -fontHeight)
		text:SetText(L["Title"])

		-- Filter text yell checkbox
		local cbFilterTextYell = CreateFrame("CheckButton", nil, self.OptionsPanel, "InterfaceOptionsCheckButtonTemplate")
		cbFilterTextYell:SetPoint("TOPLEFT", text, 0, -fontHeight)
		cbFilterTextYell.Text:SetText(L["OptionYell"])
		cbFilterTextYell:HookScript("OnClick", function(_, btn, down)
			ShutUpRhonin.options.FilterTextYell = cbFilterTextYell:GetChecked()
		end)
		self.OptionsPanel.cbFilterTextYell = cbFilterTextYell
	end

	-- Add the panel to the interface options
	InterfaceOptions_AddCategory(self.OptionsPanel)
	return self.OptionsPanel
end

function ShutUpRhonin:InitializeOptions()
	self.OptionsPanel.cbFilterTextYell:SetChecked(self.options.FilterTextYell)
end

function ShutUpRhonin:VariablesLoaded()
	ShutUpRhonin.options = ShutUpRhoninSettings.options or defaultOptions
end

function ShutUpRhonin:OnEvent(event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon == addonName then
			-- Load our variables
			ShutUpRhonin:VariablesLoaded()
			ShutUpRhonin:CreateOptionsFrame()
			ShutUpRhonin:InitializeOptions()
		end
		return
	elseif event == "PLAYER_ENTERING_WORLD" then
		local isLogin, isReload = ...
		if isLogin or isReload then
			--print("Muting Rhonin")
	        local RhoninEvent = { 559126, 559127, 559128, 559129, 559130, 559131, 559132, 559133, }
	        for _, yell in pairs(RhoninEvent) do
	            MuteSoundFile(yell)
	        end
	        ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", RhoninFilter)
		end
		return
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
