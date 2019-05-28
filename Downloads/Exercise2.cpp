#include <iostream>
#include <cmath>

int main(int argc, char const *argv[])
{
	//initialize all variables
	int input;
	int check = 0;
	std::cout << "Enter a positive integer greater than 1 \n";
	std::cin >> input;
        //While the input is less than one, ask the user to try again
	while (input <= 1)
	{
		std::cout << input << " is not greater than, please try again. \n";
		std::cout << "Enter a positive integer greater than 1 \n";
		std::cin >> input;
	}
        // the algorithm that checks if the input is prime
	for (int i = 2; i <= input; i++)
	{
		for (int j = 2; j <= (std::sqrt(input) + 1); j++) {
			if (j % i == 0)
			{
				check = i;
				cout << input << " is not a prime number. \n";
				break;
			}
		}
		if (check == 0) {
			cout << i << ", is prime.";
		}

	}
}
