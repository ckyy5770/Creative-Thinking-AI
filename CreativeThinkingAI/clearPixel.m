function clearPixel(bin)
    [x,y]=size(bin);
    for i=1:x
        for j=1:y
            bin(i,j)=0;
        end
    end
end