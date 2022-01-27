function [z,BinaryN,RGB,L] = findSquaresCentoides(I)
%Conversion de l'image original codée RGB vers une image codée en niveau de gris 
    N= ( I(:,:,1)+ I(:,:,2) + I(:,:,3))/3;  %calcul du plan Niveau de gris
    % Calcule de deux masques dérivateurs gaussiens suivant x et y
    dGx=dGausse(1); 
    Nx = conv2(double(N),dGx,'same');    % dérivée en x de N
    Ny = conv2(double(N),dGx','same');    % dérivée en y de N  : transposée de celle de X
    Norme_gradient= sqrt(Nx.^2 + Ny.^2); %% calcul de la norme du gradient
    
    %calcul de l'image binaire avecc un Threshold
    BinaryN = Norme_gradient > 0.1 * max(Norme_gradient(:))   %0.1 * max(Norme_gradient(:));
      
    sueil= 0.4;  %seuil optimal pour extraire les contours. 10%
    BinaryN = im2bw(I,sueil) % image binaire où les contours valent 1
    
    subplot( 2, 3, 2 ); imagesc(BinaryN); axis image; axis off; title(' Before morphology');colormap(gray);  
    % Element structurent usilisé pour les marphologies mathématiques
    SE3 = ones(3);SE5 = ones(5);
    BinaryN = fermeture (fermeture( ouverture( fermeture(BinaryN,SE3) , SE5 ) ,SE5),SE5 )
    % Reverse image
    BinaryN = 1-BinaryN
    
    subplot( 2, 3, 3 ); imagesc(BinaryN); axis image; axis off; title(' Edge Detection : Binary image');colormap(gray);
    
    [L,Nreg] = bwlabel(BinaryN);
    fprintf("Nombre d'objets detectes : %d\n",Nreg); % Code analyzer
    %Image affichant chaque region avec une couleur specifique
    RGB = label2rgb(L);

    taille = zeros( 1, Nreg ); % Vecteur tailles des objets
    g = zeros(2, Nreg);        % Vecteur coordonnees centres de gravité 

    %Pour chaque région détectée on détecte les coordonées des centroids 
    for j=1:1:Nreg
       maskL = L == j;  %matrice contenant que les pixel de la région i
       taille (j) = sum( maskL(:) );% taille d'un objet détecté  
       [x, y] = find( maskL );    % trouver les indices de chaque pixel à 1 de l'objet
       g(1,j) = mean(x);          % coordonées en x du centre de gravité de l'objet
       g(2,j) = mean(y);          % coordonées en y du centre de gravité de l'objet
       
    end
    
    c = zeros(2, Nreg); 
    epsilon = 10; %tolérence distance entre deux centroides
    
    for i=1:Nreg
        x = g(1,i);
        y = g(2,i);
        for j= [1:i-1 i+1:Nreg]
            d =  sqrt((x-g(1,j))^2 + (y-g(2,j))^2);   
            if (d < epsilon )
              c(1,i) = g(1,i);          
              c(2,i) = g(2,i);
            end
        end
    end

    z = c;  

    for i=1:Nreg
        zx = z(1,i);
        zy = z(2,i);
        for j= i+1:Nreg
            d =  sqrt((zx-z(1,j))^2 + (zy-z(2,j))^2);   
            if (d < epsilon )
              zold = z(1,i);
              znex = z(1,j);
              zold2 = z(2,i);
              znex2 = z(2,j); 
              z(1,j) = z(1,i);          
              z(2,j) = z(2,i);
            end
        end
    end

    z1 = unique(z(1,:),'stable');
    z2 = unique(z(2,:),'stable');

    zf = [z1;z2];
    z = zeros(2, 4);
    
    zligne  = zf(1,:); zcolone = zf(2,:);
    z(1,:) = zligne(zligne~=0); z(2,:) = zcolone(zcolone~=0);
    
end

