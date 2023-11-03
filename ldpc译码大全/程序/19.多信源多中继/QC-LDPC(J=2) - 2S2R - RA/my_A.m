function A = my_A(M)
x =M./1;
I = eye(x);

    P_1= circshift(I',-9);
    P_2= circshift(I',-56);
%     P_3= circshift(I',-3);
%     P_4= circshift(I',-4);
    
 
    
   

% a1 = [P_1,P_2;P_3,P_4];
% a2 = [P_3,P_2;P_1,P_4];
A = [P_1 P_2];
