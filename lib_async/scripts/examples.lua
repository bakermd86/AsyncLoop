function onInit()
    Comm.registerSlashHandler("blockMathExample", doMathBlocking, "/blockMathExample <number of args>")
    Comm.registerSlashHandler("asyncMathExample", doMathAsync, "/asyncMathExample <number of args>")
    math.randomseed(os.time() - os.clock() * 1000);
end

function doMathBlocking(sCommand, sParam)
    local sTime = os.clock()
    local results = {}
    for i=1,tonumber(sParam) do
        local x = math.random(1, 1000)
        local y = math.random(1, 1000)
        table.insert(results, doMath(x, y))
    end
    Debug.chat("Got ".. #results .. " results in " .. os.clock() - sTime .. "s of CPU time")
end

function doMathAsync(sCommand, sParam)
    local numbers = {}
    for i=1,tonumber(sParam) do
        local _x = math.random(1, 1000)
        local _y = math.random(1, 1000)
        table.insert(numbers, { x=_x, y=_y })
    end
    AsyncLib.scheduleAsync("doMath", wrapDoMath, numbers, mathCallback)
    AsyncLib.startAsync()
end

function mathCallback(callName, asyncResults, asyncCount, asyncCpuTime)
    Debug.chat("Got " .. asyncCount .. " results in " .. asyncCpuTime .. "s of CPU time")
end

function wrapDoMath(callArg)
    return doMath(callArg.x, callArg.y)
end

function doMath(x, y)
    local z = x * y
    Debug.chat(x .. " x " .. y .. " = " .. z)
    return z
end