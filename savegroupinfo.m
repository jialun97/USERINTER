function [ save_flag ] = savegroupinfo(filepath, mbus, mline, num_pop, generationmax,  NRitermax, NRprecision )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% �ڵ��� ��·�� ��Ⱥ������ ��Ⱥ���� ţ������������ ţ������������

save_flag = 1;
% save('C:\Users\hp\Documents\Visual Studio 2012\Projects\DynamicParalleltest\DynamicParalleltest\groupbasicinfo_matlabsave.mat',...
%     'mbus', 'mline', 'num_pop',  'NRitermax', 'NRprecision', 'generationmax');

if ischar(filepath)~=1
    disp('������ļ�·����ʽ��������������');
    return ;
end

foldername_interact_data = strcat(filepath, '/interact_data');
if exist(foldername_interact_data)==0
    mkdir(foldername_interact_data);
end

filename_groupbasicinfo_matlabsave = strcat(foldername_interact_data , '/groupbasicinfo_matlabsave.mat');

save(filename_groupbasicinfo_matlabsave, 'mbus', 'mline','num_pop', 'NRitermax', 'NRprecision', 'generationmax');

save_flag = 0;

end

