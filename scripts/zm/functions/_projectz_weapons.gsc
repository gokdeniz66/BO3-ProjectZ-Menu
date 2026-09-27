#namespace projectz_weapons;


function give_raygun()
{
    self giveWeapon(GetWeapon("ray_gun"));
    IPrintLnBold("Ray Gun Given!");
}

function give_wunderwaffe()
{
    self giveWeapon(GetWeapon("tesla_gun"));
    IPrintLnBold("Wunderwaffe DG-2 Given!");
}