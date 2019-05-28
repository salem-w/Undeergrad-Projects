
/*	util.cpp : utility program for 	Static  Huffman coding
	This program uses priority queue to implement the Static
	Huffman Coding
*/
#include	"fbitios.h"
#include	"huftree.h"	//header functions of huff tree

using namespace std;

void	count_bytes( FILE *input, ul *counts )
/* Counts the occurence of every byte in the input file */
{
	long fp_pos;
	int	 c;

	fp_pos = ftell( input );	/* save current file pointer */
	while ( ( c = getc( input ) ) != EOF )
		++counts[ c ];
	fseek( input, fp_pos, 0 );	/* restore original file pointer */
}


void scale_counts( ul *counts, ui count0[] )
/* scale down the counts so that Huff tree can be handled by 16-bit */
{
	ul	max;
	int	i;

	max = 0;
	for ( i = 0; i < 256; i++ )
		if ( counts[ i ] > max )
			max = counts[ i ];
	if ( max == 0 ) {
		counts[ 0 ] = 1;
		max = 1;
	}
	max = max / 255;
	max = max + 1;		/* scale counts so that < 256 */
	for ( i = 0; i < 256; ++i ){
		count0[i] = ( ui ) ( counts[i] / max );
		if ( count0[i] == 0 && counts[i] != 0 )
			count0[i] = 1;
	}
	count0[END_OF_STREAM] = 1;
}	/* scale_counts */

void put_counts( BitFileIOs *f,  ui *count0 )
/*   save all the 256 counts used in compressor so that
 *	the expander can use them
*/
{
	int	i;

	for ( i = 0; i < NSYMBOL; ++i )
	   f->OutputBits( (ul) count0[i], 8 );
}

void get_counts( BitFileIOs *f, ui count0[] )
/* when expanding, need to read in the same set of counts
*/
{
	int	i;
	for ( i = 0; i < NSYMBOL; ++i )
		count0[i] = f->InputBits( 8 );
}

void	print_code( HUF_CODE *codes )
//for debugging use
{
	int	 i;

	printf("\n");
	for ( i = 0; i < 257; ++i )
		printf("\n%c -- %x : %d,    ", (char)i ,codes[i].code, codes[i].nbits);

}

#ifndef SEEK_END
#define SEEK_END 2
#endif

long file_size( char *name)
{
    long eof_ftell;
    FILE *file;

    file = fopen( name, "r" );
    if ( file == NULL )
        return( 0L );
    fseek( file, 0L, SEEK_END );
    eof_ftell = ftell( file );
    fclose( file );
    return( eof_ftell );
}


/*
 * This routine prints out the compression ratios after the input
 * and output files have been closed.
 */
void print_ratios( char *input, char *output)
{
    long input_size;
    long output_size;
    float ratio;

    input_size = file_size( input );
    if ( input_size == 0 )
        input_size = 1;
    output_size = file_size( output );
	ratio = ( float ) output_size * 100 / input_size;
    printf( "\nInput bytes:        %ld\n", input_size );
    printf( "Output bytes:       %ld\n", output_size );
    if ( output_size == 0 )
        output_size = 1;
	printf( "Compression ratio:  %5.1f%%\n", ratio );
}


void	encode( BitFileIOs *f,  HUF_CODE *codes )
{
	int 	c;

	while ( ( c = f->InputBits( 8 ) ) != EOF )
		f->OutputBits( ( ul ) codes[c].code, codes[c].nbits );
	f->OutputBits( (ul) codes[END_OF_STREAM].code,
					codes[END_OF_STREAM].nbits );
}


void	decode( BitFileIOs *f, huffTree &ht )
{
	int	c;
	NODE	*p;
	hiterator hi( ht );

	while ( 1 ) {
		p = hi.first();
		do {
			if ( (c = f->InputBit ()) != 0 )
				p = hi.nextRight();
			else
				p = hi.nextLeft();
		} while ( hi.isNotLeaf() );
		if ( p->symbol == END_OF_STREAM )
			break;
		if ( c == -1 ){	/*************/
			printf(" c = %d ", c);
			break;
		}
		f->OutputBits( p->symbol, 8 );
	}
} //decode


void compress( char *argv[] )
{
	HUF_CODE	*codes;
	ul			*counts;
	ui		*count0;
	FILE	*infile;



	if ( ( infile = fopen( *argv, "rb" ) ) == NULL ){
		printf("\n%s doesn't exist ", *(argv-1) );
		exit( 1 );
	}
	codes = ( HUF_CODE * ) calloc( NSYMBOL, sizeof( HUF_CODE ) );
	counts = ( ul * ) calloc( NSYMBOL, sizeof( ul ) );
	count0 = ( ui * ) calloc( NSYMBOL, sizeof( ui ) );
	count_bytes( infile, counts );
	scale_counts( counts, count0 );
	BitFileIOs	f( *argv, *(argv+1) );

	put_counts( &f, count0 );
	huffTree ht ( count0 );		//build Huffman tree from count0[]
	ht.huffCode( codes);		//driver for tree2code
	encode( &f, codes );
	f.CloseOutput();  
	f.CloseInput();
	print_ratios ( *(argv), *(argv+1) );
    printf("\ndone!");
    exit( 0 );
}


void uncompress ( char *argv[] )
{
	ui		*count0;
	
	BitFileIOs f( *argv, *(argv+1) );
	count0 = ( ui * ) calloc( NSYMBOL, sizeof( ui ) );
	get_counts( &f, count0 );
	huffTree ht ( count0 );		//build Huffman tree from count0[]
	decode ( &f, ht );
	f.CloseOutput();
	f.CloseInput();
    	print_ratios ( *(argv+1), *(argv) );
}


void usage_exit( char *prog_name)
{
    char *short_name;
    char *extension;

    short_name = strrchr( prog_name, '\\' );
    if ( short_name == NULL )
        short_name = strrchr( prog_name, '/' );
    if ( short_name == NULL )
        short_name = strrchr( prog_name, ':' );
    if ( short_name != NULL )
        short_name++;
    else
        short_name = prog_name;
    extension = strrchr( short_name, '.' );
    if ( extension != NULL )
        *extension = '\0';
    printf( "\nUsage:  %s [-c/e] in-file out-file \n", short_name );
    printf("\n%s is written by Tong Lai Yu in Spring 1994 for \
		teaching an introductory undergraduate CS course ", prog_name );
    printf("\nIt uses a simple static Huffman tree to compress.");
    printf("\nthe switches -c means compress ( default ),");
    printf("\n             -e means expand,\n");
    exit( 0 );
}




