/**
 * Waleed Salem
 * File name: Vectors.cpp
 * 4/14/16
 * This program takes input from the user and places those values into
 * two vectors, the program then uses its functions to append the vectors
 * into one vector, merge the vectors, and sorts the two vectors into one
 * final sorted vector. The program outputs each result to the user.
 */

#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

//Takes two sorted vectors, merges them into one sorted vector
vector<int> merge_sorted(vector<int> a, vector<int> b)
{
    vector<int> c;
    int i, j;

    for(i = 0, j = 0; i < a.size() and j < b.size(); )
        //if the value in a is greater than the value in b, add
        //a value into the final vector and increment i
        if(a[i] < b[j]) {
             c.push_back(a[i]);
             i++;
        } else {
             c.push_back(b[j]);
             j++;
        }

        //checks which vector is larger, since the largest array
        //will have values not added into the final vector
        if(a.size() < b.size())
        	while(j < b.size()){
        	    c.push_back(b[j]);
        	    j++;
        	}
        if(b.size() < a.size())
            while(i < a.size()){
            	c.push_back(a[i]);
            	i++;
            }
    return c;
}

//Merges two vectors into one, also alternates the elements
vector<int> merge(vector<int> a, vector<int> b)
{
    vector<int> c;
    int i, j;

    for(i = 0, j = 0; i < a.size() and j < b.size(); )
        if(i <= j) {
             c.push_back(a[i]);
             i++;
        } else {
             c.push_back(b[j]);
             j++;
        }

        //the same check as merge_sorted for which is the larger
        if(a.size() < b.size())
        	while(j < b.size()){
        	    c.push_back(b[j]);
        	    j++;
        	}
        if(b.size() < a.size())
            while(i < a.size()){
            	c.push_back(a[i]);
            	i++;
            }
    return c;
}

//Adds elements from vector b into vector a, then returns the appended vector
vector<int> append(vector<int> a, vector<int> b)
{
    int n = a.size();
    int m = b.size();
    vector<int> c(n + m);//
    int i;

    for(i = 0; i < n; i++)
        c[i] = a[i];

    for(i = 0; i < m; i++)
        c[n + i] = b[i];

    return c;

}

//prints elements of a vector
void print_vector(vector<int> a)
{
    for(int i = 0; i < a.size(); i++)
        cout << a[i] << " ";
    cout << endl;
}

main()
{
    int i = 0, input;
    bool status = true;
    vector<int> x,y,z;

    do {
        cout << "Enter values for the first vector, -1 to exit.\n";
        cin >> input;
        if(input != -1)
            x.push_back(input);
        else
            status = false;
    }while(status);

    status = true;

    do {
        cout << "Enter values for the second vector, -1 to exit.\n";
        cin >> input;
        if(input != -1)
            y.push_back(input);
        else
            status = false;
    }while(status);


    z = append(x, y);

    cout << "The values in the vector are: \n";
    print_vector(z);

    z = merge(x,y);
    cout << "Here they are merged: \n";
    print_vector(z);

    sort(x.begin(), x.end());
    sort(y.begin(), y.end());
    z = merge_sorted(x, y);
    cout << "Here they are sorted and merged:\n";
    print_vector(z);
}

