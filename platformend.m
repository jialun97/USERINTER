function [ termiflag] =    platformend(filepath)


termiflag = 1;
if ischar(filepath)~=1
    disp('������ļ�·����ʽ��������������');
    return ;
end

foldername_interact_flag = strcat(filepath, '/interact_flag');
if exist(foldername_interact_flag)==0
    mkdir(foldername_interact_flag);
end

handfilename_matflag = strcat(foldername_interact_flag, '/matflag.txt');
handfilename_allflag = strcat(foldername_interact_flag,'/allflag.txt');



%allflag��д1�� matflag��д0
fid = fopen(handfilename_allflag, 'w');
fprintf(fid, '%d', 1);
fclose(fid);

fid = fopen(handfilename_matflag, 'w');
fprintf(fid, '%d', 0);
fclose(fid);

termiflag = 0;

end