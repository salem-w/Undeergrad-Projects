 /************************************************************************************
 * CSE201 W16: SALEM      -- LAB 05: Part B
 * 004893625
 * LAB 05 -- Exercise : LAB05_B.cpp
 * 
 * This is the main program, it uses the EggCarton class to ask the user to 
 * add brown or white eggs into a carton. It does not allow the number of eggs in a carton
 * to go over 12.
 **********************************************************************************
 */



#include <iostream>
#include <string>
#include "EggCarton.h"

using namespace std;

int main(int argc, char const *argv[])
{
	int brownEggs;
	int whiteEggs;
	int amount;
	int input;
	string response;
	bool more = true;

	cout << "Enter the amount of brown eggs in the carton: \n";
	cin >> brownEggs;
	cout << "Enter the amount of white eggs in the carton: \n";
	cin >> whiteEggs;

	while(whiteEggs + brownEggs > 12)
	{
		cout << "There are more than twelve eggs in the carton please enter a different "
		<< "amount of eggs.\n";
		cout << "Number of brown eggs: \n";
		cin >> brownEggs;
		cout <<"Number of white eggs: \n";
		cin >> whiteEggs;
	}

	EggCarton carton(brownEggs, whiteEggs);

	while(more)
	{
	amount = carton.getTotalEggs();
	cout << "The egg carton has a total of " << amount << " eggs.\n";
	 if(amount == 12)
	 	break;
	cout << "Do you wish to add more eggs? (y/n) ";
	cin >> response;

	if(response != "y")
		break;

	cout << "How many brown eggs do you want to add? \n";
	cin >> input; 
	while(!carton.addBrownEggs(input))
	{
		cout << "There are too many eggs in the carton.\n";
		cout << "Enter a new value for the brown eggs: \n";
		cin >> input;
		if(carton.addBrownEggs(input))
			break;

	}
	cout << "How many white eggs do you want to add: \n";
	cin >> input;
	while(!carton.addWhiteEggs(input))
	{
		cout << "There are too many eggs in the carton \n";
		cout << "Enter a new value for the white eggs: \n";
		cin >> input;
		if(carton.addWhiteEggs(input))
			break;
	}

	if(carton.getTotalEggs() == 12)
		more = false;

    }

    cout << "The program is done!";
	return 0;
}
