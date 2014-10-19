function b_a=booking_arrivals(rseed,T,lamda)
%以参数lamda产生长度为T的possion序列
%rseed           随机种子      
%T                   随机序列的长度
%lamda          possion分布参数


rng(rseed);
b_a = poissrnd(lamda,1,T);  % b_a:  booking arrivals 订单到来的时间点
