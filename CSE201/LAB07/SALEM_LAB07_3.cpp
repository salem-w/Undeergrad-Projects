/***********************************************************************************
 * CSE201 W16: SALEM      -- LAB 07: Exercise 3
 * 004893625
 * LAB 07 -- Exercise : LAB07_3.cpp
 *
 * This program implements a linear search, it searches through a data
 * structure element by element until a match is found. The search is an
 * inefficient algoritm, with a performance writtenin Big "O" notation
 * as an O(n) algorithm.
 **********************************************************************************/

#include <cassert>
#include <iostream>
#include <vector>

using namespace std;

/**
 * This function implements a linear search algorithm, it searches element
 * by element until a matching value is found.
 * @param arr[]
 *    - The array to search in
 * @param size
 *    - The size of the array, used to limit the amount the loop returns
 * @param k
 *    - The value to search for in the data structure
 * @return
 *    - Returns the index the matching value is at, if no matching value is
 *      found, the function returns -1.
 */
int search(int arr[], int size, int k)
{
	int index = 0;
	int i = 0;
	bool notFound = true;

	while(notFound)
	{

		if (i == size)
			return -1;
		if(k == arr[i])
		{
			notFound= false;
			index = i;
		}

		else
			i++;
	}

	return index;
}
/**
 * This procedure holds the assertions to call, the procedure calls the linear
 * search function and passes values.
 * @param arr[]
 *    - This is the array that will be passed into the linear search funtion.
 * @param size
 *    - This is the size of the array
 */
void myAssertions(int arr[], int size)
{
	assert(search(arr, size, 145) == 1);
	assert(search(arr, size, 388) == -1);
	assert(search(arr, size, 1001) == 9);
	assert(search(arr, size, 12) == -1);
	assert(search(arr, size, 1) == 0);
	assert(search(arr, size, 94) == 5);
	assert(search(arr, size, 149) == -1);

	cout << "All tests passed.\n";
}

int main(int argc, char const *argv[])
{
	int arr[10] = {1, 145, 46, 890, 78, 94, 456, 23, 727, 1001};
	int size = 10;
	myAssertions(arr, size);
	return 0;
}
