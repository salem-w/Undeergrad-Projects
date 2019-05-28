/******************************************************************************
 * Waleed Salem
 * File: Person.cpp
 * 04/23/16
 * This is the implementation of the Person header file, it includes functions
 * to access and set the data fields, and allows to compare the months of the
 * birthdays.
 *****************************************************************************/



#include <string>

#include "Person.h"

using namespace std;

//Default construsctor, sets empty values
Person::Person(): name(""), birthday("") { }

//Constructor that sets the values of name and birthday
Person::Person(string n, string b): name(n), birthday(b) { }

//Sets the name data field of the person object
void Person::set_name(string n)
{
    name = n;
}

//sets the birthday data field of the person object by appending the params
void Person::set_birthday(string month, string day, string year)
{
    birthday = month + " " + day + " " + year;
}

//returns the value of the name data field
string Person::get_name() 
{
    return name;
}

//returns the value of the birthday data field
string Person::get_birthday()
{
    return birthday;
}

//returns a substring of the birthday data field that contains the month
string Person::get_month()
{
    return birthday.substr(0,3);
}

//checks if two strings are equal and returns true, false otherwise
bool Person::is_equal(string month)
{
    if (get_month() == month)
    {
	    return true;
    }
    return false;
}