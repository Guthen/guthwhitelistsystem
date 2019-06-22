if SERVER then

    util.AddNetworkString( "guthwhitelistsystem:SetJobWhitelist" )
    net.Receive( "guthwhitelistsystem:SetJobWhitelist", function( _, ply )
        if not ply or not ply:IsValid() then return end
        if not ply:WLIsAdmin() then return end

        local job = net.ReadUInt( 7 )
        local bool = net.ReadBool()
        local vip = net.ReadBool()
        guthwhitelistsystem:WLSetJobWhitelist( job, bool or false, vip or false )
    end )

end

if not CLIENT then return end

guthwhitelistsystem.setPanel( guthwhitelistsystem.getLan( "Jobs" ), "icon16/briefcase.png", 2, function( sheet )

    local pnlJ = vgui.Create( "DPanel", sheet ) -- panel jobs
    local ply = LocalPlayer()

    if not DarkRP then
        guthwhitelistsystem.panelNotif( pnlJ, "icon16/exclamation.png", guthwhitelistsystem.getLan( "PanelDarkRP" ), -1, Color( 214, 45, 45 ) )
    end

    local listJ = vgui.Create( "DListView", pnlJ )
        listJ:Dock( FILL )
        listJ:DockMargin( 10, 10, 10, 10 )
        listJ:SetMultiSelect( false )
        listJ:AddColumn( guthwhitelistsystem.getLan( "Jobs" ) )
        listJ:AddColumn( guthwhitelistsystem.getLan( "Whitelist ?" ) )
        listJ:AddColumn( guthwhitelistsystem.getLan( "VIP ?" ) )
        function listJ:Actualize()
            self:Clear()

            for k, v in pairs( RPExtraTeams or {} ) do
                if k == GAMEMODE.DefaultTeam then continue end -- can't whitelist the DefaultTeam

                local wl = guthwhitelistsystem:WLGetJobWhitelist( k )
                listJ:AddLine( ("%s (%d)"):format( team.GetName( k ), k ), guthwhitelistsystem.getLan( wl.active and "Yes !" or "No !" ), guthwhitelistsystem.getLan( wl.vip and "Yes !" or "No !" ) )
            end
        end
        function listJ:OnRowRightClick( _, line )
            surface.PlaySound( "UI/buttonclickrelease.wav" )
            local m = DermaMenu( pnlJ )

            if line:GetValue( 2 ) == guthwhitelistsystem.getLan( "No !" ) then
                local add = m:AddOption( guthwhitelistsystem.getLan( "ActivateWhitelist" ), function()
                    local id = string.match( line:GetValue( 1 ), "(%(%d+%))$" )
                    if not id then return end
                    id = tonumber( string.match( id, "(%d+)" ) )
                    if not id then return end
                    if not ply:WLIsAdmin() then
                        guthwhitelistsystem.panelNotif( pnlJ, "icon16/shield_delete.png", guthwhitelistsystem.getLan( "PanelNotAdmin" ), 3, Color( 214, 45, 45 ) )
                        return
                    end

                    net.Start( "guthwhitelistsystem:SetJobWhitelist" )
                        net.WriteUInt( id, 7 )
                        net.WriteBool( true )
                        net.WriteBool( false )
                    net.SendToServer()

                    guthwhitelistsystem:WLSetJobWhitelist( id, true, false )

                    guthwhitelistsystem.chat( (guthwhitelistsystem.getLan( "ChatActivateWhitelist" )):format( line:GetValue( 1 ) ) )
                    guthwhitelistsystem.panelNotif( pnlJ, "icon16/accept.png", (guthwhitelistsystem.getLan( "PanelWhitelistJob" )):format( team.GetName( id ) ), 3, Color( 45, 174, 45 ) )

                    self:Actualize()
                end )
                add:SetIcon( "icon16/accept.png" )
            else
                local remove = m:AddOption( guthwhitelistsystem.getLan( "DesactivateWhitelist" ), function()
                    local id = string.match( line:GetValue( 1 ), "(%(%d+%))$" )
                    if not id then return end
                    id = tonumber( string.match( id, "(%d+)" ) )

                    if not id then return end
                    if not ply:WLIsAdmin() then
                        guthwhitelistsystem.panelNotif( pnlJ, "icon16/shield_delete.png", guthwhitelistsystem.getLan( "PanelNotAdmin" ), 3, Color( 214, 45, 45 ) )
                        return
                    end

                    net.Start( "guthwhitelistsystem:SetJobWhitelist" )
                        net.WriteUInt( id, 7 )
                        net.WriteBool( false )
                        net.WriteBool( false )
                    net.SendToServer()

                    guthwhitelistsystem:WLSetJobWhitelist( id, false, false )

                    guthwhitelistsystem.chat( (guthwhitelistsystem.getLan( "ChatDesactivateWhitelist" )):format( line:GetValue( 1 ) ) )
                    guthwhitelistsystem.panelNotif( pnlJ, "icon16/delete.png", (guthwhitelistsystem.getLan( "PanelUnwhitelistJob" )):format( team.GetName( id ) ), 3, Color( 214, 45, 45 ) )

                    self:Actualize()
                end )
                remove:SetIcon( "icon16/delete.png" )
            end

            if line:GetValue( 2 ) == guthwhitelistsystem.getLan( "Yes !" ) and line:GetValue( 3 ) == guthwhitelistsystem.getLan( "No !" ) then
                local add = m:AddOption( "Activate VIP", function()
                    local id = string.match( line:GetValue( 1 ), "(%(%d+%))$" )
                    if not id then return end
                    id = tonumber( string.match( id, "(%d+)" ) )

                    if not id then return end
                    if not ply:WLIsAdmin() then
                        guthwhitelistsystem.panelNotif( pnlJ, "icon16/shield_delete.png", guthwhitelistsystem.getLan( "PanelNotAdmin" ), 3, Color( 214, 45, 45 ) )
                        return
                    end

                    net.Start( "guthwhitelistsystem:SetJobWhitelist" )
                        net.WriteUInt( id, 7 )
                        net.WriteBool( true )
                        net.WriteBool( true )
                    net.SendToServer()

                    guthwhitelistsystem:WLSetJobWhitelist( id, true, true )

                    guthwhitelistsystem.chat( (guthwhitelistsystem.getLan( "ChatActivateVIP" ):format( line:GetValue( 1 ) ) ) )
                    guthwhitelistsystem.panelNotif( pnlJ, "icon16/money_add.png", (guthwhitelistsystem.getLan( "PanelWhitelistJobVIP" )):format( team.GetName( id ) ), 3, Color( 45, 174, 45 ) )

                    self:Actualize()
                end )
                add:SetIcon( "icon16/accept.png" )
            elseif line:GetValue( 2 ) == guthwhitelistsystem.getLan( "Yes !" ) then
                local remove = m:AddOption( guthwhitelistsystem.getLan( "DesactivateVIP" ), function()
                    local id = string.match( line:GetValue( 1 ), "(%(%d+%))$" )
                    if not id then return end
                    id = tonumber( string.match( id, "(%d+)" ) )

                    if not id then return end
                    if not ply:WLIsAdmin() then
                        guthwhitelistsystem.panelNotif( pnlJ, "icon16/shield_delete.png", guthwhitelistsystem.getLan( "PanelNotAdmin" ), 3, Color( 214, 45, 45 ) )
                        return
                    end

                    net.Start( "guthwhitelistsystem:SetJobWhitelist" )
                        net.WriteUInt( id, 7 )
                        net.WriteBool( true )
                        net.WriteBool( false )
                    net.SendToServer()

                    guthwhitelistsystem:WLSetJobWhitelist( id, true, false )

                    guthwhitelistsystem.chat( guthwhitelistsystem.getLan( "ChatDesactivateVIP" ):format( line:GetValue( 1 ) ) )
                    guthwhitelistsystem.panelNotif( pnlJ, "icon16/money_delete.png", guthwhitelistsystem.getLan( "PanelUnwhitelistJobVIP" ):format( team.GetName( id ) ), 3, Color( 214, 45, 45 ) )

                    self:Actualize()
                end )
                remove:SetIcon( "icon16/delete.png" )
            end

            m:Open()
        end
        listJ:Actualize()

    return pnlJ

end )
