//	https://github.com/darnias/Vscripts/blob/master/scripts/get_held_weapon.nut
/*
	About: Returns the currently held weapon of a player as a classname string

	Manual: RunscriptCode GetHeldWeapon(player)
		Where 'player' is a handle of targeted player. Such as FindByName(null, "Bob")
*/

function GetHeldWeapon(handle = null){
	if (handle == null || typeof handle != "instance")return null; // Check for correct inputs
	local vm = null;
	while (vm = Entities.FindByClassname(vm, "predicted_viewmodel")){
		if (vm.GetMoveParent() == handle){
			return ModelToClassname(vm.GetModelName());
		}
	}
	return null
}

function ModelToClassname(weapon = null){
	if (weapon == null || typeof weapon != "string")		return null; // Check for correct inputs
	if (weapon.find("models/weapons/v_knife") == 0)			return "weapon_knife";  
	switch (weapon){
		case "models/weapons/v_axe.mdl":					return "weapon_axe";
		case "models/weapons/v_breachcharge.mdl":			return "weapon_breachcharge";
		case "models/weapons/v_bumpmine.mdl":				return "weapon_bumpmine";
		case "models/weapons/v_eq_decoy.mdl":				return "weapon_decoy";
		case "models/weapons/v_eq_flashbang.mdl":			return "weapon_flashbang";
		case "models/weapons/v_eq_fraggrenade.mdl":			return "weapon_hegrenade";
		case "models/weapons/v_eq_incendiarygrenade.mdl":	return "weapon_incgrenade";
		case "models/weapons/v_eq_molotov.mdl":				return "weapon_molotov";
		case "models/weapons/v_eq_smokegrenade.mdl":		return "weapon_smokegrenade";
		case "models/weapons/v_eq_snowball.mdl":			return "weapon_snowball";
		case "models/weapons/v_eq_taser.mdl":				return "weapon_taser";
		case "models/weapons/v_fists.mdl":					return "weapon_fists";
		case "models/weapons/v_hammer.mdl":					return "weapon_hammer";
		case "models/weapons/v_healthshot.mdl":				return "weapon_healthshot";
		case "models/weapons/v_ied.mdl":					return "weapon_c4";
		case "models/weapons/v_mach_m249para.mdl":			return "weapon_m249";
		case "models/weapons/v_mach_negev.mdl":				return "weapon_negev";
		case "models/weapons/v_pist_223.mdl":				return "weapon_usp_silencer";
		case "models/weapons/v_pist_cz_75.mdl":				return "weapon_cz75a";
		case "models/weapons/v_pist_deagle.mdl":			return "weapon_deagle";
		case "models/weapons/v_pist_elite.mdl":				return "weapon_elite";
		case "models/weapons/v_pist_fiveseven.mdl":			return "weapon_fiveseven";
		case "models/weapons/v_pist_glock18.mdl":			return "weapon_glock";
		case "models/weapons/v_pist_hkp2000.mdl":			return "weapon_hkp2000";
		case "models/weapons/v_pist_p250.mdl":				return "weapon_p250";
		case "models/weapons/v_pist_revolver.mdl":			return "weapon_revolver";
		case "models/weapons/v_pist_tec9.mdl":				return "weapon_tec9";
		case "models/weapons/v_repulsor.mdl":				return "weapon_zone_repulsor";
		case "models/weapons/v_rif_ak47.mdl":				return "weapon_ak47";
		case "models/weapons/v_rif_aug.mdl":				return "weapon_aug";
		case "models/weapons/v_rif_famas.mdl":				return "weapon_famas";
		case "models/weapons/v_rif_galilar.mdl":			return "weapon_galilar";
		case "models/weapons/v_rif_m4a1.mdl":				return "weapon_m4a1";
		case "models/weapons/v_rif_m4a1_s.mdl":				return "weapon_m4a1_silencer";
		case "models/weapons/v_rif_sg556.mdl":				return "weapon_sg556";
		case "models/weapons/v_shield.mdl":					return "weapon_shield";
		case "models/weapons/v_shot_mag7.mdl":				return "weapon_mag7";
		case "models/weapons/v_shot_nova.mdl":				return "weapon_nova";
		case "models/weapons/v_shot_sawedoff.mdl":			return "weapon_sawedoff";
		case "models/weapons/v_shot_xm1014.mdl":			return "weapon_xm1014";
		case "models/weapons/v_smg_bizon.mdl":				return "weapon_bizon";
		case "models/weapons/v_smg_mac10.mdl":				return "weapon_mac10";
		case "models/weapons/v_smg_mp5sd.mdl":				return "weapon_mp5sd";
		case "models/weapons/v_smg_mp7.mdl":				return "weapon_mp7";
		case "models/weapons/v_smg_mp9.mdl":				return "weapon_mp9";
		case "models/weapons/v_smg_p90.mdl":				return "weapon_p90";
		case "models/weapons/v_smg_ump45.mdl":				return "weapon_ump45";
		case "models/weapons/v_snip_awp.mdl":				return "weapon_awp";
		case "models/weapons/v_snip_g3sg1.mdl":				return "weapon_g3sg1";
		case "models/weapons/v_snip_scar20.mdl":			return "weapon_scar20";
		case "models/weapons/v_snip_ssg08.mdl":				return "weapon_ssg08";
		case "models/weapons/v_sonar_bomb.mdl":				return "weapon_tagrenade";
		case "models/weapons/v_spanner.mdl":				return "weapon_spanner";
		case "models/weapons/v_tablet.mdl":					return "weapon_tablet";
		default: return "Weapon Unknown"
	}
}