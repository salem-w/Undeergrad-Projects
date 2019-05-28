#include "token.h"
#include <iostream>


using namespace std;
//convert from queue to stack
void q2stack( queue<TOKEN> &q, stack<TOKEN> &s )
{
  TOKEN t;

  while ( !q.empty() ) {
    t = q.front();
    q.pop();		//remove element
    s.push( t );
  }
}

void reverse_stack( stack<TOKEN> &s, stack<TOKEN> &sr )
{
  TOKEN t;

  while ( !s.empty() ) {
    t = s.top();
    sr.push( t );
    s.pop();
  }
}

bool c_is_an_operator( char c )
{
  if ( c == '(' || c == ')' ||
	c == '+' || c == '*' || c == '-' || c == '/' || '%' )
    return true;
  return false;

}

void print_queue( queue<TOKEN> q )
{
  while ( !q.empty() ){
    TOKEN a = q.front();
    q.pop();
    if ( a.kind == number )
	cout << a.num << " ";
    else
	cout << a.op << " ";    
  }
  cout << endl;
}

void print_stack( stack<TOKEN> s )
{
  while ( !s.empty() ){
    TOKEN a = s.top();
    s.pop();
    if ( a.kind == number )
	cout << a.num << " ";
    else
	cout << a.op << " ";    
  }
  cout << endl;
}
