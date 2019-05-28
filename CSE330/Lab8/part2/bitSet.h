#ifndef BITSET_H
#define BITSET_H
#include <vector>

using namespace std;

template <int N>
class bitSet {
public:
  vector<int> data;
  int indexValue( int index )	//inline implementation
  { 
    return index / 32;
  }
  int mask ( int index )
  {
    return 1 << ( index % 32 );
  }
  //constructors
  bitSet();	
  bitSet( bitSet<N> & b );

  //bit level operators  
  void set();		
  void set( int index );
  bool test( int index );
  void reset ( int index );

  //set operations
  void operator |= ( bitSet<N> &rhs );
  bool operator > (const bitSet<N> &rhs); 
};
#endif
