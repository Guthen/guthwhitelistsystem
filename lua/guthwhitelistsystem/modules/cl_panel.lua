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
        --function frame:OnRemove()
            --guthwhitelistsystem.panelObj = nil
        --end

    local sheet = vgui.Create( "DPropertySheet", frame )
        sheet:Dock( FILL )
        for _, v in ipairs( guthwhitelistsystem.panels ) do
            local pnl = v.func( sheet )
            if not pnl or not ispanel( pnl ) then continue end

            sheet:AddSheet( v.name, pnl, v.icon )
        end
        function sheet:OnActiveTabChanged( _, new )
            self:InvalidateChildren( true )
        end

    local close = vgui.Create( "DImageButton", frame )
        close:SetPos( w - 24, 32 )
        close:SetSize( 16, 16 )
        close:SetImage( "icon16/cancel.png" )
        function close:DoClick()
            guthwhitelistsystem.chat( "Panel closed !" )
            frame:SizeTo( -1, 0, 1, 0, -5, function() -- animation
                frame:Remove()
            end )
        end
end
concommand.Add( "guthwhitelistsystem_panel", guthwhitelistsystem.panel )

--  > #pnl: panel, the panel object
--  > #icon: string, the icon image
--  > #msg: string, the displayed message
--  > #time: number, the time before it get destroyed
--  > #color: color, the background color
function guthwhitelistsystem.panelNotif( pnl, icon, msg, time, color )
    if not ispanel( pnl ) or not pnl:IsValid() then print(pnl) return false end

    local icon = Material( icon or "icon16/bricks.png" )

    local pnl = vgui.Create( "DPanel", pnl )
        pnl:SetSize( w )
        pnl:SetHeight( 0 )
        pnl:SizeTo( -1, 30, 1 )
        function pnl:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, color or Color( 215, 45, 45 ) )
            draw.SimpleText( msg or "Enter a message here.", "DermaDefaultBold", 25, 14, Color( 255, 255, 255 ), _, TEXT_ALIGN_CENTER )

            surface.SetDrawColor( Color( 255, 255, 255 ) )
            surface.SetMaterial( icon )
            surface.DrawTexturedRect( 5, 7, 16, 16 )
        end

        print( "1" )
    if time == -1 then return end
    print( "2" )
    timer.Simple( time or 3, function()
        print( "3" )
        pnl:SizeTo( -1, 0, 1, 0, -1, function()
            print( "4" )
            pnl:Remove()
        end )
    end )
end
