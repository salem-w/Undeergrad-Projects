/***********************************************************************************
 * CSE201 W16: SALEM      -- LAB 06: Exercise 1
 * 004893625
 * LAB 06 -- Exercise : LAB06_6.cpp
 *
 * This program checks if the values and size of the two vectors are a match
 **********************************************************************************/

#include <iostream>
#include <vector>

using namespace std;


/**
 * This function checks if the vectors passed are the same
 *
 * @param a
 *    - The first vector passed to compare
 * @param b
 *    - The second vector passed to compare
 * @return
 *    - Returns true if the vectors are identical, false otherwise
 */
bool areIdentical(const vector<int>& a, const vector<int>& b)
{
	return(a == b);
}

int main(int argc, char const *argv[])
{
	//create two vectors
	vector<int> one(3);
	one[0] = 1; one[1] = 3; one[2] = 4;

	vector<int> two(3);
	two[0] = 1; two[1] = 4; two[2] = 3;

	//check if they are identical or not
	if(areIdentical(one, two))
		cout << "They are identical!\n";
	else
		cout << "They are not the same!\n";


	return 0;
}
