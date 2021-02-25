// https://github.com/darnias2/vscripts/blob/master/manage_teams.nut

// Purpose:
// Changes the teams of bots or players while remembering their previous team
// Useful for training maps where you want to change bot amount
// Does not add or remove any bots from server, just moves from CT/T to spec and vice versa
// NOTE: Only real purpose is for training maps, may not work for other uses.

// Manual:
// IMPORTANT! Add Think_Assign as think function to your entity holding this script
// Use AddT(int) to move Tspec bots from spec to T
// Use RemoveT(int) to move T bots to spec
//
// Use AddCT(int) to move CTspec bots from spec to CT
// Use RemoveCT(int) to move CT bots to spec

if (!("CURR_T" in getroottable())){ //Create locals only once
	::CURR_T <- 0; // Terrorists
	::SPEC_T <- 0; // Terrorists in spectate
	::CURR_CT <- 0; // Counter-Terrorists
	::SPEC_CT <- 0; // Counter-Terrorists in spectate
}

IGNORE_PLAYERS <- true; // Should Remove() ignore real players?

function AddT(amount){ // Moves amount of Spec Terrorists to Terrorists Team
	if (typeof amount != "integer" || amount <= 0)return; // Invalid input
	local player = null;
	while ((player = Entities.FindByClassname(player, "*")) && amount != 0){
		if (player.ValidateScriptScope() && player.GetClassname() == "player"){
			if ("PREVIOUS_TEAM" in player.GetScriptScope()){
				if (player.GetScriptScope().PREVIOUS_TEAM == 2){
					amount -= 1;
					player.SetTeam(2);
					CURR_T++;
					SPEC_T--;
				}
			}
		}
	}
	return
}

function RemoveT(amount){ // Moves amount of Terrorists to Spectate
	if (typeof amount != "integer" || amount <= 0)return; // Invalid input
	local player = null;
	while ((player = Entities.FindByClassname(player, "*")) && amount != 0){
		if (player.GetTeam() == 2 && player.GetClassname() == "player"){
			if (IGNORE_PLAYERS == true && player.GetScriptScope().BOT == false){
				continue;
			}
			else{
				amount -= 1;
				EntFireByHandle(player, "RunScriptCode", "PREVIOUS_TEAM<-2", 0, null, null);
				player.SetTeam(1);
				CURR_T--;
				SPEC_T++;
			}
		}
	}
	return
}

function AddCT(amount){ // Moves amount of Spec Terrorists to Terrorists Team
	if (typeof amount != "integer" || amount <= 0)return; // Invalid input
	local player = null;
	while ((player = Entities.FindByClassname(player, "*")) && amount != 0){
		if (player.ValidateScriptScope() && player.GetClassname() == "player"){
			if ("PREVIOUS_TEAM" in player.GetScriptScope()){
				if (player.GetScriptScope().PREVIOUS_TEAM == 3){
					amount -= 1;
					player.SetTeam(3);
					CURR_CT++;
					SPEC_CT--;					
				}
			}
		}
	}
	return
}

function RemoveCT(amount){ // Moves amount of Counter-Terrorists to Spectate
	if (typeof amount != "integer" || amount <= 0)return; // Invalid input
	local player = null;
	while ((player = Entities.FindByClassname(player, "*")) && amount != 0){
		if (player.GetTeam() == 3 && player.GetClassname() == "player"){
			if (IGNORE_PLAYERS == true && player.GetScriptScope().BOT == false){
				continue;
			}
			else{
				amount -= 1;
				EntFireByHandle(player, "RunScriptCode", "PREVIOUS_TEAM<-3", 0, null, null);
				player.SetTeam(1);
				CURR_CT--;
				SPEC_CT++;
			}
		}
	}
	return
}


function DebugPrintTotalCount(){ // Debug print to see the where bots currently are
	CountCT();
	CountSpecCT();
	CountT();
	CountSpecT();	
	printl(" ");
	printl("CURR_T: "+CURR_T);
	printl("SPEC_T: "+SPEC_T);
	printl("CURR_CT: "+CURR_CT);
	printl("SPEC_CT: "+SPEC_CT);
	printl(" ");			
}

//Purpose: Keep track of players on each team and spectate
function OnPostSpawn(){
	CountCT();
	CountSpecCT();
	CountT();
	CountSpecT();
}

function Think_Assign(){ // Differentiates bots from players
	EntFire("cs_bot", "RunScriptCode", "BOT<-true", 0, null);
	EntFire("player", "RunScriptCode", "BOT<-false", 0, null);	
}

function CountCT(){ // Returns amount of Counter-Terrorists
	CURR_CT = 0;
	local player = null;
	while (player = Entities.FindByClassname(player, "*")){
		if (player.GetTeam() == 3 && player.GetClassname() == "player"){
			EntFireByHandle(player, "RunScriptCode", "PREVIOUS_TEAM<-3", 0, null, null);
			CURR_CT++;			
		}
	}
	return CURR_CT;
}

function CountSpecCT(){ // Returns amount of Spectate Counter-Terrorists
	SPEC_CT = 0;
	local player = null;
	while (player = Entities.FindByClassname(player, "*")){
		if (player.GetTeam() == 1 && player.GetClassname() == "player"){
			if ("PREVIOUS_TEAM" in player.GetScriptScope()){
				if (player.GetScriptScope().PREVIOUS_TEAM == 3){
					SPEC_CT++;					
				}
			}			
		}
	}
	return SPEC_CT;
}

function CountT(){ // Returns amount of Terrorists
	CURR_T = 0;
	local player = null;
	while (player = Entities.FindByClassname(player, "*")){
		if (player.GetTeam() == 2 && player.GetClassname() == "player"){
			EntFireByHandle(player, "RunScriptCode", "PREVIOUS_TEAM<-2", 0, null, null);
			CURR_T++;			
		}
	}
	return CURR_T;
}

function CountSpecT(){ // Returns amount of Spec Terrorists
	SPEC_T = 0;
	local player = null;
	while (player = Entities.FindByClassname(player, "*")){
		if (player.GetTeam() == 1 && player.GetClassname() == "player"){
			if ("PREVIOUS_TEAM" in player.GetScriptScope()){
				if (player.GetScriptScope().PREVIOUS_TEAM == 2){
					SPEC_T++;				
				}
			}			
		}
	}
	return SPEC_T;
}