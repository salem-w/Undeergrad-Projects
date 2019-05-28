/******************************************************************************
 * Waleed Salem
 * File: person_main.cpp
 * 04/23/16
 * This program provides a vector of type Person, and uses a file stream to
 * take the values stored within the file and place those values into each 
 * index of the person vector. It then prints out all persons with a birthday
 * lying in the month of April.
 *****************************************************************************/


#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#include "Person.h"

using namespace std;

main()
{
	Person temp;
    string name, month, day, year;
    int i = 0;
    vector<Person> friends;
    fstream in;
    in.open("people.txt");

    //if the file does not exist or could not open then stop the program
    if(!in.is_open()) {
        cout << "Could not open file.\n";
        return 1;
    }

   //while the end of file has not been reached
   while(!in.eof())
    {
        //obtains the values of the line and places it into variables
        in >> name >> month >> day >> year;
        temp.set_name(name);
        friends.push_back(temp);
        friends[i].set_birthday(month, day, year);

        i++;

    }

    for(i = 0; i < friends.size(); i++)
    {   
        if(friends[i].is_equal("Apr"))
        {
            cout << "Name: " << friends[i].get_name() << " Birthday: "
            << friends[i].get_birthday() << endl;
        }
    }//end loop

}//end main