//bst.cpp
/*
  A sample implementation of Binary Search Tree. The class is a subclass of
  binTree ( binary tree )
*/

#ifndef BST_CPP
#define BST_CPP

#include <iostream>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

using namespace std;

//defines the interface of binary tree
template <class T>
class binTree 
{
public:
   binTree();
   virtual bool isEmpty() const;
   virtual T getData() const;
   virtual void insert(const T &a);
   virtual binTree *leftSub();		// points to root of left subtree
   virtual binTree *rightSub();
   virtual void makeLeft(binTree *t1);	// this->left==t1, (post condition)
   virtual void makeRight(binTree *t1);
//   virtual void print();	//should not define print() here because data type T is undefined at the moment
   virtual void mergeTree(T a, binTree *tlp, binTree *trp);
protected:
   bool emptyTree;
   T data;
   binTree *leftTree;
   binTree *rightTree;
};

template <class T>
binTree<T>::binTree()
{
   emptyTree=true;
   leftTree=NULL;
   rightTree=NULL;
}

template <class T>
bool binTree<T>::isEmpty() const
{
   return emptyTree;
}

template <class T>
T binTree<T>::getData() const
{
   assert(!isEmpty());// is tree empty?
   return data;
}

template <class T>
void binTree<T>::insert(const T &a)
{
   data = a;
   if (isEmpty()) {
      emptyTree=false;
      leftTree = new binTree;
      rightTree = new binTree;
   }
}

template <class T>
binTree<T>* binTree<T>::leftSub()
{
   //assert (!isEmpty());//is tree empty?
   return leftTree;
}

template <class T>
binTree<T>* binTree<T>::rightSub()
{
 //  assert( !isEmpty());//is tree empty?
   return rightTree;
}

template <class T>
void binTree<T>::makeLeft(binTree *t1)
{
   assert (!isEmpty());//is tree empty?
//   assert (leftTree->isEmpty()); //make sure left tree pointer is NULL
   leftTree = t1;
}

template <class T>
void binTree<T>::makeRight(binTree *t1)
{
   assert (!isEmpty());//is tree empty?
   assert (rightTree->isEmpty()); //make sure left tree pointer is NULL
   rightTree = t1;
}



template <class T>
void binTree<T>::mergeTree(T a, binTree *tlp, binTree *trp)
{
   data =a;
   //makeLeft(tlp);
   //makeRight(trp);
   leftTree=tlp;
   rightTree=trp;
   emptyTree=false;
}

/*
  Binary search tree ( BST )  interface. BST class inherits everything
  from binTree class.
  Here, insert() function has to insert an item at proper position.
*/
template <class T>
class BST : public binTree<T> {
public:
  virtual void insert( const T &a );	//insert item into proper position
  virtual binTree<T> *retrieve( const T &a, bool &found );  //retrieve item from a nod
  virtual T deleteMin();	//delete the node containing minimum key
};

template <class T>
void BST<T>::insert( const T &a )
{
  if ( binTree<T>::emptyTree ) {
    binTree<T>::emptyTree = false;
    binTree<T>::leftTree = new BST;
    binTree<T>::rightTree = new BST;
    binTree<T>::data = a;
  } else if ( a.key == binTree<T>::data.key )	//find the proper position until reaching a leaf
    binTree<T>::data = a;
  else if ( a.key < binTree<T>::data.key )
    binTree<T>::leftTree->insert( a );
  else 
    binTree<T>::rightTree->insert( a );
}

//returns the subtree whose root contains the data
template <class T>
binTree<T> *BST<T>::retrieve( const T &a, bool &found )
{
  binTree<T> *bp;
/*	if ( emptyTree || a.key == data.key )
		return this;
*/
//		return( this->retrieve( a, found ) );
  bp = this;
  found = true;
  while ( !bp->isEmpty() ) {
    if ( a.key == bp->getData().key )
	return bp;
    else if ( a.key < bp->getData().key )
	bp = bp->leftSub();
    else
	bp = bp->rightSub();
  } //while
  found = false;
  return bp;	//not exists
}

//returns the minimum item
template <class T>
T BST<T>::deleteMin()
{
  binTree<T> *bp, *bpp, *temp;
  assert( !binTree<T>::isEmpty() );
  bp = this;
  bpp = NULL;
  T min;
  min = bp->getData();
  if ( bp->leftSub()->isEmpty() ) {	//root is min
    min = bp->getData();
    bp = bp->rightSub();		//pointing to right subtree which
					//becomes new root
    binTree<T>::emptyTree = bp->isEmpty();
    binTree<T>::leftTree = bp->leftSub();
    binTree<T>::rightTree = bp->rightSub();
    if ( !binTree<T>::isEmpty() ) 
  	binTree<T>::data = bp->getData();
    temp = bp;
  } else {				//min is at left subtree
    while ( !bp->leftSub()->isEmpty() ) {
	bpp = bp;		//remember parent
	bp = bp->leftSub();	//keep going left
    }
    min = bp->getData();
    bpp->makeLeft( bp->rightSub() );
    temp = bp;
  }	
  delete temp;
  return( min );
} //deleteMin()

#endif

