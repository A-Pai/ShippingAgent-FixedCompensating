%�˳����о�������ֻ�յ�һ�۸������췢�ͣ��Ƴٵ��ڶ������ṩ�⳥�������Ų�������
%ÿ�����Ԥ���Ĳ���c=�̶����Ų���C+ǰһ�������B0


clc
clear
close all

%% ��������
n=100;                       %�۲������
rate=1;                       %�˼�
fare=0.6;                   %���ݵ�λ�۸�
p=0.2;                        %ÿ�Ӻ�һ�죬�⳥p
D1=0.2E4;                %������ݵ����ֵ
D2=10.2E4;              %������ݵ����ֵ,D1��D2��ȡֵ�Ǹ��ݵ����ķֲ�
Gap=1000;
cs=(D2-D1)/Gap;       %ʵ��Ĵ���cs
m=10;v=0.5;              %ÿ�쵽������������lognrnd��������ֵ�ͷ����ʵ�Ƕ��ڵ���̬�ֱ�ģ�
Co=fare;                      %��������ĳɱ�
Cu=rate-fare+p;          %����Ӧ��ĳɱ�
P=Cu/(Cu+Co);            %��ͯ����ķ���ˮƽ
C=logninv(P,m,v);        %���ͱ�ͯ����Ľ�--��ȡ��λ��

%% ����
B0(1)=0;
for rseed=1:n
    rng(rseed);      % �����������
    d(rseed)= lognrnd(m,v,1);      %���ɵ���Ļ���������
    c(rseed)=C+B0(rseed);                  
    if (d(rseed)+B0(rseed))<c(rseed)
        revenue(rseed)=d(rseed)*rate-c(rseed)*fare;   %���������ʵ�ʵģ���������(�Խӻ�ʱ��Ϊ׼--�ӻ�ʱ��Ǯ��-���ݿ�֧
        Lf(rseed)=d(rseed)/c(rseed);
        B0(rseed+1)=0;
    else
        B0(rseed+1)=d(rseed)+B0(rseed)-c(rseed);
        revenue(rseed)=d(rseed)*rate-B0(rseed+1)*p-c(rseed)*fare;
        Lf(rseed)=1;
        if d(rseed)>c(rseed)
            yc(rseed)=1;           %yc--�ӳ٣��������ĵ������ڲ��ݣ����������ӳٷ���
        else
            yc(rseed)=0;
        end
    end
    if mod(rseed,20)==0
        fprintf('���飬��ǰ�ǵ�%d�Σ���%d��\n', rseed,n)
    end
end
tran_T=sum(d)-B0(rseed);

revenue_m=mean(revenue);

save JL_Single4_p0_2    revenue  Lf   revenue_m c d  tran_T n  fare


bar(c-d-B0(1:n),'k')
title('��������');


fprintf('ƽ������Ϊ��%.2e\n', revenue_m)
fprintf('��ʱ��������Ϊ��%.2e���ܲ���Ϊ��%.2e��ƽ��������Ϊ��%.2f%%\n', tran_T,sum(c),tran_T*100/sum(c))
fprintf('��ʱƽ���ʽ�������Ϊ��%.2f%%\n', revenue_m*n*100/(sum(c)*fare))




