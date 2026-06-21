clear all ;close all

max_repeat=15 ;  %max(no. of repeat for each type of stims) 
max_record_length=256; %max no. of samples recorded for each stim
fs=256;
EOG_level=200e-6;
EEG_level=150e-6;
%*************** READING THE EEG FILE ***********************
[Dnam path]=uigetfile('*.mat','MAT File');
Dfile=[path Dnam];
load(Dfile);
signal=org_signal;
%*************** FILTERING THE EEG *************************
%plot (signal(31,:));pause;zoom on
[dl,al]=ellip(8,.1,70,35*2/fs);%org=35
[dh,ah]=ellip(4,.1,70,.5*2/fs,'high');
for j=1:4
      signal(j,:)=filtfilt(dl,al,signal(j,:));
end
for j=1:4
   signal(j,:)=filtfilt(dh,ah,signal(j,:));
end

%************** SEPARATING ERPs FEROM EACHOTHER ***************

Pz=zeros(total_stim_no,max_repeat,max_record_length);
Cz=zeros(total_stim_no,max_repeat,max_record_length);
Fz=zeros(total_stim_no,max_repeat,max_record_length);
for stim_no=1:total_stim_no,
   count(stim_no)=0;
   for j=stim_table(stim_no,:),
      if j==0, break; end,
      if (max(abs(signal(4,stim_start(j):stim_start(j)+max_record_length-1)))< EOG_level)&...
            (max(abs(signal(3,stim_start(j):stim_start(j)+max_record_length-1)))<EEG_level)&...
            (max(abs(signal(2,stim_start(j):stim_start(j)+max_record_length-1)))<EEG_level)&...
            (max(abs(signal(1,stim_start(j):stim_start(j)+max_record_length-1)))<EEG_level),
         
         count(stim_no)=count(stim_no)+1;
         Pz(stim_no,count(stim_no),1:max_record_length)=...
            signal(3,stim_start(j):stim_start(j)+max_record_length-1);
         Cz(stim_no,count(stim_no),1:max_record_length)=...
            signal(2,stim_start(j):stim_start(j)+max_record_length-1);
         Fz(stim_no,count(stim_no),1:max_record_length)=...
            signal(1,stim_start(j):stim_start(j)+max_record_length-1);
      end;
      
   end
end

count



%************* DISPLAY THE ERPs SEPARATELY & THEIR MEAN **************

sig=Pz;%*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*?*
ch_name='Pz';
color='bbbbb';%'mrkgb';
color1='rgbkcm';

figure(total_stim_no+2);hold off
for x=1:total_stim_no,
   figure(x+1);hold off
   subplot(211)
   for i=1:count(x),
      for j=1:max_record_length
         plt(j)=sig(x,i,j)+i*1.4e-4;
      end
      plot((1:max_record_length)/fs*1000,plt,color(i-5*floor(i/5)+1));hold on
   end
   axis tight;zoom on

  % ***************** calculate & display the mean *****************
  
   for k=1:max_record_length,
      erp_sig(x,k)=mean(sig(x,1:count(x),k));
   end
   
   subplot(212);
   plot((1:max_record_length)/fs*1000,erp_sig(x,1:max_record_length),'r')
   title(['Channel: ',ch_name,'    stim # ',num2str(x),'   Correct Trials: ',num2str(count(x))])
   xlabel('ms')
   %axis([1 max_record_length/fs*1000 -800 800]);%axis tight;
   zoom on;  
   figure(total_stim_no+3);
   subplot(total_stim_no,1,x);
   plot((1:max_record_length)/fs*1000,erp_sig(x,1:max_record_length));
   xlabel('ms')
  % axis([1 max_record_length/fs*1000 -800 800]);
   
   figure(total_stim_no+2);
   plot((1:max_record_length)/fs*1000,erp_sig(x,1:max_record_length),color1(x));
   hold on
end
stim_leg=['average of stim # 1';'average of stim # 2';'average of stim # 3';'average of stim # 4';'average of stim # 5'];
figure(total_stim_no+2);
legend(stim_leg);
%axis([1 max_record_length/fs*1000 -40 50])
xlabel('ms')
ylabel('Volt')


