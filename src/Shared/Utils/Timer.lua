--[[
   Timer.lua
      
   Utilities for working with scheduled tasks and time

   by @nidorx <Alex Rodin>
]]   
local RunService = game:GetService("RunService")

local ID         = 1
local TASKS       = {}
local MAX_CALLS   = 30  -- Allows you to define a limit of executions in each interaction

-- max safe int (int53)
local MAX_SAFE_INT = 9007199254740991 -- (2^53) -1

--[[
   Run scheduled tasks.

   Perform a non-blocking run using coroutines
]]
RunService.Heartbeat:Connect(function(dt)
   local toRemove = {}
   
   local count = 0
   for i, task in ipairs(TASKS) do
      if not task.IsRunning then
         task.Elapsed = task.Elapsed + dt * 1000
         if task.Elapsed >= task.Interval then
            task.Elapsed = task.Elapsed - task.Interval

            -- remove when timeout (runs only once)
            if task.IsTimeout then
               table.insert(toRemove, task)
            end
            
            -- run task
            coroutine.wrap(task.SafeExec)()

            count = count + 1
            -- limit interactions
            if count > MAX_CALLS then 
               break
            end
         end
      end
   end

   for _, task in ipairs(toRemove) do
      local pos = table.find(TASKS, task)
      if pos ~= nil then
         table.remove(TASKS, pos)
      end
   end
end)

--[[
   Schedule a task for future execution
]]
local function createTimer(func, delay, isTimeout, arguments)
   local id = ID
   ID = ID + 1

   if delay == nil or delay < 0 then 
      delay = 0
   end

   if type(delay) ~= 'number' then
      error('Number is expected for interval/delay')
   end

   delay = math.min(MAX_SAFE_INT, delay)

   local task     = {}
   task.Id        = id

   -- generates a safe execution of the task
   task.SafeExec  = function()
      task.IsRunning = true

      local success, err = pcall(func, table.unpack(arguments))

      task.IsRunning = false
      task.Elapsed   = 0

      if not success then
         warn(err)
      end
   end

   task.IsTimeout = isTimeout
   task.Elapsed   = 0
   task.Init      = os.clock()
   task.Interval  = delay
   table.insert(TASKS, task)

   return id
end

local Timer = {}

--[[
   Repeatedly calls a function, with a fixed time delay between each call. It returns an interval ID which uniquely 
   identifies the interval, so you can remove it later by calling Timer.Clear(intervalID).

   Important! The interval for the next execution of the task only starts to count when the current execution ends, 
   therefore, a task, even if it takes time, is never executed more than once in parallel


   @see https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setInterval

   @param func (function)  A function to be executed every delay milliseconds (1000ms = 1second).
   @param delay (number)   The time, in milliseconds (thousandths of a second), the timer should delay in between 
                              executions of the specified function
   @param args    (...)    Additional arguments which are passed through to the function specified by func once the 
                              timer expires

   @return intervalID The returned intervalID is a numeric, non-zero value which identifies the timer created by 
      the call to Timer.SetInterval(); this value can be passed to Timer.Clear(intervalID) to cancel the interval.
]]
function Timer.SetInterval(func, delay, ...)
   return createTimer(func, delay, false, {...})
end

--[[
   Sets a timer which executes a function once the timer expires.

   @param func (function)  A function to be executed after the timer expires.
   @param delay (number)   The time, in milliseconds (thousandths of a second, 1000ms = 1second), the timer should 
                              wait before the specified function or code is executed. If this parameter is omitted, 
                              a value of 0 is used, meaning execute "immediately", or more accurately, the next 
                              RunService.Heartbeat event cycle. Note that in either case, the actual delay may be 
                              longer than intended
   @param args (...)       Additional arguments which are passed through to the function specified by func.

   @return timeoutID The returned timeoutID is a numeric, non-zero value which identifies the timer created by 
      the call to Timer.SetTimeout(); this value can be passed to Timer.Clear(timeoutID) to cancel the timeout.
]]
function Timer.SetTimeout(func, delay, ...)
   return createTimer(func, delay, true, {...})
end

--[[
   Used to inactivate schedules created with Timer.SetTimeout or Timer.SetInterval
]]
function Timer.Clear(id)
   for pos, task in ipairs(TASKS) do
      if task.Id == id then
         table.remove(TASKS, pos)
         break
      end
   end
end

return Timer
