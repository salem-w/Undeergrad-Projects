 /******************************************************************************
 * CSE201 W16: SALEM      -- LAB 05: Part A
 * 004893625
 * LAB 05 -- Exercise : Numbers.h
 *
 * This is the numbers class, the private and public members of the object are
 * declared here, the members are defined in the Numbers.cpp file
 * 
 * +--------------------------------------------------------------------------+
 * | Class: Numbers                                                           |
 * |--------------------------------------------------------------------------+
 * | - number : int                                                           |
 * |--------------------------------------------------------------------------+
 * | + Numbers(int input)                                                     |
 * | + isPrime() : bool                                                       |
 * | + isDivisibleBy(int divisor) : bool                                      |
 * +--------------------------------------------------------------------------+
 ******************************************************************************
 */
#ifndef NUMBERS_H
#define NUMBERS_H


 class Numbers
 {
 private:
 	int number;


 public:
 	bool isPrime();
 	bool isDivisibleBy(int divisor);
 	Numbers(int input);
 	
 };

 #endif
