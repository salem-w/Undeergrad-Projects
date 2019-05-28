/*
  item.h -- defines the data type of ITEM
*/
#ifndef ITEM_H
#define ITEM_H

#include <string>

using namespace std;

typedef int keytype;

class ITEM {
public:
  keytype 	key;
  string 	value;              //other fields
};

/*
typedef struct {
  keytype 	key;
  char 		value;              //other fields
} ITEM;
*/

#endif

