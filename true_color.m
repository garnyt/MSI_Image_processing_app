function [RGB, bands] = true_color(dataCube, wavelengths)
    row = size(dataCube,1);
    col = size(dataCube,2);
    bands = size(dataCube,3);

    data = reshape(dataCube,[row*col,bands]);
    %data = data(:,4:13);

    try
        %num = regexp(wave, '\d+', 'match');
        %waves = [2:2:32];
        %wave = num(waves);
        %wave = wave(4:13);
        wave = wavelengths;
    catch
        
    end
   

    % read in illuminants (300 - 830)
    illum = csvread('Wave_A_D50_D55_D65_D75.csv');
    illum_wave = illum(:,1);
    illum_D65 = illum(:,5);

    % read XYZ observer (360 - 830)
    observer2deg = csvread('ObserverXYZ.csv');

    % interp all data to object wavelengths 
    illum_D65_interp = interp1(illum_wave, illum_D65, wave); 
    observer2deg_x_interp = interp1(observer2deg(:,1), observer2deg(:,2), wave); 
    observer2deg_y_interp = interp1(observer2deg(:,1), observer2deg(:,3), wave); 
    observer2deg_z_interp = interp1(observer2deg(:,1), observer2deg(:,4), wave); 


    %calculate the CIE XYZ tristimulus value

    num = size(data,1);

    D65_rep = repmat(illum_D65_interp,[1,num]);

    object_ave = (data/100)';
    X = 100*nansum(D65_rep.*object_ave.*repmat(observer2deg_x_interp,[1,num]))./nansum(D65_rep.*repmat(observer2deg_y_interp,[1,num]));
    Y = 100*nansum(D65_rep.*object_ave.*repmat(observer2deg_y_interp,[1,num]))./nansum(D65_rep.*repmat(observer2deg_y_interp,[1,num]));
    Z = 100*nansum(D65_rep.*object_ave.*repmat(observer2deg_z_interp,[1,num]))./nansum(D65_rep.*repmat(observer2deg_y_interp,[1,num]));

    X = X';
    Y = Y';
    Z = Z';

    % Xn_D65 = 0.9504;
    % Yn_D65 = 1;
    % Zn_D65 = 1.0888;

    Yn = 100;
    Xn = 95.04;
    Zn = 108.88;

    x = Y/Yn;
    x_Y_larger = x.^(1/3);
    x_Y_smaller = 7.787*x + 16/116;
    x_Y = zeros(size(x,1),1);
    x_Y(x > 0.00856) = x_Y_larger(x > 0.00856);
    x_Y(x <= 0.00856) = x_Y_smaller(x <= 0.00856);
    L = 116*x_Y-16;


    x = X/Xn;
    x_X_larger = x.^(1/3);
    x_X_smaller = 7.787*x + 16/116;
    x_X = zeros(size(x,1),1);
    x_X(x > 0.00856) = x_X_larger(x > 0.00856);
    x_X(x <= 0.00856) = x_X_smaller(x <= 0.00856);
    a = 500*(x_X - x_Y);

    x = Z/Zn;
    x_Z_larger = x.^(1/3);
    x_Z_smaller = 7.787*x + 16/116;
    x_Z = zeros(size(x,1),1);
    x_Z(x > 0.00856) = x_Z_larger(x > 0.00856);
    x_Z(x <= 0.00856) = x_Z_smaller(x <= 0.00856);
    b = 200*(x_Y-x_Z);    


    L = L';
    a = a';
    b = b';
    %C = C';

    LAB = reshape(L, [row,col]);
    LAB(:,:,2) = reshape(a, [row,col]);
    LAB(:,:,3) = reshape(b, [row,col]);

    RGB = lab2rgb(LAB);
    R = RGB(:,:,1);
    G = RGB(:,:,2);
    B = RGB(:,:,3);

    RGB(:,:,1) = (R - min(R(:)))/(max(R(:))- min(R(:)));
    RGB(:,:,2) = (G - min(G(:)))/(max(G(:))- min(G(:)));
    RGB(:,:,3) = (B - min(B(:)))/(max(B(:))- min(B(:)));
    
    bands = ['Red','Green','Blue'];

end
