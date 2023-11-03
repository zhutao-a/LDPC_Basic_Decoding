function   [H_matrix1,G_matrix]=gen_LDPC
%---       LDPC�����       ����ǰ
% % �����ã�ʵ�ʳ���ɾ��
% clear;
% clc;
% noise_var_Re_file6=0.01; % ���������õ��������ʣ�ʵ�����֣����ݶ�Ϊ0.01
% compute_times_file6=50; % ���������õĵ����������ݶ�Ϊ50
%--------------------------------------------------------------------------
% step 1
% ����У�����H�����ɾ���G ����GF(2)���ϣ�
%---------------------------------
% 1.1 ���ò���
%-----
% ����H�Ĳ��������޸ģ�����Ϊ0.5��
row_weight=6; % У���������Ϊ6
col_weight=3; % У���������Ϊ3
H_row_num=33; % ����H������
%-----
% ��������,�����޸�
H_col_num=H_row_num*row_weight/col_weight; % ����H���������Զ�����
row_6=[1,1,1,0,0,1,0,0,1,0,0,0,0,0,0,1]; % �������ɵ�������
row_6_end=14; % �������ɵ�����������β
H_tmp1=zeros(H_row_num,H_col_num+row_6_end); % ���ڴ洢Ҫ���ɵ�H�������ʱֵ
H_matrix=zeros(H_row_num,H_col_num); % ���ڴ洢���ɵ�H���󣬴������ӹ�ϵ
H_matrix_rank=0; % ����H����
H_matrix_1_col=zeros(1,H_row_num); % �����洢����H������������ÿһ����ʼλ���к�
%---------------------------------
% 1.2 ���ɾ���H����ʱ��
for index_0=1:H_row_num
    index_1=(2*H_row_num+14)-row_6_end-2-(2*index_0-2);
    H_tmp1(index_0,:)=[zeros(1,2*index_0-2) row_6 zeros(1,index_1)];
end
% 1.3 ���ɾ���H
for index_0=1:row_6_end
    H_tmp1(:,index_0)=H_tmp1(:,index_0)+H_tmp1(:,index_0+H_col_num);
end
for index_0=1:H_col_num
    H_matrix(:,index_0)=H_tmp1(:,index_0);
end
H_matrix1=H_matrix;
% ����H�������
%---------------------------------
% 1.4 ��2Ԫ���ϣ��Ծ���H���б任��������������Ρ�
for index_0=1:H_row_num % ��������H�������У�������index_0�У�
    for index_1=1:H_col_num
        % ������H�ĵ�index_0�У�ȡ����һ��Ϊ1��Ԫ�ص��кţ���index_1�У�
        if (H_matrix(index_0,index_1))==1
            % �Ѿ������index_1
            H_matrix_rank=H_matrix_rank+1; % ������ȼ�����1
            H_matrix_1_col(H_matrix_rank)=index_1; 
            % �洢����H�����������ε�index_0����ʼλ���кţ�index_1��
            for index_2=1:H_row_num
                if index_2~=index_0 % ���ڲ���index_0���У���index_2�У�
                    if H_matrix(index_2,index_1)==1 % ��������е�H����Ԫ��Ϊ1
                        H_matrix(index_2,:)=mod(H_matrix(index_2,:)+H_matrix(index_0,:),2);
                    end
                end
            end
            break;
        end
    end    
end
% 1.4������ɣ��Ѿ��任�����������ͣ��任�Ľ������H_matrix�У�ǰ�浥λ������кŴ���H_matrix_1_col��
%--------------------------------------------------------------------------
% step 2
% �������ɾ���G
%---------------------------------
G_matrix_1_col=zeros(1,H_col_num-H_matrix_rank); % �����洢����G�ı���ԭ����к�
G_matrix_1_col_length=0; % �����洢G_matrix_1_col�ķ�����ĳ���
G_matrix=zeros(H_col_num-H_matrix_rank,H_col_num); % ���ɾ���G
G_matrix_change1=zeros(H_col_num-H_matrix_rank,H_col_num); % δ�š�����֮ǰ�����ɾ���G
%---------------------------------
% 2.1 ���H�����У�����������������ʼλ���кţ���Ϊ����G�ı���ԭ����к�
H_col_0=zeros(1,H_col_num); % ���ڴ洢H�����У�����������������ʼλ���кŵ���ʱ����
for index_0=1:H_matrix_rank
    H_col_0(H_matrix_1_col(index_0))=1;
end
for index_0=1:H_col_num
    if H_col_0(index_0)==0;
        G_matrix_1_col_length=G_matrix_1_col_length+1;
        G_matrix_1_col(G_matrix_1_col_length)=index_0;
    end
end
% ��H�����У�����������������ʼλ���кš���Ϊ����G�ı���ԭ����к�
% ��Щ�кŴ洢��G_matrix_1_col�����ΪG_matrix_1_col_length��
%----------------------------------
% 2.2 ����H������������
H_matrix_change1=zeros(H_row_num,H_col_num); % ���ڴ洢���������ľ���H
for index_0=1:G_matrix_1_col_length
    H_matrix_change1(:,index_0)=H_matrix(:,G_matrix_1_col(index_0));
end
for index_0=1:H_matrix_rank
    H_matrix_change1(:,G_matrix_1_col_length+index_0)=H_matrix(:,H_matrix_1_col(index_0));
end

% ����������H��ɣ�H_matrix_change1��
%---------------------------------
% 2.3 ȡ����������H��ǰ�벿�ݸ�G�ĺ�벿�֣�G��ǰ�벿��Ϊ��λ��
G_matrix_change1(:,G_matrix_1_col_length+1:G_matrix_1_col_length+H_matrix_rank)=H_matrix_change1(:,1:G_matrix_1_col_length)';
G_matrix_change1(:,1:G_matrix_1_col_length)=eye(G_matrix_1_col_length);
% δ�š�����֮ǰ�����ɾ���G�������
%---------------------------------
% ��ʼ�š����򡱣�����G_matrix
for index_0=1:G_matrix_1_col_length
    G_matrix(:,G_matrix_1_col(index_0))=G_matrix_change1(:,index_0);
end
for index_0=1:H_matrix_rank
    G_matrix(:,H_matrix_1_col(index_0))=G_matrix_change1(:,G_matrix_1_col_length+index_0);
end
% G_matrix�������
%--------------------------------------------------------------------------
% ��֤����,ʵ�ʳ���ע����
%a_tmp=round(rand(1,33));
% c_tmp=mod(uncode*G_matrix,2);
% d_result=mod(H_matrix*c_tmp',2);
% d_result2=mod(H_matrix1*c_tmp',2);
%--------------------------------------------------------------------------