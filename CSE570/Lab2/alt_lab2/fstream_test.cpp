#include <fstream>
#include <string>
#include <iostream>

using namespace std;

int main() {

	fstream fin("text.txt");
	char x;
	string right;


	for(int i = 0; i < 10; i++) {
		fin >> x >> right;

		cout << "This is X\t" << x << "\n This is right\t" << right << endl;
	}
}