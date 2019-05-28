#ifndef Student_h
#define Student_h

#include "Person.h"
#include <string>

using namespace std;

class Student : public Person {

 public:

    Student();

    Student(string n, string d, string g, string m);

    virtual void print();


 protected:
    string mjor;
};

#endif // Student_h
