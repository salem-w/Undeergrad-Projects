/******************************************************************************
 * Waleed Salem
 * File: Student.cpp
 * 4/28/16
 * The implementation of the class Student, includes functions to access and
 * modify string name and string id.
 * 100% Complete
 *****************************************************************************/

#include <string>

#include "Student.h"

using namespace std;

//Default constuctor, assigns values to null
Student::Student(): name(""), id("") { }

//Constructs the student object by assigning values
Student::Student(string n, string sid): name(n), id(sid) { }

//Sets the value of the name of the Student object
void Student::set_name(string n) 
{
    name = n;
}

//Sets the value of the ID of the student object
void Student::set_id(string sid)
{
    id = sid;
}

//Accessest the name of the Student Object
string Student::get_name() { return name; }

//Accesses the ID of the student object
string Student::get_id() { return id; }


