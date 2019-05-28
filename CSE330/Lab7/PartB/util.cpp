//util.cpp
#include "util.h"

list <Course *> all_courses;    //global variables
list <Student *> all_students;
const int maxStudents = 40;

void readCourses ( istream &infile )
{
  string name;
  int max;

  while ( infile >> name >> max ) {
    Course *newCourse = new Course ( name, max );
    all_courses.push_back ( newCourse );
  }
}

Student *findStudent( string &searchName )
{
  list<Student *>::iterator start, stop;
  start = all_students.begin();
  stop = all_students.end();
  for ( ; start != stop; ++start )
    if ( (*start)->name() == searchName )
	return *start;
  Student *newStudent = new Student ( searchName );
  all_students.push_back ( newStudent );
  return newStudent;
}

Course *findCourse( string &searchName )
{
  list<Course *>::iterator start, stop;
  start = all_courses.begin();
  stop = all_courses.end();
  for ( ; start != stop; ++start )
    if ( (*start)->name() == searchName )
	return *start;
  Course *newCourse = new Course ( searchName, maxStudents );
  all_courses.push_back ( newCourse );
  return newCourse;
}



void readStudents ( istream &infile )
{
  string name;
  string course;

  while ( infile >> name >> course ) {
    Student *theStudent = findStudent ( name );
    Course  *theCourse = findCourse ( course );
    if ( theCourse != 0 )
	theStudent->addCourse( theCourse );
    else
	cout << "student " << name <<
	  " requested invalid course " << course << endl;
  }
}

void fillCourses()
//fill as many students as possible in each course
//priority given by input order ( first come, first served
{
  list <Student *>::iterator s_start, s_end;
  s_start = all_students.begin();
  s_end = all_students.end();

  for ( ; s_start != s_end; ++s_start ) {
    list <Course *>::iterator c_start, c_end, c_next;
    c_start = ( *s_start)->firstCourse();
    c_end = ( *s_start )->lastCourse();
    for ( ; c_start != c_end; c_start = c_next ) {
	c_next = c_start;  ++c_next;
	//if not full add student
	if ( !(*c_start)->full() )
	  (*c_start)->addStudent( *s_start);
	else
	  (*s_start)->removeCourse( c_start );
    } //for
  } //for
}


bool studentCompare( Student *a, Student *b)
{
  return a->name() < b->name();
}

void generateCourseReports()
//generate class lists for each course
{
  list<Course *>::iterator start, stop;
  start = all_courses.begin();
  stop = all_courses.end();
  for ( ; start != stop; ++start )
    (*start)->generateClassList();
}

void generateStudentReports()
//generate class list for students
{
  list <Student *>::iterator s_start, s_stop;
  list <Course *>::iterator c_start, c_stop;
  s_start = all_students.begin();
  s_stop = all_students.end();
  //generate the list for each student
  for ( ; s_start != s_stop; ++s_start ) {
    cout << "Class list for " << (*s_start)->name() << endl;
    c_start = (*s_start)->firstCourse();
    c_stop = (*s_start)->lastCourse();
    for ( ; c_start != c_stop; ++c_start )
	cout << (*c_start)->name() << endl;
    }
}

