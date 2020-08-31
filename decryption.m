function [] = decryption(img_col,height,width,inverse,idx,suminv,sum2inv)

%Decryption
img_new = img_col;
for j=1:size(inverse,2)
img_new(idx==j) =mod((double(img_col(idx==j)).*double(inverse(j))),256);
end
img_new = reshape(img_new,height,width);
subplot(2,4,5);
imshow(img_new);
new0 = img_new;
imwrite(img_new,'Reversed_K_Means.jpg');
title('reversed kmeans');
 %Reversing the last encryption
     x = mod((uint64(img_new).*uint64(sum2inv)) , 256);            
     subplot(2,4,6)
     new1 = uint8(x);
     imshow(new1);
     imwrite(new1,'Reversed_Complete_Phase_1.jpg');
     title('Reversed last');
     
     
     img = new1;
     
     for i=1:size(img,1)
        
        for j=1:size(img,2)
           
            if(i>(size(img,1)/2 - size(img,1)/4) && i<(size(img,1)/2 + size(img,1)/4) && j>(size(img,2)/2 - size(img,2)/4) && j<(size(img,2)/2 + size(img,2)/4))
                img(i,j) = mod(uint64(new1(i,j))*uint64(suminv) , 256);
                
            end
            
        end
        
        
     end
     
     subplot(2,4,7)
     temp = uint8(img);
     imwrite(temp,'Completely_decrypted.jpg');
     imshow(temp);
     title('Decrypted img');
   
     
     
     



end

