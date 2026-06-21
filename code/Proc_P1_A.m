%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%-------------------------------------------------------------------------
%                       Processing_Part 1
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


%CID=input('Participant''s Code number?  ');
SaveFile_Address = [PM,'\Data\Preprocessed Data\'];
%% Initializing
fs = 250;
[e1,e2] = ellip(8,.1,70,20*2/fs);

EEG_chanlocs = readlocs( 'Standard-10-20-Cap19.locs');
C = struct2cell(EEG_chanlocs);                                                  % Extract Channel Labels
Channel_Labels = C(3,:,:);

Channels = {'Pz','Cz','Fz'};
[~, loc] = ismember(Channels,Channel_Labels);

modality = {'Visual';'Audio'};
%% Main Loop
for Subject_Num = 9%[3,5:6,8:10,12,15:22,24:25,27:29]
    cid=num2str(Subject_Num);
    counter = 1;
    
    for i = 1:2
        
        disp(['#########################################################################'])

        disp(['Processing(Part 1) is started for     Subject_Num:',cid,'\ Modality: ',modality{i,1}])
        disp(['Averaging is started...'])

        SaveFile_Address_S = [SaveFile_Address,num2str(Subject_Num),'\',modality{i,1}];
        LoadFile_Address = [SaveFile_Address,num2str(Subject_Num),'\',modality{i,1}];
        states = {'Target';'NonTarget'};
        for j = 1:2
            aa = load([SaveFile_Address_S,['\', states{j,1},'_Epochs.mat']]);
            aa = orderfields(aa);
            bb = load([SaveFile_Address_S,['\', states{j,1},'_Rejected.mat']]);
            
            data = struct2cell(aa);
            trg_eph = data{3,1};
            rsp_eph = data{4,1};
            OmCm_tar = data{2,1};
            OmCm_eph = data{1,1};
            
            cc = struct2cell(bb);
            rej_ind = cc{1,1};
            
            if(~isempty(OmCm_tar))
                OmCm_erp = mean(OmCm_eph,3);
                OmCm_filt_erp = zeros(size(OmCm_eph,1),size(OmCm_eph,2));
                for q=1:length(OmCm_tar)
                    if(OmCm_tar(1,q)~=rej_ind)
                        rej_ind = [rej_ind,OmCm_tar(1,q)];
                    end
                end
            else
                OmCm_erp = [];
                OmCm_filt_erp = []; 
            end
              save([SaveFile_Address_S,'\all reject_',modality{i,1},'_',states{j,1},'_',cid,'.mat'],'rej_ind')
            trg_eph(:,:,rej_ind) = [];
         %% ERP Computation
            erp = zeros(size(trg_eph,1),size(trg_eph,2));
            filt_erp = zeros(size(trg_eph,1),size(trg_eph,2));
            
            resp_erp = zeros(size(rsp_eph,1),size(rsp_eph,2));
            resp_filt_erp = zeros(size(rsp_eph,1),size(rsp_eph,2));
        
            erp = mean(trg_eph,3);
            resp_erp = mean(rsp_eph,3);
            %% Smoothing
            for k = 1:size(erp,1)
                filt_erp(k,:) = filtfilt(e1,e2,erp(k,:));
                if(~isempty(rsp_eph))
                resp_filt_erp(k,:) = filtfilt(e1,e2,resp_erp(k,:));
                end
                if(~isempty(OmCm_tar))
                    OmCm_filt_erp = filtfilt(e1,e2,OmCm_erp(k,:));
                end
                
            end
            
            save([SaveFile_Address_S,'\erp_',modality{i,1},'_',states{j,1},'_',cid,'.mat'],'erp','resp_erp','OmCm_erp')
            save([SaveFile_Address_S,'\Filt_erp_',modality{i,1},'_',states{j,1},'_',cid,'.mat'],'filt_erp','resp_filt_erp','OmCm_filt_erp')
            
            
            %% illustration
            h = figure(counter)
            
            
            for k = 1:3
                subplot(3,1,k)
%                 title(s)
                plot(filt_erp(loc(k),:),'LineWidth',2)
                grid
                axis([1,275,-Inf,Inf])
                set(gca,'XTick',[1,25,50,75,100,125,150,175,200,225,250,275]);
                set(gca,'XTickLabel',{-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1});
                
                switch k
                    case 1
                        legend('Pz')
                        title(['Modality: ', modality{i,1}, '  State: ', states{j,1}])
                    case 2
                        legend('Cz')
                    case 3
                        legend('Fz')
                end
            end
            counter = counter + 1;
            saveas(h,[SaveFile_Address_S,'\Filt_erp_',modality{i,1},'_',states{j,1},'_',cid,'.fig'])
        end
    end
end            
        
            
        