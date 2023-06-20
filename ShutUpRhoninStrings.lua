local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end})
local _, ShutUpRhonin = ...
ShutUpRhonin.L = L

L.Rhonin = "Rhonin"
L.ShutUpRhoninTitle = "Shut Up "..L.Rhonin
L.FilterYellText = "Filter yell text"