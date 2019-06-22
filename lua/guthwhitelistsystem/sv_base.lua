guthwhitelistsystem = guthwhitelistsystem or {}

local path = "guthwhitelistsystem/"
local function loadFolder( folder )
    print( ("\vLoading %s:"):format( folder ) )

    local _path = path .. folder

    local i = 0
    local load = "Loaded"
    for _, v in pairs( file.Find( ("%s/*.lua"):format( _path ), "LUA" ) ) do
        if string.StartWith( v, "sv_" ) then
            include( ("%s/%s"):format( _path, v ) )
        else
            if not string.StartWith( v, "cl" ) then
                load = "Loaded/AddCSLuaFile"
                include( ("%s/%s"):format( _path, v ) )
            else
                load = "AddCSLuaFile"
            end
            AddCSLuaFile( ("%s/%s"):format( _path, v ) )
        end

        i = i + 1
        print( ("\t%s : %s"):format( load, v ) )
    end

    print( ("\tLoaded %d %s."):format( i, folder ) )
end

function guthwhitelistsystem.load()
    print( "\n--> [guthwhitelistsystem] <--" )

    include( "sh_config.lua" )

    loadFolder( "modules" )
    loadFolder( "panels" )
    loadFolder( "languages" )

    util.AddNetworkString( "guthwhitelistsystem:Chat" )

    print( "---------> [loaded] <--------" )
end
guthwhitelistsystem.load()

--  > Make some usefull functions

function guthwhitelistsystem.print( msg )
    if not msg or not isstring( msg ) then return end
    print( ("[guthwhitelistsystem] - %s"):format( msg )  )
end

function guthwhitelistsystem.chat( ply, msg )
    if not ply or not ply:IsPlayer() then return end
    if not msg or not isstring( msg ) then return guthwhitelistsystem.print( "'guthwhitelistsystem.chat' should have a string variable." ) end

    net.Start( "guthwhitelistsystem:Chat" )
        net.WriteString( msg )
    net.Send( ply )
end

function guthwhitelistsystem.getLan( id )
    local l = guthwhitelistsystem.languages[guthwhitelistsystem.Language]
    return l and l[id]
end
