function [dataOut]=scaleImage(data,dark,light)

dataOut = [];
data = double(data);

for i = 1:size(data,3)
    band = data(:,:,i);
    band(band < dark) = dark;
    band(band > light) = light;
    band = (band - min(band(:)))/(max(band(:)) - min(band(:)));
    dataOut(:,:,i) = band;
end

end