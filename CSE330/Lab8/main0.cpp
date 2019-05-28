#include "token.h"
#include "util.h"
#include <iostream>

/*
  Simple demo use of in2post() and evaluate()
*/

int main()
{
  stack<TOKEN> test;
  queue<TOKEN> q;
  TOKEN t;
  double x = 1.24, y = 3.4;
  char op = '/'; 

  t.kind = number;
  t.num = x;
  test.push( t );
  t.kind = operate;
  t.op = op;
  test.push( t );
  t.kind = number;
  t.num = y;
  test.push( t );
  in2post ( test, q );
  cout << x << op << y << " = " << evaluate ( q ) << endl;
}
