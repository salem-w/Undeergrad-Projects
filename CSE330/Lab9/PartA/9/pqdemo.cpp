//pqdemo.cpp : demo of use of priority queue
#include <queue>
#include <iostream>
#include <vector>
#include <stdlib.h>

using namespace std;

template <class T>
void print(vector<T> &a)
/* PURPOSE:  print all elements in a vector
   RECEIVES: a - the vector to print
*/
{  int i;
   for (i = 0; i < a.size(); i++)
      cout << a[i] << " ";
   cout << "\n";
}

int main()
{
  priority_queue<int> pq;
  vector <int> v(20);
  //create a random sequence of integers
  for ( int i = 0; i < v.size(); i++)
      v[i] = rand() % 100;
  cout << "Original list : " << endl;
  print( v );
  cout << endl;
  cout << "Sorted list : " << endl;
  //put the sequence in priority queue
  for ( int i = 0; i < v.size(); i++ )
    pq.push( v[i] );
  
  /*
   As the highest priority ( largest value ) element is always
	at the front, we can sort by deleting the front element repetitively.
  */
  while ( !pq.empty() ){
    cout << pq.top() << " , ";
    pq.pop();		//remove front element
  }
  cout << endl;
}
