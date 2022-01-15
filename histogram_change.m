%clear all
home

file_location = dir('F:\VIS\just Cu\plain Cu 4');

Afields = fieldnames(file_location);
Acell = struct2cell(file_location);
size_of_cell = size(Acell);

% Convert to a matrix
Acell = reshape(Acell, size_of_cell(1), []);      % Px(MxN)

% Make each field a column
Acell = Acell';                         % (MxN)xP

% Sort by first field "date"
Acell = sortrows(Acell, 3);

% Put back into original cell array format
Acell = reshape(Acell', size_of_cell);

% Convert to Struct
Images_sorted_struc = cell2struct(Acell, Afields, 1);

for no_of_images = 1:length(Images_sorted_struc)
    fprintf('%d\n',no_of_images);
%     disp(Asorted(no_of_images))
end

%
clear file_location Acell Afields

%% image loop

Second_SonicationMine_Cu_interfaceposition_and_timestamp = zeros(no_of_images,10);

cuv_pos = zeros(9,4);
cuv_pos(1,:) = [510 341 51 489];
cuv_pos(2,:) = [625 339 47 486];
cuv_pos(3,:) = [730 342 41 483];
cuv_pos(4,:) = [835 349 50 475];
cuv_pos(5,:) = [947 343 49 484];
cuv_pos(6,:) = [1058 356 37 468];
cuv_pos(7,:) = [1161 353 44 471];
cuv_pos(8,:) = [1270 347 43 472];
cuv_pos(9,:) = [1376 343 35 477];

for im = 1:no_of_images
    
    im
    
    image_original=imread(strcat(Images_sorted_struc(3).folder,'\',Images_sorted_struc(im).name));
    %ca = imcrop(a,[371 329 1080 545]);

    image_original = imcomplement(image_original); % inverse colours
    image_without_red_values=image_original;
    
    size_of_cell=size(image_original);
    
     %% filter out red values
     for k=1:2
         for i=1:size_of_cell(1)
             for j=1:size_of_cell(2)
                 if image_original(i,j,k)<195
                     image_without_red_values(i,j,k)=0;
                 end
             end
         end
     end
     clear k i j
    
    %% binarise
    image_grey=rgb2gray(image_without_red_values);
    image_binarised=imbinarize(image_grey,0.95); % crucial, value depends on particle colour and how clean the settling is 
    %clear image_original image_without_red_values image_grey 
    
    for cuvette=1:9 % loop for different cuvettes
        
        %cuv_current_pos = sprintf('cuv_pos_%d', cuvette);
        image_binarised_cropped = imcrop(image_binarised,cuv_pos(cuvette,:));
                    
        %% remove everything but 9 objects with largest area
        bw = bwpropfilt(image_binarised_cropped,'area',1); % 1 objects with the largest area
        %     figure, imshow(bw,[]);
        %clear image_binarised image_binarised_cropped
        
        %% fill holes
        bw = imfill(bw,'holes');
        
        %% average rows
        no_of_rows = size(bw);
        no_of_rows = no_of_rows(1);
        
        for n = 1:no_of_rows
            if mean(bw(n,:)) < 0.5
                bw(n,:) = 0;
            else
                bw(n,:) = 1;
            end       
        end
        
        %% find surface
        
        if sum(bw(1:no_of_rows,1)) > 0
            interface_row = 1;
            while bw(interface_row,1) < 1;
                interface_row = interface_row + 1;
            end       
            Second_SonicationMine_Cu_interfaceposition_and_timestamp(im,cuvette) = (no_of_rows-interface_row)/no_of_rows;
        else
            Second_SonicationMine_Cu_interfaceposition_and_timestamp(im,cuvette) = 0;
        end
        %Third_SonicationMine_Cu_interfaceposition_and_timestamp(im,cuvette)
    end
        
end






