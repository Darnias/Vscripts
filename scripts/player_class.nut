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
}

function DumpPlayers(){
	foreach (player in Players){
		player.DumpValues()
	}
}

function OnPostSpawn(){
if (!("Players" in getroottable())){ // Create Table Players only once
	::Players <- {};
	}
if (!("event_proxy" in getroottable()) || !(::event_proxy.IsValid())){
	::event_proxy <- Entities.CreateByClassname("info_game_event_proxy");
	::event_proxy.__KeyValueFromString("event_name", "player_info");	
	}
}

::GetEntityByIndex <- function(entindex){
	local ent = null;
	while (ent = Entities.FindByClassname(ent, "*")){
		if (ent.entindex() == entindex){
		return ent
		}
	}
	return null
}

::PlayerConnect <- function(event){
	if (event.networkid != "BOT"){ // Debugging via bot_add for now, so bots shouldn't get information via connect
		printl("[PlayerConnect] - CONNECT INDEX: " + event.index);
		Players[event.userid] <- Player(event.name, event.index + 1, event.userid, event.networkid, null);
	}
}

::PlayerDisconnect <- function(event){
	try{
		delete Players[event.userid];
	}
	catch(error){
		printl("[PlayerDisconnect] - Couldn't delete " + error);
	}
}

::PlayerSpawn <- function(){
	foreach (player in Players){
		if (player.handle == null){
			player.handle = GetEntityByIndex(player.index);
		}
	}
}

::PlayerInfo <- function(event){
	printl("[PlayerInfo] - Trying to add UserID: " + event.userid + " to Players");
	if (Players.len() == 0){
		Players[event.userid] <- Player(null, CI, event.userid, null, null);
		printl("[PlayerInfo] - UserID: " + event.userid + " (index: " + CI + ") added to Players");	
		CAPTURED_PLAYER <- null;				
	}
	else{
		foreach (player in Players){
			if (event.userid in Players){
				printl("[PlayerInfo] - UserID: " + event.userid + " is already in Players");
				return;
			}
			else{				
				Players[event.userid] <- Player(null, CI, event.userid, null, null);
				printl("[PlayerInfo] - UserID: " + event.userid + " (index: " + CI + ") added to Players");
				CAPTURED_PLAYER <- null;
				return;
			}
		}
	}
}


function AssignUserID(){ // This a Think function
	local p = null;
	while (p = Entities.FindByClassname(p, "*")){
		if (p.GetClassname() == "player" || p.GetClassname() == "cs_bot"){
			if (p.ValidateScriptScope()){
				local script_scope = p.GetScriptScope();
				if (!("GeneratedUserID" in script_scope)){
					printl("[AssignUserID] - Generated UserID for " + p);
					::CI <- p.entindex();
					script_scope.GeneratedUserID<-true;
					EntFireByHandle(event_proxy, "GenerateGameEvent", "", 0, p, null);
					break
				}
			}
		}
	}
}

::GetPlayerByUserID <- function(userid){
	foreach (player in Players){
		if (player.userid == userid){
			return player.handle
		}
		else{
			return null
		}
	}
}
