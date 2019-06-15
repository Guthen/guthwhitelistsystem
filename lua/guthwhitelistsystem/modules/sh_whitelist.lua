guthwhitelistsystem.wl = guthwhitelistsystem.wl or {}

local Player = FindMetaTable( "Player" )

--  > Make some players meta

function Player:WLSetJobWhitelist( job, bool )
    if not guthwhitelistsystem.wl[self:SteamID()] then
        guthwhitelistsystem.wl[self:SteamID()] = {}
    end
    guthwhitelistsystem.wl[self:SteamID()][job] = isbool( bool ) and bool or nil
end

function Player:WLGetJobWhitelist( job )
    local wl = guthwhitelistsystem.wl[self:SteamID()]
    return wl and wl[job]
end

function Player:WLGetWhitelists()
    return guthwhitelistsystem.wl[self:SteamID()]
end
