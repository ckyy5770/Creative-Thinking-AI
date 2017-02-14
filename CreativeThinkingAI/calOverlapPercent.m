function [ p ] = calOverlapPercent( shapeA, shapeB)
%COVERAREA Summary of this function goes here
%   Detailed explanation goes here

%     [a,b]=size(shapeA.bin);
%     
%     area=0;
%     for i=1:a
%         for j=1:b
%             if shapeA.bin(i,j)&&shapeB.bin(i,j)
%                 area=area+1;
%             end
%         end
%     end
%     

    setAnd=shapeA.bin&shapeB.bin;
    setOr=shapeA.bin|shapeB.bin;
    a=sum(setAnd(:));
    b=sum(setOr(:));
    p=a/b;

end

