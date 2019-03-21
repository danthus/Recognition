function labels = loadLabels(filename)

fp = fopen(filename, 'rb');

magic = fread(fp, 1, 'int32', 0, 'b');

numLabels = fread(fp, 1, 'int32', 0, 'b');

labels = fread(fp, inf, 'unsigned char');

fclose(fp);

labels = categorical(labels);

end
