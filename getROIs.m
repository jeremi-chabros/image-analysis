function ROI = getROIs(imgName, tit)

I = imread(imgName);

imshow(I)
title(tit, 'fontsize', 15)

button = uicontrol('Position',[300 15 150 30],'String','Done',...
    'Callback', @Done);
flg = 0;
counter = 1;

while ~flg
    roi = drawpoint('color',[0 0.5 0]);
    if ~isvalid(roi) || isempty(roi.Position)
        flg = 1;
    else
        ROI(counter, :) = roi.Position;
        counter = counter+1;
    end
end

function Done(button, EventData)
    close(gcf);
end


end