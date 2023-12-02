
import 'Utility/Stack'
import 'Utility/Queue'
import 'Utility/State'
import 'Utility/StateManager'
import 'Utility/PopupMenu'

local firstTime = true

local stack = Stack()
stack:push(50)
stack:push(100)
stack:push(200)
print('Stack size: ' .. stack:size())
print('Stack pop: ' .. stack:pop())
print('Stack pop: ' .. stack:pop())
print('Stack pop: ' .. stack:pop())
print('Stack size: ' .. stack:size())

local stateManager = StateManager(State())

function playdate.update()
    if firstTime then
        menu = PopupMenu()
        menu:popupMenu(stateManager, -1, -1, 5, {'Sammy', 'Betty', 'Ralph', 'Nancy'}, myCallback, true)
        firstTime = false
    end

    stateManager:getCurrentState():update()
    playdate.timer.updateTimers()
end

function myCallback(value, selected)
    if value == nil then
        value = 'Nil'
    end

    if selected then
        print('Value selected=' .. value)
    else
        print('Value hilighted=' .. value)
    end
end
