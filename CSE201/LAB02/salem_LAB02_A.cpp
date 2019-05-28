/******************************************************************************
 * Salem, Waled CSE201 W2016-LAB02 PartA, Excercise 1
 * Algorithm
 * Prompt the user for three floating point numbers x, y, and z
 * Computes and displays the
 * sum of x,y, and z 
 * sine of x
 * cosine of ((x + y)/z)
 * average of x,y, and z
 * log2 of x
 *****************************************************************************/

#include <iostream>
#include <cmath>

using namespace std;

const float PI = 3.14159265359;
int main() {

float x;
int y;
int z;
float x_radians;
float y_radians;
float z_radians;


cout << "Enter a number for x \n";

cin >> x;
x_radians = x * (PI/180);
cout << "Enter a number for y \n";

cin >> y;
y_radians = y * (PI/180);

cout << "Enter a number for z \n";

cin >> z;
z_radians = z * (PI/180);

cout << "The total for the three numbers is " << x + y + z << "\n";

cout << "The sine of x is " << sin(x_radians) << "\n";

cout << "The cosine of ((x + y)z) is " << cos((x_radians + y_radians)/z_radians) << "\n";

cout << "The average of x, y and z is " << ((x + y + z)/3) << "\n";

cout << "The log2 of x is " << log(x) << "\n";


return 0;


}


