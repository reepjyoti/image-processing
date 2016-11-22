% DEKA, reepjyoti and DAVID, atana iyer.

%% Step 1: Load the image and add noise

originalImage = imread('ic2.tif');
img_dimensions = size(originalImage);
noiseMatrix = uint8(666 * randn(img_dimensions(1)));
ic2Gauss = uint8(originalImage) + noiseMatrix;

figure;
subplot(1,2,1); imshow(originalImage); title('original');
subplot(1,2,2); imshow(ic2Gauss); title('+ Noise');


%% Step 2: denoise

medfilt = medfilt2(ic2Gauss);
avgFilt = imfilter(ic2Gauss, fspecial('average'));
wienerFilt = wiener2(ic2Gauss);

figure;
subplot(2,3,2); imshow(ic2Gauss); title('noise');
subplot(2,3,4); imshow(medfilt); title('median 3x3');
subplot(2,3,5); imshow(avgFilt); title('average 3x3');
subplot(2,3,6); imshow(wienerFilt); title('wiener 3x3');

% Answer: Among the three filters used, the Wiener filter seems to remove most of the
% The edges appear similar in all the three filters. 
% However, on close observation the wiener filtered image has better edge
% detected compared to the others.


%% Step 3: Highlight edge

% GRADIENT METHOD

% Find Gradient
[gradX,gradY] = imgradientxy(medfilt);
% Find norm
grad_norm = sqrt(gradX.^2+gradY.^2)/255;
% Get threshold
level = graythresh(grad_norm);
% Build edge dection image
imgBW = im2bw(grad_norm,level);
imgGR = bwmorph(imgBW,'thin');
% laplacian
mask_laplace = fspecial('laplacian', 0.2);
level = 0.4 * graythresh(filtered_wiener);
laplacian_bw = edge(filtered_wiener,'zerocross',level,mask_laplace);
% Canny Edge Detector
canny_bw = edge(filtered_wiener,'canny');

% Show result
figure;
subplot(3,3,3); imshow(medfilt); title('median');
%intermediate image 
subplot(3,3,1); imshow(imgBW); title('B/W');
%final edge detected images
subplot(3,3,4); imshow(imgGR); title('Gradient');
subplot(3,3,5); imshow(laplacian_bw); title('Laplacian');
subplot(3,3,6); imshow(canny_bw); title('Canny');

% Applying morphological filtering on Canny edge detected image.
figure
MorphedImage = bwmorph(canny_bw, 'thin');
imshow(MorphedImage, []); title(' Canny morphed');

% Answer: The best edge detected image that we observed was from the Canny
% edge detector. The final image has lines that are well connected and clear.

% The morphological operation improves the already edge detected image and
% even removes the slight noises present near the edges.


%% Radon transform

theta = 1:180;
[EdgeRadon,xp] = radon(MorphedImage,theta);
imagesc(theta,xp,EdgeRadon);
title('R_{\theta} (X\prime)');
xlabel('\theta (degrees)');
ylabel('X\prime');
set(gca,'XTick',0:20:180);
colormap(hot);
colorbar

% OPTIONAL SECTION

% Radon transform of a line
line_image = zeros(10,10);
line_image(4,4) = 1;
figure
imshow(line_image); title('Radon Line');
[R_line,xp] = radon(line_image,theta);
imagesc(theta,xp,R_line);
title('R_{\theta} (X\prime)');
xlabel('\theta (degrees)');
ylabel('X\prime');
set(gca,'XTick',0:20:180);
colormap(hot);
colorbar

% Answer Part B Step 4:
% Radon transform of a single line produces an output that has a
% single point of maximum intensity at a certain degree and phase/radial
% coordinates. 

% This is similar to the Hough transorm that plots each line
% to a point in the Hough space depending on the line's orientation which
% includes radial coordinates as well.

% Plotting a single point and transforming it in the radon space produces a
% curve. In the hough space, as a point can be in several lines, it produces
% a curve.

% the sum over any column is always the same as the intensity is always the
% same across each line. 



%% Radon trasnform and observe associated lines
 interactiveLine(MorphedImage,EdgeRadon,5);

%% Find The image orientation and rotate it
max_columns = max(EdgeRadon);
[max_value, max_index] = max(max_columns(1:90) + max_columns(91:180));
RadonEdgeRotated = imrotate(MorphedImage,mod(90, max_index));
figure;
imshow(RadonEdgeRotated, []);title('Rotated Image');

% Answer: It is better to take the maximum value V(1:90)+V(91:180) as this
% would include all the perpendicular lines which are present in the image.
% By adding both we make sure that the optimal rotation angle is less
% imapacted by the noise

% Answer advanced question:
% increasing the noise tends to produce erroneous angle.
% we'll have to have a better noise removal filter to produce expected
% results.