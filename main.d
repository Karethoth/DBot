import std.stdio;
import irccore.ircconnection;


// Currently used to test if implemented
// classes work correctly
int main( char[][] argv )
{
  IRCConnection conn = new IRCConnection( "irc.northpole.fi", 6667 );
  if( !conn.Connect )
    return -1;

  string data = conn.Read();
  writefln( "Received: \"%s\"", data );

  conn.Disconnect;

  delete conn;
  return 0;
}
