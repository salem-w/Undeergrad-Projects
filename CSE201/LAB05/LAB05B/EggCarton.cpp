 /************************************************************************************
 * CSE201 W16: SALEM      -- LAB 05: Part B
 * 004893625
 * LAB 05 -- Exercise : EggCarton.cpp
 * 
 * This is the EggCarton class definition, it defines the constructor, and the
 * three public methods
 * Test Values: 4 Brown eggs, 4 white eggs, add 2 brown eggs, 1 white egg, and 
 * another brown egg, end program, total of 12 eggs.
 * Test Values: 13 brown eggs to debug, 4 brown eggs, 5 white eggs, add 2 brown
 * eggs, 0 white eggs, end program, total of 12 eggs
 **********************************************************************************
 */




#include "EggCarton.h"

using namespace std;

EggCarton::EggCarton(int bEggs, int wEggs)
{
	this->brownEggs = bEggs;
	this->whiteEggs = wEggs;

}

int EggCarton::getTotalEggs()
{
	return brownEggs + whiteEggs;
}

bool EggCarton::addBrownEggs(int n)
{
	if(brownEggs + whiteEggs + n <= 12)
	{
		brownEggs += n;
		return true;
	}
	else
		return false;
}
bool EggCarton::addWhiteEggs(int n)
{
	if(brownEggs + whiteEggs + n <= 12)
	{
		whiteEggs += n;
		return true;
	}
	else
		return false;
}
