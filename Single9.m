%计量二种算法的耗时
%此程序研究多期下只收单一价格货物（当天发送，推迟到第二天则提供赔偿）的最优仓容问题---总量
%遍历法确定最优仓容，迭代法的解与之比较，表明迭代法可行
%试验最优值的稳定性--不同的随机种子
%采用报童-迭代法(波尔查诺二分法)


clc
clear
close all

%% 参数设置
sj=10;     %产生随机数的次数
n=1000;    %观测多少天
rate=1;       %运价
fare=0.6;   %仓容单位价格
p=0.2;      %每延后一天，赔偿p
D1=0.2E4;     %试验仓容的最低值
D2=10.2E4;     %试验仓容的最高值,D1和D2的取值是根据到货的分布
Gap=1000;         %仓容每次的添加值
cs=(D2-D1)/Gap;    %试验的次数cs
c=D1+Gap:Gap:D2; %试验的仓容序列，与试验的次数对应
m=10;v=0.5;           %每天到来货物重量的lognrnd参数：均值和方差（其实是对于的正态分别的）
Co=fare;                      %供过于求的成本
Cu=rate-fare+p;          %供不应求的成本
SL=Cu/(Cu+Co);            %报童问题的服务水平

rng(1);      % 设置随机种子
d= lognrnd(m,v,sj*2,n);      %生成到货的货物总重量序列,共sj*2次(行），前sj次用于求解，后sj次用于验证

%% 遍历法得到最优仓容
tic;
for rseed=1:sj    %不同的随机种子下试验--数据不同
    %% 遍历法：所有的仓容（一定的歩距）去试验，得到最优仓容
    for cr=1:cs                %cr-订舱量，cs-循环的次数
        B0=0;
        for ts=1:n               %ts--观察的第几天数   n-共多少天
                      if (d(rseed,ts)+B0)<c(cr)                    %如果当天的订舱量够用（针对于当天的到货量和前一天的遗留）
                B0=0;
            else                                                       %%如果当天的订舱量不够用（针对于当天的到货量和前一天的遗留）
                B0=d(rseed,ts)+B0-c(cr);                        %%当天要遗留下来的货物量
            end
            revenue1(cr,ts)=d(rseed,ts)*rate-B0*p-c(cr)*fare;
%             if mod(ts,20)==0&mod(cr,10)==0
%                 fprintf('遍历求解，当前是第%d-%d-%d次，共%d-%d-%d次\n', ts,cr,rseed,n,cs,sj)
%             end
        end
        revenue1_m(rseed,cr)=mean(revenue1(cr,:));                   %当前仓容量下的多期收益的平均值
    end
end
time_bl=toc;


%% 迭代法得到最优仓容
tic;
for rseed=1:sj    %不同的随机种子下试验--数据不同
%%  迭代法(波尔查诺二分法）----不是挨个去试
    ddcs=1;  %迭代次数
    a=D1;      %D1是明显的“不可能为最佳仓容”的较小值
    b=D2;      %D2是明显的“不可能为最佳仓容”的较大值
    c_dd(rseed,ddcs)=(a+b)/2;      %试验仓容
    Distance(rseed,ddcs)=distance(c_dd(rseed,ddcs),d(rseed,:),SL);   %求取当前试验仓容c_dd(rseed,ddcs)、当前到货序列d(rseed,:)，服务水平SL下的C-c
    threshold=5;    %原始阈值
    times=1;          %设置阈值的次数
    while abs(Distance(rseed,ddcs))>threshold         %当当前的“C-c”还较大
        if  distance(c_dd(rseed,ddcs),d(rseed,:),SL)*distance(b,d(rseed,:),SL)<0
            a=c_dd(rseed,ddcs);
        else
            b=c_dd(rseed,ddcs);
        end
        c_dd(rseed,ddcs+1)=(a+b)/2;
        Distance(rseed,ddcs+1)=distance(c_dd(rseed,ddcs+1),d(rseed,:),SL);
        ddcs=ddcs+1;
        if ddcs>20*times       %新的“阈值”下再次运行20次
            threshold=threshold+5;      %提升“阈值”5个单位
            times=times+1;
        end
    end
    %% '尝试解','报童解'接近情况图
%     figure
%     yx=(find(c_dd(rseed,:)~=0));       %c_dd中当前行中有效（yx）的列（有些列为0）
%     h1=plot(c_dd(rseed,yx),'k-o','LineWidth',1,'MarkerSize',3);
%     hold on
%     h2=plot(Distance(rseed,yx),'k:o','LineWidth',1,'MarkerSize',3);
%     grid on
%     legend([h1 h2],'订舱量','f(c)','Location','best')
%     title('迭代求解过程')
    
    C_dd(rseed)=c_dd(rseed,max(find(c_dd(rseed,:)>0))) ; %每次迭代实验的最优仓容值
    DistanceGg(rseed)=Distance(rseed,max(find(Distance(rseed,:)~=0))) ;     %得以“过关”的“C-c”
end
time_dd=toc;
    
 