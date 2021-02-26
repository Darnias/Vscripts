/*
https://github.com/darnias2/Vscripts/blob/master/scripts/player_class.nut

Function:
	Stores player information in table "Players" using the class "Player"
	SteamID and Name is only collected if player joins during the map not with map change
	You can retrieve this information by looping through "Players" or using functions like GetPlayerByUserID() which returns the players handle
	Player information is stored only once per player, AssignUserID is looping think function to account of late joiners

Required entities:

logic_eventlistener:
	Entity Scripts: player_class.nut
	Script think function: AssignUserID
	Event Name: player_connect
	Fetch Event Data: Yes
		OnEventFired > !self > RunScriptCode > PlayerConnect(event_data)

logic_eventlistener:
	Event Name: player_disconnect
	Fetch Event Data: Yes
		OnEventFired > !self > RunScriptCode > PlayerDisconnect(event_data)	

logic_eventlistener:
	Event Name: player_info
	Fetch Event Data: Yes
		OnEventFired > !self > RunScriptCode > PlayerInfo(event_data)	
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
	function SetIndex(entindex){
		return this.index = entindex
	}
	function SetHandle(handle){
		return this.handle = handle
	}	
}

::DEBUG <- false;
::DebugPrint<-function(text){ // Print misc debug text
	if (!DEBUG)return;
	printl(text);
}

function DumpPlayers(){ // Dumps all players that are in Players table
	foreach (player in Players){
		player.DumpValues()
	}
}

function OnPostSpawn(){ // Called each time entity spawns (new round)
if (!("Players" in getroottable())){ // Create Table Players only once
	::Players <- {};
	}
if (!("event_proxy" in getroottable()) || !(::event_proxy.IsValid())){ // Create event proxy
	::event_proxy <- Entities.CreateByClassname("info_game_event_proxy");
	::event_proxy.__KeyValueFromString("event_name", "player_info");	
	}
}

::GetEntityByIndex <- function(entindex){ // Return entity handle by entindex
	local ent = null;
	while (ent = Entities.FindByClassname(ent, "*")){
		if (ent.entindex() == entindex){
		return ent
		}
	}
	return null
}

::PlayerConnect <- function(event){
	Players[event.userid] <- Player(event.name, null, event.userid, event.networkid, null); // entindex is null for now, event returns a 0
}

::PlayerDisconnect <- function(event){
	try{
		delete Players[event.userid];
	}
	catch(error){
		DebugPrint("[PlayerDisconnect] - Couldn't delete " + error);
	}
}


::PlayerInfo <- function(event){
	DebugPrint("[PlayerInfo] - Trying to add UserID: " + event.userid + " to Players");
	if (Players.len() == 0){ // Players is empty so we can't even loop through it, force add first one
		Players[event.userid] <- Player(null, generated_player.entindex(), event.userid, null, generated_player);
		DebugPrint("[PlayerInfo] - UserID: " + event.userid + " (index: " + generated_player.entindex() + ") added to Players");	
		CAPTURED_PLAYER <- null;				
	}
	else{
		foreach (player in Players){
			if (!(event.userid in Players)){ // Player doesn't exist in the table	
				Players[event.userid] <- Player(null, generated_player.entindex(), event.userid, null, generated_player);
				DebugPrint("[PlayerInfo] - UserID: " + event.userid + " (index: " + generated_player.entindex() + ") added to Players");
				CAPTURED_PLAYER <- null;
				return
			}
			else if (event.userid in Players && Players[event.userid].index == null){ // Player added through PlayerConnect, we need to add entindex and handle only
				Players[event.userid].SetIndex(generated_player.entindex());
				Players[event.userid].SetHandle(generated_player);
				DebugPrint("[PlayerInfo] - UserID already in table, setting index to: " + generated_player.entindex());
				DebugPrint("[PlayerInfo] - UserID already in table, setting handle to: " + generated_player);
				return
			}
			else if (event.userid in Players && Players[event.userid].index != null){ // Player exists in table and his entindex is set
				DebugPrint("[PlayerInfo] - UserID: " + event.userid + " is already in Players");
				return				
			}			
		}
	}
}


function AssignUserID(){ // Looping Think function, assigns 1 player per loop
	local p = null;
	while (p = Entities.FindByClassname(p, "*")){
		if (p.GetClassname() == "player" || p.GetClassname() == "cs_bot"){
			if (p.ValidateScriptScope()){
				local script_scope = p.GetScriptScope();
				if (!("GeneratedUserID" in script_scope)){
					DebugPrint("[AssignUserID] - Generated UserID for " + p);
					::generated_player <- p;
					script_scope.GeneratedUserID<-true;
					EntFireByHandle(event_proxy, "GenerateGameEvent", "", 0, p, null);
					break
				}
			}
		}
	}
}

::GetPlayerByUserID <- function(userid){ // Returns players handle if the userid matches his userid
	foreach (player in Players){
		if (player.userid == userid){
			return player.handle
		}
	}
}

::GetPlayerByIndex <- function(entindex){ // Returns players handle if the entindex matches his index
	foreach (player in Players){
		if (player.index == entindex){
			return player.handle
		}
	}
}