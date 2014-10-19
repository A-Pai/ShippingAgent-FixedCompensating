%�˳����о�������ֻ�յ�һ�۸������췢�ͣ��Ƴٵ��ڶ������ṩ�⳥�������Ų�������---����
%������ȷ�����Ų���
%�����ۿ�


clc
clear
close all

%% ��������
n=100;    %�۲������
rate=1;       %�˼�
fare=0.6;   %���ݵ�λ�۸�
p=0.1;      %ÿ�Ӻ�һ�죬�⳥p
D1=0.2E4;     %������ݵ����ֵ
D2=10.2E4;     %������ݵ����ֵ,D1��D2��ȡֵ�Ǹ��ݵ����ķֲ�
Gap=1000;
cs=(D2-D1)/Gap;    %ʵ��Ĵ���cs
m=10;v=0.5;           %ÿ�쵽������������lognrnd��������ֵ�ͷ����ʵ�Ƕ��ڵ���̬�ֱ�ģ�
beta=1-1E-2;           %�ۿ���
% beta=1;           %�ۿ���
%% ����
for k=1:cs
    B0=0;
    c=D1+k*Gap;
    for rseed=1:n
        rng(rseed);      % �����������
        d(rseed)= lognrnd(m,v,1);      %���ɵ���Ļ���������
        if (d(rseed)+B0)<c
            revenue(k,rseed)=d(rseed)*rate-c*fare;   %���������ʵ�ʵģ���������(�Խӻ�ʱ��Ϊ׼--�ӻ�ʱ��Ǯ��-���ݿ�֧
            Lf(k,rseed)=d(rseed)/c;
            B0=0;
        else
            B0=d(rseed)+B0-c;
            revenue(k,rseed)=d(rseed)*rate-B0*p-c*fare;
            Lf(k,rseed)=1;
            if d(rseed)>c
                yc(k,rseed)=1;           %yc--�ӳ٣��������ĵ������ڲ��ݣ����������ӳٷ���
            else
                yc(k,rseed)=0;
            end
        end
        if mod(rseed,20)==0&mod(k,10)==0
            fprintf('���飬��ǰ�ǵ�%d-%d�Σ���%d-%d��\n', rseed,k,n,cs)
        end
    end
    tran_T(k)=sum(d)-B0;
end
zk=repmat(beta.^(0:n-1),cs,1);      %�ۿ۾���
revenue_m=mean(revenue.*zk,2);
c=D1+Gap:Gap:D2;
[R,id] = max(revenue_m);

fprintf('�ۿ���Ϊ��%.2f%%\n', beta*100)
fprintf('�������Ϊ��%.2e������������Ϊ��%.2e\n', R,c(id))
fprintf('��ʱ��������Ϊ��%.2e���ܲ���Ϊ��%.2e��ƽ��������Ϊ��%.2f%%\n', tran_T(id),c(id)*n,tran_T(id)*100/(c(id)*n))
fprintf('��ʱƽ���ʽ�������Ϊ��%.2f%%\n', R*100/(c(id)*fare))
% save JL_Single2D_p0_1    revenue  Lf   revenue_m c d  tran_T n  fare

%% ��������ݱ仯����
figure
hold on
h1=plot(c,revenue_m,'k-','LineWidth',2);

h= plot(c(id),R,'k*','MarkerSize',8);
grid on
hold on
load JL_Single2_p0_1
h2=plot(c,revenue_m,'r-','LineWidth',2);
[R,id] = max(revenue_m);
h= plot(c(id),R,'k*','MarkerSize',8);

legend([h1 h2 h],'  �ۿ�ģ��','���ۿ�ģ��','����','Location','best')
xlabel('����');
ylabel('ƽ������');
title('ƽ����������ݱ仯����')



fprintf('���ۿ�ʱ��\n')
fprintf('�������Ϊ��%.2e������������Ϊ��%.2e\n', R,c(id))
fprintf('��ʱ��������Ϊ��%.2e���ܲ���Ϊ��%.2e��ƽ��������Ϊ��%.2f%%\n', tran_T(id),c(id)*n,tran_T(id)*100/(c(id)*n))
fprintf('��ʱƽ���ʽ�������Ϊ��%.2f%%\n', R*100/(c(id)*fare))


% ratio=revenue_m./c';
% [C,id] = max(ratio);
% figure
% hold on
% h2=plot(c(id),ratio(id),'kh','MarkerSize',10);
% h3=plot(c,ratio,'k-','LineWidth',2);
% h4=plot(c,mean(Lf,2),'k:','LineWidth',2);
% xlabel('����');
% % ylabel('������');
% legend([h2 h1 h3 h4 ],'���������','����ֵ���','������','������','Location','best')
% grid on

