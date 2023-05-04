local IsRhonin = {
    ["Rhonin"] = true, -- enUS, deDE, esES, frFR, itIT, ptBR
    ["Ронин"] = true, -- ruRU
    ["로닌"] = true, -- koKR
    ["罗宁"] = true, -- zhCN
}

local function RhoninFilter(self, event, msg, author, ...)
    local zone = C_Map.GetBestMapForUnit("player")
    if zone == 125 and IsRhonin[author] then -- we're in Dalaran and Rhonin is yelling
        return true -- filter it
    else
        return false, msg, author, ... -- let it pass
    end
end

local function OnEvent(self, event, isLogin, isReload)
	if isLogin or isReload then
        local RhoninEvent = { 559126, 559127, 559128, 559129, 559130, 559131, 559132, 559133, }
        for _, yell in pairs(RhoninEvent) do
            MuteSoundFile(yell)
        end
        ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", RhoninFilter)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", OnEvent)
