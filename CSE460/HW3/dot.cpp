#include <stdio.h>
#include <stdlib.h>
#include <SDL/SDL.h>
#include <SDL/SDL_thread.h>
#include <iostream>

int matA[3][2] = { {1,2}, {5,8}, {7, 12} };
int matB[2][3] = { {3, 14, 0}, {6, 0, 15} };
int matC[3][3] = { {0, 0, 0}, {0, 0, 0}, {0, 0, 0} };

using namespace std;

class matrix {
public:
	void printA(int m[][2]);
	void printB(int m[][3]);
	void printC(int m[][3]);

private:
	int row;
	int col;
	int product;
};

int dotProduct(void *data) {
	int row;
	int col;
	int product;

	char *threadname;
	threadname = (char *) data;

	cout << "This is" << threadname << endl;

	for(row = 0; row < 3; row++) 
		for(col = 0; col < 3; col++) 
			for(product = 0; product < 2; product++) 
				matC[row][col] += matA[row][product] * matB[product][col];
			
	return 0;		
}

void matrix::printA(int m[][2]) {
	cout << "MatrixA: \n";

	for(row = 0; row < 3; row++){
		for(col = 0; col < 2; col++)
			cout << matA[row][col] << " ";

		cout << endl;
	}
}

void matrix::printB(int m[][3]) {
	cout << "MatrixB: \n";

	for(row = 0; row < 2; row++){
		for(col = 0; col < 3; col++)
			cout << matB[row][col] << " ";

		cout << endl;
	}
}

void matrix::printC(int m[][3]) {
	cout << "MatrixC: \n";

	for(row = 0; row < 3; row++){
		for(col = 0; col < 3; col++)
			cout << matA[row][col] << " ";

		cout << endl;
	}
}

int main()
{
	matrix mat;

	SDL_Thread *sumThread;

	sumThread = SDL_CreateThread( dotProduct, (void *) "Dot Product Thread");
	
	if(sumThread != NULL) {
		int returnValue;
		SDL_WaitThread( sumThread, &returnValue);
		cout << "Dot product of matrices A and B: \n";
		mat.printA(matA);
		mat.printB(matB);
		cout << "equal matrix C: \n";
		mat.printC(matC);
		cout << endl;
	} else 
		cout << "\nSDL_CreateThread failed: " << SDL_GetError() << endl;
	return 0;
}
