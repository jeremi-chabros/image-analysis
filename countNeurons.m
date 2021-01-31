function stats = countNeurons(imname, xl, yl, windowSize)
%% Counting Neurons
% Developed 2020 - 2021
% Leo NAGY

% INPUT:
%   imname - string specifying the image to be analysed
%   xl - scalar specifying the X coordinate of the cropped image
%   yl -  scalar specifying the Y coordinate of the cropped image
%   windowSize - scalar specifying the size of the image to be analyzed

% OUTPUT:
%   stats - structure containing the object detection results

% TODO: ADD COMMENTS!
% TODO: Merge with TotalCellMatterArea.m & WeightedDarknessScript.m

%% Read Image
I = imread(imname);

% If not cropping the image, set default values to full image
if ~exist('xl','var')
    xl = size(I, 1);
end
if ~exist('yl','var')
    yl = size(I, 2);
end
imshow(I);
title('Select 6 consecutive electrodes');

for i = 1:6 % To select six electrodes
    ROI = drawpoint;
    TemplateElec(i,:) = ROI.Position;
    clear ROI
end

for i = 1:length(TemplateElec) - 1
    lengthx(i) = TemplateElec(i+1,1)-TemplateElec(i,1);
end

eleclength = mean(lengthx); % Calculates mean of the length between electrodes.

Elec1= TemplateElec(1,:);
Elec1(1)= Elec1(1)- eleclength;

count = 0;
for w = 1:8  %w=width cooresponding to y coord
    for l = 1:8 %l=length corresponding to x coord
        if (l==1 && w==1) || (l==8 && w==8) || (l==1 && w==8) || (l==8 && w==1) || (l==5 && w==1)
            continue
        else
            count=count+1;
            ElecCoord(count,1)= Elec1(1)+ (w-1)*eleclength;
            ElecCoord(count,2)= Elec1(2)+ (l-1)*eleclength;
        end
    end
end

ElecCoord = ElecCoord';

%% JJC: This is where I really made some more important changes to the code
I = imread(imname);
% I = imread('richn1.jpg');
ref = imread('richn1.jpg'); % Reference image for which you have optimized the sensitivity

% Unsharp masking:
%   threshold = 0.01 or less gives preference to single neurons
%   threshold = 0.1 I think is the optimal but need to calculate clusters
%   separately from surface area
I = imsharpen(I, 'threshold', 0.1, 'amount', 2, 'radius', 5);
I = imhistmatch(I, ref, 'method', 'uniform'); % Match the histograms
Icomp = imcomplement(I);
Icomp = imsharpen(Icomp, 'threshold', 0.1, 'amount', 2, 'radius', 1);

% JJC NOTE: apparently both sharpenings (unsharp masking of the original image
% plus unsharp masking of the imcomplement image) are neccessary for a good
% result. There exists some interesting relationship that specifies the trade-off
% between the false positives and false negatives here. Values above have
% been optimised for richnhighres1.jpg
%%
WeightedDarknessScript % Calculates weighted darkness index of greyscale picture.

ScaledSensitivityBinarization = WeightedDarkness*0.86; % 0.86 is temporary coefficient that

BW = imbinarize(Icomp,'adaptive', 'ForegroundPolarity','bright','Sensitivity', 0.35);

se = strel('disk', 2); % Change number after 'disk' to a smaller: see more
% Larger number: makes more objects disappear
Iopenned = imopen(BW,se);
figure, imshowpair(Iopenned, I);
imshow(Iopenned);

CC = bwconncomp(Iopenned, 4); % Counts connected components; 'creates' the objects so to say.
stats = regionprops(CC, 'Eccentricity', 'Area', 'BoundingBox', 'Image', 'Centroid');
stats = stats([stats.Eccentricity] ~= 0); % Removes all rows from stats that have 0 eccentricity.
stats = stats([stats.Area] > 21); % Removes all objects below given Area size.
areas = [stats.Area];
numObjects = length([stats.Area]);
eccentricities = [stats.Eccentricity];
BoundingBox = [stats.BoundingBox];
for i = 1:length(areas)
    BoundBox(i,:) = BoundingBox (1 + (i * 4 -4): i*4);
end
clear BoundingBox
TotalCellMatterArea
AreaValsBig = [stats.Area];
EccVals0 = [stats.Eccentricity];
colsToDelete = AreaValsBig < 150.35;
AreaValsBig(colsToDelete) = [];
AvgCellsPerCluster = AreaValsBig/150.35; 
TotalClusterCells = sum(AvgCellsPerCluster);
ElecArea = 59*330/150.35;
FinalnumObjects = numObjects - length(AreaValsBig) + TotalClusterCells - ElecArea;
end
