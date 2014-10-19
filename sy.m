%��������֤��ͯģ���˳�ѧ���������--������ڱ�����
clc
clear
close all

%% ��������
sj=10;     %����������Ĵ���
n=1000;    %�۲������
rate=1;       %�˼�
fare=0.6;   %���ݵ�λ�۸�
D1=0.2E4;     %������ݵ����ֵ
D2=10.2E4;     %������ݵ����ֵ,D1��D2��ȡֵ�Ǹ��ݵ����ķֲ�
Gap=1000;         %����ÿ�ε����ֵ
cs=(D2-D1)/Gap;    %����Ĵ���cs
c=D1+Gap:Gap:D2; %����Ĳ������У�������Ĵ�����Ӧ
m=10;v=0.5;           %ÿ�쵽������������lognrnd��������ֵ�ͷ����ʵ�Ƕ��ڵ���̬�ֱ�ģ�
Co=fare;                      %��������ĳɱ�
Cu=rate-fare;          %����Ӧ��ĳɱ�
SL=Cu/(Cu+Co);            %��ͯ����ķ���ˮƽ

rng(1);      % �����������
d= lognrnd(m,v,sj*2,n);      %���ɵ����Ļ�������������,��sj*2��(�У���ǰsj��������⣬��sj��������֤

for rseed=1:sj    %��ͬ���������������--���ݲ�ͬ
    %% �����������еĲ��ݣ�һ���Ěi�ࣩȥ���飬�õ����Ų���
    for cr=1:cs                %cr-��������cs-ѭ���Ĵ���
        for ts=1:n               %ts--�۲�ĵڼ�����   n-��������
            if d(rseed,ts)>c(cr)
                revenue1(cr,ts)=c(cr)*(rate-fare);
            else
                revenue1(cr,ts)=d(rseed,ts)*rate-c(cr)*fare;
            end
            if mod(ts,20)==0&mod(cr,10)==0
                fprintf('������⣬��ǰ�ǵ�%d-%d-%d�Σ���%d-%d-%d��\n', ts,cr,rseed,n,cs,sj)
            end
        end
        revenue1_m(rseed,cr)=mean(revenue1(cr,:));                   %��ǰ�������µĶ��������ƽ��ֵ
    end
    
    J2(rseed)=prctile(d(rseed,:),SL*100);
    for ts=1:n               %ts--�۲�ĵڼ�����   n-��������
            if d(rseed,ts)>J2(rseed)
                revenue2(rseed,ts)=(rate-fare)*J2(rseed);
            else
                revenue2(rseed,ts)=d(rseed,ts)*rate-J2(rseed)*fare;
            end
    end
end
[revenue1_m_max,id]=max(revenue1_m,[],2);   %������ id--�����⣬�ҵ�sj������������ݵ�������ֵ��λ��
J1=c(id);
revenue2_m_max=mean(revenue2,2);        %������

figure
plot(J1-J2,'k-o','LineWidth',1,'MarkerSize',5);
grid on
title('������-������')

figure
plot(revenue2_m_max-revenue1_m_max,'k-o','LineWidth',1,'MarkerSize',5);
grid on
title('�������������-�����⣩')

figure
hist(revenue2_m_max-revenue1_m_max);