//card.h
#ifndef CARD_H
#define CARD_H
#include <iostream>

using namespace std;

enum suits { diamond, club, heart, spade};

class Card {
public:
  //constructors
  Card();
  Card( suits, int );
  //data fields
  int rank;		//rank of card
  suits suit;		//suit of card
};

ostream & operator << ( ostream &out, Card c );
#endif
