%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%-------------------------------------------------------------------------
%                       Preprocessing_Part 2
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
    addpath([PM(1:end-22) 'eeglab13_5_4b']);
    eeglab
    close
end

%CID=input('Participant''s Code number?');
SaveFile_Address = [PM,'\Data\Preprocessed Data\'];

modality = {'Visual';'Audio'};

for Subject_Num = [3,5:6,8:10,12,15:22,24:25,27:29]
                  
    cid=num2str(Subject_Num);
    LoadFile_Address = [SaveFile_Address,num2str(Subject_Num)];
    

    for i = 1:2
        SaveFile_Address_S=[SaveFile_Address,num2str(Subject_Num),'\',modality{i,1}];
        disp(['#########################################################################'])
        disp(['Preprocessing(Part 2) is started for    Subject_Num:',cid,'\   Modality:',modality{i,1}])
        load([SaveFile_Address_S,'\Filt_EEG_',cid,'_',modality{i,1},'.mat'],'EEG')%!!!!!!!!!!!!!!!!!!!
        disp(['EEG data for ',cid,'_',modality{i,1},' is loaded...'])
 
        %% Step #6: Running ICA
        disp('Step #6: Running ICA.......')    
%         cd([PM,'\ICA'])
        AR_order=10;
        ortho=0;
        Data=[];
        Data=EEG.data;
        [weights, NonSeparableComponents, Wefica, Wwasobi, ISRwa1, ISRef1, Components]= multicombi(Data,AR_order);       
        %[weights, sphere, compvars] = runica(,'Extended',1);  % Calculate weights and sphering matrixs
%         sphere=eye(Chan_Num);

        EEG.icasphere=eye(length(weights));
        EEG.icachansind=1:length(weights);%!!!!!!!;
        Unmix = weights*EEG.icasphere;                                            % Unmixing matrix is icaweights(Com_num,Chan_num)* Whitening matrix(Chan_num,Chan_num)     
        Mixing =(Unmix)^(-1);                                              % Mixing matrix
        EEG.icawinv=Mixing;
        EEG.icaweights=Unmix;        
%         Components = Unmix*Data;    
%         save([SaveFile_Address,'Session ',num2str(Subject_Num),'\','Components_',cid,'_',num2str(Block_Num)],'Components','weights','Chan_Num');        % Save the Components Matrix for each Block
        EEG.icaact=Unmix*Data;
        save([SaveFile_Address_S,'\ICA_EEG_',cid,'_',modality{i,1},'.mat'],'EEG')
        disp('Done') 
        
        disp(['###################################################################'])
    end
end

    
       