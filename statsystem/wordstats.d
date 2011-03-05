module statsystem.wordstats;

import std.stdio, std.string;
import std.ctype;


struct WordInfo
{
  ulong count;
}


class WordStats
{
 private:
  WordInfo[string] wordInfos;

 public:
  this(){};

  ~this()
  {
    foreach( string word, WordInfo info; wordInfos )
    {
      wordInfos.remove( word );
    }
  }

  
  void PrintStats()
  {
    writeln( "----------------" );
    writeln( "WORD STATISTICS:" );
    writeln( "----------------" );
    foreach( string word, WordInfo info; wordInfos )
    {
      writefln( "%s: said %d times.", word, info.count );
    }
    writeln( "" );
  }


  void GenerateStatsFromMessage( string msg )
  {
    string[] words = split( msg );
    foreach( string word; words )
    {
      word = tolower( word );
      if( word !in wordInfos )
        wordInfos[word] = WordInfo();
      wordInfos[word].count++;
    }
  }
}

