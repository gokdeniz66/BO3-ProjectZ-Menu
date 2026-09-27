#using scripts\zm\_zm_utility;

#namespace projectz_perks;

function toggle()
{
    self zm_utility::give_player_all_perks();

    IPrintLnBold("All Perks Given!");
}