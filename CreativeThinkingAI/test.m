% test script
% given an input array, output path
board=logical(zeros(2000,2000));
arrStartingShapes=makeStartingShapes(board,1,1,0);
outputPath='./result_cir_rec/';
% loading imagery space;
imagerySpace=loadImagerySpace();
[~,imageryNum]=size(imagerySpace);
imagerySpace{1,1}{1,10}.orientation=-90;
imagerySpace{1,3}{1,2}.orientation=0;
imagerySpace{1,3}{1,3}.orientation=0;
imagerySpace{1,3}{1,4}.orientation=0;
imagerySpace{1,4}{1,3}.orientation=-60+(52.2121-60);
% imagery result
imageryResultList=cell(1,imageryNum);
imageryResultCoverPercent=zeros(1,imageryNum);
% for each object in imagery space
for imageryTurn=1:imageryNum
    % for each shape A in the shapelist
    shapeAList=imagerySpace{1,imageryTurn};
    [~,shapeANum]=size(shapeAList);
    % list for storing best fitting combFitShape
    bestFittingList=cell(1,shapeANum);
    % list for storing the cover area of the shape Bs
    bestFittingListCover=zeros(1,shapeANum);
    for shapeATurn=1:shapeANum
        % for each shape B in arrStartingShapes
        [~,shapeBNum]=size(arrStartingShapes);
        % list for storing fitting shapelist for each result
        fittingResultList=cell(1,shapeBNum);
        % list for storing cover area for each result
        fittingResultArea=zeros(1,shapeBNum);
        for shapeBTurn=1:shapeBNum
            % fit shape A using many different size shape B (return coverage area and combFitShape)
            [coverArea,combFitShape]=fit(shapeAList{1,shapeATurn},arrStartingShapes{1,shapeBTurn});
            fittingResultArea(1,shapeBTurn)=coverArea;
            fittingResultList{1,shapeBTurn}=combFitShape;
        end
        % pick one shape B that have maximum coverage area, 
        % and the fittingShapeList of this B should be the best fitting of shape A
        [maxCover,maxIndex]=max(fittingResultArea);
        bestFittingList{1,shapeATurn}=fittingResultList{1,maxIndex};
        bestFittingListCover(1,shapeATurn)=maxCover;
    end
    imageryResultCoverPercent(1,imageryTurn)=calculateCoverPercent(bestFittingListCover,shapeAList);
    imageryResultList{1,imageryTurn}=bestFittingList;
end
%topIndex=getTopPercentIndex(imageryResultCoverPercent,5);
topIndex=[1,2,3,4];
printResult(imageryResultList,topIndex,outputPath,imagerySpace);