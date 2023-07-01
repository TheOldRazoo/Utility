
--[[
    This class implements a simple stack which can hold any type of
    Lua variables.

    Example:
        local myStack = Stack()
        myStack:push(22)
        local n = myStack:pop()

    Bob Withers  bwit@pobox.com   2023
]]

import 'CoreLibs/object'

class('Stack').extends()

-- instance variables
local s

function Stack:init()
    self.s = {}
end

function Stack:push(obj)
    self.s[#self.s + 1] = obj
end

function Stack:pop()
    local n = #self.s
    if n > 0 then
        return table.remove(self.s, n)
    end

    return nil
end

function Stack:peek()
    local n = #self.s
    if n > 0 then
        return self.s[n]
    end

    return nil
end

function Stack:isEmpty()
    return #self.s == 0
end

function Stack:size()
    return #self.s
end
