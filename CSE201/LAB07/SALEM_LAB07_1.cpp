#include <iostream>
#include <vector>

using namespace std;

/**
 * An implementation of the O(log(n)) algorithm binary search.
 * This function uses recursion to consistently decrease the
 * range of the vector to search in.
 *
 * @param v
 *    - This is the vector to search in.
 * @param from
 *    - This is the starting range to look in inside the vector.
 * @param to
 *    - This is the ending range to look in inside the vector.
 * @param k
 *    - This is the value to search for in the vector.
 * @return
 *    - Returns true if a match is found, false otherwise.
 * @return
 *    - This function returns true if a matching value is found, false otherwise
 */
bool binarySearch(const vector<int>& v, int from, int to, int k)
{

	if( from > to)
		return false;

	int mid = (from + to) / 2;
	if(v[mid] == k)
		return true;
	else if ( v[mid] < k)
		return binarySearch(v, mid++, to, k);
	else
		return binarySearch(v, from, mid--, k);
}
/**
 * This procedure prints wheter a match is found depending on if
 * binarySearch returns true.
 *
 * @param myVector
 *    - The vector to search in.
 * @param k
 *    - The value to search for in the vector.
 */
void printResult(const vector<int>& myVector, int k)
{
	//sets match to whatever value binarySearch returns, calls binarySearch
	bool match = binarySearch(myVector, 0, myVector.size() - 1, k);
	if (match)
		cout << "Found a match!" << endl;
	else
		cout << "There is no match" << endl;

}
/**
 * This procedure sets up the vector with all its values.
 *
 * @param myVector
 *    - The vector to assign values to.
 */
void setUpVector(vector<int>& myVector)
{
	myVector[0] = 3;
	myVector[1] = 7;
	myVector[2] = 16;
	myVector[3] = 45;
	myVector[4] = 67;
	myVector[5] = 98;
	myVector[6] = 124;
	myVector[7] = 156;
	myVector[8] = 189;
	myVector[9] = 234;
}

int main(int argc, char const *argv[])
{
	int k;
	vector<int> myVector(10);
	setUpVector(myVector);

	cout << "Enter a value to search in the vector:" << endl;
	cin >> k;
	printResult(myVector, k);

	return 0;
}
