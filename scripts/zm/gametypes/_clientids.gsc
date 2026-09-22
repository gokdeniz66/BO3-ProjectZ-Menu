#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;

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
	// this is now handled in code ( not lan )
	// see s_nextScriptClientId 
	level.clientid = 0;
}

function on_player_connect()
{
	self.clientid = matchRecordNewPlayer( self );
	if ( !isdefined( self.clientid ) || self.clientid == -1 )
	{
		self.clientid = level.clientid;
		level.clientid++;	// Is this safe? What if a server runs for a long time and many people join/leave
	}
}


function on_player_spawn()
{
    level flag::wait_till("initial_blackscreen_passed");

    IPrintLnBold("ProjectZ Modmenu!");

	self thread watch_menu_button();
}

function watch_menu_button()
{
    self endon("disconnect");

    for (;;)
    {
        if (self MeleeButtonPressed())
        {
            self thread open_menu();

            while (self MeleeButtonPressed())
            {
                wait 0.1;
            }
        }

        wait 0.05;
    }
}

function open_menu() 
{
	// if the menu is already open, don't open it again
	if (isdefined(self.menu_open) && self.menu_open)
	{
		return;
	}

	// set menu open true if player opens menu, this is used to prevent the menu from opening multiple times
	self.menu_open = true;
	self.menu_selected = 0;

	self.menu_options = [];

	self.menu_options[0] = "God Mode";
	self.menu_options[1] = "Give Weapons";

	self thread create_menu();
	self thread menu_navigation();
}

function create_menu()
{
	self.menu_title = hud::createserverfontstring("objective", 1.25);
	self.menu_title hud::setpoint("CENTER", "CENTER", 0, -150);
    self.menu_title setText("ProjectZ Modmenu");
}

function menu_navigation()
{
	self endon("disconnect");

	while (self.menu_open) 
	{
		if (self ActionSlotTwoButtonPressed())
		{
			self.menu_selected++;

			if (self.menu_selected >= self.menu_options.size)
			{
				self.menu_selected = 0;
			}

			while (self ActionSlotTwoButtonPressed())
			{
				wait 0.1;
			}
		}

		if (self ActionSlotOneButtonPressed())
		{
			self.menu_selected--;

			if (self.menu_selected < 0)
			{
				self.menu_selected = self.menu_options.size - 1;
			}

			while (self ActionSlotOneButtonPressed())
			{
				wait 0.1;
			}
		}
		wait 0.05;
	}
}