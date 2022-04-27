function electrode_id = parseIndexes(pos,X,Y)

for i = 1:size(pos,1)

    xpos = find(pos(i,1)==X);
    xpos = xpos(1);

    ypos = find(pos(i,2)==Y);
    ypos = ypos(1);

    [~,column] = ind2sub(8,xpos);
    [row,~] = ind2sub(8,ypos);

    electrode_id(i) = 10*column + row;
end

end