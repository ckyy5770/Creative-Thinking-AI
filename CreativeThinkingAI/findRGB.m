function [ RGBbox ] = findRGB( rgb )
%FINDRGB Summary of this function goes here
%   Detailed explanation goes here
    
    bw=~im2bw(rgb,0.9);
    
    stats=regionprops('table',bw,'Centroid');
    x=round(stats.Centroid(2));
    y=round(stats.Centroid(1));
    
    RGBbox=[rgb(x,y,1),rgb(x,y,2),rgb(x,y,3)];
    

end

