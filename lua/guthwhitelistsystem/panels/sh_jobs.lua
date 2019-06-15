if not CLIENT then return end

guthwhitelistsystem.setPanel( "Jobs", "icon16/briefcase.png", 2, function( sheet )

    local pnlJ = vgui.Create( "DPanel", sheet ) -- panel jobs

    if not DarkRP then
        guthwhitelistsystem.panelNotif( pnlJ, "icon16/exclamation.png", "This panel can only work in the DarkRP gamemode !", 3, Color( 214, 45, 45 ) )
    end

    return pnlJ

end )
