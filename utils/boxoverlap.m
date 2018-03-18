%用来计算两个boxes中box间的重叠系数。元组o中的元素是矩阵，矩阵o{i}代表boxes a和box b(i)之间的交叉系数，size(o{i})=(m,1)。m–表示boxes a中有m个box。而size(o)=n。n–表示boxes b中有n个box，最后返回cell2mat(o)，size为(m,n) 
%这个函数主要在选择产生的roi时会用到，用于选择满足一定重叠系数的roi.
function o = boxoverlap(a, b)
% Compute the symmetric intersection over union overlap between a set of
% bounding boxes in a and a single bounding box in b.
%
% a  a matrix where each row specifies a bounding box
% b  a matrix where each row specifies a bounding box

% AUTORIGHTS
% -------------------------------------------------------
% Copyright (C) 2011-2012 Ross Girshick
% Copyright (C) 2008, 2009, 2010 Pedro Felzenszwalb, Ross Girshick
% 
% This file is part of the voc-releaseX code
% (http://people.cs.uchicago.edu/~rbg/latent/)
% and is available under the terms of an MIT-like license
% provided in COPYING. Please retain this notice and
% COPYING if you use this file (or a portion of it) in
% your project.
% -------------------------------------------------------

o = cell(1, size(b, 1));
for i = 1:size(b, 1)
    x1 = max(a(:,1), b(i,1));
    y1 = max(a(:,2), b(i,2));
    x2 = min(a(:,3), b(i,3));
    y2 = min(a(:,4), b(i,4));

    w = x2-x1+1;
    h = y2-y1+1;
    inter = w.*h;
    aarea = (a(:,3)-a(:,1)+1) .* (a(:,4)-a(:,2)+1);
    barea = (b(i,3)-b(i,1)+1) * (b(i,4)-b(i,2)+1);
    % intersection over union overlap
    o{i} = inter ./ (aarea+barea-inter);
    % set invalid entries to 0 overlap
    o{i}(w <= 0) = 0;
    o{i}(h <= 0) = 0;
end

o = cell2mat(o);
