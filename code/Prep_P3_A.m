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

for Subject_Num =  [3,5:6,8:10,12,15:22,24:25,27:29]
 
    cid=num2str(Subject_Num);
    
    LoadFile_Address = [SaveFile_Address,num2str(Subject_Num)];
        
    Target_Trials = zeros(2,96);
    
    NonTarget_Trials = zeros(2,224);
    
    Fs = 250;
    
    range_rmbase=[-100 0];

    range_epoch=[-0.1 1];

    for i = 1:2
        SaveFile_Address_S=[SaveFile_Address,num2str(Subject_Num),'\',modality{i,1}];
        disp(['#########################################################################'])
        disp(['Preprocessing(Part 3) is started for          Subject_Num:',cid,'\   Modality:',modality{i,1}])

        load([SaveFile_Address_S,'\ICA_EEG_',cid,'_',modality{i,1},'.mat'],'EEG')

        disp(['EEG data for ',cid,'_',modality{i,1},' is loaded...'])
        
        C = struct2cell(EEG.chanlocs);                                     % Extract Channel Labels

        [la,lb,lc]=size(C);

        Channel_Labels = reshape(C(3,:,:),1,lc);  
         %% Step #7: Identify EOG component...

        disp('Step #7: Identify EOG component...')

        [~, Fp_loc] = ismember({'Fp2'},Channel_Labels);                    % Find FP2 Channel

        if isempty(Fp_loc)

            [~, Fp_loc] = ismember({'Fp2'},Channel_Labels); 

        end

        [R1,P1]=corr(EEG.data(Fp_loc,:)',EEG.icaact');  %-----Channel of EOG

        ind_EOG1=find(P1<0.01 & abs(R1)>0.8);

        if isempty(ind_EOG1)

            [sorted_r1,ind_r1]=sort(abs(R1),'descend');

            l=1;

            while P1(ind_r1(l))>0.05

                l=l+1;

            end

            ind_EOG1=ind_r1(l);  

            disp(['WRRNING: MAX Correlation for EOG was ',num2str(sorted_r1(l))])

        end

        disp(['Candidate(s) For EOG Component (Compared to Fp2)is(are): ',num2str(ind_EOG1)]);

        disp(['Correlation for EOG is ',num2str(R1(ind_EOG1))])

        IND_EOG(i,1)={ind_EOG1};

        IND_EOG(i,2)={R1(ind_EOG1)};
             
        EEG.icaact(ind_EOG1,:)=zeros(length(ind_EOG1),length(EEG.icaact));

        EEG.data=EEG.icawinv*EEG.icaact;

        save([SaveFile_Address_S,'\nEOG_sig_',cid,'_',modality{i,1},'.mat'],'EEG')

        disp('Done')         

        disp('--------------------------------------------------------------------')
        %% Step #8 : Extract Epochs 

        disp('Step #8 : Extracting Epochs...')

        EEG.icachansind=1:EEG.nbchan;

        [EEG] =pop_epoch(EEG,[],range_epoch);

        EEG = pop_rmbase( EEG, range_rmbase);

        Epoched_Data=EEG.data;

        disp('Done!')

        save([[SaveFile_Address,num2str(Subject_Num),'\',modality{i,1},'\',],['Stimulus_Epoched_',modality{i,1}]],'Epoched_Data'); % Save the Stimulus_Epoched Matrix for each modality

        disp('--------------------------------------------------------------------')
        
        %% Step #10 :Save Result as Dataset / EEG

        disp('Step #10 :Save Result as Dataset / EEG........')   

        save([SaveFile_Address_S,'\EEGLAB_',cid,'_',modality{i,1},'.mat'],'EEG')%!!!!!!!!!!!!!!!!!!!

        pop_saveset(EEG, 'filename',['Modality_',modality{i,1}],'filepath',[SaveFile_Address_S,'\']); 

        disp('Done') 

        disp('--------------------------------------------------------------------')
        
         %% Step #11 : Making data ready for ERP Extraction

        disp(['Step #11 : Making data ready for ERP Extraction..... '])
        
        load([SaveFile_Address_S,'\Stim_CPT_',modality{i,1},'_',cid,'.mat'])
        
        data = EEG.data;
        data = double(data);
        
        Stimulus_Epoched = data;
        
        Target_Epochs = data(:,:,stim_tar);
        
        NonTarget_Epochs = data(:,:,stim_non);
        
        load([SaveFile_Address_S,'\nEOG_sig_',cid,'_',modality{i,1},'.mat'],'EEG');
        cont_data = EEG.data;
        cont_data = double(cont_data);
        on_tar_resp = trig_on(stim_tar,1) + RT';
        on_tar_resp(:,2) = round((on_tar_resp(:,1).*250)/1000);
        Target_Epochs_Resp = zeros(19,275,96);
        for j = 1:96
            Target_Epochs_Resp(:,:,j) = cont_data(:,on_tar_resp(j,2)-24:on_tar_resp(j,2)+250);
        end
        Oms_tar = find(RT == 0);
        if(~isempty(Oms_tar))
            Oms_Resp = Target_Epochs(:,:,Oms_tar);
            Target_Epochs_Resp(:,:,Oms_tar) = [];
        else
            Oms_Resp = [];
        end
        if(~isempty(Cm_stim))
            non_tar_resp = trig_on(Cm_stim,1) + RT_C';
            non_tar_resp(:,2) = round((non_tar_resp(:,1).*250)/1000);
            NonTarget_Epochs_Resp = zeros(19,275,length(Cm_stim));
            for k = 1:length(Cm_stim)
                NonTarget_Epochs_Resp(:,:,k) = cont_data(:,non_tar_resp(k,2)-24:non_tar_resp(k,2)+250);
            end
           %  NonTarget_Epochs_Resp(:,:,Cm_stim) = [];
        else
            NonTarget_Epochs_Resp = [];
        end
        Cms_Resp = NonTarget_Epochs_Resp;
        Cms_tar = Cm_stim;
        for q = 1:length(Cm_stim)
            Cms_tar(1,q) = Cm_stim(1,q)-length(find(type(1: Cm_stim(1,q),1)==11));
        end
        
        save([SaveFile_Address_S,'\EOG_',cid,'.mat'],'IND_EOG')
        
        save([[SaveFile_Address_S,'\'],'Target_Epochs'],'Target_Epochs','Target_Epochs_Resp','Oms_Resp','Oms_tar');
        save([[SaveFile_Address_S,'\'],'NonTarget_Epochs'],'NonTarget_Epochs','NonTarget_Epochs_Resp','Cms_tar','Cms_Resp');
        save([[SaveFile_Address_S,'\'],'AllStimulus_Epoched'],'Stimulus_Epoched');
        disp('Done') 

        disp(['#########################################################################'])
        
        
        
    end
end


        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        