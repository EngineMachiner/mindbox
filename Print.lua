
local function sysPrint(...)
    
    local concat = mindbox.concat(...)          SCREENMAN:SystemMessage(concat)

end

mindbox.sysPrint = sysPrint


-- Shorten and format the string.

local function onSong(s)

	local song = GAMESTATE:GetCurrentSong()         if not song then return s end

	song = song:GetSongDir()        if not s:match(song) then return end


    -- 1 is the starting position and last argument omit patterns.

    local start, endPos = s:find( song, 1, true )           if not endPos then return s end

	return "../SongsFolder/" .. s:sub( endPos + 1 )

end


local function onTrace(s)

    local config = mindbox.Config           if not config.showTraces then return s end

    return s .. "\n\n" .. debug.traceback(2)

end


local formats = { onSong, onTrace }

local function format(s)

    s = s:gsub( "/BGAnimations/Resources/", "../" )

    for i,v in ipairs(formats) do s = v(s) end              return s

end


local Message = "mind$box: Console was not loaded!"

local function print()

	local console = mindbox.Console             if not console then sysPrint(Message) return end

	console:playcommand("Print")

end


mindbox.print = function(...)

	local s = mindbox.concat(...)           s = format(s)
    
    mindbox.currentText = s                 print()

end