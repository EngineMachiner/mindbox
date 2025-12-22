
-- Can't load SVG gradients.

local scale = SCREEN_HEIGHT / 720           local input = table.pack(...)

local config = mindbox.Config               local showFading = config.showFading

local margin = 0.915 -- The float based on the window's margin.

local title = "mind$box - Console"


local function console() return mindbox.Console end

local function font() return mindbox.Theme.Font.File end

local function texture() return mindbox.Theme.Window end


local Window = tapLua.Sprite {
    
    Name = "Window",        Texture = texture(),

    InitCommand=function(self)
        
        mindbox.Console = self:GetParent()          local color = color("#909090")

        self:diffuse(color):SetTextureFiltering(false):queuecommand("SetSize")

    end,

    ReloadCommand=function(self)
        
        local texture = texture()          self:Load(texture)
    
    end,

    SetSizeCommand=function(self)

        local size = self:GetSize()         console():setSizeVector(size):queuecommand("PostInit")

    end,

    PostInitCommand=function()

        if not input[1] then return end             mindbox.print(  table.unpack(input)  )
    
    end

}


local function quad()

	return tapLua.Quad {

		InitCommand=function(self) self:diffuse( Color.Black ) end,

        PostInitCommand=function(self)

            local size = self:GetParent():GetSize() * margin        self:setSizeVector(size)

        end

	}

end


local function onMouseScroll( self )

    self:stoptweening():RunCommandsOnChildren( function(child) child:stoptweening() end )

    self:diffusealpha(1):sleep(8):linear(0.5):diffusealpha(0)

end

local ActorFrame = tapLua.ActorFrame {

    InitCommand=function(self) self:diffusealpha(0) end,

	PostInitCommand=function(self) local w = self:GetWidth() * 0.625        self:x(w) end,

	FadeCommand=function(self)

        local t = self.time

        self:diffusealpha(0):linear(0.5):diffusealpha(1):sleep(t):linear(0.5):diffusealpha(0)
        
	end,

	OffCommand=function(self)

		self:finishtweening():RunCommandsOnChildren( function(child) child:finishtweening() end )

	end,

    MouseWheelUpMessageCommand = onMouseScroll,           MouseWheelDownMessageCommand = onMouseScroll,

    
    -- Background.

    quad() .. {  InitCommand=function(self) self:diffusealpha(0.925) end  },
    
    dofile( mindbox.Path .. "Console/Text.lua" ),

	quad() .. { -- Top fade.

		PostInitCommand=function(self)

            local h = self:GetHeight() * 0.25       self:SetHeight(h):y( - h * 1.5 )

			self:diffusealpha(0):fadebottom(0.5)

		end,

		FadeCommand=function(self)

			if not showFading then return end           self:diffusealpha(0)

            local scroll = console().scroll             if not scroll then return end

            local time =  console().time - 1            self:sleep(0.5):linear(time):diffusealpha(1)

		end

	},

	quad() .. { -- Bottom fade.

		PostInitCommand=function(self)

            local h = self:GetHeight() * 0.25       self:SetHeight(h):y( h * 1.5 )

            self:diffusealpha(0):fadetop(0.5)

		end,

		FadeCommand=function(self)

			if not showFading then return end           self:diffusealpha(0)

            local scroll = console().scroll             if not scroll then return end

            local time =  console().time - 1            self:diffusealpha(1)

			self:sleep(0.5):linear(time):diffusealpha(0)

		end

	},

	Window,

	Def.ActorFrame { -- Console title.

		PostInitCommand=function(self)
            
            local h = console():GetHeight()         self:y( - h * 0.5 + 24 ):zoom(0.5)
        
        end,

		tapLua.Quad {

			InitCommand=function(self)

                local color = color("#202020")

				self:setsize( 600, 45 ):diffuse(color):fadeHorizontally(0.25)

			end

		},

		Def.BitmapText {

			Font = font(),          Text = title,

			InitCommand=function(self) local color = color("#959595")      self:diffuse(color) end

		}

	}

}

return Def.ActorFrame {
    
    ActorFrame,         InitCommand=function(self) self:zoom(scale):CenterY() end

}