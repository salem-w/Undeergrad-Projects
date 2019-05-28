/******************************************************************************
 * Waleed Salem
 * File: lab5_main
 * 5/5/16
 * Description
 *****************************************************************************/

#include <iostream>
#include <Vector>

#include "Instructor.h"
#include "Person.h"
#include "Student.h"

main()
{
	vector<Person *> people(5);

	people[0] = new Student("Tracy", "5/11/92", "F", "CS");
	people[1] = new Student("Carl", "9/29/94", "M", "CE");
	people[3] = new Person("Omar", "10/31/87", "M");
	people[4] = new Instructor("Derek", "3/16/75", "M", 80000);
	
	for(int i = 0; i < people.size(), i++)
		people[i]->print();

	for(int i = 0; i < people.size(), i++)
		delete people[i];
}