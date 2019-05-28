/*
	htfun.h
*/
#include    <stdio.h>
#include    <malloc.h>
#include    <string.h>
#include    <stdlib.h>


#define	END_OF_STREAM	256
#define NSYMBOL         257			/* total number of symbols */

typedef		char	sc;
typedef unsigned char	uc;
typedef		int	si;
typedef unsigned short	us;
typedef unsigned int    uii;
typedef unsigned int	ui;
typedef 	long	sl;
typedef	unsigned long 	ul;


typedef struct {
	int	code;
	uc	nbits;
} HUF_CODE;


typedef  struct cell {
	int	symbol;
	struct  cell	   *left;
	struct cell	   *right;
} NODE;


typedef  NODE *data;
typedef  NODE *datapq;

#define	MAX			600



class huffTree {
friend class hiterator;
private :
	NODE *root;		//root of Huffman Tree
public :
	
	huffTree() { root = NULL; }  //create empty Huffman Tree
	huffTree( ui *counts );		//create Huffman Tree from counts[i],
								//  i corresponds symbol i
	void huffCode( HUF_CODE *codes );	//driver for huffCode(...)
	void huffCode( NODE *p, HUF_CODE *codes, ui code_so_far, int nbits );
};

class hiterator {
private :
	huffTree &htree;
	NODE *p;
public :
	hiterator( huffTree &ht ) : htree( ht )
	{	p = ht.root ; }
	int isNotLeaf();
	NODE *first();
	NODE *nextLeft();
	NODE *nextRight();
};

