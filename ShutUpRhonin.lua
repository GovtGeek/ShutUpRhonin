_, ShutUpRhonin = ...
ShutUpRhonin.addonName = "ShutUpRhonin"


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
    local zone = C_Map.GetBestMapForUnit("player")
    if zone == 125 and author == sRhonin then -- we're in Dalaran and Rhonin is yelling
        return true -- filter it
    else
        return false, msg, author, ... -- let it pass
    end
end

-- The interface options panel
function ShutUpRhonin:CreateOptionsFrame()
	if not self.OptionsPanel then
		self.OptionsPanel = CreateFrame("Frame", "ShutUpRhoninOptionsFrame")
		self.OptionsPanel.name = ShutUpRhoninTitle

		-- Filter text yell checkbox
		cbFilterTextYell = CreateFrame("CheckButton", nil, self.OptionsPanel, "InterfaceOptionsCheckButtonTemplate")
		cbFilterTextYell:SetPoint("TOPLEFT", 20, -20)
		cbFilterTextYell.Text:SetText("Filter text yell")
		cbFilterTextYell:HookScript("OnClick", function(_, btn, down)
			self.options.FilterTextYell = cbFilterTextYell:GetChecked()
		end)
		self.OptionsPanel.cbFilterTextYell = cbFilterTextYell
	end

	-- Add the panel to the interface options
	InterfaceOptions_AddCategory(self.OptionsPanel)
	return self.OptionsPanel
end

function ShutUpRhonin:InitializeOptions()
	cbFilterTextYell:SetChecked(self.options.FilterTextYell)
end

function ShutUpRhonin:VariablesLoaded()
	ShutUpRhonin.options = ShutUpRhoninSettings.options or defaultOptions
end

function ShutUpRhonin:OnEvent(event, addonName, isLogin, isReload)
	if addonName ~= ShutUpRhonin.addonName then return end
	if event == "ADDON_LOADED" then
		ShutUpRhonin:CreateOptionsFrame()
		ShutUpRhonin:InitializeOptions()
		return
	elseif event == "VARIABLES_LOADED" then
	end
	if isLogin or isReload then
        local RhoninEvent = { 559126, 559127, 559128, 559129, 559130, 559131, 559132, 559133, }
        for _, yell in pairs(RhoninEvent) do
            MuteSoundFile(yell)
        end
        ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", RhoninFilter)
	end
end

ShutUpRhoninFrame:RegisterEvent("ADDON_LOADED")
ShutUpRhoninFrame:RegisterEvent("VARIABLES_LOADED")
ShutUpRhoninFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ShutUpRhoninFrame:SetScript("OnEvent", ShutUpRhonin.OnEvent)

SLASH_SHUTUPRHONIN1 = "/shutuprhonin"
SlashCmdList.SHUTUPRHONIN = function(msg, editBox)
	-- Call it twice because of a Blizzard bug
	InterfaceOptionsFrame_OpenToCategory(ShutUpRhonin.OptionsPanel)
	InterfaceOptionsFrame_OpenToCategory(ShutUpRhonin.OptionsPanel)
end