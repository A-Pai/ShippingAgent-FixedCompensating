%�˳����о�������ֻ�յ�һ�۸������췢�ͣ��Ƴٵ��ڶ������ṩ�⳥�������Ų�������
%���۷�ȷ�����Ų���c(�̶�):������ĵ�����ǰһ�������B0����һ�𿴳ɵڶ���ĵ�������һ���µ��������


clc
clear
close all

%% ��������
ts=100;                 %ӵ�е���ǰ�ĵ�����������������������Ų���
n=100;                       %�۲�����죬������������Ƚ�
rate=1;                       %�˼�
fare=0.6;                   %���ݵ�λ�۸�
p=0.2;                        %ÿ�Ӻ�һ�죬�⳥p

m=10;v=0.5;              %ÿ�쵽������������lognrnd��������ֵ�ͷ����ʵ�Ƕ��ڵ���̬�ֱ�ģ�
Co=fare;                      %��������ĳɱ�
Cu=rate-fare+p;          %����Ӧ��ĳɱ�
P=Cu/(Cu+Co);            %��ͯ����ķ���ˮƽ
cross=inf;

%% ��ȡ��Ѳ���
%  load d    %��������d����Single2.m���ɣ���֤��Single2.m��������ͬ

rng(1);      % �����������
d= lognrnd(m,v,1,ts);      %���ɵ���Ļ���������

go_on=1;         %go_on����1����ѭ������
c=0;
distance2=inf;
k=0;
c(1)=100;
cs=1;
while  go_on
    B0=0;
    for k=1:ts-1
        if d(k)+B0<c(cs)
            D(k)=d(k+1);
            B0=0;
        else
            D(k)=d(k+1)+B0;
            B0= D(k)-c(cs);
        end
    end
    C(cs)=prctile(D,P*100);
    
%     distance1=distance2;    %��¼��һ�εĲ��
%     distance2=(c(cs)-C(cs));      %���εĲ��
    
    fprintf('���飬��ǰc��C��ֵ�ֱ�Ϊ��%d��%d\n',c(cs),C(cs))
    if c(cs)>C(cs)&c(cs-1)<C(cs-1)
        cross=cs;
    end
    if cs==cross+250
        go_on=0;
    end
    cs=cs+1;
    c(cs)=c(cs-1)+100;           %���ݶ���
end

%% ������
h1=plot(1:cs,c,'k-','LineWidth',2);
hold on
h2=plot(1:cs-1,C,'k:','LineWidth',2);
[optimal,id]=min(abs(c(1:cs-1)-C));
h=plot(id,c(id),'k.','MarkerSize',15);
grid on
legend([h1 h2 h],'�������ֵ','���ʶ�Ӧֵ','���Ų���ֵ','Location','best')

%% ����
B0(1)=0;
C=c(id);
C=2.90e+04;
for rseed=1:n
    rng(rseed);      % �����������
    dd(rseed)= lognrnd(m,v,1);      %���ɵ���Ļ���������
    if (dd(rseed)+B0(rseed))<C
        revenue(rseed)=dd(rseed)*rate-C*fare;   %���������ʵ�ʵģ���������(�Խӻ�ʱ��Ϊ׼--�ӻ�ʱ��Ǯ��-���ݿ�֧
        Lf(rseed)=dd(rseed)/C;
        B0(rseed+1)=0;
    else
        B0(rseed+1)=dd(rseed)+B0(rseed)-C;
        revenue(rseed)=dd(rseed)*rate-B0(rseed+1)*p-C*fare;
        Lf(rseed)=1;
        if dd(rseed)>C
            yc(rseed)=1;           %yc--�ӳ٣��������ĵ������ڲ��ݣ����������ӳٷ���
        else
            yc(rseed)=0;
        end
    end
    if mod(rseed,20)==0
        fprintf('���飬��ǰ�ǵ�%d�Σ���%d��\n', rseed,n)
    end
end
tran_T=sum(dd)-B0(rseed);

revenue_m=mean(revenue);

save JL_Single5_p0_2    revenue  Lf   revenue_m c dd  tran_T n  fare




fprintf('ƽ������Ϊ��%.2e,�����ڲ��ݶ���Ϊ��%.2e\n', revenue_m,C)
fprintf('��ʱ��������Ϊ��%.2e���ܲ���Ϊ��%.2e��ƽ��������Ϊ��%.2f%%\n', tran_T,C*n,mean(Lf)*100)
fprintf('��ʱƽ���ʽ�������Ϊ��%.2f%%\n', revenue_m*100/(C*fare))


bar(c-dd-B0(1:n),'k')
title('��������');


