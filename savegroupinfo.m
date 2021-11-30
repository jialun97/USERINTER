function [ save_flag ] = savegroupinfo(filepath, mbus, mline, num_pop, generationmax,  NRitermax, NRprecision )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% 节点数 线路数 种群个体数 种群代数 牛拉法迭代上限 牛拉法迭代精度

save_flag = 1;
% save('C:\Users\hp\Documents\Visual Studio 2012\Projects\DynamicParalleltest\DynamicParalleltest\groupbasicinfo_matlabsave.mat',...
%     'mbus', 'mline', 'num_pop',  'NRitermax', 'NRprecision', 'generationmax');

if ischar(filepath)~=1
    disp('输入的文件路径格式有误，请重新输入');
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

