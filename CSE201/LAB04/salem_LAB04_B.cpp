/******************************************************************************
 * Salem, Waled CSE201 W2016-LAB04 PartB
 * Algorithm
 * Prompt the user input greater than one
 * Check for numbers up to the number entered by the user in a seperate function
 Test Cases = { 66, 393, 407, 58, 2, 1111, 82, 910}
 *****************************************************************************/

#include <iostream>
#include <cmath>
 
int j;
int i;
/** 
 * @summary 
 *        is_prime houses the second loop that runs to check if the value i is 
 *        divisible by j
 * @param
 *    bool is_prime
 *        -returns true if input is prime, otherwise returns false
 * @requirements
 *        - n must be greater than 1
 */
 bool is_prime(int input)
 {
 	//second loop loops through each value between 3 and i -1
		//since every number is divisible by itself and 1 so only
		//check until before you reach i
		for ( j = 3; j <= (i - 1); j += 2) {
			//if this i is divisible by j, then break out of the 
			//loop since there is no need to check anymore
			if (i % j == 0)
			{
				return false;
			}

		}
		if(j == i)
		{
			return true;
		}
}

int main(int argc, char const *argv[])
{
	//initiate loop variables since they are referenced outside the loop
	
	//initiate input to hold the value entered by the user
	int input;
	int count;
	std::cout << "Enter a positive integer greater than 1 \n";
	//hold user input
	std::cin >> input;
	//input must be greater than 1, use a while loop to check if
	//the value is less than one, then ask the user to retry
	while (input <= 1)
	{
		std::cout << input << " is not greater than 1, please try again. \n";
		std::cout << "Enter a positive integer greater than 1 \n";
		std::cin >> input;
	}
	//2 is the only even prime, the loops only cover odd primes for efficiency
	std::cout << "2" << "\t";

    //first loop loops through each number between 1 to input
	//and test the value with the second loop
	for ( i = 1; i <= input; i += 2)
	{
	  if (count == 9)
		{
			count = 0;
			std::cout << "\n";
		}
                //call is_prime with the param input
		if(is_prime(i))
			{
				std::cout << i << "\t";
				count++;
			}	
		
		//if there were no factors for i, then j must equal i,
		//if j is equal to i, print out i and indent
		if (j == i) {
		std::cout << i << "\t";
	}

 }
		
		

	
	std::cout << "\n";
	return 0;
}
