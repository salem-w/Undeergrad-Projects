#include <iostream>
#include <bitset>

using namespace std;

main()
{
	bitset<32> first;
	bitset<32> second;

	first.set(1);
	second.set(0);

	if(first[0] > second[0])
		cout << "The first bitset is greater than the second! \n";
	else
		cout << "The second is greater than the first! \n ";

}
