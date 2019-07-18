
--  > Properties Add

properties.Add( "guthwhitelistsystem_add", -- adding whitelist
    {
        MenuLabel = "",
        Order = math.huge,
        PrependSpacer = true,

        Filter = function( self, ent, ply )
            if not DarkRP then return false end
            if not IsValid( ent ) or not ent:IsPlayer() then return false end
            if not ply:WLIsAdmin() then return false end

            return true
        end,
        MenuOpen = function( self, pnl, ent )
            if not self:Filter( ent, LocalPlayer() ) then return end

            pnl:Remove() -- removing default

            local m = pnl:GetMenu()
            pnl, _pnl = m:AddSubMenu( guthwhitelistsystem.getLan( "WhitelistAdd" ) ) -- creating new
            _pnl:SetIcon( "icon16/application_add.png" )

            local i = 0
            for k, v in pairs( guthwhitelistsystem.wlJob or {} ) do
                if k == GAMEMODE.DefaultTeam then continue end -- can't whitelist the DefaultTeam
                if ent:WLGetJobWhitelist( k ) then continue end
                local _m = pnl:AddOption( ("%s (%d)"):format( team.GetName( k ), k ), function() self:Action( ent, _, k ) end )
                _m:SetIcon( "icon16/briefcase.png" )
                i = i + 1
            end
            if i == 0 then
                local _m = pnl:AddOption( guthwhitelistsystem.getLan( "Any" ) )
                _m:SetIcon( "icon16/exclamation.png" )
            end
        end,
        Action = function( self, ent, _, id )
            self:MsgStart()
                net.WriteEntity( ent )
                net.WriteUInt( id or 1, 7 )
            self:MsgEnd()

            surface.PlaySound( "UI/buttonclick.wav" )
        end,
        Receive = function( self, _, ply )
            local ent = net.ReadEntity()
            local id = net.ReadUInt( 7 )
            if not IsValid( ply ) or not ply:IsPlayer() then return false end
            if not self:Filter( ent, ply ) then return end

            ent:WLSetJobWhitelist( id, true, ply )
            guthwhitelistsystem.chat( ply, guthwhitelistsystem.getLan( "ChatAddWhitelist" ):format( team.GetName( id ), ent:GetName(), ent:SteamID() ) )
            guthwhitelistsystem.chat( ent, guthwhitelistsystem.getLan( "ChatGetAddWhitelist" ):format( team.GetName( id ), ply:GetName(), ply:SteamID() ) )
        end,
    } )

properties.Add( "guthwhitelistsystem_remove", -- adding whitelist
    {
        MenuLabel = " ",
        Order = math.huge,

        Filter = function( self, ent, ply )
            if not DarkRP then return false end
            if not IsValid( ent ) or not ent:IsPlayer() then return false end
            if not ply:WLIsAdmin() then return false end

            return true
        end,
        MenuOpen = function( self, pnl, ent )
            if not self:Filter( ent, LocalPlayer() ) then return end

            pnl:Remove() -- removing default

            local m = pnl:GetMenu()
            pnl, _pnl = m:AddSubMenu( guthwhitelistsystem.getLan( "WhitelistRemove" ) ) -- creating new
            _pnl:SetIcon( "icon16/application_delete.png" )

            local i = 0
            for k, v in pairs( guthwhitelistsystem.wlJob or {} ) do
                if k == GAMEMODE.DefaultTeam then continue end -- can't whitelist the DefaultTeam
                if not ent:WLGetJobWhitelist( k ) then continue end
                local _m = pnl:AddOption( ("%s (%d)"):format( team.GetName( k ), k ), function() self:Action( ent, _, k ) end )
                _m:SetIcon( "icon16/briefcase.png" )
                i = i + 1
            end
            if i == 0 then
                local _m = pnl:AddOption( guthwhitelistsystem.getLan( "Any" ) )
                _m:SetIcon( "icon16/exclamation.png" )
            end
        end,
        Action = function( self, ent, _, id )
            self:MsgStart()
                net.WriteEntity( ent )
                net.WriteUInt( id or 1, 7 )
            self:MsgEnd()

            surface.PlaySound( "UI/buttonclick.wav" )
        end,
        Receive = function( self, _, ply )
            local ent = net.ReadEntity()
            local id = net.ReadUInt( 7 )
            if not IsValid( ply ) or not ply:IsPlayer() then return false end
            if not self:Filter( ent, ply ) then return end

            ent:WLSetJobWhitelist( id, false, ply )
            guthwhitelistsystem.chat( ply, guthwhitelistsystem.getLan( "ChatRemoveWhitelist" ):format( team.GetName( id ), ent:GetName(), ent:SteamID() ) )
            guthwhitelistsystem.chat( ent, guthwhitelistsystem.getLan( "ChatGetRemoveWhitelist" ):format( team.GetName( id ), ply:GetName(), ply:SteamID() ) )
        end,
    } )
