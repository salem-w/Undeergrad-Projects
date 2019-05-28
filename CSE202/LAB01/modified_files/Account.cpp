/** 
 * Waleed Salem
 * File name: Account.cpp
 * 4/6/16
 *
 */

 #include <iostream>
 #include "Account.h"

 using namespace std;

//Defaul constructor that sets the balance equal to zero
 Account::Account(): balance(0) { }

//Constructor that sets balance equal to amount specified
 Account::Account(double amount): balance(amount) { }

//Procedure that deposits a specific amount into the balance data field
 void Account::deposit(double amount)
 {
    balance += amount;
 }

//Function that withdraws amount from the balance, returns false if
//withdrawing more than what is availabe, true otherwise
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

//Returns the amount in the balance private data field
 double Account::query()
 {
    return balance;
 }

//Procedure that sets the value of interest rate equal to rate
void Account::set_interest_rate(double rate)
{
interest_rate = rate;
}

//Returns the interest rate
double Account::get_interest_rate()
{
return interest_rate;
}

void Account::add_interest()
{
balance += balance * (get_interest_rate()/100);
}
