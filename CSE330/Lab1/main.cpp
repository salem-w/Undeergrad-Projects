#include <iostream>
#include <stdlib.h>

using namespace std;

void multiply(double x, double y);

main(int argc, char* argv[])
{
	double x, y;
	if(argc > 3 || argc <=1)
		cout << "error\n";
	else
	{
		x = atof(argv[1]);
		y = atof(argv[2]);
		multiply(x,y);
	}
}
