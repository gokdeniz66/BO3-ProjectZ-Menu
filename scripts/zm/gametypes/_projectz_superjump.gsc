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
                self setVelocity((0, 0, 500));

                while (self !isOnGround())
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