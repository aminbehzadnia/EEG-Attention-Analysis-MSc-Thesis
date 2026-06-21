%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%-------------------------------------------------------------------------
%            Extracting events in different modalities of recorded data
%                       Version 5: 95/05/16
%                   Prepared by: Farnaz Ghassemi & Athena Taymourtash
%                   for Amin Behzadnia MSc project 
%-------------------------------------------------------------------------
function [EEG]=EEG_Reading2(File_Address,SaveFile_Address_S,cid,modality)
% cd(file_address)
EEG = pop_biosig(File_Address,'importevent','on','ref',20);     % Import Data

save([SaveFile_Address_S,'\EEG_',cid,'_',modality,'.mat'],'EEG')
