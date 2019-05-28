//main1.cpp : sample program 2 for testing binTree class
#include "bst.cpp"
#include "item.h"
#include "util.h"

int main()
{
  const int maxSize = 500;
  ITEM x[maxSize];
  cout<<"Enter integers, -99 to terminate "<<endl;
  int y;
  cin >> y;
     
  int size=0;
  while(y != -99) {
      x[size].key = y ;
      x[size].value = int_to_string ( y );  //just for demo, key and value look the same
      cin >> y;
      if ( size == maxSize - 1 ) break;	//reached maximum
      size++;
  }
  binTree<ITEM> *tp =array2tree(x, 0, size);
  cout << "\nIn order of tree : \n";
  inOrder ( tp );
  cout << endl;
  cout << "\nPre order of tree : \n";
  preOrder ( tp );
  cout << endl;
  cout << "\nPost order traversal of tree: \n";
  postOrder ( tp );
  cout << endl;

  return 0;
}


