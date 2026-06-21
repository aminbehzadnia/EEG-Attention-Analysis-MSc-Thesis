%----------------------------------------------------------------------
%                        Extracting Stimulus 
%                       Version 1 - 1395/04/02
%                    Prepared by: Athena Taymourtash 
%                 for EEG Data of Amin Behzadnia MSc project
%----------------------------------------------------------------------
clear all;
clc;
global Dnam_log path_log no_S no_NS
[Dnam_log path_log]=uigetfile('*.txt','Text File');
Dfile_log=[path_log Dnam_log];
fid = fopen(Dfile_log,'r');
L=320;
S=zeros(1);
NS=zeros(1);
j=1;
k=1;
h=1;
g=1;
Om_stim = [];
Cm_stim = [];
x=['11'];
ISI=[];
for i=1:L
    C = textscan(fid, '%s ',10);
    Charac = (C{1,1}{2,1}(1:end-1));
    flag_Om = (C{1,1}{7,1}(1:end-1));
    flag_Cm = (C{1,1}{8,1}(1:end-1));
    if (flag_Cm == '1')
            rt_c = (C{1,1}{4,1}(1:end-1));
            RT_C(g) = str2num(rt_c);
            Cm_stim(g) = i;
            g = g + 1;
    end
    if Charac == x
        S(j) = i;        
        if (flag_Om == '1')
            rt = (C{1,1}{3,1}(1:end-1));
            RT(j) = str2num(rt);
        else
            Om_stim(h) = i;
            h = h + 1;
        end
        j = j + 1;
    elseif ~isempty(Charac)
        NS(k) = i;
        k = k + 1; 
    end
    is = (C{1,1}{1,1}(1:end-1));
    [a,b]=size(is)
    kk=1;
    i
    if ~isempty(is)
        stim_s=str2num(is(1,b));
        for jj=1:b-1
            kk=kk*10;
            stim_s=stim_s+ kk*str2num(is(1,(b-jj)));
        end
        IS(i)=stim_s;
        if i>1
            ISI(i-1)=(IS(i)-IS(i-1))/1000;
        end
    end
    
end

s_10=find(ISI>=1.1000 & ISI<=1.1080);
s_15=find(ISI>=1.6000 & ISI<=1.6080);
s_20=find(ISI>=2.1000 & ISI<=2.1080);
s_25=find(ISI>=2.6000 & ISI<=2.6080);
[a b] = min([length(s_10),length(s_15),length(s_20),length(s_25)]);
switch b
    case 1
        s_10(1,80) = 320;
        ISI(1,320) = 1.1000;
    case 2
        s_15(1,80) = 320;
        ISI(1,320) = 1.6000;
    case 3
        s_20(1,80) = 320;
        ISI(1,320) = 2.1000;
    case 4
        s_25(1,80) = 320;
        ISI(1,320) = 2.6000;
end

no_NS=num2str(length(NS));
disp(['Number of non Target Stimuli: ' no_NS])
no_S=num2str(length(S));
disp(['Number of Target Stimuli: ' no_S])
no_Om=num2str(length(Om_stim));
disp(['Number of Omissions: ' no_Om])
no_Cm=num2str(length(Cm_stim));
disp(['Number of Commissions: ' no_Cm])

fclose(fid);
stim_tar = S;
stim_non = NS;

% save ([path_log,[Dnam_log(1,4) '_Stim_CCPT.mat']],'stim_tar','stim_non',...
%     's_10','s_15','s_20','s_25','ISI',...
%     'Cm_stim','Om_stim','no_Om','no_Cm','RT','RT_C')