%%Textbook Exercise 1_1
clc;clear;

B = [1,2,3,4;
    5,6,7,8;
    9,10,11,12;
    13,14,15,16];

%% 1. double column 1

one = [2,0,0,0;
       0,1,0,0;
       0,0,1,0;
       0,0,0,1];
   
B1 = B*one;

%% 2. halve row 3

two = [1,0,0,0;
        0,1,0,0;
        0,0,0.5,0;
        0,0,0,1];
    
B2 = two*B1;

%% 3. add row 3 to row 1

three = [1,0,1,0;
         0,1,0,0;
         0,0,1,0;
         0,0,0,1];
     
B3 = three*B2;

%% 4.interchange column 1 and 4

four = [0,0,0,1;
        0,1,0,0;
        0,0,1,0;
        1,0,0,0];
B4 = B3*four;

%% 5.substract row 2 from each of the other rows

five = [1,-1,0,0;
        0,0,0,0;
        0,-1,1,0;
        0,-1,0,1];
B5 = five*B4;

%% 6.replace column 4 by column 3

six = [1,0,0,0;
       0,1,0,0;
       0,0,1,1;
       0,0,0,0];
B6 = B5*six;

%% 7.delete column 1

seven = [0,0,0;
         1,0,0;
         0,1,0;
         0,0,1];
B7 = B6*seven;

%% (b)

A = five*three*two;
C = one*four*six*seven;

B8 = A*B*C;
