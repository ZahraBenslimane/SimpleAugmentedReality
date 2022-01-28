function imF = fermeture(img,se)
%FERMETURE :  réalisation d'une DILATATION puis d'une EROSION avec un élement stusturent se 
%   But: suprimer le bruit qu'il y a sur les objets 
imF = erosion( dilatation(img, se), se );
imF = double(imF);
end

% Morphological closing is useful for filling small holes from an image
% while preserving the shape and size of the objects in the image.