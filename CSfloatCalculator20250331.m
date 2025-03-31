function CSfloatCalculator()
    % 用户输入最小值和最大值
    min_val = input('请输入炼金产物磨损的最小值: ');
    max_val = input('请输入炼金产物磨损的最大值: ');
    
    % 用户输入筛选的特定范围
    target_min = input('请输入需要的炼金产物磨损范围的最小值: ');
    target_max = input('请输入需要的炼金产物磨损范围的最大值: ');
    
    % 读取材料磨损数据
    filename = input('请输入炼金材料磨损数据文件名（包括.txt后缀）: ', 's');
    material_wear = load(filename);
    
    % 确保材料磨损数据在0~1范围内
    if any(material_wear < 0 | material_wear > 1)
        error('材料磨损数据必须在0~1范围内');
    end
    
    % 询问用户是否需要指定必须使用的材料
    use_required = input('是否需要指定必须使用的材料？(1: 是, 0: 否): ', 's');
    
    if strcmp(use_required, '1')
        % 读取必须使用的材料磨损数据
        required_filename = input('请输入必须使用的材料磨损数据文件名（包括.txt后缀）: ', 's');
        required_materials = load(required_filename);
        
        % 检查必须使用的材料数量是否小于10
        num_required = length(required_materials);
        if num_required >= 10
            error('必须使用的材料数量必须小于10个');
        end
        
        % 确保必须使用的材料是列向量
        if isrow(required_materials)
            required_materials = required_materials';
        end
        
        % 检查必须使用的材料是否在可选材料中重复
        % 如果重复，则从可选材料中移除这些重复的材料
        % 确保必须使用的材料和可选材料的维度一致
        if ismember(required_materials, material_wear, 'rows')
            material_wear = setdiff(material_wear, required_materials, 'rows');
        else
            % 如果必须使用的材料不在可选材料中，保持可选材料不变
            warning('必须使用的材料不在可选材料中，将保持可选材料不变');
        end
        
        % 确保可选材料是列向量
        if isrow(material_wear)
            material_wear = material_wear';
        end
        
        % 检查材料总数是否足够
        num_materials = length(material_wear) + num_required;
        if num_materials < 10
            error('材料数量不足10个，无法进行炼金');
        end
        
        % 生成所有可能的组合
        % 必须使用的材料必须出现在组合中
        % 剩下的材料从可选材料中选择
        num_optional = 10 - num_required;
        optional_materials = nchoosek(material_wear, num_optional);
        
        % 检查组合数量是否过大
        num_combinations = size(optional_materials, 1);
        if num_combinations > 1e6
            warning('组合数量超过100万，可能需要较长时间处理');
        end
        
        results = []; % 用于存储符合条件的结果
        
        % 遍历所有组合
        last_reported_percent = -1; % 用于记录上次汇报的百分比
        for i = 1:num_combinations
            current_optional = optional_materials(i, :);
            
            % 确保当前可选材料是列向量
            if isrow(current_optional)
                current_optional = current_optional';
            end
            
            % 拼接必须使用的材料和可选材料
            current_set = [required_materials; current_optional]';
            
            % 计算平均磨损
            avg_wear = mean(current_set);
            
            % 映射到用户指定的范围
            mapped_wear = map_value(avg_wear, 0, 1, min_val, max_val);
            
            % 检查是否在目标范围内
            if mapped_wear >= target_min && mapped_wear <= target_max
                % 如果符合，保存结果
                results = [results; current_set, mapped_wear];
            end
            
            % 进度汇报
            current_percent = floor((i / num_combinations) * 100);
            if mod(current_percent, 10) == 0 && current_percent ~= last_reported_percent
                fprintf('已完成%d/100\n', current_percent);
                last_reported_percent = current_percent;
            end
        end
    else
        % 如果用户没有指定必须使用的材料，按照原来的逻辑处理
        num_materials = length(material_wear);
        if num_materials < 10
            error('材料数量不足10个，无法进行炼金');
        end
        
        % 生成所有可能的10个材料的组合
        combinations = nchoosek(material_wear, 10);
        
        % 检查组合数量是否过大
        num_combinations = size(combinations, 1);
        if num_combinations > 1e6
            warning('组合数量超过100万，可能需要较长时间处理');
        end
        
        results = []; % 用于存储符合条件的结果
        
        % 遍历所有组合
        last_reported_percent = -1; % 用于记录上次汇报的百分比
        for i = 1:num_combinations
            current_set = combinations(i, :);
            
            % 计算平均磨损
            avg_wear = mean(current_set);
            
            % 映射到用户指定的范围
            mapped_wear = map_value(avg_wear, 0, 1, min_val, max_val);
            
            % 检查是否在目标范围内
            if mapped_wear >= target_min && mapped_wear <= target_max
                % 如果符合，保存结果
                results = [results; current_set, mapped_wear];
            end
            
            % 进度汇报
            current_percent = floor((i / num_combinations) * 100);
            if mod(current_percent, 10) == 0 && current_percent ~= last_reported_percent
                fprintf('已完成%d/100\n', current_percent);
                last_reported_percent = current_percent;
            end
        end
    end
    
    % 确保最后完成100%的汇报
    if last_reported_percent ~= 100
        fprintf('已完成100/100\n');
    end
    
    % 将结果输出到CSV文件
    if size(results, 1) > 0
        [pathstr, name, ext] = fileparts(filename);
        
        % 如果使用了必须使用的材料，在文件名中添加_locked_included
        if strcmp(use_required, '1')
            output_filename = fullfile(pathstr, [name '_output_locked_included.csv']);
        else
            output_filename = fullfile(pathstr, [name '_output.csv']);
        end
        
        % 将结果保存到CSV文件
        writematrix(results, output_filename);
        
        fprintf('找到%d组符合条件的结果\n', size(results, 1));
        fprintf('结果已保存到文件: %s\n', output_filename);
    else
        fprintf('没有找到符合条件的结果\n');
    end
end

function mapped_value = map_value(value, original_min, original_max, target_min, target_max)
    % 将值从原始范围映射到目标范围
    mapped_value = ((value - original_min) / (original_max - original_min)) * (target_max - target_min) + target_min;
end