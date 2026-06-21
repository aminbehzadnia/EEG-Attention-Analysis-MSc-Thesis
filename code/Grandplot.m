close all
clear all;
PM=cd;
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

   counter = 1;
    
   for i = 1:2
       disp(['#########################################################################'])

       %for j = 1:2
     h=  figure(counter)
            for n = 1:3;
                k=1;
            for Subject_Num = [3,5:6,8:10,12,15:22,24:25,27:29];
               cid=num2str(Subject_Num);
               
     disp(['Processing(Part 2) is started for     Subject_Num:',cid,'\ Modality: ',modality{i,1},'target and nontarget'])
             
            SaveFile_Address_S = [SaveFile_Address,num2str(Subject_Num),'\',modality{i,1}];
            LoadFile_Address = [SaveFile_Address,num2str(Subject_Num),'\',modality{i,1}];
            load([SaveFile_Address_S,['\Filt_erp_',modality{i,1},'_',states{1,1}, '_', cid,'.mat']]);
            
            Grandt(k,:)=filt_erp(loc(n),:);
            
            load([SaveFile_Address_S,['\Filt_erp_',modality{i,1},'_',states{2,1}, '_', cid,'.mat']]); 
            
           Grandnont(k,:)=filt_erp(loc(n),:);
           
           k=k+1;
               
            end
      
            GAt(n,:)=mean(Grandt);
            
             GAnont(n,:)=mean(Grandnont);
       
                subplot(3,1,n)
                plot((GAt(n,:)),'LineWidth',2)
                hold all;
                plot((GAnont(n,:)),'LineWidth',2)
                grid 
                hold on
                axis([1,275,-Inf,Inf])
                set(gca,'XTick',[1,25,50,75,100,125,150,175,200,225,250,275]);
                set(gca,'XTickLabel',{-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1});
                switch n
                    case 1
                        legend('Target-Pz','nontarget-Pz')
                        title(['Grand Average P3 ', modality{i,1}, '  State: Target & nontarget'])
                    case 2
                        legend('Target-Cz','nontarget-Cz')
                    case 3
                        legend('Target-Fz','nontarget-Fz')
                end
                
            %end
            counter = counter + 1;
            saveas(h,[SaveFile_Address_S,'\Grand Average_p3_Target & nontarget',modality{i,1},'_','all','.fig'])
       end
   end    
          



                
                
                