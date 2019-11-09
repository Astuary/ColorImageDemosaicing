% Path to your data directory
dataDir = fullfile('..','data','demosaic');

% Path to your output directory
outDir = fullfile('..','output','demosaic');
if ~exist(outDir, 'file')
    mkdir(outDir);
    endcl
end

imageNames = {'balloon.jpeg',	'cat.jpg',	'ip.jpg','puppy.jpg','squirrel.jpg', ...
              'pencils.jpg',	'house.png', 'light.png', 'sails.png', 'tree.jpeg'};
numImages = length(imageNames);

methods = {'linear'};
numMethods = length(methods);

display = false;
error = zeros(81, 1);

fprintf([repmat('-',[1 100]),'\n']); 
fprintf('# \t image \t\t linear \n'); 
fprintf([repmat('-',[1 100]),'\n']); 
for i = 1:numImages
    fprintf('%i \t %s ', i, imageNames{i});
    for j = 1:numMethods
        thisImage = fullfile(dataDir, imageNames{i});
        thisMethod = methods{j};
        
        srcImage = imread(thisImage);
        gt = im2double(srcImage);

        err = demosaicBruteForce(srcImage);
        error = error + err;
        %pixelError = abs(gt - output);
        %error = mean(mean(mean(pixelError)));
        fprintf('\t %f ', err); 
        
        % Write the output
        outfileName = fullfile(outDir, [imageNames{i}(1:end-5) '-' thisMethod '-bf.jpg']);
        %imwrite(colorIm, outfileName);
        
    end
    fprintf('\n');
end
fprintf('\t %f ', error/numImages);
sort(error/numImages)
