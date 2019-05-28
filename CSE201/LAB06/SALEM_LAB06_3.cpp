/***********************************************************************************
 * CSE201 W16: SALEM      -- LAB 06: Exercise 1
 * 004893625
 * LAB 06 -- Exercise : LAB06_3.cpp
 *
 * This program contains two vectors holding a specific value,
 * and merges the two vectors using a procedure, it then
 * outputs the newly created vector the user.
 **********************************************************************************/

#include <iostream>
#include <vector>

using namespace std;

/**
 * This procedure takes two vectors and appends the second
 * vector to the first.
 * @param v
 *    - The vector passed to append to
 * @param w
 *    - The second vector that gets placed into the vector
 */
void appendVector(vector<int>& v, vector<int>& w)
{
	for(int j = 0; j < w.size(); j++)
	{
		v.push_back(w[j]);
	}

}

int main(int argc, char const *argv[])
{
	vector<int> x(3);
	x[0] = 4;
	x[1] = 8;
	x[2] = 2;

	vector<int> y(4);
	y[0] = 12;
	y[1] = 3;
	y[2] = 67;
	y[3] = 34;

	appendVector(x, y);

	cout << "Here is the new vector ";

	for(int i = 0; i < x.size(); i++)
	{
		cout << x[i] << ", ";
	}
	return 0;
}
