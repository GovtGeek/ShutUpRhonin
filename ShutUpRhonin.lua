local function OnEvent(self, event, isLogin, isReload)
	if isLogin or isReload then
        local RhoninEvent = { 559130, 559131, 559132, 559133, 559134, 559135, 559136, 559137, 559138 }
        for _, yell in pairs(RhoninEvent) do
            MuteSoundFile(yell)
        end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", OnEvent)
