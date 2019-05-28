//student.cpp
#include "student.h"


Student::Student ( string name ) 
{ 
  nameText = name; 
}

string Student::name() 
{ 
  return nameText; 
}

void Student::addCourse ( Course *c ) 
{ 
  courses.push_back( c ); 
}

citerator Student::firstCourse() 
{ 
  return courses.begin(); 
}

citerator Student::lastCourse() 
{ 
  return courses.end(); 
}

void Student::removeCourse ( citerator & citr ) 
{ 
  courses.erase( citr ); 
}

