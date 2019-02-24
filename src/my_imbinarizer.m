function [ I_c ] = my_imbinarizer( I, debug_mode )

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

I = rgb2gray(I);
I = imgaussfilt(I, 3);

% Apply adaptive thresholding
% I_t = blockproc(I, [5 5], @adapt_thresh); 
T = adaptthresh(I,'ForegroundPolarity','dark');
I_t = imbinarize(I,T);
I_c = imcomplement(I_t);
I_c = uint8(I_c * 255);

if debug_mode == 1
    org_img = figure; imshow(I); title('Original Image');
    bin_img = figure; imshow(I_t); title('Binary Image');
    bin_inv_img = figure; imshow(I_c); title('Binary Image Inverted');
end

end