#include <iostream>
#include <cmath>

#include "LinkedList.h"

class correlation
{
public:
	LinkedList list_data;
	float dev;
	float var;

	float x_avg;
	float y_avg;

	float x_k;
	float y_k;

	float t1;
	float t2;
	float b0;
	float b1;
	float p;

	float range1;
	float range2;
	

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
	void findPred();
	void computeDev();
	void lookUpT();
	void findRange();
	float beta_zero();
	float beta_one();
		
};


correlation::correlation(LinkedList list) {
	this->list_data = list;
}

void correlation::findPred() {
	this->computeDev();
	this->lookUpT();

}


void correlation::computeDev() {
	int size = list_data.size();
	float be1 = this->beta_one();
	float be0 = this->beta_zero();
	float var = 0;
	
	for(int i = 0; i < size; i++) {
		var += pow(list_data.yValue(i) - be0 - be1*list_data.xValue(i), 2);
	}
	var /= (size-1);
	dev = sqrt(var);
}

void correlation::lookUpT() {
	int size = list_data.size() - 1;
	this->t1 = tTable[size][3];
	this->t2 = tTable[size][5];

}
/*
void correlation::findRange() {
	range1 = t1 * x_dev * sqrt(1 + (1/list_data.size()) + (pow(x_k - x_avg,2))/x_var);
	range2 = t2 * y_dev * sqrt(1 + (1/list_data.size()) + (pow(y_k - x_avg,2))/y_var);
}
*/

float correlation::beta_zero() {

	b0 = y_avg - (this->b1 * x_avg);
	return b0;
}

float correlation::beta_one() {

	int size = list_data.size();
	float x = 0;
	float y = 0;

	float multiple = 0;
	float x_squared = 0;

	for(int i = 0; i < size; i++) {
		x = list_data.xValue(i);
		y = list_data.yValue(i);
		x_avg += x;
		y_avg += y;
		x_squared += pow(x,2);
		multiple += x * y;
	}
	x_avg /= size;
	y_avg /= size;

	this->b1 = (multiple - size*x_avg*y_avg)/(x_squared - (size*pow(x_avg,2)));

	return this->b1;

}


int main(int argc, char const *argv[]) {
	LinkedList list;
	list.insert(130, 186);
	list.insert(650, 699);
	list.insert(99, 132);
	list.insert(150, 272);
	list.insert(128, 291);
	list.insert(302, 331);
	list.insert(95, 191);
	list.insert(945, 1890);
	list.insert(368, 788);
	list.insert(961, 1601);
	correlation cor(list);
	cor.computeDev();

	list.read();
	std::cout << "The b0 ->" << cor.b0 << std::endl;
	std::cout << "The b1 ->" << cor.b1 << std::endl;
	std::cout << "The var ->" << cor.var << std::endl;
	std::cout << "The dev ->" << cor.dev << std::endl;
	return 0;
}
