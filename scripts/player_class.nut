/*
	https://github.com/darnias/Vscripts/blob/master/scripts/player_class.nut

	About:
		Stores player information in table "Players" using the class "Player"
			*SteamID and Name is only collected if player joins during the map not with map change
		Stores Player class values inside players own Script Scope
		You can get players information by accessing their script scope eg. "activator.GetScriptScope().userid" will return activators UserID
		You can also find players by UserID using GetPlayerByUserID() eg. "GetPlayerByUserID(50)" if player with UserID 50 exists it will return his handle

	Required entities:
		logic_eventlistener:
			Targetname: listen_join
			Entity Scripts: player_class.nut
			Script think function: GenerateUserID
			Event Name: player_connect
			Fetch Event Data: Yes
				OnEventFired > listen_join > RunScriptCode > PlayerConnect(event_data)

		logic_eventlistener:
			Targetname: listen_disconnect
			Event Name: player_disconnect
			Fetch Event Data: Yes
				OnEventFired > listen_disconnect > RunScriptCode > PlayerDisconnect(event_data)	

		logic_eventlistener:
			Targetname: listen_info
			Event Name: player_info
			Fetch Event Data: Yes
				OnEventFired > listen_info > RunScriptCode > PlayerInfo(event_data)	
*/

::Player <- class{
	name = null;
	index = null;
	userid = null;
	steamid = null;
	handle = null;
	constructor(i_name, i_entindex, i_userid, i_networkid, i_handle){
		name = i_name;
		index = i_entindex;
		userid = i_userid;
		steamid = i_networkid;
		handle = i_handle;
	}
	function DumpValues(){
		printl("------------");
		printl("Name: " + this.name);
		printl("Entindex: " + this.index);
		printl("UserID: " + this.userid);
		printl("SteamID: " + this.steamid);
		printl("Handle: " + this.handle);
		printl(" ");		
	}
	function setName(name){
		return this.name = name
	}
	function setIndex(entindex){
		return this.index = entindex
	}
	function setUserID(userid){
		return this.userid = userid
	}
	function setSteamID(steamid){
		return this.steamid = steamid
	}	
	function setHandle(handle){
		return this.handle = handle
	}
}

// ========================= Init & Debug =========================

function OnPostSpawn(){ // Called each time entity spawns (new round)
if (!("Players" in getroottable())){ // Create Table Players only once
	::Players <- {};
	}
if (!("event_proxy" in getroottable()) || !(::event_proxy.IsValid())){ // Create event proxy
	::event_proxy <- Entities.CreateByClassname("info_game_event_proxy");
	::event_proxy.__KeyValueFromString("event_name", "player_info");	
	}
}

::DEBUG <- false;
::DebugPrint <- function(text){ // Print misc debug text
	if (!DEBUG)return
	printl(text);
}

function DumpPlayers(){ // Dumps all players that are in Players table
	foreach (player in Players){
		player.DumpValues()
	}
}

// ========================= Event Functions =========================

::PlayerConnect <- function(event){
	Players[event.userid] <- Player(event.name, null, event.userid, event.networkid, null); // entindex is null for now, event returns a 0
}

::PlayerDisconnect <- function(event){
	try{
		DebugPrint("[PlayerDisconnect] - Deleted table entry " + Players[event.userid]);
		delete Players[event.userid];
	}
	catch(error){
		DebugPrint("[PlayerDisconnect] - Couldn't delete because " + error);
	}
}

// ========================= Find Functions =========================

::GetPlayerByUserID <- function(userid){ // Returns players handle if the userid matches
	foreach (player in Players){
		if (player.userid == userid){
			return player.handle
		}
	}
}

::GetPlayerByIndex <- function(entindex){ // Returns players handle if the entindex matches
	foreach (player in Players){
		if (player.index == entindex){
			return player.handle
		}
	}
}

::GetPlayerBySteamID <- function(steamid){ // Returns players handle if the steamid matches
	foreach (player in Players){
		if (player.steamid == steamid){
			return player.handle
		}
	}
}

// ========================= Data Collection and Distribution =========================

::PlayerInfo <- function(event){ // Assigns class values to players script scope
	local generated_scope = generated_player.GetScriptScope();
	DebugPrint("[PlayerInfo] - Trying to add UserID " + event.userid + " to Players");
	if (!(event.userid in Players)){ // Player doesn't exist in the table	
		Players[event.userid] <- Player(null, generated_player.entindex(), event.userid, null, generated_player);
		generated_scope.name <- null;
		generated_scope.index <- Players[event.userid].index;
		generated_scope.userid <- Players[event.userid].userid;
		generated_scope.steamid <- null;
		generated_scope.handle <- Players[event.userid].handle;
		DebugPrint("[PlayerInfo] - UserID " + event.userid + " (index " + generated_player.entindex() + ") added to Players");
	}
	else if (event.userid in Players && Players[event.userid].index == null){ // Player added through PlayerConnect, but we still need to add Index and Handle
		Players[event.userid].setIndex(generated_player.entindex());
		Players[event.userid].setHandle(generated_player);
		generated_scope.name <- Players[event.userid].name;
		generated_scope.index <- Players[event.userid].index;
		generated_scope.userid <- Players[event.userid].userid;
		generated_scope.steamid <- Players[event.userid].steamid;
		generated_scope.handle <- Players[event.userid].handle;
		DebugPrint("[PlayerInfo] - UserID " + event.userid + " already in table, setting index to " + generated_player.entindex() + " and handle to " + generated_player);
	}
	else if (event.userid in Players && Players[event.userid].index != null){ // Player exists in table and his entindex is set
		DebugPrint("[PlayerInfo] - UserID " + event.userid + " is already in Players");
	}	
}

function GenerateUserID(){ // Looping Think function, assigns 1 player per loop
	local p = null;
	while (p = Entities.FindByClassname(p, "*")){
		if (p.GetClassname() == "player" || p.GetClassname() == "cs_bot"){
			if (p.ValidateScriptScope()){
				local script_scope = p.GetScriptScope();
				if (!("GeneratedUserID" in script_scope)){
					::generated_player <- p;
					script_scope.GeneratedUserID <- true;
					EntFireByHandle(event_proxy, "GenerateGameEvent", "", 0, p, null);
					DebugPrint("[GenerateUserID] - Generated UserID for " + p);
					break
				}
			}
		}
	}
}