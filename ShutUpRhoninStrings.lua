-- all Lua files referenced in the .toc get passed a vararg by the wow client
-- with the first argument being the addon name and the second a Lua array scoped to the addon
-- this array is the proper way to share information among a single addon's files without polluting the global env
local _, ShutUpRhonin = ...
-- this metatable ensures any attempt to call L["Some Term"] will never error and just return the key.
-- it also caches it in the table so next time it is referenced the __index function doesn't run again.
local L = setmetatable({}, { __index = function(t, k)
  local v = tostring(k)
  rawset(t, k, v)
  return v
end })
ShutUpRhonin.L = L -- store the reference to  our localization array as a key in the shared array so we can use it in other files without making it global

local LOCALE = GetLocale() -- query the player's client locale so we only load that locale's terms, default to English

if LOCALE == "ruRU" then
  L["Rhonin"] = "Ронин"
  return
elseif LOCALE == "koKR" then
  L["Rhonin"] = "로닌"
  return
elseif LOCALE == "zhCN" then
  L["Rhonin"] = "罗宁"
  return
else -- fallback to English
  L["Rhonin"] = "Rhonin"
  L["Title"] = "Shut Up Rhonin"
  L["OptionYell"] = "Filter yell"
end
