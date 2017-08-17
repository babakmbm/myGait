% background extraction Using K-Means Clustering for color images that i am using 
% source: http://uk.mathworks.com/help/images/examples/color-based-segmentation-using-k-means-clustering.html

% personal note: This code uses LAB Color space --- maybe using HSV will be
% better. research is available on Performance of color spaces in
% color image segmentation. e.g. https://arxiv.org/pdf/1506.01472.pdf

function pureImage = backgroundExt(originalImage)

% Read Image
I = imread(originalImage);

% convert the image to LAB colorspace
cform1 = makecform('srgb2lab');
lab_I = applycform(I, cform1);

cform2 = makecform('srgb2xyz');
xyz_I = applycform(I, cform2);

hsv_I = rgb2hsv(I);
% has to be deleted:
figure(1), 
subplot(2,2,1), imshow(I), title('original Image'), 
subplot(2,2,2), imshow(lab_I), title('LAB Image'),
subplot(2,2,3), imshow(xyz_I), title('XYZ Image'),
subplot(2,2,4), imshow(hsv_I), title('hsv Image');

% Classify the Colors in 'a*b*' Space Using K-Means Clustering
ab = double(lab_I(:,:,2:3));
nrows = size(ab, 1);
ncols = size(ab,2);
ab = reshape(ab, nrows*ncols,2);
% repeat the clustering 3 times to avoid local minima
nColors = 3;
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);


% Labeling every pixel in the Image
pixel_labels = reshape(cluster_idx,nrows,ncols);
figure(2),
subplot(2,2,1), imshow(pixel_labels,[]), title('image labeled by cluster index');

% Create Images that Segment the H&E Image by Color.
segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = I;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

subplot(2,2,2), imshow(segmented_images{1}), title('objects in cluster 1');
subplot(2,2,3), imshow(segmented_images{2}), title('objects in cluster 2');
subplot(2,2,4), imshow(segmented_images{3}), title('objects in cluster 3');


% Segment the human color parts into a Separate Image
mean_cluster_value = mean(cluster_center,2);
[tmp, idx] = sort(mean_cluster_value);
Human_cluster_num = idx(3);

L = lab_I(:,:,1);
human_idx = find(pixel_labels == Human_cluster_num);
L_humanColor = L(human_idx);
is_human = imbinarize(L_humanColor);

HumanColor_labels = repmat(uint8(0),[nrows ncols]);
HumanColor_labels(human_idx(is_human==false)) = 1;
HumanColor_labels = repmat(HumanColor_labels,[1 1 3]);
Human_Color = I;
Human_Color(HumanColor_labels ~= 1) = 0;
figure(3), imshow(Human_Color), title('Human Colors');

pureImage = Human_Color;

end