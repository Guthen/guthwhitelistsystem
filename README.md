# guthwhitelistsystem
Garry's Mod job whitelist system for DarkRP.

## How to install it ?

You just need to install it in your addons folder and to configure it in `lua/guthwhitelistsystem/sh_config.lua`.

## How to open the panel ?

Type in your console : `guthwhitelistsystem_panel`
(I recommand to you, to bind it to a key)

## Do there are functions for developpers ?

Yes there are.

#### Players metafunctions :
```lua
--  > : Add/Remove the whitelist of a job to a specified player
--  > #jobId (number): the index of the job
--  > #bool (boolean): 'true' to add the whitelist and 'false' to remove it
--  > #by (optional) (player): Player who add the whitelist
--  > NOTE: Set the whitelist on CLIENT and SERVER because the changes are not networked
Player:WLSetJobWhitelist( jobId, bool, by )

--  > : Return the whitelist information of a job, 'false' if the player is not whitelisted and a table if it is 
--  > #jobId (number): the index of the job
Player:WLGetJobWhitelist( jobId )

--  > : Return all the whitelisted jobs of the player (table)
Player:WLGetWhitelists()

--  > : Return if the player is admin (defined by the 'sh_config.lua')
Player:WLIsAdmin()

--  > : Return if the player is VIP (defined by the 'sh_config.lua')
Player:WLIsVIP()
```

#### Others functions :
```lua
--  > : Set the whitelist of a specified job
--  > #jobId (number): the index of the job
--  > #bool (boolean): 'true' to add the whitelist and 'false' to remove it
--  > #vip (optional) (boolean): 'true' to add the whitelist to VIP only and 'false' to remove it
--  > NOTE: Set the whitelist on CLIENT and SERVER because the changes are not networked
guthwhitelistsystem:WLSetJobWhitelist( jobId, bool, vip )

--  > : Return the whitelist information of a job, a table is returned
--  > #jobId (number): the index of the job
guthwhitelistsystem:WLGetJobWhitelist( jobId )
```

## How can I contact you ?

Join my Discord : https://discord.gg/FZ9WVVe
