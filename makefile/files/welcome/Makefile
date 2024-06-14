welcome: main.o message.o 
	cc main.o message.o -o welcome

main.o: main.c 
	cc -c main.c 

message.o: message.c message.h
	cc -c message.c

clean:
	rm -f *.o welcome