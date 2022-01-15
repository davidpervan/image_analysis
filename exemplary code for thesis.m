close all
clear all
home

% Round objects analysis by David Pervan

%% Read image
filepath = ('400.1.tif');
image = imread(filepath);
figure(1); imshow(image);

%% Threshold image
bw = im2bw(image,0.55);
figure(3); imshow(bw);

%% Invert image
bw_inverted = ~bw;

%% Remove noise
% remove all object containing fewer than 100 pixels
bw_noiseremoved = bwareaopen(bw_inverted,100);

%% Determine particle size

stats = regionprops(bw_noiseremoved,'EquivDiameter');

folder = 'D:\Google Drive\PhD\Experiments\Cu sintering process\host stage FEG SEM\20171214 Cu\Analysis\indiviudal Excel files\new';
baseFileName = '400.1_stats.xlsx';
fullFileName = fullfile(folder, baseFileName);

writetable(struct2table(stats),fullFileName)

diameters = zeros(numel(stats),1); % CHANGE STUCTURE

for i = 1:(numel(stats))
    diameters(i) = stats(i).EquivDiameter; %ideal 
end

diameters = sort(diameters); 

scale_bar = (3438-3204)/1000; % apply scale bar from pixels to nanometres
diameters = diameters/scale_bar;

baseFileName = '400.1_diameters.xlsx';
fullFileName = fullfile(folder, baseFileName);
xlswrite(fullFileName,diameters)
