%Read the image
img = imread('course1image.jpg');
[h,w] = size(img);
r = floor(h / 3);
c = w;

B = img(1:r, :);
G = img(r+1:2*r, :);
R = img(2*r+1:3*r, :);

% Extract 51x51 patch from center of Green
centerX = round(size(G,2)/2);
centerY = round(size(G,1)/2);
ref_img_region = G(centerY-25:centerY+25, centerX-25:centerX+25);
ref_img_region=double(ref_img_region)

function [best_dy, best_dx] = alignment(channel, ref_patch)
    channel = double(channel);
    min_ssd = inf;
    best_dx = 0;
    best_dy = 0;

    for dx = -10:10
        for dy = -10:10
            shifted = circshift(channel, [dy, dx]);

            centerX = round(size(shifted,2)/2);
            centerY = round(size(shifted,1)/2);
            patch = shifted(centerY-25:centerY+25, centerX-25:centerX+25);

            ssd = sum((patch - ref_patch).^2, 'all');
            if ssd < min_ssd
                min_ssd = ssd;
                best_dx = dx;
                best_dy = dy;
            end
        end
    end
end

[dy_R, dx_R] = alignment(R, ref_img_region);
[dy_B, dx_B] = alignment(B, ref_img_region);

R_aligned = circshift(R, [dy_R, dx_R]);
B_aligned = circshift(B, [dy_B, dx_B]);

ColorImg_aligned = cat(3, uint8(R_aligned), uint8(G), uint8(B_aligned));
imshow(ColorImg_aligned);
