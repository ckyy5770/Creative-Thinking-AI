function [ combShape ] = combineShapeList( shapeList, shapeNum )
%COMBINESHAPLIST Summary of this function goes here
%   Detailed explanation goes here
    
    combShape=Shape(shapeList{1,1}.bin);
    
    n=shapeNum;
    for t=2:n
        combShape.bin=combShape.bin|shapeList{1,t}.bin;
    end
        

end

