/**
 * Waleed Salem
 * File name: Bank.cpp
 * 4/6/16
 * Defines an object Bank that inherits object Account. Bank uses all the
 * member functions of Account in Bank's member functions.
 */

#include <iostream>
#include <string>

#include "Account.h"
#include "Bank.h"

using namespace std;
//A default constructor that sets the values of the Accounts to 0
Bank::Bank() 
{
    savings.deposit(0);
    checking.deposit(0);
}

//A constructor that sets the balance of the accounts into the respective
//specified amount held in the parameter.
Bank::Bank(double savings_amount, double checking_amount)
{
    savings.deposit(savings_amount);
    checking.deposit(checking_amount);    
}

//Procedure that deposits an amount specified in the amount parameter into the
//balance of the account name held in the account parameter.
void Bank::deposit(double amount, string account)
{
    if(account == "S")
        savings.deposit(amount);
    if(account == "C")
        checking.deposit(amount);
    else
        cout << "Does not match any of the account types! Please"
             << " try again.\n"; 
        
}

//Procedure that takes an amount parameter, and uses that value to withdraw
//from the account value held in the account parameter. Returns an error if
//value being withdrawn is greater than balance stored in the account.
void Bank::withdraw(double amount, string account)
{
    if(account == "S") 
        if(!savings.withdraw(amount)) 
            cout << "Not enough balance $5 penalty charged.\n";
    if(account == "C")
        if(!checking.withdraw(amount))
            cout << "Not enough balance $5 penalty charged.\n";
    else
        cout << "Does not match any of the account types! Please"
             << " try again.\n";
}

//Procedure that takes an amount, and uses that value to transfer from the
//account specified in the account parameter to the other account. Returns an
//error if amount is greater than the value held in the accounts balance.
void Bank::transfer(double amount, string account)
{
    if(account == "S") {
        if(savings.withdraw(amount) == false)
            cout << "Not enough balance $5 penalty charged.\n";
        else
            checking.deposit(amount);
    }
    else if(account == "C") {
        if(checking.withdraw(amount) == false)
            cout << "Not enought balance $5 penalty charged./n";
        else
            savings.deposit(amount);
    } 
    else
        cout << "Does not match any of the account types! Please"
             << " try again.\n";
        
}

//Procedure that prints the balance held in each account 
void Bank::print_balances()
{
    cout << "Savings: " << savings.query() << endl
    << "Checking: " << checking.query() << endl;
}

