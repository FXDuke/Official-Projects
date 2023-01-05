

Coroutine = {
    PriorityQueue = {},
    spawn = function(oldFunc,Priority,stopVariable)

        Priority = Priority or 1 
        stopVariable = stopVariable or true

        Coroutine.PriorityQueue[Priority] = Coroutine.PriorityQueue[Priority] or {}

        local newFunc = coroutine.create(
            function()
                while true do 
                    if oldFunc(coroutine.yield()) == stopVariable then 
                        break
                    end
                end
            end)

        local ID = #Coroutine.PriorityQueue[Priority]+1

        CoroutineObject = {
            ID = ID,
            CoroutineFunction = newFunc,
            PriorityLevel = Priority,
            ChangePriority = function(newLevel)
                table.remove(Coroutine.PriorityQueue[CoroutineObject.PriorityLevel],CoroutineObject.ID)
                CoroutineObject.ID = #Coroutine.PriorityQueue[newLevel]+1
                CoroutineObject.PriorityLevel = newLevel
                table.insert(Coroutine.PriorityQueue[newLevel],CoroutineObject)
            end,
        }

        coroutine.resume(CoroutineObject.CoroutineFunction)
        table.insert(Coroutine.PriorityQueue[Priority],CoroutineObject)
    end,
    ClearPriority = function(PriorityLevel)
        PriorityLevel = PriorityLevel or 1 
        Coroutine.PriorityQueue[PriorityLevel] = {}
    end,
    Wait = {
        WaitTime = 0,
        Waiting = {},
        Wait_Loop = function() 
            local WaitTable = Coroutine.Wait
            for _,FuncTable in pairs(WaitTable.Waiting) do 
                if WaitTable.WaitTime>=FuncTable.Start_Time+FuncTable.Wait_Time then 
                    FuncTable.F()
                    table.remove(WaitTable.Waiting,_)
                end
            end
        end, 
        Add_Wait = function(Time,Func) 
            local WaitTable = Coroutine.Wait
            table.insert(WaitTable.Waiting,{F=Func,Start_Time=WaitTable.WaitTime,Wait_Time=Time})
        end,
    },
    BeginLoop = function(dt)
        Coroutine.Wait.WaitTime = Coroutine.Wait.WaitTime + dt
        Coroutine.Wait.Wait_Loop()
        for Priority,Coroutines in pairs(Coroutine.PriorityQueue) do 
            for _,CoroutineObject in pairs(Coroutines) do 
                coroutine.resume(CoroutineObject.CoroutineFunction,dt)
                if coroutine.status(CoroutineObject.CoroutineFunction) == "dead" then 
                    table.remove(Coroutines,_)
                end
            end
        end
    end
}


return Coroutine



