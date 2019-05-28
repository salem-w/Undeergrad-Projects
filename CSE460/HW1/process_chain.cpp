#include <iostream>
#include <unistd.h>
#include <stack>
#include <cstdlib>

using namespace std;

/* This creates a chain of processes that forks only once.
 */

//prints all ancestors
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

//chains processes
void chain() {
	stack<int> ancestors;
	int pid = 0;

	for(int i = 0; i < 10; i++) {
		pid = fork();
		if(pid == 0)
			ancestors.push(getppid());
		else {
			print(ancestors);
			sleep(1);
			exit(0);
		}
	}
}

int main() {
	chain();
	return 0;
}
