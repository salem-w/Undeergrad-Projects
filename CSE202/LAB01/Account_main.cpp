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

    /**savings.deposit(20);
 	cout << savings.query() << endl;

      if(savings.withdraw(50))
 	cout << "Successful withdrawal.\n";
      else cout << "Not enough funds, $5 penalty charged.\n";
      cout << savings.query() << endl;

      if(savings.withdraw(80))
 		cout << "Successful withdrawal.\n";
      else cout << "Not enough funds, $5 penalty charged.\n";
      cout << savings.query() << endl;
*/
    int years = 0;
    int rate;
    cout << "Enter an interest rate:\n";
    cin >> rate;
    while(savings.query() < 20000) {
        savings.add_interest();
        years++;
    }

 }
