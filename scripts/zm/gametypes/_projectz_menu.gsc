#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;

#using scripts\zm\functions\_projectz_weapons;
#using scripts\zm\functions\_projectz_godmode;
#using scripts\zm\functions\_projectz_ammo;
#using scripts\zm\functions\_projectz_superjump;
#using scripts\zm\functions\_projectz_fastrun;
#using scripts\zm\functions\_projectz_rounds;
#using scripts\zm\functions\_projectz_points;
#using scripts\zm\functions\_projectz_perks;
#using scripts\zm\functions\_projectz_aimbot;

#insert scripts\shared\shared.gsh;

#namespace projectz_menu;

function init_player()
{
    self.menu_open = false;
    self.menu_selected = 0;
    self.menu_submenu = "main";

    self.god_mode = false;
    self.unlimited_ammo_enabled = false;
    self.superjump_enabled = false;
    self.fastrun_enabled = false;
    self.aimbot_enabled = false;

    self thread watch_menu_button();
    self thread projectz_ammo::unlimited_ammo_monitor();
    self thread projectz_superjump::super_jump_monitor();
    self thread projectz_fastrun::fastrun_monitor();
    self thread projectz_aimbot::aimbot_monitor();
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

    self.menu_options[0] = "Player Options >";
    self.menu_options[1] = "Weapons Options >";
    self.menu_options[2] = "Zombies Options >";

    self create_menu_background();
    self create_menu();
    self create_menu_options();
    self create_menu_selector();

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

    if (isdefined(self.menu_left_border))
    {
        self.menu_left_border destroy();
        self.menu_left_border = undefined;
    }
}

function create_menu()
{
    self.menu_title = hud::createserverfontstring("objective", 1.7);
    self.menu_title hud::setpoint("CENTER", "CENTER", 0, -115);
    self.menu_title setText("^1PROJECTZ");
}

function create_menu_options()
{
    self.menu_option_text = [];

    self.menu_option_text[0] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[0] hud::setpoint("CENTER", "CENTER", 0, -75);

    self.menu_option_text[1] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[1] hud::setpoint("CENTER", "CENTER", 0, -45);
    
    self.menu_option_text[2] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[2] hud::setpoint("CENTER", "CENTER", 0, -15);

    self.menu_option_text[3] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[3] hud::setpoint("CENTER", "CENTER", 0, 15);
    
    self.menu_option_text[4] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[4] hud::setpoint("CENTER", "CENTER", 0, 45);

    self.menu_option_text[5] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[5] hud::setpoint("CENTER", "CENTER", 0, 75);
    
    self.menu_option_text[6] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[6] hud::setpoint("CENTER", "CENTER", 0, 105);
    
    self.menu_option_text[7] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[7] hud::setpoint("CENTER", "CENTER", 0, 135);
    
    self.menu_option_text[8] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[8] hud::setpoint("CENTER", "CENTER", 0, 165);
    
    self.menu_option_text[9] = hud::createserverfontstring("objective", 1.0);
    self.menu_option_text[9] hud::setpoint("CENTER", "CENTER", 0, 195);

    self.menu_option_text[0] setText("Player Options >");
    self.menu_option_text[1] setText("Weapons Options >");
    self.menu_option_text[2] setText("Zombies Options >");
    self.menu_option_text[3] setText("");
    self.menu_option_text[4] setText("");
    self.menu_option_text[5] setText("");
    self.menu_option_text[6] setText("");
    self.menu_option_text[7] setText("");
    self.menu_option_text[8] setText("");
    self.menu_option_text[9] setText("");
}

function create_menu_background()
{
    self.menu_background = hud::createServerIcon("white", 220, 270);
    self.menu_background hud::setpoint("CENTER", "CENTER", 0, 0);

    self.menu_background.alpha = 0.92;
    self.menu_background.color = (0.02, 0.02, 0.02);

    self.menu_left_border = hud::createServerIcon("white", 4, 270);
    self.menu_left_border hud::setpoint("CENTER", "CENTER", -108, 0);

    self.menu_left_border.alpha = 1;
    self.menu_left_border.color = (1, 0, 0);
}

function create_menu_selector()
{
    self.menu_selector = hud::createServerIcon("white", 210, 27);
    self.menu_selector hud::setpoint("CENTER", "CENTER", 0, -75);

    self.menu_selector.alpha = 0.25;
    self.menu_selector.color = (1, 0, 1);
}

function update_menu_selector()
{
    // refresh menu option texts
    self.menu_option_text[0] setText("");
    self.menu_option_text[1] setText("");
    self.menu_option_text[2] setText("");
    self.menu_option_text[3] setText("");
    self.menu_option_text[4] setText("");
    self.menu_option_text[5] setText("");
    self.menu_option_text[6] setText("");
    self.menu_option_text[7] setText("");
    self.menu_option_text[8] setText("");
    self.menu_option_text[9] setText("");

    if (self.menu_submenu == "main")
    {
        self.menu_option_text[0] setText("Player Options >");
        self.menu_option_text[1] setText("Weapons Options >");
        self.menu_option_text[2] setText("Zombies Options >");

        if (self.menu_selected == 0)
        {
            self.menu_option_text[0] setText("^1Player Options >");
        }
        else if (self.menu_selected == 1)
        {
            self.menu_option_text[1] setText("^1Weapons Options >");
        }
        else if (self.menu_selected == 2)
        {
            self.menu_option_text[2] setText("^1Zombies Options >");
        }
    }

    else if (self.menu_submenu == "weapons")
    {
        self.menu_option_text[0] setText("Ray Gun");
        self.menu_option_text[1] setText("Wunderwaffe DG-2");
        self.menu_option_text[2] setText("Back");

        if (self.menu_selected == 0)
        {
            self.menu_option_text[0] setText("^1Ray Gun");
        }
        else if (self.menu_selected == 1)
        {
            self.menu_option_text[1] setText("^1Wunderwaffe DG-2");
        }
        else if (self.menu_selected == 2)
        {
            self.menu_option_text[2] setText("^1Back");
        }
    }

    else if (self.menu_submenu == "Player") 
    {
        self.menu_option_text[0] setText("God Mode");
        self.menu_option_text[1] setText("Unlimited Ammo");
        self.menu_option_text[2] setText("Super Jump");
        self.menu_option_text[3] setText("Fast Run");
        self.menu_option_text[4] setText("Get All Perks");
        self.menu_option_text[5] setText("Aimbot");
        self.menu_option_text[6] setText("Back");

        if (self.menu_selected == 0)
        {
            self.menu_option_text[0] setText("^1God Mode");
        }
        else if (self.menu_selected == 1)
        {
            self.menu_option_text[1] setText("^1Unlimited Ammo");
        }
        else if (self.menu_selected == 2)
        {
            self.menu_option_text[2] setText("^1Super Jump");
        }
        else if (self.menu_selected == 3)
        {
            self.menu_option_text[3] setText("^1Fast Run");
        }
        else if (self.menu_selected == 4)
        {
            self.menu_option_text[4] setText("^1Get All Perks");
        }
        else if (self.menu_selected == 5)
        {
            self.menu_option_text[5] setText("^1Aimbot");
        }
        else if (self.menu_selected == 6)
        {
            self.menu_option_text[6] setText("^1Back");
        }
    }

    else if (self.menu_submenu == "Zombies")
    {
        self.menu_option_text[0] setText("Round 100");
        self.menu_option_text[1] setText("Spawn Points");
        self.menu_option_text[2] setText("Back");

        if (self.menu_selected == 0)
        {
            self.menu_option_text[0] setText("^1Round 100");
        }
        else if (self.menu_selected == 1)
        {
            self.menu_option_text[1] setText("^1Spawn Points");
        }
        else if (self.menu_selected == 2)
        {
            self.menu_option_text[2] setText("^1Back");
        }
    }

    self.menu_selector hud::setpoint(
        "CENTER",
        "CENTER",
        0,
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
        // Player Option
        if (self.menu_selected == 0)
        {
            self open_player_menu();
        }
        
        // WEAPONS
        else if (self.menu_selected == 1)
        {
            self open_weapons_menu();
        }

        // ZOMBIES
        else if (self.menu_selected == 2)
        {
            self open_zombies_menu();
        }
    }

    else if (self.menu_submenu == "Player") 
    {
        // GOD MODE
        if (self.menu_selected == 0)
        {
            self thread projectz_godmode::toggle();
        }

        // Unlimited Ammo
        else if (self.menu_selected == 1)
        {
            self thread projectz_ammo::toggle();
        }

        // Super Jump
        else if (self.menu_selected == 2)
        {
            self thread projectz_superjump::toggle();
        }

        // Fast Run
        else if (self.menu_selected == 3)
        {
            self thread projectz_fastrun::toggle();
        }

        // Get All Perks
        else if (self.menu_selected == 4)
        {
            self thread projectz_perks::toggle();
        }

        // Aimbot
        else if (self.menu_selected == 5)
        {
            self thread projectz_aimbot::toggle();
        }

        // BACK
        else if (self.menu_selected == 6)
        {
            self.menu_submenu = "main";
            self.menu_selected = 0;

            self.menu_options = [];

            self.menu_options[0] = "Player Options >";
            self.menu_options[1] = "Weapons Options >";
            self.menu_options[2] = "Zombies Options >";

            self update_menu_selector();
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

            self.menu_options[0] = "Player Options >";
            self.menu_options[1] = "Weapons Options >";
            self.menu_options[2] = "Zombies Options >";

            self update_menu_selector();
        }
    }

    else if (self.menu_submenu == "Zombies")
    {
        // Round 100
        if (self.menu_selected == 0)
        {
            self thread projectz_rounds::toggle();
        }

        // Spawn Points
        else if (self.menu_selected == 1)
        {
            self thread projectZ_points::toggle();
        }

        // BACK
        else if (self.menu_selected == 2)
        {
            self.menu_submenu = "main";
            self.menu_selected = 0;

            self.menu_options = [];

            self.menu_options[0] = "Player Options >";
            self.menu_options[1] = "Weapons Options >";
            self.menu_options[2] = "Zombies Options >";

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

function open_player_menu()
{
    self.menu_submenu = "Player";
    self.menu_selected = 0;

    self.menu_options = [];

    self.menu_options[0] = "God Mode";
    self.menu_options[1] = "Unlimited Ammo";
    self.menu_options[2] = "Super Jump";
    self.menu_options[3] = "Fast Run";
    self.menu_options[4] = "Get All Perks";
    self.menu_options[5] = "Aimbot";
    self.menu_options[6] = "Back";

    self update_menu_selector();
}

function open_zombies_menu()
{
    self.menu_submenu = "Zombies";
    self.menu_selected = 0;

    self.menu_options = [];

    self.menu_options[0] = "Round 100";
    self.menu_options[1] = "Spawn Points";
    self.menu_options[2] = "Back";

    self update_menu_selector();
}