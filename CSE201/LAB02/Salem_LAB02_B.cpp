/*********************************************************************
* Salem, Waleed CSE201 W2016 - LAB02: Part B, Exercise 2
* Algorithm
* Prompt for a measurement in meters, m
* Convert m into feet and inches
* Displays m meters is equal to _feet and _inches
*
*********************************************************************
*/

#include <iostream>
#include <cmath>
#include <string>
#include <string.h>
bool is_number(const std::string& s)
{
	return(strspn(s.c_str(), ".0123456789") == s.size());
	
}

int main(int argc, char const *argv[])
{
	double m;
	int f;
	double i;
	int inches;
	double f_double;

	
		std::cout << "Enter a number in meters \n";

		std::cin >> m;
		std::stringstream ss >> m;
		std::string check = ss.str();
	
		if (is_number(check) == true)
		{
			f = (int)(m * 3.281);
			f_double = (double) m * 3.281;
			i = ((f_double - f) * 12);
			inches = (int)i;

			std::cout << f << " ft " << inches << " in \n";


			return 0;

		}
		else
		{
			std::cout << "Error! Please enter a NUMBER \n";
			return -1;
		}
}

