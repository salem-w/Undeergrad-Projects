/******************************************************************************
 * Waleed Salem
 * File: Course.h
 * 4/28/16
 * The class definition of Course, includes a string and Student pointer in the
 * private data field
 * Percent Completed
 *****************************************************************************/

 #ifndef COURSE_H
 #define COURSE_H

 #include <string>

 #include "Student.h"

class Course
{
private:
    string course_name;
    Student * pointer;
public:
    Course();
    Course(string c, Student * p);
    void set_course(string c);
    void set_pointer(Student * p);
    string get_course();
    Student * get_pointer();
    string find_name();
    string find_id();
};

#endif