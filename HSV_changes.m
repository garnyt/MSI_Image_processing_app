function [img] = HSV_changes(current_image, h_value, s_value, v_value)

    current_image = uint8(current_image * 255);
    hsvImage = rgb2hsv(current_image);
    
    hsvImage(:,:,1) = hsvImage(:,:,1) * h_value;
    hsvImage(:,:,2) = hsvImage(:,:,2) * s_value;
    hsvImage(:,:,3) = hsvImage(:,:,3) * v_value;
    img = hsv2rgb(hsvImage);
    
end