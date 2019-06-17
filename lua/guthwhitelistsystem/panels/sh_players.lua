if SERVER then

    util.AddNetworkString( "guthwhitelistsystem:SetWhitelist" )
    net.Receive( "guthwhitelistsystem:SetWhitelist", function( _, ply )
        if not ply or not ply:IsValid() then return end
        if not ply:WLIsAdmin() then return end

        local trg = net.ReadEntity() or ply
        if not trg:IsValid() or not trg:IsPlayer() then return end

        local job = net.ReadUInt( 7 )
        local bool = net.ReadBool()
        trg:WLSetJobWhitelist( job, bool, ply )
    end )

end

if not CLIENT then return end

guthwhitelistsystem.setPanel( guthwhitelistsystem.getLan( "Players" ), "icon16/user_gray.png", 1, function( sheet, w, h )

    local pnlP = vgui.Create( "DPanel", sheet ) -- panel players

    local trg = LocalPlayer()
    local ply = trg

    local listP = vgui.Create( "DListView", pnlP )
    local listJ = vgui.Create( "DListView", pnlP )
    local jobChoice = vgui.Create( "DComboBox", pnlP )

    --  > List of Players
        listP:Dock( LEFT )
        listP:DockMargin( 10, 10, 0, 10 )
        listP:SetWidth( 250 )
        listP:SetMultiSelect( false )
        listP:AddColumn( guthwhitelistsystem.getLan( "Players" ) )
        listP:AddColumn( guthwhitelistsystem.getLan( "SteamID" ) )
        for _, v in pairs( player.GetAll() ) do
            listP:AddLine( v:Name(), v:SteamID() )
        end

        function listP:OnRowSelected()
            listJ:Actualize()
            surface.PlaySound( "UI/buttonclick.wav" )
        end
        function listP:OnRowRightClick( _, line )
            surface.PlaySound( "UI/buttonclickrelease.wav" )
            local m = DermaMenu( pnlP )

            local n = m:AddOption( guthwhitelistsystem.getLan( "Copy Name" ), function()
                SetClipboardText( line:GetColumnText( 1 ) )
                guthwhitelistsystem.panelNotif( pnlP, "icon16/page_copy.png", (guthwhitelistsystem.getLan( "CopyName" )):format( trg:GetName() ), 3, Color( 210, 210, 210 ) )
            end )
            n:SetIcon( "icon16/page_copy.png" )

            local sid = m:AddOption( guthwhitelistsystem.getLan( "Copy SteamID" ), function()
                SetClipboardText( line:GetColumnText( 2 ) )
                guthwhitelistsystem.panelNotif( pnlP, "icon16/page_copy.png", (guthwhitelistsystem.getLan( "CopySteamID" )):format( trg:GetName() ), 3, Color( 210, 210, 210 ) )
            end )
            sid:SetIcon( "icon16/page_copy.png" )

            local nsid = m:AddOption( guthwhitelistsystem.getLan( "Copy NameSteamID" ), function()
                SetClipboardText( ("%s : %s"):format( line:GetColumnText( 1 ), line:GetColumnText( 2 ) ) )
                guthwhitelistsystem.panelNotif( pnlP, "icon16/page_copy.png", (guthwhitelistsystem.getLan( "CopyNameSteamID" )):format( trg:GetName() ), 3, Color( 210, 210, 210 ) )
            end )
            nsid:SetIcon( "icon16/page_copy.png" )

            m:Open()
        end

    --  > List of Jobs
        listJ:Dock( FILL )
        listJ:DockMargin( 10, 10, 10, 10 )
        listJ:SetMultiSelect( false )
        listJ:AddColumn( guthwhitelistsystem.getLan( "Jobs" ) )
        listJ:AddColumn( guthwhitelistsystem.getLan( "Date" ) )
        listJ:AddColumn( guthwhitelistsystem.getLan( "Time" ) )
        listJ:AddColumn( guthwhitelistsystem.getLan( "By" ) )
        function listJ:Actualize()
            listJ:Clear()

            trg = player.GetBySteamID( listP:GetLines()[listP:GetSelectedLine() or 1]:GetValue( 2 ) )
            if not trg then trg = LocalPlayer() end

            for k, v in pairs( trg:WLGetWhitelists() ) do
                listJ:AddLine( string.format( "%s (%d)", team.GetName( k ), k ), v.date or "?", v.time or "?", v.by or "?" )
            end
        end
        function listJ:OnRowRightClick( _, line )
            surface.PlaySound( "UI/buttonclickrelease.wav" )
            local m = DermaMenu( pnlP )

            local remove = m:AddOption( guthwhitelistsystem.getLan( "RemoveWhitelist" ) , function()
                local id = tonumber( string.match( line:GetValue( 1 ), "(%d+)" ) )
                --print( "ID:" .. tostring( id ), line:GetValue( 1 ) )
                if not id then return end
                if not ply:WLIsAdmin() then
                    guthwhitelistsystem.panelNotif( pnlP, "icon16/shield_delete.png", guthwhitelistsystem.getLan( "PanelNotAdmin" ) , 3, Color( 214, 45, 45 ) )
                    return
                end

                net.Start( "guthwhitelistsystem:SetWhitelist" )
                    net.WriteEntity( trg )
                    net.WriteUInt( id, 7 )
                    net.WriteBool( false )
                net.SendToServer()

                trg:WLSetJobWhitelist( id, false, LocalPlayer() )

                guthwhitelistsystem.chat( (guthwhitelistsystem.getLan( "ChatRemoveWhitelist" )):format( team.GetName( id ), trg:GetName(), trg:SteamID() ) )
                guthwhitelistsystem.panelNotif( pnlP, "icon16/delete.png", (guthwhitelistsystem.getLan( "PanelUnwhitelisted" )):format( trg:GetName(), team.GetName( id ) ), 3, Color( 214, 45, 45 ) )

                self:Actualize()
            end )
            remove:SetIcon( "icon16/delete.png" )

            m:Open()
        end
        listJ:SelectFirstItem()

    --  > Choice of Jobs
        jobChoice:Dock( BOTTOM )
        jobChoice:DockMargin( 10, 0, 300, 10 )
        function jobChoice:Actualize()
            self:Clear()

            local i = 0
            for k, v in pairs( guthwhitelistsystem.wlJob or {} ) do
                local select = false
                if v.vip == true then continue end -- don't show vip jobs
                if i == 0 then select = true end -- select the first job found
                jobChoice:AddChoice( team.GetName( k ), k, select, "icon16/briefcase.png" )
                i = i + 1
            end
            if i == 0 then
                jobChoice:AddChoice( guthwhitelistsystem.getLan( "Any" ), -1, true, "icon16/exclamation.png" )
            end
        end
        function jobChoice:OnSelect()
            surface.PlaySound( "UI/buttonclick.wav" )
        end
        jobChoice:Actualize()

    local addButton = vgui.Create( "DImageButton", pnlP )
        addButton:SetPos( 380, 401 )
        addButton:SetSize( 16, 16 )
        addButton:SetImage( "icon16/add.png" )
        function addButton:DoClick()
            surface.PlaySound( "UI/buttonclickrelease.wav" )

            if not ply:WLIsAdmin() then
                guthwhitelistsystem.panelNotif( pnlP, "icon16/shield_delete.png", guthwhitelistsystem.getLan( "PanelNotAdmin" ), 3, Color( 214, 45, 45 ) )
                return
            end

            local _, id = jobChoice:GetSelected()
            if not id then return guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", guthwhitelistsystem.getLan( "PanelUncorrectJob" ), 3, Color( 214, 45, 45 ) ) end
            if not guthwhitelistsystem:WLGetJobWhitelist( id ).active then return guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", guthwhitelistsystem.getLan( "PanelNotWhitelisted" ), 3, Color( 214, 45, 45 ) ) end
            if trg:WLGetJobWhitelist( id ) then return guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", (guthwhitelistsystem.getLan( "PanelAlreadyWhitelist" )):format( trg:GetName(), team.GetName( id ) ), 3, Color( 214, 45, 45 ) ) end

            net.Start( "guthwhitelistsystem:SetWhitelist" )
                net.WriteEntity( trg )
                net.WriteUInt( id, 7 )
                net.WriteBool( true )
            net.SendToServer()

            trg:WLSetJobWhitelist( id, true, LocalPlayer() )

            guthwhitelistsystem.chat( (guthwhitelistsystem.getLan( "ChatAddWhitelist" )):format( team.GetName( id ), trg:GetName(), trg:SteamID() ) )
            guthwhitelistsystem.panelNotif( pnlP, "icon16/accept.png", (guthwhitelistsystem.getLan( "PanelWhitelisted" )):format( trg:GetName(), team.GetName( id ) ), 3, Color( 45, 174, 45 ) )

            listJ:Actualize()
        end

    local refreshButton = vgui.Create( "DImageButton", pnlP )
        refreshButton:SetPos( 400, 401 )
        refreshButton:SetSize( 16, 16 )
        refreshButton:SetImage( "icon16/arrow_refresh.png" )
        function refreshButton:DoClick()
            surface.PlaySound( "UI/buttonclickrelease.wav" )

            jobChoice:Actualize()
            guthwhitelistsystem.panelNotif( pnlP, "icon16/arrow_refresh.png", guthwhitelistsystem.getLan( "PanelRefreshJob" ), 3, Color( 45, 174, 45 ) )
        end

    -- error
    if not DarkRP then
        guthwhitelistsystem.panelNotif( pnlP, "icon16/exclamation.png", guthwhitelistsystem.getLan( "PanelDarkRP" ), -1, Color( 214, 45, 45 ) )
    else -- info
        guthwhitelistsystem.panelNotif( pnlP, "icon16/information.png", guthwhitelistsystem.getLan( "PanelWelcome" ), 3, Color( 45, 45, 214 ) )
    end

    return pnlP

end )
