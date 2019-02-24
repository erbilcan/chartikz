function [ I_ac ] = my_angle_corrector( I_f, debug_mode )

switch nargin
  case 0
    error('Image argument is missing.');
  case 1
    debug_mode = 0;
  case 2
      if debug_mode ~= 0
          debug_mode = 1;
      end
  otherwise
    error('1 or 2 inputs are accepted.')
end

I_canny = edge(I_f, 'canny');

% Find Hough transformation
[H,theta,rho] = hough(I_canny);

% Find first 10 hough peaks
P = houghpeaks(H,10);

% Find peaks angle using P
angle = majority_vote_angles(P);

% for \ type
if angle > 95
   angle = angle - 180; 
end

% Rotate
I_ac = imrotate(I_f,angle);

if debug_mode == 1
    ac_img = figure; imshow(I_ac); title('Angle correction');
end

end

