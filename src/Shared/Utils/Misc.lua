local Misc = {}

Misc.NUMBER_MIN         = -9007199254740992
Misc.NUMBER_MAX         = 9007199254740992
Misc.NUMBER_STEP        = 0.01
Misc.NUMBER_PRECISION   = 2

--[[
   Create an event disconnect function, a pattern used on all controllers
]]
function Misc.DisconnectFn(connections, ...)

   local disconnectFns = {...}

   return function()

      for _, disconnect in ipairs(disconnectFns) do
         disconnect()
      end

      for _, conn in ipairs(connections) do
         conn:Disconnect()
      end

      table.clear(connections)
   end
end

--[[
   Gets the number of decimals a number has
]]
function Misc.CountDecimals(x) 
   local _x = tostring(x)
   local idexOf, _ = string.find(_x, ".", 1, true)
   if idexOf ~= nil then
      return string.len(_x) - (idexOf -1) - 1
   end
   
   return 0
end

--[[
   Linearly map a value from an input range to an output range
   https://rosettacode.org/wiki/Map_range#Lua
]]
function Misc.MapRange(x, inMin, inMax, outMin, outMax)
   return outMin + (x - inMin)*(outMax - outMin)/(inMax - inMin) 
end

return Misc

