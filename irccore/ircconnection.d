module irccore.ircconnection;

import std.stdio, std.socket;
import irccore.readwriter;

class IRCConnection : ReadWriter
{
 private:
  // Basic stuff
  string host;
  ushort port;
  // Socket stuff
  Socket handle;

 public:
  this( string host, ushort port )
  {
    handle = null;
    this.host = host;
    this.port = port;
  }
  ~this()
  {
    host = null;
    port = 0;
    if( handle !is null )
    {
      if( handle.isAlive )
        handle.close;
      delete handle;
    }
  }

  
  bool Connect()
  {
    assert( host !is null );
    assert( port > 0 );

    handle = new TcpSocket;
    assert( handle.isAlive );
    
    // Connect
    try
    {
      handle.connect( new InternetAddress( host, cast(int)port ) );
    }
    // If connection failed
    catch( SocketException e )
    {
      writefln( "Failed to connect to %s:%d - %s", host, port, e.toString() );
      delete handle;
      return false;
    }

    // Connection succeeded
    return true;
  }

  bool Disconnect()
  {
    if( handle !is null )
    {
      if( handle.isAlive )
        handle.close;
      delete handle;
    }
    return true;
  }

  bool IsAlive()
  {
    if( handle !is null )
      return handle.isAlive;
    return false;
  }


  bool Write( string msg )
  {
    if( !IsAlive )
      return false;

    auto ret = handle.send( msg );
    if( !ret )
      return false;

    return true;
  }

  string Read( uint bufferSize=1024 )
  {
    if( !IsAlive )
      return null;
    
    char[] buf = new char[bufferSize];
    auto ret = handle.receive( buf );

    if( !ret )
      return null;


    char[] data = buf[0 .. ret].dup;
    // If we didn't manage to read everything to the buffer
    // read the rest..
    while( ret == bufferSize )
    {
      delete buf;
      buf = new char[bufferSize];
      ret = handle.receive( buf );
      if( !ret )
        return cast(string)data;
      data ~= buf[0 .. ret];
    }

    return cast(string)data;
  }
}

