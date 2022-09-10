
local Player = FindMetaTable( "Player" )

--  > Make some meta

function Player:WLSendData()
    if not self:IsValid() then return end

    net.Start( "guthwhitelistsystem:SendData" )
        net.WriteTable( guthwhitelistsystem.wl )
        net.WriteTable( guthwhitelistsystem.wlJob )
    net.Send( self )
end

net.Receive( "guthwhitelistsystem:SendData", function( len, ply )
    if not ply:WLIsAdmin() then return end

    ply:WLSendData()
end )

--  > --------------- <  --

local path = "guthwhitelistsystem"
local wlFile = "/whitelist.txt"
local jobFile = "/job.txt"

--  > Make some functions

function guthwhitelistsystem:WLSave()
    if not file.Exists( path, "DATA" ) then
        file.CreateDir( path )
    end

    file.Write( path .. wlFile, util.TableToJSON( self.wl or {} ) )
    file.Write( path .. jobFile, util.TableToJSON( self.wlJob or {} ) )

    self.print( "Whitelist and Job saved !" )
end

function guthwhitelistsystem:WLLoad()
    if not file.Exists( path, "DATA" ) then
        return self.print( "Can't load data because directory doesn't exists." )
    end

    if not file.Exists( path .. wlFile, "DATA" ) then
        return self.print( "Can't load data because whitelist file doesn't exists." )
    else
        self.wl = util.JSONToTable( file.Read( path .. wlFile ) )
    end

    if not file.Exists( path .. jobFile, "DATA" ) then
        return self.print( "Can't load data because job file doesn't exists." )
    else
        self.wlJob = util.JSONToTable( file.Read( path .. jobFile ) )
    end

    self.print( "Whitelist and Job loaded !" )
end
