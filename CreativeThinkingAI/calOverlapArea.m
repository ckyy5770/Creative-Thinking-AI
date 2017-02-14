function [ area ] = calOverlapArea( shapeA,shapeB )
%CALOVERLAPAREA Summary of this function goes here
%   Detailed explanation goes here
% 
% 
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
    
    s=shapeA.bin&shapeB.bin;
    %stats=regionprops('table',s,'Area');
    %area=stats.Area;
    area=sum(s(:));

end

