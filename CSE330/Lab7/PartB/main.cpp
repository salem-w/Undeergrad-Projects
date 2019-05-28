#include <iostream>
#include <string>
#include <sstream>
#include "course.h"
#include "student.h"
#include "util.h"

using namespace std;

void insert_c()
{
	stringstream ss;
	string t;
	int x;

	cout << "Enter a course name \n";
	cin >> t;
	cout << "Enter a max \n";
	cin >> x;

	Course *c = findCourse(t);
	ofstream out;
	out.open("course.dat", ios::app);
	out << c->name() << " " << x;
	out.close();
}

void insert_s()
{
	stringstream ss;
	string s, t;

	cout << "Enter a student name \n";
	cin >> s;
	cout << "Enter a course name \n";
	cin >> t;

	Student st(s);
	Course *c = findCourse(t);
	st.addCourse(c);

	ofstream out;
	out.open("student.dat", ios::app);
	string str(st.name());
	out << str << " " << c; 
	out.close();
	
}

void list_s(ifstream& a)
{
	readCourses ( a ); 	
 	generateStudentReports();
	
}

void list_c(ifstream& b)
{
	readCourses (b);
	generateCourseReports();
}

void save()
{
	cout << "Your program has been saved" << endl;
}

int main()
{
	ifstream in_course("course.dat");
    ifstream in_student("student.dat" );
	string s;
	stringstream ss;

	bool on;

	while(!on)
	{
		cout << "Enter a command or q to exit" << endl;
		cin >> s;
		if(s == "q")
		{
			save();
			break;
		}

		if(s == "is")
			insert_s();

		if(s == "ic")
			insert_c();

		if(s == "ls")
			list_s(in_student);

		if(s == "lc")
			list_c(in_course);

		if(s == "s")
			save();
		
			
	}

	in_course.close();
	in_student.close();


    return 0;
}

