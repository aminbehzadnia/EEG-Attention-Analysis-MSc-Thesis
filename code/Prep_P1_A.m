%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%-------------------------------------------------------------------------
%                         Preprocessing_Part 1
%                       Version 3: 95/05/16
%                   Prepared by: Farnaz Ghassemi & Athena Taymourtash 
%                   for Amin Behzadnia MSc Project
%                   
%-------------------------------------------------------------------------
clc;
clear all;
close all;
PM=cd
CC=1;
PP=0;
% pw=input('Please enter the password: ','s');
% clc
% PW='behzadnia17051';
% PP=sum(pw==PW);
% clear pw PW
% if PP~=11
%    disp('The password is wrong!!!!!!!!!')
%    CC=0;
%    quit;
% end
el=input('Have you run EEGLAB previously(y/n)? ','s');
if (CC & ( el=='n' | el=='N'))
    [PM(1:end-19) 'eeglab11_0_4_3b']
    addpath([PM(1:end-22) 'eeglab11_0_4_3b']);
    eeglab
    close
end

% CID=input('Participant''s Code number?');
SaveFile_Address = [PM,'\Data\Preprocessed Data\']; 

modality = {'Visual';'Audio'};

for Subject_Num = [3,5:6,8:10,12,15:22,24:25,27:29]
    
    cid = num2str(Subject_Num);
    cd([PM '\Data\Raw Data\'])
    
    LoadFile_Address = [SaveFile_Address,num2str(Subject_Num)];
    PathName=[SaveFile_Address(1:end-18),'Raw Data\',cid,'\'];
    
    for i = 1:2
        SaveFile_Address_S=[SaveFile_Address,num2str(Subject_Num),'\',modality{i,1}];
        mkdir(SaveFile_Address_S);
        disp(['#########################################################################'])
        %FileName=[num2str(Subject_Num),'-',modality{i,1},'-raw.EDF'];
        FileName=[num2str(Subject_Num),'-',modality{i,1},'-off.txt'];
        disp(['Preprocessing(Part 1) is started for     Subject_Num:',cid,'\  Modality:',modality{i,1}])
        
        %% Step #1 : Reading EEG Data  
        disp('Step #1 : Reading EEG Data ......')
        File_Address=strcat(PathName,FileName);
        cd(PM)
        
        EEG = pop_importdata('data',File_Address,'srate' ,250);     % Import Data
       % [EEG]=EEG_Reading2(File_Address,SaveFile_Address_S,cid,modality{i,1});
        disp(['EEG data for subject',cid,' ',modality{i,1},' is extracted...'])
        disp('Done')
        disp('--------------------------------------------------------------------')
        %% Step #2 :Extracting Trigers
        disp('Step #2 : Extracting Trigers......')
        path_log = PathName;
        Dnam_log = [cid,'-',modality{i,1},'-Trial.txt'];
        [trig_on,type,stim_tar,stim_non,all_isi] = Ext_Stim(path_log,Dnam_log,SaveFile_Address_S,cid,modality{i,1});
        TRG(i)={type};
        TT(i)={trig_on};
        new_trg = [type,trig_on]; % adding locs of triggers and their isi
        Name = ['event_values_',modality{i,1},'.txt'];
        cd(path_log)
        dlmwrite(Name,new_trg,'delimiter','\t');
        cd(PM)
        NEW_TRG(i)={new_trg};
        disp(['Trigers for ',cid,'  modality :',modality{i,1},' are extracted...'])
        EEG_T(i)={EEG};  
         
         
         %% initial Values

        Fs = EEG_T{1,i}.srate;
        range_rmbase=[-100 0];
        range_epoch=[-.1 1];
        data = EEG.data(any(EEG.data,2),:);
        [EEG, eventnumbers] = pop_importevent(EEG,'event',[path_log,Name],...
            'fields', {'type', 'latency'},'skipline',0,'timeunit',1E-3,'append','no'); 
        EEG_Event = EEG.event; 
        
        
        EEG.chanlocs = readlocs( 'Standard-10-20-Cap19.locs');
        EEG_chanlocs = EEG.chanlocs(any(data,2));                      % Update Channel Location 
        C = struct2cell(EEG_chanlocs);                                                  % Extract Channel Labels
        Channel_Labels = C(3,:,:);
        disp('Done')
        disp('--------------------------------------------------------------------')
        
       %% Step #3 : Rerefrencing   
%         disp('Step #3 : Rerefrencing ......')
%         [~, Ref_loc] = ismember({'A1' 'A2'},Channel_Labels);
%         if(~isequal(Ref_loc,[0,0]))
%             [Data, EEG_chanlocs] = reref(data,Ref_loc,'elocs',EEG_chanlocs);   % Rereference to Average of A1 & A2
%         else
%             [Data, EEG_chanlocs] = reref(data);   %  Average Rereference
%         end
           Data=EEG.data;
           Data=double(Data);
           Chan_Num = size(Data,1);                                           % Channel Number
%         disp('Done')
%         disp('--------------------------------------------------------------------')
        
            
        %% Step #4 : Bandpass and Notch Filtering
        disp('Step #5 : Bandpass and Notch Filtering.......')
        cd(PM)
        Filtered_Data = Filtering3(Data,SaveFile_Address_S,modality{i,1},cid,Chan_Num);%!!!!!!!!!!!!!!!!!(org_signal,PM,kk,cid)
        EEG.data=Filtered_Data;
        
        save([SaveFile_Address_S,'\Filt_EEG_',cid,'_',modality{i,1},'.mat'],'EEG')%!!!!!!!!!!!!!!!!!!!
%         eegplot(Filtered_Data,'srate',Fs, 'scale', 'on','events',EEG_Event,'eloc_file',EEG_chanlocs,'winlength','4','dispchans','16');
        disp('Done') 
        disp('--------------------------------------------------------------------')
        disp(['#########################################################################'])
       %% Step #5 : Baseline Rejection
       disp('Step #4 : Baseline Rejection ......')
       Data = rmbase(Data);                                               % Remove mean of each Data Channel
        disp('Done')  
        disp('--------------------------------------------------------------------')

        save([SaveFile_Address_S,'\Trig_Type_Total_',cid,'_ ',modality{i,1},'.mat'],'TRG','NEW_TRG','TT','stim_tar','stim_non','all_isi')%!!!!!!!!!!!!!!!!!!!
        save([SaveFile_Address_S,'\EEG_Total_',cid,'_ ',modality{i,1},'.mat'],'EEG_T')%!!!!!!!!!!!!!!!!!!!
    end
  
end

        
        















