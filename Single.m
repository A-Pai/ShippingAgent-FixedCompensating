%此程序研究多期下只收单一价格货物（当天发送，推迟到第二天则提供赔偿）的最优仓容问题---总量
%遍历法确定最优仓容，迭代法的解与之比较，表明迭代法可行
%试验最优值的稳定性--不同的随机种子
%固定歩距法

clc
clear
close all

%% 参数设置
sj=100;     %产生随机数的次数
n=100;    %观测多少天
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
P=Cu/(Cu+Co);            %报童问题的服务水平

%% 遍历法和迭代法得到最优仓容
for rseed=1:sj    %不同的随机种子下试验--数据不同
    rng(rseed);      % 设置随机种子
    d= lognrnd(m,v,1,n);      %生成到货的货物总重量序列-当前随机种子下的
    for cr=1:cs                %cr-仓容，cs-循环的次数
        B0=0;
        for ts=1:n-1               %ts--观察的第几天数   n-共多少天
            if (d(ts)+B0)<c(cr)
                revenue(cr,ts)=d(ts)*rate-c(cr)*fare;   %这个收益是实质的，承运所得(以接货时刻为准--接货时收钱）-仓容开支
                Lf(cr,ts)=d(ts)/c(cr);                            %满载系数
                B0=0;                                                    %遗留到第二天的货物量为0
                D(rseed,cr,ts)=d(ts+1);                  %D：第二天的承运量
            else
                B0=d(ts)+B0-c(cr);                        %%遗留到第二天的货物量为：前一天的到货量+遗留到前一天的货物量-当前的仓容
                revenue(cr,ts)=d(ts)*rate-B0*p-c(cr)*fare;
                Lf(cr,ts)=1;                                           %满载系数为1
                D(rseed,cr,ts)=d(ts+1)+B0;            %D：第二天的承运量
                if d(ts)>c(cr)
                    yc(cr,ts)=1;           %yc--延迟，如果当天的到货大于仓容，则当天会存在延迟发送
                else
                    yc(cr,ts)=0;
                end
            end
            if mod(ts,20)==0&mod(cr,10)==0
                fprintf('试验，当前是第%d-%d-%d次，共%d-%d-%d次\n', ts,cr,rseed,n,cs,sj)
            end
        end
        revenue_m(rseed,cr)=mean(revenue(cr,:));                   %当前仓容量下的多期收益的平均值
        C(rseed,cr)=prctile(reshape(D(rseed,cr,:),1,[]),P*100);  %由“第二天承运量”概率分布得到的最优仓容
    end
end

[hhh,id1]=min(abs(repmat(c,sj,1)-C),[],2);              %id1--迭代解，每行（不同的数据下）中试验仓容和求取的最优仓容相同的位置
[revenue_m_max,id2]=max(revenue_m,[],2);       %id2--遍历解，找到sj次随机产生数据的最大仓容值和位置

%% 比较迭代法的仓容与遍历法的仓容
figure
h1=plot(c(id1),'k-o','LineWidth',1,'MarkerSize',3);
hold on
h2=plot(c(id2),'r-o','LineWidth',1,'MarkerSize',3);
h=plot(c(id1)-c(id2),'k-o','LineWidth',1,'MarkerSize',3);
legend([h1 h2 h],'迭代法','遍历法','迭----遍','Location','best')
title('经验数据上的遍历解和迭代解-最优订舱值')
grid on

figure
boxplot([(c(id1))', (c(id2))'])
title('经验数据上的遍历解和迭代解-最优订舱值')

c_opti1=mean(c(id1));    %迭代解
c_opti2=mean(c(id2));   %遍历解

%% 收益随仓容变化曲线

figure
plot(c,revenue_m','LineWidth',1);
grid on
xlabel('仓容');
ylabel('平均收益');
title('平均收益随仓容变化曲线')

%% 验证迭代法解的优良性，采用新的数据
%验证sj次数
for rseed=1:sj   %不同的随机种子下试验
    rng(rseed+sj);      % 设置随机种子，“+sj”的目的是与上一部分的数据不同
    d= lognrnd(m,v,1,n);      %生成当天的货物总重量
    B0_1=0;                      %迭代解遗留到第二天的货物量
    B0_2=0;                      %遍历解遗留到第二天的货物量
    revenue_test1=[];
    revenue_test2=[];
    for ts=1:n-1               %ts--观察的第几天数   n-共多少天
        %迭代解
        if (d(ts)+B0_1)<c_opti1
            B0_1=0;                                                    %遗留到第二天的货物量为0
            revenue_test1(ts)=d(ts)*rate-c_opti1*fare;   %这个收益是实质的，承运所得(以接货时刻为准--接货时收钱）-仓容开支
            Lf(cr,ts)=d(ts)/c_opti1;                            %满载系数
        else
            B0_1=d(ts)+B0_1-c_opti1;                        %%遗留到第二天的货物量为：前一天的到货量+遗留到前一天的货物量-当前的仓容
            revenue_test1(ts)=d(ts)*rate-B0_1*p-c_opti1*fare;
            Lf(cr,ts)=1;                                           %满载系数为1
        end
        %遍历解
        if (d(ts)+B0_2)<c_opti2
            B0_2=0;                                                    %遗留到第二天的货物量为0
            revenue_test2(ts)=d(ts)*rate-c_opti2*fare;   %这个收益是实质的，承运所得(以接货时刻为准--接货时收钱）-仓容开支
            Lf(cr,ts)=d(ts)/c_opti2;                            %满载系数
        else
            B0_2=d(ts)+B0_2-c_opti2;                        %%遗留到第二天的货物量为：前一天的到货量+遗留到前一天的货物量-当前的仓容
            revenue_test2(ts)=d(ts)*rate-B0_2*p-c_opti2*fare;
            Lf(cr,ts)=1;                                           %满载系数为1
        end
        if mod(ts,20)==0
            fprintf('试验，当前是第%d-%d次，共%d-%d次\n', ts,rseed-sj,n,sj)
        end
    end
    revenue_m_test1(rseed)=mean(revenue_test1);                   %迭代解的多期收益的平均值
    revenue_m_test2(rseed)=mean(revenue_test2);                   %遍历解的多期收益的平均值
    
end
ratio=(revenue_m_test1-revenue_m_test2)./revenue_m_test1;

figure
h1=plot(revenue_m_test1,'k-o','LineWidth',1,'MarkerSize',3);
hold on
h2=plot(revenue_m_test2,'k:o','LineWidth',1,'MarkerSize',3);
h3=plot(revenue_m_max,'r-o','LineWidth',1,'MarkerSize',3);
h=plot(revenue_m_test1-revenue_m_test2,'k--o','LineWidth',1,'MarkerSize',3);
legend([h1 h2 h h3],'迭代解','遍历解','迭---遍','训练解','Location','best')
title('遍历解和迭代解在新数据平均收益')
grid on

figure
hist(revenue_m_test1'- revenue_m_test2',20)
title('验证数据上的遍历解和迭代解的收益差')

fprintf('迭代法的最优仓容平均为：%.0f，标准差为：%.0f，%.0f期的平均收益为：%.0f\n', c_opti1,std(c(id1)),n,mean(revenue_m_test1))
fprintf('遍历法的最优仓容平均为：%.0f，标准差为：%.0f，%.0f期的平均收益为：%.0f\n', c_opti2,std(c(id2)),n,mean(revenue_m_test2))
