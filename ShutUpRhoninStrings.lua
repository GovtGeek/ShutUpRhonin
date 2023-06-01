local _, ShutUpRhonin = ...
local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end})

ShutUpRhonin.L = L

L.Rhonin = "Rhonin"
L.ShutUpRhoninTitle = "Shut Up "..L.Rhonin
L.FilterYellText = "Filter yell text"

--sRhonin = "Rhonin"
--ShutUpRhoninTitle = "Shut Up "..sRhonin
--sFilterTextYell = "Filter text yell"