/******************************************************************************
 * Waleed Salem
 * File: Roster.cpp
 * 4/28/16
 * Reads two files each containing name of students and their respective IDs,
 * and the other file contains name of students and the course they are taking.
 * And prints out the roster of the course.
 * Sketch: Pointers are used to solve the problem, 
 * Percent Completed
 *****************************************************************************/

#include <fstream>
#include <iomanip>
#include <iostream>
#include <vector>

#include "Course.h"
#include "Student.h"

using namespace std;

//uses string match to find all instances of the course name being pointed to 
//in the vector,and prints those instances.
void print_roster(vector<Course *> c, string match)
{
	cout << match << "\n";

    for(int i = 0; i < c.size(); i++)
        if(c[i]->get_course() == match)
        {
            cout << "    " << left << setw(10) << c[i]->find_name() << setw(6) 
            << c[i]->find_id() << endl;
        }
    cout << "\n";
}

main()
{
	int i = 0;
	string name;
	string id;
	string course_name;
    vector<Student *> enrolled;
    vector<Course *> offered;
    Student * student_pointer;
    Course * course_pointer;

    ifstream in;

    in.open("students");

    if(!in.is_open()) {
        cout << "Couldn't open 'students' file.\n Does the file exist?\n";
        return 1;
    }
    
    while(!in.eof()) {
        //store the variables
        in >> name >> id;

        //construct a dynamic memory allocation, and push back the pointer
        student_pointer = new Student(name, id);
        enrolled.push_back(student_pointer);
    }

    in.close();
    //use the same ofstream to open another file
    in.open("courses");

    if(!in.is_open()) {
    	cout << "Couldn't open 'courses' file.\n Doss the file exist?\n";
    	return 2;//return error code 2
    }



   while(!in.eof()) {
    	in >> name >> course_name;

        for(i = 0; i < enrolled.size(); i++)
            {
                //if the name of object is the same as the name in courses file
                if(enrolled[i]->get_name() == name)
                {
                    student_pointer = enrolled[i];//point to the index

                    course_pointer = new Course(course_name, student_pointer);
                    offered.push_back(course_pointer);

                }
            }

    }

    print_roster(offered, "CSE202");
    print_roster(offered, "MATH272");
    print_roster(offered, "PHYS221");
    print_roster(offered, "HIST101");

    //delete the dynamic memory allocations
    for(i = 0; i < enrolled.size(); i++)
        delete enrolled[i];
    for(i = 0; i < offered.size(); i++)
        delete offered[i];
}