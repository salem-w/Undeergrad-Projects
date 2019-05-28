/******************************************************************************
 * Waleed Salem
 * File: Person.h
 * 5/1/16
 * The class definition of the Object Person, defines all functions and data
 * fields.
 *****************************************************************************/

#ifndef PERSON_H
#define PERSON_H

#include <string>

using namespace std;

class Person
{
private:
    string name;
    Person * best_friend;
    int popularity;
public:
    Person();
    Person(string n);
    string get_name();
	string get_best_friend();
	int get_popularity();
	void set_best_friend(Person *);
};

#endif