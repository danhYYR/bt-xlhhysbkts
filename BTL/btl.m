%%
addpath('H:\My Drive\Khang\BK\212\AS3055 - xlhhysbkts\Sample data _ Chapter 04');
addpath('H:\My Drive\Khang\BK\212\AS3055 - xlhhysbkts\Sample data _ Chapter 03');
addpath('H:\My Drive\Khang\BK\212\AS3055 - xlhhysbkts\BTL');

%% Doc anh v�o
% [file_X, folder] = uigetfile({'*.*'}, 'MultiSelect', 'on');
% file = [folder file_X];
% I = imread(file);
clear all;
I = imread('16_test.tif');
if size(I, 3) == 3
    I = rgb2gray(I);
end
% adapthisteq = adapthisteq(I);
% imsharpen = imsharpen(adapthisteq);
figure, imshow(I), title('Anh goc');
%% sharpen

adapthisteq = adapthisteq(I);
imsharpen = imsharpen(adapthisteq);
imshow(imsharpen);
%% inverted contrast

inverted_contrast = abs(255 - imsharpen);
imshow(inverted_contrast);
%% Loc median

median = medfilt2(inverted_contrast, [5 5]);
imshowpair(inverted_contrast, median, 'montage');
%% Lay bi�n
[BWs, nguong] = edge(median, 'Sobel'); 
heso = .4;
BWs = edge(median, 'Sobel', nguong*heso); 
% BWs = edge(median, 'sobel'); 
figure, imshow(BWs), title('Mat na chua bien');

%% L�m d�y bi�n l�n bang ky thuat �Dilate�
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil = imdilate(BWs, [se90 se0]);
figure, imshow(BWsdil), title('Mat na chua bien duoc lam day len');

%% L�m day cac lo trong
BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill), title('L�m day cac lo trong');

%% bo di cac thanh phan sat o bien
% BWnobord = imclearborder(BWdfill, 4);
BWnobord = imclearborder(BWsdil, 4);
% BWnobord = imclearborder(BWs, 4);
figure, imshowpair(BWs, BWnobord, 'montage'), title('bo di cac thanh phan sat o bien');

%% L�m muot bi�n
seD = strel('square', 1); %seD = strel('square',3);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
figure, imshow(BWfinal), title('L�m muot bi�n');

%% Ve duong bien mau trang va hien thi anh len ket qua
BWoutline = bwperim(BWfinal);
Segout = imsharpen;
Segout(BWoutline) = 255;
figure, imshow(Segout), title('Te bao duoc xac dinh');
%%
I = im2double(imread('medtest.png'));

J = regiongrowing(I); 
figure, imshowpair(I, J, 'montage');
