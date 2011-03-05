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
    "TestServer",
    "localhost",
    6667
  );

  // Identity of the bot
  UserInfo botInfo;
  botInfo.nick = "DBot";
  botInfo.ident = "DBotV.01";
  botInfo.realName = "ByKoukari";
  
  DBot bot = new DBot( botInfo, serverInfo );
  bot.Start();
  delete bot;

  return 0;
}

