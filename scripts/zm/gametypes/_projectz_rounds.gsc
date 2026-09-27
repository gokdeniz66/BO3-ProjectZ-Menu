#using scripts\zm\_zm_utility;

#namespace projectz_rounds;

function toggle()
{
    zm_utility::zombie_goto_round(100);
    IPrintLnBold("Round 100!");
}