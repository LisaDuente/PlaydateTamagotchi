import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Player").extends(gfx.sprite)

local image = gfx.image.new("images/Player")

function Player:init(x, y)
    self:moveTo(x,y)
    self:setImage(image)
    self.moveSpeed = 4
    self:setCollideRect(0,0,10,10)
    self.idleImage = gfx.image.new("images/Player")
    self.collisionImage = gfx.image.new("images/playerPet1")
    self.holdImage = gfx.image.new("images/playerHold")
    self.state = "idle"
end

function Player:update()
    if self.state == "idle" then
        self:setImage(self.idleImage)
    end
    if self.state == "collision" then
        self:setImage(self.collisionImage)
    end
    if self.state == "hold" then
        self:setImage(self.holdImage)
    end
    
end