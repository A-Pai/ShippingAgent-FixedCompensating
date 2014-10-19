%�˳���Ƚϵ��ںͶ��ڵ�һ�۸�����������

clc
clear
close all

load JL_Single2_p0_1
[R1,id1] = max(revenue_m);
h1= plot(c(id1),R1,'k*','MarkerSize',5);
hold on
h2=plot(c,revenue_m,'k-','LineWidth',2);
tran_T2=tran_T(id1);

fprintf('���ڣ��������Ϊ��%.2f�������ڵ�����Ϊ��%d\n', R1,c(id1))

load JL_Single3
h3=plot(c,revenue_m,'r-','LineWidth',2);
[R2,id2] = max(revenue_m);
h= plot(c(id2),R2,'r*','MarkerSize',5);
legend([h1,h2,h3],'���ֵ','����','����','Location','best')
xlabel('����');
ylabel('ƽ������');
grid on
tran_T3=tran_T(id2);
fprintf('���ڣ��������Ϊ��%.2f�������ڵ�����Ϊ��%d\n', R2,c(id2))

fprintf('���ڱȵ��ڵ����������ˣ�%.2f%%�������ͻ��%.2f%%\n', (R1-R2)*100/R2,(tran_T2-tran_T3)*100/tran_T3)