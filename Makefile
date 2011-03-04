files=*.d irccore/*.d
exec=dbot
all :
	dmd -of$(exec) $(files)

clean :
	rm -rf *.o

