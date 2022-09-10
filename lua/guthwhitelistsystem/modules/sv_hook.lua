util.AddNetworkString( "guthwhitelistsystem:SendData" )

--  > Hook(s)

hook.Add( "playerCanChangeTeam", "guthwhitelistsystem:Hook", function( ply, job )
    if job == GAMEMODE.DefaultTeam then return true end

    local wl = guthwhitelistsystem:WLGetJobWhitelist( job )
    if wl.active == true then
        if wl.vip == true then
            if ply:WLIsVIP() or ply:WLIsWhitelistAll() then
                return true
            else
                return false, guthwhitelistsystem.getLan( "NotifNotVIP" )
            end
        end
        if ply:WLGetJobWhitelist( job ) or ply:WLIsWhitelistAll() then return true end

        return false, guthwhitelistsystem.getLan( "NotifNotWhitelist" )
    end
end )

--  > Data things

hook.Add( "Initialize", "guthwhitelistsystem:Hook", function()
    guthwhitelistsystem:WLLoad()
end )