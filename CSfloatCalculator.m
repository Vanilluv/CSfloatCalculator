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
    
    % 获取所有可能的10个材料的组合
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
    
    % 确保最后完成100%的汇报
    if last_reported_percent ~= 100
        fprintf('已完成100/100\n');
    end
    
    % 将结果输出到CSV文件
    if size(results, 1) > 0
        [pathstr, name, ext] = fileparts(filename);
        output_filename = fullfile(pathstr, [name '_output.csv']);
        
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