
local astro = Astro.Type            local isString = astro.isString

local getFiles = tapLua.FILEMAN.getFiles


local Config = {

	showChildren = true,       showTraces = false,         showFading = true,

    maxZoom = 2,        timeOn = 8

}

local Theme = {
    
    Font = { randomColor = false,   Color = Color.White } 

}


local WindowsPath = mindbox.Path .. "Assets/Graphics/Windows/"

local function setWindow(input)

    if isString(input) then Theme.Window = WindowsPath .. input return end

    local windows = getFiles( WindowsPath )             Theme.Window = windows[input]

end


local FontsPath = mindbox.Path .. "Assets/Fonts/"

local function setFont(input)

    local font = Theme.Font

    if isString(input) then font.File = FontsPath .. input return end

    local fonts = getFiles( FontsPath, "%.ini", true )

    font.File = fonts[input]

end


local merge = {

    Config = Config,            Theme = Theme,

    setWindow = setWindow,          setFont = setFont

}

Astro.Table.merge( mindbox, merge )