/*******************************************************************************
 * CSE201 W16: SALEM      -- LAB 05: Part A
 * 004893625
 * LAB 05 -- Exercise : Numbers.cpp
 *
 * This is the constructor for the Numbers class, it contains three functions, 
 * the Default constructor Numbers, isPrime, and isDivisibleBy
 ******************************************************************************
 */



#include <iostream>
#include <cmath>
#include "Numbers.h"

using namespace std;

/**
 * This is the default constructor that sets number = input
 *    @param
 *        - input's value is put into the private member function of the class 
 */
Numbers::Numbers(int input)
{
	 this->number = input;
}

/**
 * This function checks if the number is prime.
 *    @return
 *        - Returns true if the number is prime, otherwise false
 */
bool Numbers::isPrime()
{
	for(int i = 2; i <= sqrt(number); i++)
	{
		if(number % i == 0) return false;
	}
	return true;
}

/**
 * This funtion checks if the number is divisible by the integer passed by the 
 * statement in the main program
 *    @param
 *        - number is compared to the parameter divisor
 *    @return
 *        - returns true if the number is divisible by divisor, otherwise false
 */
bool Numbers::isDivisibleBy(int divisor)
{

	if(number % divisor == 0) return true;

	return false;
}
