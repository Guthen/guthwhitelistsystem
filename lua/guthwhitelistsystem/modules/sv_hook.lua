util.AddNetworkString( "guthwhitelistsystem:SendData" )

--  > Hook(s)

hook.Add( "playerCanChangeTeam", "guthwhitelistsystem:Hook", function( ply, job, force )
    if force then return end  --  don't prevent forced team changes
    if job == GAMEMODE.DefaultTeam then return end  --  don't whitelist the default team

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