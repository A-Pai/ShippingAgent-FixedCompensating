function b_a=booking_arrivals(rseed,T,lamda)
%�Բ���lamda��������ΪT��possion����
%rseed           �������      
%T                   ������еĳ���
%lamda          possion�ֲ�����


rng(rseed);
b_a = poissrnd(lamda,1,T);  % b_a:  booking arrivals ����������ʱ���
