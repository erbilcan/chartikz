function [connection_info] = my_connection_analyser(I_arrows, shape_stats, debug_mode)
    
    % argument check
    switch nargin
        case 0
            error('Missing arguments.');
        case 1
            error('Missing arguments.');
        case 2
            debug_mode = 0;
        case 3
            if debug_mode ~= 0
                debug_mode = 1;
            end
        otherwise
            error('2 or 3 inputs are accepted.')
    end

    % label arrows
    [L_arrows, ~] = bwlabel(I_arrows);

    % pseudocolor the regions, black will have the color [.5 .5 .5]
    RGB_arrows = label2rgb(L_arrows, 'hsv', [.5 .5 .5], 'shuffle');
    
    % get props of each arrow
    arrow_stats = regionprops(L_arrows, 'all');
        
    % show arrows
    if debug_mode == 1
        arrows_rgb_img = figure;
        imshow(RGB_arrows);
        hold on;
    end
    
    % for each arrow
    for k = 1:numel(arrow_stats)
        
        % get bounding box and centroid
        arrow_bb = arrow_stats(k).BoundingBox;
        arrow_c = arrow_stats(k).Centroid;

        % calculate center of bounding box
        bb_center = [arrow_bb(1)+arrow_bb(3)/2, arrow_bb(2)+arrow_bb(4)/2];
                
        % define a vector using center points of arrow and bounding box
        vec = [arrow_c(1) - bb_center(1), arrow_c(2) - bb_center(2)];
        
        % determine direction using the vector
        [~, ind] = max(abs(vec));
        if ind == 1 && vec(ind) < 0
            dir = 'L';
        elseif ind == 1 && vec(ind) >= 0
            dir = 'R';
        elseif ind == 2 && vec(ind) < 0
            dir = 'U';
        elseif ind == 2 && vec(ind) >= 0
            dir = 'D';
        else
            dir = "unidentified";
        end
         
        % get closest shape considering the direction detected
        min_dist_to = 999999.0;
        min_ind_to = -1;
        min_dist_from = 999999.0;
        min_ind_from = -1;
        for j = 1:numel(shape_stats)
            if strcmp(dir,'L')
                ref_point_to = [arrow_bb(1) arrow_bb(2)+arrow_bb(4)/2];
                ref_point_from = [arrow_bb(1)+arrow_bb(3) arrow_bb(2)+arrow_bb(4)/2];
            elseif strcmp(dir,'R')
                ref_point_to = [arrow_bb(1)+arrow_bb(3) arrow_bb(2)+arrow_bb(4)/2];
                ref_point_from = [arrow_bb(1) arrow_bb(2)+arrow_bb(4)/2];
            elseif strcmp(dir,'U')
                ref_point_to = [bb_center(1) arrow_bb(2)];
                ref_point_from = [bb_center(1) arrow_bb(2)+arrow_bb(4)];
            elseif strcmp(dir,'D')
                ref_point_to = [bb_center(1) arrow_bb(2)+arrow_bb(4)];
                ref_point_from = [bb_center(1) arrow_bb(2)];
            else    
                ref_point_to = [-1 -1];
                ref_point_from = [-2 -2];
            end
            curr_dist_to = norm(shape_stats(j).Centroid - ref_point_to);
            if curr_dist_to < min_dist_to
                min_dist_to = curr_dist_to;
                min_ind_to = j;
            end
            curr_dist_from = norm(shape_stats(j).Centroid - ref_point_from);
            if curr_dist_from < min_dist_from
                min_dist_from = curr_dist_from;
                min_ind_from = j;
            end
        end
        
        % draw bounding box, id, direction, center points, connections
        if debug_mode == 1
            figure(arrows_rgb_img);
            rectangle('Position', [arrow_bb(1), arrow_bb(2), arrow_bb(3), arrow_bb(4)], 'EdgeColor', 'r', 'LineWidth', 1);
            if strcmp(dir,'L') || strcmp(dir,'R')
                text(bb_center(1), arrow_bb(2)-25, [num2str(k) ' ' num2str(min_ind_from) ' ' dir ' ' num2str(min_ind_to)],'FontWeight', 'bold');
            else
                text(arrow_bb(1)+arrow_bb(3)+10, bb_center(2), [num2str(k) ' ' num2str(min_ind_from) ' ' dir ' ' num2str(min_ind_to)],'FontWeight', 'bold');
            end
            text(arrow_c(1), arrow_c(2), 'x');
            text(bb_center(1), bb_center(2), '+');
            text(ref_point_from(1), ref_point_from(2), 'f');
            text(ref_point_to(1), ref_point_to(2), 't');
        end
        
        % build connection info struct
        connection_info(k).arrow_id = k;
        connection_info(k).source_shape_id = min_ind_from;
        connection_info(k).target_shape_id = min_ind_to;
        connection_info(k).direction = dir;
        
    end
    
    % show connection info with a table
    if debug_mode == 1
        var_names = {'arrow_id', 'source_shape_id', 'target_shape_id', 'direction'};
        table([connection_info.arrow_id]', [connection_info.source_shape_id]', [connection_info.target_shape_id]', [connection_info.direction]', 'VariableNames', var_names)
    end
    
end

