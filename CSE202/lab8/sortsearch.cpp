#include <fstream>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

//The O(log(n)) binary search algorithm, this derivative of binary search is 
//recursive. It constantly halves the array of integer searching for k
int binary_search(const vector<int>& arr, int start, int end, int k)
{
	//not found
	if(start > end)
		return -1;

	int mid = (start + end)/2;

	if( k == arr[mid])
		return mid;

	if( k < arr[mid])
		return binary_search(arr, start, mid - 1, k);

	if(k > arr[mid])
		return binary_search(arr, mid + 1, end, k);


} 

//The O(n^2) algorithm selection sort, the function swaps two values until the
//array is sorted
void selection_sort(vector<int>& arr, int n)
{

	for(int i = 0; i < n-1; i++)
		for(int j = i + 1; j < n; j++)
			if(arr[i] > arr[j])
				swap(arr[i], arr[j]);

}

main()
{
	int input, n;
	ifstream in;
	in.open("array");
	if(!in.is_open()) {
		cout << "Error opening file" << endl;
		return 1;
	}
	vector<int> v;
	vector<int> search;

	while(in >> input)
		v.push_back(input);

	in.close();

	selection_sort(v, v.size());

	
	for(int i = 0; i < v.size(); i++)
		cout << v[i] << endl;

	cout << "Enter numbers to search for in the vector Ctrl D to stop " << endl;
	while(cin >> input) {
		n = binary_search(v, 0, v.size(), input);
		search.push_back(n);
	}

	cout << "The output is: \n";

	for(int i = 0; i < search.size(); i ++)
		cout << search[i] << endl;

	
}
