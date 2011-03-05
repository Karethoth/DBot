import std.stdio;
import irccore.ircconnection;
import irccore.replyhandler;



// Currently used to test if implemented
// classes work correctly
int main( char[][] argv )
{
  IRCConnection conn = new IRCConnection( "irc.northpole.fi", 6667 );
  if( !conn.Connect )
    return -1;

  string data = conn.Read();

  void HandleNotice( ReplyInfo reply, IRCConnection conn )
  {
    writefln( "NOTICE: %s", reply.message );
  }

  ReplyHandler replyHandler = new ReplyHandler();
  replyHandler.SetConnection( &conn );
  replyHandler.ReplyCodeToDelegate( "NOTICE", &HandleNotice );
  replyHandler.HandleInput( data );
  delete replyHandler;

  conn.Disconnect;

  delete conn;
  return 0;
}

