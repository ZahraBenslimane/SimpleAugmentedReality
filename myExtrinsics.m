function [rotationMatrix,translationVector] = myExtrinsics(imagePoints,worldPoints,cameraParams)

K = cameraParams.IntrinsicMatrix'; % We load the matrix containing the intisic parameters
H = myDLT(imagePoints,worldPoints); % We then calculate the homography that transforms a pont in the world plane to its equivalent in the image plane.

r1 = inv(K)*H(:,1); % We calculate the first two colomns 
r2 = inv(K)*H(:,2); % of the rotation matrix that are actually multiplied by a factor lamda
                   % r3 is unnecessary at this pont beacause we assume we
                   % are at a level where z=0

format long
R_prime = [r1, r2, cross(r1,r2)]; % the cross product between r1 and r2 columns, gves us the third colum r3 of the rotation matrix.

lamda4 = det(R_prime); %We calculate the factor lamda s we can backtrack and recalcultae
lamda  = nthroot(lamda4, 4);

rotationMatrix = [r1./lamda r2./lamda cross(r1./lamda,r2./lamda)]; % By taking out the factor lamda out of the equation we get the final form of the rotation matrix
translationVector = (inv(K)*H(:,3))./lamda ;

if translationVector(3) < 0 % if the z vector is inversed, this conditon allows us to take that into account
   translationVector = (inv(K)*H(:, 3))./(-lamda); 
   rotationMatrix = [r1./(-lamda) r2./(-lamda) cross(r1,r2)/lamda^2];
end
end

