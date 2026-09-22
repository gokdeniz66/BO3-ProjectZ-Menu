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
        if (!isdefined(self.menu_open) || !self.menu_open)
        {
            if (self MeleeButtonPressed())
            {
                while (self MeleeButtonPressed())
                {
                    wait 0.1;
                }

                self thread open_menu();
            }
        }

        wait 0.05;
    }
}

function close_menu()
{
	self.menu_open = false;

	if (isdefined(self.menu_title))
	{
		self.menu_title destroy();
		self.menu_title = undefined;
	}

	if (isdefined(self.menu_option_text))
	{
		foreach (option in self.menu_option_text)
		{
			if (isdefined(option))
			{
			option destroy();
			}
		}

		self.menu_option_text = undefined;
	}

	if (isdefined(self.menu_selector))
    {
        self.menu_selector destroy();
        self.menu_selector = undefined;
    }

    if (isdefined(self.menu_background))
    {
        self.menu_background destroy();
        self.menu_background = undefined;
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
	self.menu_options[1] = "Spawn Ray Gun";

	self thread create_menu_background();
	self thread create_menu();
	self thread create_menu_options();
	self thread create_menu_selector();
	self thread menu_navigation();
}

// This function creates the menu title, which is the text that appears at the top of the menu
function create_menu()
{
    self.menu_title = hud::createserverfontstring("objective", 1.3);
    self.menu_title hud::setpoint("CENTER", "CENTER", 0, -125);
    self.menu_title setText("^2PROJECTZ");
}

// This function creates the menu options, which are the text that appears on the screen for each menu option
function create_menu_options()
{
    self.menu_option_text = [];

    self.menu_option_text[0] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[0] hud::setpoint("CENTER", "CENTER", 0, -75);
    self.menu_option_text[0] setText("^2God Mode");

    self.menu_option_text[1] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[1] hud::setpoint("CENTER", "CENTER", 0, -45);
    self.menu_option_text[1] setText("Spawn Ray Gun");
}

function create_menu_background()
{
    self.menu_background = hud::createServerIcon("white", 350, 220);
    self.menu_background hud::setpoint("CENTER", "CENTER", 0, -40);
    self.menu_background.alpha = 0.85;
    self.menu_background.color = (0, 0, 0);
}

// This function creates the menu selector, which is a ">" symbol that indicates which menu option is currently selected
function create_menu_selector()
{
    self.menu_selector = hud::createserverfontstring("objective", 1.0);
    self.menu_selector hud::setpoint("CENTER", "CENTER", -100, -75);
    self.menu_selector setText(">");
}

// This function updates the position of the menu selector based on the currently selected menu option
function update_menu_selector()
{
    if (self.menu_selected == 0)
    {
        self.menu_option_text[0] setText("^2God Mode");
        self.menu_option_text[1] setText("Spawn Ray Gun");

        self.menu_selector hud::setpoint("CENTER", "CENTER", -100, -75);
    }
    else if (self.menu_selected == 1)
    {
        self.menu_option_text[0] setText("God Mode");
        self.menu_option_text[1] setText("^2Spawn Ray Gun");

        self.menu_selector hud::setpoint("CENTER", "CENTER", -100, -45);
    }
}

function menu_navigation()
{
    self endon("disconnect");

    while (self.menu_open)
    {
		// Close menu if player presses melee button again
		if (self MeleeButtonPressed())
		{
			self close_menu();

			while (self MeleeButtonPressed())
			{
				wait 0.1;
			}

			break;
		}

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

// This function is called when the player selects a menu option, and it executes the corresponding action
function select_menu_option()
{
	if (self.menu_selected == 0)
	{
		if (!isdefined(self.god_mode) || self.god_mode == false)
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