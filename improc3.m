% Reepjyoti Deka + Atana David

% Creating matrix of 256x256 with values = 64
matrix256 = 64.*uint8(ones(256));

% Creating matrix of 64x64 with values = 192
matrix64val192 = 192.*uint8(ones(64));

%placing matrix (64x64) with values 192 at the center of the matrix with values 64 
%and creating matrix256
matrix256(97:160, 97:160) = matrix64val192;

%Creating noise matrix of size 256x256
noiseMatrix = uint8(randn(256))*666;

%adding noise matrix to the matrix256
imageWithNoise = matrix256 + noiseMatrix;

%filtered images

filteredImage1 = medfilt2(imageWithNoise, [2 2]);

filteredImage2 = medfilt2(imageWithNoise, [10 10]);

filteredImage3 = medfilt2(imageWithNoise, [24 24]);


figure
subplot(2,3,1);imshow(matrix256); title('Original image');
subplot(2,3,2);imshow(imageWithNoise); title('Image with Noise');
subplot(2,3,3);imshow(filteredImage1);title('2x2 Filter');
subplot(2,3,4);imshow(filteredImage2);title('10x10 Filter');
subplot(2,3,5);imshow(filteredImage3);title('24x24 Filter');

