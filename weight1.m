function w=weight(rseed,m,v)
%�Բ���m,v��������ΪT�Ļ����������У�m��v��ʵ�Ƕ�Ӧ����̬�ֲ��ľ�ֵ�ͷ���
%rseed           ������� 
%m��v           ��ʵ�Ƕ�Ӧ����̬�ֲ��ľ�ֵ�ͷ���  �μ� doc lognrnd
%T                   ������еĳ���

rng(rseed);      %rseed+300��Ϊ�˲���booking_arrivals��rate�����
mu = log((m^2)/sqrt(v+m^2));
sigma = sqrt(log(v/(m^2)+1));
w = lognrnd(mu,sigma);      %���ɶ�Ӧ�Ķ�����̬�ֲ��������
% ���������ܶ�
% [f,xi] = ksdensity(w); 
% plot(xi,f);