function [overlapArea,combFitShape] = fit( shapeA, shapeB )
%FIT fit shape A using many different size shape B
%   Detailed explanation goes here

%shapeA=Shape.getPropertiesFromBin(shapeA);
%shapeA=Shape.getCategoryFromProps(shapeA);
shapeB=Shape.getPropertiesFromBin(shapeB);
%shapeB=Shape.getCategoryFromProps(shapeB);

tempList=cell(1,100);
count=0;

% if both circle or both rectangle
if shapeA.category==1&&shapeB.category==1 || shapeA.category==2&&shapeB.category==2
    % dup A as the fitting shape
%     ft=Shape(shapeA.bin);
%     ft=ft.getPropertiesFromBin(ft);
%     ft=ft.getCategoryFromProps(ft);
%     combFitShape=ft;
%     overlapArea=ft.area;

    if shapeA.category==1
        ft=drawCir(shapeA.bin,shapeA.center,shapeA.radii);
        ft=ft.getPropertiesFromBin(ft);
        ft=ft.getCategoryFromProps(ft);
        combFitShape=ft;
        overlapArea=ft.area;
    elseif shapeA.category==2
        ft=drawRec(shapeA.bin,shapeA.center,shapeA.length,shapeA.height,shapeA.orientation);
        ft=ft.getPropertiesFromBin(ft);
        ft=ft.getCategoryFromProps(ft);
        combFitShape=ft;
        overlapArea=ft.area;
    end
elseif shapeB.category==2
    % use rectangle to fit anything
    ft=drawRec(shapeA.bin,shapeA.center,shapeA.boundingBox(3),shapeA.boundingBox(4),shapeA.orientation);
    ft=ft.getPropertiesFromBin(ft);
    ft=ft.getCategoryFromProps(ft);
    combFitShape=ft;
    overlapArea=calOverlapArea(shapeA,combFitShape)*0.9;
    
elseif shapeA.category==2&&shapeB.category==1
    % use circle to fit rectangle
    fitLen=shapeA.length;
    radii=shapeA.height/2;
    center=shapeA.center;
    angle=shapeA.orientation;
    
    % first circle
    ft=drawCir(shapeA.bin,center,radii);
    count=count+1;
    tempList{1,1}=ft;
    fitLen=fitLen-radii*2;
    
    % circles
    while(fitLen>radii*2)
        ft=drawCir(shapeA.bin,center,radii);
        ft=ft.move(ft,angle,2*radii*floor((count+1)/2));
        count=count+1;
        tempList{1,count}=ft;
        
        ft=drawCir(shapeA.bin,center,radii);
        ft=ft.move(ft,angle+180,2*radii*floor((count+1)/2));
        count=count+1;
        tempList{1,count}=ft;
        
        fitLen=fitLen-radii*4;
        
    end
    combFitShape=combineShapeList(tempList, count);
    overlapArea=calOverlapArea(shapeA,combFitShape);
    
elseif shapeA.category==2&&shapeB.category==0
    % use unknown shape to fit rectangle
    fitLen=shapeA.length;
    radii=shapeA.height/2;
    center=shapeA.center;
    angle=shapeA.orientation;
    
    % first shapeB
    ft=Shape(shapeA.bin);
    ft=Shape.clearBin(ft);
    
    bin=shapeB.bin;
    stats=regionprops('table',bin,'FilledImage');
    [height0,length0]=size(stats.FilledImage{1,1});
    scale=shapeA.height/length0;
    
    bin=imresize(bin,scale);
    stats=regionprops('table',bin,'FilledImage');
    [height0,length0]=size(stats.FilledImage{1,1});
    ft=ft.replaceRegionWithImage(ft,[1,1],stats.FilledImage{1,1});
    ft=ft.getPropertiesFromBin(ft);
    
    ft.bin=allPixelMoveXY(ft.bin,ceil(center(2)-ft.center(2)),-ceil(center(1)-ft.center(1)));
    ft=ft.rotate(ft,angle-30,0);
    
    count=count+1;
    tempList{1,1}=ft;
    fitLen=fitLen-length0;
    
    % shape Bs
    while(fitLen>length0/2)
        % 1
        ft=Shape(shapeA.bin);
        ft=Shape.clearBin(ft);
        
        ft.bin=shapeB.bin;
        stats=regionprops('table',ft.bin,'FilledImage');
        [height0,length0]=size(stats.FilledImage{1,1});
        scale=shapeA.height/length0;
        
        ft=ft.resize(ft,scale,center);
        length0=length0*scale;
        ft=ft.rotate(ft,angle-30,0);
        
        ft=ft.move(ft,angle,length0*floor((count+1)/2));
        count=count+1;
        tempList{1,count}=ft;
        
        % 2
        ft=Shape(shapeA.bin);
        ft=Shape.clearBin(ft);
        
        ft.bin=shapeB.bin;
        stats=regionprops('table',ft.bin,'FilledImage');
        [height0,length0]=size(stats.FilledImage{1,1});
        scale=shapeA.height/length0;
        
        ft=ft.resize(ft,scale,center);
        length0=length0*scale;
        ft=ft.rotate(ft,angle-30,0);
 
        ft=ft.move(ft,angle+180,length0*floor((count+1)/2));
        count=count+1;
        tempList{1,count}=ft;
        
        fitLen=fitLen-length0*2;
    end
    combFitShape=combineShapeList(tempList, count);
    overlapArea=calOverlapArea(shapeA,combFitShape);
else
    % general algorithm
    % use unknown shapeB to fit unknown shapeA
    fitLen=shapeA.majorAxisLength;
    scaleLen=shapeA.minorAxisLength;
    angle=shapeA.orientation;
    center=shapeA.center;
    fitLen_0=shapeA.majorAxisLength/2;
    fitLen_180=shapeA.majorAxisLength/2;
    
    
    % first shapeB
    ft=Shape(shapeA.bin);
    ft=Shape.clearBin(ft);
    
    ft.bin=shapeB.bin;
    stats=regionprops('table',ft.bin,'FilledImage','MajorAxisLength');
    [height0,length0]=size(stats.FilledImage{1,1});
    major_old=stats.MajorAxisLength;
    ft=ft.rotate(ft,angle,0);
    
    ft = findSize( shapeA,ft,length0,shapeA.minorAxisLength/2,shapeA.majorAxisLength,center);
    ft=ft.getPropertiesFromBin(ft);
    major_new=ft.majorAxisLength;
    length0=length0*major_new/major_old;
    
    count=count+1;
    tempList{1,count}=ft;
    fitLen_0=fitLen_0-length0/2;
    fitLen_180=fitLen_180-length0/2;
    
    lastLen_0=length0/2;
    lastLen_180=length0/2;
    % shape Bs
    % right side
    while(fitLen_0>shapeA.minorAxisLength/2)
        % 1
        ft=Shape(shapeA.bin);
        ft=Shape.clearBin(ft);
        
        ft.bin=shapeB.bin;
        stats=regionprops('table',ft.bin,'FilledImage','MajorAxisLength');
        [height0,length0]=size(stats.FilledImage{1,1});
        major_old=stats.MajorAxisLength;
        ft=ft.rotate(ft,angle,0);
        
        % find new center
        length=lastLen_0+shapeA.minorAxisLength/2;
        angle=angle/180*pi;
        dx=round(cos(angle)*length);
        dy=round(sin(angle)*length);
        center=center+[-dy,+dx];
        
        ft = findSize( shapeA,ft,length0,shapeA.minorAxisLength/2,shapeA.majorAxisLength,center);
        ft=ft.getPropertiesFromBin(ft);
        major_new=ft.majorAxisLength;
        length0=length0*major_new/major_old;
        
        fitLen_0=fitLen_0-length0/2-max(length0/2,shapeA.minorAxisLength/2);
        lastLen_0=length0/2;
        
        count=count+1;
        tempList{1,count}=ft;
        
    end
    % left side
    while(fitLen_180>shapeA.minorAxisLength/2)
        % 1
        ft=Shape(shapeA.bin);
        ft=Shape.clearBin(ft);
        
        ft.bin=shapeB.bin;
        stats=regionprops('table',ft.bin,'FilledImage','MajorAxisLength');
        [height0,length0]=size(stats.FilledImage{1,1});
        major_old=stats.MajorAxisLength;
        ft=ft.rotate(ft,angle,0);
        
        % find new center
        length=lastLen_180+shapeA.minorAxisLength/2;
        angle=(angle+180)/180*pi;
        dx=round(cos(angle)*length);
        dy=round(sin(angle)*length);
        center=center+[-dy,+dx];
        
        ft = findSize( shapeA,ft,length0,shapeA.minorAxisLength/2,shapeA.majorAxisLength,center);
        ft=ft.getPropertiesFromBin(ft);
        major_new=ft.majorAxisLength;
        length0=length0*major_new/major_old;
        
        fitLen_180=fitLen_180-length0/2-max(length0/2,shapeA.minorAxisLength/2);
        lastLen_180=length0/2;
        
        count=count+1;
        tempList{1,count}=ft;
        
    end
    
    combFitShape=combineShapeList(tempList, count);
    overlapArea=calOverlapArea(shapeA,combFitShape);
    
    

end

end

