%本程序为解决“运筹学-熊伟版”的例子10.10
clc
clear
close all

C=0.35;     %进价   /份
P=0.5;       %售价   /份
S=0.1;       %回收价   /份
Co=C-S;    %供过于求的损失   /份
Cu=P-C;    %供不应求的损失   /份
SL=Cu/(Cu+Co);      %最优服务水平
xql=[60	100	140	170	190	210	230	240];    %需求量
ts=[20	50	60	70	80	100	70	50];            %出现以上需求量的天数
cf=[];            %cf--历史上每天的需求
for k=1:length(ts)
    cf=[cf,repmat(xql(k),1,ts(k))];
end
fprintf('报童最佳订报纸的份数为：%.0f\n', prctile(cf,SL*100))
