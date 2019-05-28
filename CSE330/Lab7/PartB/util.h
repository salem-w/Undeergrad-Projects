//util.h
#ifndef UTIL_H
#define	UTIL_H

#include "course.h"
#include "student.h"

void readCourses ( istream &infile );
Student *findStudent( string &searchName );
Course *findCourse( string &searchName );
void readStudents ( istream &infile );
void fillCourses();
bool studentCompare( Student *a, Student *b);
void generateCourseReports();
void generateStudentReports();

#endif
