#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;

#using scripts\zm\gametypes\_projectz_weapons;
#using scripts\zm\gametypes\_projectz_godmode;
#using scripts\zm\gametypes\_projectz_ammo;

#insert scripts\shared\shared.gsh;

#namespace projectz_menu;


function init_player()
{
    self.menu_open = false;
    self.menu_selected = 0;
    self.menu_submenu = "main";

    self.god_mode = false;
    self.unlimited_ammo_enabled = false;

    self thread watch_menu_button();
    self thread projectz_ammo::unlimited_ammo();
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


function open_menu()
{
    if (isdefined(self.menu_open) && self.menu_open)
    {
        return;
    }

    self.menu_open = true;
    self.menu_selected = 0;
    self.menu_submenu = "main";

    self.menu_options = [];

    self.menu_options[0] = "God Mode";
    self.menu_options[1] = "Weapons";
    self.menu_options[2] = "Unlimited Ammo";

    self thread create_menu_background();
    self thread create_menu();
    self thread create_menu_options();
    self thread create_menu_selector();

    wait 0.05;

    self update_menu_selector();

    self thread menu_navigation();
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


function create_menu()
{
    self.menu_title = hud::createserverfontstring("objective", 1.4);
    self.menu_title hud::setpoint("RIGHT", "CENTER", -190, -135);
    self.menu_title setText("^2PROJECTZ MENU");
}


function create_menu_options()
{
    self.menu_option_text = [];

    self.menu_option_text[0] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[0] hud::setpoint("RIGHT", "CENTER", -205, -75);

    self.menu_option_text[1] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[1] hud::setpoint("RIGHT", "CENTER", -205, -45);

    self.menu_option_text[2] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[2] hud::setpoint("RIGHT", "CENTER", -205, -15);

    self.menu_option_text[3] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[3] hud::setpoint("RIGHT", "CENTER", -205, 15);

    self.menu_option_text[4] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[4] hud::setpoint("RIGHT", "CENTER", -205, 45);

    self.menu_option_text[5] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[5] hud::setpoint("RIGHT", "CENTER", -205, 75);

    self.menu_option_text[6] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[6] hud::setpoint("RIGHT", "CENTER", -205, 105);

    self.menu_option_text[7] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[7] hud::setpoint("RIGHT", "CENTER", -205, 135);

    self.menu_option_text[8] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[8] hud::setpoint("RIGHT", "CENTER", -205, 165);

    self.menu_option_text[0] setText("God Mode");
    self.menu_option_text[1] setText("Weapons >");
    self.menu_option_text[2] setText("Unlimited Ammo");

    self.menu_option_text[3] setText("");
    self.menu_option_text[4] setText("");
    self.menu_option_text[5] setText("");
    self.menu_option_text[6] setText("");
    self.menu_option_text[7] setText("");
    self.menu_option_text[8] setText("");
}


function create_menu_background()
{
    self.menu_background = hud::createServerIcon("white", 260, 330);
    self.menu_background hud::setpoint("RIGHT", "CENTER", -170, 0);

    self.menu_background.alpha = 0.92;
    self.menu_background.color = (0.02, 0.02, 0.02);
}


function create_menu_selector()
{
    self.menu_selector = hud::createServerIcon("white", 250, 27);
    self.menu_selector hud::setpoint("RIGHT", "CENTER", -190, -75);

    self.menu_selector.alpha = 0.25;
    self.menu_selector.color = (0, 1, 0);
}


function update_menu_selector()
{
    if (self.menu_submenu == "main")
    {
        self.menu_option_text[0] setText("God Mode");
        self.menu_option_text[1] setText("Weapons >");
        self.menu_option_text[2] setText("Unlimited Ammo");

        self.menu_option_text[3] setText("");
        self.menu_option_text[4] setText("");
        self.menu_option_text[5] setText("");
        self.menu_option_text[6] setText("");
        self.menu_option_text[7] setText("");
        self.menu_option_text[8] setText("");

        if (self.menu_selected == 0)
        {
            self.menu_option_text[0] setText("^2God Mode");
        }
        else if (self.menu_selected == 1)
        {
            self.menu_option_text[1] setText("^2Weapons >");
        }
        else if (self.menu_selected == 2)
        {
            self.menu_option_text[2] setText("^2Unlimited Ammo");
        }
    }

    else if (self.menu_submenu == "weapons")
    {
        self.menu_option_text[0] setText("Ray Gun");
        self.menu_option_text[1] setText("Wunderwaffe DG-2");
        self.menu_option_text[2] setText("Back");

        self.menu_option_text[3] setText("");
        self.menu_option_text[4] setText("");
        self.menu_option_text[5] setText("");
        self.menu_option_text[6] setText("");
        self.menu_option_text[7] setText("");

        if (self.menu_selected == 0)
        {
            self.menu_option_text[0] setText("^2Ray Gun");
        }
        else if (self.menu_selected == 1)
        {
            self.menu_option_text[1] setText("^2Wunderwaffe DG-2");
        }
        else if (self.menu_selected == 2)
        {
            self.menu_option_text[2] setText("^2Back");
        }
    }

    self.menu_selector hud::setpoint(
        "RIGHT",
        "CENTER",
        -190,
        -75 + (self.menu_selected * 30)
    );
}


function menu_navigation()
{
    self endon("disconnect");

    while (self.menu_open)
    {
        // MELEE = CLOSE
        if (self MeleeButtonPressed())
        {
            while (self MeleeButtonPressed())
            {
                wait 0.1;
            }

            self close_menu();
            break;
        }

        // ADS = UP
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

        // ATTACK = DOWN
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

        // USE = SELECT
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
    if (self.menu_submenu == "main")
    {
        // GOD MODE
        if (self.menu_selected == 0)
        {
            self thread projectz_godmode::toggle();
        }

        // WEAPONS
        else if (self.menu_selected == 1)
        {
            self open_weapons_menu();
        }

        // UNLIMITED AMMO
        else if (self.menu_selected == 2)
        {
            self thread projectz_ammo::toggle();
        }
    }

    else if (self.menu_submenu == "weapons")
    {
        // RAY GUN
        if (self.menu_selected == 0)
        {
            self thread projectz_weapons::give_raygun();
        }

        // WUNDERWAFFE DG-2
        else if (self.menu_selected == 1)
        {
            self thread projectz_weapons::give_wunderwaffe();
        }

        // BACK
        else if (self.menu_selected == 2)
        {
            self.menu_submenu = "main";
            self.menu_selected = 0;

            self.menu_options = [];

            self.menu_options[0] = "God Mode";
            self.menu_options[1] = "Weapons";
            self.menu_options[2] = "Unlimited Ammo";

            self update_menu_selector();
        }
    }
}


function open_weapons_menu()
{
    self.menu_submenu = "weapons";
    self.menu_selected = 0;

    self.menu_options = [];

    self.menu_options[0] = "Ray Gun";
    self.menu_options[1] = "Wunderwaffe DG-2";
    self.menu_options[2] = "Back";

    self update_menu_selector();
}