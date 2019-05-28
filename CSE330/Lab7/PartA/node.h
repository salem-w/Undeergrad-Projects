//Node.h

#ifndef NODE_H
#define NODE_H

template <typename T> class List;		//forward declaration
template <typename T> class listIterator;	//forward declaration
//a Node is a node ( cell )
template <typename T> class Node {
private:
  Node ( T &v );	//constructor
  T value;
  Node<T> *next;
  Node<T> *prev;

  //allow lists and iterators to access members
  friend class List<T>;
  friend class listIterator<T>;
};
#endif
