//util.cpp : utility functions for manipulating binary tree
#include "bst.cpp"
#include "item.h"
#include <sstream>

using namespace std;

typedef binTree<ITEM> btitem;
typedef btitem *btpitem;

binTree<ITEM> *array2tree(ITEM a[], int i, int size);
void inOrder( btpitem bp );
void preOrder( btpitem bp);
void postOrder( btpitem bp );
string int_to_string(int n);

