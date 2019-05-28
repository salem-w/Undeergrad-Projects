/******************************************************************************
 * Salem, Waled CSE201 W2016-LAB03 PartA
 * Algorithm
 * Prompt the user input greater than one
 * Check if the number is prime or not
 Test Cases = { 6, 33, 47, 58, 2, 111, 82, 91}
 *****************************************************************************/



#include <iostream>
#include <cmath>

int main(int argc, char const *argv[])
{
	//initialize input variable
	int input;
        int i;
	std::cout << "Enter a positive integer greater than 1 \n";
	std::cin >> input;
	while (input <= 1)
	{
		std::cout << input << " is not greater than, please try again. \n";
		std::cout << "Enter a positive integer greater than 1 \n";
		std::cin >> input;
	}
	// if input is equal to 2 or 3, then it is prime and end program
	if(input == 2 || input == 3)
         {
         std::cout << input << "is prime.";
         return 0;
         }
        
	//for loop that checks if the number is divisible
	for ( i = 2; i < input; i++)
	{
                //if it is divisible by i, then it is not prime
                // break out of the loop
		if(input % i == 0)
		{
         	std::cout << input << "is not prime it is divisible by " << i;
		break;
                }

	}
        //if input was not divisible by i, then it must be equal to i
        // meaning input is prime.
        if(input == i)
        {
         std::cout << input << " is prime";
        }
	std::cout << "\n";
        return 0;
}
