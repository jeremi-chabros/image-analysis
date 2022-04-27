% 1) Set imname to the photo file (if not in the same folder, then specify
% path in the filename)
% 2) On default, the results will be saved as the same file name with .mat
% extension. If you want to input custom name, do it in the construct_id
% variable (remember about the .mat extension!)

clearvars; clc;
imname = 'IMG_4525.jpg';
construct_id = '';
I = imread(imname);

tit1 = 'Select second row and click "Done"';
ROI = getROIs(imname, tit1);

for i = 1:length(ROI)-1
    ie_dist(i) = sqrt(sum((ROI(i,:)-ROI(i+1,:)).^2,2));
end
ie_dist = mean(ie_dist);

tit2 = 'Select electrodes: 21, 71,  28, 78 (IN THIS ORDER)';
corners = getROIs(imname, tit2);


x = corners(1,1)-ie_dist:ie_dist:corners(1,1)+6*ie_dist;
y = corners(1,2):ie_dist:corners(1,2)+7*ie_dist;
[X,Y] = meshgrid(x,y);

imshow(I);
hold on;
scatter(X,Y, 150,'o','linewidth', 2, 'MarkerEdgeColor',[240	206	70]/256, 'MarkerEdgeAlpha', 0.5)

button = uicontrol('Position',[300 15 150 30],'String','Done',...
    'Callback', @Done);

%-------------------------------------------------
%% This needs to be this way sorry
load("tempfile.mat")
electrode_id = parseIndexes(pos,X, Y);

if length(construct_id) < 4
    save([imname(1:end-4) '.mat'],'electrode_id');
else
    save(construct_id,'electrode_id');
end



%--------------------------------------------
%% Function for the button
function Done(button, EventData)
d = datacursormode(gcf);
vals = getCursorInfo(d);
pos = vertcat(vals(:).Position);
save('tempfile.mat', 'pos')
close(gcf);
end
