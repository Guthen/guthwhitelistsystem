
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
