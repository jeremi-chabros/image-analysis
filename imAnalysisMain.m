% Main function for calculating the number of neurons in culture
% Requires dependencies:
%   manualCount.m
%   parseCoord.m
%   TotalCellMatterArea.m - this should be incorporated in countNeurons.m
%   WeightedDarkness.m - this should be incorporated in countNeurons.m
%   countNeurons.m

clearvars; clc;
imname = 'richnhighres1.jpg';
I = imread(imname);
windowSize = 300; % size of the cropped image
[ROI, xl, yl] = manualCount(imname, windowSize); % Manual counting
stats = countNeurons(imname, xl, yl, windowSize); % Automatic detection
%% Parameters for exclusions

% Size (area) exclusion
areas = [stats.Area];
sortedAreas = sort(areas);
nAreas = round(0.1*length(areas)); % exclude 10% of the smallest regions
minArea = sortedAreas(nAreas);
minArea = 1;

BoxRatio = 1.5; % Shape (aspect ratio) exclusion

singleCellArea = 150;
electrodeArea = 400;

%% Plot results

% Plot the original image
imshow(I);
hold on;

% Plot detected regions
ctr = 0;
for idx = 1:length(areas)
    
    % Plot single neurons
    if stats(idx).Area < singleCellArea && stats(idx).Area > minArea % only plot regions that satisfy size constraints
        box = stats(idx).BoundingBox(3:4);
        if ~(box(1) > box(2) * BoxRatio || box(2) > box(1) * BoxRatio) % only plot regions that satisfy shape constraints
            h = rectangle('Position', stats(idx).BoundingBox, 'EdgeColor', [0.75 0 0]);
            hold on;
            ctr = ctr+1;
        end
        
    % Plot clusters
    elseif stats(idx).Area > singleCellArea
        rectangleArea = stats(idx).BoundingBox(3) * stats(idx).BoundingBox(4);
        h = rectangle('Position',stats(idx).BoundingBox);
        set(h,'EdgeColor',[0.5 0 0], 'linewidth', 1.4);
        hold on;
        ctr = ctr + (rectangleArea/singleCellArea);
    end
end
ctr = ctr - 60*electrodeArea/singleCellArea; %
title(['There are ',  num2str(round(ctr)),  ' objects in this image']);
hold on;

% Plot the manually marked cells in green squares
scatter(ROI(:,1),ROI(:,2), 100, 's', 'markeredgecolor', [0 0.5 0], 'linewidth', 1.5);
hold on

% Plot regions that were correctly detected in yellow triangles
correct = parseCoord(ROI, stats, xl, yl, windowSize);
scatter(correct(:,1),correct(:,2), 20, 'y^', 'filled');

xlim([xl xl+windowSize])
ylim([yl yl+windowSize])

