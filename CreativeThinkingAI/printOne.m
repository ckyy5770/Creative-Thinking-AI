function [  ] = printOne( shapelist,colorlist,path )
%PRINT Summary of this function goes here
%   Detailed explanation goes here

    %shapelist{1,1}=Shape.rotate(shapelist{1,1},180,1);

    [~,n]=size(shapelist);
    [a,b]=size(shapelist{1,1}.bin);
    board=uint8(zeros(a,b,3));
    
    for i=1:n
        curShape=shapelist{1,i};
        curShape=Shape.getPropertiesFromBin(curShape);
        x=floor(min(curShape.boundingBox(:,2)));
        dx=ceil(max(curShape.boundingBox(:,4)));
        y=floor(min(curShape.boundingBox(:,1)));
        dy=ceil(max(curShape.boundingBox(:,3)));
        
        for s=max(1,1):min(a,a)
            for t=max(1,1):min(b,b)
                if curShape.bin(s,t)
                    board(s,t,1)=colorlist{i}(1,1);
                    board(s,t,2)=colorlist{i}(1,2);
                    board(s,t,3)=colorlist{i}(1,3);
                end
            end
        end
        
    end
    imwrite(board,path);

end

