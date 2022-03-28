function [dataPCA, bandsPCA] = PCAcalc(dataCube,bands_to_keep)
    
    sz = size(dataCube);
    temp = dataCube(:,:,round(sz(3)/2));
    temp = temp/(max(temp(:)));
    
    
    % select document only area
    answer = questdlg('Would you like to select a smaller region of interest (ROI) to calculate the PCA statistics on? For example, excluding the color checker chart will create better statistics. Note, stay within the object borders - usually 1/3 or 1/4 section would be good including the text you are interested in.', ...
	'Select ROI?', 'Yes','No','No');

        switch answer
            case 'Yes'
                roi = 1;
            case 'No'
                roi = 2;
        end       
            
   if  roi == 1       
           figure
           %[temp]=stretchImage(temp, 1.5);
           imshow(temp,[]) 
           title('Select ROI - rectangle')
            
           % select smaller area for document
          
           hFH = imrect();
           xy = hFH.getPosition;
           close(gcf)

           xy = floor(xy);
           
           row_end = xy(2)+xy(4);
           col_end = xy(1)+xy(3);
           
           if row_end > size(temp,1)
               row_end = size(temp,1);
           end
           if col_end > size(temp,2)
               col_end = size(temp,2);
           end
           
           dataCube_stats = dataCube(xy(2):row_end,xy(1):col_end,:);
   else
       dataCube_stats = dataCube;
   end   

    
    X = double(reshape(dataCube,[sz(1)*sz(2),sz(3)]))/255; 
    X_stats = double(reshape(dataCube_stats,[size(dataCube_stats,1)*size(dataCube_stats,2),sz(3)]))/255; 
           
    mu = mean(X_stats,1);
    X_stats = bsxfun(@minus,X_stats,mu);
    C = cov(X_stats);
    [U,D] = eig(C);
    clear C;
    [~,ix] = sort(diag(D),'descend');
    U = U(:,ix);
    U = U(:,1:bands_to_keep);
    out = U'*X';
    
    out = out + abs(min(out(:)));
    out = (out)/(max(out(:)));
    
    dataPCA = (reshape(out',[sz(1),sz(2),bands_to_keep]));
    
    [dataPCA]=stretchImage(dataPCA,2);
    
    bandsPCA = {};
    for i = 1:bands_to_keep
       bandsPCA{i} = ['PCA band ', num2str(i)]; 
       temp = dataPCA(:,:,i);
       dataPCA(:,:,i) = (temp - min(temp(:)))/(max(temp(:))-min(temp(:)));
    end


end