function Answer= revenue_cyl(c,d)
fare=0.6;   %���ݵ�λ�۸�
p=0.2;      %ÿ�Ӻ�һ�죬�⳥p
rate=1;       %�˼�

n=length(d);
B(1)=0;
for ts=1:n-1               %ts--�۲�ĵڼ�����   n-��������
    if (d(ts)+B(ts))<c
        B(ts+1)=0;                                                    %�������ڶ���Ļ�����Ϊ0
    else
        B(ts+1)=d(ts)+B(ts)-c;           %%�������ڶ���Ļ�����Ϊ��ǰһ��ĵ�����+������ǰһ��Ļ�����-��ǰ�Ĳ���
    end
end
D=d+B;
for ts=1:n
    if D(ts)<c
%         revenue(ts)=d(ts)*rate-c*fare;
        revenue(ts)=D(ts)*rate-c*fare;
    else
         revenue(ts)=c*(rate-fare)-(D(ts)-c)*p;
  %     revenue(ts)=d(ts)*rate-c*fare-(D(ts)-c)*p;
    end
end
%Answer=revenue;
Answer=mean(revenue);
