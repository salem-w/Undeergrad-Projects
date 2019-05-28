#include <iostream>
#include <unistd.h>
#include <stack>
#include <cstdlib>

using namespace std;

void print(stack<int> s) {
	cout << "This PID is " << getpid() << endl;

	if(s.empty())
		cout << "This is the parent process" << endl;
	else {
		cout << "The ancestors of this process are: " << endl;
		while(!s.empty()) {
			cout << s.top() << endl;
			s.pop();
		}
	}

}

void fan() {
	stack<int> ancestors;
	int pid = getpid();

	for(int i = 0; i < 10; i++) {

		if(pid == 0) {

			ancestors.push(getppid());
			print(ancestors);
			exit(0);

		} else {

			pid = fork();
			sleep(1);

		}
	}

}

int main(){
	fan();
	return 0;
}
