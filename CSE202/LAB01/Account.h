#ifndef ACCOUNT_H
#define ACCOUNT_H

/** Waleed Salem
 * File name: Account.h
 * 4/6/16
 * 
 */

 class Account
  {
  private:
  	double balance;
  public:
  	Account();
  	Account(double amount);
  	void deposit(double);
  	bool withdraw(double); // returns true if enough money, false otherwise
  	double query();
  }; 
  #endif
