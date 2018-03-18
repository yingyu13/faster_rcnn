%prep_im_for_blob.m 根据输入图片，图片均值，目标尺寸，返回目标图片和缩放系数。 
%prep_im_for_blob_size.m 按输入图片的尺寸和目标尺寸，返回尺寸缩放系数。
function [im, im_scale] = prep_im_for_blob(im, im_means, target_size, max_size)
    im = single(im);
    
    if ~isa(im, 'gpuArray')   %判断im是否为cuda可以处理的gpuArray类型的对象
        try
            im = bsxfun(@minus, im, im_means);
        catch
            im_means = imresize(im_means, [size(im, 1), size(im, 2)], 'bilinear', 'antialiasing', false);    
            im = bsxfun(@minus, im, im_means);
        end
        im_scale = prep_im_for_blob_size(size(im), target_size, max_size);

        target_size = round([size(im, 1), size(im, 2)] * im_scale);
        im = imresize(im, target_size, 'bilinear', 'antialiasing', false);
    else
        % for im as gpuArray
        try
            im = bsxfun(@minus, im, im_means);
        catch
            im_means_scale = max(double(size(im, 1)) / size(im_means, 1), double(size(im, 2)) / size(im_means, 2));
            im_means = imresize(im_means, im_means_scale);    
            y_start = floor((size(im_means, 1) - size(im, 1)) / 2) + 1;
            x_start = floor((size(im_means, 2) - size(im, 2)) / 2) + 1;
            im_means = im_means(y_start:(y_start+size(im, 1)-1), x_start:(x_start+size(im, 2)-1));
            im = bsxfun(@minus, im, im_means);
        end
        
        im_scale = prep_im_for_blob_size(size(im), target_size, max_size);
        im = imresize(im, im_scale);
    end
end
