guthwhitelistsystem.panels = guthwhitelistsystem.panels or {}

--  > Create function to add panels
function guthwhitelistsystem.setPanel( name, icon, sort, func )
    if not name or not icon or not func then return guthwhitelistsystem.print( "'guthwhitelistsystem.setPanel' should have 3 valid arguments." ) end
    if not isstring( name ) then return guthwhitelistsystem.print( "'guthwhitelistsystem.setPanel' #1 argument must be a string." ) end
    if not isstring( icon ) then return guthwhitelistsystem.print( "'guthwhitelistsystem.setPanel' #2 argument must be a string." ) end
    if not isfunction( func ) then return guthwhitelistsystem.print( "'guthwhitelistsystem.setPanel' #4 argument must be a function." ) end

    table.insert( guthwhitelistsystem.panels, { name = name, func = func, icon = icon, sort = sort or 0 } )

    if sort then
        table.SortByMember( guthwhitelistsystem.panels, "sort", true )
    end
end

--  > Make a panel to configure the jobs, players..

local w, h = 700, 500
function guthwhitelistsystem.panel()
    --  > Load the panels
    guthwhitelistsystem.loadPanels()

    guthwhitelistsystem.chat( "Panel opened !" )

    local frame = vgui.Create( "DFrame" )
        frame:SetSize( w, h )
        frame:Center()
        frame:SetTitle( "" )
        frame:SetDraggable( false )
        frame:ShowCloseButton( false )
        frame:MakePopup()
        frame:SetSize( w, 0 )
        frame:SizeTo( -1, h, 1, 0, -5 ) -- animation
        function frame:Paint()
        end

    local sheet = vgui.Create( "DPropertySheet", frame )
        sheet:Dock( FILL )
        for _, v in ipairs( guthwhitelistsystem.panels ) do
            local pnl = v.func( sheet )
            if not pnl or not ispanel( pnl ) then continue end

            sheet:AddSheet( v.name, pnl, v.icon )
        end

    local close = vgui.Create( "DImageButton", frame )
        close:SetPos( w - 24, 32 )
        close:SetSize( 16, 16 )
        close:SetImage( "icon16/cancel.png" )
        function close:DoClick()
            guthwhitelistsystem.chat( "Panel closed !" )
            frame:SizeTo( -1, 0, 1, 0, -5, function() -- animation
                frame:Close()
            end )
        end
end
concommand.Add( "guthwhitelistsystem_panel", guthwhitelistsystem.panel )
