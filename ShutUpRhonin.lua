local frame = CreateFrame("Frame", "ShutUpRhoninFrame")
frame:RegisterEvent("ZONE_CHANGED")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
function frame:OnEvent(event)
    if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" then
        cvar_dialog = C_CVar.GetCVar("Sound_EnableDialog")
        if GetZoneText() == "Dalaran" then
            dialog_result = C_CVar.SetCVar("Sound_EnableDialog", 0)
        else
            dialog_result = C_CVar.SetCVar("Sound_EnableDialog", 1)
        end
    end
end;
frame:SetScript("OnEvent", frame.OnEvent);
