/******************************************************************************
 * Waleed Salem
 * File: payroll.cpp
 * 5/14/16
 * Tests inheritance and overridden functions by using each objects compute_pay
 * function.
 * Through the use of pointers to base class, and the virtual keyword in each
 * function to be overridden. The program can obtain the correct outputs based
 * on the name of the object
 *****************************************************************************/

#include <iostream>
#include <vector>

#include "HourlyWorker.h"
#include "SalariedWorker.h"
#include "Worker.h"

using namespace std;

main()
{
	vector<Worker *> employees(5);
	employees[0] = new Worker("Felix", 36);
	employees[1] = new SalariedWorker("Tom", 2800);
	employees[2] = new Worker("Marie", 18);
	employees[3] = new HourlyWorker("Carlos", 27.50);
	employees[4] = new SalariedWorker("Betty", 1800);

	//print out pay
	cout << employees[0]->get_name() << " " << employees[0]->compute_pay(24) 
	<< endl;
	cout << employees[1]->get_name() << " " << employees[1]->compute_pay(52) 
	<< endl;
	cout << employees[2]->get_name() << " " << employees[2]->compute_pay(13) 
	<< endl;
	cout << employees[3]->get_name() << " " << employees[3]->compute_pay(56) 
	<< endl; 
	cout << employees[4]->get_name() << " " << employees[4]->compute_pay(32) 
	<< endl;

	//clean up
	for(int i = 0; i < employees.size(); i++)
		delete employees[i];

}