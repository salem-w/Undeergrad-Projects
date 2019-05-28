//fbitios.cpp
#include "fbitios.h"

BitFileIOs :: BitFileIOs( char *argv1,  char *argv2 )
{

	if ( ( input = fopen( argv1, "rb" ) ) == NULL ){
		cout << "error open file " << argv1;
		exit( 1 );
	}
	if ( ( output = fopen( argv2, "wb" ) ) == NULL ){
		cout << "error open file " << argv2;
		exit( 1 );
	}
	 in_code = out_code = 0;
	 in_mask = out_mask = 0x80;
	 comforter = 0;
}

int BitFileIOs :: InputBit()
{
	int	value;

	if ( in_mask == 0x80 ){
		in_code = getc( input );
		if ( in_code == EOF ){
			printf("\nout of data ");
			return ( -1 );
		}
		if ( !(comforter++ & 0x0fff)  ){
			putc('.', stdout );
			fflush( stdout );
		}
	}
	value = in_mask & in_code;
	in_mask >>= 1;
	if ( in_mask == 0 )
		in_mask = 0x80;
	return( value ? 1 : 0 );
}	/* InputBit() */

int BitFileIOs :: InputBits( int n )
{
	ul	temp_mask;
	ul	return_value = 0;

	temp_mask = 1L << ( n - 1 );
	while ( temp_mask != 0 ) {
		if ( in_mask == 0x80 ){
			in_code = getc( input );
			if ( in_code == EOF ){
				printf("\n out of data! ");
				return ( -1 );
			}
			if ( ! ( comforter++ & 0x0fff )   ){
				putc('.', stdout );
				fflush( stdout );
			}
		}
		if ( in_code & in_mask )
			return_value |= temp_mask;
		temp_mask >>= 1;
		in_mask >>= 1;
		if ( in_mask == 0 )
			in_mask = 0x80;
	} /* while */
	return( return_value );
}	/* input_bits() */

void BitFileIOs :: OutputBit ( int bit )
{
		if ( bit )
			out_code |= out_mask;
		out_mask >>= 1;
		if ( out_mask == 0 ){
			if ( putc( out_code, output ) != out_code )
				printf("\nfatal error in output_bit" );
			out_code = 0;
			out_mask = 0x80;
			if ( !(comforter++ & 0x0fff)  ){
			   putc('.', stdout );
			   fflush( stdout );
			}
		}
}	/* OutputBit() */

void  BitFileIOs :: OutputBits( ul value, int count )
{
	ul p;

	p = 1L << ( count - 1 );
	while ( p != 0 ) {
		if ( p & value )
			out_code |= out_mask;				/* non-zero bit */
		p >>= 1;
		out_mask >>= 1;
		if ( out_mask == 0 ){
			putc( out_code, output );
			out_mask = 0x80;
			out_code = 0;
			if ( !(comforter++ & 0x0fff)  ){
				putc('.', stdout );
				fflush( stdout );
			}
		}
	}
}	/* OutputBits() */

void	BitFileIOs :: CloseOutput ()
{
	if ( out_mask != 0x80 )
		putc( out_code, output );
	fclose ( output );
}

void	BitFileIOs :: CloseInput()
{
	fclose ( input );
}





