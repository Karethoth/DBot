module statsystem.stats;

import statsystem.wordstats;
import statsystem.userstats;
import irccore.replyhandler;

class Stats
{
 private:
  WordStats wordStats;
  UserStats userStats;

 public:
  this()
  {
    wordStats = new WordStats();
    userStats = new UserStats();
  }
  ~this()
  {
    if( wordStats !is null )
      delete wordStats;

    if( userStats !is null )
      delete userStats;
  }

  
  bool InputPrivmsg( ReplyInfo info )
  {
    assert( info.user !is null );
    assert( info.message !is null );
    assert( wordStats !is null );
    assert( userStats !is null );

    wordStats.InputMessage( info.message );
    userStats.InputPrivMsg( info );

    return true;
  }


  void PrintStats()
  {
    assert( wordStats !is null );
    assert( userStats !is null );

    userStats.PrintStats();
    wordStats.PrintStats();
  }
}

