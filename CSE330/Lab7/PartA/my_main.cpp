#include "list.h"
#include "node.h"
#include <iostream>

using namespace std;

template <typename T>

void print_list( List<T> &aList )
{
  typename List<T>::iterator start, stop;
  start = aList.begin();	stop = aList.end();
  while ( start != stop ){
    cout << *start << ",\t";
    ++start;
  }
  cout << endl;
}


main()
{
	typedef int L;
	
	List<L> aList;

	aList.push_front(13);
	aList.push_front(1556);
	aList.push_front(1);

	cout << "Implementation of erase function, erases from range 0 to 1 \n";
	print_list(aList);
	aList.erase(0,1);
	print_list(aList);

	L i;

	while(true) {
		cout << "Enter a number, -1 to terminate" << endl;
		cin >> i;
		if ( i == -1)
			break;

		aList.push_front(i);	 
	}
	cout << " The size of the list is " << aList.size() << endl;
	cout << "The list is: \n";
	if(!aList.empty())
		cout << "not ";	

	cout << "empty" << endl;

	print_list(aList);

	cout << "Pop front implementation"
	aList.pop_front();
	print_list(aList);

	cout << "What value do you want to insert? \n";
	int x1, x2;
	cin >> x1;
	cout << "At what index? \n";
	cin >> x2;
	listIterator it = aList.begin + x2;
	aList.insert(it, x1);

	print_list(aList);


	
}

