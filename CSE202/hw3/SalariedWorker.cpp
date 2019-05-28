/******************************************************************************
 * Waleed Salem
 * File: SalariedWorker.cpp
 * 5/14/16
 * Object SalariedWorker which inherits from Worker class, has virtual function
 * comput_pay() which pays delcared weekly salary no matter how many hours have
 * been worked.
 *****************************************************************************/

#include "SalariedWorker.h"

//Default constructor, sets name value to empty and salary to 0.
SalariedWorker::SalariedWorker(): Worker("", 0) { }

//Constructor that sets the value of the name and salary fields
SalariedWorker::SalariedWorker(string n, double s): Worker(n, s) { }

//computes pay does not matter how many hours have been worked, hours parameter
//is left for consistency with other classes.
double SalariedWorker::compute_pay(int hours)
{
	return Worker::get_salary_rate();
}