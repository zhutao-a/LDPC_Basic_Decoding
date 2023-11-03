function   [H_matrix1,G_matrix]=gen_LDPC
%---       LDPC编码后       编码前
% % 测试用，实际程序删除
% clear;
% clc;
% noise_var_Re_file6=0.01; % 本程序设置的噪声功率（实部部分），暂定为0.01
% compute_times_file6=50; % 本程序设置的迭代次数，暂定为50
%--------------------------------------------------------------------------
% step 1
% 生成校验矩阵H和生成矩阵G （在GF(2)域上）
%---------------------------------
% 1.1 设置参数
%-----
% 矩阵H的参数，可修改（码率为0.5）
row_weight=6; % 校验矩阵行重为6
col_weight=3; % 校验矩阵列重为3
H_row_num=33; % 矩阵H的行数
%-----
% 其他参数,不可修改
H_col_num=H_row_num*row_weight/col_weight; % 矩阵H的列数，自动调整
row_6=[1,1,1,0,0,1,0,0,1,0,0,0,0,0,0,1]; % 用于生成的行向量
row_6_end=14; % 用于生成的行向量的拖尾
H_tmp1=zeros(H_row_num,H_col_num+row_6_end); % 用于存储要生成的H矩阵的临时值
H_matrix=zeros(H_row_num,H_col_num); % 用于存储生成的H矩阵，代表连接关系
H_matrix_rank=0; % 矩阵H的秩
H_matrix_1_col=zeros(1,H_row_num); % 用来存储矩阵H的行最简阶梯形每一行起始位的列号
%---------------------------------
% 1.2 生成矩阵H的临时量
for index_0=1:H_row_num
    index_1=(2*H_row_num+14)-row_6_end-2-(2*index_0-2);
    H_tmp1(index_0,:)=[zeros(1,2*index_0-2) row_6 zeros(1,index_1)];
end
% 1.3 生成矩阵H
for index_0=1:row_6_end
    H_tmp1(:,index_0)=H_tmp1(:,index_0)+H_tmp1(:,index_0+H_col_num);
end
for index_0=1:H_col_num
    H_matrix(:,index_0)=H_tmp1(:,index_0);
end
H_matrix1=H_matrix;
% 矩阵H生成完成
%---------------------------------
% 1.4 在2元域上，对矩阵H做行变换，变成行最简阶梯形。
for index_0=1:H_row_num % 遍历矩阵H的所有行（遍历到index_0行）
    for index_1=1:H_col_num
        % 检查矩阵H的第index_0行，取出第一个为1的元素的列号（第index_1列）
        if (H_matrix(index_0,index_1))==1
            % 已经计算出index_1
            H_matrix_rank=H_matrix_rank+1; % 矩阵的秩计数加1
            H_matrix_1_col(H_matrix_rank)=index_1; 
            % 存储矩阵H的行最简阶梯形第index_0行起始位的列号（index_1）
            for index_2=1:H_row_num
                if index_2~=index_0 % 对于不是index_0的行（第index_2行）
                    if H_matrix(index_2,index_1)==1 % 如果本行列的H矩阵元素为1
                        H_matrix(index_2,:)=mod(H_matrix(index_2,:)+H_matrix(index_0,:),2);
                    end
                end
            end
            break;
        end
    end    
end
% 1.4部分完成，已经变换成行最简阶梯型，变换的结果存在H_matrix中，前面单位矩阵的列号存在H_matrix_1_col中
%--------------------------------------------------------------------------
% step 2
% 构造生成矩阵G
%---------------------------------
G_matrix_1_col=zeros(1,H_col_num-H_matrix_rank); % 用来存储矩阵G的保持原码的列号
G_matrix_1_col_length=0; % 用来存储G_matrix_1_col的非零项的长度
G_matrix=zeros(H_col_num-H_matrix_rank,H_col_num); % 生成矩阵G
G_matrix_change1=zeros(H_col_num-H_matrix_rank,H_col_num); % 未排“列序”之前的生成矩阵G
%---------------------------------
% 2.1 检查H矩阵中，不是行最简阶梯形起始位的列号，即为矩阵G的保持原码的列号
H_col_0=zeros(1,H_col_num); % 用于存储H矩阵中，不是行最简阶梯形起始位的列号的临时矩阵
for index_0=1:H_matrix_rank
    H_col_0(H_matrix_1_col(index_0))=1;
end
for index_0=1:H_col_num
    if H_col_0(index_0)==0;
        G_matrix_1_col_length=G_matrix_1_col_length+1;
        G_matrix_1_col(G_matrix_1_col_length)=index_0;
    end
end
% “H矩阵中，不是行最简阶梯形起始位的列号”即为矩阵G的保持原码的列号
% 这些列号存储在G_matrix_1_col里，长度为G_matrix_1_col_length。
%----------------------------------
% 2.2 矩阵H的列重新排序
H_matrix_change1=zeros(H_row_num,H_col_num); % 用于存储重新排序后的矩阵H
for index_0=1:G_matrix_1_col_length
    H_matrix_change1(:,index_0)=H_matrix(:,G_matrix_1_col(index_0));
end
for index_0=1:H_matrix_rank
    H_matrix_change1(:,G_matrix_1_col_length+index_0)=H_matrix(:,H_matrix_1_col(index_0));
end

% 重新排序后的H完成（H_matrix_change1）
%---------------------------------
% 2.3 取重新排序后的H的前半部份给G的后半部分，G的前半部分为单位阵。
G_matrix_change1(:,G_matrix_1_col_length+1:G_matrix_1_col_length+H_matrix_rank)=H_matrix_change1(:,1:G_matrix_1_col_length)';
G_matrix_change1(:,1:G_matrix_1_col_length)=eye(G_matrix_1_col_length);
% 未排“列序”之前的生成矩阵G构成完毕
%---------------------------------
% 开始排“列序”，生成G_matrix
for index_0=1:G_matrix_1_col_length
    G_matrix(:,G_matrix_1_col(index_0))=G_matrix_change1(:,index_0);
end
for index_0=1:H_matrix_rank
    G_matrix(:,H_matrix_1_col(index_0))=G_matrix_change1(:,G_matrix_1_col_length+index_0);
end
% G_matrix生成完成
%--------------------------------------------------------------------------
% 验证部分,实际程序注销：
%a_tmp=round(rand(1,33));
% c_tmp=mod(uncode*G_matrix,2);
% d_result=mod(H_matrix*c_tmp',2);
% d_result2=mod(H_matrix1*c_tmp',2);
%--------------------------------------------------------------------------