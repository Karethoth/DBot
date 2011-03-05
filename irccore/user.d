module irccore.user;

import std.string;


// Structure to hold some basic user info
struct UserInfo
{
  string nick;
  string ident;
  string realName;
  string host;
  string ip;

  this( this )
  {
    nick = null;
    ident = null;
    realName = null;
    host = null;
    ip = null;
  }

  this( string info )
  {
    nick = null;
    ident = null;
    realName = null;
    host = null;
    ip = null;

    int nickEnd = indexOf( info, '!' );
    // If not found, we're dealing with the server
    if( nickEnd == -1 )
    {
      host = info;
      return;
    }
    // So we're dealing with a client then
    nick = info[0 .. nickEnd-1];
  }

  ~this()
  {
    nick = null;
    ident = null;
    realName = null;
    host = null;
    ip = null;
  }
}


// User class
class User
{
  // Holds the information related to he user
  private UserInfo userInfo;

  // Constructors
  this()
  {
    assert( userInfo.nick is null );
    assert( userInfo.ident is null );
    assert( userInfo.realName is null );
    assert( userInfo.host is null );
    assert( userInfo.ip is null );
  }
  this( string nick )
  {
    this();
    userInfo.nick = nick;
  }
}

