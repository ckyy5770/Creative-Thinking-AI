function [ p ] = calculateCoverPercent( coverlist,shapelist )
%CALCULATECOVERPERCENT Summary of this function goes here
%   Detailed explanation goes here

    [~,n]=size(coverlist);
    sumc=0;
    suma=0;
    for i=1:n
        sumc=sumc+coverlist(1,i);
        suma=suma+shapelist{1,i}.area;
    end
    p=sumc/suma;
end

