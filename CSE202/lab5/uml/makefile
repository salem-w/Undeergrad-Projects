
School: school_main.o Student.o Instructor.o Person.o
	g++ -o School school_main.o Student.o Instructor.o Person.o

school_main.o: school_main.cpp Person.o Student.o Instructor.o
	g++ -c school_main.cpp

Student.o: Student.h Student.cpp Person.o
	g++ -c Student.cpp

Instructor.o: Instructor.h Instructor.cpp Person.o
	g++ -c Instructor.cpp

Person.o: Person.cpp Person.h
	g++ -c Person.cpp

clean:
	rm *.o School