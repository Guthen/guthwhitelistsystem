guthwhitelistsystem.setPanel( "Players", "icon16/user_gray.png", 1, function( sheet )

    local pnlP = vgui.Create( "DPanel", sheet ) -- panel players

    local list = vgui.Create( "DListView", pnlP )
        list:Dock( LEFT )
        list:DockMargin( 10, 10, 0, 10 )
        list:SetWidth( 200 )
        list:SetMultiSelect( false )
        list:AddColumn( "Players" )
        list:AddColumn( "SteamID" )
        for _, v in pairs( player.GetAll() ) do
            list:AddLine( v:Name(), v:SteamID() )
        end

        function list:OnRowRightClick( id, line )
            local m = DermaMenu( pnlP )

            local n = m:AddOption( "Copy Name", function()
                SetClipboardText( line:GetColumnText( 1 ) )
            end )
            n:SetIcon( "icon16/page_copy.png" )

            local sid = m:AddOption( "Copy SteamID", function()
                SetClipboardText( line:GetColumnText( 2 ) )
            end )
            sid:SetIcon( "icon16/page_copy.png" )

            local nsid = m:AddOption( "Copy Name + SteamID", function()
                SetClipboardText( ("%s : %s"):format( line:GetColumnText( 1 ), line:GetColumnText( 2 ) ) )
            end )
            nsid:SetIcon( "icon16/page_copy.png" )

            m:Open()
        end

    return pnlP

end )
