//card.cpp
#include "card.h"

Card::Card()
//default
{
  rank = 1;
  suit = spade;
}

Card::Card( suits s, int r )
{
  rank = r;
  suit = s;
}


ostream & operator << ( ostream &out, Card c )
{
  //first output rank
  switch ( c.rank ) {
    case 1: out << "Ace"; break;
    case 11: out << "Jack"; break;
    case 12: out << "Queen"; break;
    case 13: out << "King"; break;
    default:
	out << c.rank; break;
  }

  //then output suit
  switch( c.suit ) {
    case diamond: out << " of Diamonds"; break;
    case spade: out << " of Spadess"; break;
    case heart: out << " of Heartss"; break;
    case club: out << " of Clubs"; break;
  }
  return out;
}


