function imD = dilatation( img, se )
%On réalise une DILATATION morphologique avec se comme élément stucturent.
%tous les point ou la l'intersection entre l'image et l'élément stucturant n'est pas égal à l'enssemble nul
imD = conv2(img,se,'same')>=1;
imD = double(imD);    %% Pour pouvoir faire d'autres opérations morphologiques
end

