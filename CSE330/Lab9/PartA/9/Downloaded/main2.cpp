//main2.cpp : sample program  for testing BST class
#include "bst.cpp"
#include "item.h"
#include "util.h"

using namespace std;

int main()
{
  int x;
  cout<<"Enter an array of integers, -99 to terminate"<<endl;
  cin >> x;
  ITEM a;
  a.key = x;
  a.value = int_to_string ( x );	//just for testing, key and value look the same
  BST<ITEM> bst1;

  while ( x != -99 ) {
    bst1.insert( a );
    cin >> x;
    a.key = x;
    a.value = int_to_string ( x );
  }
  cout << "\nenter a key for retrieve : ";
  cin >> x;
  a.key = x;
  bool found;
  binTree<ITEM> *bp =	bst1.retrieve( a, found );
  if ( found == false )
    cout << "\nrecord not in tree";
  else
    cout << "\nRecord found : " << "( " << bp->getData().key
	<< " , " << bp->getData().value << " ) " << endl;

  cout << "\nIn order traversal of  tree : \n";
  inOrder ( &bst1 );
  cout << endl;
  cout << "\nPost order traversal of tree: \n";
  postOrder ( &bst1 );
  cout << endl;

  cout << "\nafter deleteing the minimum element:" << endl;


  a = bst1.deleteMin();
  cout << "\nminimum record is :" << "(" << a.key << "," << a.value << " ) " << endl;
  cout << "\nIn order traversal of  tree : \n";
  inOrder ( &bst1 );
  cout << endl;
  cout << "\nPost order traversal of tree: \n";
  postOrder ( &bst1 );
  cout << endl;

  return 0;
}


