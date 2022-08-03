// List of Includes
#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cstrike>
#include <smlib>

// The code formatting rules we wish to follow
#pragma semicolon 1;
// #pragma newdecls required;


#define EF_BONEMERGE		(1 << 0)
#define EF_NOSHADOW			(1 << 4)
#define EF_NORECEIVESHADOW	(1 << 6)
#define EF_PARENT_ANIMATES	(1 << 9)


// The retrievable information about the plugin itself 
public Plugin myinfo =
{
	name		= "[CS:GO] Manifest' Command Library",
	author		= "Manifest @Road To Glory",
	description	= "Provides the server with additional server commands.",
	version		= "V. 1.0.0 [Beta]",
	url			= ""
};




/* - Improvements
- Configure the damage dealing reduction or players who are in noclip mode

- Configuration to not pull weapons (C4) in to the black holes
- Configuration to not pull anything aside from players in to the black holes
*/ 



// Global Booleans (Checks)
bool PlayerHasBanish[MAXPLAYERS + 1] = {false,...};
bool PlayerHasBlur[MAXPLAYERS + 1] = {false,...};
bool PlayerHasDoubleJump[MAXPLAYERS + 1] = {false,...};
bool PlayerHasDrug[MAXPLAYERS + 1] = {false,...};
bool PlayerHasDrunk[MAXPLAYERS + 1] = {false,...};
bool PlayerHasHealingGun[MAXPLAYERS + 1] = {false,...};
bool PlayerHasNoClip[MAXPLAYERS + 1] = {false,...};
bool PlayerHasNoScope[MAXPLAYERS + 1] = {false,...};
bool PlayerHasQuickDefuse[MAXPLAYERS + 1] = {false,...};
bool PlayerHasQuickExplode[MAXPLAYERS + 1] = {false,...};
bool PlayerHasQuickPlant[MAXPLAYERS + 1] = {false,...};
bool PlayerHasQuickScope[MAXPLAYERS + 1] = {false,...};
bool PlayerHasPlantBombAnywhere[MAXPLAYERS + 1] = {false,...};
bool PlayerHasRadarReveal[MAXPLAYERS + 1] = {false,...};
bool PlayerHasReversedMovement[MAXPLAYERS + 1] = { false, ... };
bool PlayerHasReincarnation[MAXPLAYERS + 1] = { false, ... };
bool PlayerHasThirdPerson[MAXPLAYERS + 1] = {false,...};

// Global Booleans (Functionality)
bool PlayerHasTeleportDeathImmunity[MAXPLAYERS + 1] = {false,...};
bool PlayerDoubleJumped[MAXPLAYERS + 1] = {false,...};
bool ReincarnationItemDefuser[MAXPLAYERS + 1] = {false,...};
bool ReincarnationItemKevlar[MAXPLAYERS + 1] = {false,...};
bool ReincarnationItemKevlarHelmet[MAXPLAYERS + 1] = {false,...};


// Global Integers (Checks)
int PlayerHasAbsorptionShield[MAXPLAYERS + 1] = {0, ...};
int PlayerHasCrouchInvisibility[MAXPLAYERS + 1] = {0, ...};
int PlayerHasFlicker[MAXPLAYERS + 1] = {0, ...};
int PlayerHasHealthDecay[MAXPLAYERS + 1] = {0, ...};
int PlayerHasFOV[MAXPLAYERS + 1] = {0, ...};
int PlayerHasPoisonSmokes[MAXPLAYERS + 1] = {0, ...};
int PlayerHasPropModel[MAXPLAYERS + 1] = {-1, ...};
int PlayerHasHealingGunMinHeal[MAXPLAYERS + 1] = {-1, ...};
int PlayerHasHealingGunMaxHeal[MAXPLAYERS + 1] = {-1, ...};
int PlayerHasHealingGunHealCap[MAXPLAYERS + 1] = {-1, ...};


// Global Integers (Functionality)
int LastButtonsPressed[MAXPLAYERS + 1] = {0, ...};
int EntityOwner[2049] = {-1, ...};
int BlackHoleEntity[2049] = {-1, ...};
int SmokeGrenadeEntity[2049] = {-1, ...};

// Global Integers (Material Files)
int SpriteSheet_Ring_BlackHole = 0;
int SpriteSheet_Core_BlackHole = 0;


// Global Floats (Checks)
float PlayerHasFallDamageReduction[MAXPLAYERS + 1] = {0.0};
float PlayerHasHeadshotImmunity[MAXPLAYERS + 1] = {0.0,...};
float PlayerHasBodyshotImmunity[MAXPLAYERS + 1] = {0.0,...};
float PlayerHasHealingGunDamageReduction[MAXPLAYERS + 1] = {0.0,...};

// Global Char (functionality)
char ReincarnationWeaponPrimary[MAXPLAYERS + 1][64];
char ReincarnationWeaponSecondary[MAXPLAYERS + 1][64];


// Global Handles (Functionality)
Handle Timer_ManageExplosiveBarrel;


public void OnPluginStart()
{
	//////////////////////////
	// - Commands : Setfx - //
	//////////////////////////

	// Setfx like commands
	RegServerCmd("wcs_caller_setfxabsorptionshield", Command_SetfxAbsorptionShield);
	RegServerCmd("wcs_caller_setfxbanish", Command_SetfxBanish);
	RegServerCmd("wcs_caller_setfxblur", Command_SetfxBlur);
	RegServerCmd("wcs_caller_setfxbodyshotimmunity", Command_SetfxBodyshotImmunity);
	RegServerCmd("wcs_caller_setfxcrouchinvisibility", Command_SetfxCrouchInvisibility);
	RegServerCmd("wcs_caller_setfxdrunk", Command_SetfxDrunk);
	RegServerCmd("wcs_caller_setfxdrug", Command_SetfxDrug);
	RegServerCmd("wcs_caller_setfxfalldamage", Command_SetfxFallDamage);
	RegServerCmd("wcs_caller_setfxflicker", Command_SetfxFlicker);
	RegServerCmd("wcs_caller_setfxfov", Command_SetfxFOV);
	RegServerCmd("wcs_caller_setfxdoublejump", Command_SetfxDoubleJump);
	RegServerCmd("wcs_caller_setfxheadshotimmunity", Command_SetfxHeadshotImmunity);
	RegServerCmd("wcs_caller_setfxhealthdecay", Command_SetfxHealthDecay);
	RegServerCmd("wcs_caller_setfxnoclip", Command_SetfxNoClip);
	RegServerCmd("wcs_caller_setfxnoscope", Command_SetfxNoScope);
	RegServerCmd("wcs_caller_setfxplantbombanywhere", Command_PlantBombAnywhere);
	RegServerCmd("wcs_caller_setfxparalyze", Command_SetfxParalyze);
	RegServerCmd("wcs_caller_setfxquickdefuse", Command_SetfxQuickDefuse);
	RegServerCmd("wcs_caller_setfxquickexplode", Command_SetfxQuickExplode);
	RegServerCmd("wcs_caller_setfxquickplant", Command_SetfxQuickPlant);
	RegServerCmd("wcs_caller_setfxquickscope", Command_SetfxQuickScope);
	RegServerCmd("wcs_caller_setfxradarreveal", Command_SetfxRadarReveal);
	RegServerCmd("wcs_caller_setfxreincarnation", Command_SetfxReincarnation);
	RegServerCmd("wcs_caller_setfxreversemovement", Command_SetfxReverseMovement);
	RegServerCmd("wcs_caller_setfxthirdperson", Command_SetfxThirdPerson);
	



	///////////////////////////
	// - Commands : Normal - //
	///////////////////////////

	// Existing but fixed or reworked commands
	RegServerCmd("wcs_caller_blackhole", Command_Blackhole);
	RegServerCmd("wcs_caller_setmodelplayer", Command_SetModelPlayer);
	RegServerCmd("wcs_caller_setmodelprop", Command_SetModelProp);
	RegServerCmd("wcs_caller_prop_dynamic_destructible", Command_PropDynamicDestructible);
	RegServerCmd("wcs_caller_prop_physics_destructible", Command_PropPhysicsDestructible);
	RegServerCmd("wcs_caller_prop_explosive_barrel", Command_ExplosiveBarrel);
	RegServerCmd("wcs_caller_poisonsmoke", Command_PoisonSmoke);
	RegServerCmd("wcs_caller_teleportpush", Command_TeleportPush);
	RegServerCmd("wcs_caller_healinggun", Command_HealingGun);
	RegServerCmd("wcs_caller_switchteam", Command_SwitchTeam);




	// Setfx
	// - Set Resist
	// - Quick Reload
	// - Quick weapon Switch
	// - Wallhack
	// - Rocket Jump
	// - Undying <userid> <duration>
	// - Grapple Hook
	// - Sticky Grenades
	// - Impact Explosion Grenades
	// - Est_Rocket
	// - CrouchInvisibilityFrozen
	
	// Commands
	// - Eye Laser
	// - Aim - Head / Body
	// - Throwing Knives
	// - Execute
	// - Telekinesis
	// - Portals

	// - ScoreboardAssist
	// - ScoreboardContribution
	// - ScoreboardDeath
	// - ScoreboardKill
	// - ScoreboardMVP

	// Particle Tools
	// - Particle On Player
	// - Particle At Location
	// - Point_Tesla
	// - Env_Smokestack
	// - Env_Steam
	// - LightGlow
	// - 




	// Hooks the events we plan on using
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
	HookEvent("round_start", Event_RoundStart, EventHookMode_Post);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_Post);
	HookEvent("bomb_planted", Event_BombPlanted, EventHookMode_Post);
	HookEvent("bomb_beginplant", Event_BombBeginPlant, EventHookMode_Post);
	HookEvent("bomb_begindefuse", Event_BombBeginDefuse, EventHookMode_Post);	
	HookEvent("smokegrenade_detonate", Event_SmokeGrenadeDetonate, EventHookMode_Post);
	HookEvent("weapon_zoom", Event_WeaponZoom, EventHookMode_Post);



	HookEvent("weapon_fire", Event_WeaponFire, EventHookMode_Pre);

	// Calls upon our function named DownloadAndPrecacheFiles
	DownloadAndPrecacheFiles();

	// Late Load Support
	for (int client = 1; client <= MaxClients; client++)
	{
		if(IsValidClient(client))
		{
			SDKHook(client, SDKHook_OnTakeDamage, Event_OnDamageTaken);
			SDKHook(client, SDKHook_PreThink, Event_OnPreThink);
			SDKHook(client, SDKHook_PostThink, Event_OnPostThink);
			ResetAllEffects(client);
		}
	}
}






// This section is executed everytime the player fires a weapon or left attacks with his knife
public Action Event_WeaponFire(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	CreateTimer(0.0, Timer_AutoMaticPistols, client, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Continue;
}



public Action Timer_AutoMaticPistols(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	int weaponEntity = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");

	if(!IsValidEntity(weaponEntity))
	{
		return Plugin_Continue;
	}

	char weaponClassName[32];

	GetEntityClassname(weaponEntity, weaponClassName, sizeof(weaponClassName));

	if(StrEqual(weaponClassName, "weapon_cz75a", false) || StrEqual(weaponClassName, "weapon_deagle", false) || StrEqual(weaponClassName, "weapon_elite", false) || StrEqual(weaponClassName, "weapon_fiveseven", false) || StrEqual(weaponClassName, "weapon_glock", false) || StrEqual(weaponClassName, "weapon_hkp2000", false) || StrEqual(weaponClassName, "weapon_p250", false) || StrEqual(weaponClassName, "weapon_revolver", false) || StrEqual(weaponClassName, "weapon_tec9", false) || StrEqual(weaponClassName, "weapon_usp_silencer", false))
	{
		SetEntPropFloat(client, Prop_Send, "m_flNextAttack", 0.0);

		SetEntProp(client, Prop_Send, "m_iShotsFired", 0);
	}

	return Plugin_Continue;
}




////////////////
// - Events - //
////////////////

public Action Event_WeaponZoom(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	if(!PlayerHasQuickScope[client])
	{
		return Plugin_Continue;
	}

	CreateTimer(0.25, Timer_QuickScopeUnzoom, client, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Continue;
}


public Action Event_BombBeginPlant(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	if(!PlayerHasQuickPlant[client])
	{
		return Plugin_Continue;
	}

	int c4 = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");

	char classname[32];

	GetEntityClassname(c4, classname, sizeof(classname));

	if(StrEqual(classname, "weapon_c4", false))
	{
		SetEntPropFloat(c4, Prop_Send, "m_fArmedTime", 1.0);
	}

	return Plugin_Continue;
}


public Action Event_BombPlanted(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	if(!PlayerHasQuickExplode[client])
	{
		return Plugin_Continue;
	}

	int entity = FindEntityByClassname(MaxClients + 1, "planted_c4");

	if(IsValidEntity(entity))
	{
		if(entity)
		{
			SetEntPropFloat(entity, Prop_Send, "m_flC4Blow", 1.0);
		}
	}

	return Plugin_Continue;
}


public Action Event_BombBeginDefuse(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	if(!PlayerHasQuickDefuse[client])
	{
		return Plugin_Continue;
	}

	CreateTimer(0.0, Timer_InstantDefuseBomb, client, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Continue;
}



public Action Timer_InstantDefuseBomb(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	int entity = FindEntityByClassname(MaxClients + 1, "planted_c4");

	if(IsValidEntity(entity))
	{
		if(entity)
		{
			SetEntPropFloat(entity, Prop_Send, "m_flDefuseCountDown", GetGameTime());
		}
	}

	return Plugin_Continue;
}



public Action Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	ExplosiveBarrelTimerManager();
}


public Action Event_RoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
	// Creates a float value equals to the value of mp_round_restart_delay
	float DelayTillNextRound = float(GetConVarInt(FindConVar("mp_round_restart_delay")));

	// Removes 0.25 seconds from the value of DelayTillNextRound
	DelayTillNextRound -= 0.25;

	// Call upon the function named Timer_CallUponReset just prior to the round ending
	CreateTimer(DelayTillNextRound, Timer_CallUponReset, TIMER_FLAG_NO_MAPCHANGE);
}


public Action Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	ResetAllEffects(client);

	return Plugin_Continue;
}


public Action Event_PlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	GiveReincarnationItems(client);

	return Plugin_Continue;
}


public Action Event_SmokeGrenadeDetonate(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	// Poison Smokes
	if(PlayerHasPoisonSmokes[client] <= 0)
	{
		return Plugin_Continue;
	}

	int poisonDamage = PlayerHasPoisonSmokes[client];

	float smokeLocationX = GetEventFloat(event, "x");
	float smokeLocationY = GetEventFloat(event, "y");
	float smokeLocationZ = GetEventFloat(event, "z");

	int lightEntity = CreateEntityByName("light_dynamic");

	if(lightEntity != -1)
	{
		int initialTeam = 0;

		char lightEntityName[64];
		char lightEntityLocation[32];

		DispatchKeyValue(lightEntity, "brightness", "6");

		DispatchKeyValueFloat(lightEntity, "spotlight_radius", 95.0);

		DispatchKeyValueFloat(lightEntity, "distance", float(260));

		DispatchKeyValue(lightEntity, "style", "6");

		if(GetClientTeam(client) == 2)
		{
			initialTeam = 2;
			DispatchKeyValue(lightEntity, "_light", "195 0 0 255");
			Format(lightEntityName, sizeof(lightEntityName), "lightDynamic_t_%i", lightEntity);
		}
		else if(GetClientTeam(client) == 3)
		{
			initialTeam = 3;
			DispatchKeyValue(lightEntity, "_light", "0 0 1830 255");
			Format(lightEntityName, sizeof(lightEntityName), "lightDynamic_ct_%i", lightEntity);
		}

		DispatchKeyValue(lightEntity,"targetname", lightEntityName);

		Format(lightEntityLocation, sizeof(lightEntityLocation), "%0.3f %0.3f %0.3f", smokeLocationX, smokeLocationY, smokeLocationZ);

		DispatchKeyValue(lightEntity, "origin", lightEntityLocation);

		DispatchSpawn(lightEntity);

		AcceptEntityInput(lightEntity, "TurnOn");

		SmokeGrenadeEntity[lightEntity] = 32;

		int initialRound = GameRules_GetProp("m_totalRoundsPlayed");

		DataPack pack = new DataPack();
		pack.WriteCell(client);
		pack.WriteCell(initialTeam);
		pack.WriteCell(lightEntity);
		pack.WriteCell(poisonDamage);
		pack.WriteCell(initialRound);
		pack.WriteCell(smokeLocationX);
		pack.WriteCell(smokeLocationY);
		pack.WriteCell(smokeLocationZ);

		CreateTimer(0.5, Timer_PoisonSmokeWithinProximity, pack, TIMER_REPEAT);
	}

	return Plugin_Continue;
}


public Action Event_OnPreThink(int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	if(PlayerHasNoScope[client] || PlayerHasFOV[client])
	{
		CheckIfPlayerScopes(client);
	}

	return Plugin_Continue;
}


public Action CheckIfPlayerScopes(int client)
{
	int weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");

	if (IsValidEdict(weapon))
	{
		char classname[32];

		GetEdictClassname(weapon, classname, sizeof(classname));
		
		if (StrEqual(classname[7], "ssg08") || StrEqual(classname[7], "aug") || StrEqual(classname[7], "sg550") || StrEqual(classname[7], "sg552") || StrEqual(classname[7], "sg556") || StrEqual(classname[7], "awp") || StrEqual(classname[7], "scar20") || StrEqual(classname[7], "g3sg1"))
		{
			if(PlayerHasBanish[client])
			{
				SetEntProp(client, Prop_Send, "m_iFOV", 167);
				SetEntProp(client, Prop_Send, "m_iDefaultFOV", 167);
			}

			if(PlayerHasFOV[client])
			{
				SetEntProp(client, Prop_Send, "m_iFOV", PlayerHasFOV[client]);
				SetEntProp(client, Prop_Send, "m_iDefaultFOV", PlayerHasFOV[client]);
			}

			if(PlayerHasNoScope[client])
			{
				int m_flNextSecondaryAttack = -1;

				m_flNextSecondaryAttack = FindSendPropOffs("CBaseCombatWeapon", "m_flNextSecondaryAttack");

				SetEntDataFloat(weapon, m_flNextSecondaryAttack, GetGameTime() + 2.0);
			}
		}
	}
}


public Action Event_OnDamageTaken(int client, int &attacker, int &inflictor, float &damage, int &damagetype) 
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	// Recently Teleported Fall Damage Immunity
	if(PlayerHasTeleportDeathImmunity[client])
	{
		if (damagetype & DMG_FALL)
		{
			if(PlayerHasFallDamageReduction[client] > 0.00)
			{
				return Plugin_Continue;
			}

			PlayerHasTeleportDeathImmunity[client] = false;

			damage = 0.0;

			return Plugin_Changed;
		}
	}



	// Headshot Immunity
	if(PlayerHasHeadshotImmunity[client] > 0.00)
	{	
		if(damagetype & CS_DMG_HEADSHOT)
		{
			if(PlayerHasHeadshotImmunity[client] == 1.00)
			{
				int Armor = GetClientArmor(client);

				SetEntProp(client, Prop_Data, "m_ArmorValue", Armor, 1);

				damage = 0.0;

				return Plugin_Changed;
			}

			else
			{
				float DamageReduction = PlayerHasHeadshotImmunity[client];

				float HeadshotDamage = damage * DamageReduction;

				int DamageTaken = RoundToFloor(HeadshotDamage);

				int Health = GetClientHealth(client) + DamageTaken;

				SetEntProp(client, Prop_Data, "m_iMaxHealth", Health);
				SetEntityHealth(client, Health);

				return Plugin_Continue;
			}
		}
	}

	// Bodyshot Immunity
	if(PlayerHasBodyshotImmunity[client] > 0.00)
	{	
		if(damagetype & CS_DMG_HEADSHOT)
		{
			return Plugin_Continue;
		}

		if(PlayerHasBodyshotImmunity[client] == 1.00)
		{
			int Armor = GetClientArmor(client);

			SetEntProp(client, Prop_Data, "m_ArmorValue", Armor, 1);

			damage = 0.0;

			return Plugin_Changed;
		}

		else
		{
			float DamageReduction = PlayerHasBodyshotImmunity[client];

			float BodyshotDamage = damage * DamageReduction;

			int DamageTaken = RoundToFloor(BodyshotDamage);

			int Health = GetClientHealth(client) + DamageTaken;

			SetEntProp(client, Prop_Data, "m_iMaxHealth", Health);
			SetEntityHealth(client, Health);

			return Plugin_Continue;
		}
	}



	// Fall Damage Reduction
	if(PlayerHasFallDamageReduction[client] > 0.00)
	{	
		// If the type of damage happens to be fall damage then do this
		if (damagetype & DMG_FALL)
		{
			float DamageReduction = PlayerHasFallDamageReduction[client];

			float FallDamage = damage * DamageReduction;

			int DamageTaken = RoundToFloor(FallDamage);

			int Health = GetClientHealth(client) + DamageTaken;

			SetEntProp(client, Prop_Data, "m_iMaxHealth", Health);
			SetEntityHealth(client, Health);
		}
	}


	// Absorption Shield
	if(PlayerHasAbsorptionShield[client] > 0)
	{
		// Creates a variable which we'll store the value of PlayerHasAbsorptionShield within
		int AbsorptionShield = PlayerHasAbsorptionShield[client];
		// PrintToChat(client, "Absorption Value: %i", AbsorptionShield);

		// Subtracts the damage taken value from the AbsorptionShield variable value
		AbsorptionShield = AbsorptionShield - RoundFloat(damage);

		// If the AbsorptionShield value is above 0 then execute this section
		if(AbsorptionShield >= 0.00)
		{
			// Change the damage to zero
			damage = 0.00;

			// Changes the PlayerHasAbsorptionShield variable to the value of AbsorptionShield
			PlayerHasAbsorptionShield[client] = AbsorptionShield;

			// PrintToChat(client, "0 Damage Taken - New Value: %i", PlayerHasAbsorptionShield[client]);

			return Plugin_Changed;
		}

		// Current issue: If the damage exceeds your shield value, then the damage you receive is the shield value
		else
		{
			// Absorption Shield will always be a negative
			// Damage will always be a positive value
			
			// PrintToChat(client, "Total Damage %2f", damage);
			float RemainingShield = damage + AbsorptionShield;
			
			damage = RemainingShield - damage;
			// PrintToChat(client, "Reduced Damage %2f", damage);

			// Changes the PlayerHasAbsorptionShield variable to the value of damage
			PlayerHasAbsorptionShield[client] = 0;


			return Plugin_Changed;
		}
	}


	if(!IsValidClient(attacker))
	{
		return Plugin_Continue;
	}


	// NoClip
	if(PlayerHasNoClip[attacker])
	{
		if(GetClientTeam(client) == GetClientTeam(attacker))
		{
			return Plugin_Continue;
		}

		damage = (damage / 100) * 40;

		RoundToFloor(damage);

		return Plugin_Changed;
	}
	if(PlayerHasNoClip[client])
	{
		if(GetClientTeam(client) == GetClientTeam(attacker))
		{
			return Plugin_Continue;
		}

		int IntDamage = RoundToFloor(damage);

		DealDamageToNoClippedTarget(client, IntDamage, attacker);

		return Plugin_Continue;
	}

	// Healing Gun
	if(PlayerHasHealingGun[attacker])
	{
		if(GetClientTeam(attacker) == GetClientTeam(client))
		{
			int MinValue = PlayerHasHealingGunMinHeal[attacker];
			int MaxValue = PlayerHasHealingGunMaxHeal[attacker];

			int RandomHealValue = GetRandomInt(MinValue, MaxValue);

			int PlayerHealth = GetClientHealth(client) + RandomHealValue;

			if ((PlayerHealth) <= PlayerHasHealingGunHealCap[attacker])
			{
				SetEntProp(client, Prop_Data, "m_iMaxHealth", PlayerHealth);
				SetEntityHealth(client, PlayerHealth);

				PrintToChat(client, "You were healed for %i health", RandomHealValue);
				PrintToChat(attacker, "You healed your teammate for %i health", RandomHealValue);
			}
			else 
			{
				SetEntProp(client, Prop_Data, "m_iMaxHealth", PlayerHasHealingGunHealCap[attacker]);
				SetEntityHealth(client, PlayerHasHealingGunHealCap[attacker]);

				PrintToChat(client, "Your teammate tried to heal you, but you are at maximum health!", RandomHealValue);
				PrintToChat(attacker, "Your teammate is already at maximum health!", RandomHealValue);
			}
		}
		else
		{
			damage = damage * PlayerHasHealingGunDamageReduction[attacker];

			RoundFloat(damage);

			return Plugin_Changed;
		}
	}

	return Plugin_Continue;
}


//////////////////
// - Forwards - //
//////////////////


public void OnClientPostAdminCheck(int client)
{
	if(IsValidClient(client))
	{
		SDKHook(client, SDKHook_OnTakeDamage, Event_OnDamageTaken);
		SDKHook(client, SDKHook_PreThink, Event_OnPreThink);
		SDKHook(client, SDKHook_PostThink, Event_OnPostThink);

		ResetAllEffects(client);
	}
}



public void OnClientDisconnect(int client)
{
	SDKUnhook(client, SDKHook_OnTakeDamage, Event_OnDamageTaken);
	SDKUnhook(client, SDKHook_PreThink, Event_OnPreThink);
	SDKUnhook(client, SDKHook_PreThink, Event_OnPostThink);
}


public void OnMapStart()
{
	// Calls upon our function named DownloadAndPrecacheFiles
	DownloadAndPrecacheFiles();
}



public Action Event_OnPostThink(int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	if(IsFakeClient(client))
	{
		return Plugin_Continue;
	}

	if(PlayerHasRadarReveal[client])
	{
		for(int i = 1 ;i <= MaxClients; i++)
		{
			if(!IsValidClient(i))
			{
				continue;
			}

			if(i == client)
			{
				continue;
			}

			if(GetClientTeam(client) == GetClientTeam(i))
			{
				continue;
			}

			SetEntPropEnt(i, Prop_Send, "m_bSpotted", 1);
		}
	}

	// Plant Bomb Anywhere
	if(PlayerHasPlantBombAnywhere[client])
	{
		SetEntPropEnt(client, Prop_Send, "m_bInBombZone", 1);
	}

	return Plugin_Continue;
}






///////////////////
// - Functions - //
///////////////////


// We call upon this function whenever we want to inflict damage upon an enemy
public Action DealDamageToNoClippedTarget(int client, int damage, int attacker)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	if(!IsValidClient(attacker))
	{
		return Plugin_Continue;
	}

	if(!IsPlayerAlive(client))
	{
		return Plugin_Continue;
	}

	if(!PlayerHasNoClip[client])
	{
		return Plugin_Continue;
	}

	int PlayerHealth = GetClientHealth(client);

	if(PlayerHealth > damage)
	{
		PlayerHealth = PlayerHealth - damage;
		SetEntProp(client, Prop_Data, "m_iMaxHealth", PlayerHealth);
		SetEntityHealth(client, PlayerHealth);

		return Plugin_Continue;
	}

	else
	{
		PlayerHasNoClip[client] = false;
		SetEntityMoveType(client, MOVETYPE_WALK);

		// Creates a variable naemd DamageInt which we will use to store the damage we wish to inflict upon our victim
		char DamageInt[16];

		// Converts our two variables to a different type
		IntToString(damage, DamageInt, 16);


		int EntityPointHurt = CreateEntityByName("point_hurt");

		// If the EntityPointHurt exists then execute this section
		if(EntityPointHurt)
		{
			// Modifies our point_hurt entity to target the client and deal damage from the attacekr
			DispatchKeyValue(client, "targetname", "DamageVictim");
			DispatchKeyValue(EntityPointHurt, "DamageTarget", "DamageVictim");
			DispatchKeyValue(EntityPointHurt, "Damage", DamageInt);
			DispatchKeyValue(EntityPointHurt, "DamageType", "DMG_GENERIC");

			DispatchKeyValue(EntityPointHurt, "classname", "");
			
			DispatchSpawn(EntityPointHurt);
			AcceptEntityInput(EntityPointHurt, "Hurt", (attacker > 0) ? attacker : -1);
			DispatchKeyValue(EntityPointHurt, "classname", "point_hurt");
			DispatchKeyValue(client, "targetname", "DamageDealer");
			RemoveEdict(EntityPointHurt);
		}
	}

	return Plugin_Continue;
}



public Action DealDamageBlackHole(int client, int damage, int attacker)
{
	char DamageInt[16];

	IntToString(damage, DamageInt, 16);

	int EntityPointHurt = CreateEntityByName("point_hurt");

	if(EntityPointHurt)
	{
		DispatchKeyValue(client, "targetname", "DamageVictim");
		DispatchKeyValue(EntityPointHurt, "DamageTarget", "DamageVictim");
		DispatchKeyValue(EntityPointHurt, "Damage", DamageInt);
		DispatchKeyValue(EntityPointHurt, "DamageType", "DMG_GENERIC");
		DispatchSpawn(EntityPointHurt);
		AcceptEntityInput(EntityPointHurt, "Hurt", (attacker > 0) ? attacker : -1);
		DispatchKeyValue(EntityPointHurt, "classname", "");
		DispatchKeyValue(client, "targetname", "DamageDealer");
		RemoveEdict(EntityPointHurt);
	}

	return Plugin_Continue;
}



// This is called upon whenever the plugin is loaded ResetAllEffects
public Action ResetAllEffects(int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	// Absorption Shield
	if(PlayerHasAbsorptionShield[client])
	{
		PlayerHasAbsorptionShield[client] = 0;
	}

	// Banish
	if(PlayerHasBanish[client])
	{
		PlayerHasBanish[client] = false;
		ClientCommand(client, "r_screenoverlay 0");
		SetEntProp(client, Prop_Send, "m_iFOV", 90);
		SetEntProp(client, Prop_Send, "m_iDefaultFOV", 90);
	}

	// Blur
	if(PlayerHasBlur[client])
	{
		PlayerHasBlur[client] = false;
		ClientCommand(client, "r_screenoverlay 0");
	}

	// Crouching Invisibility
	if(PlayerHasCrouchInvisibility[client])
	{
		PlayerHasCrouchInvisibility[client] = 0;
	}

	// Bodyshot Immunity
	if(PlayerHasBodyshotImmunity[client])
	{
		PlayerHasBodyshotImmunity[client] = 0.00;
	}

	// Double Jump
	if(PlayerHasDoubleJump[client])
	{
		PlayerHasDoubleJump[client] = false;
	}

	// Drug
	if(PlayerHasDrug[client])
	{
		PlayerHasDrug[client] = false;
		ApplyFadeOverlay(client, 1536, 1536, (0x0010), 255, 255, 255, 0, true);
	}

	// Drunk
	if(PlayerHasDrunk[client])
	{
		PlayerHasDrunk[client] = false;
		RemoveDrunkEffect(client);
	}

	// Fall Damage
	if(PlayerHasFallDamageReduction[client])
	{
		PlayerHasFallDamageReduction[client] = 0.0;
	}

	// Flicker
	if(PlayerHasFlicker[client])
	{
		PlayerHasFlicker[client] = 0;
		DispatchKeyValue(client, "renderfx", "0");
	}

	// FOV
	if(PlayerHasFOV[client])
	{
		PlayerHasFOV[client] = 0;
		SetEntProp(client, Prop_Send, "m_iFOV", 90);
		SetEntProp(client, Prop_Send, "m_iDefaultFOV", 90);
	}

	// Headshot Immunity
	if(PlayerHasHeadshotImmunity[client])
	{
		PlayerHasHeadshotImmunity[client] = 0.0;
	}

	// Healing Gun
	if(PlayerHasHealingGun[client])
	{
		PlayerHasHealingGun[client] = false;
	}

	// Health Decay
	if(PlayerHasHealthDecay[client])
	{
		PlayerHasHealthDecay[client] = 0;
	}

	// NoClip
	if(PlayerHasNoClip[client])
	{
		PlayerHasNoClip[client] = false;
	}

	// NoScope
	if(PlayerHasNoScope[client])
	{
		PlayerHasNoScope[client] = false;
	}

	// Poison Smoke
	if(PlayerHasPoisonSmokes[client])
	{
		PlayerHasPoisonSmokes[client] = 0;
	}

	// If the player has a prop as a model then execute this section
	if(PlayerHasPropModel[client])
	{
		// Creates a timer, which will remove any props attached to dead players
		CheckItems(client);

		if(IsValidEntity(PlayerHasPropModel[client]))
		{
			SDKUnhook(PlayerHasPropModel[client], SDKHook_SetTransmit, Transmit_HideModelEntity);

			// Removes the player's prop model status
			PlayerHasPropModel[client] = -1;
		}
	}

	// Plant Bomb Anywhere
	if(PlayerHasPlantBombAnywhere[client])
	{
		PlayerHasPlantBombAnywhere[client] = false;
	}

	// Quick Bomb Defuse
	if(PlayerHasQuickDefuse[client])
	{
		PlayerHasQuickDefuse[client] = false;
	}

	// Quick Bomb Explode
	if(PlayerHasQuickExplode[client])
	{
		PlayerHasQuickExplode[client] = false;
	}

	// Quick Bomb Plant
	if(PlayerHasQuickPlant[client])
	{
		PlayerHasQuickPlant[client] = false;
	}

	// Quick Scope
	if(PlayerHasQuickScope[client])
	{
		PlayerHasQuickScope[client] = false;
	}

	// Radar Reveal
	if(PlayerHasRadarReveal[client])
	{
		PlayerHasRadarReveal[client] = false;
	}

	// Reversed Movement Keys
	if(PlayerHasReversedMovement[client])
	{
		PlayerHasReversedMovement[client] = false;
	}

	// ThirdPerson
	if(PlayerHasThirdPerson[client])
	{
		PlayerHasThirdPerson[client] = false;
	}

	// Teleport Damage Reduction - Prevents damage briefly after using push teleport
	if(PlayerHasTeleportDeathImmunity[client])
	{
		PlayerHasTeleportDeathImmunity[client] = false;
	}

	return Plugin_Continue;
}



public void ShakeScreen(int client, float intensity, float duration, float frequency)
{
	Handle pb;

	if((pb = StartMessageOne("Shake", client)) != null)
	{
		PbSetFloat(pb, "local_amplitude", intensity);
		PbSetFloat(pb, "duration", duration);
		PbSetFloat(pb, "frequency", frequency);

		EndMessage();
	}
}


public bool TraceRayFilter(int entity, int contentsMask)
{
	return entity > MaxClients;
}


// We call upon this true and false statement whenever we wish to validate our player
public bool IsValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientConnected(client) || !IsClientInGame(client) || IsClientSourceTV(client) || IsClientReplay(client))
	{
		return false;
	}

	return true;
}






/////////////////////////
// - Timer Functions - //
/////////////////////////


// This function is called upon briefly prior to the round ending
public Action Timer_CallUponReset(Handle timer)
{
	// Loops through all of the clients on our server
	for(int client = 1 ;client <= MaxClients; client++)
	{
		ResetAllEffects(client);
	}
}


public Action Timer_RemoveEntity(Handle timer, int Entity)
{
	// If the entity is a valid entity then execute this section
	if(IsValidEntity(Entity))
	{
		AcceptEntityInput(Entity, "Kill");
	}
}














//////////////////////////
// - Commands : Setfx - //
//////////////////////////

//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx Absorptionshield													//
// - Usage: wcs_setfx absorptionshield <userid> <operator> <Amount / 0 Off> <time> 	//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxAbsorptionShield(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx absorptionshield only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasAbsorptionShield[client] = 0;
		return Plugin_Continue;
	}
	else if(amount >= 1)
	{
		PlayerHasAbsorptionShield[client] = amount;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx absorptionshield only supports '0' and positive integer values");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxAbsorptionShield, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxAbsorptionShield(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasAbsorptionShield[client] = 0;

	return Plugin_Continue;
}




//////////////////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx Banish 																		//
// - Usage: wcs_setfx banish <userid> <operator> <1 On / 0 Off> <time> 							//
//////////////////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxBanish(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx banish only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasBanish[client] = false;
		ClientCommand(client, "r_screenoverlay 0");
		SetEntProp(client, Prop_Send, "m_iFOV", 90);
		SetEntProp(client, Prop_Send, "m_iDefaultFOV", 90);
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasBanish[client] = true;
		ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
		SetEntProp(client, Prop_Send, "m_iFOV", 167);
		SetEntProp(client, Prop_Send, "m_iDefaultFOV", 167);
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx banish only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxBanish, client, TIMER_FLAG_NO_MAPCHANGE);
	}

//	CreateTimer(1.0, Timer_ApplyBanishEffect, client, TIMER_REPEAT);

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxBanish(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasBanish[client] = false;
	SetEntProp(client, Prop_Send, "m_iFOV", 90);
	SetEntProp(client, Prop_Send, "m_iDefaultFOV", 90);
	ClientCommand(client, "r_screenoverlay 0");

	return Plugin_Continue;
}

/*
public Action Timer_ApplyBanishEffect(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Stop;
	}

	if(!PlayerHasBanish[client])
	{
		ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
		return Plugin_Stop;
	}
	

	return Plugin_Continue;
}
*/


//////////////////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx Blur 																		//
// - Usage: wcs_setfx blur <userid> <operator> <1 On / 0 Off> <time> 							//
//////////////////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxBlur(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx blur only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasBlur[client] = false;
		ClientCommand(client, "r_screenoverlay 0");
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasBlur[client] = true;
		ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx blur only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxBlur, client, TIMER_FLAG_NO_MAPCHANGE);
	}

//	CreateTimer(1.0, Timer_ApplyBlurEffect, client, TIMER_REPEAT);

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxBlur(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasBlur[client] = false;
	ClientCommand(client, "r_screenoverlay 0");

	return Plugin_Continue;
}

/*
public Action Timer_ApplyBlurEffect(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Stop;
	}

	if(!PlayerHasBlur[client])
	{
		ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
		return Plugin_Stop;
	}
	

	return Plugin_Continue;
}
*/



//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx CrouchInvisibility													//
// - Usage: wcs_setfx absorptionshield <userid> <operator> <Amount / 0 Off> <time> 	//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxCrouchInvisibility(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx crouchinvisibility only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasCrouchInvisibility[client] = 0;
		return Plugin_Continue;
	}
	else if(amount >= 1 && amount <= 255)
	{
		PlayerHasCrouchInvisibility[client] = amount;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx crouchinvisibility only supports '0' and positive integer values up to 255");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxCrouchInvisibility, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxCrouchInvisibility(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasCrouchInvisibility[client] = 0;

	return Plugin_Continue;
}






//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx BodyshotImmunity																		//
// - Usage: wcs_setfx bodyshotimmunity <userid> <operator> <1.0 Immune / 0.0 Full Damage> <time> 		//
//////////////////////////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxBodyshotImmunity(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx bodyshotimmunity only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	float amount = StringToFloat(amount_char);
	if(amount <= 0.0)
	{
		PlayerHasBodyshotImmunity[client] = 0.00;
		return Plugin_Continue;
	}
	if(amount > 0.00 && amount <= 1.00)
	{
		PlayerHasBodyshotImmunity[client] = amount;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx bodyshotimmunity only supports the following range of values: '0.00' to '1.00'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxBodyshotImmunity, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxBodyshotImmunity(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasBodyshotImmunity[client] = 0.00;

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx Drug 																		//
// - Usage: wcs_setfx drug <userid> <operator> <1 On / 0 Off> <time> 							//
//////////////////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxDrug(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx drug only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasDrug[client] = false;
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasDrug[client] = true;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx drug only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxDrug, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	CreateTimer(0.5, Timer_ApplyDrugEffect, client, TIMER_REPEAT);

	return Plugin_Continue;
}


public Action Timer_ApplyDrugEffect(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Stop;
	}

	if(!PlayerHasDrug[client])
	{
		return Plugin_Stop;
	}

	int red = GetRandomInt(0, 255);
	int green = GetRandomInt(0, 255);
	int blue = GetRandomInt(0, 255);

	ApplyFadeOverlay(client, 255, 255, (0x0008), red, green, blue, 128, true);

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxDrug(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	ApplyFadeOverlay(client, 1536, 1536, (0x0010), 255, 255, 255, 0, true);
	PlayerHasDrug[client] = false;

	return Plugin_Continue;
}


// Thanks to Berni for his SM LIB screenfade stock
public void ApplyFadeOverlay(int client, int duration, int holdtime, int fadeflags, int red, int green, int blue, int alpha, bool reliable)
{
	// 0x0001 - Fade In, i believe?
	// 0x0002 - Fade out
	// 0x0004 - Fade without transitional color blend and a bit darker tones
	// 0x0008 - Stays faded until a new fade takes over
	// 0x0010 - Replaces any existing fade overlays with this one
	
	Handle userMessage = StartMessageOne("Fade", client, (reliable ? USERMSG_RELIABLE : 0));

	if (userMessage != INVALID_HANDLE)
	{
		if (GetFeatureStatus(FeatureType_Native, "GetUserMessageType") == FeatureStatus_Available && GetUserMessageType() == UM_Protobuf)
		{
			new color[4];
			color[0] = red;
			color[1] = green;
			color[2] = blue;
			color[3] = alpha;

			// Duration 512 is ~1 second
			PbSetInt(userMessage, "duration", duration); 	
			PbSetInt(userMessage, "hold_time", holdtime);

			// You can use multiple flags at once by enclosing them in parantheses
			PbSetInt(userMessage, "flags", fadeflags); 
			PbSetColor(userMessage, "clr", color);
		}
		else
		{
			BfWriteShort(userMessage, duration);
			BfWriteShort(userMessage, holdtime);
			BfWriteShort(userMessage, fadeflags);
			BfWriteByte(userMessage, red);
			BfWriteByte(userMessage, green);
			BfWriteByte(userMessage, blue);
			BfWriteByte(userMessage, alpha);
		}

		EndMessage();
	}
}




//////////////////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx Drunk 																		//
// - Usage: wcs_setfx drunk <userid> <operator> <1 On / 0 Off> <time> 							//
//////////////////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxDrunk(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx drunk only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasDrunk[client] = false;
		RemoveDrunkEffect(client);

		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasDrunk[client] = true;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx drunk only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxDrunk, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	CreateTimer(1.0, Timer_ApplyDrunkEffect, client, TIMER_REPEAT);

	return Plugin_Continue;
}


public void RemoveDrunkEffect(int client)
{
	float PlayerPosition[3];
	float PlayerViewAngle[3];

	GetClientAbsOrigin(client, PlayerPosition);
	GetClientEyeAngles(client, PlayerViewAngle);
	
	PlayerViewAngle[2] = 0.0;
	
	TeleportEntity(client, PlayerPosition, PlayerViewAngle, NULL_VECTOR);
}


public Action Timer_ApplyDrunkEffect(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Stop;
	}

	if(!PlayerHasDrunk[client])
	{
		return Plugin_Stop;
	}

	float PlayerPosition[3];
	float PlayerViewAngle[3];

	GetClientAbsOrigin(client, PlayerPosition);
	GetClientEyeAngles(client, PlayerViewAngle);
	
	PlayerViewAngle[2] = GetRandomFloat(-32.50, 32.50);
	
	TeleportEntity(client, PlayerPosition, PlayerViewAngle, NULL_VECTOR);

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxDrunk(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasDrunk[client] = false;
	RemoveDrunkEffect(client);

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx FallDamage 																	//
// - Usage: wcs_setfx falldamage <userid> <operator> <1.0 Immune / 0.0 Full Damage> <time> 		//
//////////////////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxFallDamage(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx falldamage only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	float amount = StringToFloat(amount_char);
	if(amount <= 0.0)
	{
		PlayerHasFallDamageReduction[client] = 0.00;
		return Plugin_Continue;
	}
	if(amount > 0.00 && amount <= 1.00)
	{
		PlayerHasFallDamageReduction[client] = amount;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx falldamage only supports the following range of values: '0.00' to '1.00'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxFallDamage, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxFallDamage(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasFallDamageReduction[client] = 0.00;

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx Flicker 																		//
// - Usage: wcs_setfx flicker <userid> <operator> <value / 0 Off> <time> 						//
//////////////////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxFlicker(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx flicker only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasFlicker[client] = 0;
		DispatchKeyValue(client, "renderfx", "0");

		return Plugin_Continue;
	}
	// Subject to change, to do go back note
	else if(amount >= 1 && amount <= 5)
	{
		PlayerHasFlicker[client] = amount;
		if(amount == 1)
		{
			DispatchKeyValue(client, "renderfx", "13");
		}
		else if(amount == 2)
		{
			DispatchKeyValue(client, "renderfx", "12");
		}
		else if(amount == 3)
		{
			DispatchKeyValue(client, "renderfx", "11");
		}
		else if(amount == 4)
		{
			DispatchKeyValue(client, "renderfx", "17");
		}
		else if(amount == 5)
		{
			DispatchKeyValue(client, "renderfx", "15");
		}		
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx flicker only supports the following range of values: '0', '5'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxFlicker, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxFlicker(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasFlicker[client] = 0;
	DispatchKeyValue(client, "renderfx", "0");

	return Plugin_Continue;
}





/*
enum RenderFx
{	
	RENDERFX_NONE = 0, 
	RENDERFX_PULSE_SLOW, 
	RENDERFX_PULSE_FAST, 
	RENDERFX_PULSE_SLOW_WIDE, 
	RENDERFX_PULSE_FAST_WIDE, 
	RENDERFX_FADE_SLOW, 
	RENDERFX_FADE_FAST, 
	RENDERFX_SOLID_SLOW, 
	RENDERFX_SOLID_FAST, 	   
	RENDERFX_STROBE_SLOW, 
	RENDERFX_STROBE_FAST, 
	RENDERFX_STROBE_FASTER, 
	RENDERFX_FLICKER_SLOW, 
	RENDERFX_FLICKER_FAST,
	RENDERFX_NO_DISSIPATION,
	*/
//	RENDERFX_DISTORT,			/**< Distort/scale/translate flicker */
//	RENDERFX_HOLOGRAM,			/**< kRenderFxDistort + distance fade */
//	RENDERFX_EXPLODE,			/**< Scale up really big! */
//	RENDERFX_GLOWSHELL,			/**< Glowing Shell */
//	RENDERFX_CLAMP_MIN_SCALE,	/**< Keep this sprite from getting very small (SPRITES only!) */
//	RENDERFX_ENV_RAIN,			/**< for environmental rendermode, make rain */
//	RENDERFX_ENV_SNOW,			/**<  "		"			"	, make snow */
//	RENDERFX_SPOTLIGHT,			/**< TEST CODE for experimental spotlight */
//	RENDERFX_RAGDOLL,			/**< HACKHACK: TEST CODE for signalling death of a ragdoll character */
//	RENDERFX_PULSE_FAST_WIDER,
//	RENDERFX_MAX
//};









//////////////////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx FOV 																			//
// - Usage: wcs_setfx fov <userid> <operator> <value / 0 Off> <time> 							//
//////////////////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxFOV(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx fov only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		SetEntProp(client, Prop_Send, "m_iFOV", 90);
		SetEntProp(client, Prop_Send, "m_iDefaultFOV", 90);
		PlayerHasFOV[client] = 0;
		return Plugin_Continue;
	}
	else if(amount >= 1 && amount <= 180)
	{
		SetEntProp(client, Prop_Send, "m_iFOV", amount);
		SetEntProp(client, Prop_Send, "m_iDefaultFOV", amount);
		PlayerHasFOV[client] = amount;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx fov only supports the following range of values: '0', '180'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxFOV, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxFOV(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	SetEntProp(client, Prop_Send, "m_iFOV", 90);
	SetEntProp(client, Prop_Send, "m_iDefaultFOV", 90);

	PlayerHasFOV[client] = 0;

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx DoubleJump 														//
// - Usage: wcs_setfx doublejump <userid> <operator> <1 On / 0 Off> <time> 			//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_SetfxDoubleJump(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx doublejump only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasDoubleJump[client] = false;
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasDoubleJump[client] = true;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx doublejump only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxDoubleJump, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxDoubleJump(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasDoubleJump[client] = false;

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx HeadshotImmunity																		//
// - Usage: wcs_setfx headshotimmunity <userid> <operator> <1.0 Immune / 0.0 Full Damage> <time> 		//
//////////////////////////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxHeadshotImmunity(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx headshotimmunity only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	float amount = StringToFloat(amount_char);
	if(amount <= 0.0)
	{
		PlayerHasHeadshotImmunity[client] = 0.00;
		return Plugin_Continue;
	}
	if(amount > 0.00 && amount <= 1.00)
	{
		PlayerHasHeadshotImmunity[client] = amount;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx headshotimmunity only supports the following range of values: '0.00' to '1.00'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxHeadshotImmunity, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxHeadshotImmunity(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasHeadshotImmunity[client] = 0.00;

	return Plugin_Continue;
}




//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx Health Decay														//
// - Usage: wcs_setfx healthdecay <userid> <operator> <Amount / 0 Off> <time> 		//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxHealthDecay(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx healthdecay only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasHealthDecay[client] = 0;
		return Plugin_Continue;
	}
	else if(amount >= 1)
	{
		PlayerHasHealthDecay[client] = amount;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx healthdecay only supports '0' and positive integer values");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		time += 1.0;
		CreateTimer(time, Timer_RemoveSetfxHealthDecay, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	int initialRound = GameRules_GetProp("m_totalRoundsPlayed");

	DataPack pack = new DataPack();
	pack.WriteCell(client);
	pack.WriteCell(initialRound);

	CreateTimer(1.0, Timer_HealthDecayActive, pack, TIMER_REPEAT);

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxHealthDecay(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasHealthDecay[client] = 0;

	return Plugin_Continue;
}


public Action Timer_HealthDecayActive(Handle timer, DataPack data)
{
	data.Reset();
	int client = data.ReadCell();
	int initialRound = data.ReadCell();

	if(!IsValidClient(client))
	{
		delete data;
		return Plugin_Stop;
	}

	int currentRound = GameRules_GetProp("m_totalRoundsPlayed");
	if(initialRound != currentRound)
	{
		delete data;
		return Plugin_Stop;
	}

	if(PlayerHasHealthDecay[client] <= 0)
	{
		delete data;
		return Plugin_Stop;
	}

	int DecayAmount = PlayerHasHealthDecay[client];

	int PlayerHealth = GetClientHealth(client);

	if(PlayerHealth > DecayAmount)
	{
		PlayerHealth = PlayerHealth - DecayAmount;

		SetEntProp(client, Prop_Data, "m_iMaxHealth", PlayerHealth);
		
		SetEntityHealth(client, PlayerHealth);

		return Plugin_Continue;
	}
	else 
	{
		DecayAmount *= 2;
		DealDamagePoisonSmoke(client, DecayAmount, client);
	}

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx NoClip 															//
// - Usage: wcs_noclip <userid> <operator> <1 On / 0 Off> <time> 					//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxNoClip(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));
	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx noclip only supports the following operator: '='");

		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasNoClip[client] = false;
		SetEntityMoveType(client, MOVETYPE_WALK);
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasNoClip[client] = true;
		SetEntityMoveType(client, MOVETYPE_NOCLIP);
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx noclip only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxNoClip, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxNoClip(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasNoClip[client] = false;
	SetEntityMoveType(client, MOVETYPE_WALK);

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx NoScope 															//
// - Usage: wcs_setfx noscope <userid> <operator> <1 On / 0 Off> <time> 			//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxNoScope(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx noscope only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasNoScope[client] = false;
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasNoScope[client] = true;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx noscope only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxNoScope, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxNoScope(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasNoScope[client] = false;

	return Plugin_Continue;
}





//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx PlantBombAnywhere												//
// - Usage: wcs_setfx plantbombanywhere <userid> <operator> <1 On / 0 Off> <time> 	//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_PlantBombAnywhere(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx plantbombanywhere only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasPlantBombAnywhere[client] = false;
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasPlantBombAnywhere[client] = true;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx plantbombanywhere only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxPlantBombAnywhere, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxPlantBombAnywhere(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasPlantBombAnywhere[client] = false;

	return Plugin_Continue;
}





//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx Paralyze 														//
// - Usage: wcs_setfx paralyze <userid> <operator> <1 On / 0 Off> <time> 			//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxParalyze(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx paralyze only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		SetEntityFlags(client, GetEntityFlags(client) & ~FL_FROZEN);
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		SetEntityFlags(client, GetEntityFlags(client) | FL_FROZEN);
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx paralyze only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxParalyze, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxParalyze(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	SetEntityFlags(client, GetEntityFlags(client) & ~FL_FROZEN);

	return Plugin_Continue;
}




//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx Quick Defuse 													//
// - Usage: wcs_setfx quickdefuse <userid> <operator> <1 On / 0 Off> <time> 		//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_SetfxQuickDefuse(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx quickdefuse only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasQuickDefuse[client] = false;
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasQuickDefuse[client] = true;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx quickdefuse only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxQuickDefuse, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxQuickDefuse(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasQuickDefuse[client] = false;

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx Quick Explode 													//
// - Usage: wcs_setfx quickexplode <userid> <operator> <1 On / 0 Off> <time> 		//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_SetfxQuickExplode(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx quickexplode only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasQuickExplode[client] = false;
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasQuickExplode[client] = true;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx quickexplode only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxQuickExplode, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxQuickExplode(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasQuickExplode[client] = false;

	return Plugin_Continue;
}


//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx Quick Plant 														//
// - Usage: wcs_setfx quickplant <userid> <operator> <1 On / 0 Off> <time> 			//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_SetfxQuickPlant(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx quickplant only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasQuickPlant[client] = false;
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasQuickPlant[client] = true;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx quickplant only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxQuickPlant, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxQuickPlant(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasQuickPlant[client] = false;

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx QuickScope 														//
// - Usage: wcs_setfx quickscope <userid> <operator> <1 On / 0 Off> <time> 			//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxQuickScope(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx quickscope only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasQuickScope[client] = false;
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasQuickScope[client] = true;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx quickscope only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxQuickScope, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxQuickScope(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasQuickScope[client] = false;

	return Plugin_Continue;
}


public Action Timer_QuickScopeUnzoom(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	if(!IsPlayerAlive(client))
	{
		return Plugin_Continue;
	}

	if(!PlayerHasQuickScope[client])
	{
		return Plugin_Continue;
	}

	int Weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);

	if(!IsValidEntity(Weapon))
	{
		return Plugin_Continue;
	}

	SetEntProp(Weapon, Prop_Send, "m_zoomLevel", 0);
	SetEntProp(client, Prop_Send, "m_bIsScoped", 0);
	SetEntProp(client, Prop_Send, "m_bResumeZoom", 0);

	if(PlayerHasBanish[client] || PlayerHasFOV[client])
	{
		return Plugin_Continue;
	}

	SetEntProp(client, Prop_Send, "m_iFOV", 90);
	SetEntProp(client, Prop_Send, "m_iDefaultFOV", 90);

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx Reincarnation 													//
// - Usage: wcs_setfx reincarnation <userid> <operator> <1 On / 0 Off> <time> 		//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxReincarnation(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx reincarnation only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasReincarnation[client] = false;

		ReincarnationItemDefuser[client] = false;
		ReincarnationItemKevlar[client] = false;
		ReincarnationItemKevlarHelmet[client] = false;

		ReincarnationWeaponPrimary[client] = "-1";
		ReincarnationWeaponSecondary[client] = "-1";

		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasReincarnation[client] = true;

		char ClassNamePrimary[64];
		char ClassNameSecondary[64];

		int WeaponPrimary = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
		int WeaponSecondary = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);

		if(IsValidEntity(WeaponPrimary))
		{
			GetEntityClassname(WeaponPrimary, ClassNamePrimary, sizeof(ClassNamePrimary));
		}
		
		if(IsValidEntity(WeaponSecondary))
		{
			
			GetEntityClassname(WeaponSecondary, ClassNameSecondary, sizeof(ClassNameSecondary));
		}

		if(GetEntProp(client, Prop_Send, "m_bHasDefuser"))
		{
			ReincarnationItemDefuser[client] = true;
		}

		if(GetEntProp(client, Prop_Send, "m_ArmorValue"))
		{
			if(!GetEntProp(client, Prop_Send, "m_bHasHelmet"))
			{
				int IsArmourFree = GetConVarInt(FindConVar("mp_free_armor"));
				if(IsArmourFree == 0)
				{
					ReincarnationItemKevlar[client] = true;
				}
			}
		}

		if(GetEntProp(client, Prop_Send, "m_bHasHelmet"))
		{
			ReincarnationItemKevlarHelmet[client] = true;
		}

		ReincarnationWeaponPrimary[client] = ClassNamePrimary;
		ReincarnationWeaponSecondary[client] = ClassNameSecondary;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx reincarnation only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxReincarnation, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxReincarnation(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasReincarnation[client] = false;

	return Plugin_Continue;
}


public void GiveReincarnationItems(int client)
{
	if(!PlayerHasReincarnation[client])
	{
		int WeaponPrimary = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
		int WeaponSecondary = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);

		if(IsValidEntity(WeaponPrimary))
		{
			CS_DropWeapon(client, WeaponPrimary, false, false);
		}
		
		if(IsValidEntity(WeaponSecondary))
		{
			CS_DropWeapon(client, WeaponSecondary, false, false);
		}

		GivePlayerItem(client, ReincarnationWeaponPrimary[client]);
		GivePlayerItem(client, ReincarnationWeaponSecondary[client]);

		ReincarnationWeaponPrimary[client] = "-1";
		ReincarnationWeaponSecondary[client] = "-1";

		if(!ReincarnationItemDefuser[client])
		{
			ReincarnationItemDefuser[client] = false;
			SetEntProp(client, Prop_Send, "m_bHasDefuser", 1);
		}

		if(!ReincarnationItemKevlar[client])
		{
			ReincarnationItemKevlar[client] = false;
			GivePlayerItem(client, "item_kevlar");
		}

		if(!ReincarnationItemKevlarHelmet[client])
		{
			ReincarnationItemKevlarHelmet[client] = false;
			SetEntProp(client, Prop_Send, "m_bHasHelmet", 1);	
		}
		
		PlayerHasReincarnation[client] = false;
	}
}




//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx RadarReveal 														//
// - Usage: wcs_setfx radarreveal <userid> <operator> <1 On / 0 Off> <time> 		//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxRadarReveal(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx radarreveal only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasRadarReveal[client] = false;

		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasRadarReveal[client] = true;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx radarreveal only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxRadarReveal, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxRadarReveal(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasRadarReveal[client] = false;

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx ReverseMovement 													//
// - Usage: wcs_setfx reversemovement <userid> <operator> <1 On / 0 Off> <time> 	//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxReverseMovement(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx reversemovement only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasReversedMovement[client] = false;
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasReversedMovement[client] = true;
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx reversemovement only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxReverseMovement, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxReverseMovement(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasReversedMovement[client] = false;

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////
// Command - Setfx ThirdPerson 														//
// - Usage: wcs_setfx thirdperson <userid> <operator> <1 On / 0 Off> <time> 		//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_SetfxThirdPerson(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char operator_char[16];
	GetCmdArg(2, operator_char, sizeof(operator_char));

	if(!StrEqual(operator_char, "="))
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx thirdperson only supports the following operator: '='");
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(3, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount == 0)
	{
		PlayerHasThirdPerson[client] = false;
		SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", -1);
		SetEntProp(client, Prop_Send, "m_iObserverMode", 0);
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 1);
		SetEntProp(client, Prop_Send, "m_iFOV", 90);
		return Plugin_Continue;
	}
	else if(amount == 1)
	{
		PlayerHasThirdPerson[client] = true;
		SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", 0); 
		SetEntProp(client, Prop_Send, "m_iObserverMode", 1);
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 0);
		SetEntProp(client, Prop_Send, "m_iFOV", 120);
	}
	else
	{
		PrintToServer("Command Syntax Error:");
		PrintToServer("wcs_setfx thirdperson only supports the following values: '0', '1'");
		return Plugin_Continue;
	}

	char time_char[32];
	GetCmdArg(4, time_char, sizeof(time_char));
	float time = StringToFloat(time_char);
	if(time > 0.00)
	{
		CreateTimer(time, Timer_RemoveSetfxThirdPerson, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}


public Action Timer_RemoveSetfxThirdPerson(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	PlayerHasThirdPerson[client] = false;
	SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", -1);
	SetEntProp(client, Prop_Send, "m_iObserverMode", 0);
	SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 1);
	SetEntProp(client, Prop_Send, "m_iFOV", 90);

	return Plugin_Continue;
}









///////////////////////////
// - Commands : Normal - //
///////////////////////////

//////////////////////////////////////////////////////////////////////////////////////
// Command - Absorption Shield														//
// - Usage: wcs_Absorptionshield <userid> <integer>									//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_AbsorptionShield(int args)
{
	// Creates a variable named userid which we'll store our data within
	char userid[128];

	// Sets our userid variable to be the first argument in the command
	GetCmdArg(1, userid, sizeof(userid));

	// Converts the string to an integer and store that within client
	int client = StringToInt(userid);

	// Changes the client variable integer to something
	client = GetClientOfUserId(client);

	// If the player meets our criteria for validation then execute this section
	if(IsValidClient(client))
	{
		char amount_char[128];

		GetCmdArg(2, amount_char, sizeof(amount_char));

		// Converts the string to an integer and store that within the variable amount
		int amount = StringToInt(amount_char);

		if(amount <= 0)
		{
			// Removes the player's Absorption shield status
			PlayerHasAbsorptionShield[client] = 0;

			PrintToChat(client, "Amount should be zero but was: %i", amount);
		}
		else
		{
			// Changes the player's Absorption shield value to match the amount specified
			PlayerHasAbsorptionShield[client] = amount;

			PrintToChat(client, "The Amount was: %i", amount);
		}
	}
}



//public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float velocity[3], float angles[3], int &weapon)
{
	// If the player meets our criteria for validation then execute this section
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	// If the player has reversed movement enabled then execute this section
	if(PlayerHasReversedMovement[client])
	{
		velocity[1] = -velocity[1];
		velocity[0] = -velocity[0];


		if(buttons & IN_FORWARD)
		{
			buttons &= ~IN_FORWARD;
			buttons |= IN_BACK;
		}
		else if(buttons & IN_BACK)
		{
			buttons &= ~IN_BACK;
			buttons |= IN_FORWARD;
		}


		if(buttons & IN_MOVELEFT)
		{
			buttons &= ~IN_MOVELEFT;
			buttons |= IN_MOVERIGHT;
		}
		else if(buttons & IN_MOVERIGHT)
		{
			buttons &= ~IN_MOVERIGHT;
			buttons |= IN_MOVELEFT;
		}

		return Plugin_Changed;
	}

	// If the player has double jump enabled then execute this section
	if(PlayerHasDoubleJump[client])
	{
		int PlayerFlags = GetEntityFlags(client);

		if(PlayerFlags & FL_ONGROUND)
		{
			PlayerDoubleJumped[client] = false;
		}
		
		else if(!(LastButtonsPressed[client] & IN_JUMP) && (buttons & IN_JUMP) && !(PlayerFlags & FL_ONGROUND))
		{
			if(!PlayerDoubleJumped[client])
			{
				PlayerDoubleJumped[client] = true;

				float JumpVelocity[3];
				GetEntPropVector(client, Prop_Data, "m_vecVelocity", JumpVelocity);

				JumpVelocity[2] = 350.0;
				TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, JumpVelocity);
			}
		}
		
		LastButtonsPressed[client] = buttons;
	}



	if(buttons & IN_DUCK)
	{
		int userid = GetClientUserId(client);

		char ServerCommandMessage[128];

		FormatEx(ServerCommandMessage, sizeof(ServerCommandMessage), "es wcsgroup set is_ducking %i 1", userid);

		ServerCommand(ServerCommandMessage);

		// Crouching Invisibility
		if(PlayerHasCrouchInvisibility[client])
		{
			if(GetEntityFlags(client) & FL_ONGROUND)
			{
				SetEntityRenderMode(client, RENDER_TRANSALPHA);
				Entity_SetRenderColor(client, 255, 255, 255, PlayerHasCrouchInvisibility[client]);

				return Plugin_Continue;				
			}
			else
			{
				Entity_SetRenderColor(client, 255, 255, 255, 255);

				return Plugin_Continue;
			}
		}
	}
	else
	{
		int userid = GetClientUserId(client);

		char ServerCommandMessage[128];

		FormatEx(ServerCommandMessage, sizeof(ServerCommandMessage), "es wcsgroup set is_ducking %i 0", userid);

		ServerCommand(ServerCommandMessage);

		// Crouching Invisibility
		if(PlayerHasCrouchInvisibility[client])
		{
			Entity_SetRenderColor(client, 255, 255, 255, 255);

			return Plugin_Continue;
		}
	}





	

	return Plugin_Continue;
}




//////////////////////////////////////////////////////////////////////////////////////
// Command - Destroyable Physics Props												//
// - Usage: wcs_prop_explosive_barrel <userid> 										//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_ExplosiveBarrel(int args)
{
	// Creates a variable named userid which we'll store our data within
	char userid[128];

	// Sets our userid variable to be the first argument in the command
	GetCmdArg(1, userid, sizeof(userid));

	// Converts the string to an integer and store that within client
	int client = StringToInt(userid);

	// Changes the client variable integer to something
	client = GetClientOfUserId(client);

	// If the player meets our criteria for validation then execute this section
	if(IsValidClient(client))
	{

		float PropOrigin[3];
		float PropAngle[3];
		
		GetClientEyePosition(client, PropOrigin);
		GetClientEyeAngles(client, PropAngle);
		
		TR_TraceRayFilter(PropOrigin, PropAngle, MASK_SOLID, RayType_Infinite, Trace_FilterPlayers, client);
		
		if(TR_DidHit(INVALID_HANDLE))
		{
			TR_GetEndPosition(PropOrigin, INVALID_HANDLE);
			TR_GetPlaneNormal(INVALID_HANDLE, PropAngle);

			GetVectorAngles(PropAngle, PropAngle);

			PropAngle[0] += 90.0;
			
			int Entity = CreateEntityByName("prop_exploding_barrel");

			DispatchSpawn(Entity);
			TeleportEntity(Entity, PropOrigin, PropAngle, NULL_VECTOR);

			Entity_SetHealth(Entity, 100, true, true);

			Entity_EnableMotion(Entity);

			// Checks our current timer's status and executes this section if the timer is already running
			if(Timer_ManageExplosiveBarrel != null)
			{
				return Plugin_Handled;
			}

			// Creates our global timer which is being repeated every 1 second 
			Timer_ManageExplosiveBarrel = CreateTimer(1.0, ManageExplosiveBarrel, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	
	return Plugin_Handled;
}


public Action ManageExplosiveBarrel(Handle timer)
{
	// Loops through all the entities, but skips the client indexed entities
	int Entity = MaxClients + 1;

	// If an entity has a classname containing physics then execute this section
	while((Entity = FindEntityByClassname(Entity, "prop_physics")) != -1)
	{
		// Creates a variable named ModelName which we'll use to store data within
		char ModelName[75];

		// Obtains the model name of the prop and store it within our variable called ModelName
		GetEntPropString(Entity, Prop_Data, "m_ModelName", ModelName, sizeof(ModelName));

		// If the prop's model is the same as our ModelName variable then execute this section
		if (StrEqual(ModelName, "models/props/coop_cementplant/exloding_barrel/exploding_barrel_top.mdl"))
		{
			// Creates a variable named ClassName which we'll use to store our data within
			char ClassName[128];

			// Obtains the Entity's classname and store it within our ClassName variable
			GetEntityClassname(Entity, ClassName, sizeof(ClassName));

			if (Entity_GetCollisionGroup(Entity) == COLLISION_GROUP_PROJECTILE)
			{
				return Plugin_Handled;
			}

			// Changes the Entity's collision to not collide with players, but still be movable by shooting at the prop
			Entity_SetCollisionGroup(Entity, COLLISION_GROUP_PROJECTILE);

			// Creates a timer, which will remove any props attached to dead players
			CreateTimer(5.0, Timer_RemoveEntity, Entity, TIMER_FLAG_NO_MAPCHANGE);
		}
	}

	return Plugin_Handled;
}


public Action ExplosiveBarrelTimerManager()
{
	// If our timer is currently running then execute this section
	if(Timer_ManageExplosiveBarrel != null)
	{
	   	// Sets our global timer to null
	   	Timer_ManageExplosiveBarrel = null; 

	   	// Deletes our global timer 
		delete Timer_ManageExplosiveBarrel;

		return Plugin_Handled;
	}

	return Plugin_Handled;
}



//////////////////////////////////////////////////////////////////////////////////////
// Command - Destroyable Physics Props												//
// - Usage: wcs_prop_physics_destructible <userid> <model path> <health>			//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_PropPhysicsDestructible(int args)
{
	// Creates a variable named userid which we'll store our data within
	char userid[128];
	char ModelPath[1024];
	char Health[128];

	// Sets our userid variable to be the first argument in the command
	GetCmdArg(1, userid, sizeof(userid));

	// Converts the string to an integer and store that within client
	int client = StringToInt(userid);

	// Changes the client variable integer to something
	client = GetClientOfUserId(client);

	// If the player meets our criteria for validation then execute this section
	if(IsValidClient(client))
	{
		GetCmdArg(2, ModelPath, sizeof(ModelPath));
		GetCmdArg(3, Health, sizeof(Health));
		
		PrecacheModel(ModelPath);
		
		float PropOrigin[3];
		float PropAngle[3];
		
		GetClientEyePosition(client, PropOrigin);
		GetClientEyeAngles(client, PropAngle);
				
		TR_TraceRayFilter(PropOrigin, PropAngle, MASK_SOLID, RayType_Infinite, Trace_FilterPlayers, client);
		
		if(TR_DidHit(INVALID_HANDLE))
		{
			TR_GetEndPosition(PropOrigin, INVALID_HANDLE);
			TR_GetPlaneNormal(INVALID_HANDLE, PropAngle);

			GetVectorAngles(PropAngle, PropAngle);

			PropAngle[0] += 90.0;
					
			int Entity = CreateEntityByName("prop_physics_multiplayer");

			// Check if the model we intend to use is already precached, if not then execute this section
			if(!IsModelPrecached(ModelPath))
			{
				// Precache the model we intend to use
				PrecacheModel(ModelPath);
			}

			SetEntityModel(Entity, ModelPath);

			DispatchKeyValue(Entity, "targetname", "Name");
			DispatchKeyValue(Entity, "Solid", "6");
			DispatchSpawn(Entity);


//			Entity_SetRenderColor(Entity, 10, 40, 200, 100);

			TeleportEntity(Entity, PropOrigin, PropAngle, NULL_VECTOR);

			SetEntityMoveType(Entity, MOVETYPE_VPHYSICS);

			if (StringToInt(Health) > 0)
			{
				Entity_SetHealth(Entity, StringToInt(Health), true, true);
			}
		}
	}
	
	return Plugin_Handled;
}



//////////////////////////////////////////////////////////////////////////////////////
// Command - Destroyable Dynamic Props												//
// - Usage: wcs_prop_dynamic_destructible <userid> <model path> <health>			//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_PropDynamicDestructible(int args)
{
	// Creates a variable named userid which we'll store our data within
	char userid[128];
	char ModelPath[1024];
	char Health[128];

	// Sets our userid variable to be the first argument in the command
	GetCmdArg(1, userid, sizeof(userid));

	// Converts the string to an integer and store that within client
	int client = StringToInt(userid);

	// Changes the client variable integer to something
	client = GetClientOfUserId(client);

	// If the player meets our criteria for validation then execute this section
	if(IsValidClient(client))
	{
		GetCmdArg(2, ModelPath, sizeof(ModelPath));
		GetCmdArg(3, Health, sizeof(Health));
		
		PrecacheModel(ModelPath);
		
		float PropOrigin[3];
		float PropAngle[3];
		
		GetClientEyePosition(client, PropOrigin);
		GetClientEyeAngles(client, PropAngle);
				
		TR_TraceRayFilter(PropOrigin, PropAngle, MASK_SOLID, RayType_Infinite, Trace_FilterPlayers, client);
		
		if(TR_DidHit(INVALID_HANDLE))
		{
			TR_GetEndPosition(PropOrigin, INVALID_HANDLE);
			TR_GetPlaneNormal(INVALID_HANDLE, PropAngle);

			GetVectorAngles(PropAngle, PropAngle);

			PropAngle[0] += 90.0;
					
			int Entity = CreateEntityByName("prop_dynamic");

			// Check if the model we intend to use is already precached, if not then execute this section
			if(!IsModelPrecached(ModelPath))
			{
				// Precache the model we intend to use
				PrecacheModel(ModelPath);
			}

			SetEntityModel(Entity, ModelPath);

			DispatchKeyValue(Entity, "targetname", "Name");
			DispatchKeyValue(Entity, "Solid", "6");
			DispatchSpawn(Entity);

			TeleportEntity(Entity, PropOrigin, PropAngle, NULL_VECTOR);

			SetEntityMoveType(Entity, MOVETYPE_VPHYSICS);

			if (StringToInt(Health) > 0)
			{
				Entity_SetHealth(Entity, StringToInt(Health), true, true);
			}
		}
	}
	
	return Plugin_Handled;
}


public OnEntityCreated(entity, const String:classname[])
{
	if (entity > 0)
	{
		SDKHook(entity, SDKHook_OnTakeDamage, OnTakeDamage);
	}
}


public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{ 
	new health = Entity_GetHealth(victim);

	if (health > 0 && victim > MaxClients)
	{
		Entity_TakeHealth(victim, RoundFloat(damage), true, true);
	}
}


public bool:Trace_FilterPlayers(entity, contentsMask, any:data)
{
	if(entity != data && entity > MaxClients)
	{
		return true;
	}

	return false;
}













//////////////////////////////////////////////////////////////////////////////////////
// Command - Teleport Push Based 													//
// - Usage: wcs_teleport_push <userid> <velocity force> 							//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_TeleportPush(int args)
{
	// Creates a variable named userid which we'll store our data within
	char userid[128];

	// Sets our userid variable to be the first argument in the command
	GetCmdArg(1, userid, sizeof(userid));

	// Converts the string to an integer and store that within client
	int client = StringToInt(userid);

	// Changes the client variable integer to something
	client = GetClientOfUserId(client);

	// If the player meets our criteria for validation then execute this section
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(2, amount_char, sizeof(amount_char));
	float amount = StringToFloat(amount_char);	


	// If the player is on the ground then provide some security to prevent the player from taking damage
	if(GetEntityFlags(client) & FL_ONGROUND)
	{
		PlayerHasTeleportDeathImmunity[client] = true;

		CreateTimer(0.20, Timer_RemoveTeleportImmunity, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	float PlayerVelocity[3];

	GetEntPropVector(client, Prop_Data, "m_vecVelocity", PlayerVelocity);

	PlayerVelocity[2] += 251;

	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, PlayerVelocity);


	DataPack pack = new DataPack();
	pack.WriteCell(client);
	pack.WriteCell(amount);

	

	CreateTimer(0.02, Timer_ApplyFowardVelocity, pack, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Continue;
}


public Action Timer_ApplyFowardVelocity(Handle timer, DataPack data)
{
	data.Reset();
	int client = data.ReadCell();
	float amount = data.ReadCell();
	delete data;
	
	// If the player doesn't meet our validation criteria then stop the plugin
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	float PlayerAngles[3];
	float PlayerOrigin[3];
	float PlayerVelocity[3];

	GetClientEyeAngles(client, PlayerAngles);

	GetAngleVectors(PlayerAngles, PlayerOrigin, NULL_VECTOR, NULL_VECTOR);
	
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", PlayerVelocity);
	
	PlayerVelocity[0] += amount * PlayerOrigin[0];
	PlayerVelocity[1] += amount * PlayerOrigin[1];
	PlayerVelocity[2] += amount * PlayerOrigin[2];
	
	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, PlayerVelocity);

	return Plugin_Continue;
}


public Action Timer_RemoveTeleportImmunity(Handle timer, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}
	
	PlayerHasTeleportDeathImmunity[client] = false;

	return Plugin_Continue;
}



//////////////////////////////////////////////////////////////////////////////////////
// Command - Switch Team 															//
// - Usage: wcs_switchteam <userid> 												//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_SwitchTeam(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);

	if(IsValidClient(client))
	{
		if(GetClientTeam(client) == 2)
		{
			CS_SwitchTeam(client, 3);

			if(!IsModelPrecached("models/weapons/ct_arms_idf.mdl"))
			{
				PrecacheModel("models/weapons/ct_arms_idf.mdl");
		 	}
			if(!IsModelPrecached("models/player/ctm_idf_variantc.mdl"))
			{
				PrecacheModel("models/player/ctm_idf_variantc.mdl");
			}

			SetEntityModel(client, "models/player/ctm_idf_variantc.mdl");
			SetEntPropString(client, Prop_Send, "m_szArmsModel", "models/weapons/ct_arms_idf.mdl");
		}
		else if(GetClientTeam(client) == 3)
		{
			CS_SwitchTeam(client, 2);

			if(!IsModelPrecached("models/weapons/t_arms_phoenix.mdl"))
			{
				PrecacheModel("models/weapons/t_arms_phoenix.mdl");
		 	}
			if(!IsModelPrecached("models/player/custom_player/legacy/tm_phoenix_varianta.mdl"))
			{
				PrecacheModel("models/player/custom_player/legacy/tm_phoenix_varianta.mdl");
			}

			SetEntityModel(client, "models/player/custom_player/legacy/tm_phoenix_varianta.mdl");
			SetEntPropString(client, Prop_Send, "m_szArmsModel", "models/weapons/t_arms_phoenix.mdl");
		}
	}
}


//////////////////////////////////////////////////////////////////////////////////////
// Command - Healing Gun 															//
// - Usage: wcs_healinggun <userid> <1 On / 0 Off>							//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_HealingGun(int args)
{
	// Creates a variable named userid which we'll store our data within
	char userid[128];

	// Sets our userid variable to be the first argument in the command
	GetCmdArg(1, userid, sizeof(userid));

	// Converts the string to an integer and store that within client
	int client = StringToInt(userid);

	// Changes the client variable integer to something
	client = GetClientOfUserId(client);

	// If the player meets our criteria for validation then execute this section
	if(IsValidClient(client))
	{
		char amount_char[16];
		GetCmdArg(2, amount_char, sizeof(amount_char));
		int amount = StringToInt(amount_char);
		if(amount <= 0)
		{
			PlayerHasHealingGun[client] = false;
			return Plugin_Continue;
		}


		char capamount_char[16];
		GetCmdArg(3, capamount_char, sizeof(capamount_char));
		int healcapamount = StringToInt(capamount_char);
		if(healcapamount == 0)
		{
			PlayerHasHealingGunHealCap[client] = 0;
		}
		else if(healcapamount >= 1)
		{
			PlayerHasHealingGunHealCap[client] = healcapamount;
		}
		else
		{
			PrintToServer("Command Syntax Error:");
			PrintToServer("wcs_healinggun healcap value only supports '0' and positive integer values");
			return Plugin_Continue;
		}


		char minamount_char[16];
		GetCmdArg(4, minamount_char, sizeof(minamount_char));
		int minhealamount = StringToInt(minamount_char);
		if(minhealamount == 0)
		{
			PlayerHasHealingGunMinHeal[client] = 0;
		}
		else if(minhealamount >= 1)
		{
			PlayerHasHealingGunMinHeal[client] = minhealamount;
		}
		else
		{
			PrintToServer("Command Syntax Error:");
			PrintToServer("wcs_healinggun minheal value only supports '0' and positive integer values");
			return Plugin_Continue;
		}


		char maxamount_char[16];
		GetCmdArg(5, maxamount_char, sizeof(maxamount_char));
		int maxhealamount = StringToInt(maxamount_char);
		if(maxhealamount == 0)
		{
			PlayerHasHealingGunMaxHeal[client] = 0;
		}
		else if(maxhealamount >= 1)
		{
			PlayerHasHealingGunMaxHeal[client] = maxhealamount;
		}
		else
		{
			PrintToServer("Command Syntax Error:");
			PrintToServer("wcs_healinggun maxheal value only supports '0' and positive integer values");
			return Plugin_Continue;
		}


		char damagereductionamount_char[16];
		GetCmdArg(6, damagereductionamount_char, sizeof(damagereductionamount_char));
		float damagereductionamount = StringToFloat(damagereductionamount_char);
		if(damagereductionamount <= 0.0)
		{
			PlayerHasHealingGunDamageReduction[client] = 0.00;
		}
		if(damagereductionamount > 0.00)
		{
			PlayerHasHealingGunDamageReduction[client] = damagereductionamount;
		}
		else
		{
			PrintToServer("Command Syntax Error:");
			PrintToServer("wcs_healinggun enemydamage only supports the following range of values: '0.00' to '1.00'");
			return Plugin_Continue;
		}

		PlayerHasHealingGun[client] = true;
	}

	return Plugin_Continue;
}









//////////////////////////////////////////////////////////////////////////////////////
// Purpose: Changes the player's model to a player model							//
// Command Usage: wcs_blackhole <userid> <damage> <Location 0 = self, 1 = aim>		//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_Blackhole(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(IsValidClient(client))
	{
		char damage_char[16];
		GetCmdArg(2, damage_char, sizeof(damage_char));
		int blackHoleDamage = StringToInt(damage_char);

		char amount_char[16];
		GetCmdArg(3, amount_char, sizeof(amount_char));
		int amount = StringToInt(amount_char);

		float BlackholePosition[3];

		if(amount == 0)
		{
			GetEntPropVector(client, Prop_Send, "m_vecOrigin", BlackholePosition);
			BlackholePosition[2] += 25;
		}
		else
		{
			float vecangles[3];
			float vecorigin[3];

			GetClientEyeAngles(client, vecangles);
			GetClientEyePosition(client, vecorigin);

			Handle traceray = TR_TraceRayFilterEx(vecorigin, vecangles, MASK_SHOT_HULL, RayType_Infinite, TraceRayFilter);

			if(TR_DidHit(traceray))
			{
				TR_GetEndPosition(BlackholePosition, traceray);
			}
		}


		int ColorRGBA[4] = {255, 255, 255, 255};
		TE_SetupBeamRingPoint(BlackholePosition, 250.0, 251.0, SpriteSheet_Ring_BlackHole, SpriteSheet_Ring_BlackHole, 0, 10, 6.0, 70.0, 0.0, ColorRGBA, 10, 0);
		TE_SendToAll();

		TE_SetupGlowSprite(BlackholePosition, SpriteSheet_Core_BlackHole, 6.0, 0.45, 255);
		TE_SendToAll();

		int initialTeam = 0;
		if(GetClientTeam(client) == 2)
		{
			initialTeam = 2;
		}
		else if(GetClientTeam(client) == 3)
		{
			initialTeam = 3;
		}

		int infoTargetEntity = CreateEntityByName("info_target");
		DispatchSpawn(infoTargetEntity);
		TeleportEntity(infoTargetEntity, BlackholePosition, NULL_VECTOR, NULL_VECTOR);

		BlackHoleEntity[infoTargetEntity] = 60;

		int initialRound = GameRules_GetProp("m_totalRoundsPlayed");

		DataPack pack = new DataPack();
		pack.WriteCell(client);
		pack.WriteCell(initialTeam);
		pack.WriteCell(infoTargetEntity);
		pack.WriteCell(blackHoleDamage);
		pack.WriteCell(initialRound);

		CreateTimer(0.1, Timer_BlackHoleActive, pack, TIMER_REPEAT);

		CreateTimer(6.0, Timer_RemoveEntity, infoTargetEntity);
	}
}


public Action Timer_BlackHoleActive(Handle timer, DataPack data)
{
	data.Reset();
	int client = data.ReadCell();
	int initialTeam = data.ReadCell();
	int infoTargetEntity = data.ReadCell();
	int blackHoleDamage = data.ReadCell();
	int initialRound = data.ReadCell();


	if(!IsValidClient(client))
	{
		if(IsValidEntity(infoTargetEntity))
		{
			AcceptEntityInput(infoTargetEntity, "Kill");
		}
		delete data;
		return Plugin_Stop;
	}


	int currentRound = GameRules_GetProp("m_totalRoundsPlayed");
	if(initialRound != currentRound)
	{
		if(IsValidEntity(infoTargetEntity))
		{
			AcceptEntityInput(infoTargetEntity, "Kill");
		}
		delete data;
		return Plugin_Stop;
	}


	if(BlackHoleEntity[infoTargetEntity] > 0)
	{
		BlackHoleEntity[infoTargetEntity] -= 1;
	}
	else
	{
		if(IsValidEntity(infoTargetEntity))
		{
			AcceptEntityInput(infoTargetEntity, "Kill");
		}
		delete data;
		return Plugin_Stop;
	}


	if(GetClientTeam(client) != initialTeam)
	{
		if(IsValidEntity(infoTargetEntity))
		{
			AcceptEntityInput(infoTargetEntity, "Kill");
		}
		delete data;
		return Plugin_Stop;
	}

	float BlackholePosition[3];
	GetEntPropVector(infoTargetEntity, Prop_Send, "m_vecOrigin", BlackholePosition);

	EntityIsBeingPulled(BlackholePosition, "weapon_*");
	EntityIsBeingPulled(BlackholePosition, "physics*");
	EntityIsBeingPulled(BlackholePosition, "prop_exploding_barrel");
	EntityIsBeingPulled(BlackholePosition, "flashbang_projectile");
	EntityIsBeingPulled(BlackholePosition, "hegrenade_projectile");
	EntityIsBeingPulled(BlackholePosition, "smokegrenade_projectile");

	// Loops through clients
	for(int i = 1 ;i <= MaxClients; i++)
	{
		if(!IsValidClient(i))
		{
			continue;
		}

		if(!IsPlayerAlive(i))
		{
			continue;
		}

		if(GetClientTeam(i) == initialTeam)
		{
			continue;
		}


		float PlayerPosition[3];
		
		GetEntPropVector(i, Prop_Send, "m_vecOrigin", PlayerPosition);

		float distance = GetVectorDistance(PlayerPosition, BlackholePosition);

		if(distance < 65.0)
		{
			ShakeScreen(i, 5.0, 0.1, 0.7);
			
			DealDamageBlackHole(i, blackHoleDamage, client);
		}

		if(distance < 750.0)
		{
			SetEntPropEnt(i, Prop_Data, "m_hGroundEntity", -1);

			ShakeScreen(i, 5.0, 0.1, 0.7);

			float Velocity[3];

			float Direction[3];

			float PushPower = 800.0 / distance;
			
			if(PushPower < 6.0)
			{
				PushPower = 6.0;
			}

			SubtractVectors(PlayerPosition, BlackholePosition, Direction);

			if(Direction[0] > 0.0)
			{
				if(Direction[0] > 150.0)
				{
					Direction[0] = 150.0;
				}
			}
			else
			{
				if(Direction[0] < -150.0)
				{
					Direction[0] = -150.0;
				}
			}


			if(Direction[1] > 0.0)
			{
				if(Direction[1] > 150.0)
				{
					Direction[1] = 150.0;
				}
			}
			else
			{
				if(Direction[1] < -150.0)
				{
					Direction[1] = -150.0;
				}
			}


			if(Direction[2] > 0.0)
			{
				if(Direction[2] > 150.0)
				{
					Direction[2] = 150.0;
				}
			}
			else
			{
				if(Direction[2] < -150.0)
				{
					Direction[2] = -150.0;
				}
			}

			GetEntPropVector(i, Prop_Data, "m_vecVelocity", Velocity);
			
			// Reverse the upside velocity
			if(Velocity[2] < 0.0)
			{
				Velocity[2] *= -1.0;
			}

			ScaleVector(Direction, PushPower);

			if(Direction[2] > 0.0)
			{
				if(Direction[2] > 900.0)
				{
					Direction[2] = 900.0;
				}
			}
			else
			{
				if(Direction[2] < -900.0)
				{
					Direction[2] = -900.0;
				}
			}

			NegateVector(Direction);

			TeleportEntity(i, NULL_VECTOR, NULL_VECTOR, Direction);
		}	
	}

	return Plugin_Continue;
}


void EntityIsBeingPulled(float BlackholePosition[3], const char[] classname)
{
	int entity = MaxClients + 1;

	while((entity = FindEntityByClassname(entity, classname)) != -1)
	{
		if(!IsValidEntity(entity))
		{
			continue;
		}

		float PropPosition[3]; 
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", PropPosition);
		
		float distance = GetVectorDistance(PropPosition, BlackholePosition);

		if(distance < 750.0)
		{
			float Velocity[3];

			float Direction[3];

			float PushPower = 800.0 / distance;
			
			if(PushPower < 6.0)
			{
				PushPower = 6.0;
			}

			SubtractVectors(PropPosition, BlackholePosition, Direction);

			if(Direction[0] > 0.0)
			{
				if(Direction[0] > 150.0)
				{
					Direction[0] = 150.0;
				}
			}
			else
			{
				if(Direction[0] < -150.0)
				{
					Direction[0] = -150.0;
				}
			}


			if(Direction[1] > 0.0)
			{
				if(Direction[1] > 150.0)
				{
					Direction[1] = 150.0;
				}
			}
			else
			{
				if(Direction[1] < -150.0)
				{
					Direction[1] = -150.0;
				}
			}


			if(Direction[2] > 0.0)
			{
				if(Direction[2] > 150.0)
				{
					Direction[2] = 150.0;
				}
			}
			else
			{
				if(Direction[2] < -150.0)
				{
					Direction[2] = -150.0;
				}
			}

			GetEntPropVector(entity, Prop_Data, "m_vecVelocity", Velocity);
			
			if(Velocity[2] < 0.0)
			{
				Velocity[2] *= -1.0;
			}

			ScaleVector(Direction, PushPower);

			if(Direction[2] > 0.0)
			{
				if(Direction[2] > 900.0)
				{
					Direction[2] = 900.0;
				}
			}
			else
			{
				if(Direction[2] < -900.0)
				{
					Direction[2] = -900.0;
				}
			}

			NegateVector(Direction);

			TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, Direction);
		}

		if(distance < 65.0)
		{
			AcceptEntityInput(entity, "Kill");
		}
	}
}




//////////////////////////////////////////////////////////////////////////////////////
// Command - Poison Smoke 															//
// - Usage: wcs_poisonsmoke <userid> <damage per tick (2 ticks per second)>			//
//////////////////////////////////////////////////////////////////////////////////////


public Action Command_PoisonSmoke(int args)
{
	char userid[128];
	GetCmdArg(1, userid, sizeof(userid));
	int client = StringToInt(userid);
	client = GetClientOfUserId(client);
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	char amount_char[16];
	GetCmdArg(2, amount_char, sizeof(amount_char));
	int amount = StringToInt(amount_char);
	if(amount <= 0)
	{
		PlayerHasPoisonSmokes[client] = 0;
		return Plugin_Continue;
	}
	else if(amount >= 1)
	{
		PlayerHasPoisonSmokes[client] = amount;
	}

	return Plugin_Continue;
}


public Action Timer_PoisonSmokeWithinProximity(Handle timer, DataPack data)
{
	data.Reset();
	int client = data.ReadCell();
	int initialTeam = data.ReadCell();
	int lightEntity = data.ReadCell();
	int poisonDamage = data.ReadCell();
	int initialRound = data.ReadCell();
	float smokeLocationX = data.ReadCell();
	float smokeLocationY = data.ReadCell();
	float smokeLocationZ = data.ReadCell();

	float smokeLocation[3];
	smokeLocation[0] = smokeLocationX;
	smokeLocation[1] = smokeLocationY;
	smokeLocation[2] = smokeLocationZ;

	if(!IsValidClient(client))
	{
		if(IsValidEntity(lightEntity))
		{
			AcceptEntityInput(lightEntity, "Kill");
		}
		delete data;
		return Plugin_Stop;
	}

	int currentRound = GameRules_GetProp("m_totalRoundsPlayed");
	if(initialRound != currentRound)
	{
		if(IsValidEntity(lightEntity))
		{
			AcceptEntityInput(lightEntity, "Kill");
		}
		delete data;
		return Plugin_Stop;
	}

	if(GetClientTeam(client) != initialTeam)
	{
		if(IsValidEntity(lightEntity))
		{
			AcceptEntityInput(lightEntity, "Kill");
		}
		delete data;
		return Plugin_Stop;
	}

	if(SmokeGrenadeEntity[lightEntity] > 0)
	{
		SmokeGrenadeEntity[lightEntity] -= 1;
	}
	else
	{
		if(IsValidEntity(lightEntity))
		{
			AcceptEntityInput(lightEntity, "Kill");
		}
		delete data;
		return Plugin_Stop;
	}

	float PlayerLocation[3];

	for(int i = 1 ;i <= MaxClients; i++)
	{
		if(!IsValidClient(i))
		{
			continue;
		}

		if(!IsPlayerAlive(i))
		{
			continue;
		}

		if(GetClientTeam(i) == GetClientTeam(client))
		{
			continue;
		}

		GetEntPropVector(i, Prop_Send, "m_vecOrigin", PlayerLocation);

		float distance = GetVectorDistance(smokeLocation, PlayerLocation);

		if(distance > 155.0)
		{
			continue;
		}

		DealDamagePoisonSmoke(i, poisonDamage, client);
	}

	return Plugin_Continue;
}


public void DealDamagePoisonSmoke(int client, int damage, int attacker)
{
	char DamageInt[16];

	IntToString(damage, DamageInt, 16);

	int EntityPointHurt = CreateEntityByName("point_hurt");

	if(EntityPointHurt)
	{
		DispatchKeyValue(client, "targetname", "DamageVictim");
		DispatchKeyValue(EntityPointHurt, "DamageTarget", "DamageVictim");
		DispatchKeyValue(EntityPointHurt, "Damage", DamageInt);
		DispatchKeyValue(EntityPointHurt, "DamageType", "DMG_GENERIC");
		DispatchSpawn(EntityPointHurt);
		AcceptEntityInput(EntityPointHurt, "Hurt", (attacker > 0) ? attacker : -1);
		DispatchKeyValue(EntityPointHurt, "classname", "");
		DispatchKeyValue(client, "targetname", "DamageDealer");
		RemoveEdict(EntityPointHurt);
	}
}



//////////////////////////////////////////////////////////////////////////////////////
// Purpose: Changes the player's model to a player model							//
// Command Usage: wcs_setmodelplayer <userid> <models/yourmodelpath/model.mdl>		//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_SetModelPlayer(int args)
{
	// Creates a variable named userid which we'll store our data within
	char userid[128];

	// Sets our userid variable to be the first argument in the command
	GetCmdArg(1, userid, sizeof(userid));

	// Converts the string to an integer and store that within client
	int client = StringToInt(userid);

	// Changes the client variable integer to something
	client = GetClientOfUserId(client);

	// If the player meets our criteria for validation then execute this section
	if(IsValidClient(client))
	{
		// If the player is alive then execute this section
		if(IsPlayerAlive(client))
		{
			char ModelPath[PLATFORM_MAX_PATH];

			GetCmdArg(2, ModelPath, sizeof(ModelPath));

			// Check if the model we intend to use is already precached, if not then execute this section
			if(!IsModelPrecached(ModelPath))
			{
				// Precache the model we intend to use
				PrecacheModel(ModelPath);
			}

			// Change the player's model to our precached model
			SetEntityModel(client, ModelPath);
		}
	}
}


//////////////////////////////////////////////////////////////////////////////////////
// Purpose: Changes the player's model to a prop model								//
// Command Usage: wcs_setmodelprop <userid> <models/yourmodelpath/model.mdl>		//
//////////////////////////////////////////////////////////////////////////////////////

public Action Command_SetModelProp(int args)
{
	// Creates a variable named userid which we'll store our data within
	char userid[128];

	// Sets our userid variable to be the first argument in the command
	GetCmdArg(1, userid, sizeof(userid));

	// Converts the string to an integer and store that within client
	int client = StringToInt(userid);

	// Changes the client variable integer to something
	client = GetClientOfUserId(client);

	// If the player meets our criteria for validation then execute this section
	if(IsValidClient(client))
	{
		char ModelPath[PLATFORM_MAX_PATH];

		GetCmdArg(2, ModelPath, sizeof(ModelPath));

		if (StrEqual(ModelPath, "0"))
		{
			if(GetClientTeam(client) == 2)
			{
				// Check if the model we intend to use is already precached, if not then execute this section
				if(!IsModelPrecached("models/weapons/t_arms_phoenix.mdl"))
				{
					PrecacheModel("models/weapons/t_arms_phoenix.mdl");
			 	}
				if(!IsModelPrecached("models/player/custom_player/legacy/tm_phoenix_varianta.mdl"))
				{
					PrecacheModel("models/player/custom_player/legacy/tm_phoenix_varianta.mdl");
				}

				SetEntityModel(client, "models/player/custom_player/legacy/tm_phoenix_varianta.mdl");
				SetEntPropString(client, Prop_Send, "m_szArmsModel", "models/weapons/t_arms_phoenix.mdl");
			}
			if(GetClientTeam(client) == 3)
			{
				// Check if the model we intend to use is already precached, if not then execute this section
				if(!IsModelPrecached("models/weapons/ct_arms_idf.mdl"))
				{
					PrecacheModel("models/weapons/ct_arms_idf.mdl");
			 	}
				if(!IsModelPrecached("models/player/ctm_idf_variantc.mdl"))
				{
					PrecacheModel("models/player/ctm_idf_variantc.mdl");
				}

				SetEntityModel(client, "models/player/ctm_idf_variantc.mdl");
				SetEntPropString(client, Prop_Send, "m_szArmsModel", "models/weapons/ct_arms_idf.mdl");
			}

			if(IsValidEntity(PlayerHasPropModel[client]))
			{
				SDKUnhook(PlayerHasPropModel[client], SDKHook_SetTransmit, Transmit_HideModelEntity);

				// Removes the player's prop model status
				PlayerHasPropModel[client] = -1;
			}

			// Creates a timer, which will remove any props attached to dead players
			//CreateTimer(0.0, CheckItems, client, TIMER_FLAG_NO_MAPCHANGE);
			CheckItems(client);
		}
		else
		{
			// Check if the model we intend to use is already precached, if not then execute this section
			if(!IsModelPrecached(ModelPath))
			{
				// Precache the model we intend to use
				PrecacheModel(ModelPath);
				PrecacheModel("models/player/custom_player/legacy/backwards/furry_invisible.mdl");
			}

			SetEntityModel(client, "models/player/custom_player/legacy/backwards/furry_invisible.mdl");

			char EntityID[64];
			char EntityName[64];

		 	int PropEntity = CreateEntityByName("prop_dynamic_override");
		 	
		 	Format(EntityID, sizeof(EntityID), "client%i", client);

			Format(EntityName, sizeof(EntityName), "prop_dynamic_override_%i", PropEntity);

		 	DispatchKeyValue(client, "targetname", EntityID);
		 	
			DispatchKeyValue(PropEntity, "targetname", EntityName);

			DispatchKeyValue(PropEntity, "parentname", EntityID);

			DispatchKeyValue(PropEntity, "model", ModelPath);

			DispatchKeyValue(PropEntity, "disablereceiveshadows", "1");

			DispatchKeyValue(PropEntity, "disableshadows", "1");
			
			DispatchKeyValue(PropEntity, "solid", "0");
			
			DispatchKeyValue(PropEntity, "spawnflags", "256");
			
			SetEntProp(PropEntity, Prop_Send, "m_CollisionGroup", 11);
			
			DispatchSpawn(PropEntity);

			SetEntProp(PropEntity, Prop_Send, "m_fEffects", EF_BONEMERGE|EF_NOSHADOW|EF_NORECEIVESHADOW|EF_PARENT_ANIMATES);

			SetVariantString("!activator");

			AcceptEntityInput(PropEntity, "SetParent", client, PropEntity);

			SetVariantString("primary");

			AcceptEntityInput(PropEntity, "SetParentAttachment", PropEntity, PropEntity, 0);   
			
			AcceptEntityInput(PropEntity, "TurnOn");

			EntityOwner[PropEntity] = client;

			PlayerHasPropModel[client] = EntityOwner[PropEntity];
			
			SDKHook(PropEntity, SDKHook_SetTransmit, Transmit_HideModelEntity);
		}
	}
}


public Action Transmit_HideModelEntity(int entity, int client)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	if(client == EntityOwner[entity])
	{
		return Plugin_Handled;
	}

	if(GetEntProp(client, Prop_Send, "m_iObserverMode") == 4)
	{
		if(GetEntPropEnt(client, Prop_Send, "m_hObserverTarget") == EntityOwner[entity])
		{
			return Plugin_Handled;
		}
	}

	return Plugin_Continue;
}



/* Thanks to BackWards for supplying us with this code, which made it possible to remove all attached
   props from a player upon their death. Along with coloring the prop without turning the player visible. */

#define LOOP_CHILDREN2(%1,%2) for (new %2=Entity_GetNextChild2(%1); %2 != INVALID_ENT_REFERENCE; %2=Entity_GetNextChild2(%1, ++%2))


stock Entity_GetParent2Name2(int entity, String:buffer[], size)
{
	return GetEntPropString(entity, Prop_Data, "m_iParent", buffer, size);
}

// public Action CheckItems(Handle timer, int client)
public Action CheckItems(int client)
{
	if(IsValidClient(client))
	{
		LOOP_CHILDREN2(client, child)
		{
			decl String:className[128];
			GetEntityClassname(child, className, sizeof(className));
		
			if(StrEqual(className, "prop_physics", false) || StrEqual(className, "prop_dynamic", false) || StrEqual(className, "prop_dynamic_override", false))
			{
				AcceptEntityInput(child, "Kill");
			}
		}
	}
	
	return Plugin_Continue;
}


stock Entity_GetParent2(int entity)
{
	return GetEntPropEnt(entity, Prop_Data, "m_pParent");
}


stock Entity_GetNextChild2(parent, start=0)
{
	for (int entity=start; entity <= 2048; entity++)
	{
		//if (!Entity_IsValid(entity))
		if(!IsValidEntity(entity))
		{
			continue;
		}

		if (entity > 0 && entity <= MaxClients && !IsClientConnected(entity))
		{
			continue;
		}

		if (Entity_GetParent2(entity) == parent)
		{
			return entity;
		}
	}

	return INVALID_ENT_REFERENCE;
}




/////////////////////////////////////
// - Downloading & Precachinging - //
/////////////////////////////////////

public void DownloadAndPrecacheFiles()
{
	// Used by the wcs_blackhole command
	SpriteSheet_Ring_BlackHole = PrecacheModel("sprites/water_drop.vmt");
	SpriteSheet_Core_BlackHole = PrecacheModel("sprites/splodesprite.vmt");


	////////////////////////////////
	// - Player Model Downloads - //
	////////////////////////////////

	AddFileToDownloadsTable("models/player/custom_player/legacy/backwards/furry_invisible.dx90.vtx");
	AddFileToDownloadsTable("models/player/custom_player/legacy/backwards/furry_invisible.mdl");
	AddFileToDownloadsTable("models/player/custom_player/legacy/backwards/furry_invisible.vvd");


	/////////////////////////////////
	// - Player Model Precaching - //
	/////////////////////////////////

	PrecacheModel("models/player/custom_player/legacy/backwards/furry_invisible.mdl");
	PrecacheModel("models/player/ctm_idf_variantc.mdl");
	PrecacheModel("models/player/custom_player/legacy/tm_phoenix_varianta.mdl");


	/////////////////////////////////////
	// - Player Arm Model Precaching - //
	/////////////////////////////////////

	PrecacheModel("models/weapons/ct_arms_idf.mdl");
	PrecacheModel("models/weapons/t_arms_phoenix.mdl");


	///////////////////////////////////
	// - Effect Materials Download - //
	///////////////////////////////////

	AddFileToDownloadsTable("materials/effects/blueblackflash_v2.vmt");
	AddFileToDownloadsTable("materials/effects/blueblackflash_v2.vtf");
	AddFileToDownloadsTable("materials/effects/blueflare1.vmt");
	AddFileToDownloadsTable("materials/effects/blueflare1.vtf");
	AddFileToDownloadsTable("materials/effects/bluelaser1.vmt");
	AddFileToDownloadsTable("materials/effects/bluelaser1.vtf");
	AddFileToDownloadsTable("materials/effects/bluemuzzle.vmt");
	AddFileToDownloadsTable("materials/effects/bluemuzzle.vtf");
	AddFileToDownloadsTable("materials/effects/com_shield003a.vmt");
	AddFileToDownloadsTable("materials/effects/combine_binocoverlay.vmt");
	AddFileToDownloadsTable("materials/effects/combine_binocoverlay.vtf");
	AddFileToDownloadsTable("materials/effects/combineshield/comshieldwall.vmt");
	AddFileToDownloadsTable("materials/effects/combineshield/comshieldwall.vtf");
	AddFileToDownloadsTable("materials/effects/combineshield/comshieldwall_close.vtf");
	AddFileToDownloadsTable("materials/effects/fluttercore_v2.vmt");
	AddFileToDownloadsTable("materials/effects/fluttercore_v2.vtf");
	AddFileToDownloadsTable("materials/effects/mh_blood1.vmt");
	AddFileToDownloadsTable("materials/effects/mh_blood1.vtf");
	AddFileToDownloadsTable("materials/effects/mh_blood2.vmt");
	AddFileToDownloadsTable("materials/effects/mh_blood2.vtf");
	AddFileToDownloadsTable("materials/effects/mh_blood3.vmt");
	AddFileToDownloadsTable("materials/effects/mh_blood3.vtf");
	AddFileToDownloadsTable("materials/effects/redflare_v2.vmt");
	AddFileToDownloadsTable("materials/effects/redflare_v2.vtf");
	AddFileToDownloadsTable("materials/effects/rollerglow.vmt");
	AddFileToDownloadsTable("materials/effects/rollerglow.vtf");
	AddFileToDownloadsTable("materials/effects/strider_dark_flare.vmt");
	AddFileToDownloadsTable("materials/effects/strider_dark_flare.vtf");
	AddFileToDownloadsTable("materials/effects/strider_muzzle.vmt");
	AddFileToDownloadsTable("materials/effects/strider_muzzle.vtf");
	AddFileToDownloadsTable("materials/effects/stunstick.vmt");
	AddFileToDownloadsTable("materials/effects/stunstick.vtf");
	AddFileToDownloadsTable("materials/effects/tp_eyefx/2tpeyefx_.vtf");
	AddFileToDownloadsTable("materials/effects/tp_eyefx/3tpeyefx_.vtf");
	AddFileToDownloadsTable("materials/effects/tp_eyefx/tp_eyefx.vmt");
	AddFileToDownloadsTable("materials/effects/tp_eyefx/tp_eyefx.vtf");
	AddFileToDownloadsTable("materials/effects/tp_eyefx/tpeye.vmt");
	AddFileToDownloadsTable("materials/effects/tp_eyefx/tpeye2.vmt");
	AddFileToDownloadsTable("materials/effects/tp_eyefx/tpeye3.vmt");
	AddFileToDownloadsTable("materials/effects/tp_eyefx/tpeye_.vtf");
	
	AddFileToDownloadsTable("materials/models/airboat/airboat_blur02.vmt");
	AddFileToDownloadsTable("materials/models/airboat/airboat_blur02.vtf");
	AddFileToDownloadsTable("materials/models/effects/comball_sphere.vmt");
	AddFileToDownloadsTable("materials/models/effects/comball_sphere.vtf");
	AddFileToDownloadsTable("materials/models/effects/comball_tape.vmt");
	AddFileToDownloadsTable("materials/models/effects/comball_tape.vtf");
	AddFileToDownloadsTable("materials/models/effects/splode1_sheet.vmt");
	AddFileToDownloadsTable("materials/models/effects/splode1_sheet.vtf");
	AddFileToDownloadsTable("materials/models/effects/splodecard2_sheet.vmt");
	AddFileToDownloadsTable("materials/models/effects/splodecard2_sheet.vtf");
	AddFileToDownloadsTable("materials/models/manhack/blur01.vmt");
	AddFileToDownloadsTable("materials/models/manhack/blur01.vtf");
	AddFileToDownloadsTable("materials/models/manhack/manhackblade001.vmt");
	AddFileToDownloadsTable("materials/models/manhack/manhackblade001.vtf");
	AddFileToDownloadsTable("materials/models/police/pupil_r.vmt");
	AddFileToDownloadsTable("materials/models/police/pupil_r.vtf");
	AddFileToDownloadsTable("materials/models/props_combine/masterinterface01c.vmt");
	AddFileToDownloadsTable("materials/models/props_combine/masterinterface01c.vtf");
	AddFileToDownloadsTable("materials/models/props_lab/cornerunit_cloud.vmt");
	AddFileToDownloadsTable("materials/models/props_lab/cornerunit_cloud.vtf");
	AddFileToDownloadsTable("materials/models/props_lab/teleportgate_fence.vmt");
	AddFileToDownloadsTable("materials/models/props_lab/teleportgate_fence.vtf");
	AddFileToDownloadsTable("materials/models/props_lab/warp_sheet.vmt");
	AddFileToDownloadsTable("materials/models/props_lab/warp_sheet.vtf");

	AddFileToDownloadsTable("materials/particle/fire.vmt");
	AddFileToDownloadsTable("materials/particle/fire.vtf");
	AddFileToDownloadsTable("materials/particle/smokesprites0199.vtf");
	AddFileToDownloadsTable("materials/particle/smokesprites0793.vtf");
	AddFileToDownloadsTable("materials/particle/smokesprites_0004.vmt");
	AddFileToDownloadsTable("materials/particle/smokesprites_0013.vmt");

	AddFileToDownloadsTable("materials/sprites/ar2_muzzle3_v2.vmt");
	AddFileToDownloadsTable("materials/sprites/ar2_muzzle3_v2.vtf");
	AddFileToDownloadsTable("materials/sprites/blackbeam.vmt");
	AddFileToDownloadsTable("materials/sprites/blackbeam.vtf");
	AddFileToDownloadsTable("materials/sprites/blueglow1.vmt");
	AddFileToDownloadsTable("materials/sprites/blueglow1.vtf");
	AddFileToDownloadsTable("materials/sprites/bluelaser1.vmt");
	AddFileToDownloadsTable("materials/sprites/bluelaser1.vtf");
	AddFileToDownloadsTable("materials/sprites/bluelight1.vmt");
	AddFileToDownloadsTable("materials/sprites/bluelight1.vtf");
	AddFileToDownloadsTable("materials/sprites/blueshaft1.vmt");
	AddFileToDownloadsTable("materials/sprites/blueshaft1.vtf");
	AddFileToDownloadsTable("materials/sprites/combineball_glow_blue_1.vmt");
	AddFileToDownloadsTable("materials/sprites/combineball_glow_blue_1.vtf");
	AddFileToDownloadsTable("materials/sprites/combineball_glow_red_1.vmt");
	AddFileToDownloadsTable("materials/sprites/combineball_glow_red_1.vtf");
	AddFileToDownloadsTable("materials/sprites/combineball_trail_blue_1.vmt");
	AddFileToDownloadsTable("materials/sprites/combineball_trail_blue_1.vtf");
	AddFileToDownloadsTable("materials/sprites/combineball_trail_red_1.vmt");
	AddFileToDownloadsTable("materials/sprites/combineball_trail_red_1.vtf");
	AddFileToDownloadsTable("materials/sprites/crystal_beam1.vmt");
	AddFileToDownloadsTable("materials/sprites/crystal_beam1.vtf");
	AddFileToDownloadsTable("materials/sprites/dot.vmt");
	AddFileToDownloadsTable("materials/sprites/dot.vtf");
	AddFileToDownloadsTable("materials/sprites/fire.vmt");
	AddFileToDownloadsTable("materials/sprites/fire.vtf");
	AddFileToDownloadsTable("materials/sprites/fire1.vmt");
	AddFileToDownloadsTable("materials/sprites/fire2.vmt");
	AddFileToDownloadsTable("materials/sprites/fireburst.vmt");
	AddFileToDownloadsTable("materials/sprites/fireburst/stmu0.vtf");
	AddFileToDownloadsTable("materials/sprites/flame01-.vtf");
	AddFileToDownloadsTable("materials/sprites/flame01.vmt");
	AddFileToDownloadsTable("materials/sprites/flamelet5.vmt");
	AddFileToDownloadsTable("materials/sprites/flamelet5.vtf");
	AddFileToDownloadsTable("materials/sprites/flames1/flame.vtf");
	AddFileToDownloadsTable("materials/sprites/flames2/fire.vtf");
	AddFileToDownloadsTable("materials/sprites/flare1.vmt");
	AddFileToDownloadsTable("materials/sprites/flare1.vtf");
	AddFileToDownloadsTable("materials/sprites/flatflame.vmt");
	AddFileToDownloadsTable("materials/sprites/flatflame.vtf");
	AddFileToDownloadsTable("materials/sprites/floorflame.vmt");
	AddFileToDownloadsTable("materials/sprites/floorflame.vtf");
	AddFileToDownloadsTable("materials/sprites/glow02.vmt");
	AddFileToDownloadsTable("materials/sprites/glow02.vtf");
	AddFileToDownloadsTable("materials/sprites/glow08.vmt");
	AddFileToDownloadsTable("materials/sprites/glow08.vtf");
	AddFileToDownloadsTable("materials/sprites/glow1.vmt");
	AddFileToDownloadsTable("materials/sprites/glow1.vtf");
	AddFileToDownloadsTable("materials/sprites/greenglow1.vmt");
	AddFileToDownloadsTable("materials/sprites/greenglow1.vtf");
	AddFileToDownloadsTable("materials/sprites/greenspit1.vmt");
	AddFileToDownloadsTable("materials/sprites/greenspit1.vtf");
	AddFileToDownloadsTable("materials/sprites/halo01.vmt");
	AddFileToDownloadsTable("materials/sprites/halo01.vtf");
	AddFileToDownloadsTable("materials/sprites/hydragutbeam.vmt");
	AddFileToDownloadsTable("materials/sprites/hydragutbeam.vtf");
	AddFileToDownloadsTable("materials/sprites/hydragutbeamcap.vmt");
	AddFileToDownloadsTable("materials/sprites/hydragutbeamcap.vtf");
	AddFileToDownloadsTable("materials/sprites/hydraspinalcord.vmt");
	AddFileToDownloadsTable("materials/sprites/hydraspinalcord.vtf");
	AddFileToDownloadsTable("materials/sprites/laser.vmt");
	AddFileToDownloadsTable("materials/sprites/laser.vtf");
	AddFileToDownloadsTable("materials/sprites/lgtning.vmt");
	AddFileToDownloadsTable("materials/sprites/lgtning.vtf");
	AddFileToDownloadsTable("materials/sprites/light_glow01.vmt");
	AddFileToDownloadsTable("materials/sprites/light_glow01.vtf");
	AddFileToDownloadsTable("materials/sprites/orangeflare1_v2.vmt");
	AddFileToDownloadsTable("materials/sprites/orangeflare1_v2.vtf");
	AddFileToDownloadsTable("materials/sprites/orangelight1_v2.vmt");
	AddFileToDownloadsTable("materials/sprites/orangelight1_v2.vtf");
	AddFileToDownloadsTable("materials/sprites/physcannon_bluecore1b_v2.vmt");
	AddFileToDownloadsTable("materials/sprites/physcannon_bluecore1b_v2.vtf");
	AddFileToDownloadsTable("materials/sprites/physcannon_blueflare1_v2.vmt");
	AddFileToDownloadsTable("materials/sprites/physcannon_blueflare1_v2.vtf");
	AddFileToDownloadsTable("materials/sprites/physcannon_bluelight1_v2.vmt");
	AddFileToDownloadsTable("materials/sprites/physcannon_bluelight1_v2.vtf");
	AddFileToDownloadsTable("materials/sprites/physcannon_bluelight1b_v2.vmt");
	AddFileToDownloadsTable("materials/sprites/physcannon_bluelight1b_v2.vtf");
	AddFileToDownloadsTable("materials/sprites/physring1-.vtf");
	AddFileToDownloadsTable("materials/sprites/physring1.vmt");
	AddFileToDownloadsTable("materials/sprites/plasma.vmt");
	AddFileToDownloadsTable("materials/sprites/plasma.vtf");
	AddFileToDownloadsTable("materials/sprites/plasma1.vmt");
	AddFileToDownloadsTable("materials/sprites/plasmabeam.vmt");
	AddFileToDownloadsTable("materials/sprites/plasmabeam.vtf");
	AddFileToDownloadsTable("materials/sprites/plasmaember.vmt");
	AddFileToDownloadsTable("materials/sprites/plasmaember.vtf");
	AddFileToDownloadsTable("materials/sprites/plasmahalo.vmt");
	AddFileToDownloadsTable("materials/sprites/plasmahalo.vtf");
	AddFileToDownloadsTable("materials/sprites/redglow1.vmt");
	AddFileToDownloadsTable("materials/sprites/redglow1.vtf");
	AddFileToDownloadsTable("materials/sprites/redglow3.vmt");
	AddFileToDownloadsTable("materials/sprites/redglow3.vtf");
	AddFileToDownloadsTable("materials/sprites/redglow4.vmt");
	AddFileToDownloadsTable("materials/sprites/redglow4.vtf");
	AddFileToDownloadsTable("materials/sprites/reticle_v2.vmt");
	AddFileToDownloadsTable("materials/sprites/reticle_v2.vtf");
	AddFileToDownloadsTable("materials/sprites/scanner.vmt");
	AddFileToDownloadsTable("materials/sprites/scanner.vtf");
	AddFileToDownloadsTable("materials/sprites/scanner_bottom.vmt");
	AddFileToDownloadsTable("materials/sprites/scanner_bottom.vtf");
	AddFileToDownloadsTable("materials/sprites/shellchrome.vmt");
	AddFileToDownloadsTable("materials/sprites/shellchrome.vtf");
	AddFileToDownloadsTable("materials/sprites/splodesprite.vmt");
	AddFileToDownloadsTable("materials/sprites/splodesprite.vtf");
	AddFileToDownloadsTable("materials/sprites/sprite_fire01.vmt");
	AddFileToDownloadsTable("materials/sprites/sprite_fire01_.vtf");
	AddFileToDownloadsTable("materials/sprites/strider_blackball.vmt");
	AddFileToDownloadsTable("materials/sprites/strider_blackball.vtf");
	AddFileToDownloadsTable("materials/sprites/strider_bluebeam.vmt");
	AddFileToDownloadsTable("materials/sprites/strider_bluebeam.vtf");
	AddFileToDownloadsTable("materials/sprites/tp_beam001.vmt");
	AddFileToDownloadsTable("materials/sprites/tp_beam001.vtf");
	AddFileToDownloadsTable("materials/sprites/water_drop.vmt");
	AddFileToDownloadsTable("materials/sprites/water_drop.vtf");
	AddFileToDownloadsTable("materials/sprites/xbeam2.vmt");
	AddFileToDownloadsTable("materials/sprites/xbeam2.vtf");
	AddFileToDownloadsTable("materials/sprites/yellowglow1.vmt");
	AddFileToDownloadsTable("materials/sprites/yellowglow1.vtf");


	/////////////////////////////////////
	// - Effect Materials Precaching - //
	/////////////////////////////////////

	PrecacheGeneric("materials/effects/combineshield/comshieldwall.vmt", true);
	PrecacheGeneric("materials/effects/blueblackflash_v2.vmt", true);
	PrecacheGeneric("materials/effects/blueflare1.vmt", true);
	PrecacheGeneric("materials/effects/bluelaser1.vmt", true);
	PrecacheGeneric("materials/effects/bluemuzzle.vmt", true);
	PrecacheGeneric("materials/effects/com_shield003a.vmt", true);
	PrecacheGeneric("materials/effects/combine_binocoverlay.vmt", true);
	PrecacheGeneric("materials/effects/fluttercore_v2.vmt", true);
	PrecacheGeneric("materials/effects/mh_blood1.vmt", true);
	PrecacheGeneric("materials/effects/mh_blood2.vmt", true);
	PrecacheGeneric("materials/effects/mh_blood3.vmt", true);
	PrecacheGeneric("materials/effects/redflare_v2.vmt", true);
	PrecacheGeneric("materials/effects/rollerglow.vmt", true);
	PrecacheGeneric("materials/effects/strider_dark_flare.vmt", true);
	PrecacheGeneric("materials/effects/strider_muzzle.vmt", true);
	PrecacheGeneric("materials/effects/stunstick.vmt", true);
	PrecacheGeneric("materials/effects/tp_eyefx/tp_eyefx.vmt", true);
	PrecacheGeneric("materials/effects/tp_eyefx/tpeye.vmt", true);
	PrecacheGeneric("materials/effects/tp_eyefx/tpeye2.vmt", true);
	PrecacheGeneric("materials/effects/tp_eyefx/tpeye3.vmt", true);

	PrecacheGeneric("materials/models/airboat/airboat_blur02.vmt", true);
	PrecacheGeneric("materials/models/effects/comball_sphere.vmt", true);
	PrecacheGeneric("materials/models/effects/comball_tape.vmt", true);
	PrecacheGeneric("materials/models/effects/splode1_sheet.vmt", true);
	PrecacheGeneric("materials/models/effects/splodecard2_sheet.vmt", true);
	PrecacheGeneric("materials/models/manhack/blur01.vmt", true);
	PrecacheGeneric("materials/models/manhack/manhackblade001.vmt", true);
	PrecacheGeneric("materials/models/police/pupil_r.vmt", true);
	PrecacheGeneric("materials/models/props_combine/masterinterface01c.vmt", true);
	PrecacheGeneric("materials/models/props_lab/cornerunit_cloud.vmt", true);
	PrecacheGeneric("materials/models/props_lab/teleportgate_fence.vmt", true);
	PrecacheGeneric("materials/models/props_lab/warp_sheet.vmt", true);

	PrecacheGeneric("materials/particle/fire.vmt", true);
	PrecacheGeneric("materials/particle/smokesprites_0004.vmt", true);
	PrecacheGeneric("materials/particle/smokesprites_0013.vmt", true);

	PrecacheGeneric("materials/sprites/ar2_muzzle3_v2.vmt", true);
	PrecacheGeneric("materials/sprites/blackbeam.vmt", true);
	PrecacheGeneric("materials/sprites/blueglow1.vmt", true);
	PrecacheGeneric("materials/sprites/bluelaser1.vmt", true);
	PrecacheGeneric("materials/sprites/bluelight1.vmt", true);
	PrecacheGeneric("materials/sprites/blueshaft1.vmt", true);
	PrecacheGeneric("materials/sprites/combineball_glow_blue_1.vmt", true);
	PrecacheGeneric("materials/sprites/combineball_glow_red_1.vmt", true);
	PrecacheGeneric("materials/sprites/combineball_trail_blue_1.vmt", true);
	PrecacheGeneric("materials/sprites/combineball_trail_red_1.vmt", true);
	PrecacheGeneric("materials/sprites/crystal_beam1.vmt", true);
	PrecacheGeneric("materials/sprites/dot.vmt", true);
	PrecacheGeneric("materials/sprites/fire.vmt", true);
	PrecacheGeneric("materials/sprites/fire1.vmt", true);
	PrecacheGeneric("materials/sprites/fire2.vmt", true);
	PrecacheGeneric("materials/sprites/fireburst.vmt", true);
	PrecacheGeneric("materials/sprites/flame01.vmt", true);
	PrecacheGeneric("materials/sprites/flamelet5.vmt", true);
	PrecacheGeneric("materials/sprites/flare1.vmt", true);
	PrecacheGeneric("materials/sprites/flatflame.vmt", true);
	PrecacheGeneric("materials/sprites/floorflame.vmt", true);
	PrecacheGeneric("materials/sprites/glow02.vmt", true);
	PrecacheGeneric("materials/sprites/glow08.vmt", true);
	PrecacheGeneric("materials/sprites/glow1.vmt", true);
	PrecacheGeneric("materials/sprites/greenglow1.vmt", true);
	PrecacheGeneric("materials/sprites/greenspit1.vmt", true);
	PrecacheGeneric("materials/sprites/halo01.vmt", true);
	PrecacheGeneric("materials/sprites/hydragutbeam.vmt", true);
	PrecacheGeneric("materials/sprites/hydragutbeamcap.vmt", true);
	PrecacheGeneric("materials/sprites/hydraspinalcord.vmt", true);
	PrecacheGeneric("materials/sprites/laser.vmt", true);
	PrecacheGeneric("materials/sprites/lgtning.vmt", true);
	PrecacheGeneric("materials/sprites/light_glow01.vmt", true);
	PrecacheGeneric("materials/sprites/orangeflare1_v2.vmt", true);
	PrecacheGeneric("materials/sprites/orangelight1_v2.vmt", true);
	PrecacheGeneric("materials/sprites/physcannon_bluecore1b_v2.vmt", true);
	PrecacheGeneric("materials/sprites/physcannon_blueflare1_v2.vmt", true);
	PrecacheGeneric("materials/sprites/physcannon_bluelight1_v2.vmt", true);
	PrecacheGeneric("materials/sprites/physcannon_bluelight1b_v2.vmt", true);
	PrecacheGeneric("materials/sprites/physring1.vmt", true);
	PrecacheGeneric("materials/sprites/plasma.vmt", true);
	PrecacheGeneric("materials/sprites/plasma1.vmt", true);
	PrecacheGeneric("materials/sprites/plasmabeam.vmt", true);
	PrecacheGeneric("materials/sprites/plasmaember.vmt", true);
	PrecacheGeneric("materials/sprites/plasmahalo.vmt", true);
	PrecacheGeneric("materials/sprites/redglow1.vmt", true);
	PrecacheGeneric("materials/sprites/redglow3.vmt", true);
	PrecacheGeneric("materials/sprites/redglow4.vmt", true);
	PrecacheGeneric("materials/sprites/reticle_v2.vmt", true);
	PrecacheGeneric("materials/sprites/scanner.vmt", true);
	PrecacheGeneric("materials/sprites/scanner_bottom.vmt", true);
	PrecacheGeneric("materials/sprites/shellchrome.vmt", true);
	PrecacheGeneric("materials/sprites/splodesprite.vmt", true);
	PrecacheGeneric("materials/sprites/sprite_fire01.vmt", true);
	PrecacheGeneric("materials/sprites/strider_blackball.vmt", true);
	PrecacheGeneric("materials/sprites/strider_bluebeam.vmt", true);
	PrecacheGeneric("materials/sprites/tp_beam001.vmt", true);
	PrecacheGeneric("materials/sprites/xbeam2.vmt", true);
	PrecacheGeneric("materials/sprites/yellowglow1.vmt", true);
	PrecacheGeneric("materials/sprites/water_drop.vmt", true);


	////////////////////////
	// - Sound Download - //
	////////////////////////

	AddFileToDownloadsTable("sound/skills/breathfire.mp3");
	AddFileToDownloadsTable("sound/skills/frostbolt.mp3");
	AddFileToDownloadsTable("sound/skills/hymn.mp3");
	AddFileToDownloadsTable("sound/skills/stancehealmonk.mp3");

	AddFileToDownloadsTable("sound/wcs/clearcast.mp3");
	AddFileToDownloadsTable("sound/wcs/defiance.mp3");
	AddFileToDownloadsTable("sound/wcs/divine.mp3");
	AddFileToDownloadsTable("sound/wcs/execute.mp3");
	AddFileToDownloadsTable("sound/wcs/firecast.mp3");
	AddFileToDownloadsTable("sound/wcs/fireloop.mp3");
	AddFileToDownloadsTable("sound/wcs/heal.mp3");
	AddFileToDownloadsTable("sound/wcs/invisibility.mp3");
	AddFileToDownloadsTable("sound/wcs/levelup.mp3");
	AddFileToDownloadsTable("sound/wcs/lightning.mp3");
	AddFileToDownloadsTable("sound/wcs/mole.mp3");
	AddFileToDownloadsTable("sound/wcs/resurrect.mp3");
	AddFileToDownloadsTable("sound/wcs/root.mp3");
	AddFileToDownloadsTable("sound/wcs/shadow.mp3");
	AddFileToDownloadsTable("sound/wcs/shamanisticrage.mp3");
	AddFileToDownloadsTable("sound/wcs/speed.mp3");
	AddFileToDownloadsTable("sound/wcs/teleport.mp3");
	AddFileToDownloadsTable("sound/wcs/tidetotem.mp3");
	AddFileToDownloadsTable("sound/wcs/tomes.mp3");
	AddFileToDownloadsTable("sound/wcs/vampiricstrike.mp3");
	AddFileToDownloadsTable("sound/wcs/zeal.mp3");


	//////////////////////////
	// - Sound Precaching - //
	//////////////////////////

	PrecacheSound("sound/skills/breathfire.mp3", true);
	PrecacheSound("sound/skills/frostbolt.mp3", true);
	PrecacheSound("sound/skills/hymn.mp3", true);
	PrecacheSound("sound/skills/stancehealmonk.mp3", true);
	
	PrecacheSound("sound/wcs/clearcast.mp3", true);
	PrecacheSound("sound/wcs/defiance.mp3", true);
	PrecacheSound("sound/wcs/divine.mp3", true);
	PrecacheSound("sound/wcs/execute.mp3", true);
	PrecacheSound("sound/wcs/firecast.mp3", true);
	PrecacheSound("sound/wcs/fireloop.mp3", true);
	PrecacheSound("sound/wcs/heal.mp3", true);
	PrecacheSound("sound/wcs/invisibility.mp3", true);
	PrecacheSound("sound/wcs/levelup.mp3", true);
	PrecacheSound("sound/wcs/lightning.mp3", true);
	PrecacheSound("sound/wcs/mole.mp3", true);
	PrecacheSound("sound/wcs/resurrect.mp3", true);
	PrecacheSound("sound/wcs/root.mp3", true);
	PrecacheSound("sound/wcs/shadow.mp3", true);
	PrecacheSound("sound/wcs/shamanisticrage.mp3", true);
	PrecacheSound("sound/wcs/speed.mp3", true);
	PrecacheSound("sound/wcs/teleport.mp3", true);
	PrecacheSound("sound/wcs/tidetotem.mp3", true);
	PrecacheSound("sound/wcs/tomes.mp3", true);
	PrecacheSound("sound/wcs/vampiricstrike.mp3", true);
	PrecacheSound("sound/wcs/zeal.mp3", true);
}
