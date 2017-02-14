function [  ] = printResult( relist,index,outputPath,space )
%PRINTRESULT Summary of this function goes here
%   Detailed explanation goes here

    for i=index
        name=strcat(outputPath,num2str(i),'.png');
        shapelist=relist{1,i};
        printOne(shapelist,space{1,i}(2,:),name);
    end
end

