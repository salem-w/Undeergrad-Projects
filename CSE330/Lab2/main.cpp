#include <iostream>
#include "CPoint.h"
#include "CVec3.h"

using namespace std;

main()
{
	CPoint c1(1, 2, 3);
	CPoint c2(0, 1, 5);
	CVec3 v1(4, 7, 9);
	CVec3 v2(4, 5, 22);

	CVec3 v3();
	v3 = c1 - v2;

	cout << v3.print_vec() << " is a point subtracted by a point \n";
	CPoint c3();
	c3 = c1 + v1;
	cout << c3.print_point() << " is a point added to a vector \n";
	v3 = v1 + v2;
	cout << v3.print_vec() << " is a point subtracted by a point \n";

}
