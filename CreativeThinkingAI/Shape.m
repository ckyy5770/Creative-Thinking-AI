classdef Shape < handle
    %SHAPE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bin             % binary image of the shape
        category        % circle = 1, rectangle = 2, triangle = 3, other = 0
        center          % the center point of the shape
        orientation
        majorAxisLength
        minorAxisLength
        area
        filledArea
        boundingBox
        length          % rectangle specific property
        height          % rectangle specific property
        radii           % circle specific property
    end
    
    methods(Static)
        function obj=Shape(bin)
            obj.bin=bin;
%             obj.category=category;
%             obj.center=center;
%             obj.orientation=orientation;
%             obj.majorAxisLength=majorAxisLength;
%             obj.minorAxisLength=minorAxisLength;
%             obj.area=area;
%             obj.filledArea=filledArea;
%             obj.boundingBox=boundingBox;
        end
        function obj=getPropertiesFromBin(obj)
            stats=regionprops('table',obj.bin,'Centroid','Orientation','MajorAxisLength',...
                'MinorAxisLength','Area','FilledArea','BoundingBox');
            obj.center=stats.Centroid;
            temp=obj.center;
            obj.center=[temp(2),temp(1)];
            obj.orientation=stats.Orientation;
            obj.majorAxisLength=stats.MajorAxisLength;
            obj.minorAxisLength=stats.MinorAxisLength;
            obj.area=stats.Area;
            obj.filledArea=stats.FilledArea;
            obj.boundingBox=stats.BoundingBox;
        end
        function obj=getCategoryFromProps(obj)
            % circle = 1, rectangle = 2, triangle = 3, other = 0
            if (obj.majorAxisLength/obj.minorAxisLength>2)
                % this shape must be a rectangle or other
                % suppose it is a rectangle
                angle=obj.orientation;
                if angle>0
                    rotatedIm=imrotate(obj.bin,180-angle);
                else
                    rotatedIm=imrotate(obj.bin,-angle);
                end
                statsRot=regionprops('table',rotatedIm,'BoundingBox');
                obj.length=max(statsRot.BoundingBox([3,4]));
                obj.height=min(statsRot.BoundingBox([3,4]));
                newRec=drawRec(obj.bin,obj.center,obj.length,obj.height,angle);
                % if 90% area of obj.bin is overlaped with the supposed
                % rectangle, then it is a rectangle. otherwise, it is a
                % 'other' shape
                overlap=calOverlapPercent(obj,newRec);
                if(overlap>=0.85)
                    obj.category=2;
                else
                    obj.category=0;
                end
            else
                % this shape could be a rectangle or a circle or other
                % shape, use both rectangle and circle to fit it, choose
                % better fitting or neither if both are not fitting well
               
                % suppose it is a rectangle
                angle=obj.orientation;
                if angle>0
                    rotatedIm=imrotate(obj.bin,180-angle);
                else
                    rotatedIm=imrotate(obj.bin,-angle);
                end
                statsRot=regionprops('table',rotatedIm,'BoundingBox');
                obj.length=max(statsRot.BoundingBox([3,4]));
                obj.height=min(statsRot.BoundingBox([3,4]));
                newRec=drawRec(obj.bin,obj.center,obj.length,obj.height,angle);
                overlapRecp=calOverlapPercent(obj,newRec);
                
                % suppose it is a circle
                newCir=drawCir(obj.bin,obj.center,(obj.majorAxisLength+obj.minorAxisLength)/4);
                overlapCirp=calOverlapPercent(obj,newCir);
                
                % if one of them fitting 90%+, then choose the better on as the
                % category, else it is a 'other' shape
                if (overlapRecp>0.85 || overlapCirp>0.85)
                    if(overlapRecp>overlapCirp)
                        obj.category=2;
                    else
                        obj.radii=(obj.majorAxisLength+obj.minorAxisLength)/4;
                        obj.category=1;
                    end
                else
                    obj.category=0;
                end 
            end
        end
        function obj=move(obj,angle,length)
            angle=angle/180*pi;
            dx=round(cos(angle)*length);
            dy=round(sin(angle)*length);
            obj.bin=allPixelMoveXY(obj.bin,dx,dy);
            obj=obj.getPropertiesFromBin(obj);
        end
        function obj=rotate(obj,angle,isClock)
            obj=obj.getPropertiesFromBin(obj);
            boundx=[obj.boundingBox(2),obj.boundingBox(2)+obj.boundingBox(4)];
            boundy=[obj.boundingBox(1),obj.boundingBox(1)+obj.boundingBox(3)];
            if isClock
                theta=-angle*(pi/180);
            else
                theta=angle*(pi/180);
            end
            R = [cos(theta) sin(theta);...
                -sin(theta) cos(theta)];
            [a,b]=size(obj.bin);
            newBin=logical(zeros(a,b));
            for i=max(floor(boundx(1)),1):min(ceil(boundx(2)),a)
                for j=max(floor(boundy(1)),1):min(ceil(boundy(2)),b)
                    if obj.bin(i,j)==1
                        coor=R*([j;i]-[obj.center(2);obj.center(1)])+[obj.center(2);obj.center(1)];
                        coor=ceil(coor);
                        if coor(1)<1
                            coor(1)=1;
                        end
                        if coor(2)<1
                            coor(2)=1;
                        end
                        if coor(1)>b;
                            coor(1)=b;
                        end
                        if coor(2)>a
                            coor(2)=a;
                        end
                        newBin(coor(2),coor(1))=true;
                    end
                end
            end
            obj.bin=newBin;
            statsRot=regionprops('table',obj.bin,'FilledImage','BoundingBox');
            %startpoint=obj.findStartPoint(obj);
            obj=obj.replaceRegionWithImage(obj,[ceil(statsRot.BoundingBox(2)),ceil(statsRot.BoundingBox(1))],statsRot.FilledImage{1,1});
            obj=obj.getPropertiesFromBin(obj);
        end
        function [startpoint]=findStartPoint(obj)
            [a,b]=size(obj.bin);
            
            found=0;
            for i=1:a
                for j=1:b
                    if obj.bin(i,j)==1
                        mina=i;
                        found=1;
                        break;
                    end
                end
                if found
                    break;
                end
            end
            found=0;
            for j=1:b
                for i=1:a
                    if obj.bin(i,j)==1
                        minb=j;
                        found=1;
                        break;
                    end
                end
                if found
                    break;
                end
            end
            startpoint=[mina,minb];
        end
        function obj=replaceRegionWithImage(obj,startpoint,img)
            [imga,imgb]=size(img);
            [obja,objb]=size(obj.bin);
            
            startx=startpoint(1);
            endx=min(startpoint(1)+imga-1,obja);
            starty=startpoint(2);
            endy=min(startpoint(2)+imgb-1,objb);
            countx=1;
            for i=startx:endx
                county=1;
                for j=starty:endy
                    obj.bin(i,j)=img(countx,county);
                    county=county+1;
                end
                countx=countx+1;
            end
        end
        function obj=clearBin(obj)
            [x,y]=size(obj.bin);
            obj.bin=logical(zeros(x,y));
        end
        function obj=resize(obj,scale,newCenter)
            [a,b]=size(obj.bin);
            newbin=imresize(obj.bin,scale);
            stats=regionprops('table',newbin,'FilledImage','BoundingBox');
            [height0,length0]=size(stats.FilledImage{1,1});
            obj.bin=logical(zeros(a,b));
            obj=obj.replaceRegionWithImage(obj,[1,1],stats.FilledImage{1,1});
            obj=obj.getPropertiesFromBin(obj);   
            obj.bin=areaMoveXY(obj.bin,ceil(newCenter(2)-obj.center(2)),-ceil(newCenter(1)-obj.center(1)),[1,height0],[1,length0]);
            obj=obj.getPropertiesFromBin(obj);
            
        end
    end
    
end

