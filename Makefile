files=*.d irccore/*.d bot/*.d statsystem/*.d
exec=dbot
all :
	dmd -of$(exec) $(files)

clean :
	rm -rf *.o

