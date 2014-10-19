%�˳����о�������ֻ�յ�һ�۸������췢�ͣ��Ƴٵ��ڶ������ṩ�⳥�������Ų�������---����
%������ȷ�����Ų��ݣ��������Ľ���֮�Ƚϣ���������������
%��������ֵ���ȶ���--��ͬ���������
%�̶��i�෨

clc
clear
close all

%% ��������
sj=100;     %����������Ĵ���
n=100;    %�۲������
rate=1;       %�˼�
fare=0.6;   %���ݵ�λ�۸�
p=0.2;      %ÿ�Ӻ�һ�죬�⳥p
D1=0.2E4;     %������ݵ����ֵ
D2=10.2E4;     %������ݵ����ֵ,D1��D2��ȡֵ�Ǹ��ݵ����ķֲ�
Gap=1000;         %����ÿ�ε����ֵ
cs=(D2-D1)/Gap;    %����Ĵ���cs
c=D1+Gap:Gap:D2; %����Ĳ������У�������Ĵ�����Ӧ
m=10;v=0.5;           %ÿ�쵽������������lognrnd��������ֵ�ͷ����ʵ�Ƕ��ڵ���̬�ֱ�ģ�
Co=fare;                      %��������ĳɱ�
Cu=rate-fare+p;          %����Ӧ��ĳɱ�
P=Cu/(Cu+Co);            %��ͯ����ķ���ˮƽ

%% �������͵������õ����Ų���
for rseed=1:sj    %��ͬ���������������--���ݲ�ͬ
    rng(rseed);      % �����������
    d= lognrnd(m,v,1,n);      %���ɵ����Ļ�������������-��ǰ��������µ�
    for cr=1:cs                %cr-���ݣ�cs-ѭ���Ĵ���
        B0=0;
        for ts=1:n-1               %ts--�۲�ĵڼ�����   n-��������
            if (d(ts)+B0)<c(cr)
                revenue(cr,ts)=d(ts)*rate-c(cr)*fare;   %���������ʵ�ʵģ���������(�Խӻ�ʱ��Ϊ׼--�ӻ�ʱ��Ǯ��-���ݿ�֧
                Lf(cr,ts)=d(ts)/c(cr);                            %����ϵ��
                B0=0;                                                    %�������ڶ���Ļ�����Ϊ0
                D(rseed,cr,ts)=d(ts+1);                  %D���ڶ���ĳ�����
            else
                B0=d(ts)+B0-c(cr);                        %%�������ڶ���Ļ�����Ϊ��ǰһ��ĵ�����+������ǰһ��Ļ�����-��ǰ�Ĳ���
                revenue(cr,ts)=d(ts)*rate-B0*p-c(cr)*fare;
                Lf(cr,ts)=1;                                           %����ϵ��Ϊ1
                D(rseed,cr,ts)=d(ts+1)+B0;            %D���ڶ���ĳ�����
                if d(ts)>c(cr)
                    yc(cr,ts)=1;           %yc--�ӳ٣��������ĵ������ڲ��ݣ����������ӳٷ���
                else
                    yc(cr,ts)=0;
                end
            end
            if mod(ts,20)==0&mod(cr,10)==0
                fprintf('���飬��ǰ�ǵ�%d-%d-%d�Σ���%d-%d-%d��\n', ts,cr,rseed,n,cs,sj)
            end
        end
        revenue_m(rseed,cr)=mean(revenue(cr,:));                   %��ǰ�������µĶ��������ƽ��ֵ
        C(rseed,cr)=prctile(reshape(D(rseed,cr,:),1,[]),P*100);  %�ɡ��ڶ�������������ʷֲ��õ������Ų���
    end
end

[hhh,id1]=min(abs(repmat(c,sj,1)-C),[],2);              %id1--�����⣬ÿ�У���ͬ�������£���������ݺ���ȡ�����Ų�����ͬ��λ��
[revenue_m_max,id2]=max(revenue_m,[],2);       %id2--�����⣬�ҵ�sj������������ݵ�������ֵ��λ��

%% �Ƚϵ������Ĳ�����������Ĳ���
figure
h1=plot(c(id1),'k-o','LineWidth',1,'MarkerSize',3);
hold on
h2=plot(c(id2),'r-o','LineWidth',1,'MarkerSize',3);
h=plot(c(id1)-c(id2),'k-o','LineWidth',1,'MarkerSize',3);
legend([h1 h2 h],'������','������','��----��','Location','best')
title('���������ϵı�����͵�����-���Ŷ���ֵ')
grid on

figure
boxplot([(c(id1))', (c(id2))'])
title('���������ϵı�����͵�����-���Ŷ���ֵ')

c_opti1=mean(c(id1));    %������
c_opti2=mean(c(id2));   %������

%% ��������ݱ仯����

figure
plot(c,revenue_m','LineWidth',1);
grid on
xlabel('����');
ylabel('ƽ������');
title('ƽ����������ݱ仯����')

%% ��֤��������������ԣ������µ�����
%��֤sj����
for rseed=1:sj   %��ͬ���������������
    rng(rseed+sj);      % ����������ӣ���+sj����Ŀ��������һ���ֵ����ݲ�ͬ
    d= lognrnd(m,v,1,n);      %���ɵ���Ļ���������
    B0_1=0;                      %�������������ڶ���Ļ�����
    B0_2=0;                      %�������������ڶ���Ļ�����
    revenue_test1=[];
    revenue_test2=[];
    for ts=1:n-1               %ts--�۲�ĵڼ�����   n-��������
        %������
        if (d(ts)+B0_1)<c_opti1
            B0_1=0;                                                    %�������ڶ���Ļ�����Ϊ0
            revenue_test1(ts)=d(ts)*rate-c_opti1*fare;   %���������ʵ�ʵģ���������(�Խӻ�ʱ��Ϊ׼--�ӻ�ʱ��Ǯ��-���ݿ�֧
            Lf(cr,ts)=d(ts)/c_opti1;                            %����ϵ��
        else
            B0_1=d(ts)+B0_1-c_opti1;                        %%�������ڶ���Ļ�����Ϊ��ǰһ��ĵ�����+������ǰһ��Ļ�����-��ǰ�Ĳ���
            revenue_test1(ts)=d(ts)*rate-B0_1*p-c_opti1*fare;
            Lf(cr,ts)=1;                                           %����ϵ��Ϊ1
        end
        %������
        if (d(ts)+B0_2)<c_opti2
            B0_2=0;                                                    %�������ڶ���Ļ�����Ϊ0
            revenue_test2(ts)=d(ts)*rate-c_opti2*fare;   %���������ʵ�ʵģ���������(�Խӻ�ʱ��Ϊ׼--�ӻ�ʱ��Ǯ��-���ݿ�֧
            Lf(cr,ts)=d(ts)/c_opti2;                            %����ϵ��
        else
            B0_2=d(ts)+B0_2-c_opti2;                        %%�������ڶ���Ļ�����Ϊ��ǰһ��ĵ�����+������ǰһ��Ļ�����-��ǰ�Ĳ���
            revenue_test2(ts)=d(ts)*rate-B0_2*p-c_opti2*fare;
            Lf(cr,ts)=1;                                           %����ϵ��Ϊ1
        end
        if mod(ts,20)==0
            fprintf('���飬��ǰ�ǵ�%d-%d�Σ���%d-%d��\n', ts,rseed-sj,n,sj)
        end
    end
    revenue_m_test1(rseed)=mean(revenue_test1);                   %������Ķ��������ƽ��ֵ
    revenue_m_test2(rseed)=mean(revenue_test2);                   %������Ķ��������ƽ��ֵ
    
end
ratio=(revenue_m_test1-revenue_m_test2)./revenue_m_test1;

figure
h1=plot(revenue_m_test1,'k-o','LineWidth',1,'MarkerSize',3);
hold on
h2=plot(revenue_m_test2,'k:o','LineWidth',1,'MarkerSize',3);
h3=plot(revenue_m_max,'r-o','LineWidth',1,'MarkerSize',3);
h=plot(revenue_m_test1-revenue_m_test2,'k--o','LineWidth',1,'MarkerSize',3);
legend([h1 h2 h h3],'������','������','��---��','ѵ����','Location','best')
title('������͵�������������ƽ������')
grid on

figure
hist(revenue_m_test1'- revenue_m_test2',20)
title('��֤�����ϵı�����͵�����������')

fprintf('�����������Ų���ƽ��Ϊ��%.0f����׼��Ϊ��%.0f��%.0f�ڵ�ƽ������Ϊ��%.0f\n', c_opti1,std(c(id1)),n,mean(revenue_m_test1))
fprintf('�����������Ų���ƽ��Ϊ��%.0f����׼��Ϊ��%.0f��%.0f�ڵ�ƽ������Ϊ��%.0f\n', c_opti2,std(c(id2)),n,mean(revenue_m_test2))
