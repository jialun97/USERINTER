function [bus_sol,line_sol,line_flow,P_loss, Q_loss, cal_flag] = loadflowpart(bus, line, V, ang, Pg, Qg, Pl, Ql, bus_type, conv_flag )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%计算线路潮流并输出标准格式潮流解，输入的busline为标准格式源数据，V,ANG等为列向量，从GPU计算结果读取
jay = sqrt(-1);
[nline nlc] = size(line);

bus_no = bus(:,1);
qg_max = bus(:,11);
qg_min = bus(:,12);

Gb = bus(:,8);
Bb = bus(:,9);

volt_min = bus(:,15);%电压最小限制是第15列元素
volt_max = bus(:,14);%电压最大限制是第14列元素

if conv_flag == 1%如果还没收敛，显示交流潮流收敛失败
   %disp('ac load flow failed to converge')
   
   bus_sol=0;
   line_sol=0;
   line_flow=0;
   P_loss = 0;
   Q_loss = 0;

else
    
    bus_sol=[bus_no  V  ang Pg Qg Pl Ql Gb Bb...节点的潮流解
      bus_type qg_max qg_min bus(:,13) volt_max volt_min];
  
  ang2 = ang*pi/180;
  
    line_sol = line;%修正的线路矩阵
   
    VV = V.*exp(jay*ang2);
    tap_index = find(abs(line(:,6))>0);%找出分接头变比绝对值>0的
    tap_ratio = ones(nline,1);%全1阵，一列矢量
    tap_ratio(tap_index)=line(tap_index,6);%设置了分抽头的都按原来的值，没有设置的为1
    phase_shift(:,1) = line(:,7);%分抽头相角
    tps = tap_ratio.*exp(jay*phase_shift*pi/180);%变比写成复数形式
    from_bus = line(:,1);
    to_bus = line(:,2);
    
    busmax = max(bus(:,1));
bus_int = zeros(busmax,1);
nbus = length(bus(:,1));
for i = 1:nbus
  bus_int(round(bus(i,1))) = i;
end
    from_int = bus_int(round(from_bus));%电力节点编号存在不连续现象，此编号代表节点在MATLAB矩阵中的编号
    to_int = bus_int(round(to_bus));
    
    r = line(:,3);%电阻
    rx = line(:,4);%电抗
    chrg = line(:,5);%充电电容电压
    z = r + jay*rx;%阻抗
    y = ones(nline,1)./z;%导纳
    MW_s = VV(from_int).*conj((VV(from_int) - tps.*VV(to_int)).*y ...|VV|^2-变比×末端电压×支路导纳+起始电压×(充电电容电压/2)/|变比|^2
   + VV(from_int).*(jay*chrg/2))./(tps.*conj(tps));
    P_s = real(MW_s);     % ！！active power sent out by from_bus to to_bus从起始节点发出的注入末端节点有功
    Q_s = imag(MW_s);     % ！！reactive power sent out by from_bus to to_bus从起始节点发出的注入末端节点的无功
    MW_r = VV(to_int).*conj((VV(to_int) ...%**************************************************？？？？
   - VV(from_int)./tps).*y ...
   + VV(to_int).*(jay*chrg/2));
    P_r = real(MW_r);     % active power received by to_bus from from_bus末端节点收到的从起始节点来的有功
    Q_r = imag(MW_r);     % reactive power received by to_bus from from_bus末端节点收到的从起始节点来的无功
    iline = [1:1:nline]';%列阵，从1到nline
    
    P_loss = sum(P_s) + sum(P_r) ;%有功损耗
    Q_loss = sum(Q_s) + sum(Q_r) ;%无功损耗

    line_flow(1:nline, :)  =[iline from_bus to_bus P_s Q_s];
    line_flow(1+nline:2*nline,:) = [iline to_bus from_bus P_r Q_r];%线路的潮流解
    
end

cal_flag=conv_flag;




end

