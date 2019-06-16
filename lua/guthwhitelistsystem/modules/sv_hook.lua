util.AddNetworkString( "guthwhitelistsystem:SendData" )

--  > Hook(s)

hook.Add( "playerCanChangeTeam", "guthwhitelistsystem:Hook", function( ply, job )
    if job == GAMEMODE.DefaultTeam then return true end

    local wl = guthwhitelistsystem:WLGetJobWhitelist( job )
    if wl.active == true then
        PrintTable( ply:WLGetWhitelists() )
        if wl.vip == true then if ply:WLIsVIP() then return true else return false, "You are not a VIP !" end end
        if ply:WLGetJobWhitelist( job ) then return true end

        return false, "You are not whitelisted !"
    end
end )

--  > Data things

hook.Add( "Initialize", "guthwhitelistsystem:Hook", function()
    guthwhitelistsystem:WLLoad()
end )

hook.Add( "ShutDown", "guthwhitelistsystem:Hook", function()
    guthwhitelistsystem:WLSave()
end )

hook.Add( "PlayerInitialSpawn", "guthwhitelistsystem:Hook", function( ply )
    net.Start( "guthwhitelistsystem:SendData" )
        net.WriteTable( guthwhitelistsystem.wl )
        net.WriteTable( guthwhitelistsystem.wlJob )
    net.Send( ply )
end )

timer.Create( "guthwhitelistsystem:Save", guthwhitelistsystem.TimerSaveTime or 120, 0, function()
    guthwhitelistsystem:WLSave()
end )
