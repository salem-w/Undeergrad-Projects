/******************************************************************************
 * Waleed Salem
 * File name: Pointers.cpp
 * 04/20/16
 * This program implements many of the string functions and utilizing these 
 * functions to operate on two character arrays.
 * The functions use pointers for all their approaches in solving the operation.
 * 100% Completed
 ******************************************************************************/

#include <iostream>

using namespace std;

//This function copies a char array s into another char array t up to a number
//n. t will look like s up to n characters.
void strncpy(char * t, const char * s, const unsigned int n)
{
    unsigned int i;

    for(i = 0; i < n and *(s+i); i++)
        *(t+i) = *(s+i);
    *(t+i) = '\0';//null character at the end of string
}

//This function copies one array s and places the copy into t using pointers.
void strcpy(char * t, const char * s)
{
    for( ; *t++ = *s++; );
}

//This function iterates through an array until it reaches the null character
// and returns the number of iterations.
unsigned int strlen(const char * s)
{
    unsigned int n;
    
    for(n = 0; *(s+n); n++); 

    return n;
}

//This function concatenates char array t and char array s, it also calls the
//strcpy function to giving the location of where to begin concatenation.
void strcat(char * t, const char * s)
{
    unsigned int i;

    for(i = 0; *(t+i); i++);

    strcpy((t+i), s);
}

//This function traverses through two char arrays and checks if they constain the
//same ascii sequence returning 0 if so, other wise it will return the difference
//of what s and t are pointing to.
int strcmp(const char * s, const char * t)
{
   const char * p1 =  s;
   const char * p2 =  t;

    for( ; *p1 == *p2 and *p1; p1++, p2++);
    return *p1 - *p2;
}

main()
{
     char str1[20] = "abcd", str2[20] = "efg";

    cout << "str1=" << str1<< " str2=" << str2 << endl;
    cout << "strlen(str1)=" << strlen(str1)<< " strlen(str2)=" << strlen(str2) << endl;

    strcpy(str1, str2);
    cout << "str1=" << str1 << endl;

    strcat(str1, str2);
    cout << "str1=" << str1 << endl;

    cout << "strcmp(str1, str2)=" << strcmp(str1, str2) << endl;
    cout << "strcmp(str2, \"efh\")=" << strcmp(str2, "efh") << endl;

    strncpy(str2, "hi jkl", 2);
    cout << "str2=" << str2 << endl;

    strncpy(str2, "hi jkl", 12);
    cout << "str2=" << str2 << endl;
}
