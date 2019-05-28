//strs.cpp
#include <assert.h>
#include <string.h>
#include "strs.h"

Strings::Strings():String()
{
/*
  str = new char[1];    //points to new node
  *str = 0;             //initializes to NULL string
*/
}

Strings::Strings( char *s ):String( s )
{
//  str = new char[ strlen( s ) + 1 ];
//  strcpy( str, s );
}

Strings::Strings( Strings &s )
{
  str = new char[s.length() +1];
  assert ( str );
  strcpy ( str, s.str );
}

Strings::~Strings()
//called implicitly when a string is about to be deleted
//free the memory associated with str
{
  delete [] str;
}

void Strings::operator = ( Strings &s )
{
  char *p = new char[s.length() +1];
  assert ( p );
  delete [] str;	//return memory to pool, otherwise memory leak
  str = p;
  strcpy ( str, s.str );
}

char Strings::operator [] ( unsigned int i )
{
  assert ( i < length() );
  return str[i];
}

bool Strings::isEmpty()
{
  return ( *str == 0 );
}

char *Strings::begin()
{
  return str;
}

char *Strings::end()
{
  return str + length();
}

void Strings::remove( unsigned int start, unsigned int len )
{
  int stop = start + len;
  int strlen = length();
  while ( ( stop < strlen ) && ( str[stop] != 0 ) )
    str[start++] = str[stop++];
  str[start] = 0;
}

void Strings::insert( unsigned int pos, Strings &newText )
{
  int len = length();	//current length
  assert ( pos <= len );
  int addLen = newText.length();		//additional length
  int newLen = len + addLen;		//new length
  char *p = new char[newLen +1];
  assert ( p );
  int i;
  for ( i = 0; i < pos; ++i )
    p[i] = str[i];
  for ( i = 0; i < addLen; ++i )	//copy newtext
    p[i+pos] = newText[i];
  for ( i = pos; i <= len; ++i )		//copy remaining
    p[i+addLen] = str[i];
  delete [] str;
  str = p;
  
}
