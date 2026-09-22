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

	self thread create_menu_background();
	self thread create_menu();
	self thread create_menu_options();
	self thread create_menu_selector();
	self thread menu_navigation();
}

// This function creates the menu title, which is the text that appears at the top of the menu
function create_menu()
{
	self.menu_title = hud::createserverfontstring("objective", 1.25);
	self.menu_title hud::setpoint("CENTER", "CENTER", 0, -150);
    self.menu_title setText("ProjectZ Modmenu");
}

// This function creates the menu options, which are the text that appears on the screen for each menu option
function create_menu_options()
{
	self.menu_option_text = [];

	self.menu_option_text[0] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[0] hud::setpoint("CENTER", "CENTER", 0, -100);
    self.menu_option_text[0] setText("God Mode");

    self.menu_option_text[1] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[1] hud::setpoint("CENTER", "CENTER", 0, -75);
    self.menu_option_text[1] setText("Give Weapons");
}

function create_menu_background()
{
    self.menu_background = hud::createServerIcon("white", 220, 150);
	self.menu_background hud::setpoint("CENTER", "CENTER", 0, -50);
	self.menu_background.alpha = 1;
}

// This function creates the menu selector, which is a ">" symbol that indicates which menu option is currently selected
function create_menu_selector()
{
	self.menu_selector = hud::createserverfontstring("objective", 1.0);
	self.menu_selector hud::setpoint("CENTER", "CENTER", -80, -100);
	self.menu_selector setText(">");
}

// This function updates the position of the menu selector based on the currently selected menu option
function update_menu_selector()
{
	if (self.menu_selected == 0)
	{
		self.menu_selector hud::setpoint("CENTER", "CENTER", -80, -100);
	}
	else if (self.menu_selected == 1)
	{
		self.menu_selector hud::setpoint("CENTER", "CENTER", -80, -75);
	}
}

function menu_navigation()
{
    self endon("disconnect");

    while (self.menu_open)
    {
		// UP = right mouse click
        if (self AdsButtonPressed())
        {
            self.menu_selected--;

            if (self.menu_selected < 0)
            {
                self.menu_selected = self.menu_options.size - 1;
            }

            self update_menu_selector();

            while (self AdsButtonPressed())
            {
                wait 0.1;
            }
        }

		// DOWN = left mouse click
        if (self AttackButtonPressed())
        {
            self.menu_selected++;

            if (self.menu_selected >= self.menu_options.size)
            {
                self.menu_selected = 0;
            }

            self update_menu_selector();

            while (self AttackButtonPressed())
            {
                wait 0.1;
            }
        }

		// F key = choose selected option
        if (self UseButtonPressed())
        {
            self select_menu_option();

            while (self UseButtonPressed())
            {
                wait 0.1;
            }
        }

        wait 0.05;
    }
}

function select_menu_option()
{
	if (self.menu_selected == 0)
	{
		if (!isdefined(self.god_mode))
		{
			self.god_mode = true;
			self EnableInvulnerability();

			IPrintLnBold("God Mode ON");
		}
		else 
		{
			self.god_mode = false;
			self DisableInvulnerability();

			IPrintLnBold("God Mode OFF");
		}
	}
	else if (self.menu_selected == 1)
	{
		self giveWeapon(GetWeapon("ray_gun"));

		IPrintLnBold("Ray Gun Given!");
	}
}