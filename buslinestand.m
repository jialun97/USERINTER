function [ bus, line ] = buslinestand( bussource, linesource )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%  BUS LINE转为标准格式，用户可利用此程序将busline标准化

% bus:1.number  2.voltage_magnitude 3.voltage_angle 4.p_gen 5.q_gen 6.p_load 7.q_load 8.G 9.B 10.bus_type 
%    11.q_gen_max 12.q_gen_min 13.v_rated 14.v_max 15.v_min

% line:1.from_bus 2.to_bus 3.r 4.x 5.b 6.tap_ratio 7.tap_phase 8.tap_max 9.tap_min 10.tap_size

bus = bussource;
line = linesource;

[nline nlc] = size(linesource);    % number of lines and no of line colsb把线路矩阵的行数和列数赋给nline和nlc
[nbus ncol] = size(bussource);     % number of buses and number of col把节点矩阵的行数和列数赋给nbus和ncol

if ncol<15 
   % set generator var limits设置发电机无功的限制
   if ncol<12 %如果列数小于12，把矩阵bus第11列的元素赋值为一个nbus*1的全1阵元素*9999
                              %把12列的元素赋值为nbus*1的全1阵元素*-9999
                              
      bus(:,11) = 9999*ones(nbus,1);%即：把11、12列的元素都赋为9999和-9999（11列是最大无功，12列是最小无功，无功的上下限）
      bus(:,12) = -9999*ones(nbus,1);
   end 
  if ncol<13;bus(:,13) = ones(nbus,1);end
   %如果节点矩阵列数小于13，bus第13列元素为1（13列是额定电压）
   bus(:,14) = 1.5*ones(nbus,1);%bus第14列元素为1.5（最大电压标幺值）
   bus(:,15) = 0.5*ones(nbus,1);%bus第15列元素为0.5（最小电压标幺值）
   volt_min = bus(:,15);%电压的最小限制是bus矩阵的15列元素
   volt_max = bus(:,14);%电压的最大限制是bus矩阵的14列元素
else
   volt_min = bus(:,15);%电压最小限制是第15列元素
   volt_max = bus(:,14);%电压最大限制是第14列元素
end



%如果bus矩阵是完整的，但有些节点的数据没有设置，设置这些数据
no_vmin_idx = find(volt_min==0);% 查找最小电压限制为零的母线号码对应的列数
if ~isempty(no_vmin_idx)%如果找到这个位置
   volt_min(no_vmin_idx) = 0.5*ones(length(no_vmin_idx),1);%这个位置的元素赋为0.5
end
no_vmax_idx = find(volt_max==0);%最大电压的默认值是1.5
if ~isempty(no_vmax_idx)
   volt_max(no_vmax_idx) = 1.5*ones(length(no_vmax_idx),1);
end
no_mxv = find(bus(:,11)==0);%找11列元素为0的位置
no_mnv = find(bus(:,12)==0);%找12列元素为0的位置
if ~isempty(no_mxv);  bus(no_mxv,11)=9999*ones(length(no_mxv),1);end %最大无功的默认值是9999,列矩阵
if ~isempty(no_mnv);bus(no_mnv,12) = -9999*ones(length(no_mnv),1);end%最小无功的默认值-9999，列矩阵

no_vrate = find(bus(:,13)==0);%查找额定电压为零的列
if ~isempty(no_vrate);bus(no_vrate,13) = ones(length(no_vrate),1);end%额定电压的默认值1

no_taps = 0;
% line data defaults, sets all tap ranges to zero - this fixes taps设置线路默认数据
if nlc < 10%如果线路矩阵的列数小于10
   line(:,7:10) = zeros(nline,4);%将line的7到10列的所有元素赋为0
   no_taps = 1;  % disable tap changing不考虑分接头的影响,如果程序没有给出分接头调整，则无需调整
 
end

end

