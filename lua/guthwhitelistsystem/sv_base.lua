guthwhitelistsystem = guthwhitelistsystem or {}

local path = "guthwhitelistsystem/"
local function loadFolder( folder )
    print( ("\vLoading %s:"):format( folder ) )

    local _path = path .. folder

    local i = 0
    for _, v in pairs( file.Find( ("%s/*.lua"):format( _path ), "LUA" ) ) do
        if string.StartWith( v, "sv_" ) then
            include( ("%s/%s"):format( _path, v ) )
        elseif string.StartWith( v, "sh_" ) then
            include( ("%s/%s"):format( _path, v ) )
            AddCSLuaFile( ("%s/%s"):format( _path, v ) )
        elseif string.StartWith( v, "cl_" ) then
            AddCSLuaFile( ("%s/%s"):format( _path, v ) )
            print( ("%s/%s"):format( _path, v ) )
        else
            print( ("\vFailed to load : %s"):format( v ) )
            continue
        end

        i = i + 1
        print( ("\vLoaded : %s"):format( v ) )
    end

    print( ("\vLoaded %d %s."):format( i, folder ) )
end

function guthwhitelistsystem.load()
    print( "\n--> [guthwhitelistsystem] <--" )

    loadFolder( "modules" )
    loadFolder( "panels" )

    print( "---------> [loaded] <--------" )
end
guthwhitelistsystem.load()
