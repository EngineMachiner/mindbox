
local Vector = Astro.Vector

local function console() return mindbox.Console end

local config = mindbox.Config
local maxZoom = config.maxZoom
local timeOn = config.timeOn

local fontTheme = mindbox.Theme.Font
local fontFile = fontTheme.File

local resScale = 2 -- Resolution scale.

local function size( args )

    local w, h = console():GetSize(true)

    w = w * resScale * 0.75         h = h * resScale * 0.9

    return not args and Vector( w, h ) or w, h

end

local function textColor(self)

    local color = fontTheme.Color

    if not fontTheme.randomColor then return color end

    return tapLua.Color.random(0.8)

end

local function setTextZoom(self)
    
    local w1 = size(true)           local w2 = self:GetWidth()

    local zoom = w1 / w2        zoom = math.min( maxZoom, zoom )

    self:zoom(zoom)             return self

end

local function setTextPos(self)

    local p = console()         local w, h1 = size(true)

    local h2 = self:GetZoomedHeight()       local timeOn = timeOn / self:GetZoom()

    
    local offset = 100      local y = h2 * 0.5 + offset     self:y(y)


    p.scroll = false            p.time = timeOn

    
    if h2 <= h1 then return self end -- Scrolling limit.


    local length = h2 - h1              local time = length * timeOn / h1
    
    local y = y - length - offset - 300

    self:sleep(timeOn):linear(time):y(y)


    p.scroll = true             p.time = timeOn * 2 + time


    return self

end

return Def.ActorFrame {

    -- Give the console some time to initialize.

    PrintCommand=function(self) self:sleep(0):queuecommand("Start") end,

    tapLua.Actor {

        Name = "TextAFT",       Class = "ActorFrameTexture",

        PostInitCommand=function(self)

            local size = size()     self:setSizeVector(size)
            
            self:EnableAlphaBuffer(true):Create()

            self:GetParent():playcommand("TextureLoad")

        end,

        Def.BitmapText {

            Font = fontFile,

            InitCommand=function(self)
                
                self.color = textColor          self.setZoom = setTextZoom

                self.setPos = setTextPos        self:halign(0)

            end,

            StartCommand=function(self)

                console():playcommand("Off")        self:queuecommand("Set")

            end,

            SetCommand=function(self)

                local text = mindbox.currentText        local color = self:color()
                
                self:settext(text):diffuse(color)       self:setZoom():setPos()
                
                console():playcommand("Fade")

            end
                
        },

        tapLua.Quad { -- This quad helps me see the texture's size.
            
            InitCommand=function(self) self:diffusealpha(0) end,

            PostInitCommand=function(self)
            
                local size = size() * resScale          self:setSizeVector(size)

            end
        
        }

    },

    -- Load the ActorFrameTexture texture.

    Def.Sprite {

        TextureLoadCommand=function(self)

            local AFT = self:GetParent():GetChild("TextAFT")

            local texture = AFT:GetTexture()

            self:zoom( 1 / resScale ):SetTexture(texture)

            self:fadetop(0.1):fadebottom(0.1)

        end

    }

}