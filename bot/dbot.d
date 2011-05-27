module bot.dbot;

import std.stdio;

import irccore.ircconnection;
import irccore.replyhandler;
import irccore.user;
import irccore.server;
import statsystem.stats;

// TODO
// Server.Part( string channel, string message=null )
// Server.Quit( string message=null )


class DBot
{
 private:
  Server server;
  UserInfo bot;
  Stats stats;
  ReplyHandler replyHandler;
 

 public:
  this( UserInfo botInfo, ServerInfo serverInfo )
  {
    server = new Server( serverInfo );
    bot = botInfo;
    stats = new Stats();
    replyHandler = new ReplyHandler( server.GetConnection() );
  }

  ~this()
  {
    if( server !is null )
      delete server;

    if( stats !is null)
      delete stats;

    if( replyHandler !is null)
      delete replyHandler;
  }


  bool Start()
  {
    assert( server !is null );
    assert( stats !is null );
    assert( replyHandler !is null );

    // Generate the deligates
    if( !GenerateDelegates() )
      return false;

    // To hold the data we need to process
    string data;

    // Connect to the server
    if( server.Connect )
    {
      // Get the notices
      data = server.Read;
      if( data.length > 0 )
      {
        replyHandler.HandleInput( data );
      }

      if( server.Nick( bot.nick ) )
      {
        // Some servers ping now, so let's handle it
        // Let's set the socket non blocking in case the ping hasn't been sent
        //server.GetConnection().GetHandle().blocking = false;
        data = server.Read;
        if( data.length > 0 )
        {
          replyHandler.HandleInput( data );
        }
        //server.GetConnection().GetHandle().blocking = true;

        if( server.Register( bot ) )
          writeln( "Registered succesfully." );
      }
    }

    // Join to #channel
    if( !server.Join( "#channel" ) )
      return false;

    // The "main" loop
    while( true )
    {
      data = server.Read;
      if( data.length <= 0 )
        return false;
      replyHandler.HandleInput( data );
    }
    server.Disconnect();
    return true;
  }


  // Yes.. This is ugly.. I have more deligate way in my mind.
  bool GenerateDelegates()
  {
    assert( replyHandler !is null );

    // NOTICE
    void HandleNotice( ReplyInfo reply, IRCConnection conn )
    {
      writefln( "NOTICE: %s", reply.message );
    }
    replyHandler.ReplyCodeToDelegate( "NOTICE", &HandleNotice );
    
    // PING
    void HandlePing( ReplyInfo reply, IRCConnection conn )
    {
      assert( server !is null );
      if( !conn.IsAlive )
        return;

      if( reply.message != null )
        conn.Write( "PONG :" ~ reply.message );
      else
        conn.Write( "PONG" );
    }
    replyHandler.ReplyCodeToDelegate( "PING", &HandlePing );
    
    // PRIVMSG
    void HandlePrivMsg( ReplyInfo reply, IRCConnection conn )
    {
      assert( server !is null );
      assert( reply.user !is null );
      if( !conn.IsAlive )
        return;

      writefln( "<%s@%s> %s", reply.user.nick, reply.target, reply.message );
      stats.InputPrivmsg( reply );
      stats.PrintStats();
    }
    replyHandler.ReplyCodeToDelegate( "PRIVMSG", &HandlePrivMsg );

    return true;
  }
}

