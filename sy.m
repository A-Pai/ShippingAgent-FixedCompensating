%本程序验证报童模型运筹学解的优良性--收益大于遍历解
clc
clear
close all

%% 参数设置
sj=10;     %产生随机数的次数
n=1000;    %观测多少天
rate=1;       %运价
fare=0.6;   %仓容单位价格
D1=0.2E4;     %试验仓容的最低值
D2=10.2E4;     %试验仓容的最高值,D1和D2的取值是根据到货的分布
Gap=1000;         %仓容每次的添加值
cs=(D2-D1)/Gap;    %试验的次数cs
c=D1+Gap:Gap:D2; %试验的仓容序列，与试验的次数对应
m=10;v=0.5;           %每天到来货物重量的lognrnd参数：均值和方差（其实是对于的正态分别的）
Co=fare;                      %供过于求的成本
Cu=rate-fare;          %供不应求的成本
SL=Cu/(Cu+Co);            %报童问题的服务水平

rng(1);      % 设置随机种子
d= lognrnd(m,v,sj*2,n);      %生成到货的货物总重量序列,共sj*2次(行），前sj次用于求解，后sj次用于验证

for rseed=1:sj    %不同的随机种子下试验--数据不同
    %% 遍历法：所有的仓容（一定的歩距）去试验，得到最优仓容
    for cr=1:cs                %cr-订舱量，cs-循环的次数
        for ts=1:n               %ts--观察的第几天数   n-共多少天
            if d(rseed,ts)>c(cr)
                revenue1(cr,ts)=c(cr)*(rate-fare);
            else
                revenue1(cr,ts)=d(rseed,ts)*rate-c(cr)*fare;
            end
            if mod(ts,20)==0&mod(cr,10)==0
                fprintf('遍历求解，当前是第%d-%d-%d次，共%d-%d-%d次\n', ts,cr,rseed,n,cs,sj)
            end
        end
        revenue1_m(rseed,cr)=mean(revenue1(cr,:));                   %当前仓容量下的多期收益的平均值
    end
    
    J2(rseed)=prctile(d(rseed,:),SL*100);
    for ts=1:n               %ts--观察的第几天数   n-共多少天
            if d(rseed,ts)>J2(rseed)
                revenue2(rseed,ts)=(rate-fare)*J2(rseed);
            else
                revenue2(rseed,ts)=d(rseed,ts)*rate-J2(rseed)*fare;
            end
    end
end
[revenue1_m_max,id]=max(revenue1_m,[],2);   %遍历解 id--遍历解，找到sj次随机产生数据的最大仓容值和位置
J1=c(id);
revenue2_m_max=mean(revenue2,2);        %解析解

figure
plot(J1-J2,'k-o','LineWidth',1,'MarkerSize',5);
grid on
title('遍历解-解析解')

figure
plot(revenue2_m_max-revenue1_m_max,'k-o','LineWidth',1,'MarkerSize',5);
grid on
title('最大收益差（解析解-遍历解）')

figure
hist(revenue2_m_max-revenue1_m_max);