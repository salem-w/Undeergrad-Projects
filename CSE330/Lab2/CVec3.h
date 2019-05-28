//CVec3.h
#pragma
#ifndef CVEC3_H
#define CVEC3_H
#include <iostream>
#include "CPoint.h"

using namespace std;

class CVec3 {

public:
	CVec3();
	CVec3(int a, int b, int c);
	CPoint operator+(CPoint p);
	CVec3 operator+(CVec3 v1);
	void print_vec(CVec3 v);

	int x, y, z;

}

#endif
