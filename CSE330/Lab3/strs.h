//strs.h
#ifndef STR1_H
#define STR1_H
#include "str.h"	//note need to make it str protected instead of private
			//so that it can be used here
class Strings: public String {
public:
  typedef char *iterator;	//define iterator
  Strings ();			//constructors cannot be inherited but can call 
  Strings ( char * );
  Strings ( Strings & );
  ~Strings ();			//destructor
		//member functions
  iterator	begin();
  iterator	end();
  bool		isEmpty();
  void		insert ( unsigned int, Strings & );
  void		remove ( unsigned int, unsigned int );
		//operators
  char	 operator [] ( unsigned int );
  void	operator = ( Strings & );
};

#endif
