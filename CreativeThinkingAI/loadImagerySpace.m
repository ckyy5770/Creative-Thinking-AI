function [ imagerySpace ] = loadImagerySpace()
%LOADIMAGERYSPACE Summary of this function goes here
%   Detailed explanation goes here

% imagerySpace:
% shapelist1,shapelist2,...;
% name1,name2,...;
imagerySpace=cell(2,4);

% shapelist:
% shape1,shape2,...;
% color1,color2,...;
% area1,area2,...;

% android
imagerySpace{2,1}='android';
imagerySpace{1,1}=cell(3,10);
for i=1:10
    temp=Shape(0);
    rgb=imread(strcat('./pics/android/',num2str(i),'.png'));
    RGBbox=findRGB(rgb);
    bw=~im2bw(rgb,0.9);
    temp.bin=bw;
    temp=temp.getPropertiesFromBin(temp);
    temp=temp.getCategoryFromProps(temp);
    
    area=temp.area;
    
    imagerySpace{1,1}{1,i}=temp;
    imagerySpace{1,1}{2,i}=RGBbox;
    imagerySpace{1,1}{3,i}=area;

end

% iphone
imagerySpace{2,2}='iphone';
imagerySpace{1,2}=cell(3,5);
for i=1:5
    temp=Shape(0);
    rgb=imread(strcat('./pics/iphone/',num2str(i),'.png'));
    RGBbox=findRGB(rgb);
    bw=~im2bw(rgb,0.9);
    temp.bin=bw;
    temp=temp.getPropertiesFromBin(temp);
    temp=temp.getCategoryFromProps(temp);
    
    area=temp.area;
    
    imagerySpace{1,2}{1,i}=temp;
    imagerySpace{1,2}{2,i}=RGBbox;
    imagerySpace{1,2}{3,i}=area;

end


% tree
imagerySpace{2,3}='tree';
imagerySpace{1,3}=cell(3,10);
for i=1:10
    temp=Shape(0);
    rgb=imread(strcat('./pics/tree/',num2str(i),'.png'));
    RGBbox=findRGB(rgb);
    bw=~im2bw(rgb,0.9);
    temp.bin=bw;
    temp=temp.getPropertiesFromBin(temp);
    temp=temp.getCategoryFromProps(temp);
    
    area=temp.area;
    
    imagerySpace{1,3}{1,i}=temp;
    imagerySpace{1,3}{2,i}=RGBbox;
    imagerySpace{1,3}{3,i}=area;

end


% cat
imagerySpace{2,4}='cat';
imagerySpace{1,4}=cell(3,12);
for i=1:12
    temp=Shape(0);
    rgb=imread(strcat('./pics/cat/',num2str(i),'.png'));
    RGBbox=findRGB(rgb);
    bw=~im2bw(rgb,0.9);
    temp.bin=bw;
    temp=temp.getPropertiesFromBin(temp);
    temp=temp.getCategoryFromProps(temp);
    
    area=temp.area;
    
    imagerySpace{1,4}{1,i}=temp;
    imagerySpace{1,4}{2,i}=RGBbox;
    imagerySpace{1,4}{3,i}=area;

end

end

