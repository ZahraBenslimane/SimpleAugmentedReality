function [m_image] = mapWorldPoints(P,M_world)
 % Projection of the world points onto the image plane
 m_image_homogenisee = P * M_world;
 % Find the euclidean coordinates of the homogeneous ones
 m_image = [m_image_homogenisee(1)/m_image_homogenisee(3) , m_image_homogenisee(2)/m_image_homogenisee(3)];
end

