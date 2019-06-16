
--  > Info command

concommand.Add( "guthwhitelistsystem_info", function()
    local msg = string.format(
        "[guthwhitelistsystem] - 'guthwhitelistsystem' is made by %s.\nThe installated version is %s.\nDownload the addon here : %s.\nJoin freely my Discord : %s.",
        guthwhitelistsystem.Author, guthwhitelistsystem.Version, guthwhitelistsystem.Link, guthwhitelistsystem.Discord)

    if ply:IsValid() then
        ply:PrintMessage( HUD_PRINTCONSOLE, msg )
    else
        print( msg )
    end
end )
