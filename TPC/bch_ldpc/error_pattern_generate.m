function t=error_pattern_generate(N)%�Ը��������ʽ���ɲ�������
sub_gray=[0;1];
for n=2:N
    top_gray=[zeros(1,2^(n-1))' sub_gray];
    bottom_gray=[ones(1,2^(n-1))' sub_gray];
    bottom_gray=bottom_gray(end:-1:1,:);
    sub_gray=[top_gray;bottom_gray];
end
t=sub_gray;
end

