#include <stdio.h>
#include <time.h>
#include <math.h>
#include <stdlib.h>
#include "function.h"

#define M_PI 3.14159265358979323846
#define RAD(degrees) (degrees * (M_PI / 180.0))

long double function(long double lat1, long double long1,long double lat2, long double long2)
{
    long double dLa1, dLo1, dLa2, dLo2;

    //converting from degree to radian
    dLa1 = RAD(lat1);
    dLo1 = RAD(long1);
    dLa2 = RAD(lat2);
    dLo2 = RAD(long2);

    long double dlong = dLo2 - dLo1;
    long double dlat = dLa2 - dLa1;

    // Calculating distance
    long double ans = pow(sin(dlat / 2), 2) +
                    cos(dLa1) * cos(dLa2) *
                    pow(sin(dlong / 2), 2);
 
    ans = 2 * asin(sqrt(ans));
 
    // Radius of Earth in
    // Kilometers, R = 6371
    // Use R = 3956 for miles
    // double R = 6371;
    double R = 6371;
     
    // Calculate the result
    ans = ans * R;
    return ans;
}
