/******************************************************************************
 * CSE201 W16: SALEM      -- LAB 05: Part A
 * 004893625
 * LAB 05 -- Exercise : LAB05_A.cpp
 * 
 * This program uses a class called Numbers, and uses the constructor to 
 * return booleans of funtions isPrime, and isDivisibleBy depending on the number.
 ****************************************************************************
 */

#include <iostream>
#include "Numbers.h"

using namespace std;

int main(int argc, char const *argv[])
{
	Numbers nine(9);
 if (!nine.isPrime()) cout << "9 is not prime! " << endl;
 if (nine.isDivisibleBy(1)) cout << "9 is divisible by 1. "<< endl;
 if (!nine.isDivisibleBy(2)) cout << "9 is not divisible by 2! "  << endl;
 if ( nine.isDivisibleBy(3)) cout << "9 is divisible by 3. " << endl;
 if (!nine.isDivisibleBy(8)) cout << "9 is not divisible by 8! " << endl;
 if ( nine.isDivisibleBy(9)) cout << "9 is divisible by 9. " << endl;
 cout << endl << "\n";
 Numbers seven(7);
 if ( seven.isPrime()) cout << "7 is prime. " << endl ;
 if ( seven.isDivisibleBy(1)) cout << "7 is divisible by 1. " << endl;
 if (!seven.isDivisibleBy(2)) cout << "7 is not divisible by 2! " << endl;
 if (!seven.isDivisibleBy(3)) cout << "7 is not divisible by 3! " << endl;
 if ( seven.isDivisibleBy(7)) cout << "7 is divisible by 7. " << endl;
 cout << endl << "\n";
 Numbers seventySeven(77);
 if (!seventySeven.isPrime()) cout << "77 is not prime! " << endl;
 cout << endl << "\n";
 Numbers seventyThree(73);
 if (seventyThree.isPrime()) cout << "73 is prime. " << endl;
 cout << endl << "\n";
 Numbers twentySeven(27);
 if (!twentySeven.isPrime()) cout << "27 is not prime! " << endl;
 if (!twentySeven.isDivisibleBy(2)) cout << "27 is not divisible by 2! " << endl;
 if (twentySeven.isDivisibleBy(3)) cout << "27 is divisible by 3. " << endl;
 if (twentySeven.isDivisibleBy(9)) cout << "27 is divisible by 9. " << endl ;
 cout << endl << "\n";
 cout << "All tests passed.\n" << endl;

	return 0;
}
