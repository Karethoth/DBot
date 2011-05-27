import std.stdio;
import irccore.user;
import irccore.server;
import bot.dbot;



// Currently used to test if implemented
// classes work correctly
int main( char[][] argv )
{
  // Server info
  ServerInfo serverInfo = ServerInfo
  (
    "Server Name",
    "Server Host",
    6667 // Port
  );

  // Identity of the bot
  UserInfo botInfo;
  botInfo.nick = "dbot";
  botInfo.ident = "dbot";
  botInfo.realName = "dbot";
  
  DBot bot = new DBot( botInfo, serverInfo );
  bot.Start();
  delete bot;

  return 0;
}

