//main0.cpp : for testing binTree class
#include "bst.cpp"
#include "item.h"
#include "util.h"

using namespace std;

int main()
{
   //manually constructing a tree 
   ITEM a;
   a.key = 1, a.value = "4";
   binTree<ITEM> *tp1 (new binTree<ITEM>);	//create a new binary tree
   tp1->insert ( a );				//put value in root

   a.key = 2, a.value = "*";
   binTree<ITEM> *tp2 (new binTree<ITEM>);	//create a new binary tree
   tp2->insert ( a );				//put value in root

   a.key = 3, a.value = "5";
   binTree<ITEM> *tp3 (new binTree<ITEM>);	//create a new binary tree
   tp3->insert ( a );				//put value in root

   tp2->makeLeft(tp1);				//form a larger tree by attaching left and right subtrees
   tp2->makeRight(tp3);
   cout << "\nIn order traversal of your tree: ";
   inOrder ( tp2 );
   cout << endl;
   cout << "\nPre order of tree : \n";
   preOrder ( tp2 );
   cout << endl;
   cout << "\nPost order traversal of your tree: ";
   postOrder ( tp2 );
   cout << endl;

   //make a bigger tree
   a.key = 4, a.value = "1";
   binTree<ITEM> *tp4 (new binTree<ITEM>);	//create a new binary tree
   tp4->insert ( a );				//put value in root
   a.key = 5, a.value = "+";
   binTree<ITEM> *tp5 (new binTree<ITEM>);	//create a new binary tree
   tp5->insert ( a );				//put value in root
   tp5->makeLeft( tp4 );
   tp5->makeRight( tp2 );
   

   cout << "\nIn order traversal of your bigger tree: ";
   inOrder ( tp5 );
   cout << endl;
   cout << "\nPost order traversal of your bigger tree: ";
   postOrder ( tp5 );
   cout << endl;

  return 0;
}

