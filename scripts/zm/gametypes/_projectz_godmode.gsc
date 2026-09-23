#namespace projectz_godmode;


function toggle()
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