%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%-------------------------------------------------------------------------
%                       Processing_Part 2
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


CID=input('Participant''s Code number?  ');
SaveFile_Address = [PM,'\Data\Preprocessed Data\'];

fs = 250;
[e1,e2] = ellip(8,.1,70,12*2/fs);

EEG_chanlocs = readlocs( 'Standard-10-20-Cap19.locs');
C = struct2cell(EEG_chanlocs);                                                  % Extract Channel Labels
Channel_Labels = C(3,:,:);

Channels = {'Pz','Cz','Fz'};
[~, loc] = ismember(Channels,Channel_Labels);

modality = {'Visual';'Audio'};
states = {'Target';'NonTarget'};

for Subject_Num = CID %[3,5:6,8:10,12,15:22,24:25,27:29]
 
    cid=num2str(Subject_Num);
    
    amp_p3 = zeros(3,1);  %three channels: Pz, Cz and Fz \ two states: Target and Non-Target
    lat_p3 = zeros(3,1);
    
    counter = 1;
    
    for i = 1:2
        
        disp(['#########################################################################'])

        disp(['Processing(Part 2) is started for     Subject_Num:',cid,'\ Modality: ',modality{i,1}])
        disp(['P300 estimation is started...'])

        SaveFile_Address_S = [SaveFile_Address,num2str(Subject_Num),'\',modality{i,1}];
        LoadFile_Address = [SaveFile_Address,num2str(Subject_Num),'\',modality{i,1}];
        
        for j = 1:2
            
            load([SaveFile_Address_S,['\Filt_erp_',modality{i,1},'_',states{j,1}, '_', cid,'.mat']]);
            
          h=  figure(counter)
            
            for n = 1:3
                
                subplot(3,1,n)
                plot(filt_erp(loc(n),:),'LineWidth',2)
                grid 
                hold on
                axis([1,275,-Inf,Inf])
                set(gca,'XTick',[1,25,50,75,100,125,150,175,200,225,250,275]);
                set(gca,'XTickLabel',{-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1});
                switch n
                    case 1
                        legend('Pz')
                        title(['Modality: ', modality{i,1}, '  State: ', states{j,1}])
                    case 2
                        legend('Cz')
                    case 3
                        legend('Fz')
                end
                
                %% P300 Computation
                locs = [];
            for k = 101:274    % P300 interval: 300-1000ms after stimulus onset
                sign = (filt_erp(loc(n),k) - filt_erp(loc(n),k-1)) .* (filt_erp(loc(n),k+1) - filt_erp(loc(n),k));
                if((sign < 0) & (filt_erp(loc(n),k) >= filt_erp(loc(n),k-1)) & (filt_erp(loc(n),k) >= filt_erp(loc(n),k+1)))
                    locs = [locs k];
                end
            end
            [val pos] = max(filt_erp(loc(n),locs));
            amp_p3(n,1) = val - mean(filt_erp(loc(n),1:25));
            lat_p3(n,1) = (round(locs(pos)*(1000/fs)) - 100);
            mean_100(n,1)= mean(filt_erp(loc(n),1:25));
            
            P300 = plot3(locs(pos),filt_erp(loc(n),locs(pos)),val,'.','MarkerSize',20,'markeredgecolor','r');
            hold on
            datacursormode on
            disp(['LP3 ',modality{i,1},'_',states{j,1},'_',Channels{1,n},' (red bullet):',num2str(lat_p3(n,1)),' ms\ ',num2str(locs(pos)),' Sample'])
            usr_confirm = input([modality{i,1},'_',states{j,1},': proposed location for P300(Enter:Accept the results)?']);
            if ~isempty(usr_confirm)
                amp_p3(n,1) = filt_erp(loc(n),usr_confirm) - mean(filt_erp(loc(n),1:25));
                lat_p3(n,1) = round((usr_confirm .* (1000/fs)) - 100);
                X = ['Amplitude_P300: ',num2str(amp_p3(n,1)), '   Latency_P300: ',num2str(lat_p3(n,1)),' milisecond'];
                disp(X)
                disp('-----------------------------------------------------------------------')
            elseif(isempty(usr_confirm))
                disp('you have confirmed the result of automatic P300 extraction (red bullet)')
                disp('-----------------------------------------------------------------------')
            end
            datacursormode off
            hold off
            end
            counter = counter + 1;
            save([SaveFile_Address_S,'\P300_',modality{i,1},'_',states{j,1},'_',cid,'.mat'],'amp_p3','lat_p3','mean_100')
            saveas(h,[SaveFile_Address_S,'\ERP_p3',modality{i,1},'_',states{j,1},'_',cid,'.fig'])
        end
    end
end
                
                
                
                
                
            
            
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    