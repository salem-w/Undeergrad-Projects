#include <iostream>

using namespace std;

struct Array100 
{
   int a[100];
};

int &nValue(Array100 &r, int n)
{
  return r.a[n];
}
    
int main()
{
   Array100 x;
      
   //set 8-th element of x to the value of 999
   nValue ( x, 8 ) = 909;

   cout << x.a[8] << endl;	//prints 909
   return 0;
}
   
