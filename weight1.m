function w=weight(rseed,m,v)
%以参数m,v产生长度为T的货物重量序列，m，v其实是对应的正态分布的均值和方差
%rseed           随机种子 
%m，v           其实是对应的正态分布的均值和方差  参见 doc lognrnd
%T                   随机序列的长度

rng(rseed);      %rseed+300是为了不和booking_arrivals、rate等相关
mu = log((m^2)/sqrt(v+m^2));
sigma = sqrt(log(v/(m^2)+1));
w = lognrnd(mu,sigma);      %生成对应的对数正态分布的随机数
% 画出概率密度
% [f,xi] = ksdensity(w); 
% plot(xi,f);