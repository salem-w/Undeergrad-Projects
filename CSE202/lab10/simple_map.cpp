/******************************************************************************
 * Waleed Salem
 * File: simple_map.cpp
 * 6/8/16
 * Implements a map data structure and tests two template structure of map by 
 * outputing the values stored in each index.
 * Sketch: Utilizing a map, the program specifies whether each month is a 31
 * day month or not, outputing whether it is or not.
 * 100% completed
 *****************************************************************************/

#include <map>
#include <string>
#include <iostream>

using namespace std;

main()
{
    map<string, bool> m;

    m["Jan"] = true;
    m["Feb"] = false;
    m["Mar"] = true;
    m["Apr"] = false;
    m["May"] = true;
    m["Jun"] = false;
    m["Jul"] = true;
    m["Aug"] = true;
    m["Sep"] = false;
    m["Oct"] = true;
    m["Nov"] = false;
    m["Dec"] = true;
	//other months would default to false, only true values listed here
	m["January"] = true;
    m["March"] = true;
    m["May"] = true;
    m["July"] = true;
    m["August"] = true;
    m["October"] = true;
    m["December"] = true;

    string response;

    cout << "Enter a month name: ";
    cin >> response;

    if (m[response])
       cout << "This is a 31-day month.\n";
    else
       cout << "This is a non-31-day month or it is an invalid month name.\n";
}
