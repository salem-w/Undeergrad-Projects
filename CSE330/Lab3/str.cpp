//str.cpp
#include <iostream>
#include <string.h>
#include "str.h"

using namespace std;

String::String()
{
  str = new char[1];	//points to new node
  *str = 0;		//initializes to NULL string
}

String::String( char *s )
{
  str = new char[ strlen( s ) + 1 ];
  strcpy( str, s );
}

int String::length()
{
  return( strlen( str ) );
}

std::ostream& operator<<(std::ostream& os, String s)
{
  os << s.str;
  return os;
}

bool String::operator < ( String s )
{
  return (  strcmp( str, s.str ) < 0 );
}

bool String::operator > (String s)
{
  return( s.str > str);
}

int String::find_pat(String pattern)
{
  String * n = strstr(str, pattern);
  return n - str;
}

/*
void String::test( String s )
{
  cout << s.str;
}

void String::test1( Tests ts )
{
   cout << ts.s; 	//illegal, because s is private
}
*/
