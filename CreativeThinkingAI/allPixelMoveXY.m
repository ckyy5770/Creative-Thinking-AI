function newbin = allPixelMoveXY(bin,dx,dy)
    [x,y]=size(bin);
    newbin=logical(zeros(x,y));
    for i=1:x
        for j=1:y
            if bin(i,j)==1
                if(i-dy)>0&&(j+dx)>0&&(i-dy)<x&&(j+dx)<y
                    newbin(i-dy,j+dx)=1;
                end
            end
        end
    end
end