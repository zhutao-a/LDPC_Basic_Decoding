function A1 = my_A1(M)
x =M./2;
I = eye(x);

    P_1= circshift(I',-1);
    P_2= circshift(I',-2);
    P_3= circshift(I',-3);
    P_4= circshift(I',-4);
    
 
    
   

A1 =[P_1,P_2;P_3,P_4];