/******************************************************************************
 * Waleed Salem
 * File: HourlyWorker.h
 * 5/14/16
 * Class HourlyWorker with function prototypes, includes a virtual 
 * compute_pay() that overrides compute_pay() of inherited class Worker.
 *****************************************************************************/
#ifndef HOURLYWORKER_H	
#define HOURLYWORKER_H

#include <string>
#include "Worker.h"	

using namespace std;

class HourlyWorker : public Worker {
public:
	HourlyWorker();
	HourlyWorker(string, double);
	virtual double compute_pay(int hours);
};

#endif