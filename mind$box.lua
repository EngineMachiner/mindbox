
local isLegacy = tapLua.isLegacy()


local path = "/Appearance/Themes/_fallback/Modules/mind$box/"

path = isLegacy and "/Modules/mind$box/" or path

mindbox = mindbox or { Path = path }


local modules = { "Config", "Print" }

for i,v in ipairs(modules) do LoadModule( "mind$box/" .. v .. ".lua" ) end

mindbox.concat = function(...) return loadfile( path .. "Concat.lua" )(...) end

mindbox.console = function(...) return loadfile( path .. "Console/Actor.lua" )(...) end


mindbox.setWindow(1)        mindbox.setFont(1)