if SERVER then

    net.Receive( "guthwhitelistsystem:AddWhitelist", function( _, ply )
        if not ply or not ply:IsValid() then return end
        if not ply:IsAdmin() then return end

        local trg = net.ReadEntity()
        if not trg:IsValid() or not trg:IsPlayer() then return end

        local job = net.ReadUInt( 7 )
        trg:WLSetJobWhitelist( job, true )
    end )

end

if not CLIENT then return end

guthwhitelistsystem.setPanel( "Players", "icon16/user_gray.png", 1, function( sheet )

    local pnlP = vgui.Create( "DPanel", sheet ) -- panel players

    local listP = vgui.Create( "DListView", pnlP )
        listP:Dock( LEFT )
        listP:DockMargin( 10, 10, 0, 10 )
        listP:SetWidth( 250 )
        listP:SetMultiSelect( false )
        listP:AddColumn( "Players" )
        listP:AddColumn( "SteamID" )
        for _, v in pairs( player.GetAll() ) do
            listP:AddLine( v:Name(), v:SteamID() )
        end

        function listP:OnRowRightClick( id, line )
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

    local listJ = vgui.Create( "DListView", pnlP )
        listJ:Dock( FILL )
        listJ:DockMargin( 10, 10, 10, 10 )
        listJ:SetMultiSelect( false )
        listJ:AddColumn( "Job" )
        listJ:AddColumn( "Date" )
        listJ:AddColumn( "Time" )
        listJ:AddColumn( "By" )

    local jobChoice = vgui.Create( "DComboBox", pnlP )
        jobChoice:Dock( BOTTOM )
        jobChoice:DockMargin( 10, 0, 300, 10 )
        jobChoice:InvalidateLayout( true )
        for k, v in pairs( RPExtraTeams or {} ) do
            local select = false
            if k == 1 then select = true end
            jobChoice:AddChoice( v.name, k, select, "icon16/briefcase.png" )
        end

    local _x, _y = jobChoice:GetPos()
    local addButton = vgui.Create( "DImageButton", pnlP )
        addButton:SetPos( _x + jobChoice:GetWide() + 10, _y )
        addButton:SetSize( 16, 16 )
        addButton:SetImage( "icon16/add.png" )

    -- error
    if not DarkRP then
        guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", "This panel can only work in the DarkRP gamemode !", 3, Color( 214, 45, 45 ) )
    end

    return pnlP

end )
