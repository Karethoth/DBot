module irccore.readwriter;

interface ReadWriter
{
  bool Write( string );
  string Read( uint );
}

