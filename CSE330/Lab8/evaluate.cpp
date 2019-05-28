//evaluate.cpp
#include "token.h"
#include <iostream>
#include <stdlib.h>

using namespace std;

//evaluates postfix expression represented as a queue of tokens
//assumes that postfix expression is correctly formed
dataType evaluate ( queue<TOKEN> &post )
{
  stack<TOKEN> eval;
  dataType first, second, ans;
  char bin_op;
  TOKEN tp, te;

  while ( !post.empty() ) {
    tp = post.front();
    post.pop();
    if ( tp.kind == number )	//number
	eval.push( tp );	//save the number on evaluation stack
    else {			//its an operator
	te = eval.top();	//get a 'number' from eval stack
	first = te.num;
	eval.pop();
	te = eval.top();	//get a second 'number'
	second = te.num;
	eval.pop();
	bin_op = tp.op;
	switch ( bin_op ) {
	  case '+' : 
	    ans = second + first;
	    break;
	  case '-' : 
	    ans = second - first;
	    break;
	  case '*' : 
	    ans = second * first;
	    break;
	  case '/' : 
		if(first == 0){
			cout << "Error, cannot divide by zero" << endl;
			break;
		}
	    ans = second / first;
		break;
	  case '%':
		ans = (int) second % (int) first;
		break;

		cout << "Error, expressiont type not supported \n";
		exit(1);
	    break;
	} //switch
	te.num = ans;		//save the result
	eval.push ( te );
    } //else
  } //while
  te = eval.top();
  return te.num;
}

