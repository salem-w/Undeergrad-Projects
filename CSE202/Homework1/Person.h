/******************************************************************************
 * Waleed Salem
 * File:
 * 04/23/16
 * This is the person class, it holds the name and the birthday of a person
 * in the object, along with procedures to access the data fields, to set the
 * data fields and to compare the months of the birthday data field
 *****************************************************************************/

#ifndef PERSON_H
#define PERSON_H

#include <string>

using namespace std;

class Person {
    private:
        string name, birthday;
    public:
        Person();
        Person(string n, string b);
        void set_name(string n);
        void set_birthday(string month, string day, string year);
        string get_name();
        string get_birthday();
        string get_month();
        bool is_equal(string month);
};

#endif