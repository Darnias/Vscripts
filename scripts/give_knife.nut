//	https://github.com/darnias/Vscripts/blob/master/scripts/give_knife.nut
/*
    Purpose:
    Gives activator a knife that you normally can't pick up
    Removes players current knife if he has one

    Manual:
    Run a function 'GiveKnife(knives.<KNIFE NAME HERE>)'

    Examples of the script on a func_button
        OnPressed > !self > RunScriptCode > GiveKnife(knives.karambit)
        OnDamaged > !self > RunScriptCode > GiveKnife(knives.survival)
        OnUseLocked > !self > RunScriptCode > GiveKnife(knives.css)
*/

enum knives{
	knife = "weapon_knife", // Default Knife
	gut = "weapon_knife_gut", // Gut Knife
	bowie = "weapon_knife_survival_bowie", // Bowie Knife
	flip = "weapon_knife_flip", // Flip Knife
	daggers = "weapon_knife_push", // Shadow Daggers
	huntsman = "weapon_knife_tactical", // Huntsman Knife
	butterfly = "weapon_knife_butterfly", // Butterfly Knife
	m9_bayonet = "weapon_knife_m9_bayonet", // M9 Bayonet
	bayonet = "weapon_bayonet", // Bayonet
	karambit = "weapon_knife_karambit", // Karambit
	skeleton = "weapon_knife_skeleton", // Skeleton Knife
	survival = "weapon_knife_canis", // Survival Knife
	paracord = "weapon_knife_cord", // Paracord Knife
	nomad = "weapon_knife_outdoor", // Nomad Knife
	ursus = "weapon_knife_ursus", // Ursus Knife
	talon = "weapon_knife_widowmaker", // Talon Knife
	css = "weapon_knife_css", // CS:S Knife
	navaja = "weapon_knife_gypsy_jackknife", // Navaja Knife
	stiletto = "weapon_knife_stiletto", // Stiletto Knife
	falchion = "weapon_knife_falchion", // Falchion Knife
}

function GiveKnife(knife_name){
	if (activator == null)return;
	local p_knife = null;
	while (p_knife = Entities.FindByClassname(p_knife, "weapon_knife*")){
		if (p_knife.GetOwner() == activator && p_knife.GetMoveParent() == activator){
			p_knife.Destroy();
			knife_equip <- Entities.CreateByClassname("game_player_equip");
			knife_equip.__KeyValueFromInt(knife_name, 1);
			EntFireByHandle(knife_equip, "Use", "", 0, activator, activator);
			knife_equip.Destroy();
			EntFire("weapon_knife", "AddOutput", "classname weapon_knifegg", FrameTime(), null);
			return
		}
    }
	knife_equip <- Entities.CreateByClassname("game_player_equip");
	knife_equip.__KeyValueFromInt(knife_name, 1);
	EntFireByHandle(knife_equip, "Use", "", 0, activator, activator);
	knife_equip.Destroy();
	EntFire("weapon_knife", "AddOutput", "classname weapon_knifegg", FrameTime(), null);
}