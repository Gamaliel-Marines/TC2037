#include <iostream>
#include <sstream>
#include <math.h>

using namespace std;


void aproxPI(int n)
{
    float cont,acum,pi;

    for(int i = 0; i < n; i++)
    {
        pi += 4.0 * pow(-1, i) / (2 * i + 1);
    }

    std::cout<<pi;

}


int main()
{
    aproxPI(10000);

    return 0;
}