/******************************************************************************
 * Waleed Salem
 * File: HourlyWorker.cpp
 * 5/14/16
 * Object HourlyWorker which inherits from Worker class, has virtual function
 * comput_pay() which pays time and a half if working over 40 hours.
 *****************************************************************************/

#include "HourlyWorker.h"

//Default constructor, sets name value to empty and salary to 0.
HourlyWorker::HourlyWorker(): Worker("", 0) { }

//Constructor that sets the value of the name and salary fields
HourlyWorker::HourlyWorker(string n, double s): Worker(n, s) { }

//Computes pay to worker, if working over 40 hours time and a half is paid
//to everything over 40.
double HourlyWorker::compute_pay(int hours)
{
	if(hours > 40)
		return (Worker::compute_pay(hours % 40) * 1.5) + Worker::compute_pay(40);

	return Worker::compute_pay(hours);
}