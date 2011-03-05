module irccore.server;

import std.stdio;
import irccore.ircconnection;
import irccore.readwriter;
import irccore.user;


struct ServerInfo
{
  string name;
  string host;
  ushort port;

  this( string sname=null, string shost=null, ushort sport=0 )
  {
    name = sname;
    host = shost;
    port = sport;
  }
}


class Server : ReadWriter
{
 private:
  ServerInfo serverInfo;
  IRCConnection connection;

 public:
  this()
  {
    serverInfo = ServerInfo();
    connection = null;
  }
  this( ServerInfo sinfo )
  {
    serverInfo = sinfo;
  }


  bool Connect()
  {
    assert( serverInfo.host !is null );
    assert( serverInfo.port > 0 );

    if( connection !is null )
    {
      connection.Disconnect;
      delete connection;
    }
    
    connection = new IRCConnection( serverInfo.host, serverInfo.port );
    assert( connection !is null );
    return connection.Connect();
  }

  bool Disconnect()
  {
    if( connection !is null )
      return connection.Disconnect;
    return true;
  }


  bool IsAlive()
  {
    if( connection !is null )
      return connection.IsAlive;
    return false;
  }

  bool Write( string msg )
  {
    if( IsAlive )
      return connection.Write( msg );
    return false;
  }

  string Read( uint bufferSize=1024 )
  {
    if( IsAlive )
      return connection.Read( bufferSize );
    return null;
  }


  IRCConnection* GetConnection()
  {
    return &connection;
  }


  bool Nick( string nick )
  {
    assert( nick !is null );
    if( !IsAlive  )
      return false;

    string nickMsg = "NICK " ~ nick;
    if( !Write( nickMsg ) )
      return false;
    return true;
  }


  bool Register( UserInfo info )
  {
    assert( info.nick !is null );
    if( !IsAlive )
      return false;

    string userMsg = "USER " ~ info.ident ~  " 8 * :" ~ info.realName;
    if( !Write( userMsg ) )
      return false;

    return true;
  }


  bool Join( string channel, string password=null )
  {
    assert( channel !is null );
    if( !IsAlive )
      return false;

    string joinMsg = "JOIN " ~ channel;
    if( password !is null )
      joinMsg ~= " " ~ password;

    if( !Write( joinMsg ) )
      return false;
    
    return true;
  }
}

