%clear all
%clc

%% upload image 
im=imread('C:\Users\Cripps Hire Laptop\Dropbox\Nottingham\PhD\Image analysis\distance transform\i1^cimgpsh_orig.png');

%% crop image

[im_cropped, rect] = imcrop(im);

%% convert image to bw based on threshold

bw=im2bw(im_cropped,0.5); %look into thresholding

%% invert colours

s_bw=size(bw);
n_bw=numel(bw);
ibw=zeros(s_bw(1),s_bw(2));

for i=1:n_bw
    if bw(i)==0
        ibw(i)=1;
    else
        ibw(i)=0;
    end
end

%% split up image into square

min_matrix_value=min(s_bw);

cibw=imcrop(ibw,[0 0 min_matrix_value min_matrix_value]);

%% Eulicidian distance transform

euclidean_cibw = bwdist(cibw,'euclidean');

%% round matrix according to chosen precision

% s_euclidean_cibw=size(euclidean_cibw);
n_euclidean_cibw=numel(euclidean_cibw);
% r_euclidean_cibw=zeros(s_euclidean_cibw(1),s_euclidean_cibw(2));

% for i=1:n_euclidean_cibw
%     r_euclidean_cibw(i)=euclidean_cibw(i)*10000; %change 10 % change to x*10000
%     %round(D111(i),1); %round to what decimal place
% end

figure
subimage(mat2gray(euclidean_cibw)), title('Euclidean'), imcontour(euclidean_cibw)

%% Stats and graphs of result

no_nonC=0;
max_euclidean_cibw=euclidean_cibw(1,1);
for i=1:n_euclidean_cibw
    if euclidean_cibw(i) > 0
        no_nonC=no_nonC+1;
    end
    if max_euclidean_cibw<=euclidean_cibw(i);
        max_euclidean_cibw=euclidean_cibw(i);
    end
end

eleven_euclidean_values=zeros(11,1);
eleven_groups_euclidean_cibw=zeros(11,1);

for i=2:11
    eleven_euclidean_values(i)=max_euclidean_cibw*i/10;
end

for i=1:n_euclidean_cibw
    if euclidean_cibw(i) > eleven_euclidean_values(1) & euclidean_cibw(i) <= eleven_euclidean_values(2)
        eleven_groups_euclidean_cibw(2)=eleven_groups_euclidean_cibw(2)+1;
    elseif euclidean_cibw(i) > eleven_euclidean_values(2) & euclidean_cibw(i) <= eleven_euclidean_values(3)
        eleven_groups_euclidean_cibw(3)=eleven_groups_euclidean_cibw(3)+1;
    elseif euclidean_cibw(i) > eleven_euclidean_values(3) & euclidean_cibw(i) <= eleven_euclidean_values(4)
        eleven_groups_euclidean_cibw(4)=eleven_groups_euclidean_cibw(4)+1;
    elseif euclidean_cibw(i) > eleven_euclidean_values(4) & euclidean_cibw(i) <= eleven_euclidean_values(5)
        eleven_groups_euclidean_cibw(5)=eleven_groups_euclidean_cibw(5)+1;
    elseif euclidean_cibw(i) > eleven_euclidean_values(5) & euclidean_cibw(i) <= eleven_euclidean_values(6)
        eleven_groups_euclidean_cibw(6)=eleven_groups_euclidean_cibw(6)+1;
    elseif euclidean_cibw(i) > eleven_euclidean_values(6) & euclidean_cibw(i) <= eleven_euclidean_values(7)
        eleven_groups_euclidean_cibw(7)=eleven_groups_euclidean_cibw(7)+1;
    elseif euclidean_cibw(i) > eleven_euclidean_values(7) & euclidean_cibw(i) <= eleven_euclidean_values(8)
        eleven_groups_euclidean_cibw(8)=eleven_groups_euclidean_cibw(8)+1;
    elseif euclidean_cibw(i) > eleven_euclidean_values(8) & euclidean_cibw(i) <= eleven_euclidean_values(9)
        eleven_groups_euclidean_cibw(9)=eleven_groups_euclidean_cibw(9)+1;        
    elseif euclidean_cibw(i) > eleven_euclidean_values(9) & euclidean_cibw(i) <= eleven_euclidean_values(10)
        eleven_groups_euclidean_cibw(10)=eleven_groups_euclidean_cibw(10)+1;
    elseif euclidean_cibw(i) > eleven_euclidean_values(10) & euclidean_cibw(i) <= eleven_euclidean_values(11)
        eleven_groups_euclidean_cibw(11)=eleven_groups_euclidean_cibw(11)+1;
    end
end

eleven_groups_euclidean_cibw=eleven_groups_euclidean_cibw/no_nonC;
cum_eleven_groups_euclidean_cibw=zeros(11,1);

cum_eleven_groups_euclidean_cibw(2)=eleven_groups_euclidean_cibw(2);

for i=3:11
    cum_eleven_groups_euclidean_cibw(i)=eleven_groups_euclidean_cibw(i)+cum_eleven_groups_euclidean_cibw(i-1);
end

x_values=linspace(0,10,11)

figure
plot(x_values,cum_eleven_groups_euclidean_cibw)
axis([0,10,0,1])
