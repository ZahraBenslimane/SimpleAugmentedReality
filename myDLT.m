function H = myDLT(m1,m2)
% We need at least 4, 2D points, as inputs
% H is a 3*3 matrix
% MyDLT calculates the homography that goes from a pot in the world plane,
% to a pont in the image plane. To acheve this, we need at least 4, 2D
% points
nbPoints = size(m1);
H = zeros(3,3);
A = zeros( 2*nbPoints(1) , 9); % a 6*9 matrix is created to house 
a = zeros(3,9);

for i = 1:length(m1)
    
    M1 = [m1(i,:),1]'; % We use the homogenous coordiantes for m1
    M2 = [m2(i,:),1]'; % and m2
    O3 = [0;0;0];
    a  = [ O3', - M2' ,M1(2)*M2' ; M2', O3' ,- M1(1)*M2' ; - M1(2)*M2' , M1(1)*M2' , O3']; %We calculate the matrix that allows us to calculate the homography
    
    a(1:2 ,: );
    if (i == 1)
       A(i:i+1 ,:) = a(1:2 ,: );
    else 
        A(i*2 - 1:i*2 ,:) = a(1:2 ,: );    
    end
end    
    
[U,S,V] = svd(A); %The SVD command is then used to obtain the homography
A ;
h = V(:,end);
H = [h(1:3)'; h(4:6)';h(7:9)' ];
end


