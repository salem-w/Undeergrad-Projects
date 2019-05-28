//text_processing.cpp

#include "util.h"
#include "text_processing.h"
#include <string.h>

using namespace std;

int process_text( fstream &ifs, fstream &ofs, char target[], char replacement[] )
{
  string replace_str(replacement);
  int tlen = strlen( target );	//string length of target
  int max_len = 200;		//maximum length of a line
  char s[max_len+1];
  clear_screen();			//clear the screen
  while ( !ifs.eof() ) {
    int i2, i1 = 0, len=0;
    ifs.getline( s, max_len );		//get one line from file
    string str( s );			//construct a string object
    i2 = str.find ( target, i1 );	//find target
    len = i2 - i1;
    if ( i2 > -1 && len > 0 ){		//if target  found
      print_text( str.substr( i1, i2 ).c_str() );  //print up to target
      ofs << str.substr( i1, i2 );
    }
    while ( i2 > -1 ) {
      print_text_inverse ( replacement );	//highlight target
      ofs << replace_str;
      i1 = i2 + tlen;			//new search position
      i2 = str.find ( target, i1 );	//find next target
      len = i2 - i1;
      if ( i2 > -1 && len > 0 ){			//found target
       	print_text( str.substr( i1, len ).c_str() ); //print up to target
	ofs << str.substr( i1, len );
      }
    }
    len = str.length() - i1;
    if ( len > 0  ) {		//print the remainder
     	print_text( str.substr( i1, len ).c_str() );
	ofs << str.substr( i1, len );
    } 
    ofs << endl;
    getnstr( s, 1 );		//prompt for <Enter>
  } //while ( !ifs.eof() )
  restore_screen();		//restore the old screen
  return 1;
}
