%此程序研究多期下只收单一价格货物（当天发送，推迟到第二天则提供赔偿）的最优仓容问题
%理论法确定最优仓容c(固定):将当天的到货和前一天的余量B0合在一起看成第二天的到货，是一个新的随机变量


clc
clear
close all

%% 参数设置
ts=100;                 %拥有的以前的到货量的天数，用以求解最优仓容
n=100;                       %观测多少天，用以与遍历法比较
rate=1;                       %运价
fare=0.6;                   %仓容单位价格
p=0.2;                        %每延后一天，赔偿p

m=10;v=0.5;              %每天到来货物重量的lognrnd参数：均值和方差（其实是对于的正态分别的）
Co=fare;                      %供过于求的成本
Cu=rate-fare+p;          %供不应求的成本
P=Cu/(Cu+Co);            %报童问题的服务水平
cross=inf;

%% 求取最佳仓容
%  load d    %载入数据d，由Single2.m生成，保证与Single2.m的数据相同

rng(1);      % 设置随机种子
d= lognrnd(m,v,1,ts);      %生成当天的货物总重量

go_on=1;         %go_on等于1，则循环继续
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
    
%     distance1=distance2;    %记录上一次的差距
%     distance2=(c(cs)-C(cs));      %当次的差距
    
    fprintf('试验，当前c和C的值分别为：%d，%d\n',c(cs),C(cs))
    if c(cs)>C(cs)&c(cs-1)<C(cs-1)
        cross=cs;
    end
    if cs==cross+250
        go_on=0;
    end
    cs=cs+1;
    c(cs)=c(cs-1)+100;           %仓容订量
end

%% 求解过程
h1=plot(1:cs,c,'k-','LineWidth',2);
hold on
h2=plot(1:cs-1,C,'k:','LineWidth',2);
[optimal,id]=min(abs(c(1:cs-1)-C));
h=plot(id,c(id),'k.','MarkerSize',15);
grid on
legend([h1 h2 h],'试验仓容值','概率对应值','最优仓容值','Location','best')

%% 试验
B0(1)=0;
C=c(id);
C=2.90e+04;
for rseed=1:n
    rng(rseed);      % 设置随机种子
    dd(rseed)= lognrnd(m,v,1);      %生成当天的货物总重量
    if (dd(rseed)+B0(rseed))<C
        revenue(rseed)=dd(rseed)*rate-C*fare;   %这个收益是实质的，承运所得(以接货时刻为准--接货时收钱）-仓容开支
        Lf(rseed)=dd(rseed)/C;
        B0(rseed+1)=0;
    else
        B0(rseed+1)=dd(rseed)+B0(rseed)-C;
        revenue(rseed)=dd(rseed)*rate-B0(rseed+1)*p-C*fare;
        Lf(rseed)=1;
        if dd(rseed)>C
            yc(rseed)=1;           %yc--延迟，如果当天的到货大于仓容，则当天会存在延迟发送
        else
            yc(rseed)=0;
        end
    end
    if mod(rseed,20)==0
        fprintf('试验，当前是第%d次，共%d次\n', rseed,n)
    end
end
tran_T=sum(dd)-B0(rseed);

revenue_m=mean(revenue);

save JL_Single5_p0_2    revenue  Lf   revenue_m c dd  tran_T n  fare




fprintf('平均收益为：%.2e,发生在仓容订量为：%.2e\n', revenue_m,C)
fprintf('此时总运输量为：%.2e，总仓容为：%.2e，平均满载率为：%.2f%%\n', tran_T,C*n,mean(Lf)*100)
fprintf('此时平均资金收益率为：%.2f%%\n', revenue_m*100/(C*fare))


bar(c-dd-B0(1:n),'k')
title('仓容余量');


