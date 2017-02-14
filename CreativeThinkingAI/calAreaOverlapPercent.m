function [ p ] = calAreaOverlapPercent( shapeA, shapeB, areax,areay )
%CALAREAOVERLAPPERCENT Summary of this function goes here
%   Detailed explanation goes here


    setAnd=shapeA.bin&shapeB.bin;
    setOr=shapeA.bin|shapeB.bin;
    setAnd=setAnd(areax(1):areax(2),areay(1):areay(2));
    setOr=setOr(areax(1):areax(2),areay(1):areay(2));
    a=sum(setAnd(:));
    b=sum(setOr(:));
    p=a/b;


end

