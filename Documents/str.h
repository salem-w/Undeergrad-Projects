//str.h
#ifndef STR_H
#define STR_H
class String {
protected:
  char *str;
public:	
				//constructors
  String();			//create an empty string
  String ( char *init );	//initializes str to string init
  int length();			//returns length of this string
  void prints();		//prints this string
  bool operator < ( String s );	//if this String < String s returns true
				//else false
  int find_pat( String pattern );//returns an index i such that pattern
				//matches the substring of this string that
				//begins at position i, returns -1 if no match
};

#endif
