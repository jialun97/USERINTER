function [ inputflag ] = platforminput(filepath, generation_iter,...
    mbus, mline, num_pop, generationmax,  NRitermax, NRprecision, ...
    busgroup, linegroup)

inputflag = 1;

if ischar(filepath)~=1
    disp('������ļ�·����ʽ��������������');
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
        disp('�洢��Ⱥ��Ϣ����');
        return;
    end
end

save_flag = savebuslinegroup(filepath, busgroup, linegroup);
if save_flag == 1
   disp('�洢����ϵͳ��Ϣ����');
   return;
end

%�ļ��ܱ�־λ
if generation_iter == 1
    fid = fopen(handfilename_allflag, 'w');
    fprintf(fid, '%d', 0);
    fclose(fid);
end

%mat�û����־λ
fid = fopen(handfilename_matflag,'w');
fprintf(fid, '%d', 0);
fclose(fid);

%vs���������־λ
fid = fopen(handfilename_vsflag,'w');
fprintf(fid, '%d', 1);
fclose(fid);

inputflag = 0;

end