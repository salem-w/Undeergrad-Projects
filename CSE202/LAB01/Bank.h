#ifndef BANK_H
#define BANK_H

/**
 * Waleed Salem
 * File name: Bank.h
 * 4/6/16
 *
 */

#include <string>

#include "Account.h"

using namespace std;

class Bank {
private:
    Account savings;
    Account checking;
public:
    Bank();
    Bank(double savings_amount, double checking_amount);
    void deposit(double amount, string account);
    void withdraw(double amount, string account);
    void transfer(double amount, string account);
    void print_balances();
};

#endif
