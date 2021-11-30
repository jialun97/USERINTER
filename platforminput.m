function [ inputflag ] = platforminput(filepath, generation_iter,...
    mbus, mline, num_pop, generationmax,  NRitermax, NRprecision, ...
    busgroup, linegroup)

inputflag = 1;

if ischar(filepath)~=1
    disp('输入的文件路径格式有误，请重新输入');
    return ;
end
foldername_interact_flag = strcat(filepath, '/interact_flag');
if exist(foldername_interact_flag)==0
    mkdir(foldername_interact_flag);
end

handfilename_allflag = strcat(foldername_interact_flag,'/allflag.txt');
handfilename_matflag = strcat(foldername_interact_flag,'/matflag.txt');
handfilename_vsflag = strcat(foldername_interact_flag, '/vsflag.txt');


if generation_iter==1
    save_flag = savegroupinfo(filepath, mbus, mline, num_pop, generationmax,  NRitermax, NRprecision);
    if save_flag == 1
        disp('存储种群信息出错');
        return;
    end
end

save_flag = savebuslinegroup(filepath, busgroup, linegroup);
if save_flag == 1
   disp('存储电力系统信息出错');
   return;
end

%文件总标志位
if generation_iter == 1
    fid = fopen(handfilename_allflag, 'w');
    fprintf(fid, '%d', 0);
    fclose(fid);
end

%mat用户侧标志位
fid = fopen(handfilename_matflag,'w');
fprintf(fid, '%d', 0);
fclose(fid);

%vs服务器侧标志位
fid = fopen(handfilename_vsflag,'w');
fprintf(fid, '%d', 1);
fclose(fid);

inputflag = 0;

end