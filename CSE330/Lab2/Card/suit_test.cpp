//suit_test.cpp
#include "card.h"

int main(){
  Card c1;
  Card c2( diamond, 8 );

	suits su[4];

  Card c[52];

	for(int i = 0; i < 4; i++)
	{
		for(int j = 0; j < 13; j++)
		{
			c[(j+ 1) * (i + 1)] = c2(su[i], j);
		}
	}
			

 /** for(int i = 1, j = 1, k = 0; i < 5; j++)
	{
		if(j = 13) {
			j = 1;
			i++;
		}
		if(i = 1)
			c[k] = c2( diamond, j);

		if(i = 2)
			c[k] = c2( club, j);

		if(i = 3)
			c[k] = c2( heart, j);

		if(i = 4)
			c[k] = c2( spade, j);

	k++;
	}
	**/
	for(int k = 0; k < 52, k++)
		cout << c[k]->rank << endl;
			

  return 0;
}

