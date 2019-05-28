/******************************************************************************
 * Waleed Salem
 * File: Course.cpp
 * 4/28/16
 * The implementation of the course class, has functions to access and set the
 * string and Student pointer private data fields.
 * 100% Completed
 *****************************************************************************/

#include <string>

#include "Course.h"
#include "Student.h"

//Default constructor, sets string and pointer to null values
Course::Course(): course_name(""), pointer(0) { }

//Constructs course object, assigns values to course_name and student pointer
Course::Course(string c, Student * p)
{
     course_name = c;
     pointer = p;
}

//function that sets the new course name
void Course::set_course(string c)
{
    course_name = c;
}

//function that sets the new address the pointer points to
void Course::set_pointer(Student * p)
{
    pointer = p;
}

//returns the value of course_name
string Course::get_course()
{
    return course_name;
}

//returns the address the Student pointer is pointing to
Student * Course::get_pointer()
{
    return pointer;
}

//Accesses the functions within student class to get the students name
string Course::find_name()
{
    return pointer->get_name();
}

//Accesses the function within student class to get the students ID #
string Course::find_id()
{
    return pointer->get_id();
}