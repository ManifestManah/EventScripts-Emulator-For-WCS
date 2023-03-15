# ============================================================================
# >> IMPORTS
# ============================================================================
# Python Imports
#   Math
import math
#   String
import string
#   Time
import time
#   Random
from random import choice
from random import randint

# Source.Python Imports
#   Colors
from colors import Color
#   Commands
from commands.server import ServerCommand
from commands.typed import TypedServerCommand
#   Core
from core import SOURCE_ENGINE_BRANCH
#   Cvars
from cvars import ConVar
#   Effects
from effects.base import TempEntity
#   Engines
from engines.precache import Model
from engines.server import queue_command_string
from engines.server import execute_server_command
from engines.trace import ContentMasks
from engines.trace import engine_trace
from engines.trace import GameTrace
from engines.trace import Ray
from engines.trace import TraceFilterSimple
#   Entities
from entities import BaseEntityGenerator
from entities import CheckTransmitInfo
from entities import TakeDamageInfo
from entities.constants import DamageTypes
from entities.constants import MoveType
from entities.entity import Entity
from entities.helpers import index_from_edict
from entities.helpers import index_from_inthandle
from entities.helpers import index_from_pointer
from entities.helpers import inthandle_from_pointer
from entities.hooks import EntityCondition
from entities.hooks import EntityPreHook
#   Events
from events import Event
from events.hooks import PreEvent
#   Filters
from filters.players import PlayerIter
from filters.recipients import RecipientFilter
#   Listeners
from listeners.tick import Delay
from listeners.tick import Repeat
from listeners.tick import RepeatStatus
#   Mathlib
from mathlib import Vector,QAngle
#   Memory
from memory import make_object
#   Messages
from messages import Fade
from messages import FadeFlags
from messages import HudMsg
from messages import SayText2
from messages import TextMsg
from messages.base import Shake
#   Players
from players.entity import Player
from players.helpers import userid_from_edict
from players.helpers import index_from_userid
from players.helpers import playerinfo_from_userid
from players.helpers import index_from_playerinfo
from players.helpers import userid_from_index
from players.helpers import edict_from_userid
from players.helpers import inthandle_from_userid
from players.helpers import playerinfo_from_index
#   Weapons
from weapons.entity import Weapon
# WCS Imports
from wcs.core.helpers.esc.converts import convert_userid_to_player
from wcs.core.players.entity import Player as WCSPlayer
from wcs import wcsgroup
# Headshot Immunity
from players.constants import HitGroup


# =============================================================================
# >> GLOBAL VARIABLES
# =============================================================================
#entity_health = {}
#_game_models = {}

weapon_list = ["weapon_ak47","weapon_aug","weapon_awp","weapon_bizon","weapon_c4","weapon_cz75a","weapon_deagle","weapon_decoy","weapon_elite","weapon_famas","weapon_fiveseven","weapon_flashbang","weapon_g3sg1","weapon_galil","weapon_galilar","weapon_glock","weapon_hegrenade","weapon_incgrenade","weapon_hkp2000","weapon_knife","weapon_m249","weapon_m3","weapon_m4a1","weapon_m4a1_silencer","weapon_mac10","weapon_mag7","weapon_molotov","weapon_mp5navy","weapon_mp7","weapon_mp9","weapon_negev","weapon_nova","weapon_p228","weapon_p250","weapon_p90","weapon_sawedoff","weapon_scar17","weapon_scar20","weapon_scout","weapon_sg550","weapon_sg552","weapon_sg556","weapon_ssg08","weapon_smokegrenade","weapon_taser","weapon_tec9","weapon_tmp","weapon_ump45","weapon_usp","weapon_usp_silencer","weapon_xm1014","weapon_revolver"]

#anti_falldamage = {}
repeat_dict = {}
for player in PlayerIter('all'):
    repeat_dict[player.userid] = 0





# =============================================================================
# >> SOURCEPAWN SERVER COMMANDS - WCS_SETFX
# =============================================================================


# Gives the player an absorption shield which has to first be broken before the player can take damage
@TypedServerCommand(["wcs_setfx", "absorptionshield"])
def wcs_setfx_absorptionshield(command_info, player:convert_userid_to_player, operator:str, value:int, time:float=0):
    queue_command_string('wcs_caller_setfxabsorptionshield %s %s %s %s' % (player.userid, operator, value, time))

# Lets the player use any pistol as if it was automatic, allowing the player to hold down their shooting key
@TypedServerCommand(["wcs_setfx", "automaticpistols"])
def wcs_setfx_automaticpistols(command_info, player:convert_userid_to_player, operator:str, value:int, time:float=0):
    queue_command_string('wcs_caller_setfxautomaticpistols %s %s %s %s' % (player.userid, operator, value, time))

# Modifies the player's FOV and applies a blurring texture on the player's screen at the same time
@TypedServerCommand(["wcs_setfx", "banish"])
def wcs_setfx_banish(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxbanish %s %s %s %s' % (player.userid, operator, value, time))

# Applies a blurring overlay to the player's screen making it harder to see
@TypedServerCommand(["wcs_setfx", "blur"])
def wcs_setfx_blur(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxblur %s %s %s %s' % (player.userid, operator, value, time))

# Reduces the damage the player takes from being shot in the body
@TypedServerCommand(["wcs_setfx", "bodyshotimmunity"])
def wcs_setfx_bodyshotimmunity(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxbodyshotimmunity %s %s %s %s' % (player.userid, operator, value, time))

# Changes the player's alpha color value while the player crouches
@TypedServerCommand(["wcs_setfx", "crouchinvisibility"])
def wcs_setfx_crouchinvisibility(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxcrouchinvisibility %s %s %s %s' % (player.userid, operator, value, time))

# Lets the player perform a second jump
@TypedServerCommand(["wcs_setfx", "doublejump"])
def wcs_setfx_doublejump(command_info, player:convert_userid_to_player, operator:str, value:int, time:float=0):
    queue_command_string('wcs_caller_setfxdoublejump %s %s %s %s' % (player.userid, operator, value, time))

# Contineously applies different colored fade overlays to the player's screen
@TypedServerCommand(["wcs_setfx", "drug"])
def wcs_setfx_drug(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxdrug %s %s %s %s' % (player.userid, operator, value, time))

# Causes the player's screen to contineously tilt in random angles 
@TypedServerCommand(["wcs_setfx", "drunk"])
def wcs_setfx_drunk(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxdrunk %s %s %s %s' % (player.userid, operator, value, time))

# Reduces the damage the player takes from falling
@TypedServerCommand(["wcs_setfx", "falldamage"])
def wcs_setfx_falldamage(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxfalldamage %s %s %s %s' % (player.userid, operator, value, time))

# Changes the way the player is being rendered, below is a list of the different value numbers and what they each do
# 0 - Disable Flickering
# 1 - Quick Flicker (100% visible to 100% invisible in a blink)
# 2 - Flickering but with stutters (100% visible to 100% invisible in a blink)
# 3 - Super Quick Flickering
# 4 - Quick Flicker (Gradually becoming more transparent, then re-apparent)
# 5 - Fully Invisible, Only Footprint Shadows are left 
@TypedServerCommand(["wcs_setfx", "flickering"])
def wcs_setfx_flickering(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxflicker %s %s %s %s' % (player.userid, operator, value, time))

# Changes the player's fov (Field of view)
@TypedServerCommand(["wcs_setfx", "fov"])
def wcs_setfx_fov(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxfov %s %s %s %s' % (player.userid, operator, value, time))

# Reduces the damage the player takes from being shot in the head
@TypedServerCommand(["wcs_setfx", "headshotimmunity"])
def wcs_setfx_headshotimmunity(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxheadshotimmunity %s %s %s %s' % (player.userid, operator, value, time))

# Causes the player to lose the specified amount of health every second until death or till cancelled
@TypedServerCommand(["wcs_setfx", "healthdecay"])
def wcs_setfx_healthdecay(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxhealthdecay %s %s %s %s' % (player.userid, operator, value, time))

# Puts the player in noclip mode, but the player can still take damage and be killed, the player also deals reduced damage while in noclip
@TypedServerCommand(["wcs_setfx", "noclip"])
def wcs_setfx_noclip(command_info, player:convert_userid_to_player, operator:str, value:int, time:float=0):
    queue_command_string('wcs_caller_setfxnoclip %s %s %s %s' % (player.userid, operator, value, time))

# Removes recoil and spread from the player
@TypedServerCommand(["wcs_setfx", "norecoilsm"])
def wcs_setfx_norecoilsm(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxnorecoilsm %s %s %s %s' % (player.userid, operator, value, time))

# Prevents the player from using the scope
@TypedServerCommand(["wcs_setfx", "noscope"])
def wcs_setfx_noscope(command_info, player:convert_userid_to_player, operator:str, value:int, time:float=0):
    queue_command_string('wcs_caller_setfxnoscope %s %s %s %s' % (player.userid, operator, value, time))

# Makes the player unable to move or perform any actions
@TypedServerCommand(["wcs_setfx", "paralyze"])
def wcs_setfx_paralyze(command_info, player:convert_userid_to_player, operator:str, value:int, time:float=0):
    queue_command_string('wcs_caller_setfxparalyze %s %s %s %s' % (player.userid, operator, value, time))

# Lets the player plant the bomb anywhere on the map
@TypedServerCommand(["wcs_setfx", "plantbombanywhere"])
def wcs_setfx_plantbombanywhere(command_info, player:convert_userid_to_player, operator:str, value:int, time:float=0):
    queue_command_string('wcs_caller_setfxplantbombanywhere %s %s %s %s' % (player.userid, operator, value, time))

# Lets the player instantly defuse the bomb
@TypedServerCommand(["wcs_setfx", "quickdefuse"])
def wcs_setfx_quickdefuse(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxquickdefuse %s %s %s %s' % (player.userid, operator, value, time))

# Lets the player explode the bomb instantly once it has been planted
@TypedServerCommand(["wcs_setfx", "quickexplode"])
def wcs_setfx_quickexplode(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxquickexplode %s %s %s %s' % (player.userid, operator, value, time))

# Lets the player instantly plant the bomb
@TypedServerCommand(["wcs_setfx", "quickplant"])
def wcs_setfx_quickplant(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxquickplant %s %s %s %s' % (player.userid, operator, value, time))

# Prevents the player from scoping for more than 0.25 seconds at a time, forcing the player to quick-scope
@TypedServerCommand(["wcs_setfx", "quickscope"])
def wcs_setfx_quickscope(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
    queue_command_string('wcs_caller_setfxquickscope %s %s %s %s' % (player.userid, operator, value, time))

# Reveals all the players on the opposite team by showing them on the radar to the entire team
# @TypedServerCommand(["wcs_setfx", "radarreveal"])
# def wcs_setfx_radarreveal(command_info, player:convert_userid_to_player, operator:str, value:float, time:float=0):
#    queue_command_string('wcs_caller_setfxradarreveal %s %s %s %s' % (player.userid, operator, value, time))

# Gives you the same  primary weapon, secondary weapon, defuse kit, armor and helmet next time you spawn
@TypedServerCommand(["wcs_setfx", "reincarnation"])
def wcs_setfx_reincarnation(command_info, player:convert_userid_to_player, operator:str, value:int, time:float=0):
    queue_command_string('wcs_caller_setfxreincarnation %s %s %s %s' % (player.userid, operator, value, time))

# Reverses the movement keys for the player, making W move you backwards, S is forwards, D is left and A becomes right
@TypedServerCommand(["wcs_setfx", "reversemovement"])
def wcs_setfx_reversemovement(command_info, player:convert_userid_to_player, operator:str, value:int, time:float=0):
    queue_command_string('wcs_caller_setfxreversemovement %s %s %s %s' % (player.userid, operator, value, time))

# Lets the player play in a third person perspective
@TypedServerCommand(["wcs_setfx", "thirdperson"])
def wcs_setfx_thirdperson(command_info, player:convert_userid_to_player, operator:str, value:int, time:float=0):
    queue_command_string('wcs_caller_setfxthirdperson %s %s %s %s' % (player.userid, operator, value, time))




# =============================================================================
# >> SOURCEPAWN SERVER COMMANDS - REGULAR
# =============================================================================



#@TypedServerCommand(["wcs_particleeffectplayer"])
#def wcs_particleeffectplayer(command_info, particlename:str, time:float=0, player:convert_userid_to_player):
#    queue_command_string('wcs_caller_particleeffectplayer %s %s %s' % (particlename, time, player.userid))


#@TypedServerCommand(["wcs_particleeffectlocation"])
#def wcs_particleeffectlocation(command_info, particlename:str, time:float=0, x:float, y:float, z:float):
#    queue_command_string('wcs_caller_particleeffectlocation %s %s %s %s %s' % (particlename, time, x, y, z))



# Creates a black hole which will suck in players, physic props, weapons and thrown grenades
@TypedServerCommand(["wcs_blackhole"])
def wcs_blackhole(command_info, player:convert_userid_to_player, value:int, location:int):
    queue_command_string('wcs_caller_blackhole %s %s %s' % (player.userid, value, location))


# 
# @TypedServerCommand(["wcs_resist"])
# def wcs_resist(command_info, player:convert_userid_to_player, weaponclassname:str, value:int):
#     queue_command_string('wcs_caller_resist %s %s %s' % (player.userid, weaponclassname, value))


# The player's smoke grenades becomes poisonous, dealing X damage two times per second to enemies inside the smoke
@TypedServerCommand(["wcs_poisonsmoke"])
def wcs_poisonsmoke(command_info, player:convert_userid_to_player, value:int):
    queue_command_string('wcs_caller_poisonsmoke %s %s' % (player.userid, value))


# Shooting teammates will heal the player and you deal 50% reduced damage to enemies 
@TypedServerCommand(["wcs_healinggun"])
def wcs_healinggun(command_info, player:convert_userid_to_player, toggle:int, healcap:int, minheal:int, maxheal:int, reducedattackdamage:float=0):
    queue_command_string('wcs_caller_healinggun %s %s %s %s %s %s' % (player.userid, toggle, healcap, minheal, maxheal, reducedattackdamage))


# A Push based teleport which brings the player in the direction of their crosshair
@TypedServerCommand(["wcs_teleport_push"])
def wcs_teleport_push(command_info, player:convert_userid_to_player, value:int):
    queue_command_string('wcs_caller_teleportpush %s %s' % (player.userid, value))


# Switches you to the opposing team without dying
@TypedServerCommand(["wcs_switchteam"])
def wcs_switchteam(command_info, player:convert_userid_to_player):
    queue_command_string('wcs_caller_switchteam %s' % (player.userid))


# Spawns an explosive barrel at the location where the player aims 
@TypedServerCommand(["wcs_prop_explosive_barrel"])
def wcs_prop_explosive_barrel(command_info, player:convert_userid_to_player):
    queue_command_string('wcs_caller_prop_explosive_barrel %s' % (player.userid))


# Spawns an explosive barrel at the location where the player aims 
@TypedServerCommand(["wcs_prop_dynamic_destructible"])
def wcs_prop_dynamic_destructible(command_info, player:convert_userid_to_player, modelpath:str, value:int):
    queue_command_string('wcs_caller_prop_dynamic_destructible %s %s %s' % (player.userid, modelpath, value))


# Spawns a destructible prop_physics entity at the location where the player aims
@TypedServerCommand(["wcs_prop_physics_destructible"])
def wcs_prop_physics_destructible(command_info, player:convert_userid_to_player, modelpath:str, value:int):
    queue_command_string('wcs_caller_prop_physics_destructible %s %s %s' % (player.userid, modelpath, value))


# Precaches and changes the player's model to a specified prop model, the model can also be colored without making the player visible
@TypedServerCommand(["wcs_setmodelprop"])
def wcs_setmodelprop(command_info, player:convert_userid_to_player, modelpath:str):
    queue_command_string('wcs_caller_setmodelprop %s %s' % (player.userid, modelpath))


# Precaches and changes the player's model to a specified player model 
@TypedServerCommand(["wcs_setmodelplayer"])
def wcs_setmodelplayer(command_info, player:convert_userid_to_player, modelpath:str):
    queue_command_string('wcs_caller_setmodelplayer %s %s' % (player.userid, modelpath))


# Obtains whether or not the player is currently ducking, returns 1 for true and 0 for false
@TypedServerCommand('wcs_getducking')
def wcs_getducking(command_info, wcsplayer:convert_userid_to_player, var:ConVar):
    if wcsplayer is None:
        var.set_int(0)
        return
    var.set_int(wcsgroup.getUser(wcsplayer.userid,'is_ducking'))


# Obtains the player's gravitty value
@TypedServerCommand('wcs_getgravity')
def wcs_getgravity(command_info, wcsplayer:convert_userid_to_player, var:ConVar):
    if wcsplayer is None:
        var.set_int(0)
        return
    var.set_float(wcsplayer.gravity)
#    SayText2('Var: %s' % var).send()








# =============================================================================
# >> SERVER COMMANDS
# =============================================================================



# Thanks to Predz for the improved version of Push Teleport
#@ServerCommand(["wcs_teleport_push_new"])
#def _on_teleport_command(command):
#    userid = command[1]
#    magnitude = command[2]
#
#    if type(userid) != int:
#        userid = int(userid)
#
#    if type(magnitude) != int:
#        magnitude = int(magnitude)
#
#    player = Player.from_userid(userid)
#    player.push(magnitude, magnitude)



# Works and also provides the position math for wcs_doteleport
@ServerCommand('wcs_teleport')
def _wcs_teleport(command):
    userid = int(command[1])
    x = float(command[2])
    y = float(command[3])
    z = float(command[4])
    target_location = Vector(x,y,z,)
    player = Player.from_userid(userid)
    origin = player.origin
    angles = QAngle(*player.get_property_vector('m_angAbsRotation'))
    forward = Vector()
    right = Vector()
    up = Vector()
    angles.get_angle_vectors(forward, right, up)
    forward.normalize()
    forward *= 10.0
    loop_limit = 100
    can_teleport = 1
    while is_player_stuck(player.index, target_location):
        target_location -= forward
        loop_limit -= 1
        if target_location.get_distance(origin) <= 10.0 or loop_limit < 1:
            can_teleport = 0
            break
    if can_teleport == 1:
        player.teleport(target_location,None,None)


# Tested and Works
@ServerCommand('wcs_doteleport')
def _doteleport_command(command):
    userid = int(command[1])
    if exists(userid):
        player = Player.from_userid(userid)
        view_vector = player.view_coordinates
        queue_command_string('wcs_teleport %s %s %s %s' % (userid, view_vector[0], view_vector[1], view_vector[2]))




#@ServerCommand('wcs_getviewcoords')
#def viewcoord(command):
#    userid = int(command[1])
#    xvar = str(command[2])
#    yvar = str(command[3])
#    zvar = str(command[4])
#    if exists(userid):
#        player = Player(index_from_userid(userid))
#        view_vec = player.get_view_coordinates()
#        ConVar(xvar).set_float(view_vec[0])
#        ConVar(yvar).set_float(view_vec[1])
#        ConVar(zvar).set_float(view_vec[2])





#@ServerCommand('wcs_setmodel')
#def set_model(command):
#    userid = int(command[1])
#    model = str(command[2])

#    if model == '0':
#        inthandle = _remove_model(userid)

#        if inthandle is not None:
#            Player.from_userid(userid).color = Color(255, 255, 255, 255)

#        return

#    _remove_model(userid)

#    if 'models/' not in model:
#        model = 'models/' + model

#    player = Player.from_userid(userid)
#    player.color = Color(255, 255, 255, 0)

#    model = Model(model)

#    entity = Entity.create('prop_dynamic_override')
#    entity.origin = player.origin
#    entity.parent = player
#    entity.set_model(model)
#    entity.spawn()

#    _game_models[entity.inthandle] = player.userid

#    entity.add_output('OnUser1 !self,Kill,,0,1')


#def _remove_model(userid):
#    for inthandle in _game_models:
#        if userid == _game_models[inthandle]:
#            try:
#                index = index_from_inthandle(inthandle)
#            except ValueError:
#                pass
#            else:
#                entity = Entity(index)

#                entity.clear_parent()
#                entity.call_input('FireUser1', '1')
#            finally:
#                del _game_models[inthandle]

#            return inthandle

#    return None


# =============================================================================
# >> Kami's - Poison smoke grenade
# =============================================================================
#@ServerCommand('poison_smoke')
#def poison_smoke(command):
    # poison_smoke <x> <y> <z> <userid> <range> <damage> <delay> <duration>
#    do_poison_smoke(Vector(float(command[1]),float(command[2]),float(command[3])),int(command[4]),float(command[5]),int(command[6]),float(command[7]),float(command[8]))


#def do_poison_smoke(position,userid,range,damage,delay,duration):
#    attacker = Player.from_userid(int(userid))
#    duration = duration - delay
#    for player in PlayerIter('all'):
#        if player.origin.get_distance(position) <= range:
#            player.take_damage(damage,attacker_index=attacker.index, weapon_index=None)
#    if duration > 0:
#        Delay(delay,do_poison_smoke,(position,userid,range,damage,delay,duration))


# =============================================================================
# >> Headshot Immunity
# =============================================================================

#@ServerCommand('wcs_headshot_immunity')
#def headshot_immunity(command):
#    userid = int(command[1])
#    amount = float(command[2])
#    if exists(userid):
#        wcsgroup.setUser(userid,'headshot_immunity',amount)


#@PreEvent('player_hurt')
#def pre_hurt(ev):
#    victim = Player.from_userid(int(ev['userid']))
#    if ev['attacker'] > 1:
#        damage = int(ev['dmg_health'])
#        headshot_immunity = wcsgroup.getUser(victim.userid,'headshot_immunity')
#        if headshot_immunity != None:
#            if victim.hitgroup == HitGroup.HEAD:
#                headshot_immunity = float(headshot_immunity)
#                if headshot_immunity > 0:
#                    headshot_immunity_dmg = damage*headshot_immunity
#                    if int(headshot_immunity_dmg) > 0:
#                        victim.health += int(headshot_immunity_dmg)
#                         wcs.wcs.tell(victim.userid,'\x04[WCS] \x05Your headshot immunity prevented %s damage!' % int(headshot_immunity_dmg))


# =============================================================================
# >> HOOKS
# =============================================================================
#@EntityPreHook(EntityCondition.equals_entity_classname('prop_physics_multiplayer'), 'on_take_damage')
#def take_damage_hook(stack_data):
#    take_damage_info = make_object(TakeDamageInfo, stack_data[1])
#    victim = make_object(Entity, stack_data[0])
#    if victim.index in entity_health:
#        damage = take_damage_info.damage
#        if entity_health[victim.index] <= 0:
#            Delay(0.1,victim.remove)
#        else:
#            entity_health[victim.index] -= damage
#    else:
#        return


# TODO: Only register this callback when _game_models is populated
#@EntityPreHook(EntityCondition.equals_entity_classname('prop_dynamic_override'), 'set_transmit')
#def pre_set_transmit(stack):
#    if _game_models:
#        inthandle = inthandle_from_pointer(stack[0])
#        userid = _game_models.get(inthandle)

#        if userid is not None:
#            target = userid_from_edict(make_object(CheckTransmitInfo, stack[1]).client)

#            if target == userid:
#                return False


# =============================================================================
# >> EVENTS
# =============================================================================
@Event('player_activate')
def player_activate(ev):
    repeat_dict[ev['userid']] = 0


@Event('player_death')
def player_death(ev):
    if valid_repeat(repeat_dict[ev['userid']]):
        repeat_dict[ev['userid']].stop()
        repeat_dict[ev['userid']] = 0

    # _remove_model(ev['userid'])

    # userid = ev['userid']

    # for inthandle in list(_game_models.keys()):
    #     if _game_models[inthandle] == userid:
    #         try:
    #             index = index_from_inthandle(inthandle)
    #         except ValueError:
    #             pass
    #         else:
    #             Entity(index).call_input('FireUser1', '1')
    #         finally:
    #             del _game_models[inthandle]


#@Event('round_prestart')
#def round_prestart(event):
#    _game_models.clear()


@Event('round_end')
def round_end(ev):
    for user in repeat_dict:
        if valid_repeat(repeat_dict[user]):
            repeat_dict[user].stop()
            repeat_dict[user] = 0
    for player in PlayerIter('all'):
        wcsplayer = WCSPlayer.from_userid(player.userid)

        for weapon in weapon_list:
            wcsplayer.data['resist_' + weapon] = 0.0


@Event('player_spawn')
def player_spawn(ev):
    if ev['userid'] not in repeat_dict:
        repeat_dict[ev['userid']] = 0
    if repeat_dict[ev['userid']] != 0:
        repeat_dict[ev['userid']].stop()
        repeat_dict[ev['userid']] = 0


# =============================================================================
# >> HELPER FUNCTIONS
# =============================================================================
def check_space(position, mins, maxs):
    mask = ContentMasks.ALL
    generator = BaseEntityGenerator
    ray = Ray(position, position, mins, maxs)

    trace = GameTrace()
    engine_trace.trace_ray(ray, mask, TraceFilterSimple(generator()), trace)
    return trace


def exists(userid):
    try:
        index_from_userid(userid)
    except ValueError:
        return False
    return True


def is_player_stuck(player_index, origin):
    '''Return whether or not the given player is stuck in solid.'''

    # Get the player's PlayerInfo instance...
    player_info = playerinfo_from_index(player_index)

    # Get the player's origin...
    origin = player_info.origin

    # Get a Ray object based on the player physic box...
    ray = Ray(origin, origin, player_info.mins, player_info.maxs)

    # Get a new GameTrace instance...
    trace = GameTrace()

    # Do the trace...
    engine_trace.trace_ray(ray, ContentMasks.PLAYER_SOLID, TraceFilterSimple(
        PlayerIter()), trace)

    # Return whether or not the trace did hit...
    return trace.did_hit()


def valid_repeat(repeat):
    try:
        if repeat.status == RepeatStatus.RUNNIN:
            return True
    except:
        return False
