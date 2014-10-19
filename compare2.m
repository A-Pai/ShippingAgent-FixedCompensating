%�˳���Ƚϵ��ںͶ��ڵ�һ�۸�����������

clc
clear
close all

load JL_Single2_p0_1     %p=0.1
figure
hold on
h1=plot(c,revenue_m,'k-','LineWidth',1);
[R,id] = max(revenue_m);
h= plot(c(id),R,'k*','MarkerSize',8);
[R,id] = max(revenue_m);
fprintf('p=0.1,�������Ϊ��%.2e������������Ϊ��%.2e\n', R,c(id))
fprintf('��ʱ��������Ϊ��%.2e���ܲ���Ϊ��%.2e��ƽ��������Ϊ��%.2f%%\n', tran_T(id),c(id)*n,tran_T(id)*100/(c(id)*n))
fprintf('��ʱƽ���ʽ�������Ϊ��%.2f%%\n', R*100/(c(id)*fare))



load JL_Single2_p0_2     %p=0.2
h2=plot(c,revenue_m,'k--','LineWidth',1);
[R,id] = max(revenue_m);
h= plot(c(id),R,'k*','MarkerSize',8);
fprintf('p=0.2,�������Ϊ��%.2e������������Ϊ��%.2e\n', R,c(id))
fprintf('��ʱ��������Ϊ��%.2e���ܲ���Ϊ��%.2e��ƽ��������Ϊ��%.2f%%\n', tran_T(id),c(id)*n,tran_T(id)*100/(c(id)*n))
fprintf('��ʱƽ���ʽ�������Ϊ��%.2f%%\n', R*100/(c(id)*fare))

load JL_Single2_p0_4     %p=0.4
h3=plot(c,revenue_m,'k:','LineWidth',1);
[R,id] = max(revenue_m);
h= plot(c(id),R,'k*','MarkerSize',8);
fprintf('p=0.4,�������Ϊ��%.2e������������Ϊ��%.2e\n', R,c(id))
fprintf('��ʱ��������Ϊ��%.2e���ܲ���Ϊ��%.2e��ƽ��������Ϊ��%.2f%%\n', tran_T(id),c(id)*n,tran_T(id)*100/(c(id)*n))
fprintf('��ʱƽ���ʽ�������Ϊ��%.2f%%\n', R*100/(c(id)*fare))

load JL_Single3
h4=plot(c,revenue_m,'r-','LineWidth',1);
[R2,id2] = max(revenue_m);
h= plot(c(id2),R2,'k*','MarkerSize',8);

grid on
legend([h1 h2 h3 h4 h],'����p=0.1','����p=0.2','����p=0.4','����','���ֵ','Location','best')
xlabel('����');
ylabel('ƽ������');
title('ƽ����������ݱ仯����')
