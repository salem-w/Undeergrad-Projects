//token.h
#ifndef TOKEN_H
#define TOKEN_H

#include <string>
#include <stack>
#include <queue>
#include <ctype.h>
#include <stdio.h>

using namespace std;

typedef double dataType;	//could be int or double

enum whatKind { operate, number };

//defines TOKEN datatype
class TOKEN {
public:
  whatKind  kind;
  dataType  num;
  char	    op;
};

void in2post ( stack<TOKEN> &infix, queue<TOKEN> &postq );
dataType evaluate ( queue<TOKEN> &post );

#endif
