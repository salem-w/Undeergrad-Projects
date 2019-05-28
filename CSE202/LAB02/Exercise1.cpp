#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

vector<int> merge(vector<int> a, vector<int> b)
{
    vector<int> c;
    int i, j;
    int k = a.size() + b.size();

    for(i = 0, j = 0; i < a.size() and j < b.size(); )
        if(a[i] < b[j]) {
             c.push_back(a[i]);
             i++;
        } else {
             c.push_back(b[j]);
             j++;
        }

    if(i < j)
        while(i < k)
             c.push_back(a[i]);

    if(j < i)
         while(j < k)
             c.push_back(b[j]);

    return c;
}

vector<int> append(vector<int> a, vector<int> b)
{
    int n = a.size();
    int m = b.size();
    vector<int> c(n + m);
    int i;

    for(i = 0; i < n; i++)
        c[i] = a[i];

    for(i = 0; i < m; i++)
        c[n + i] = b[i];

    return c;

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
    for(i = 0; i < z.size(); i++)
        cout << z[i] << endl;

    z = merge(x,y);
    cout << "Here they are merged: \n";
    for(i = 0; i < z.size(); i++)
        cout << z[i] << endl;
}

