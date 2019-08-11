
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
                local _m = pnl:AddOption( ("%s (%d)"):format( team.GetName( k ), k ), function() self:Action( ent, false, k ) end )
                _m:SetIcon( "icon16/briefcase.png" )
                i = i + 1
            end
            if i == 0 then
                local _m = pnl:AddOption( guthwhitelistsystem.getLan( "Any" ) )
                _m:SetIcon( "icon16/exclamation.png" )
            elseif not ent:WLIsWhitelistAll() then
                pnl:AddOption( guthwhitelistsystem.getLan( "WhitelistAll" ), function()
                    self:Action( ent, true )
                end ):SetIcon( "icon16/book_key.png" )
            end
        end,
        Action = function( self, ent, whitelistAll, id )
            if whitelistAll then
                self:MsgStart()
                    net.WriteBool( true )
                    net.WriteEntity( ent )
                self:MsgEnd()
            else
                self:MsgStart()
                    net.WriteBool( false )
                    net.WriteEntity( ent )
                    net.WriteUInt( id or 1, guthwhitelistsystem.JobIDBit )
                self:MsgEnd()
            end

            surface.PlaySound( "UI/buttonclick.wav" )
        end,
        Receive = function( self, _, ply )
            local whitelistAll = net.ReadBool()
            local ent = net.ReadEntity()
            local id = net.ReadUInt( guthwhitelistsystem.JobIDBit )
            if not IsValid( ply ) or not ply:IsPlayer() then return false end
            if not self:Filter( ent, ply ) then return end

            if whitelistAll then
                ent:WLSetWhitelistAll( true, ply )
                guthwhitelistsystem.chat( ply, guthwhitelistsystem.getLan( "ChatAddWhitelistAll" ):format( ent:GetName(), ent:SteamID() ) )
                guthwhitelistsystem.chat( ent, guthwhitelistsystem.getLan( "ChatGetAddWhitelistAll" ):format( ply:GetName(), ply:SteamID() ) )
            else
                ent:WLSetJobWhitelist( id, true, ply )
                guthwhitelistsystem.chat( ply, guthwhitelistsystem.getLan( "ChatAddWhitelist" ):format( team.GetName( id ), ent:GetName(), ent:SteamID() ) )
                guthwhitelistsystem.chat( ent, guthwhitelistsystem.getLan( "ChatGetAddWhitelist" ):format( team.GetName( id ), ply:GetName(), ply:SteamID() ) )
            end
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
            if i == 0 and not ent:WLIsWhitelistAll() then
                local _m = pnl:AddOption( guthwhitelistsystem.getLan( "Any" ) )
                _m:SetIcon( "icon16/exclamation.png" )
            elseif ent:WLIsWhitelistAll() then
                pnl:AddOption( guthwhitelistsystem.getLan( "WhitelistAll" ), function()
                    self:Action( ent, true )
                end ):SetIcon( "icon16/book_key.png" )
            end
        end,
        Action = function( self, ent, whitelistAll, id )
            if whitelistAll then
                self:MsgStart()
                    net.WriteBool( true )
                    net.WriteEntity( ent )
                self:MsgEnd()
            else
                self:MsgStart()
                    net.WriteBool( false )
                    net.WriteEntity( ent )
                    net.WriteUInt( id or 1, guthwhitelistsystem.JobIDBit )
                self:MsgEnd()
            end

            surface.PlaySound( "UI/buttonclick.wav" )
        end,
        Receive = function( self, _, ply )
            local whitelistAll = net.ReadBool()
            local ent = net.ReadEntity()
            local id = net.ReadUInt( guthwhitelistsystem.JobIDBit )
            if not IsValid( ply ) or not ply:IsPlayer() then return false end
            if not self:Filter( ent, ply ) then return end

            if whitelistAll then
                ent:WLSetWhitelistAll( false, ply )
                guthwhitelistsystem.chat( ply, guthwhitelistsystem.getLan( "ChatRemoveWhitelistAll" ):format( ent:GetName(), ent:SteamID() ) )
                guthwhitelistsystem.chat( ent, guthwhitelistsystem.getLan( "ChatGetRemoveWhitelistAll" ):format( ply:GetName(), ply:SteamID() ) )
            else
                ent:WLSetJobWhitelist( id, false, ply )
                guthwhitelistsystem.chat( ply, guthwhitelistsystem.getLan( "ChatRemoveWhitelist" ):format( team.GetName( id ), ent:GetName(), ent:SteamID() ) )
                guthwhitelistsystem.chat( ent, guthwhitelistsystem.getLan( "ChatGetRemoveWhitelist" ):format( team.GetName( id ), ply:GetName(), ply:SteamID() ) )
            end
        end,
    } )
