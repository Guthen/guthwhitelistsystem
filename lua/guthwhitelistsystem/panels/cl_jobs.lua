guthwhitelistsystem.setPanel( "Jobs", "icon16/briefcase.png", 2, function( sheet )

    local pnlJ = vgui.Create( "DPanel", sheet ) -- panel jobs

    if not DarkRP then
        local exclamation = Material( "icon16/exclamation.png" )
        local _, _h = pnlJ:GetSize()

        local pnl = vgui.Create( "DPanel", pnlJ )
            pnl:Dock( TOP )
            pnl:SetHeight( 0 )
            pnl:SizeTo( -1, 30, 1 )
            function pnl:Paint( w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color( 215, 45, 45 ) )
                draw.SimpleText( "This panel can only work in the DarkRP gamemode !", "DermaDefaultBold", 25, 14, Color( 255, 255, 255, 255 ), _, TEXT_ALIGN_CENTER )

                surface.SetDrawColor( Color( 255, 255, 255 ) )
                surface.SetMaterial( exclamation )
                surface.DrawTexturedRect( 5, 7, 16, 16 )
            end
    else

    end

    return pnlJ
    
end )
