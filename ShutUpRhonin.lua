local function OnEvent(self, event, isLogin, isReload)
	if isLogin or isReload then
        local RhoninEvent = { 559126, 559127, 559128, 559129, 559130, 559131, 559132, 559133, }
        for _, yell in pairs(RhoninEvent) do
            MuteSoundFile(yell)
        end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", OnEvent)
