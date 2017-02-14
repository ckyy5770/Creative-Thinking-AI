function [ newTri ] = drawTri( board,center, length )
%DRAWTRI Summary of this function goes here
%   Detailed explanation goes here
    [a,b]=size(board);
    newBoard=logical(zeros(a,b));
    newTri=Shape(newBoard);
    % y<sin(pi/3)*x-length*sin(pi/3)*x/2;
    % y<-sin(pi/3)*x+length*sin(pi/3)*x/2;
    % y>-length*sin(pi/3)/2
    for i=1:a
        for j=1:b
            y=-(i-1);
            x=j-1;
            y1=tan(pi/3)*x-length*tan(pi/3)/2;
            y2=-tan(pi/3)*x+length*tan(pi/3)/2;
            y3=-length*tan(pi/3)/2;
            if(y<y1&&y<y2&&y>y3)
                newTri.bin(i,j)=1;
            end
        end
    end
    newTri=Shape.getPropertiesFromBin(newTri);
    %newTri=Shape.rotate(newTri,90,1);
    newTri.bin=allPixelMoveXY(newTri.bin,ceil(center(2)-tan(pi/3)*length/4),-ceil(center(1)-tan(pi/3)*length/4));
    newTri=Shape.getPropertiesFromBin(newTri);
    newTri.category=0;
end

