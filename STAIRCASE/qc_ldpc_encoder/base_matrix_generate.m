m_base = 6; % ������������
n_base = 42; % ������������
z = 52; % �Ӿ����С��z+1 �������������� z > (m_base + n_base)

base_matrix = qc_ldpc_cons(m_base,n_base,z);

dlmwrite('base_matrix.txt', base_matrix, 'delimiter','\t');
disp(base_matrix);

fprintf('�볤��%g\n',n_base * z);
fprintf('���ʣ�%g\n',1 - m_base / n_base);
