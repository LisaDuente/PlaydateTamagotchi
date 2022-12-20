import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Pet").extends(gfx.sprite)

function Pet:init(x, y, movespeed, state, walkDirection, image)
    self:moveTo(x,y)
    self:setImage(image)
    self.moveSpeed = movespeed
    self.state = state --can be idle, hold
    self.walkDirection = walkDirection
    self:setCollideRect(0,0,self:getSize())
end

function Pet:isHold()
    if self.state == "hold" then
        return true
    else
        return false
    end
end

function Pet:movePet()
    if self.state == "idle" then
        if self.x >= 360  and self.walkDirection == "r" then
            self.walkDirection = "l"
        end

        if self.x <= 50 and self.walkDirection == "l"then
            self.walkDirection = "r"
        end

        if self.walkDirection == "r" then
            self:moveBy(self.moveSpeed, 0)
        end
        if self.walkDirection == "l" then
            self:moveBy(-self.moveSpeed, 0)
        end
    end

    
end