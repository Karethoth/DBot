files=*.d irccore/*.d bot/*.d
exec=dbot
all :
	dmd -of$(exec) $(files)

clean :
	rm -rf *.o

