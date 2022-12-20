import "Player"
import "Pet"
import "HomeScene"
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local image = gfx.image.new("images/Pet1")

class("OutdoorScene").extends(gfx.sprite)

function OutdoorScene:init(pet)
    local backgroundImage = gfx.image.new("images/background")
    gfx.sprite.setBackgroundDrawingCallback(function()
        backgroundImage:draw(0,0)
    end)

    self.testImage = gfx.image.new("images/coin")
    self.load = pd.datastore.read("petSave")
    -- if self.load == nil then
    --     print("pettable was nil")
    --     self.pet = Pet(120,200, 1, "idle", "r", image)
    -- else
    --     self.pet = Pet(self.load["x"],self.load["y"],self.load["moveSpeed"],self.load["state"], self.load["walkDirection"],self.load["image"])
    -- end
    self.pet = pet
    
    self.pet:add()

    self.playerInstance = Player(200,120)
    self.playerInstance:add()

    self:add()
end

function OutdoorScene:update()
    self.pet:movePet()
    --ad here some commandos like doing the crank to swtch scenes! SCENE_MANAGER:switchScene(sceneName)
    self:inputHandler()
    self:grabDetection()
    
end

function OutdoorScene:isCP()
    local collision = self.pet:overlappingSprites()
	if #collision >=1 then 
        return true
    else
        return false
    end
end

function OutdoorScene:grabDetection()
	if self:isCP() and pd.buttonIsPressed(pd.kButtonA) then
        self.pet.state = "hold"
        self.playerInstance.state = "hold"
    end
    if self:isCP() and not pd.buttonIsPressed(pd.kButtonA) then
        self.pet.state = "idle"
        self.playerInstance.state = "collision"
        print("idle")
    end
    if not self:isCP() then
        self.playerInstance.state = "idle"
    end
end 



function OutdoorScene:inputHandler()
    if pd.buttonJustPressed(pd.kButtonB) then
        local petTable = {}
        petTable["x"] = self.pet.x
        petTable["y"] = self.pet.y
        petTable["moveSpeed"] = self.pet.moveSpeed
        petTable["walkDirection"] = self.pet.walkDirection
        petTable["state"] = self.pet.state
        petTable["image"] = self.pet:getImage()

        pd.datastore.write(petTable, "savePet")
        print(self.pet)
        SCENE_MANAGER:switchScene(HomeScene(self.pet))

    end
    if pd.buttonIsPressed(pd.kButtonUp) then
        self.playerInstance:moveBy(0, -self.playerInstance.moveSpeed)
        if self.pet:isHold() then
            self.pet:moveBy(0, -self.playerInstance.moveSpeed)
        end
    end
    if pd.buttonIsPressed(pd.kButtonDown) then
        self.playerInstance:moveBy(0, self.playerInstance.moveSpeed)
        if self.pet:isHold() then
            self.pet:moveBy(0, self.playerInstance.moveSpeed)
        end
    end
    if pd.buttonIsPressed(pd.kButtonLeft) then
        self.playerInstance:moveBy(-self.playerInstance.moveSpeed, 0)
        if self.pet:isHold() then
            self.pet:moveBy( -self.playerInstance.moveSpeed, 0)
        end
    end
    if pd.buttonIsPressed(pd.kButtonRight) then
        self.playerInstance:moveBy(self.playerInstance.moveSpeed, 0)
        if self.pet:isHold() then
            self.pet:moveBy( self.playerInstance.moveSpeed, 0)
        end
    end
end 

