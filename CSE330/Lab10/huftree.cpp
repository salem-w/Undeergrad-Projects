/*
  Implementation of Huffman tree using priority queue.
  @Author: T.L. Yu, 1994
*/

#include "atom.h"
#include "huftree.h"	//header functions for Huffman tree
#include <queue>	//need to use priority queue

using namespace std;

//object to be pushed onto priority queue
class NODE_PQ {
public:
  ATOM_PQ<int, datapq>	a;
  //contructor
  NODE_PQ ( ATOM_PQ<int, datapq> atom ) : a ( atom ) {}
  NODE_PQ(){};		//not used
  //to be used as function object
  bool operator () ( const NODE_PQ p1, const NODE_PQ p2 )
  {
    return p1.a.key > p2.a.key;
  }
};

int hiterator::isNotLeaf()
{
	if ( p->symbol > END_OF_STREAM )
		return 1;
	else
		return 0;
}

NODE *hiterator :: first()
{
	p = htree.root;
	return	p;
}

NODE *hiterator :: nextRight()
//returns right child of current node
{
	if ( isNotLeaf() ) {
		p = p->right;              //Not Missing statement 
		return p;
	} else
		return NULL;
}

NODE *hiterator :: nextLeft()
//returns left child of current node
{
	if ( isNotLeaf() ) {
		p = p->left;            //Not Missing statement
		return p;
	} else
		return NULL;
}

huffTree :: huffTree( ui count0[] )
{
	ATOM_PQ<int, datapq>	a, min1, min2; 
	NODE	*p;
//	pqueue<int, datapq> pq( 600 );
	priority_queue<NODE_PQ, vector<NODE_PQ>, NODE_PQ> pq;
	int		i;

	for ( i = 0; i < NSYMBOL; ++i ){
          if ( count0[i] == 0 )
            continue;
	  p = new NODE;
	  p->symbol = i;
      
	  a.key = count0[i];//missing statement 1
	  a.x = p;//missing statement 2
	  
	  pq.push( NODE_PQ ( a ) );
	}
	i = END_OF_STREAM + 1;
	min1 = pq.top().a;
	pq.pop();
	while ( !pq.empty() ) {
	   min2 = pq.top().a;	
	   pq.pop();
	   p = ( NODE * ) malloc( sizeof( NODE ) );
           if ( p == NULL ) {
             printf("\nout of memory ");
             exit( 1 );
           }

	  
       
	   p->right = min1.x;
	   p->left = min2.x;
	   
	}
	root = min1.x;
}   /* BUILD_HUFF_TREE */


//driver for huffCode(...)
void huffTree :: huffCode( HUF_CODE *codes )
{
	huffCode( root, codes, 0, 0 );
}

/*	traverse the tree, code_so_far, nbits start from 0 */
void huffTree :: huffCode( NODE *p, HUF_CODE *codes, ui code_so_far, int nbits )
{
	if ( p->symbol <= END_OF_STREAM ) {	/* leaves */
		codes[p->symbol].code = code_so_far; /*internal nodes > END_OF_STREAM*/
		codes[p->symbol].nbits = nbits;
		return;
	}
	code_so_far <<= 1;		/* bit near root is rightmost bit */
	nbits++;
				/* traverse left subtree */
	huffCode( p->left, codes, code_so_far, nbits);
				/* traverse right subtree */
	huffCode( p->right, codes, code_so_far | 1, nbits );
}
