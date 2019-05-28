/***********************************************************************************
 * CSE201 W16: SALEM      -- LAB 06: Exercise 1
 * 004893625
 * LAB 06 -- Exercise : LAB06_4.cpp
 *
 * This program inserts a new value into the vector and sorts the values to
 * be in increasing order, it then prints the contents of the newly sorted vector.
 **********************************************************************************/

#include <iostream>
#include <vector>

using namespace std;

/**
 * This function inserts a value k into a vector v while maintaining
 * a strictly increasing order
 *
 * @param v
 *    - This is the vector passed by the main function
 * @param k
 *    - This is a type int that gets pushed into the vector
 * @return
 *    - returns the newly sorted vector
 */
vector<int> insert(vector<int> v, int k)
{
	v.push_back(k);
	// loops through the function swapping values
	for(int i = v.size() - 2; i >= 0; i--)
	{
		if(v[i] > v[i +1])
			swap(v[i + 1], v[i]);
		else
			break;

	}

	return v;

}


int main(int argc, char const *argv[])
{
	vector<int> myVector(5);
	myVector[0] = 1;
	myVector[1] = 4;
	myVector[2] = 7;
	myVector[3] = 12;
	myVector[4] = 17;

	int input;
	cout << "Enter a value you would like to insert into the vector:\n";
	cin >> input;
	myVector = insert(myVector, input);

    //loops through each index and prints out value of that index
	for(int i = 0; i < myVector.size(); i++)
	{
		cout << myVector[i] << " ";
	}
	cout << "\n";



	return 0;
}
