//CPoint.cpp
#include "CPoint.h"
#include "CVec3.h"

using namespace std;

CPoint::CPoint()
{
	int x = 0;
	int y = 0;
	int z = 0;
}

CPoint::CPoint(int a, int b, int c)
{
	x = a;
	y = b;
	z = c;
}

CPoint::CVec3 operator-(CPoint b)
{
	return CVec3(this->x - b.x, this->y - b.y, this->z - b.z);
}

void CPoint::print_point(CPoint c)
{
	cout << c.x << c.y << c.z;
}
