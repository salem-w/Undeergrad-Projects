//mergesort.cpp
#include "mergesort.h"
#include "Card.h"

using namespace std;

//center serves the end of first half and the beginning of second 
template <class Itr, class T>
void merge( Itr start, Itr center, Itr end, T &temp )
{
  Itr p1 = start;
  Itr p2 = center + 1;
  int n = end - start + 1;
  int j = 0;
  vector <T> v( n );
  while ( p1 <= center && p2 <= end ) {
    if ( *p1 < *p2 )
	v[j++] = *p1++;
    else
	v[j++] = *p2++;
  }
  //copy remaining ( only one while loop is executed )
  while ( p1 <= center )
	v[j++] = *p1++;
  while ( p2 <= end )
	v[j++] = *p2++;

  // copy back from the temporary vector 
   for (j = 0; j < n; j++)
      start[j] = v[j];
}

//typedef T *iterator;
template <class Itr, class T>
void m_sort ( Itr start, int low, int high, T &temp )
{
  //cout << "low = " << low << " high = " << high << endl;
  if ( low  < high ){
    int center = ( high + low ) / 2;
    m_sort ( start, low, center, temp );
    m_sort ( start, center+1, high, temp );
    merge( start + low, start + center, start + high, temp );
  }
}

template <class T>
void mergeSort( vector<T> &s )
{
  //vector<T> temp( s.size() ); //temporary storage
  T temp;               //to hold datatype
  m_sort( s.begin(), 0, s.size()-1, temp );
}

/*
 Unfortunaley, as of this date ( 10/03 ), we still cannot link 
 object files using template.  So I use  stubs to provide the 
 interface.
	T.L. Yu
*/

//sort integers
void sort_int( vector<int> &a )
{
  mergeSort ( a );
}

//sort double
void sort_double( vector<double> &a )
{
  mergeSort( a );
}

//sort string
void sort_string( vector<string> &a )
{
  mergeSort( a );
}

void sort_card( vector<Card> &a)
{
	 mergeSort( a );
}

