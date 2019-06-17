guthwhitelistsystem.languages = guthwhitelistsystem.languages or {}

local l = "fr"
guthwhitelistsystem.languages[l] = {}
local function setLan( id, txt )
    guthwhitelistsystem.languages[l][id] = txt
end

--  > language configuration <  --

setLan( "NotifNotVIP", "Vous n'avez pas accès aux métiers VIP !" )
setLan( "NotifNotWhitelist", "Vous n'êtes pas dans la liste blanche !" )

setLan( "Players", "Joueurs" )
setLan( "SteamID", "SteamID" )
setLan( "Jobs", "Métiers" )
setLan( "Date", "Date" )
setLan( "Time", "Temps" )
setLan( "By", "Par" )
setLan( "Any", "Aucun" )
setLan( "Whitelist ?", "Whitelist ?" )
setLan( "VIP ?", "VIP ?" )
setLan( "Yes !", "Oui !" )
setLan( "No !", "Non !" )

setLan( "Copy Name", "Copier le Nom" )
setLan( "CopyName", "Vous avez copié le nom de %s !" )
setLan( "Copy SteamID", "Copier le SteamID" )
setLan( "CopySteamID", "Vous avez copié le SteamID de %s !" )
setLan( "Copy NameSteamID", "Copier le Nom et le SteamID" )
setLan( "CopyNameSteamID", "Vous avez copié le nom et le SteamID de %s !" )
setLan( "RemoveWhitelist", "Enlever de la liste blanche" )
setLan( "ActivateWhitelist", "Activer la liste blanche" )
setLan( "DesactivateWhitelist", "Désactiver la liste blanche" )
setLan( "DesactivateVIP", "Désactiver le VIP" )

setLan( "ChatRemoveWhitelist", "Vous avez enlevé la whitelist de %s à %s (%s) !" )
setLan( "ChatAddWhitelist", "Vous avez ajouté la whitelist de %s à %s (%s) !" )
setLan( "ChatActivateWhitelist", "Vous avez activé la liste blanche à %s !" )
setLan( "ChatDesactivateWhitelist", "Vous avez désactivé la liste blanche à %s !" )
setLan( "ChatActivateVIP", "Vous avez activé le VIP à %s !" )
setLan( "ChatDesactivateVIP", "Vous avez désactivé le VIP à %s !" )
setLan( "ChatNotAdmin", "Vous n'avez pas assez de privilèges !" )
setLan( "ChatOpen", "PANEL ouvert !" )
setLan( "ChatClose", "PANEL fermé !" )

setLan( "PanelNotAdmin", "Vous n'êtes pas un administrateur !" )
setLan( "PanelUnwhitelisted", "%s a été enlevé de la liste blanche du métier : %s !" )
setLan( "PanelUnwhitelistJob", "Vous avez enlevé de la liste blanche le métier : %s !" )
setLan( "PanelUnwhitelistJobVIP", "Vous avez enlevé le métier %s du VIP !" )
setLan( "PanelWhitelisted", "%s a été ajouté à la liste blanche du métier : %s !" )
setLan( "PanelWhitelistJob", "Vous avez ajouté à la liste blanche le métier : %s !" )
setLan( "PanelWhitelistJobVIP", "Vous avez ajouté le métier %s au VIP !" )
setLan( "PanelUncorrectJob", "Vous devez choisir un métier valide !" )
setLan( "PanelNotWhitelisted", "Ce métier n'est pas ajouté à la liste blanche !" )
setLan( "PanelAlreadyWhitelist", "%s a déjà été ajouté à la liste blanche du métier %s !" )
setLan( "PanelRefreshJob", "Vous avez rafraichi la liste des métiers de la liste blanche !" )
setLan( "PanelDarkRP", "Ce PANEL peut seulement fonctionner dans le gamemode DarkRP !" )
setLan( "PanelWelcome", "Bienvenue sur le PANEL du système de whitelist de Guthen !" )
