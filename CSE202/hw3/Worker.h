/******************************************************************************
 * Waleed Salem
 * File: Worker.h
 * 5/14/16
 * Base class worker, has accessor and modifier functions, along with a virtual
 * compute pay function.
 *****************************************************************************/

#ifndef WORKER_H
#define WORKER_H

#include <string>

using namespace std;

class Worker {
public:
	Worker();
	Worker(string, double);
	void set_name(string);
 	void set_salary_rate(double);
 	string get_name();
 	int get_salary_rate();   
 	virtual double compute_pay(int);
protected:
	string name;
	double salary_rate;
};

#endif