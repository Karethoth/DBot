files=*.d irccore/*.d bot/*.d statsystem/*.d
exec=dbot
all :
	dmd -of$(exec) $(files)
	make clean

clean :
	rm -rf *.o

