//CVec3.cpp
#include "CVec3.h"
#include "CPoint.h"

using namespace std

CVec3::CVec3()
{
	x = 0;
	y = 0;
	z = 0;
}
CVec3::CVec3(int a, int b, int c)
{
	x = a;
	y = b;
	z = c;
}
CVec3::CPoint operator+(CPoint p)
{
	CPoint my_point(p.x - this->x, p.y - this->y, p.z - this->z);
	return my_point;
}

CVec3::CVec3 operator+(CVec3 v1)
{
	CVec3 my_vector(v1.x - this->x, v1.y - this->y, v1.z - this->z);
	return my_vector;
}

void CVec3::print_vec(CVec3 v)
{
	cout << v.x << v.y << v.z;
}
