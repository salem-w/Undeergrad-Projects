/*	hufmain.cpp	: 	
	A demonstration of using Static  Huffman coding
	This program uses priority queue to implement the Static
	Huffman Coding
*/

#include	"fbitios.h"
#include	"huftree.h"	//header functions of huff tree
#include	"util.h"

using namespace std;

int main( int argc, char *argv[] )
{
	char	c;

    if ( argc < 3 )
		usage_exit( argv[ 0 ] );
	printf("%s",argv[1] );
    argv++;
	c = *(argv[0]+1);
	if ( *argv[0] != '-' ){
		compress( argv );
    } else {
		if ( argc < 4 )
			usage_exit( argv[0] );
        ++argv;
		if ( c == 'c' || c == 'C' )
			compress( argv  );
		else if ( c == 'e' || c == 'E' )
			uncompress( argv );
		else
			usage_exit( argv[0] );
	}	/* else */

   return 0;
}	/* main */


