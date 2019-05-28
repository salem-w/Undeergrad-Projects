//CPoint.h
#pragma
#ifndef CPOINT_H
#define CPOINT_H
#include <iostream>
#include "CVec3.h"

using namespace std;

class CPoint {
public:
	CPoint();
	CPoint(int a, int b, int c);
	CVec3 operator-(CPoint b);
	void print_point(CPoint c);

	int x, y, z;

}
#endif
