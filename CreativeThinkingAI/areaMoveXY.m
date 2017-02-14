function [ newbin ] = areaMoveXY( bin,dx,dy,areax,areay )
%AREAMOVEXY Summary of this function goes here
%   Detailed explanation goes here
    [a,b]=size(bin);
    newbin=logical(zeros(a,b));
    for i=max(floor(areax(1)),1):min(ceil(areax(2)),a)
        for j=max(floor(areay(1)),1):min(ceil(areay(2)),a)
            if bin(i,j)==1
                if(i-dy)>0&&(j+dx)>0&&(i-dy)<a&&(j+dx)<b
                    newbin(i-dy,j+dx)=1;
                end
            end
        end
    end

end

