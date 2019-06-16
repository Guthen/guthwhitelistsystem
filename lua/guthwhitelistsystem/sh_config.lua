AddCSLuaFile()

guthwhitelistsystem = guthwhitelistsystem or {}

--  > CONFIGURATION <  --

--  < In seconds, how many seconds it takes to make a save of whitelists
guthwhitelistsystem.TimerSaveTime   =   120

--  < All the VIP ranks, they have access to the VIP whitelist
guthwhitelistsystem.VIPRanks        =
                    {
                        ["superadmin"] = true,
                        ["vip"] = true,
                    }

--  < All the Admin ranks, they have access to whitelist panel (they can whitelist peoples and jobs)
guthwhitelistsystem.AdminRanks        =
                    {
                        ["superadmin"] = true,
                        ["admin"] = true,
                    }

print( "\tLoaded : sh_config.lua." )
