/******************************************************************************
 * Waleed Salem
 * File: Person.cpp
 * 5/1/16
 * The implementation of the Person class, includes functions to access values
 * and to set a best friend.
 *****************************************************************************/

 #include "Person.h"

 #include <string>

//Default constructor, assigns null values
Person::Person(): name(""), best_friend(0), popularity(0) { }

//Assigns the name n to the type person,default of no best friend 0 popularity 
Person::Person(string n): name(n), best_friend(0), popularity(0) { }

//Gets the name of the person
string Person::get_name()
{
    return name;
}

//Gets the best friend assigned to the person
string Person::get_best_friend()
{
    if(best_friend != 0)//check for null pointer
        return best_friend->name;
    return "";
}

//Gets the popularity value of the person
int Person::get_popularity()
{
    return popularity;
}

//Sets the person's bestfriend
void Person::set_best_friend(Person * bf)
{
    best_friend = bf;
    (bf->popularity)++;//increment popularity
}