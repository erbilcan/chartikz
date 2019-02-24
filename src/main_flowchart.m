function [] = main_flowchart( I, debug_mode )

    % binarize
    I_c = my_imbinarizer(I, debug_mode);

    % noise reduction
    I_d = my_noise_reductor(I_c, debug_mode);

    % region filling
    I_f = my_region_filler(I_d, debug_mode);

    % angle correction
    I_ac = my_angle_corrector(I_f, debug_mode);

    % segmentation
    [I_seg, I_arrows] = my_imseg(I_ac, debug_mode);

    % classification
    [shape_info, stats] = my_object_classifier(I_seg, debug_mode);

    % connection analysis
    connection_info = my_connection_analyser(I_arrows, stats, debug_mode);

    % re-composition
    my_tikz_generator(connection_info, shape_info);

end

