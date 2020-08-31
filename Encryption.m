%reading an image 

img = imread('six40.jpg');
%converting into a grayscale image
img = rgb2gray(img);


% X-> IMG
    x = double(img);
    
    subplot(2,4,1)
    temp = uint8(x);
    imshow(temp);
    title('Original img');
    
    bw1 = edge(img,'canny',[0.0001 0.0005],7);
    
    % y-> edge intensity values only
    y = double(img);
    
    y(bw1==0) = 0;    
    
    % summing all intensity values at edge points
    sum1=0;
    
    sum1 = mod(sum(sum(y)),256);
    
    %which sum >= sum has an inverse in 256
    
    while(gcd(sum1,256) ~= 1)
        sum1 = sum1 + 1 ;
    end
    
    % suminv cointains inverse value
    
    [~,a,b] = gcd(sum1,256);
    suminv = mod(a,256);
    
    fprintf('sum -> %d\n' , sum1);
    fprintf('sum inv -> %d\n' , suminv);
    
    %distorting a particular portion of image
    
     for i=1:size(img,1)
        
        for j=1:size(img,2)
           
            if(i>(size(img,1)/2 - size(img,1)/4) && i<(size(img,1)/2 + size(img,1)/4) && j>(size(img,2)/2 - size(img,2)/4) && j<(size(img,2)/2 + size(img,2)/4))
                x(i,j) = mod(x(i,j)*sum1 , 256);
                
            end
            
        end
        
     end
    
     subplot(2,4,2)
     temp = uint8(x);
     imshow(temp);
     imwrite(temp,'object_encrypted.jpg');
     title('Encrypted img');
     
     
     %summing all new intesity points at all points
     
     bw2 = edge(x,'log',0.001,7);
     
     z = x;
     
     z(bw2==0) = 0;
     
     sum2=mod(sum(sum(z)) , 256);
      
      while(gcd(sum2,256) ~= 1 && sum2 ~= sum1)
        sum2 = sum2 + 1 ;
      end
      
      % inverse of sum2
      
      [~,a,b] = gcd(sum2,256);
      sum2inv = mod(a,256);
      
      fprintf('sum2 -> %d\n' , sum2);
      fprintf('sum2 inv -> %d\n\n' , sum2inv);
      
      %Distorting whole image now
      
      x = mod(x.*sum2 , 256);
      
     subplot(2,4,3)
     temp = uint8(x);
     imshow(temp);
     imwrite(temp,'Complete_phase_1.jpg');
     title('Completely Encrypted img');
     %end of the encryption of rishab code 
     %kmeans code started
     height = size(temp,1);
width = size(temp,2);
%now reshaping to column vector
img_col = reshape(temp,height*width,1);
%number of clusters
n=input('enter no of clusters');
%applying the kmeans 
[idx,c]=kmeans(double(img_col),n);
%now finding the prime values in c having the multiplicative inverse
key=[];
inverse=[];
for i=1:size(c,1)
    [key(i),inverse(i)] = prime1(c(i));
    disp('----');
    disp(c(i));
    disp(key);
    disp(inverse);
    disp('------');
end
disp(key);
disp(inverse);
%Encryption
for j=1:size(c,1)
img_col(idx==j) =mod((double(img_col(idx==j)).*double(key(j))),256);
end
img_col = reshape(img_col,height*width,1);
img_new = reshape(img_col,height,width);
subplot(2,4,4);
imshow(img_new);
imwrite(img_new,'Kmeans_encrypted.jpg');
title('using kmeans encryption');
%normalising the idx matrix in range of 0 to 255

decryption(img_col, height,width,inverse,idx,suminv,sum2inv);