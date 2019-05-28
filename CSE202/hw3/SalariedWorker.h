/******************************************************************************
 * Waleed Salem
 * File: SalariedWorker.h
 * 5/14/16
 * Class HourlyWorker with function prototypes, includes a virtual 
 * compute_pay() that overrides compute_pay() of inherited class Worker.
 *****************************************************************************/
#ifndef SALARIEDWORKER_H
#define SALARIEDWORKER_H

#include <string>
#include "Worker.h"

class SalariedWorker : public Worker {
public:
	SalariedWorker();
	SalariedWorker(string, double);
	virtual double compute_pay(int);
};

#endif