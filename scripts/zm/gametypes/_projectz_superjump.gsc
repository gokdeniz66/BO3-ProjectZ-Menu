#namespace projectz_superjump;

function toggle()
{
    if (!self.superjump_enabled)
    {
        self.superjump_enabled = true;
        IPrintLnBold("Super Jump ON");
    }
    else
    {
        self.superjump_enabled = false;
        IPrintLnBold("Super Jump OFF");
    }
}

function super_jump_monitor()
{
    self endon("disconnect");

    for (;;)
    {
        if (self.superjump_enabled)
        {            
            if (self JumpButtonPressed())
            {
                self setVelocity((0, 0, 1000));

                while (!self isOnGround())
                {
                    wait 0.05;
                }

                while (self JumpButtonPressed())
                {
                    wait 0.05;
                }
            }
        }

        wait 0.05;
    }
}

function disable_death_barriers()
{
    ents = GetEntArray();

    for (i = 0; i < ents.size; i++)
    {
        if (isSubStr(ents[i].classname, "trigger_hurt"))
        {
            ents[i].origin = (0, 0, 9999999);
        }
    }

    level.player_out_of_playable_area_monitor = false;

    IPrintLnBold("Death Barriers Disabled");
}