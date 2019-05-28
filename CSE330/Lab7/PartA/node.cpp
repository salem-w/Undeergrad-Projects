//node.cpp
#include "node.h"
#include "list.h"

using namespace std;

template <typename T>
Node<T>::Node( T &v )
{
  value = v;
  prev = next = 0;
}
