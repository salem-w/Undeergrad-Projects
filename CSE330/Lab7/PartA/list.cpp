//list.cpp
#include <iostream>
#include "list.h"
#include "node.h"
#include <stdio.h>

using namespace std;

template<typename T>
List<T>::List()
{
  first = last = 0;	//null list
}

template<typename T>
bool List<T>::empty()
{
  return first == 0;
}

template<typename T>
int List<T>::size()
//count the number of elements in collection
/*
Comments from Tong: This is NOT a good implementation as
it takes time to traverse the list.  A better way is to include
a field called 'size' in the List class; when elements are
inserted or deleted, size is adjusted.
*/
{
  int count = 0;
  Node<T> *p;
  for ( p = first; p != 0; p = p->next )
    count++;
  return count;
}

template<typename T>
void List<T>::push_front( T &a )
{
  Node<T> *newNode = new Node<T> ( a );
  if ( empty() )
    first = last = newNode;
  else {
    first->prev = newNode;
    newNode->next = first;
    first = newNode;
  }
}

template<typename T>
void List<T>::pop_front()
{
  Node <T> *temp = first;
  first = first->next;
  if ( first != 0 )
    first->prev = 0;
  else
    last = 0;
  delete temp;
}

template<typename T>
List<T>::~List()
{
  Node <T> *p = first;
  while ( p != 0 ) {
    Node<T> *temp = p;
    p = p->next;
    delete temp;
  }
}

template<typename T>
listIterator<T> List<T>::begin()
{
  return iterator ( this, first );
}

template<typename T>
listIterator<T> List<T>::end()
{
  return iterator ( this, 0 ); 	//points beyond last
}

//listIterator

//constructors
template<typename T>
listIterator<T>::listIterator()
{
}

template<typename T>
listIterator<T>::listIterator( List<T> *lp, Node<T> *lkp )
{
  theList = lp;
  currentNode = lkp;
}

template<typename T>
T & listIterator<T>::operator * ()
{
  return currentNode->value;
}

template<typename T>
bool listIterator<T>::operator != ( iterator &rhs )
{
  return currentNode != rhs.currentNode;
}

template<typename T>
listIterator<T> & listIterator<T>::operator ++ (int)
{
  currentNode = currentNode->next;
  return *this;
}


template<typename T>
listIterator<T> listIterator<T>::operator ++ ()
//postfix form of increment ( e.g. assigned, then increment )
{
  //make an old copy
  listIterator<T> clone ( theList, currentNode );
  currentNode = currentNode->next;		//advance pointer
  return clone;		//return old iterator
}

template<typename T>
void List<T>::insert( listIterator<T> &itr, T &a )
{
  Node<T> *p = new Node<T> ( a );
  Node<T> *current = itr.currentNode;

  if ( empty() ) {	//empty list
    first = last = p;
    return;
  }
  //assert ( current );
  if ( current == 0 ){	//point to end, thus append to list
    last->next = p;
    p->next = 0;
    p->prev = last;
    last = p;
    return;
  }
  //otherwise, always insert before
  p->next = current;
  p->prev = current->prev;
  current->prev = p;
  current = p->prev;
  if ( current != 0 )
    current->next = p;
  else
    first = p;
}


template<typename T>
void List<T>::erase ( listIterator<T> &start, listIterator<T> &stop )
//remove elements from the range ( before stop )
{

  Node<T> *p = start.currentNode;
  Node<T> *q = p->prev;
  Node<T> *stopNode = stop.currentNode;


  if ( q == 0 ) {	//removing initial portion of list
    first = stopNode;
    if ( stopNode == 0 ) 	//pointing to end 
	last = 0;		//whole list is deleted
    else
	stopNode->prev = 0;
  } else {
	q->next = stopNode;
	if ( stopNode == 0 )
	  last = q;
	else
	  stopNode->prev = q; // q->prev = q;
  }

  //now delete the atoms
  while ( start != stop ) {
    listIterator<T> next = start;
    ++next;
    delete start.currentNode;
    start = next;
  }
}
