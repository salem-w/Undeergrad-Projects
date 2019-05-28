/******************************************************************************
 * Waleed Salem
 * File: student.h
 * 4/28/16
 * The class Student definition, includes public member functions and two
 * strings in the private data fields.
 * 100% Completed
 *****************************************************************************/

 #ifndef STUDENT_H
 #define STUDENT_H

 #include <string>

 using namespace std;

class Student
{
private:
    string name;
    string id;
public:
    Student();
    Student(string n, string sid);
    void set_name(string n);
    void set_id(string sid);
    string get_name();
    string get_id();
	
};
 #endif