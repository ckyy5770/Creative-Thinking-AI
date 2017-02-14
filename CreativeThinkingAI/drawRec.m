function [ newRec ] = drawRec( board,center, length,height,angle )
%DRAWREC Summary of this function goes here
%   Detailed explanation goes here
    [a,b]=size(board);
    newBoard=logical(zeros(a,b));
    newRec=Shape(newBoard);
    for i=1:round(height)
        for j=1:round(length)
            newRec.bin(i,j)=1;
        end
    end
    newRec.bin=areaMoveXY(newRec.bin,ceil(center(2)-length/2),-ceil(center(1)-height/2),[1,round(height)],[1,round(length)]);
    newRec=Shape.getPropertiesFromBin(newRec);
    newRec=Shape.rotate(newRec,angle,0);
    newRec.category=2;
    newRec.length=length;
    newRec.height=height;
end

