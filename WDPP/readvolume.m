function [data,ChunkSize] =readvolume(path,n,fun)
% read volume:
% path can be folder to files, path to stacked tiff, or h5
% is a z axis multiplier
%
% n is the extenstion factor along z (does not apply if path points to h5).
 

if ~exist('n','var') || isempty(n), n=1; end
if ~exist('fun','var') || isempty(fun), fun=@(x) x; end

ChunkSize = [];

filetype = exist(path,'file');

if  filetype == 2 % if file (here it should be multipage tiff)
    [~,~,ext]=fileparts(path);
    if strcmp(ext,'.tif')
        info = imfinfo(path);
        num_images = numel(info);
        if strcmp(info(1).ColorType,'grayscale')
            data = zeros(info(1).Height,info(1).Width,num_images*n,'single');
        elseif info(1).BitDepth == 24
            data = zeros(info(1).Height,info(1).Width,3,num_images*n,'uint8');
        else
            data = zeros(info(1).Height,info(1).Width,num_images*n,'uint16');
        end
        if ndims(data) == 3
            for k = 1:num_images
                data(:,:,(k-1)*n+1:k*n) = repmat(imread(path, k),[1 1 n]);
            end
        elseif ndims(data) == 4
            for k = 1:num_images
                data(:,:,:,(k-1)*n+1:k*n) = repmat(imread(path, k),[1 1 1 n]);
            end
        end
            
    elseif strcmp(ext,'.h5')
        info=h5info(path); disp(info);
        if ~isempty(info.Datasets) && strcmp(info.Datasets.Name,'stack')
            data = permute(h5read(path,'/stack'),[2 3 1]);
            ChunkSize = info.Datasets.ChunkSize;
        else
            data = h5read(path,'/volume/predictions');
            ChunkSize = info.Groups.Datasets.ChunkSize;
            data = permute(data(1,:,:,:),[2 3 4 1]);
        end
        num_images = size(data,3);
        
        'h5'
    end
else
    if filetype == 7 % if a folder
        filelist = dir(fullfile(path,'*.png'));
        if isempty(filelist), filelist = dir(fullfile(path,'*.tif')); end
    elseif filetype == 0 % will check if path can be parsed from the string
        filelist = dir(path); path=fileparts(path);
    end
    num_images = numel(filelist);
    %keyboard
    sz = size(imread(fullfile(path,filelist(1).name)));
    type = class(imread(fullfile(path,filelist(1).name)));
    if length(sz) == 3
        data = zeros(sz(1),sz(2),sz(3),num_images*n,type);
    else
        data = zeros(sz(1),sz(2),num_images*n,type);
    end
    
    for k = 1:num_images
        if length(sz) == 3
            data(:,:,:,(k-1)*n+1:k*n) = repmat(imread(fullfile(path,filelist(k).name)),[1 1 1 n]);
        else
            data(:,:,(k-1)*n+1:k*n) = repmat(imread(fullfile(path,filelist(k).name)),[1 1 n]);
        end
    end
    
end

for k = 1:num_images
    data(:,:,k) = fun(data(:,:,k));
end







