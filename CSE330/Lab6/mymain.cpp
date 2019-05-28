#include <vector>
#include <iostream>

using namespace std;

int main()
{
	vector<double> v(5);
	v[0] = 1.24;
	v[1] = 10.56;
	v[2] = 4.5;
	v[3] = 12.34;
	v[4] = 9.2;

	sort_double(v);

	for(int i = 0; i < v.size(); i++)
		cout << v[i] << endl;

	return 0;
}
	
