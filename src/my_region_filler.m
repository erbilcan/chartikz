function [ I_f ] = my_region_filler( I_d, debug_mode )

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

I_f = imfill(I_d, 'holes'); 

if debug_mode == 1
    rf_img = figure; imshow(I_f); title('Region Filling');
end
end