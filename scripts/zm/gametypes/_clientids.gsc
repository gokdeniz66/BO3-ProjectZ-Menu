#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;

#using scripts\zm\gametypes\_projectz_menu;

#insert scripts\shared\shared.gsh;

#namespace clientids;

REGISTER_SYSTEM( "clientids", &__init__, undefined )

function __init__()
{
    callback::on_start_gametype( &init );
    callback::on_connect( &on_player_connect );
    callback::on_spawned( &on_player_spawn );
}

function init()
{
    level.clientid = 0;
}

function on_player_connect()
{
    self.clientid = matchRecordNewPlayer(self);

    if (!isdefined(self.clientid) || self.clientid == -1)
    {
        self.clientid = level.clientid;
        level.clientid++;
    }

    self thread projectz_menu::init_player();
}

function on_player_spawn()
{
    level flag::wait_till("initial_blackscreen_passed");

    IPrintLnBold("ProjectZ Modmenu!");
}