guthwhitelistsystem = guthwhitelistsystem or {}

local path = "guthwhitelistsystem/"
local function loadFolder( folder )
    print( ("\vLoading %s:"):format( folder ) )

    local _path = path .. folder

    local i = 0
    for _, v in pairs( file.Find( ("%s/*.lua"):format( _path ), "LUA" ) ) do
        if string.StartWith( v, "cl_" ) or string.StartWith( v, "sh_" ) then
            include( ("%s/%s"):format( _path, v ) )
        elseif string.StartWith( v, "sv_" ) then
            continue
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

    print( "---------> [loaded] <--------" )
end
guthwhitelistsystem.load()

--  > Make some usefull functions

function guthwhitelistsystem.loadPanels()
    guthwhitelistsystem.panels = {}
    loadFolder( "panels" )
end

function guthwhitelistsystem.print( msg )
    if not msg or not isstring( msg ) then return end
    print( ("[guthwhitelistsystem] - %s"):format( msg )  )
end

function guthwhitelistsystem.chat( msg )
    if not msg or not isstring( msg ) then return guthwhitelistsystem.print( "'guthwhitelistsystem.chat' should have a string variable." ) end
    chat.AddText( Color( 215, 145, 45 ), "[guthwhitelistsystem] - ", Color( 255, 255, 255 ), msg )
end
