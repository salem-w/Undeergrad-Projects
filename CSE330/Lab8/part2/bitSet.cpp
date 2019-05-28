#include <vector>
#include "bitSet.h"

using namespace std;

template<int N> bitSet<N>::bitSet()	
{
    int n = ( N + 31 ) / 32;
    data = vector<int> ( n, 0 );
}

template<int N>bitSet<N>::bitSet( bitSet<N> & b )
{
  //duplicate the same vector
  data = vector<int> ( b.data );
}

template<int N> void bitSet<N>::set()		
//all bits set to 1
{
    int n = data.size();
    for ( int i = 0; i < n; i++ )
      data[i] = ~0;
}

//set the bit pointed at by index
template<int N>  void bitSet<N>:: set( int index )
{
    data[indexValue( index )] |= mask ( index );
}

template<int N>  bool bitSet<N>::test( int index )
{
    if ( data[indexValue( index )] & mask(index) )
      return true;
    else
      return false;
}

template<int N>  void bitSet<N>::reset ( int index )
{
    data[indexValue(index)] &= ~mask(index);
}

template<int N> void bitSet<N>:: operator |= ( bitSet<N> &rhs )
{
    int n = data.size();
    for ( int i = 0; i < n; i++ )
      data[i] |= rhs.data[i];
}

template<int N> bool bitSet<N>::operator > (const bitSet<N> &rhs)
{
	 for (int i = N-1; i >= 0; i--) {
        if (data[i] ^ rhs[i]) return data[i];
    }
    return false;
}

template<int N> void bitSet<N>::rotateLeft()
{
	int temp = data[1];
	
}
