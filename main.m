clc
clear
close all

B0=0;     %初始的“第一天余量”
c=8000;     %仓容
n=100;    %观测多少天
r1=1;       %一天内发出的运价（1类货运价）
r2=0.8;    %二天内发出的运价（2类货运价）
p=0.2;      %每延后一天，赔偿p，不分1类货和2类货
T=100;       %每天的接货期
for m=1:100
    for k=1:n
        rseed=k;
        Arrivals=sum(booking_arrivals(rseed,m,0.20));
        d1=sum(weight(rseed,Arrivals,500 ,10^2));     %kg
        rseed=k+100;      %将随机种子区分开来，1类货和2类货独立
        Arrivals=sum(booking_arrivals(rseed,T-m,0.1));
        d2=sum(weight(rseed,Arrivals,500 ,10^2));     %kg
        [r,B0,Lf,s]=revenue(B0,d1,d2,c,r1,r2,p);
        Revenue(m,k)=r;
        Load_factor(m,k)=Lf;
        State(m,k)=s;
        if mod(k,10)==0
            fprintf('试验，当前是第%d-%d次，共%d-%d次\n', k,m,n,100)
        end
    end
    
    R_mean(m)=mean(Revenue(m,:));
    Lf_mean(m)=mean(Load_factor(m,:));
end

save JL Revenue Load_factor R_mean Lf_mean