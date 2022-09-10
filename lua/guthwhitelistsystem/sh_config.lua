AddCSLuaFile()

guthwhitelistsystem = guthwhitelistsystem or {}

--  > CONFIGURATION <  --

--  < In bits, (network optimisation), how much job ID is maximum in bits (don't touch it if
--  < you don't need/know). For example, 7 bits accept 127 in maximum and 0 in minimum. If you
--  < have more than 127 jobs, up this number.
guthwhitelistsystem.JobIDBit       =   7

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

--  < Language: choice between 'en' and 'fr'
guthwhitelistsystem.Language          =  "en"

--  < The chat command to enter to open the whitelist panel
guthwhitelistsystem.ChatCommand       =  "!whitelist"

print( "\tLoaded : sh_config.lua." )
