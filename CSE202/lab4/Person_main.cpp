/******************************************************************************
 * Waleed Salem
 * File: Person_main.cpp
 * 5/1/16
 * This program reads names from a file and assigns a pointer to each Person,
 * the program gives a popularity number to each person based on if they have
 * a best friend or not.
 *
 * Pointers are used to assign values to the names, the program prompts the user
 * to enter a name of the person's best friend. There is no duplicate entry and
 * the name must exist within the names file.
 * 100% Completed
 *****************************************************************************/

#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

#include "Person.h"

using namespace std;

//An O(n) linear search that returns true if a best friend has already been
//declared with the specified name n, false otherwise
bool check_duplicate(const vector<Person *>& p, string n)
{
    for(int i = 0; i < p.size(); i++)
        if(p[i]->get_best_friend() == n)
            return true;

    return false;
}

main()
{
    string name;
    vector<Person *> people;
    Person * person_pointer;

    ifstream in;

    in.open("names");
    if(!in.is_open())
    {
        cout << "Couldn't open 'names' file.\nDoes the file exist?\n";
        return 1;
    }

    while(!in.eof()) {
        in >> name;

        if(!check_duplicate(people, name)) {
        person_pointer = new Person(name);
        people.push_back(person_pointer);
        }
    }

    in.close();

    int i, j;

    for(i = 0; i < people.size(); i++) {
        cout << "Who is " << people[i]->get_name() << "'s best freind? \n";
        cin >> name;

        //search for best friend
        bool is_searching = true;
        j = 0;
        while(is_searching)//search through vector until matching name is found
        {
            if(j == people.size())
            {
                cout << "Couldn't find best friend " << name << endl;
                cout << "Enter a new name:\n";
                cin >> name;
                j = 0;
            }

            if(people[j]->get_name() == name)//found matching name
            {
                is_searching = false;
                people[i]->set_best_friend(people[j]);
            }

            j++;
        }

    }//end large loop

    //list of name, best friend, and popularity count
    for(i = 0; i < people.size(); i++) {
        person_pointer = people[i];
        cout << left << setw(10) << person_pointer->get_name();
        cout << left << setw(10) << person_pointer->get_best_friend();
        cout << right << setw(2) << person_pointer->get_popularity() << endl;
    }

    //clean up
    for(i = 0; i < people.size(); i++)
        delete people[i];

}