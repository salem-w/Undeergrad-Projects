//util.cpp : utility functions for manipulating binary tree
#include "bst.cpp"
#include "item.h"
#include "util.h"

using namespace std;

//contruct a binary tree from an array recursively
binTree<ITEM> *array2tree(ITEM a[], int i, int size)
{
  binTree<ITEM> *dummy = new binTree<ITEM>;
  if (i>=size) return dummy;
  binTree <ITEM> *temp = new binTree<ITEM>;
  //This merges two subtree to one with a[i] residing in root
  temp->mergeTree(a[i], array2tree(a, 2*i+1, size),
 			 array2tree(a, 2*i+2, size));
  return temp;
}

void inOrder( btpitem bp )
{
  if ( !bp->isEmpty() ) {
    inOrder( bp->leftSub() );
    ITEM data = bp->getData();
#ifdef main0
    cout << bp->getData().value << ' ';
#else
    cout << "(" << data.key << " , " <<  data.value << " ),  ";
#endif
    inOrder( bp->rightSub() );
  }
}

// Print the tree pre-order
// Traverse the root, left sub-tree, right sub-tree
void preOrder( btpitem bp)
{
   if ( !bp->isEmpty() ) {
     ITEM data = bp->getData();
#ifdef main0
    cout << bp->getData().value << ' ';
#else
    cout << "(" << data.key << " , " <<  data.value << " ),  ";
#endif
     preOrder(bp->leftSub());
     preOrder(bp->rightSub());
    }
}


void postOrder( btpitem bp )
{
  if ( !bp->isEmpty() ) {
    postOrder( bp->leftSub() );
    postOrder( bp->rightSub() );
    ITEM data = bp->getData();
#ifdef main0
    cout << bp->getData().value << ' ';
#else
    cout << "(" << data.key << " , " <<  data.value << " ),  ";
#endif
  }
}

//convert an integer to a string
string int_to_string(int n)
{  ostringstream outstr;
   outstr << n;
   return outstr.str();
}


