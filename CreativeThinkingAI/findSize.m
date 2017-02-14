function [ newB ] = findSize( shapeA,shapeB,curSize,minSize,maxSize,center )
%FINDSIZE Summary of this function goes here
%   Detailed explanation goes here
    maxstep=25;
    scale=1.1;
    
    newB=Shape(shapeB.bin);
    newB=newB.resize(newB,minSize/curSize,center);
    stats=regionprops('table',newB.bin,'BoundingBox');
    newCoverp=calAreaOverlapPercent(shapeA,newB,...
        ceil([stats.BoundingBox(2),stats.BoundingBox(2)+stats.BoundingBox(4)]),...
        ceil([stats.BoundingBox(1),stats.BoundingBox(1)+stats.BoundingBox(3)]));
    
    for i=1:maxstep
        curSize=curSize*1.1;
        if curSize>maxSize
            break;
        end
        temp=Shape(shapeB.bin);
        temp=temp.resize(temp,1.1^i,center);
        stats=regionprops('table',temp.bin,'BoundingBox');
        coverp=calAreaOverlapPercent(shapeA,temp,...
            ceil([stats.BoundingBox(2),stats.BoundingBox(2)+stats.BoundingBox(4)]),...
            ceil([stats.BoundingBox(1),stats.BoundingBox(1)+stats.BoundingBox(3)]));
        if coverp>newCoverp
            newB=temp;
            newCoverp=coverp;
        end
    end

end

