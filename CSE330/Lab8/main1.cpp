#include "token.h"
#include "util.h"
#include <iostream>
/*
  Simple demo 2 of using in2post() and evaluate()
  works for integer input only
*/

int main()
{
  stack<TOKEN> s1;
  stack<TOKEN> s2;
  queue<TOKEN> q1;
  TOKEN a;
  char c;
  dataType ans;

  cout << "\nEnter an infix expression with integers only : " << endl;
  while ( ( c = getchar() ) != '\n' ) {
    if ( c == ' ' ) continue;
    if ( isdigit ( c ) ) {
	a.kind = number;
	a.num = c - '0';
    } else {
	a.kind = operate;
	a.op = c;
    }
    s1.push ( a );		//save token in stack
  } //while
  reverse_stack ( s1, s2 );	//s2 contains the reverse of s1, s1 destroyed
  cout << "\nThe infix expression you have entered is : ";
  print_stack( s2 );		
  in2post ( s2, q1 );		//convert to postfix queue
  cout << "\nThe corresponding postfix queue is : ";
  print_queue( q1 );
  cout << "\nIts value is : " << evaluate ( q1 ) << endl;
}
