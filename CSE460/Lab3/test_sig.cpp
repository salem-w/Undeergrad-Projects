#include <signal.h>
#include <unistd.h>
#include <iostream>
#include <stdio.h>

using namespace std;

void func ( int sig ) {
	cout << "Oops! -- I got a signal " << sig << endl ;
	if ( sig == SIGQUIT ) {
		raise(SIGTERM);
	}
}

int main () {
	struct sigaction action;
	sigset_t set ;
	sigemptyset(& set );
	sigaddset(& set , SIGINT);
	sigaddset(& set , SIGQUIT);
	action.sa_handler = func;
	action.sa_mask = set ;
	action.sa_flags = 0 ;
	sigaction( SIGINT, &action, NULL );
	sigaction( SIGQUIT, &action, NULL );
	while ( 1 ) {
		cout << "CSUSB CS 460 lab on signals" << endl ;
		sleep ( 1 );
	}
	return 0 ;
}