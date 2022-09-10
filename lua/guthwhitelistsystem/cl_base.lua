guthwhitelistsystem = guthwhitelistsystem or {}

local path = "guthwhitelistsystem/"
local function loadFolder( folder )
    print( ("\vLoading %s:"):format( folder ) )

    local _path = path .. folder

    local i = 0
    for _, v in pairs( file.Find( ("%s/*.lua"):format( _path ), "LUA" ) ) do
        if string.StartWith( v, "sv_" ) then
            continue
        else
            include( ("%s/%s"):format( _path, v ) )
        end

        i = i + 1
        print( ("\tLoaded : %s"):format( v ) )
    end

    print( ("\tLoaded %d %s."):format( i, folder ) )
end

function guthwhitelistsystem.load()
    print( "\n--> [guthwhitelistsystem] <--" )

    include( "sh_config.lua" )

    loadFolder( "modules" )
    loadFolder( "languages" )


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

function guthwhitelistsystem.getLan( id )
    local l = guthwhitelistsystem.languages[guthwhitelistsystem.Language]
    return l and l[id]
end

--  > Receive some data
local function retrieve_data() 
    net.Start( "guthwhitelistsystem:SendData" )
    net.SendToServer()
end
concommand.Add( "guthwhitelistsystem_retrieve_data", retrieve_data )
hook.Add( "InitPostEntity", "guthwhitelistsystem:SendData", retrieve_data )

net.Receive( "guthwhitelistsystem:SendData", function()
    local wl = net.ReadTable()
    local jobs = net.ReadTable()

    local i = 0
    if wl and istable( wl ) then
        guthwhitelistsystem.wl = wl
        i = i + 1
    end
    if jobs and istable( jobs ) then
        guthwhitelistsystem.wlJob = jobs
        i = i + 1
    end

    guthwhitelistsystem.print( ( "Receive some data ! (%d)"):format( i ) )
end )

net.Receive( "guthwhitelistsystem:Chat", function()
    guthwhitelistsystem.chat( net.ReadString() )
end )
