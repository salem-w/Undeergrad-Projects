Person: person_main.o Person.o
	g++ -o Person person_main.o Person.o

person_main.o: person_main.cpp Person.h
	g++ -c person_main.cpp

Person.o: Person.cpp Person.h
	g++ -c Person.cpp

clean: 
	rm *.o Person