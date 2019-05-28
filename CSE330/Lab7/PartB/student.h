//student.h
#ifndef STUDENT_H
#define STUDENT_H

#include <string>
#include <iostream>
#include <fstream>
#include <list>
#include "course.h"

typedef list<Course *>::iterator citerator;

class Student {

public:
  Student ( string name );
  string name();
  void addCourse ( Course *c );
  citerator firstCourse();
  citerator lastCourse();
  void removeCourse ( citerator & citr );
 
protected:
  string nameText;
  list <Course *> courses;
};

#endif
