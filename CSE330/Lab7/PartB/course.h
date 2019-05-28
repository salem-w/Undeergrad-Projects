//course.h
#ifndef COURSE_H
#define COURSE_H

#include <string>
#include <iostream>
#include <fstream>
#include <list>

using namespace std;

class Student;		//forward declaration
bool studentCompare( Student *a, Student *b);

class Course {
protected:
  string nameText;
  int max;
  list<Student *> students;
public:
  Course ( string name, int s );
  string name();
  bool full();
  void addStudent ( Student *s );
  void generateClassList ();
};


#endif
