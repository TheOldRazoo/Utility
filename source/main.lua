
import 'Utility/Stack'

local stack = Stack()
stack:push(50)
stack:push(100)
stack:push(200)
print('Stack size: ' .. stack:size())
print('Stack pop: ' .. stack:pop())
print('Stack pop: ' .. stack:pop())
print('Stack pop: ' .. stack:pop())
print('Stack size: ' .. stack:size())
