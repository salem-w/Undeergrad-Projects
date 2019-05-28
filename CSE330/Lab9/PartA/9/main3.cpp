//main3.cpp: Lab 9 part A2

#include <math.h>
#include "bst.cpp"
#include "item.h"
#include "util.h"

using namespace std;

int main() {
    int seed = static_cast<int>(time(0));
    srand(seed);
   
    int x;
    ITEM a;
    BST<ITEM> bst1;
   
    for ( int i = 0; i < 10; i++ ) {
        x = rand() % 100;
        a.key = x;
        a.value = int_to_string (x);
        bst1.insert(a);
    }

   // sort(bst1);

    cout << "\nIn order traversal of  tree : \n";
    inOrder ( &bst1 );
    cout << endl;
   
    cout << "\nPre order of tree : \n";
    preOrder ( &bst1 );
    cout << endl;
   
    cout << "\nPost order traversal of tree: \n";
    postOrder ( &bst1 );
    cout << endl << endl;
 
    return 0;
}
