#include <iostream>
#include <cmath>

#include "LinkedList.h"

class correlation
{
public:
	LinkedList list_data;
	float sigvalue;
	float p;
	float c;

	float tTable[16][9] = {
			{0,0.60,0.70,0.85,0.90,0.95,0.975,0.99,0.995}, //Alpha
			{0,0.20,0.40,0.70,0.80,0.90,0.95,0.98,0.99}, //Alpha/2
			{1,0.325,0.727,1.963,3.078,6.314,12.706,31.821,63.657},
			{2,0.289,0.617,1.386,1.886,2.920,4.303,6.965,9.925},
			{3,0.277,0.584,1.250,1.638,2.353,3.182,4.541,5.841},
			{4,0.271,0.569,1.190,1.533,2.132,2.776,3.747,4.604},
			{5,0.267,0.559,1.156,1.476,2.015,2.571,3.365,4.032},
			{6,0.265,0.553,1.134,1.440,1.943,2.447,3.143,3.707},
			{7,0.263,0.549,1.119,1.415,1.895,2.365,2.998,3.499},
			{8,0.262,0.546,1.108,1.397,1.860,2.306,2.896,3.355},
			{9,0.261,0.543,1.100,1.383,1.833,2.262,2.821,3.250},
			{10,0.260,0.542,1.093,1.372,1.812,2.228,2.764,3.169},
			{20,0.257,0.533,1.064,1.325,1.725,2.086,2.528,2.845},
			{30,0.256,0.530,1.055,1.310,1.697,2.042,2.457,2.750},
			{999999,0.253,0.524,1.036,1.282,1.645,1.960,2.326,2.576},
		};

	correlation(LinkedList list);
	float correlate();
	float significance();
	float pValue();
	float twoPValue();	
};

correlation::correlation(LinkedList list) {
	this->list_data = list;
}

float correlation::correlate() {
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

	for(int num = 0; num < size; num++) {
		sum_of_products += list_data.xValue(num) * list_data.yValue(num);
		x += list_data.xValue(num);
		y += list_data.yValue(num);
		sum_of_x_squares += pow(list_data.xValue(num), 2);
		sum_of_y_squares += pow(list_data.yValue(num), 2);
	}
	sum_of_products *= size;
	product_of_sum = x*y;
	sum_of_x_squares *= size;
	x_squared_sum = pow(x, 2);
	sum_of_y_squares *= size;
	y_squared_sum = pow(y, 2);

	answer = (sum_of_products - product_of_sum)/sqrt(
		(sum_of_x_squares - x_squared_sum)*(sum_of_y_squares - y_squared_sum));
	this->c = answer;
	return answer;

}

float correlation::significance() {
	float r = this->correlate();
	if(std::abs(r) > 0.7) {
		int size = list_data.size();
		float sig = ((std::abs(r)) * sqrt(size - 2))/(sqrt(1 - pow(r, 2)));
		this->sigvalue = sig;
		return sig;
	}
	else {
		std::cout << "Cannot calculate significance, data has weak correlation.\n";
		return (-10000000);
	}
}

float correlation::pValue() {
	int df = 0;
	int index = 1;
	float diff = 0;
	float x = 0;
	float y = 0;
	float z = 0;

	for(int i = 0; i < 15; i++)
		if(list_data.size() - 1 <= tTable[i][0]) {
			df = tTable[i][0];
			break;
		}

	for(; index < 9; index++) {
		if(tTable[df][index] >= this->sigvalue) {
			diff = tTable[1][index] - tTable[0][index];
			break;
		}
	}
	
	x = this->sigvalue - tTable[df][index-1];
	y = tTable[df][index] - tTable[df][index-1];
	z = (x/y) * diff;
	
		
	this->p = 0.99 + z;
	return this->p;
 }

float correlation::twoPValue() {
	return 2.0f*(1 - this->p); 
}

int main(int argc, char const *argv[]) {
	LinkedList list;
	list.insert(400, 26.6);
	list.insert(450, 30.2);
	list.insert(1700, 36.6);
	list.insert(1600, 48.8);
	list.insert(1958, 58.5);
	list.insert(2030, 55.6);
	list.insert(125, 32.3);

	list.read();
	correlation cor(list);
	float correlation = cor.correlate();
	float significance = cor.significance();
	float p = cor.pValue();
	float minusp = cor.twoPValue();
	std::cout << "The correlation is: " << correlation << std::endl 
	<< "Significance:" << significance << std::endl << "p: " << p << std::endl
	<< "2*(1-p):" << minusp << std::endl;

	return 0;
}
