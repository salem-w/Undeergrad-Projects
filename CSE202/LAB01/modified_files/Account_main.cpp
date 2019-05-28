/**
 * Waleed Salem
 * File name: Account_main.cpp
 * 4/6/16
 *
 */

 #include <iostream>
 #include "Account.h"

 using namespace std;

 main()
 {
    Account savings(10000);

    int years = 0;
    int rate;
    cout << "Enter an interest rate:\n";
    cin >> rate;
    savings.set_interest_rate(rate);
    while(savings.query() < 20000) {
        savings.add_interest();
        years++;
    }
    cout << years << " years until you reach $20000.\n";

 }
