import std.stdio;
import irccore.ircconnection;
import irccore.user;
import irccore.server;
import irccore.replyhandler;



// Currently used to test if implemented
// classes work correctly
int main( char[][] argv )
{
  // Server info
  ServerInfo serverInfo = ServerInfo( "TestServer", "localhost", 6667 );

  // Identity of the bot
  UserInfo botInfo;
  botInfo.nick = "DBot";
  botInfo.ident = "DBotV.01";
  botInfo.realName = "ByKoukari";
  
  Server server = new Server( serverInfo );

  void HandleNotice( ReplyInfo reply, IRCConnection conn )
  {
    writefln( "NOTICE: %s", reply.message );
  }
  void HandlePing( ReplyInfo reply, IRCConnection conn )
  {
    assert( conn !is null );
    if( !conn.IsAlive )
      return;

    if( reply.message != null )
      conn.Write( "PONG :" ~ reply.message );
    else
      conn.Write( "PONG" );
  }
  void HandlePrivMsg( ReplyInfo reply, IRCConnection conn )
  {
    assert( conn !is null );
    assert( reply.user !is null );
    if( !conn.IsAlive )
      return;

    writefln( "<%s@%s> %s", reply.user.nick, reply.target, reply.message );
  }


  ReplyHandler replyHandler = new ReplyHandler();
  replyHandler.ReplyCodeToDelegate( "NOTICE", &HandleNotice );
  replyHandler.ReplyCodeToDelegate( "PING", &HandlePing );
  replyHandler.ReplyCodeToDelegate( "PRIVMSG", &HandlePrivMsg );


  // To hold the data we need to process
  string data;

  // Connect to the server
  if( server.Connect )
  {
    // Give the connection handle to the reply handler
    replyHandler.SetConnection( server.GetConnection );

    // Get the notices
    data = server.Read;
    if( data.length > 0 )
    {
      replyHandler.HandleInput( data );
    }

    if( server.Nick( botInfo.nick ) )
    {
      // Some servers ping now, so let's handle it
      // Let's set the socket non blocking in case the ping hasn't been sent
      server.GetConnection().GetHandle().blocking = false;
      data = server.Read;
      if( data.length > 0 )
      {
        replyHandler.HandleInput( data );
      }
      server.GetConnection().GetHandle().blocking = true;

      if( server.Register( botInfo ) )
        writeln( "Registered succesfully." );
    }
  }

  server.Join( "#lobby" );

  while( true )
  {
    data = server.Read;
    if( data.length <= 0 )
      break;
    replyHandler.HandleInput( data );
  }

  delete replyHandler;
  server.Disconnect();
  delete server;
  return 0;
}

