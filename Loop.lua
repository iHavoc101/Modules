-- // Constants \\ --
-- [ Services ] --
local Services = setmetatable({}, {__index = function(Self, Index)
    local NewService = game:GetService(Index)
    if NewService then
        Self[Index] = NewService
    end
    return NewService
end})

-- // Variables \\ --
local Connections = {}

-- // Functions \\ --
local Utility = {}

-- // Main Module \\ --
local Module = {}

--[[
Module.new(Delay: integer, Callback: Function)
    Creates a loop.
]]
function Module.new(Delay: integer, Callback: Function)
    local Loop = {
        Delay = Delay;
        Function = Callback;
        LastCalled = time();
    }

    local Connection = Services.RunService.RenderStepped:Connect(function()
        if time() - Loop.LastCalled > Loop.Delay then
            coroutine.wrap(Loop.Function)()
            Loop.LastCalled = time()
        end
    end)
    table.insert(Connections, Connection)

    function Loop:Break()
        Connection:Disconnect()
    end

    return Loop
end

--[[
Module.Yield(Delay: integer)
    Delays a certain amount of time.
]]
function Module.Yield(Delay: integer)
    local InitialTime = time()
    repeat
        Services.RunService.RenderStepped:Wait(0.5)
    until time() - InitialTime > Delay
end

--[[
Module:Disconnect()
    Breaks all loops currently running.
]]
function Module:Disconnect()
    for i,v in ipairs(Connections) do
        v:Disconnect()
    end
end

return Module
