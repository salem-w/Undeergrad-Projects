Roster: Roster.o Student.o Course.o
	g++ -o Roster Roster.o Student.o Course.o

Roster.o: Roster.cpp Student.h Course.h
	g++ -c Roster.cpp

Student.o: Student.cpp Student.h Course.h
	g++ -c Student.cpp

Course.o: Course.cpp Course.h
	g++ -c Course.cpp

clean: 
	rm *.o Roster