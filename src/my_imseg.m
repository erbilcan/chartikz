function [ I_seg, I_arrows ] = my_imseg( I_ac, debug_mode )

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

% Trying to find SE size (1/60 of the width)
[oSizeX, oSizeY] = size(I_ac);
oSizeX = fix(oSizeX/75);

% Apply openning (erosion followed by a dilation)
% Used disk for avoid shape corruptions
seopen = strel('disk', oSizeX, 8);
I_seg = imopen(I_ac, seopen);

% Subtract shapes from the original image to get arrows
I_arrows = im2bw(imsubtract(I_ac,I_seg));

% Apply opening to arrows
seopen = strel('disk', 8, 4);
I_arrows = imopen(I_arrows, seopen);

% Apply region filling  due to corner issues (5% again)
numOfOnes = sum(I_arrows(:) == 1);
regionSizeArrows = fix(numOfOnes / 20);
I_arrows = bwareaopen(I_arrows, regionSizeArrows, 8);

if debug_mode == 1
    shapes_img = figure; imshow(I_seg); title('Shapes');
    arrows_img = figure; imshow(I_arrows); title('Arrows');
end

end

