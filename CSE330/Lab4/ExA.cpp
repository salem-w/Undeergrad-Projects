#include <iostream>

using namespace std;

int & inc ( int &n )
{
    return ++n;
}

int main()
{
  int i = 1;

  cout << inc(inc(i)) << endl;
  return 0;
}
  
