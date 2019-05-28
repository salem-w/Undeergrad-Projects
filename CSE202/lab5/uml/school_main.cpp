/******************************************************************************
 * Waleed Salem
 * File: school_main.cpp
 * 5/5/16
 * Description
 *****************************************************************************/

#include <iostream>
#include <vector>

#include "Instructor.h"
#include "Person.h"
#include "Student.h"

main()
{
	 vector<Person *> people(5); // vector of pointers to Person

    people[0] = new Student("Derek", "6/14/92", "M", "CE");
    people[1] = new Student("Ashley", "9/19/76", "F", "CS");
    people[2] = new Instructor("Patrice", "5/24/82", "F", 62000);
    people[3] = new Person("Peter", "6/14/80", "M");
    people[4] = new Person	("Omar", "7/4/94", "M");

    for (int i = 0; i < people.size(); i++)
        people[i]->print();

    // clean up
    for (int i = 0; i < people.size(); i++)
        delete people[i];
}
