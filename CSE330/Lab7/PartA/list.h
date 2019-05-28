//list.h
#ifndef LIST_H
#define LIST_H
template <typename T> class Node;		//forward declaration
template <typename T> class listIterator;	//forward declaration

template<typename T>
class List {
protected:
  Node<T> *first;
  Node<T> *last;

public:
  //type definition
  typedef T value_type;
  typedef listIterator<T> iterator;

  //constructor and destructor
  List ();
  virtual ~List();

  //operations
  bool empty();
  int size();
  T &front();			//returns first element
  T &back();			//returns last element
  void push_front ( T & );	//insert from the front
  void push_back( T & );	//insert from the back
  void pop_front();		//remove first element
  void pop_back();		//remove last element
  iterator begin();
  iterator end();
  void sort();
  void insert( iterator &, T &);
  void erase( iterator & );
  void erase( iterator &, iterator &);
};

template <typename T> 
class listIterator {
  typedef listIterator<T> iterator;

protected:
  List<T> *theList;
  Node<T> *currentNode;
  friend class List<T>;

public:
  //constructor
  listIterator ();
  listIterator ( List<T> *tl, Node<T> *cl );
  T &operator * ();			//dereferencing
  bool operator != ( iterator &rhs );
  iterator & operator ++ ( int );	//prefix
  iterator operator ++ ();		//postfix
};

#endif
