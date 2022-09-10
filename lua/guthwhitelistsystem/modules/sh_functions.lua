guthwhitelistsystem.wl = guthwhitelistsystem.wl or {}
guthwhitelistsystem.wlJob = guthwhitelistsystem.wlJob or {}

local Player = FindMetaTable( "Player" )

if SERVER and guthlogsystem then 
    guthlogsystem.addCategory( "guthwhitelistsystem", Color( 142, 68, 173 ) ) 
end

--  > Make some players meta

function Player:WLSetWhitelistAll( bool, by )
    if not guthwhitelistsystem.wl[self:SteamID()] then -- create player table if not existing
        guthwhitelistsystem.wl[self:SteamID()] = {}
    end
    if guthwhitelistsystem.wl[self:SteamID()].whitelistAll and bool == true then return end -- don't make modification if you are already whitelist

    by = by and by:IsPlayer() and by:GetName() or not by == nil and by or "Unknow"

    if bool == true then
        guthwhitelistsystem.wl[self:SteamID()].whitelistAll =
            {
                date = os.date( "%d/%m/%Y", os.time() ),
                time = os.date( "%H:%M:%S", os.time() ),
                by = by,
            }
    elseif bool == false then
        guthwhitelistsystem.wl[self:SteamID()].whitelistAll = nil
    end

    if SERVER then
        --  >   saving
        guthwhitelistsystem:WLSave()

        --  >   networking
        for _, v in pairs( player.GetAll() ) do
            if not v:WLIsAdmin() then continue end
            v:WLSendData()
        end

        --  >   guthlogsystem
        if guthlogsystem then
            local whitelist = bool and "whitelisted all" or "unwhitelisted all"
            local msg = by and ("by ?%s?"):format( by ) or ""
            guthlogsystem.addLog( "guthwhitelistsystem", ("*%s* (%s) has been %s %s"):format( self:GetName(), self:SteamID(), whitelist, msg ) )
        end
    end

    guthwhitelistsystem.print( ("Set job whitelist all to %s to %s by %s !"):format( self:GetName(), tostring( bool ), by ) )
end

function Player:WLSetJobWhitelist( job, bool, by )
    if not job or not isnumber( job ) then return error( "#1 argument must be valid and be a number !", 2 ) end
    if job == GAMEMODE.DefaultTeam then return end -- can't whitelist the DefaultTeam
    if not guthwhitelistsystem.wl[self:SteamID()] then -- create player table if not existing
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

    if SERVER then
        --  >   saving
        guthwhitelistsystem:WLSave()

        --  >   networking
        for _, v in pairs( player.GetAll() ) do
            if not v:WLIsAdmin() then continue end
            v:WLSendData()
        end

        --  >   guthlogsystem
        if guthlogsystem then
            local whitelist = bool and "whitelisted" or "unwhitelisted"
            local msg = by and ("by ?%s?"):format( by ) or ""
            guthlogsystem.addLog( "guthwhitelistsystem", ("*%s* (%s) has been %s to &%s& %s"):format( self:GetName(), self:SteamID(), whitelist, team.GetName( job ), msg ) )
        end
    end

    guthwhitelistsystem.print( ("Set job whitelist (%d : %s) to %s to %s by %s !"):format( job, team.GetName( job ), self:GetName(), tostring( bool ), by ) )
end

function Player:WLGetJobWhitelist( job )
    local wl = guthwhitelistsystem.wl[self:SteamID() == "NULL" and "BOT" or self:SteamID()]
    return wl and wl[job] or false
end

function Player:WLGetWhitelists()
    return guthwhitelistsystem.wl[self:SteamID() == "NULL" and "BOT" or self:SteamID()] or {}
end

function Player:WLIsAdmin()
    return guthwhitelistsystem.AdminRanks[self:GetUserGroup()]
end

function Player:WLIsVIP()
    return guthwhitelistsystem.VIPRanks[self:GetUserGroup()]
end

function Player:WLIsWhitelistAll()
    local steamid = self:IsBot() and "BOT" or self:SteamID()
    return guthwhitelistsystem.wl[steamid] and guthwhitelistsystem.wl[steamid].whitelistAll
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

    if SERVER then
        --  >   saving
        guthwhitelistsystem:WLSave()

        --  >   networking
        for _, v in pairs( player.GetAll() ) do
            if not v:WLIsAdmin() then continue end
            v:WLSendData()
        end

        --  >   guthlogsystem
        if guthlogsystem then
            local whitelist = bool and "whitelisted" or "unwhitelisted"
            local msg = vip and "to VIP only" or ""
            guthlogsystem.addLog( "guthwhitelistsystem", ("&%s& has been %s %s"):format( team.GetName( job ), whitelist, msg ) )
        end
    end

    guthwhitelistsystem.print( ("Set job whitelist (%d : %s) to %s (VIP: %s) !"):format( job, team.GetName( job ), tostring( bool ), tostring( vip or false ) ) )
end

function guthwhitelistsystem:WLGetJobWhitelist( job )
    return guthwhitelistsystem.wlJob[job] or {}
end
