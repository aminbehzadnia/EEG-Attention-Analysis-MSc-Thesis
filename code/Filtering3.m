function [Filtered_Data]= Filtering3(org_signal,PM,modality,cid,Chan_Num)
% path_r 
% Dnam_r 
% if not(isempty(path_r))
%     cd(path_r)
% else
%     cd(path_Data)
% end

fs=250;
LP_filter= 80;
HP_filter= 0.5;
ERP_filter = 8.23;%12; %8.23
Notch_band=[49 51]/(fs/2);

[dh_EOG,ah_EOG]=ellip(4,.1,70,0.5*2/fs,'high');

[a,b]=ellip(5,0.1,70,Notch_band,'stop');
[al,bl]=ellip(5,.1,70,LP_filter*2/fs);% [dl,al]=ellip(8,.1,70,35*2/fs);
[ah,bh]=ellip(5,.1,70,HP_filter*2/fs,'high');

%disp('Filtering Data ...')
[aa,bb]=size(org_signal);


    
%     % *************** FILTERING THE EOG *************************
%     for j=[33:36]
%         signal(j,:)=filtfilt(a,b,org_signal(j,:));
%         signal(j,:)=filtfilt(al,bl,signal(j,:));
%         signal(j,:)=filtfilt(dh_EOG,ah_EOG,signal(j,:));
%         
% %         ss=signal(j,:)';
% %         ss=filtfilt(dl,al,ss);
% %         ss=filtfilt(dh_EOG,ah_EOG,ss);
% %         ss=filtfilt(a,b,ss);
% %         signal(j,:)=ss';
%     end

    %*************** FILTERING THE EEG *************************
    for j=[1:Chan_Num]
        Filtered_Data(j,:)=filtfilt(a,b,org_signal(j,:));
        Filtered_Data(j,:)=filtfilt(al,bl,Filtered_Data(j,:));
        Filtered_Data(j,:)=filtfilt(ah,bh,Filtered_Data(j,:));
    end
save([PM,'\FData_',cid,'_',modality,'.mat'],'Filtered_Data');



disp('Done.')
