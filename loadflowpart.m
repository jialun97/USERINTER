function [bus_sol,line_sol,line_flow,P_loss, Q_loss, cal_flag] = loadflowpart(bus, line, V, ang, Pg, Qg, Pl, Ql, bus_type, conv_flag )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%������·�����������׼��ʽ�����⣬�����buslineΪ��׼��ʽԴ���ݣ�V,ANG��Ϊ����������GPU��������ȡ
jay = sqrt(-1);
[nline nlc] = size(line);

bus_no = bus(:,1);
qg_max = bus(:,11);
qg_min = bus(:,12);

Gb = bus(:,8);
Bb = bus(:,9);

volt_min = bus(:,15);%��ѹ��С�����ǵ�15��Ԫ��
volt_max = bus(:,14);%��ѹ��������ǵ�14��Ԫ��

if conv_flag == 1%�����û��������ʾ������������ʧ��
   %disp('ac load flow failed to converge')
   
   bus_sol=0;
   line_sol=0;
   line_flow=0;
   P_loss = 0;
   Q_loss = 0;

else
    
    bus_sol=[bus_no  V  ang Pg Qg Pl Ql Gb Bb...�ڵ�ĳ�����
      bus_type qg_max qg_min bus(:,13) volt_max volt_min];
  
  ang2 = ang*pi/180;
  
    line_sol = line;%��������·����
   
    VV = V.*exp(jay*ang2);
    tap_index = find(abs(line(:,6))>0);%�ҳ��ֽ�ͷ��Ⱦ���ֵ>0��
    tap_ratio = ones(nline,1);%ȫ1��һ��ʸ��
    tap_ratio(tap_index)=line(tap_index,6);%�����˷ֳ�ͷ�Ķ���ԭ����ֵ��û�����õ�Ϊ1
    phase_shift(:,1) = line(:,7);%�ֳ�ͷ���
    tps = tap_ratio.*exp(jay*phase_shift*pi/180);%���д�ɸ�����ʽ
    from_bus = line(:,1);
    to_bus = line(:,2);
    
    busmax = max(bus(:,1));
bus_int = zeros(busmax,1);
nbus = length(bus(:,1));
for i = 1:nbus
  bus_int(round(bus(i,1))) = i;
end
    from_int = bus_int(round(from_bus));%�����ڵ��Ŵ��ڲ��������󣬴˱�Ŵ���ڵ���MATLAB�����еı��
    to_int = bus_int(round(to_bus));
    
    r = line(:,3);%����
    rx = line(:,4);%�翹
    chrg = line(:,5);%�����ݵ�ѹ
    z = r + jay*rx;%�迹
    y = ones(nline,1)./z;%����
    MW_s = VV(from_int).*conj((VV(from_int) - tps.*VV(to_int)).*y ...|VV|^2-��ȡ�ĩ�˵�ѹ��֧·����+��ʼ��ѹ��(�����ݵ�ѹ/2)/|���|^2
   + VV(from_int).*(jay*chrg/2))./(tps.*conj(tps));
    P_s = real(MW_s);     % ����active power sent out by from_bus to to_bus����ʼ�ڵ㷢����ע��ĩ�˽ڵ��й�
    Q_s = imag(MW_s);     % ����reactive power sent out by from_bus to to_bus����ʼ�ڵ㷢����ע��ĩ�˽ڵ���޹�
    MW_r = VV(to_int).*conj((VV(to_int) ...%**************************************************��������
   - VV(from_int)./tps).*y ...
   + VV(to_int).*(jay*chrg/2));
    P_r = real(MW_r);     % active power received by to_bus from from_busĩ�˽ڵ��յ��Ĵ���ʼ�ڵ������й�
    Q_r = imag(MW_r);     % reactive power received by to_bus from from_busĩ�˽ڵ��յ��Ĵ���ʼ�ڵ������޹�
    iline = [1:1:nline]';%���󣬴�1��nline
    
    P_loss = sum(P_s) + sum(P_r) ;%�й����
    Q_loss = sum(Q_s) + sum(Q_r) ;%�޹����

    line_flow(1:nline, :)  =[iline from_bus to_bus P_s Q_s];
    line_flow(1+nline:2*nline,:) = [iline to_bus from_bus P_r Q_r];%��·�ĳ�����
    
end

cal_flag=conv_flag;




end

