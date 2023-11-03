function output=add_noise(sgma,input)
         [n,nl]=size(input);
         for k=1:nl
            for m=1:n
                noise=normrnd(0,sgma)+normrnd(0,sgma)*sqrt(-1);              %噪声方差为sgma平方输入因为input为复数所以实部虚部都加上了高斯白噪声NORMRND 产生了一个均值为零 方差为SGMA的 服从正态分布的数
                output(m,k)=input(m,k)+noise;
            end
         end
         