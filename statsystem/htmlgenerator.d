module statsystem.htmlgenerator;

import std.stdio;
import statsystem.stats;
import statsystem.userstats;
import statsystem.wordstats;


class HTMLGenerator
{
 private:
  Stats *stats;
  UserStats *userStats;
  WordStats *wordStats;

 public:
  this( Stats *rstats,
        UserStats *ruserStats,
        WordStats *rwordStats )
  {
    assert( rstats !is null );
    assert( ruserStats !is null );
    assert( rwordStats !is null );

    stats = rstats;
    userStats = ruserStats;
    wordStats = rwordStats;
  }


  bool Generate( string filename )
  {
    /* TODO
       - Open file
       - If exists, archive then delete original
       - Open _new_ file
       - Output statistics to it.
       - Timestamps? To ease the archiving process?
       - Openin new file with the name of current timestamp? Sounds good.
     */
    return false; // temporary
  }
};
