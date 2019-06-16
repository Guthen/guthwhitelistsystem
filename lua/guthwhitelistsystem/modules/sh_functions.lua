guthwhitelistsystem.wl = guthwhitelistsystem.wl or {}
guthwhitelistsystem.wlJob = guthwhitelistsystem.wlJob or {}

local Player = FindMetaTable( "Player" )

--  > Make some players meta

function Player:WLSetJobWhitelist( job, bool, by )
    if not job or not isnumber( job ) then return error( "#1 argument must be valid and be a number !", 2 ) end
    if job == GAMEMODE.DefaultTeam then return end -- can't whitelist the DefaultTeam
    if not guthwhitelistsystem.wl[self:SteamID()] then -- create player table
        guthwhitelistsystem.wl[self:SteamID()] = {}
    end
    if guthwhitelistsystem.wl[self:SteamID()][job] and bool == true then return end -- don't make modification (time & date) if you are already whitelist
    if guthwhitelistsystem.wlJob[job] and guthwhitelistsystem.wlJob[job].vip == true and bool == true then return end -- don't be whitelist if it's a vip job

    by = by and by:IsPlayer() and by:GetName() or not by == nil and by or "Unknow"

    if bool == true then
        guthwhitelistsystem.wl[self:SteamID()][job] =
            {
                date = os.date( "%d/%m/%Y", os.time() ),
                time = os.date( "%H:%M:%S", os.time() ),
                by = by,
            }
    elseif bool == false then
        guthwhitelistsystem.wl[self:SteamID()][job] = nil
    end

    guthwhitelistsystem.print( ("Set job whitelist (%d : %s) to %s to %s by %s !"):format( job, team.GetName( job ), self:GetName(), tostring( bool ), by ) )
end

function Player:WLGetJobWhitelist( job )
    local wl = guthwhitelistsystem.wl[self:SteamID()]
    return wl and wl[job] or false
end

function Player:WLGetWhitelists()
    return guthwhitelistsystem.wl[self:SteamID()] or {}
end

function Player:WLIsAdmin()
    return guthwhitelistsystem.AdminRanks[self:GetUserGroup()]
end

function Player:WLIsVIP()
    return guthwhitelistsystem.VIPRanks[self:GetUserGroup()]
end

--  > Make some functions

function guthwhitelistsystem:WLSetJobWhitelist( job, bool, vip )
    if not job or not isnumber( job ) then return error( "#1 argument must be valid and be a number !", 2 ) end
    if job == GAMEMODE.DefaultTeam then return end -- can't whitelist the DefaultTeam
    if not guthwhitelistsystem.wlJob[job] then
        guthwhitelistsystem.wlJob[job] = {}
    end

    if bool then
        guthwhitelistsystem.wlJob[job] =
            {
                vip = isbool( vip ) and vip or false,
                active = isbool( bool ) and bool or false,
            }
    else
        guthwhitelistsystem.wlJob[job] = nil
        for _, v in pairs( player.GetAll() ) do
            local wl = guthwhitelistsystem.wl[v:SteamID()]
            if wl and wl[job] then wl[job] = nil end
        end
    end

    guthwhitelistsystem.print( ("Set job whitelist (%d : %s) to %s (VIP: %s) !"):format( job, team.GetName( job ), tostring( bool ), tostring( vip or false ) ) )
end

function guthwhitelistsystem:WLGetJobWhitelist( job )
    return guthwhitelistsystem.wlJob[job] or {}
end
