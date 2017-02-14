function [ arr ] = makeStartingShapes( board,cir,rec,tri )
%MAKESTARTINGSHAPES Summary of this function goes here
%   Detailed explanation goes here
    
    num=cir+rec+tri;
    arr=cell(1,num);
    
    count=0;
    if cir==1
        newCir=drawCir(board,[1000,1000],100);
        count=count+1;
        arr{1,count}=newCir;
    end
    if rec==1
        newRec=drawRec(board,[1000,1000],200,50,0);
        count=count+1;
        arr{1,count}=newRec;
    end
    if tri==1
        newTri=drawTri(board,[1000,1000],100);
        count=count+1;
        arr{1,count}=newTri;
    end
    
    
end

