function [dataOut]=stretchImage(data,percent)

dataOut = [];
data = double(data);

for i = 1:size(data,3)
    band = data(:,:,i);
    temp2 = sort(band(:));
    pix = size(band,1)*size(band,2);
    percent2 = round(pix/100*percent);
    low = temp2(percent2);
    high = temp2(end-percent2);
    band(band <= low) = temp2(percent2+1);
    band(band >= high) = temp2(end-percent2-1);
    band = (band - min(band(:)))/(max(band(:))-min(band(:)));
    dataOut(:,:,i) = band;
end

end
