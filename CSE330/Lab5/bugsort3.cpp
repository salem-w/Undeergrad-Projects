//bugsort3.cpp
#include <iostream>

using namespace std;

class Citem {
public:
  int	key;
  char	data[4096];	//increase size of array for debugging
};

Citem item_array[] = {
  { 3, "Arnold" },
  { 2, "David" },
  { 4, "Dianne" },
  { 5, "Bill" },
  { 1, "Barbara" }
};

void sort( Citem a[], int n )
{
  int i = 0, j = 0, s = 1;
  for ( ; i < n && s != 0; i++ ){
    s = 0;
    for ( j = 0; j < n-1; j++ ) {
	if ( a[j].key > a[j+1].key ) {
	  Citem t = a[j];
	  a[j] = a[j+1];
	  a[j+1] = t;
	  s++;
	}
    }
    //n--;	
  }
} //sort

int main()
{
  sort( item_array, 5 ); 
  cout << "Sorted items : " << endl;
  for ( int i = 0; i < 5; i++ ) {
    cout << "item_array[" << i << "]=\t (" << item_array[i].key 
	<< ",\t" << item_array[i].data << " )" << endl;
  }
}
