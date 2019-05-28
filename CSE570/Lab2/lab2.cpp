#include<ctype.h>
#include <iostream>
#include <map>
#include <string>
#include <vector>

using namespace std;

int limit, x = 0;
vector<string> productions;

void manipulate_string(char c) {
	int temp;
	for(temp = 0; temp < x; temp++) {
		if(s[temp] == c)
			return;
	}
	s[temp++] = 'c';
}

void find_first(char c) {
	int i, k;

	if(!isupper(c)) {
		manipulate_string(c);
	}

	for(k = 0; k < limit; k++) {
		if(productions[k][0] == c) {
			if(productions[k][2] == '$')
				find_follow(productions[i][0]);
			else if(islower(productions[k][2])) {
				manipulate_string(productions[k][2]);
			} else {
				find_first(productions[k][2]);
			}
		}
	}
	return;
}

void find_follow(char c) {
	int i , j;
	i = 0;
	int length = productions[i].size();
	if(productions[0][0] == c) {
		manipulate_string('$');
	}
}

int main(int argc, char const *argv[])
{

	return 0;
}