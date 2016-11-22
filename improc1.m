% Reepjyoti Deka + Atana David
lena = imread('lena.png');
fourierTrans2DLena = fftshift(fft2(lena));
fourierTrans2DLenaAbs = abs(fourierTrans2DLena); 
fourierTrans2DLenaLog = log(fourierTrans2DLenaAbs+1); 
fourierTrans2DLenaGray = mat2gray(fourierTrans2DLenaLog);

filterCustomLPF1 = freqLPF([size(fourierTrans2DLena,1),size(fourierTrans2DLena,2)],0.01);
filteredImage = fourierTrans2DLena .* filterCustomLPF1;

filterCustomLPF2 = freqLPF([size(fourierTrans2DLena,1),size(fourierTrans2DLena,2)],0.05);
filteredImage2 = fourierTrans2DLena .* filterCustomLPF2;

filterCustomLPF3 = freqLPF([size(fourierTrans2DLena,1),size(fourierTrans2DLena,2)],0.1);
filteredImage3 = fourierTrans2DLena .* filterCustomLPF3;

filteredImageSpatial = uint8(ifft2(ifftshift(filteredImage)));
filteredImageSpatial2 = uint8(ifft2(ifftshift(filteredImage2)));
filteredImageSpatial3 = uint8(ifft2(ifftshift(filteredImage3)));


subplot(2,3,1); imshow(lena); title('Original');
subplot(2,3,2); imshow(fourierTrans2DLenaGray); title('Original Spectrum');
subplot(2,3,3); imshow(real(filteredImage3)); title('Filtered Spectrum');

subplot(2,3,4); imshow(filteredImageSpatial); title('fcoupure = 0.01');

subplot(2,3,5); imshow(filteredImageSpatial2); title('fcoupure = 0.05');

subplot(2,3,6); imshow(filteredImageSpatial3); title('fcoupure = 0.1');
