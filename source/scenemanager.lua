local pd <const> = playdate
local gfx <const> = playdate.graphics

class("SceneManager").extends()

function SceneManager:init()
    self.transitionTime = 1000
    self.transitioning = false
end

function SceneManager:switchScene(scene, ...)
    if self.transitioning then
        return
    end
    self.transitioning = true
    self.newScene = scene
    self.sceneArgs = ... --these are the arguments that need to be preserved when switching scenes
    
    self:startTransition()
end

function SceneManager:loadNewScene()
    self:clearScene()
    self.newScene(self.sceneArgs)
end

function SceneManager:startTransition()
    local transitionTimer = self:wipeTransition(0, 240) --from top to bottom
    transitionTimer.timerEndedCallback = function()
        self:loadNewScene()
        transitionTimer = self:wipeTransition(240,0)
        transitionTimer.timerEndedCallback = function()
            self.transitioning = false
        end
    end
end

function SceneManager:wipeTransition(startValue, endvalue)
    transitionSprite = self:createTransitionSprite()
    transitionSprite:setClipRect(0,0, 400, startValue)

    local transitionTimer = pd.timer.new(self.transitionTime, startValue, endvalue, pd.easingFunctions.inOutCubic)
    transitionTimer.updateCallback = function(timer) --method to update during the timer is running
        transitionSprite:setClipRect(0 , 0, 400, timer.value)
    end
    return transitionTimer
end

function SceneManager:createTransitionSprite()
    local fillRect = gfx.image.new(400, 240, gfx.kColorBlack)
    transitionSprite = gfx.sprite.new(fillRect)
    transitionSprite:moveTo(200, 120)
    transitionSprite:setZIndex(10000) -- its drawn over everything else
    transitionSprite:setIgnoresDrawOffset(true)
    transitionSprite:add()
    return transitionSprite
end

function SceneManager:clearScene()
    gfx.sprite.removeAll() -- removes all sprites to clear the screen for new scene
    self:removeAllTimers()
    gfx.setDrawOffset(0,0)
end

function SceneManager:removeAllTimers()
    local allTimers = pd.timer.allTimers()
    for _, timer in ipairs(allTimers) do
        timer:remove()
    end
end