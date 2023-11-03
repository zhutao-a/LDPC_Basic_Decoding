m_base = 6; % 基础矩阵行数
n_base = 42; % 基础矩阵列数
z = 52; % 子矩阵大小，z+1 必须是质数，且 z > (m_base + n_base)

base_matrix = qc_ldpc_cons(m_base,n_base,z);

dlmwrite('base_matrix.txt', base_matrix, 'delimiter','\t');
disp(base_matrix);

fprintf('码长：%g\n',n_base * z);
fprintf('码率：%g\n',1 - m_base / n_base);
