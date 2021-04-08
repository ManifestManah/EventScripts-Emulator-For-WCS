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
from wcs.core.players.entity import Player as WCSPlayer
from wcs import wcsgroup
# Headshot Immunity
from players.constants import HitGroup


# =============================================================================
# >> GLOBAL VARIABLES
# =============================================================================
entity_health = {}
_game_models = {}

weapon_list = ["weapon_ak47","weapon_aug","weapon_awp","weapon_bizon","weapon_c4","weapon_cz75a","weapon_deagle","weapon_decoy","weapon_elite","weapon_famas","weapon_fiveseven","weapon_flashbang","weapon_g3sg1","weapon_galil","weapon_galilar","weapon_glock","weapon_hegrenade","weapon_incgrenade","weapon_hkp2000","weapon_knife","weapon_m249","weapon_m3","weapon_m4a1","weapon_m4a1_silencer","weapon_mac10","weapon_mag7","weapon_molotov","weapon_mp5navy","weapon_mp7","weapon_mp9","weapon_negev","weapon_nova","weapon_p228","weapon_p250","weapon_p90","weapon_sawedoff","weapon_scar17","weapon_scar20","weapon_scout","weapon_sg550","weapon_sg552","weapon_sg556","weapon_ssg08","weapon_smokegrenade","weapon_taser","weapon_tec9","weapon_tmp","weapon_ump45","weapon_usp","weapon_usp_silencer","weapon_xm1014","weapon_revolver"]

anti_falldamage = {}
repeat_dict = {}
for player in PlayerIter('all'):
    repeat_dict[player.userid] = 0


# =============================================================================
# >> SERVER COMMANDS
# =============================================================================
# A functional teleportation ultimate which will allow for adjusting all races with one code if velocity updates gets pushed out
@ServerCommand('wcs_teleport_push')
def _push_teleport(command):
    userid = int(command[1])
    force = float(command[2])
    if exists(userid):
        player = Player.from_userid(userid)
        origin = player.origin
        coords = player.view_coordinates
        coords -= origin
        player.set_property_vector('localdata.m_vecBaseVelocity', coords*force)


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


# Works as intended
@ServerCommand('wcs_explosive_barrel')
def wcs_explosive_barrel(command):
    userid = int(command[1])
    player = Player.from_userid(userid)
    entity = Entity.create('prop_exploding_barrel')
    entity.origin = player.view_coordinates
    entity.spawn()


@ServerCommand('wcs_getviewcoords')
def viewcoord(command):
    userid = int(command[1])
    xvar = str(command[2])
    yvar = str(command[3])
    zvar = str(command[4])
    if exists(userid):
        player = Player(index_from_userid(userid))
        view_vec = player.get_view_coordinates()
        ConVar(xvar).set_float(view_vec[0])
        ConVar(yvar).set_float(view_vec[1])
        ConVar(zvar).set_float(view_vec[2])


@ServerCommand('wcs_setmodel')
def set_model(command):
    userid = int(command[1])
    model = str(command[2])

    if model == '0':
        inthandle = _remove_model(userid)

        if inthandle is not None:
            Player.from_userid(userid).color = Color(255, 255, 255, 255)

        return

    _remove_model(userid)

    if 'models/' not in model:
        model = 'models/' + model

    player = Player.from_userid(userid)
    player.color = Color(255, 255, 255, 0)

    model = Model(model)

    entity = Entity.create('prop_dynamic_override')
    entity.origin = player.origin
    entity.parent = player
    entity.set_model(model)
    entity.spawn()

    _game_models[entity.inthandle] = player.userid

    entity.add_output('OnUser1 !self,Kill,,0,1')


def _remove_model(userid):
    for inthandle in _game_models:
        if userid == _game_models[inthandle]:
            try:
                index = index_from_inthandle(inthandle)
            except ValueError:
                pass
            else:
                entity = Entity(index)

                entity.clear_parent()
                entity.call_input('FireUser1', '1')
            finally:
                del _game_models[inthandle]

            return inthandle

    return None


# =============================================================================
# >> Kami's - Poison smoke grenade
# =============================================================================
@ServerCommand('poison_smoke')
def poison_smoke(command):
    # poison_smoke <x> <y> <z> <userid> <range> <damage> <delay> <duration>
    do_poison_smoke(Vector(float(command[1]),float(command[2]),float(command[3])),int(command[4]),float(command[5]),int(command[6]),float(command[7]),float(command[8]))


def do_poison_smoke(position,userid,range,damage,delay,duration):
    attacker = Player.from_userid(int(userid))
    duration = duration - delay
    for player in PlayerIter('all'):
        if player.origin.get_distance(position) <= range:
            player.take_damage(damage,attacker_index=attacker.index, weapon_index=None)
    if duration > 0:
        Delay(delay,do_poison_smoke,(position,userid,range,damage,delay,duration))


# =============================================================================
# >> Headshot Immunity
# =============================================================================

@ServerCommand('wcs_headshot_immunity')
def headshot_immunity(command):
    userid = int(command[1])
    amount = float(command[2])
    if exists(userid):
        wcsgroup.setUser(userid,'headshot_immunity',amount)


@PreEvent('player_hurt')
def pre_hurt(ev):
    victim = Player.from_userid(int(ev['userid']))
    if ev['attacker'] > 1:
        damage = int(ev['dmg_health'])
        headshot_immunity = wcsgroup.getUser(victim.userid,'headshot_immunity')
        if headshot_immunity != None:
            if victim.hitgroup == HitGroup.HEAD:
                headshot_immunity = float(headshot_immunity)
                if headshot_immunity > 0:
                    headshot_immunity_dmg = damage*headshot_immunity
                    if int(headshot_immunity_dmg) > 0:
                        victim.health += int(headshot_immunity_dmg)
                        ##wcs.wcs.tell(victim.userid,'\x04[WCS] \x05Your headshot immunity prevented %s damage!' % int(headshot_immunity_dmg))


# =============================================================================
# >> HOOKS
# =============================================================================
@EntityPreHook(EntityCondition.equals_entity_classname('prop_physics_multiplayer'), 'on_take_damage')
def take_damage_hook(stack_data):
    take_damage_info = make_object(TakeDamageInfo, stack_data[1])
    victim = make_object(Entity, stack_data[0])
    if victim.index in entity_health:
        damage = take_damage_info.damage
        if entity_health[victim.index] <= 0:
            Delay(0.1,victim.remove)
        else:
            entity_health[victim.index] -= damage
    else:
        return


# TODO: Only register this callback when _game_models is populated
@EntityPreHook(EntityCondition.equals_entity_classname('prop_dynamic_override'), 'set_transmit')
def pre_set_transmit(stack):
    if _game_models:
        inthandle = inthandle_from_pointer(stack[0])
        userid = _game_models.get(inthandle)

        if userid is not None:
            target = userid_from_edict(make_object(CheckTransmitInfo, stack[1]).client)

            if target == userid:
                return False


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

    _remove_model(ev['userid'])

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


@Event('round_prestart')
def round_prestart(event):
    _game_models.clear()


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
