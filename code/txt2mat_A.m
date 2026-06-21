global Dnam_r path_r 
if isempty(Dnam_r)
    [Dnam_r path_r]=uigetfile('*.txt','ASCII File');
end
Dfile=[path_r Dnam_r]
disp(['Loading Raw Data ...'])
fid = fopen(Dfile,'r');
Ch_no = 19;       %Number of Channels
C = textscan(fid, '%s ');
[m n] = size(C{1,1});
L = m./19;       %Number of Samples
fclose(fid);

fid = fopen(Dfile,'r');
MyMat = zeros(L,Ch_no);
for i = 1:L
    for j = 1:Ch_no
        MyMat(i,j) = str2num(fscanf(fid, '%s', 1));
    end
end
fclose(fid);
save ([Dfile(1:end-4),'_Raw.mat'],'MyMat','Ch_no','L')
disp(['Done'])