//course.cpp

#include "course.h"
#include "student.h"

Course::Course ( string name, int s ) : nameText( name ), max( s )
{
}
  
string Course::name() 
{ 
  return nameText; 
}

bool Course::full() 
{ 
  return students.size() >= max; 
}
  
void Course::addStudent ( Student *s ) 
{ 
  students.push_back( s ); 
}

/*
  Because it uses Student::iterator, therefore needs to
  define after Student
*/
void Course::generateClassList()
//print class list of all students
{
  students.sort( studentCompare );
  cout << "Class list for " << nameText << endl;
  list<Student *>::iterator start, stop;
  start = students.begin();
  stop = students.end();
  for ( ; start != stop; ++start )
    cout << (*start)->name() << endl;
}

