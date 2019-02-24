function [ I_d ] = my_noise_reductor( I_c, debug_mode)

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

%Gaussian for denoising after binarization
I_d = imgaussfilt(I_c, 2);

% Make edges more clear
I_d = bwmorph(I_d, 'fill', 1);

% Find the number of ones of the whole image
numOfOnes = sum(I_d(:) == 1);

% Fill small regions (5% of the ones)
regionSize = fix(numOfOnes / 20);
I_d = bwareaopen(I_d, regionSize, 8);

if debug_mode == 1
    nr_img = figure; imshow(I_d); title('Noise Reduction');
end

end