
module statsystem.userstats;

import std.stdio, std.string;
import std.ctype;
import irccore.user, irccore.replyhandler;


struct UserStatInfo
{
  ulong lines=0;
  ulong words=0;
  float lineLengthMean=0;
  ulong joins=0;
  ulong parts=0;
}


class UserStats
{
 private:
  UserStatInfo[string] userStats;

 public:
  this(){};

  ~this()
  {
    foreach( string user, UserStatInfo stats; userStats )
    {
      userStats.remove( user );
    }
  }

  
  void PrintStats()
  {
    writeln( "----------------" );
    writeln( "USER STATISTICS:" );
    writeln( "----------------" );
    foreach( string user, UserStatInfo stats; userStats )
    {
      writefln( "%s has:", user );
      writefln( "\tspoke %d lines.", stats.lines );
      writefln( "\tsaid %d words.", stats.words );
      writefln( "\tline length mean of %.2f characters.", stats.lineLengthMean );
    }
    writeln( "" );
  }


  void InputPrivMsg( ReplyInfo info )
  {
    assert( info.user !is null );
    string[] words = split( info.message );

    string nick = info.user.nick;
    
    if( nick !in userStats )
    {
      userStats[nick] = UserStatInfo();
    }

    UserStatInfo *stats = &userStats[nick];
    stats.lines++;
    stats.words += words.length;
    stats.lineLengthMean = (stats.lineLengthMean*(stats.lines-1) + info.message.length-1)/(stats.lines);
  }
}
