function [ save_flag ] = savebuslinegroup(filepath, busgroupinput, linegroupinput )
%UNTITLED5 Summary of this function goes here
% �洢Ⱥbusline���ļ���,��ر�֤��׼��ʽ��δת��
%   Detailed explanation goes here
save_flag = 1;

if ischar(filepath)~=1
    disp('������ļ�·����ʽ��������������');
    return ;
end

foldername_interact_data = strcat(filepath, '/interact_data');
if exist(foldername_interact_data)==0
    mkdir(foldername_interact_data);
end


filename_buslinegroup_matlabsave = strcat(foldername_interact_data , '/buslinegroup_matlabsave.mat');

busgroup = busgroupinput';
linegroup = linegroupinput';
% save('C:\Users\hp\Documents\Visual Studio 2012\Projects\DynamicParalleltest\DynamicParalleltest\buslinegroup_matlabsave.mat',...
%     'busgroup', 'linegroup');

save(filename_buslinegroup_matlabsave, 'busgroup', 'linegroup');

save_flag = 0;
end

