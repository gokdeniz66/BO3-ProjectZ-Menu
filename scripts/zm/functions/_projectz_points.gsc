#using scripts\zm\_zm_score;

#namespace projectz_points;

function toggle()
{
    self zm_score::add_to_player_score(9999999);
    IPrintLnBold("Added 9,999,999 points!");
}