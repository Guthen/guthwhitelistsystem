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

guthwhitelistsystem.setPanel( "Jobs", "icon16/briefcase.png", 2, function( sheet )

    local pnlJ = vgui.Create( "DPanel", sheet ) -- panel jobs
    local ply = LocalPlayer()

    if not DarkRP then
        guthwhitelistsystem.panelNotif( pnlJ, "icon16/exclamation.png", "This panel can only work in the DarkRP gamemode !", -1, Color( 214, 45, 45 ) )
    end

    local listJ = vgui.Create( "DListView", pnlJ )
        listJ:Dock( FILL )
        listJ:DockMargin( 10, 10, 10, 10 )
        listJ:SetMultiSelect( false )
        listJ:AddColumn( "Job" )
        listJ:AddColumn( "Whitelist ?" )
        listJ:AddColumn( "VIP ?" )
        function listJ:Actualize()
            self:Clear()

            for k, v in pairs( RPExtraTeams or {} ) do
                if k == GAMEMODE.DefaultTeam then continue end -- can't whitelist the DefaultTeam

                local wl = guthwhitelistsystem:WLGetJobWhitelist( k )
                listJ:AddLine( ("%s (%d)"):format( team.GetName( k ), k ), wl.active and "Yes !" or "No !", wl.vip and "Yes !" or "No !" )
            end
        end
        function listJ:OnRowRightClick( _, line )
            surface.PlaySound( "UI/buttonclickrelease.wav" )
            local m = DermaMenu( pnlJ )

            if line:GetValue( 2 ) == "No !" then
                local add = m:AddOption( "Activate whitelist", function()
                    local id = tonumber( string.match( line:GetValue( 1 ), "(%d+)" ) )
                    --print( "ID:" .. tostring( id ), line:GetValue( 1 ) )
                    if not id then return end
                    if not ply:WLIsAdmin() then
                        guthwhitelistsystem.panelNotif( pnlJ, "icon16/shield_delete.png", "You are not an admin !", 3, Color( 214, 45, 45 ) )
                        return
                    end

                    net.Start( "guthwhitelistsystem:SetJobWhitelist" )
                        net.WriteUInt( id, 7 )
                        net.WriteBool( true )
                        net.WriteBool( false )
                    net.SendToServer()

                    guthwhitelistsystem:WLSetJobWhitelist( id, true, false )

                    guthwhitelistsystem.chat( ("You activated whitelist to %s !"):format( line:GetValue( 1 ) ) )
                    guthwhitelistsystem.panelNotif( pnlJ, "icon16/accept.png", ("You whitelisted the job %s !"):format( team.GetName( id ) ), 3, Color( 45, 174, 45 ) )

                    self:Actualize()
                end )
                add:SetIcon( "icon16/accept.png" )
            else
                local remove = m:AddOption( "Desactivate whitelist", function()
                    local id = tonumber( string.match( line:GetValue( 1 ), "(%d+)" ) )
                    --print( "ID:" .. tostring( id ), line:GetValue( 1 ) )
                    if not id then return end
                    if not ply:WLIsAdmin() then
                        guthwhitelistsystem.panelNotif( pnlJ, "icon16/shield_delete.png", "You are not an admin !", 3, Color( 214, 45, 45 ) )
                        return
                    end

                    net.Start( "guthwhitelistsystem:SetJobWhitelist" )
                        net.WriteUInt( id, 7 )
                        net.WriteBool( false )
                        net.WriteBool( false )
                    net.SendToServer()

                    guthwhitelistsystem:WLSetJobWhitelist( id, false, false )

                    guthwhitelistsystem.chat( ("You desactived whitelist to %s !"):format( line:GetValue( 1 ) ) )
                    guthwhitelistsystem.panelNotif( pnlJ, "icon16/delete.png", ("You unwhitelisted the job %s !"):format( team.GetName( id ) ), 3, Color( 214, 45, 45 ) )

                    self:Actualize()
                end )
                remove:SetIcon( "icon16/delete.png" )
            end

            if line:GetValue( 2 ) == "Yes !" and line:GetValue( 3 ) == "No !" then
                local add = m:AddOption( "Activate VIP", function()
                    local id = tonumber( string.match( line:GetValue( 1 ), "(%d+)" ) )
                    --print( "ID:" .. tostring( id ), line:GetValue( 1 ) )
                    if not id then return end
                    if not ply:WLIsAdmin() then
                        guthwhitelistsystem.panelNotif( pnlJ, "icon16/shield_delete.png", "You are not an admin !", 3, Color( 214, 45, 45 ) )
                        return
                    end

                    net.Start( "guthwhitelistsystem:SetJobWhitelist" )
                        net.WriteUInt( id, 7 )
                        net.WriteBool( true )
                        net.WriteBool( true )
                    net.SendToServer()

                    guthwhitelistsystem:WLSetJobWhitelist( id, true, true )

                    guthwhitelistsystem.chat( ("You activated VIP to %s !"):format( line:GetValue( 1 ) ) )
                    guthwhitelistsystem.panelNotif( pnlJ, "icon16/money_add.png", ("You whitelisted the job %s to VIP only !"):format( team.GetName( id ) ), 3, Color( 45, 174, 45 ) )

                    self:Actualize()
                end )
                add:SetIcon( "icon16/accept.png" )
            elseif line:GetValue( 2 ) == "Yes !" then
                local remove = m:AddOption( "Desactivate VIP", function()
                    local id = tonumber( string.match( line:GetValue( 1 ), "(%d+)" ) )
                    --print( "ID:" .. tostring( id ), line:GetValue( 1 ) )
                    if not id then return end
                    if not ply:WLIsAdmin() then
                        guthwhitelistsystem.panelNotif( pnlJ, "icon16/shield_delete.png", "You are not an admin !", 3, Color( 214, 45, 45 ) )
                        return
                    end

                    net.Start( "guthwhitelistsystem:SetJobWhitelist" )
                        net.WriteUInt( id, 7 )
                        net.WriteBool( true )
                        net.WriteBool( false )
                    net.SendToServer()

                    guthwhitelistsystem:WLSetJobWhitelist( id, true, false )

                    guthwhitelistsystem.chat( ("You desactived VIP to %s !"):format( line:GetValue( 1 ) ) )
                    guthwhitelistsystem.panelNotif( pnlJ, "icon16/money_delete.png", ("You unwhitelisted the job %s to VIP only !"):format( team.GetName( id ) ), 3, Color( 214, 45, 45 ) )

                    self:Actualize()
                end )
                remove:SetIcon( "icon16/delete.png" )
            end

            m:Open()
        end
        listJ:Actualize()

    return pnlJ

end )
