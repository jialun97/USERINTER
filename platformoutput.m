function [ outputflag, bus_solgroup,line_solgroup, line_flowgroup, P_lossgroup, Q_lossgroup, cal_flaggroup ] =...
    platformoutput(filepath, mbus, mline, num_pop, busgroup, linegroup)

outputflag = 1;

if ischar(filepath)~=1
    disp('输入的文件路径格式有误，请重新输入');
    return ;
end

foldername_interact_flag = strcat(filepath, '/interact_flag');
if exist(foldername_interact_flag)==0
    mkdir(foldername_interact_flag);
end
foldername_interact_data = strcat(filepath, '/interact_data');
if exist(foldername_interact_data)==0
    mkdir(foldername_interact_data);
end

handfilename_vsflag = strcat(foldername_interact_flag, '/vsflag.txt');
filename_buslinegroup_vssave = strcat(foldername_interact_data, '/buslinegroup_vssave.mat');

%% 等待VS端计算完成
  vs_flag = 1;
 while (vs_flag==1)
 fid = fopen(handfilename_vsflag,'r');
 [vs_flag, ~] = fscanf(fid, '%f', 1);
 fclose(fid);
 end

 %% 读取VS端数据
load(filename_buslinegroup_vssave);

%% 初始化输出变量
bus_solgroup = zeros(mbus*num_pop, 15);
line_solgroup = zeros(mline*num_pop, 10);
line_flowgroup = zeros(2*mline*num_pop, 5);
P_lossgroup = zeros(num_pop, 1);
Q_lossgroup = zeros(num_pop, 1);
cal_flaggroup = zeros(num_pop, 1);

%% 计算每个个体的潮流结果并存储到群体潮流解变量中
for j=1:num_pop
   

        Pgenout = Pgengroup(j,:)';
        Ploadout = Ploadgroup(j,:)';
        Qgenout = Qgengroup(j,:)';
        Qloadout = Qloadgroup(j,:)';
        bustypeout = bustypegroup(j,:)';
        convflagout = convflaggroup(j)';
        Uout = Ugroup(j,:)';
        deltaout = deltagroup(j,:)';
        
        bus = busgroup( (j-1)*mbus+1 : j*mbus, : );
        line = linegroup( (j-1)*mline+1 : j*mline, : );

       [bus_sol,line_sol,line_flow, P_loss, Q_loss, cal_flag] =...
    loadflowpart(bus, line, Uout, deltaout, Pgenout, Qgenout, Ploadout, Qloadout, bustypeout, convflagout );

    bus_solgroup( (j-1)*mbus+1 : j*mbus, : ) = bus_sol;
    line_solgroup( (j-1)*mline+1: j*mline, : ) = line_sol;
    line_flowgroup( (j-1)*2*mline+1 : j*2*mline, : ) = line_flow;
    
    P_lossgroup(j,1) = P_loss;
    Q_lossgroup(j,1) = Q_loss;
    cal_flaggroup(j,1) = cal_flag;

outputflag = 0;
end