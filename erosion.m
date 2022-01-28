function imE = erosion( img, se)
%On réalise une EROSION morphologique avec se comme élément stucturent.

nSE = sum( se(:) );    %Nombre de pixels à 1 dans l'élément structurant
imE = conv2( img, se, 'same' ) == nSE;
imE = double(imE);
end

