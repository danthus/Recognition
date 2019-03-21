matrix = zeros(560,560);
imshow(matrix);
paint = imfreehand('Closed',false);
xy = round(paint.getPosition);
x = xy(:,1);
y = xy(:,2);
for i = 1:size(x)
    matrix(y(i),x(i))= 255;
end
resized = imresize(matrix,[28,28]);
resized = mat2gray(resized);

enhanced = zeros(28,28);
for r = 1:28
    for c = 1:28
        if(resized(r,c)>0.6 && resized(r,c)<0.8)
            enhanced(r,c) = resized(r,c)+0.2;
        elseif(resized(r,c)>0.4 && resized(r,c)<0.6)
            enhanced(r,c) = resized(r,c)+0.4;
        elseif(resized(r,c)>0.2 && resized(r,c)<0.4)
            enhanced(r,c) = resized(r,c)+0.55;
 
        end
    end
end

for row = 2:27
    for col = 2:27
        count = 0;
        if(enhanced(row,col)==0)
            if(enhanced(row-1,col)~=0)
                count = count + 1;
            end
            if(enhanced(row,col-1)~=0)
                count = count + 1;
            end
            if(enhanced(row+1,col)~=0)
                count = count + 1;
            end
            if(enhanced(row,col+1)~=0)
                count = count + 1;
            end
            
        end
        
        if(count >= 3)
            enhanced(row,col)=1;
        end
        
    end 
end
imtool(enhanced);
classify(ssnet,enhanced)