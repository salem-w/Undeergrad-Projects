/***********************************************************************************
 * CSE201 W16: SALEM      -- LAB 07: Exercise 2
 * 004893625
 * LAB 07 -- Exercise : LAB07_2.cpp
 *
 * This program initializes a array and implements a recursive binary search
 * function. The function is fairly efficient, with a (in Big "O" notation) speed
 * of O(log(n)). So as the array grows the time it takes to complete matches the
 * graph of log(n).
 *
 **********************************************************************************/

#include <iostream>
#include <vector>

using namespace std;
/**
 * This function implements a recursive binary search, it searches through the
 * array for a matching function.
 *
 * @param a[]
 *    - The array to search a matching value in
 * @param begin
 *    - This is the starting range of the array
 * @param size
 *    - This holds the size of the array and the ending range to search
 * @param k
 *    - This is the value to search for
 * @return
 *    - This function returns the index of the matching value
 */
int binarySearch(int a[], int begin, int size, int k)
{

	 if (begin >= size)
	   return -1;

	 else
	 {
	 int mid = (begin + size)/2;

	 if (k == a[mid])
	 return mid;
	 else

	 if (k < a[mid])
	     return binarySearch(a,begin, mid-1, k);
	 else
	     return binarySearch(a, mid+1, size, k);

	 } // end if
	 }// end binarySearch

	 /**
	  * This procedure prints the result of the search, there two outputs
		* depending on if a match was found or not.
		*
		* @param arr[]
		*    - This is the array that will pass on to binary search
		* @param size
		*    - This is the size of the array
		* @param k
		*    - This is the value to search for, it will be passed to binary search
		*/
void printResult(int arr[], int size, int k)
{
	//initializes an int type named index, calls the binary serach function and
	//passes the values of the params to the function.
	int index = binarySearch(arr, 0, size, k);
	if(index == -1)
		cout << "No matching value was found!\n";
	else
		cout << "The matching value is at index "
		 << index << endl;
}
int main(int argc, char const *argv[])
{
	int arr[10] = {1, 13, 26, 78, 90, 145, 187, 220, 456, 560};
	int size = 10;
	int k;
	cout << "Enter the value you want the index of:\n";
	cin >> k;
	printResult(arr, size, k);
	return 0;
}
