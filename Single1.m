%�˳����о������µ��췢����������Ų�������---possion�ֲ����ڵ���

clc
clear
close all


n=100;    %�۲������
rate=1;       %һ���ڷ������˼ۣ�1����˼ۣ�
p=0.2;      %ÿ�Ӻ�һ�죬�⳥p������1�����2���
Arrivals=100;
R=0;
D1=4.5E4;     %������ݵ����ֵ
D2=6.5E4;     %������ݵ����ֵ
cs=(D2-D1)/100;    %ʵ��Ĵ���

for k=1:cs
    B0=0;     %��ʼ�ġ���һ��������
    c=D1+k*100;
    for rseed=1:100
        d(rseed)=sum(weight(rseed,Arrivals,500 ,10^2));     %kg
        if d(rseed)+B0<c
            r(k,rseed)=d(rseed)*rate;
            Lf(k,rseed)=(d(rseed)+B0)/c;
        else
            r(k,rseed)=d(rseed)*rate-(d(rseed)+B0-c)*p;
            B0=d(rseed)+B0-c;
            Lf(k,rseed)=1;
        end
        if mod(rseed,20)==0&mod(k,10)==0
            fprintf('���飬��ǰ�ǵ�%d-%d�Σ���%d-%d��\n', rseed,k,100,cs)
        end
    end
    gkkz=c/10;
    r_m(k)=mean(r(k,:))-gkkz;
    ratio(k)=r_m(k)/gkkz;
    
end
