//sorting example, a dumb_sort
#include <string>
#include <iostream>
#include <stdio.h>

using namespace std;

void sort ( string *a, int n, string b )
{
  int changed;
  string temp;
  if(b == "-a")
  {
    do {
      changed = 0;
	
      for ( int i = 0; i < n - 1; i++ ) {
	  if ( a[i+1] < a[i] ) {
	    temp = a[i];
	    a[i] = a[i+1];
	    a[i+1] = temp;
	    changed = 1;
	  }
      }
    } while ( changed );
  }
  if(b == "-d") {
    do {
      changed = 0;
	
      for ( int i = 0; i < n - 1; i++ {
	  if ( a[i+1] > a[i] ) {
	    temp = a[i];
	    a[i] = a[i+1];
	    a[i+1] = temp;
	    changed = 1;
	  }
      }
    } while ( changed );
  }
} 

void input ( string *a, int limit, int &i )
//value of i will be passed out as size
{
  static char buffer[100];
  cout << "\nenter data:";
  for ( i = 0; i < limit; i++ )
    if ( scanf( "%s", buffer ) == EOF )
	break;
    else
	a[i] = string ( buffer );
}

void output( string *a, int size )
{
 // cout << a[0].str;		//illegal because str is private
  cout << "\nlist : ";
  for ( int i = 0; i < size; i++ )
	cout << a[i] << " ";
  cout << endl;
}

const int maxSize = 10;
string list[maxSize];

int size = 0;

int main(int argc, char * argv[])
{
  input ( list,  maxSize, size );
  sort ( list, size, argv[1] );
  output ( list, size );
/*
  string ss;
  ss.str = NULL;	//illegal, because ss is private
*/
  return 0;
}

