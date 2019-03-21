for i = 1:12
    subplot(3,4,i);
    imshow(imgs_4d(:,:,1,i));
end

layers = [ ...
    imageInputLayer([28,28,1])
    convolution2dLayer(5,20)
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'MaxEpochs',20,...
    'InitialLearnRate',1e-4, ...
    'Verbose',false, ...
    'Plots','training-progress');

ssnet = trainNetwork(imgs_4d,labs_cate,layers,options);