#include <iostream>
#include <cmath>

int main(int argc, char const *argv[])
{
	int input;
	std::cout << "Enter a number greater than 1 \n";
	std::cin >> input;
	while (input <= 1)
	{
		std::cout << "That number is less than 1. \n";
		std::cout << "Enter a number greater than 1 \n";
		std::cin >> input;
	}

	for (int i = 2; i <= (std::sqrt(input) + 1); i++) {
		if(input % i == 0)
		{
			std::cout << input << " is not prime, it is divisible by " << i << " \n";
			system("pause");
			return 0;
		}
		
	}
	std::cout << input << "is a prime number" << " \n";
	system("pause");
	return 0;
}