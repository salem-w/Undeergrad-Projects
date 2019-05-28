#include <unistd.h>
#include <iostream>

using namespace std;

int main() {
	cout << "Running ps with execl\n";
	execl ( "ps" , "ps" , "-ax" , ( char *) NULL );
	cout << "Done!\n";
	return 0;
}