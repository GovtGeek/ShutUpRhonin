local function RhoninFilter(self, event, msg, author, ...)
    local lang, channel, author2, flags, zonechannel, channelid, channelbase, langid, lineid, guid = ...
    local zone = C_Map.GetBestMapForUnit("player")
    local _, _, _, _, _, npcid = strsplit("-", guid or "")
    npcid = tonumber(npcid)
    if npcid == 16128 and zone == 125 then -- language independent check
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
        ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", RhoninFilter)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", OnEvent)
