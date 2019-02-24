function [shape_info, stats] = my_object_classifier(I_seg, debug_mode)

    % argument check
    switch nargin
        case 0
            error('Image argument is missing.');
        case 1
            debug_mode = 0;
        case 2
            if debug_mode ~= 0
                debug_mode = 1;
            end
        otherwise
            error('1 or 2 inputs are accepted.')
    end

    % detect boundaries
    [B,~] = bwboundaries(I_seg);

    % label each boundary & generate different color
    [L,N] = bwlabel(I_seg);
    RGB = label2rgb(L, 'hsv', [.5 .5 .5], 'shuffle');
    
    % show shapes
    if debug_mode == 1
        arrows_rgb_img = figure; imshow(RGB); hold on;
    end

    % get properties for each region (object)
    stats = regionprops(L, 'Centroid', 'BoundingBox', 'Area', 'Eccentricity', 'Orientation', 'Perimeter');

    % compute other props & predict type for each shape
    for k = 1:N

        % compute thinness ratio
        stats(k,1).ThinnessRatio = 4*pi*stats(k,1).Area / (stats(k,1).Perimeter)^2;

        % compute aspect ratio
        stats(k,1).AspectRatio = (stats(k,1).BoundingBox(3))/(stats(k,1).BoundingBox(4));

        % compute perimeter / boundary box perimeter ratio
        stats(k,1).PerimeterBBoxRatio = (stats(k,1).Perimeter)/((2*stats(k,1).BoundingBox(3))+ (2*stats(k,1).BoundingBox(4)));

        shape_info(k).shape_id = k;

        % Rules
        if stats(k, 1).ThinnessRatio > 0.99 && stats(k, 1).Eccentricity < 0.5
            shape_info(k).shape_type = 'C';
            continue;
        end
        if stats(k, 1).PerimeterBBoxRatio > 0.75 && abs(stats(k,1).Orientation) < 10
            shape_info(k).shape_type = 'R';
        else
            shape_info(k).shape_type = 'D';
        end

    end

    % show shape info with a table
    if debug_mode == 1
        var_names = {'shape_id', 'predicted_type', 'Area', 'Orientation', 'Eccentricity', 'AspectRatio', 'Perimeter', 'PerimeterBBoxRatio', 'ThinnessRatio'};
        table([shape_info.shape_id]',  [shape_info.shape_type]', [stats.Area]', [stats.Orientation]', [stats.Eccentricity]', [stats.AspectRatio]', [stats.Perimeter]', [stats.PerimeterBBoxRatio]', [stats.ThinnessRatio]', 'VariableNames', var_names)
    end

    % print predicted types & ids
    if debug_mode == 1
        for k = 1:length(B)
            boundary = B{k};
            plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2);
            text(stats(k).Centroid(1), stats(k).Centroid(2), [shape_info(k).shape_type, ' ', num2str(k)], 'Color','k','FontSize', 14, 'FontWeight', 'bold', 'BackgroundColor', 'white');
        end
        hold off;
    end

end