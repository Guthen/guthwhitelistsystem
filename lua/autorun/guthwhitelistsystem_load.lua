guthwhitelistsystem = {}
guthwhitelistsystem.Author = "Guthen"
guthwhitelistsystem.Version = "0.1.0"
guthwhitelistsystem.Link = "https://github.com/Guthen/guthwhitelistsystem"
guthwhitelistsystem.Discord = "https://discord.gg/eKgkpCf"

if SERVER then
    include( "guthwhitelistsystem/sv_base.lua" )
else
    include( "guthwhitelistsystem/cl_base.lua" )
end

print( ("[guthwhitelistsystem] - Made by %s in version %s, type 'guthwhitelistsystem_info' for more info."):format( guthwhitelistsystem.Author, guthwhitelistsystem.Version ) )