/******************************************************************************
 * Salem, Waled CSE201 W2016-LAB04 PartA
 * Algorithm
 * Prompt the user input greater than one
 * Check if the number is truly prime by dividing it througha loop
 * in a seperate function
 Test Cases = { 66, 393, 407, 58, 2, 1111, 82, 910}
 *****************************************************************************/

#include <iostream>
#include <cmath>

int i = 0;
/** @summary
 *   is_prime houses a loop that checks whether the number is truly prime
 *  @param 
 *   int input
 *        -a number enterd by the user
 *  @return 
 *   bool is_prime
 *        -if input is prime, return true, if not prime return false
 *  @requirements
 *        -n must be greater than 1
 */
 bool is_prime(int input)
{

//loop that checks if the number is prime
for ( i = 3; i < input; i++)
	{
		if(input % i == 0)
		{
         	return false;
        }

	}
        //if input went through all the checks against i
        //and got to here, input must equal to i
        if(input == i)
        {
         return true;
        }

      

 }


int main(int argc, char const *argv[])
{
	//initialize input variable
	int input;
        
	std::cout << "Enter a positive integer greater than 1 \n";
	std::cin >> input;
	while (input <= 1)
	{
		std::cout << input << " is not greater than, please try again. \n";
		std::cout << "Enter a positive integer greater than 1 \n";
		std::cin >> input;
	}
	if(input == 2)
         std::cout << "2 is prime.";
     //call is_prime with input as param
     if(is_prime(input)){
     	std::cout << input << "is prime";
     }
     
     else
     {
     	std::cout << input << "is not prime it is divisible by " << i;
     }

	
	std::cout << "\n";
}
