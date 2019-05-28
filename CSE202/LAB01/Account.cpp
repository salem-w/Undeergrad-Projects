/** 
 * Waleed Salem
 * File name: Account.cpp
 * 4/6/16
 * Constructs an object of type defined as account, the Account type holds a
 * balance value, includes two modifiers withdraw() and deposit(), and an
 * accessor function query().
 */

 #include <iostream>
 #include "Account.h"

 using namespace std;

//Default constructor that gives balance a value of 0
 Account::Account(): balance(0) { }

//Constructor that sets balance equal to amount
 Account::Account(double amount): balance(amount) { }

//Procedure that deposits amount into balance
 void Account::deposit(double amount)
 {
 	balance += amount;
 }

//Function that withdraws amount from balance, if withdrawing more than there
//is availabe in the balance, the function will return false, true otherwise
 bool Account::withdraw(double amount)
 {
 	bool status;

 	if(amount > balance) {
 		balance -= 5; //penalty
 		status = false;
 	} else {
 		balance -= amount;
 		status = true;
 	}
 	return status;
 }

//Returns the balance
 double Account::query()
 {
 	return balance;
 }
