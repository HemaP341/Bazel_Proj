#include "examples/algorithm/function.h"
#include <stdio.h>
#include <time.h>
#include <math.h>
#include <stdlib.h>

int main()
{
  
  // Read the input from the user.
  double lat1;
  double long1;
  double lat2;
  double long2;

  clock_t start, end;
  double cpu_time_used;

  start = clock();
  printf("> ");
  scanf("%lf, %lf, %lf, %lf", &lat1, &long1, &lat2, &long2);
  
  // Calculate the output.
  long double output = function(lat1,long1,lat2,long2);

  end = clock();
  cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

  // Return the output to the user.
  printf("%.2Lf,%.2f", output, cpu_time_used);
  
  return (int) output;
}

