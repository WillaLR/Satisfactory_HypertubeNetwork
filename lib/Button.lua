--- Created by Willis.
--- DateTime: 16/12/2021 4:10pm
--- Class to represent Buttons



local UPDATED = "17/12/2021 1:12am"
print("Initialising Button.lua\nLast Update: "..UPDATED)

filesystem.doFile("Boundary.lua")

Button = {}
Button.__index = Button
setmetatable(Button, {__call = function(cls,...) return cls.new(...) end,})


function Button.new(label, xMin, xMax, yMin, yMax, colourBack, colourFore)
    local self = setmetatable({}, Button)

    self.label = label
    self.colourBack = colourBack
    self.colourFore = colourFore

    self.boundary = Boundary(xMin, xMax, yMin, yMax)
    return self
end


function Button:setBackground(rgba)
    self.colourBack = rgba
end

function Button:setForeground(rgba)
    self.colourFore = rgba
end


function Button:draw(gpu)
    local min_max = self.boundary:get_min_max()

    gpu:setBackground(self.colourInit[1], self.colourInit[2], self.colourInit[3], self.colourInit[4])
    gpu:fill(min_max.xMin, min_max.yMin, min_max.dX, min_max.dY, " ")

    local midX = math.ceil( (min_max.xMax - min_max.xMin-1)/2) + min_max.xMin
    local midY = math.floor((min_max.yMax - min_max.yMin-1)/2) + min_max.yMin

    local label_len = string.len(self.label)
    local label_mid = math.ceil(label_len/2)
    local label_start = midX-label_len+label_mid

    gpu:setText(label_start, midY, self.label)
end


function Button:get_min_max()
    return self.boundary:get_min_max()
end


function Button:execute(x,y, func)
    if(self.boundary:check(x,y, -1, -1)) then
        func(self, true)
        return true
    else
        func(self, false)
        return false
    end
end



function Button:move(dX, dY)
    self.boundary:move(dX, dY)
end

