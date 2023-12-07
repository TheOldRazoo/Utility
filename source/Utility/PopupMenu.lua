
import 'CoreLibs/object'
import 'State'
import 'gridview'

class('PopupMenu').extends(State)

local pd <const> = playdate
local gfx <const> = pd.graphics

local fontExtra <const> = 4

function PopupMenu:init()
    PopupMenu.super.init()
    self.allowButtonB = true
end

local function getMaxTextLength(optionTab, font)
    local max = 0
    for i, option in ipairs(optionTab) do
        local len = font:getTextWidth(option)
        if len > max then
            max = len
        end
    end

    return max
end

local function centerX(maxWidth)
    return (pd.display.getWidth() - maxWidth) // 2
end

local function centerY(visableRows, font)
    return (pd.display.getHeight() - (visableRows * (font:getHeight() + fontExtra))) // 2
end

local function clearScreen(x, y, width, height, drawBorder)
    gfx.fillRect(x, y, width, height)
    if drawBorder then
        gfx.drawRect(x - 1, y - 1, width + 2, height + 2)
    end
end

local function myDrawCell(grid, section, row, col, selected, x, y, width, height)
    local c, b
    local color = gfx.getColor()
    local backgroundColor = gfx.getBackgroundColor()
    if selected then
        gfx.setImageDrawMode(gfx.kDrawModeInverted)
        b = color
        c = backgroundColor
    else
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        b = backgroundColor
        c = color
    end

    gfx.setColor(b)
    gfx.fillRect(x, y, width, height)
    gfx.setColor(c)
    gfx.setBackgroundColor(b)
    local self = grid:getUserData()
    self.font:drawText(self.optionTab[row], x + 4, y + 2)
    gfx.setColor(color)
    gfx.setBackgroundColor(backgroundColor)
end

function PopupMenu:setOptionButtonB(allow)
    self.allowButtonB = allow
end

--[[
    Pops up a selection menu consisting of the string in
    the option table passed.  The upper left corner of the
    menu will be at location x,y.

    if x or y are passed as negative values an attempt will be
    made to center the popup on that coordinate.

    The current state manager should be passed as the first
    parameter.

    When the menu is dismissed the callBack function will be
    called with the result.  The callback should be of the form:

        function myCallBack(userData, result, selected)

    The passed in 'result' will be one of the strings in the optionTab
    indicating that it was selected or 'nil' indicating that the menu
    was dismissed.  'selected' will be true if the user has selected
    that option (A or B button) and false if the cursor has just been
    positioned on that option.  The 'userData' value will be what was
    passed in during invocation of the menu.

    The callback function will be called before update control is returned
    the the calling state so the results will be available on it's next
    update() call.
]]
function PopupMenu:popupMenu(stateMgr, x, y, visableRows, optionTab, callBack, userData, drawBorder, font)
    if optionTab == nil or #optionTab == 0 then
        if callBack then
            callBack(userData, nil, true)
        end
        return
    end

    if font == nil then
        font = gfx.getSystemFont()
    end

    visableRows = math.min(visableRows, #optionTab)
    self.optionTab = optionTab
    self.userData = userData
    self.font = font
    self.callBack = callBack
    self.maxWidth = getMaxTextLength(optionTab, self.font) + fontExtra

    if x < 0 then
        x = centerX(self.maxWidth)
    end

    if y < 0 then
        y = centerY(visableRows, font)
    end

    self.gridView = gridview.new(self.maxWidth, self.font:getHeight() + fontExtra)
    self.gridView:setNumberOfRows(#optionTab)
    self.gridView:setNumberOfSections(1)
    self.gridView:setSelection(1, 1, 1)
    self.gridView:scrollToRow(1, false)
    self.gridView:setUserData(self)
    self.gridView:setUserDrawCellCallback(myDrawCell)
    self.stateMgr = stateMgr
    self.x = x
    self.y = y
    self.visableRows = visableRows * (self.font:getHeight() + fontExtra)
    self.prevSate = stateMgr:capture(self)
    self.releaseState = true
    self.screen = gfx.getDisplayImage()
    clearScreen(self.x, self.y, self.maxWidth, self.visableRows, drawBorder)
    if self.callBack then
        self.callBack(self.userData, self.optionTab[1], false)
    end
end

function PopupMenu:update()
    if pd.buttonJustPressed(pd.kButtonDown) then
        self.gridView:selectNextRow(true)
        if self.callBack then
            local section, row, col = self.gridView:getSelection()
            self.callBack(self.userData, self.optionTab[row], false)
        end
    elseif pd.buttonJustPressed(pd.kButtonUp) then
        self.gridView:selectPreviousRow(true)
        if self.callBack then
            local section, row, col = self.gridView:getSelection()
            self.callBack(self.userData, self.optionTab[row], false)
        end
    elseif pd.buttonJustPressed(pd.kButtonA) then
        local section, row, col = self.gridView:getSelection()
        self:cleanup(self.optionTab[row])
        return
    elseif self.allowButtonB and pd.buttonJustPressed(pd.kButtonB) then
        self:cleanup(nil)
        return
    end

    if self.gridView.needsDisplay then
        self.gridView:drawInRect(self.x, self.y, self.maxWidth, self.visableRows)
    end
end

function PopupMenu:cleanup(retValue)
    if self.callBack then
        self.callBack(self.userData, retValue, true)
    end
    if self.releaseState then
        self.stateMgr:release(self.prevSate)
    end
    self.screen:draw(0, 0)
    return
end

function PopupMenu:exit()
    self.releaseState = false
end
