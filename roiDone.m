function roiDone(button, EventData)
d = datacursormode(gcf);
vals = getCursorInfo(d);
pos = vertcat(vals(:).Position);
save('tempfile.mat', 'pos')
close(gcf);
end