%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%-------------------------------------------------------------------------
%                       Preprocessing_Part 4
%                       Version 3: 95/07/16
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
    
    
    
    
    for i = 1:2
        
        disp(['#########################################################################'])

        disp(['Preprocessing(Part 4) is started for     Subject_Num:',cid,'\ Modality: ',modality{i,1}])

        SaveFile_Address_S = [SaveFile_Address,num2str(Subject_Num),'\',modality{i,1}];
        LoadFile_Address = [SaveFile_Address,num2str(Subject_Num),'\',modality{i,1}];
        cd([LoadFile_Address]);
        %% Load Data
        
        load([SaveFile_Address_S,'\Stim_CPT_',modality{i,1},'_',cid,'.mat'])
        
        Target_Rejected = [];
        
        NonTarget_Rejected = [];
        
        m1 = 0;
        
        m2 = 0;
        
        EEG = pop_loadset('filename',['Modality_',modality{i,1},'.set'],'filepath',LoadFile_Address);
        
         %% Step #12: Rejecting Artifacts...

        disp('Step #12:  Rejecting Artifacts...')
        
        [EEG, Rejected_Epochs] = pop_autorej(EEG,'maxrej',5,'startprob',3,'eegplot','off','nogui','on');
        
        Rejected_Epochs

        

        save([[LoadFile_Address,'/'],['RejectedEpochs_',modality{i,1}]],'Rejected_Epochs');     % Save the StimulusRejectedEpoches for each Modality

         %% Determine Rejected Epochs for Target Category 
         
          [~,~,I] = intersect(Rejected_Epochs,stim_tar);
          
          if ~isempty(I)

            Target_Rejected(m1+1:m1+length(I)) = I;

            m1 = m1+length(I);
          
          end
          
           %% Determine Rejected Epochs for NonTarget Category
           
           
           [~,~,I] = intersect(Rejected_Epochs,stim_non);
           
           if ~isempty(I)
               
               NonTarget_Rejected(m2+1:m2+length(I)) = I;
               
               m2 = m2+length(I);
           
           end 
           
           %% Save Result of Auto Rejection
           
           save([[LoadFile_Address],'/','Target_Rejected'],'Target_Rejected');           % Save the Target_Rejected Epochs
           
           save([[LoadFile_Address],'/','NonTarget_Rejected'],'NonTarget_Rejected');           % Save the NonTarget_Rejected Epochs
           
    end
end
         



        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    