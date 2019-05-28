#include "token.h"
#include "util.h"
#include <iostream>

/*
  Simple demo 3 of using in2post() and evaluate()
  works for any real numbers 
*/

int main()
{
  stack<TOKEN> s, sr;
  queue<TOKEN> q;
  TOKEN a;
  char c;
  double x, xint, xfrac, fracd;
  int dotflag, readflag, numflag, sign, lpflag;
  dataType ans;

  cout << "\nEnter an infix expression, real numbers allowed. ";
  cout << "\nBesides the first one, every negative number must be enclosed by parenthesis! ";
  cout << "\ne.g. -1.0 + ( 2 - 3.12*( -4) )/(.61 - 3.14159 * 2)\n";

  x = xint = xfrac = 0.0;	//start with value zero
  fracd = 0.1;			//for calculating fractional part of number
  dotflag = numflag = 0;
  lpflag = 0;			//for handling negative numbers
  
  while ( ( c = getchar() ) == ' ' );	//get rid of leading space
  if ( c == '-' ) {		//negative number
    sign = -1;
    c = getchar();
  } else
    sign = 1;			//positive number

  while ( true ) {
    if ( c == '.' ) dotflag=1;	//a dot has been read
    if ( isdigit( c )) {		//a digit read
	if ( !dotflag )		//if no dot read yet
	  xint = xint*10 +(c-'0');	//calculate integer part of #
	else {
	  xfrac += (c-'0')*fracd;	//fractional part of #
	  fracd *= 0.1;
	}
	numflag = 1;		//its a number
    } else
	if ( (numflag==1) && (c != '.') ) {	//# has been read
	  x = xint + xfrac;	//calculate the whole number
	  a.num = x * sign;	//include the sign
	  a.kind = number;
	  s.push( a );		//put token on stack
	  sign = 1;		//get ready for another token
	  fracd = 0.1;
  	  x = xint = xfrac = 0.0;	
	  dotflag = numflag = 0;
	} else if ( c == '(' ){	//check for negative #s
  	  while ( ( c = getchar() ) == ' ' );	//get rid of leading space
  	  if ( c == '-' ) {		//negative number
	    lpflag = 1;
	    sign = -1;
    	    c = getchar();
	    continue;
  	  } else {		//if not negative number
	    ungetc( c, stdin );	//push char back to buffer
	    c = '(';		//need to process this (
	  }
	} //if ( c == '(' )
    if ( c_is_an_operator( c ) ) {
	if ( !lpflag ) {
	  a.op = c;		//skip ')' if negative #
	  a.kind = operate;
	  s.push( a );
	}
	lpflag = 0;		//reset for next number
    }
    if ( c == '\n' ) break;
    c = getchar();
  } //while ( true )
  reverse_stack ( s, sr );
  cout << "\nThe infix expression you have entered is : ";
  print_stack( sr );
  in2post( sr, q );  
  cout << "\nThe corresponding postfix queue is : ";
  print_queue( q );
  cout << "\nIts value is : " << evaluate ( q ) << endl;
}

