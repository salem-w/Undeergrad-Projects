/***********************************************************************************
 * CSE201 W16: SALEM      -- LAB 06: Exercise 1
 * 004893625
 * LAB 06 -- Exercise : LAB06_8.cpp
 *
 * This program checks if a vector is strictly increasing, it creates a vector
 * and begins testing if the loop is in increasing order through a loop.
 *
 **********************************************************************************/

#include <iostream>
#include <vector>

using namespace std;

/**
 * This function checks if the vectors values are in increasing order
 *
 * @param v
 *    - The vector passed to test if it is in increasing order
 * @return
 *    - Returns true if the vector is strictly increasing, false otherwise
 */
bool isStrictlyIncreasing(const vector<int>& v)
{
	for(int i = 1; i < v.size(); i++)
	{
		if(v[i - 1] > v[i])
			return false;
	}
	return true;
}

int main(int argc, char const *argv[])
{
	vector<int> myVector(4);
	myVector[0] = 2;
	myVector[1] = 5;
	myVector[2] = 7;
	myVector[3] = 12;
	myVector[3] = 11;
	{

	};

	if(isStrictlyIncreasing(myVector))
		cout << "The numbers are in increasing order!\n";
	else
		cout << "The numbers are not in increasing order!\n";


	return 0;
}
