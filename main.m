clc
clear
close all

B0=0;     %��ʼ�ġ���һ��������
c=8000;     %����
n=100;    %�۲������
r1=1;       %һ���ڷ������˼ۣ�1����˼ۣ�
r2=0.8;    %�����ڷ������˼ۣ�2����˼ۣ�
p=0.2;      %ÿ�Ӻ�һ�죬�⳥p������1�����2���
T=100;       %ÿ��Ľӻ���
for m=1:100
    for k=1:n
        rseed=k;
        Arrivals=sum(booking_arrivals(rseed,m,0.20));
        d1=sum(weight(rseed,Arrivals,500 ,10^2));     %kg
        rseed=k+100;      %������������ֿ�����1�����2�������
        Arrivals=sum(booking_arrivals(rseed,T-m,0.1));
        d2=sum(weight(rseed,Arrivals,500 ,10^2));     %kg
        [r,B0,Lf,s]=revenue(B0,d1,d2,c,r1,r2,p);
        Revenue(m,k)=r;
        Load_factor(m,k)=Lf;
        State(m,k)=s;
        if mod(k,10)==0
            fprintf('���飬��ǰ�ǵ�%d-%d�Σ���%d-%d��\n', k,m,n,100)
        end
    end
    
    R_mean(m)=mean(Revenue(m,:));
    Lf_mean(m)=mean(Load_factor(m,:));
end

save JL Revenue Load_factor R_mean Lf_mean