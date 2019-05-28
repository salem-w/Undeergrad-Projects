/******************************************************************************
 * Waleed Salem
 * File: Worker.cpp
 * 5/14/16
 * Defines Worker functions, has a default compute_pay() function which can
 * be overriden in derived classes.
 *****************************************************************************/

#include "Worker.h"

//Default constructor sets values to empty
Worker::Worker(): name(""), salary_rate(0) { }

//Constructor sets values of object
Worker::Worker(string n, double s): name(n), salary_rate(s) { }

//sets name of object when called
void Worker::set_name(string n)
{
	name = n;
}

//sets salary of object
void Worker::set_salary_rate(double s)
{
	salary_rate = s;
}

//returns name of object
string Worker::get_name()
{
	return name;
}

//returns salary of object
int Worker::get_salary_rate()
{
	return salary_rate;
}

//default compute_pay() function, returns wage of Worker
double Worker::compute_pay(int hours)
{
	return hours * salary_rate;
}