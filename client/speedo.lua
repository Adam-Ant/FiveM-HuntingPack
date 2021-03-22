function text(content)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.6,0.6)
    SetTextColour(247, 247, 247, 247)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentString("~y~" .. content)
    EndTextCommandDisplayText(0.143,0.925)
end

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(2)
        --[[
            kph's factor 3.6
            mph's factor 2.2369
        ]]
        local speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1),false))*2.2369
        -- Check if the ped is in a vehicle 
        if (IsPedInAnyVehicle(GetPlayerPed(-1),false)) then
            text(tostring(math.floor(speed)))
        end
    end

end)
