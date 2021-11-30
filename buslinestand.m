function [ bus, line ] = buslinestand( bussource, linesource )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%  BUS LINEתΪ��׼��ʽ���û������ô˳���busline��׼��

% bus:1.number  2.voltage_magnitude 3.voltage_angle 4.p_gen 5.q_gen 6.p_load 7.q_load 8.G 9.B 10.bus_type 
%    11.q_gen_max 12.q_gen_min 13.v_rated 14.v_max 15.v_min

% line:1.from_bus 2.to_bus 3.r 4.x 5.b 6.tap_ratio 7.tap_phase 8.tap_max 9.tap_min 10.tap_size

bus = bussource;
line = linesource;

[nline nlc] = size(linesource);    % number of lines and no of line colsb����·�������������������nline��nlc
[nbus ncol] = size(bussource);     % number of buses and number of col�ѽڵ�������������������nbus��ncol

if ncol<15 
   % set generator var limits���÷�����޹�������
   if ncol<12 %�������С��12���Ѿ���bus��11�е�Ԫ�ظ�ֵΪһ��nbus*1��ȫ1��Ԫ��*9999
                              %��12�е�Ԫ�ظ�ֵΪnbus*1��ȫ1��Ԫ��*-9999
                              
      bus(:,11) = 9999*ones(nbus,1);%������11��12�е�Ԫ�ض���Ϊ9999��-9999��11��������޹���12������С�޹����޹��������ޣ�
      bus(:,12) = -9999*ones(nbus,1);
   end 
  if ncol<13;bus(:,13) = ones(nbus,1);end
   %����ڵ��������С��13��bus��13��Ԫ��Ϊ1��13���Ƕ��ѹ��
   bus(:,14) = 1.5*ones(nbus,1);%bus��14��Ԫ��Ϊ1.5������ѹ����ֵ��
   bus(:,15) = 0.5*ones(nbus,1);%bus��15��Ԫ��Ϊ0.5����С��ѹ����ֵ��
   volt_min = bus(:,15);%��ѹ����С������bus�����15��Ԫ��
   volt_max = bus(:,14);%��ѹ�����������bus�����14��Ԫ��
else
   volt_min = bus(:,15);%��ѹ��С�����ǵ�15��Ԫ��
   volt_max = bus(:,14);%��ѹ��������ǵ�14��Ԫ��
end



%���bus�����������ģ�����Щ�ڵ������û�����ã�������Щ����
no_vmin_idx = find(volt_min==0);% ������С��ѹ����Ϊ���ĸ�ߺ����Ӧ������
if ~isempty(no_vmin_idx)%����ҵ����λ��
   volt_min(no_vmin_idx) = 0.5*ones(length(no_vmin_idx),1);%���λ�õ�Ԫ�ظ�Ϊ0.5
end
no_vmax_idx = find(volt_max==0);%����ѹ��Ĭ��ֵ��1.5
if ~isempty(no_vmax_idx)
   volt_max(no_vmax_idx) = 1.5*ones(length(no_vmax_idx),1);
end
no_mxv = find(bus(:,11)==0);%��11��Ԫ��Ϊ0��λ��
no_mnv = find(bus(:,12)==0);%��12��Ԫ��Ϊ0��λ��
if ~isempty(no_mxv);  bus(no_mxv,11)=9999*ones(length(no_mxv),1);end %����޹���Ĭ��ֵ��9999,�о���
if ~isempty(no_mnv);bus(no_mnv,12) = -9999*ones(length(no_mnv),1);end%��С�޹���Ĭ��ֵ-9999���о���

no_vrate = find(bus(:,13)==0);%���Ҷ��ѹΪ�����
if ~isempty(no_vrate);bus(no_vrate,13) = ones(length(no_vrate),1);end%���ѹ��Ĭ��ֵ1

no_taps = 0;
% line data defaults, sets all tap ranges to zero - this fixes taps������·Ĭ������
if nlc < 10%�����·���������С��10
   line(:,7:10) = zeros(nline,4);%��line��7��10�е�����Ԫ�ظ�Ϊ0
   no_taps = 1;  % disable tap changing�����Ƿֽ�ͷ��Ӱ��,�������û�и����ֽ�ͷ���������������
 
end

end

