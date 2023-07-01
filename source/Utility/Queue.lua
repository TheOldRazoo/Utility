
--[[
    This class implements a simple queue which can hold any type of
    Lua variables.

    Example:
        local myQ = Queue()
        myQ:enqueue(22)
        myQ:enqueue(50)
        myQ:enqueue(101)
        local n = myQ:dequeue()     -- returns 22
        local p = myQ:dequeue()     -- returns 50

    Bob Withers  bwit@pobox.com   2023
]]

import 'CoreLibs/object'

class('Queue').extends()

-- instance variables
local q

function Queue:init()
    self.q = {}
end

function Queue:enqueue(obj)
    self.q[#self.q + 1] = obj
end

function Queue:dequeue()
    local n = #self.q
    if n > 0 then
        return table.remove(self.q, 1)
    end

    return nil
end

function Queue:isEmpty()
    return #self.q == 0
end

function Queue:isFull()
    return false
end

function Queue:size()
    return #self.q
end
