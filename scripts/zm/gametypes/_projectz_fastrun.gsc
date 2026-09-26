#namespace projectz_fastrun;

function toggle()
{
    if (!self.fastrun_enabled)
    {
        self.fastrun_enabled = true;
        IPrintLnBold("Fast Run ON");
    }
    else
    {
        self.fastrun_enabled = false;
        IPrintLnBold("Fast Run OFF");
    }
}

function fastrun_monitor()
{
    self endon("disconnect");

    for (;;)
    {
        if (self.fastrun_enabled)
        {
            self setmovespeedscale(2.0);
        }
        else
        {
            self setmovespeedscale(1.0);
        }

        wait 0.05;
    }
}