function [BW_calibration_target] = auto_calibrate(img)

    % filter out any spots on the calibration target
    H = ones([20,20])/400;
    img_filt = filter2(H, img); 
    
    % remove top 1% of data
    out=stretchImage(img_filt,1);

    cnt = 0;
    stats = '';
    % set start threshold
    thresh = median(out(:));
    
    while (size(stats,1) ~= 1) && (cnt < 20) && (thresh < 1)
        cnt = cnt + 1;
        bw = im2bw(img_filt, 1-thresh);
        BW2 = bwareafilt(bw,[100000 300000]);
        stats = regionprops(BW2,'Centroid',...
            'MajorAxisLength','MinorAxisLength');
        thresh = thresh + 0.05;
    end

    if size(stats,1) == 1
        SE = strel('square',30);  
        BW_calibration_target = imerode(BW2, SE);
    else
        BW_calibration_target = 0;
        
    end
    
     BW_calibration_target = double(BW_calibration_target);
    
end
        


