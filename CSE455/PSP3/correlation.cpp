#include <iostream>
#include <cmath>

#include "LinkedList.h"

float correlate(LinkedList list_data) {
	float sum_of_products = 0;
	float product_of_sum = 0;
	float sum_of_x_squares = 0;
	float x_squared_sum = 0;
	float sum_of_y_squares = 0;
	float y_squared_sum = 0;
	float size = list_data.size();
	float x = 0;
	float y = 0;
	float answer = 0;
	//loop prepares the summations for the next arithmetic
	for(int num = 0; num < size; num++) {
		sum_of_products += list_data.xValue(num) * list_data.yValue(num);
		x += list_data.xValue(num);
		y += list_data.yValue(num);
		sum_of_x_squares += pow(list_data.xValue(num), 2);
		sum_of_y_squares += pow(list_data.yValue(num), 2);
	}
	//more preparation of values
	sum_of_products *= size;
	product_of_sum = x*y;
	sum_of_x_squares *= size;
	x_squared_sum = pow(x, 2);
	sum_of_y_squares *= size;
	y_squared_sum = pow(y, 2);
	
	//the formula to compute the correlation of the data set
	answer = (sum_of_products - product_of_sum)/sqrt(
		(sum_of_x_squares - x_squared_sum)*(sum_of_y_squares - y_squared_sum));
	return answer;



}

int main(int argc, char const *argv[]) {
	LinkedList list;
	list.insert(24.6, 14);
	list.insert(34.5, 1286.9);
	list.insert(27, 0.67);
	list.insert(42, 1200);
	list.insert(15, 14.76);
	list.insert(4, 99.8);
	list.insert(153, 129.5);
	list.insert(9, 456);
	list.insert(540, 1);
	list.insert(729, 34);
	list.read();
	float correlation = correlate(list);

	std::cout << "The correlation is: " << correlation << std::endl;
	std::cout << "The r^2 is: " << pow(correlation, 2) << std::endl;

	return 0;
}
