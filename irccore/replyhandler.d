module irccore.replyhandler;

import std.stdio, std.string;
import std.array, std.conv;
import irccore.ircconnection;
import irccore.user;


struct ReplyInfo
{
  UserInfo *user;
  string target;
  string command;
  string message;
  string replyCode;
  string raw;
};


class ReplyHandler
{
 private:
  void delegate( ReplyInfo, IRCConnection )[string] replyCodeMap;
  IRCConnection *connection;

 public:
  this()
  {
  }
  this( IRCConnection *conn )
  {
    connection = conn;
  }

  ~this()
  {
    if( replyCodeMap !is null )
      foreach( string replyCode, void delegate( ReplyInfo, IRCConnection ) del; replyCodeMap )
      {
        replyCodeMap[replyCode] = null;
      }
  }


  void ReplyCodeToDelegate( string replyCode,
                            void delegate( ReplyInfo, IRCConnection ) del )
  {
    replyCodeMap[replyCode] = del;
  }


  ReplyInfo FetchReplyInfo( string line )
  {
    assert( line !is null );
    assert( line.length > 0 );

    int replyCodeIndex = 1;
    // Hybrid-style
    if( line[0] == ':' )
      line = line[1 .. $]; // Snip the leading ':'
    // In other cases reply code index is 0
    else
    {
      replyCodeIndex = 0;
    }

    ReplyInfo info;
    string[] words = split( line );
    assert( words.length >= 2 );

    info.raw = line;

    // Let the UserInfo constructor handle the user info
    info.user = new UserInfo( words[0] );

    // Fetch the message:
    int messageIndex = indexOf( line, ':' );
    if( messageIndex >= 0 )
      info.message = line[messageIndex+1 .. $];

    // Check if we're dealing with PING
    if( words[replyCodeIndex] == "PING" )
    {
      info.command = words[0];
      info.replyCode = words[0];
    }
    // If we're dealing with NOTICE message here
    else if( words[replyCodeIndex] == "NOTICE" )
    {
      info.command = words[replyCodeIndex];
      info.replyCode = words[replyCodeIndex];
    }
    // We're dealing with a normal reply code here
    else
    {
      // Fetch the reply code
      info.replyCode = words[replyCodeIndex];

      // Fetch the target
      info.target = words[replyCodeIndex+1];
    }

    // Check if the code has been pointed to a delegate
    if( info.replyCode in replyCodeMap )
    {
      replyCodeMap[info.replyCode]( info, *connection );
    }
    // If not..
    else
    {
      writefln( "Unknown reply code \"%s\" - %s", info.replyCode, info.raw );
    }

    return info;
  }

  
  bool HandleLine( string line )
  {
    assert( line !is null );
    assert( line.length > 0 );

    ReplyInfo info = FetchReplyInfo( line );
    return true;
  }


  bool HandleInput( string data )
  {
    assert( data !is null );
    assert( data.length > 0 );

    // Split the data to lines and handle them one by one
    int index=0;
    string line;
    while( data.length > 0 )
    {
      index = indexOf( data, '\n' );

      if( index >= 0 )
      {
        line = data[0 .. index];
        data = data[index+1 .. $];
      }
      else
      {
        line = data;
        data = "";
      }
      if( !HandleLine( line ) )
        return false;
    }
    return true;
  }


  void SetConnection( IRCConnection *conn )
  {
    connection = conn;
  }
}

