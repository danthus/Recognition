function images = loadImages(filename)

fp = fopen(filename);

magic = fread(fp, 1, 'int32', 0, 'b');

numImages = fread(fp, 1, 'int32', 0, 'b');
numRows = fread(fp, 1, 'int32', 0, 'b');
numCols = fread(fp, 1, 'int32', 0, 'b');

images = fread(fp, inf, 'unsigned char');
images = reshape(images, numCols, numRows, numImages);
images = permute(images,[2 1 3]);

fclose(fp);

end
