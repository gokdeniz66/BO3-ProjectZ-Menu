#namespace projectz_ammo;


function toggle()
{
    if (!self.unlimited_ammo_enabled)
    {
        self.unlimited_ammo_enabled = true;
        IPrintLnBold("Unlimited Ammo ON");
    }
    else
    {
        self.unlimited_ammo_enabled = false;
        IPrintLnBold("Unlimited Ammo OFF");
    }
}


function unlimited_ammo()
{
    self endon("disconnect");

    for (;;)
    {
        if (self.unlimited_ammo_enabled)
        {
            weapons = self GetWeaponsList(1);

            for (x = 0; x < weapons.size; x++)
            {
                if (self HasWeapon(weapons[x]))
                {
                    self GiveMaxAmmo(weapons[x]);
                }
            }
        }

        wait 0.1;
    }
}