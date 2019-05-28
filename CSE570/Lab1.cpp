#include <conio.h>
#include <iostream>
#include <string>


using namespace std;

int dfa[10];

int move(int s, char c) {
	
}

int main(int argc, char *argv[]) {
	string L = "(a|b)*abb";
	int s = 0;
	
	char c = L[0];
	int i = 1;
	dfa[0] = s;

	while(c != "\0") {
		s = move(s,c);
		c = L[i];
		dfa[i] = s;
		i++;
	}

	if

	return 0;
}
