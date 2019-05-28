/***********************************************************************************
 * CSE201 W16: SALEM      -- LAB 06: Exercise 1
 * 004893625
 * LAB 06 -- Exercise : LAB06_1.cpp
 *
 * This program takes an array and loops through each element of the set and finds
 * the maximum value withing that set, it then outputs the number.
 *
 **********************************************************************************/

#include <iostream>


using namespace std;

/**
 * This function returns the largest element in the vector
 *
 * @param arr
 *    - The array to find the max value in
 * @param numberOfElements
 *    - The value that holds the amount of times the loop should compute.
 * @return
 *    - Returns the largest number in the data structure
 */
int myMaximum(int arr[6], int numberOfElements)
{
	int max = arr[0];

	for(int i = 1; i < numberOfElements; i++)
	{
		if(max < arr[i])
			max = arr[i];
	}
	return max;
}

int main(int argc, char const *argv[])
{
	int myNumbers[6] = {1, 7, 9, 12, 5, 8};
	int length = 6;
	int myMax = myMaximum(myNumbers, length);

	cout << "The largest number in the array is " << myMax;


	return 0;
}
