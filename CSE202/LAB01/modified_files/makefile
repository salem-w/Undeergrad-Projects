Account: Account_main.o Account.o
	g++ -o Account_main.o Account.o

Account_main.o: Account_main.cpp Account.h
	g++ -c Account_main.cpp

Account.o: Account.cpp Account.h
	g++ -c Account.cpp

clean:
	rm *.o Account
