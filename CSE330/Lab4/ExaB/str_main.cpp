//str_main.cpp

#include "util.h"
#include "text_processing.h"
#include <string.h>

using namespace std;

/*
  Note that grace_open() must be defined in same file
  as main(), otherwise the destructor of fstream will
  automatically close the opened file as it finds that
  its out of scope upon exiting the function. 
*/
int grace_open( char *s, fstream &fs, char *mode )
{
  if ( mode == "in" )
    fs.open ( s, ios::in );
  else if ( mode == "out" )
    fs.open ( s, ios::out );

  if ( fs.fail() ) {
    cout << "error opening file " << s << endl;
    return -1;
  } else
    return 1;
} //grace_open


int main( int argc, char *argv[] )
{

  if(strcmp(argv[1], " --help") == 0)
    cout << "./findpat input_file output_file target_word replacement_word " << endl;

  const int max_len = 200;
  char  s[max_len+1];
  char	target[100];
  char replacement[100];
  if ( argc < 5  ) {
    usage( argv[0]  ); 
    return 1;
  }
  char *pin = argv[1];		//pointing to input filename
  char *pout = argv[2];		//pointing to output filename
  strcpy ( target, argv[3] );	//target for search
  strcpy ( replacement, argv[4]); //replacement string
  fstream ifs, ofs;		//input output filestream

  if ( grace_open ( pin, ifs, "in" ) < 0 )
    return 1;			//fail
  if ( grace_open ( pout, ofs, "out" ) < 0 )
    return 1;			//fail
  process_text( ifs, ofs, target, replacement );
  return 0;
}
