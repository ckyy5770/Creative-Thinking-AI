function [ newCir ] = drawCir( board,center, radii )
%DRAWCIR Summary of this function goes here
%   Detailed explanation goes here
    [a,b]=size(board);
    newBoard=logical(zeros(a,b));
    newCir=Shape(newBoard);
    for i=max(floor(center(1)-radii),1):min(ceil(center(1)+radii),a)
        for j=max(floor(center(2)-radii),1):min(ceil(center(2)+radii),b)
            dist = norm([i,j]-center);
            if dist<radii
                newCir.bin(i,j)=1;
            end
        end
    end
    newCir=Shape.getPropertiesFromBin(newCir);
    newCir.category=1;
    newCir.radii=radii;
end

