//fbitios.h
#ifndef FBITIOS_H
#define FBITIOS_H

#include	<stdio.h>
#include	<stdlib.h>
#include	<iostream>
#include	<string.h>

using namespace std;

typedef	unsigned int	ui;
typedef unsigned long	ul;
typedef	unsigned char	uc;

class	BitFileIOs {
	int		in_code, out_code;
	uc		in_mask, out_mask;
	ui		comforter;
	FILE	*input, *output;
  public :
	BitFileIOs ( char *argv1,  char *argv2 );		//constructors
        BitFileIOs ( FILE *fi, FILE *fo )
	{   input = fi; output = fo; 
	    in_code = out_code = 0;
	    in_mask = out_mask = 0x80;
	    comforter = 0;

	}	

	int  InputBit();	//input one bit from file
	int  InputBits( int n );  //input n bits from file
	void OutputBit( int bit );	//output one bit
	void OutputBits ( ul value, int n );
	void CloseOutput();	//close_output
	void CloseInput();	//close input
};

#endif

