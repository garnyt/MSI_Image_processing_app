function dataStruct = get_selected_image_from_dataStruct(listbox_selection, dataStruct)

    len = size(listbox_selection,1);
    
    if len == 1
        img = dataStruct(listbox_selection(1,1)).data;
        current_image = img(:,:,listbox_selection(1,2));
        
        dataStruct(1).data = current_image;
        dataStruct(1).bands = dataStruct(listbox_selection(1,1)).bands(listbox_selection(1,2));
        
    elseif len == 3
        R = dataStruct(listbox_selection(1,1)).data;
        current_image = zeros(size(R,1),size(R,2),3);
        current_image(:,:,1) = R(:,:,listbox_selection(1,2));
        dataStruct(listbox_selection(1,1)).bands(listbox_selection(1,2));
        G = dataStruct(listbox_selection(2,1)).data;
        current_image(:,:,2) = G(:,:,listbox_selection(2,2));
        B = dataStruct(listbox_selection(3,1)).data;
        current_image(:,:,3) = B(:,:,listbox_selection(3,2));
        
        
        dataStruct(1).data = current_image;
        dataStruct(1).bands = {};
        dataStruct(1).bands(1) = dataStruct(listbox_selection(1,1)).bands(listbox_selection(1,2));
        dataStruct(1).bands(2) = dataStruct(listbox_selection(2,1)).bands(listbox_selection(2,2));
        dataStruct(1).bands(3) = dataStruct(listbox_selection(3,1)).bands(listbox_selection(3,2));
        
    else
        uiwait(msgbox('Select the bands to display','Selection','help'));
    end   

end