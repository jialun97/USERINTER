function [ termiflag] =    platformend(filepath)


termiflag = 1;
if ischar(filepath)~=1
    disp('输入的文件路径格式有误，请重新输入');
    return ;
end

foldername_interact_flag = strcat(filepath, '/interact_flag');
if exist(foldername_interact_flag)==0
    mkdir(foldername_interact_flag);
end

handfilename_matflag = strcat(foldername_interact_flag, '/matflag.txt');
handfilename_allflag = strcat(foldername_interact_flag,'/allflag.txt');



%allflag先写1， matflag后写0
fid = fopen(handfilename_allflag, 'w');
fprintf(fid, '%d', 1);
fclose(fid);

fid = fopen(handfilename_matflag, 'w');
fprintf(fid, '%d', 0);
fclose(fid);

termiflag = 0;

end