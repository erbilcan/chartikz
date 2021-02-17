 # chartikz - Digitalizing Hand-Drawn Flowcharts
 
 This project is about digitalizing hand-drawn flowcharts. It is written in MATLAB and it uses IPT functions. It basically decomposes the flowchart into smaller components such as rectangles, circles, diamonds, arrows and identifies each component. After that, connection information is extracted and finally the flowchart is re-composed to be drawn with tikz in LaTeX.
 
 ## Assumptions
 
 * Component types are limited to rectangles, diamonds, circles and arrows.
 * Components should not have any text in them.
 * Arrows should only be either in left, up, right or down directions.
 * Arrows should consist of only one straight component.
 * Arrows should not intersect.
 
 # Pipeline
 
1. Obtaining Image
1. Binarization
1. Noise Reduction
   1. Gaussian Filtering
   1. Fill isolated interior pixels
   1. Remove small objects
1. Region Filling
1. Angle Correction
1. Segmentation
1. Classification
1. Connection Analysis
1. Re-composition

## Usage

It is written in MATLAB. 
Its main function is "main_flowchart.m"
```matlab
    I = imread('PATH_TO_IMAGE');
    main_flowchart(I, DEBUG_MODE);
```

If DEBUG_MODE equals 1, the figures created at each step are shown.

tikz commands are written to file located in 'output/tikz_command.tex'.

## Illustration

Obtaining Image

<img src="https://user-images.githubusercontent.com/9055746/53300593-a05a5f00-385a-11e9-8890-247db0543569.png" width="300" height="350">

Binarization

<img src="https://user-images.githubusercontent.com/9055746/53300603-b8ca7980-385a-11e9-8fde-c9ba0be8d692.png" width="300" height="350">

Noise Reduction

<img src="https://user-images.githubusercontent.com/9055746/53300724-098ea200-385c-11e9-94d1-2913c45919c6.png" width="300" height="350">

Region Filling

<img src="https://user-images.githubusercontent.com/9055746/53300776-7144ed00-385c-11e9-8821-6b39dd41f059.png" width="300" height="350">

Angle Correction

<img src="https://user-images.githubusercontent.com/9055746/53300807-b36e2e80-385c-11e9-8abe-8ecb424cc4c7.png" width="300" height="350">

Segmentation
<p float="left">
 <img src="https://user-images.githubusercontent.com/9055746/53300823-e9abae00-385c-11e9-81f3-50b4e60a34de.png" width="300" height="350">
 <img src="https://user-images.githubusercontent.com/9055746/53300821-e57f9080-385c-11e9-8bab-7614a204de19.png" width="300" height="350">
</p>

Classification

<img src="https://user-images.githubusercontent.com/9055746/53300865-80786a80-385d-11e9-9344-cd0f759436d9.png" width="300" height="350">

Connection Analysis

<img src="https://user-images.githubusercontent.com/9055746/53300889-c2091580-385d-11e9-9738-f5e0236a32c9.png" width="300" height="350">

Re-composition

<img src="https://user-images.githubusercontent.com/9055746/53300930-1f9d6200-385e-11e9-8632-e36f5192d4c3.png" width="300" height="350">
