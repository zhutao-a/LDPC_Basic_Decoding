function [ output_code ] = Graycode( input_bit )
%格雷码产生函数，input_bit为格雷码位数，输出n*in的格雷码；
%   Detailed explanation goes here
temp=input_bit;
gray_1=[    0;
            1;
            ];
gray_2=[    0,0;
            0,1;
            1,1;
            1,0;
            ];
gray_3=[
            0,0,0;
            0,0,1;
            0,1,1;
            0,1,0;
            1,1,0;
            1,1,1;
            1,0,1;
            1,0,0;
        ];
gray_4=[
            0,0,0,0;
            0,0,0,1;
            0,0,1,1;
            0,0,1,0;
            0,1,1,0;
            0,1,1,1;
            0,1,0,1;
            0,1,0,0;
            1,1,0,0;
            1,1,0,1;
            1,1,1,1;
            1,1,1,0;
            1,0,1,0;
            1,0,1,1;
            1,0,0,1;
            1,0,0,0;
        ];    
switch temp
    case 1
        output_code=gray_1;
    case 2
        output_code=gray_2;
    case 3
        output_code=gray_3;
    case 4
        output_code=gray_4;
    case 5
      a=zeros(32,5);
       k=0;%k控制gray_2的次数
        for n1=1:8
            k=~k;
            for n2=1:4
                a((n1-1)*4+n2,1:3)=gray_3(n1,:);
                if(k)
                    a((n1-1)*4+n2,4:5)=gray_2(n2,:);
                else 
                    a((n1-1)*4+n2,4:5)=gray_2(5-n2,:);
                end
            end
        end
        output_code=a;
    case 6
        a=zeros(64,6);
        k=0;%k控制gray_2的次数
        for n1=1:8
            k=~k;
            for n2=1:8
                a((n1-1)*8+n2,1:3)=gray_3(n1,:);
                if(k)
                    a((n1-1)*8+n2,4:end)=gray_3(n2,:);
                else 
                    a((n1-1)*8+n2,4:end)=gray_3(9-n2,:);
                end
            end
        end
        output_code=a;
    case 7
        a=zeros(128,7);
        k=0;%k控制gray_2的次数
        for n1=1:16
            k=~k;
            for n2=1:8
                a((n1-1)*8+n2,1:4)=gray_4(n1,:);
                if(k)
                    a((n1-1)*8+n2,5:end)=gray_3(n2,:);
                else 
                    a((n1-1)*8+n2,5:end)=gray_3(9-n2,:);
                end
            end
        end
        output_code=a;
    case 8
        a=zeros(256,8);
        k=0;%k控制gray_2的次数
        for n1=1:16
            k=~k;
            for n2=1:16
                a((n1-1)*16+n2,1:4)=gray_4(n1,:);
                if(k)
                    a((n1-1)*16+n2,5:end)=gray_4(n2,:);
                else 
                    a((n1-1)*16+n2,5:end)=gray_4(17-n2,:);
                end
            end
        end
        output_code=a;
    case 9
       gray_5=zeros(32,5);
       k=0;%k控制gray_2的次数
        for n1=1:8
            k=~k;
            for n2=1:4
                gray_5((n1-1)*4+n2,1:3)=gray_3(n1,:);
                if(k)
                    gray_5((n1-1)*4+n2,4:5)=gray_2(n2,:);
                else 
                    gray_5((n1-1)*4+n2,4:5)=gray_2(5-n2,:);
                end
            end
        end
        a=zeros(512,9);
       k=0;%k控制gray_2的次数
        for n1=1:32
            k=~k;
            for n2=1:16
                a((n1-1)*16+n2,1:5)=gray_5(n1,:);
                if(k)
                    a((n1-1)*16+n2,6:end)=gray_4(n2,:);
                else 
                    a((n1-1)*16+n2,6:end)=gray_4(17-n2,:);
                end
            end
        end
        output_code=a;
    case 10
        gray_5=zeros(32,5);
       k=0;%k控制gray_2的次数
        for n1=1:8
            k=~k;
            for n2=1:4
                gray_5((n1-1)*4+n2,1:3)=gray_3(n1,:);
                if(k)
                    gray_5((n1-1)*4+n2,4:5)=gray_2(n2,:);
                else 
                    gray_5((n1-1)*4+n2,4:5)=gray_2(5-n2,:);
                end
            end
        end
        a=zeros(1024,10);
       k=0;%k控制gray_2的次数
        for n1=1:32
            k=~k;
            for n2=1:32
                a((n1-1)*32+n2,1:5)=gray_5(n1,:);
                if(k)
                    a((n1-1)*32+n2,6:end)=gray_5(n2,:);
                else 
                    a((n1-1)*32+n2,6:end)=gray_5(33-n2,:);
                end
            end
        end
        output_code=a;
    otherwise display(strcat('input bit should be 1 to 10! please input again'));
end
end

