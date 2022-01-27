%% COMPUTER VISION 
close all;
clc;

%% If the video frames are not yet extracted, run this following command.
%videoFrames = extractFrames('projet_fond_noir.mp4');

%%
load videoFrames.mat
load('cameraParams.mat', 'cameraParams')
%% 

% % create the video writer with 1 fps
% writerObj = VideoWriter('myResVideo.avi');
% writerObj.FrameRate = 10;
% % open the video writer
% open(writerObj);

index = 1;
% create figure
figure()

for idxFrame = [1:5:435]
    
    %% Tache N°1 : 
    
     index = index + 1 ;  
     I = videoFrames{idxFrame};
     [redCentroid,greenCentroid,blueCentroid,yellowCentroid] = findImagePoints(I);
          
     imagePoints = [redCentroid;greenCentroid;blueCentroid;yellowCentroid];
     worldPoints = [0 0;186 108;0 109;187 1];
     % Extract the intrisic matric Found by MATLAB
     K = cameraParams.IntrinsicMatrix';
     % Find the pose of the camera : Rotation Matrix + Translation Vector
     [R,T] = myExtrinsics(imagePoints,worldPoints,cameraParams); 
     % Computing the projection Matrix
     P = K*[R T];

    % Pot the centroid of the 4 colored squares
    set(gcf,'position',[150,50,1000,700])
    subplot( 1, 2, 1 );imagesc(I);hold on;
    plot ( redCentroid(2), redCentroid(1), 'ob', 'linewidth', 1);
    plot ( greenCentroid(2), greenCentroid(1), 'ob', 'linewidth', 1);
    plot ( blueCentroid(2), blueCentroid(1), 'ob', 'linewidth', 1);
    plot ( yellowCentroid(2), yellowCentroid(1), 'ob', 'linewidth', 1);
    
    % plot the first base of the 3D object 
    pos_hexagon=[redCentroid(2) redCentroid(1) blueCentroid(2) blueCentroid(1) greenCentroid(2) greenCentroid(1)  yellowCentroid(2) yellowCentroid(1) ];
    RGB = insertShape(I,'FilledPolygon',{pos_hexagon},'Color', {'green'},'Opacity',0.5);
     
    % Plot multiple stacked lines alors the z axis
     for z = 1:2:50
         % Compute the projected points of the shape's corners
         miRed   = mapWorldPoints(P,[0;0;z;1]);
         miGreen = mapWorldPoints(P,[186;108;z;1]);
         miBlue  = mapWorldPoints(P,[0;109;z;1]);
         miYellow = mapWorldPoints(P,[187;0;z;1]);
         % Inserct the lines on the Image
         pos_hexagon=[miRed(2) miRed(1) miBlue(2) miBlue(1) miGreen(2) miGreen(1)  miYellow(2) miYellow(1) ];
         RGB = insertShape(RGB,'Polygon',{pos_hexagon},'Color', {'red'},'Linewidth',3);
     end
        % Insert the last filled base on the image
         pos_hexagon=[miRed(2) miRed(1) miBlue(2) miBlue(1) miGreen(2) miGreen(1)  miYellow(2) miYellow(1) ];
         RGB = insertShape(RGB,'FilledPolygon',{pos_hexagon},'Color', {'green'},'Opacity',0.9);
     
     % plot the resulting image
     subplot( 1, 2, 2 );imagesc(RGB);
     
     % write the frames to the video
     
     %% The following command overwrites the existing video in the folder
     % If you want to save another one uncomment line 75, 14, 15, 17
     
     % writeVideo(writerObj, RGB);
     
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

