function faster_rcnn_build()
% faster_rcnn_build()
% --------------------------------------------------------
% Faster R-CNN
% Copyright (c) 2015, Shaoqing Ren
% Licensed under The MIT License [see LICENSE for details]
% --------------------------------------------------------

% Compile nms_mex
if ~exist('nms_mex', 'file')
  fprintf('Compiling nms_mex\n');  %当不存在nms_mex文件的时候进行编译，nms过程用C编写，mex编译后供matlab调用

  mex -O -outdir bin ...
      CXXFLAGS="\$CXXFLAGS -std=c++11"  ...
      -largeArrayDims ...
      functions/nms/nms_mex.cpp ...
      -output nms_mex;
end

if ~exist('nms_gpu_mex', 'file')
   fprintf('Compiling nms_gpu_mex\n');
   addpath(fullfile(pwd, 'functions', 'nms'));
   nvmex('functions/nms/nms_gpu_mex.cu', 'bin');
   delete('nms_gpu_mex.o');
end


