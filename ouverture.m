function imO = ouverture(img,se)
%OUVERTURE : réalisation d'une EROSION puis d'une DILATATION avec un élement stusturent se 
%   But: supprimer le bruit qu'il ya au fond de l'image 
imO = dilatation( erosion(img, se), se );
imO = double(imO);
end

% Morphological opening is useful for removing small objects from an 
% image while preserving the shape and size of larger objects in the image.