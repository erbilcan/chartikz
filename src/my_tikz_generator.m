function [] = my_tikz_generator(connection_info, shape_info)
    
    % tikz code will be written to this file
    output_folder = '../output';
    output_file = [output_folder '/' 'tikz_command.tex'];
    
    % open file
    output_file_id = fopen(output_file, 'w');
    
    % write static commands before
    fprintf(output_file_id, '\\newcommand{\\autoFlowchart}[0]{\n');
    fprintf(output_file_id, '\t\\tikzstyle{rec} = [draw, rectangle, minimum size=1cm]\n');
    fprintf(output_file_id, '\t\\tikzstyle{dia} = [draw, diamond, minimum size=1cm]\n');
    fprintf(output_file_id, '\t\\tikzstyle{cir} = [draw, circle, minimum size=1cm]\n');
    fprintf(output_file_id, '\t\\tikzstyle{line} = [draw, -latex]\n');
    fprintf(output_file_id, '\t\\begin{figure}\n');
    fprintf(output_file_id, '\t\t\\centering\n');
    fprintf(output_file_id, '\t\t\\begin{tikzpicture}[node distance = 2cm, auto]\n');
    
    % shape types class -> string
    shape_types = containers.Map;
    shape_types('R') = 'rec';
    shape_types('D') = 'dia';
    shape_types('C') = 'cir';
        
    % arrow type -> position (rev)
    arrow2pos_rev = containers.Map;
    arrow2pos_rev('D') = 'below';
    arrow2pos_rev('U') = 'above';
    arrow2pos_rev('R') = 'right';
    arrow2pos_rev('L') = 'left';

    % lists for traversing
    to_look = [];
    used_shapes = [];

    % find the root
    shape_ids_list = 1:numel(shape_info);
    root_shape_id = setdiff(shape_ids_list, [connection_info.target_shape_id]);
    root_shape_type = shape_types(shape_info(root_shape_id).shape_type);
    root_shape_type_id = [root_shape_type num2str(root_shape_id)];
    command = ['\t\t\t\' '\node [' root_shape_type '] (' root_shape_type_id ') {};' '\n'];
    fprintf(output_file_id, command);
    used_shapes = [used_shapes root_shape_id];
    
    % add root's neighbors
    current_shape_id = root_shape_id;
    arrow_from = [connection_info.source_shape_id] == current_shape_id;
    to_look = [to_look connection_info(arrow_from).target_shape_id];
    arrow_to = [connection_info.target_shape_id] == current_shape_id;
    to_look = [to_look connection_info(arrow_to).source_shape_id];
    
    % iterate over the queue
    while (numel(to_look) ~= 0)
        
        % get current shape
        current_shape_id = to_look(1);
        current_shape_type = shape_types(shape_info(current_shape_id).shape_type);
        current_shape_type_id = [current_shape_type num2str(current_shape_id)];

        % remove current shape from queue & add it to used list
        to_look = to_look(2:end);
        used_shapes = [used_shapes current_shape_id];
        
        % add neighbors of current shape to queue
        arrow_from = find([connection_info.source_shape_id] == current_shape_id);
        target_shape_ids = [connection_info(arrow_from).target_shape_id];
        arrow_to = find([connection_info.target_shape_id] == current_shape_id);
        source_shape_ids = [connection_info(arrow_to).source_shape_id];
        to_look = [setdiff(target_shape_ids, used_shapes) to_look];
        to_look = [setdiff(source_shape_ids, used_shapes) to_look];
        
        % position using existing neighbors
        position_command = '';
        if numel(intersect(source_shape_ids, used_shapes) > 0)
            for source_shape_id = intersect(source_shape_ids, used_shapes)
                source_shape_type = shape_types(shape_info(source_shape_id).shape_type);
                source_shape_type_id = [source_shape_type num2str(source_shape_id)];
                arrow_id = find([connection_info.source_shape_id] == source_shape_id & [connection_info.target_shape_id] == current_shape_id);
                position = arrow2pos_rev(connection_info(arrow_id).direction);
                position_command = [position_command ', ' position ' of=' source_shape_type_id];
                command = ['\t\t\t\' '\node [' current_shape_type position_command '] (' current_shape_type_id ') {};' '\n'];
                fprintf(output_file_id, command);
            end
        end

    end
    
    % add arrows
    for arrow = connection_info
        source_type = shape_info(arrow.source_shape_id).shape_type;
        source_name = shape_types(source_type);
        source_name_id = [source_name num2str(arrow.source_shape_id)];
        target_type = shape_info(arrow.target_shape_id).shape_type;
        target_name = shape_types(target_type);
        target_name_id = [target_name num2str(arrow.target_shape_id)];
        command = ['\t\t\t\' '\path [line] (' source_name_id ') -- (' target_name_id ');\n'];
        fprintf(output_file_id, command);
    end
    
    % write static commands after
    fprintf(output_file_id, '\t\t\\end{tikzpicture}\n');
    fprintf(output_file_id, '\t\t\\caption{Auto-generated flowchart}\n');
    fprintf(output_file_id, '\t\t\\label{fig:auto-flowchart}\n');
	fprintf(output_file_id, '\t\\end{figure}\n');
    fprintf(output_file_id, '}');
        
    % close file
    fclose(output_file_id);

end

