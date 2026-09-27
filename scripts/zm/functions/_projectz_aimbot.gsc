#namespace projectz_aimbot;

function toggle()
{
    if (!self.aimbot_enabled)
    {
        self.aimbot_enabled = true;
        IPrintLnBold("Aimbot ON");
    }
    else
    {
        self.aimbot_enabled = false;
        IPrintLnBold("Aimbot OFF");
    }
}

function aimbot_monitor()
{
    self endon("disconnect");

    for (;;)
    {
        if (self.aimbot_enabled)
        {
            if (self AdsButtonPressed())
            {
                zombies = getAiSpeciesArray("axis", "all");

                if (isDefined(zombies) && zombies.size > 0)
                {
                    zombie = ArrayGetClosest(self getOrigin(), zombies);
                        
                    if (isDefined(zombie) && IsAlive(zombie))
                    {
                        self SetPlayerAngles(VectorToAngles(zombie getTagOrigin("j_head") - self getTagOrigin("j_head")));
                    }
                }
            }
        }
        
        wait 0.05;
    }
}