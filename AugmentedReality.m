%%

%load videoFrames.mat
load('cameraParams.mat', 'cameraParams')
%% 

% create the video writer with 1 fps
writerObj = VideoWriter('myResVideo.avi');
writerObj.FrameRate = 10;
% open the video writer
open(writerObj);

p1 = zeros(200, 2); 
p2 = zeros(200, 2); 
p4 = zeros(200, 2); 
p3 = zeros(200, 2); 

index = 0;
% create figure
figure()

for idxFrame = [100:5:150]
    
    %% Tache N°1 : 
    
     index = index + 1 ; 
     
    v = VideoReader('newNewMarker2.mp4');    
    I = read(v,idxFrame); 
    
    subplot( 2, 3, 1 ); imagesc(I); axis image; axis off; title('Image original');colormap(gray);
     
    [z,BinaryN,Labeled,L] = findSquaresCentoides(I);
    
    subplot( 2, 3, 2 ); imagesc(BinaryN); axis image; axis off; title('Binary Image');colormap(gray);
    subplot( 2, 3, 3 ); imagesc(Labeled); axis image; axis off; title('8 connected Components Labelling ');colormap(gray);
    subplot( 2, 3, 4 ); imagesc(L); axis image; axis off;hold on; title('Centroids detection'); 
    plot ( z(2,:),z(1,:), '+r', 'linewidth', 2);hold off;
 
     if index == 1
        p1(index,:) = [z(1,1), z(2,1)]
        p2(index,:) = [z(1,2), z(2,2)]
        p3(index,:) = [z(1,3), z(2,3)]
        p4(index,:) = [z(1,4), z(2,4)]

     else
    
        p_temp = [0,0]
        for j = 1:4
            if j == 1, p_temp  = [z(1,1), z(2,1)]
            elseif j == 2, p_temp  = [z(1,2), z(2,2)]
            elseif j == 3, p_temp  = [z(1,3), z(2,3)]
            elseif j == 4, p_temp  = [z(1,4), z(2,4)]
            end
            %p_temp
            
            d1 =  sqrt((p_temp(1,1) -p1(index-1,1))^2 + (p_temp(1,2) -p1(index-1,2))^2);
            d2 =  sqrt((p_temp(1,1) -p2(index-1,1))^2 + (p_temp(1,2) -p2(index-1,2))^2);
            d3 =  sqrt((p_temp(1,1) -p3(index-1,1))^2 + (p_temp(1,2) -p3(index-1,2))^2);
            d4 =  sqrt((p_temp(1,1) -p4(index-1,1))^2 + (p_temp(1,2) -p4(index-1,2))^2);
            d = [d1,d2,d3,d4]
            minimum = min(d)
            
            if minimum == d1, p1(index,:) = p_temp(1,:);
            elseif minimum == d2,  p2(index,:) = p_temp(1,:);
            elseif minimum == d3,  p3(index,:) = p_temp(1,:);
            elseif minimum == d4,  p4(index,:) = p_temp(1,:);
            end   
        end
     end

     currentPi1 = p1(index,:);
     currentPi2 = p2(index,:);
     currentPi3 = p3(index,:);
     currentPi4 = p4(index,:);
     
     imagePoints = [currentPi1 ;currentPi2; currentPi3; currentPi4];
     worldPoints = [0 109;0 0;186 108;187 1];
     
     % Extract the intrisic matric Found by MATLAB
     K = cameraParams.IntrinsicMatrix';
     % Find the pose of the camera : Rotation Matrix + Translation Vector
     [R,T] = myExtrinsics(imagePoints,worldPoints,cameraParams); 
     % Computing the projection Matrix
     P = K*[R T];
     

    % Plot the centroid of the 4 colored squares
    set(gcf,'position',[150,50,1000,700])
    subplot( 2, 3, 5 );imagesc(I);hold on;
    plot ( currentPi1(2), currentPi1(1), 'ob', 'linewidth', 1);
    plot ( currentPi2(2), currentPi2(1), 'or', 'linewidth', 1);
    plot ( currentPi3(2), currentPi3(1), 'og', 'linewidth', 1);
    plot ( currentPi4(2), currentPi4(1), 'oy', 'linewidth', 1);
    hold off;
    
    y = 90
    % Compute the projected points of the shape's corners
    mi1 = mapWorldPoints(P,[0;0;y;1]);
    mi2 = mapWorldPoints(P,[186;108;y;1]);
    mi3 = mapWorldPoints(P,[0;109;y;1]);
    mi4 = mapWorldPoints(P,[187;0;y;1]);
    
    % Inserct the lines on the Image
    pos_hexagon=[mi1(2) mi1(1)  mi3(2) mi3(1)  mi4(2) mi4(1) mi2(2) mi2(1) ];
    AR = insertShape(I,'Polygon',{pos_hexagon},'Color', {'red'},'Linewidth',3);
    
    y = 0
    % Compute the projected points of the shape's corners
    mi1 = mapWorldPoints(P,[0;0;y;1]);
    mi2 = mapWorldPoints(P,[186;108;y;1]);
    mi3 = mapWorldPoints(P,[0;109;y;1]);
    mi4 = mapWorldPoints(P,[187;0;y;1]);
    
    % Inserct the lines on the Image
    pos_hexagon=[mi1(2) mi1(1)  mi3(2) mi3(1)  mi4(2) mi4(1) mi2(2) mi2(1) ];
    AR = insertShape(AR,'Polygon',{pos_hexagon},'Color', {'red'},'Linewidth',3);

    % plot the resulting image
    subplot( 2, 3, 6 );imagesc(AR);hold on;
    plot ( mi1(2),mi1(1), 'ob', 'linewidth', 1);
    plot ( mi2(2),mi2(1), 'ob', 'linewidth', 1);
    plot ( mi3(2),mi3(1), 'ob', 'linewidth', 1);
    plot ( mi4(2),mi4(1), 'ob', 'linewidth', 1);

    % write the frames to the video

    %% The following command overwrites the existing video in the folder
    % If you want to save another one uncomment line 75, 14, 15, 17

    writeVideo(writerObj, AR);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                   %%%
    %% :) :) :) The plot takes some time to run, please wait   :) :) :) %%%
    %                                                                   %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%     
    pause(0.0001)

end

    % close the writer object
    close(writerObj);
