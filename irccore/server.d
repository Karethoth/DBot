module irccore.server;

import std.stdio;
import irccore.ircconnection;
import irccore.readwriter;


struct ServerInfo
{
  string name;
  string host;
  ushort port;
}


class Server : ReadWriter
{
 private:
  ServerInfo serverInfo;
  IRCConnection connection;

 public:


  bool Write( string msg )
  {
    if( connection !is null )
      return connection.Write( msg );
    return false;
  }

  string Read( uint bufferSize=1024 )
  {
    if( connection !is null )
      return connection.Read( bufferSize );
    return null;
  }
}

