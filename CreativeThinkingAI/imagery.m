classdef imagery
    %IMAGERY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        path            % file path
        image           % original image
        shapelist       % a list of shapes containing in this image
                        % (every image has been preprocessed and separated into shapes before AI runs, 
                        % info about these shapes is stored in the disk)
    end
    
    methods
        function obj=imagery(path)
            obj.path=path;
            obj.image=imread(path);
        end
        function obj=readShapeListFromFile(obj)
            shapelistpath=getShapeListPathFromFilePath(pbj.path);
            obj.shapelist=readShapelist(shapelistpath);
        end
    end
    
end

