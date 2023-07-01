
--[[
	This singleton manages the state machine used to determine which code should
	be invoked at any point in the game.

	Example:
		startState = MyStartState()		-- extends State
		stateMgr = StateManager(startState)
		stateMgr:getCurrentState():update()
		stateManager:setCurrentState(someOtherState)

	Bob Withers
	bwit@pobox.com
	06/10/2023
]]

import 'CoreLibs/object'

class('StateManager').extends()

-- Instance variables
local currState


function StateManager:init(startState)
	self.currState = startState
	self.currState:enter(nil)
end

function StateManager:getCurrentState()			-- returns State
	return self.currState
end

function StateManager:setCurrentState(state)
	local prevState = self.currState
	self.currState:exit()
	self.currState = state
	self.currState:enter(prevState)
end