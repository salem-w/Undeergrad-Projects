//in2postd.cpp

#include "token.h"

using namespace std;

int precedence ( char c )
{
  switch ( c ) {
    case '+':
    case '-':
	return 1;
    case '*':
    case '/':
	case '%':
	return 2;
  }
  return 0;	//lowest
}


void transfer ( stack<TOKEN> &s, queue<TOKEN> &q )
{
  q.push( s.top() );
  s.pop();			//remove top element of stack
}

void in2post ( stack<TOKEN> &infix, queue<TOKEN> &postq )
{
  stack <TOKEN> opstack;	//operator stack
  TOKEN a;

  while ( !infix.empty() ) {
    a = infix.top();		//get a Token from infix stack
    infix.pop();		//remove token at top
    if ( a.kind == number ) 
	postq.push( a );	//enter a to postfix queue
    else if ( opstack.empty() )	
	opstack.push( a );	//put token in operator stack
    else if ( a.op == '(' )	//'(' has lowest precedence, always put it in op stack
	opstack.push( a );    
    else if ( a.op == ')' ){	//encounters right parenthesis, so transfer everything enclosed by  ( .. )
	while ( opstack.top().op != '(' )
	  transfer ( opstack, postq );
	opstack.pop();		//remove '(' after the transfer
    } else {
	while ( !opstack.empty() &&
	  	precedence( a.op ) <= precedence( opstack.top().op ) )
    	  transfer ( opstack, postq );

	opstack.push( a );
    }
  } //while
  while ( !opstack.empty() )
    transfer ( opstack, postq );
}
