function [g,taille] = findCentoid(Image)
    % g =[x,y]  the blob centroid
    maskIm = Image == 1;
    taille = sum( maskIm(:) );  % blob size 
    [x, y] = find( maskIm );    % Find the indices of each pixel equal to 1 
    g(1) = mean(x);          % x coordinate of the blob centroid 
    g(2) = mean(y);          % y coordinate of the blob centroid 
end

