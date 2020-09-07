function [angle, vect] = convert_angles(theta, phi)

A = [0, 0, 1];
B = sph2cart2(theta, phi, 1);

vect=cross(A, B);

if vect == [0, 0, 0]
    vect = B;
end

angle = theta*360/(2*pi);


end
