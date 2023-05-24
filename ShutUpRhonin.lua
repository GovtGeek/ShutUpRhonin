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
    if zone == 125 and author == sRhonin and ShutUpRhonin.options.FilterTextYell then -- we're in Dalaran and Rhonin is yelling
        return true -- filter it
    else
        return false, msg, author, ... -- let it pass
    end
end

-- The interface options panel
function ShutUpRhonin:CreateOptionsFrame()
	if not self.OptionsPanel then
		local panel = CreateFrame("Frame", "ShutUpRhoninOptionsFrame", nil, BackdropTemplateMixin and "BackdropTemplate")
		self.OptionsPanel = panel
		self.OptionsPanel.name = ShutUpRhoninTitle

		-- Title of our options panel
		local text = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLargeLeftTop")
		text:SetSize(290, 0)
		text:SetJustifyV("MIDDLE")
		local _, fontHeight = text:GetFont()
		fontHeight = math.floor(fontHeight)
		text:SetPoint("TOPLEFT", 16, -fontHeight)
		text:SetText(ShutUpRhoninTitle)

		-- Filter text yell checkbox
		cbFilterTextYell = CreateFrame("CheckButton", nil, self.OptionsPanel, "InterfaceOptionsCheckButtonTemplate")
		cbFilterTextYell:SetPoint("TOPLEFT", text, 0, -fontHeight)
		cbFilterTextYell.Text:SetText(sFilterTextYell)
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
	cbFilterTextYell:SetChecked(self.options.FilterTextYell)
end

function ShutUpRhonin:VariablesLoaded()
	ShutUpRhonin.options = ShutUpRhoninSettings.options or defaultOptions
	ShutUpRhonin:InitializeOptions()
end

function ShutUpRhonin:OnEvent(event, addonName, isLogin, isReload)
	if event == "VARIABLES_LOADED" then
		-- Load our variables
		ShutUpRhonin:VariablesLoaded()
	end
	if event == "ADDON_LOADED" and addonName == ShutUpRhonin.addonName then
		ShutUpRhonin:CreateOptionsFrame()
		ShutUpRhonin:InitializeOptions()
		return
	else
	end
	if isLogin or isReload then
		--print("Muting Rhonin")
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