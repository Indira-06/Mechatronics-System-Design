clear all;
close all;
clc;
opts = detectImportOptions('tof_benchmark.csv');
opts.VariableNamingRule = 'preserve';
data = readtable('tof_benchmark.csv', opts);
disp('Column names in the table:');
disp(data.Properties.VariableNames);
timestamps = data.Timestamp;
distances_mm = data.('Distance(mm)');
time_start = datetime(timestamps(1), 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSSSSS');
time_seconds = seconds(datetime(timestamps, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSSSSS') -
time_start);
distances_m = distances_mm / 1000;
valid_indices = distances_m > 0;
time_valid = time_seconds(valid_indices);
distances_valid = distances_m(valid_indices);
window_size = 10;
distances_smoothed = movmean(distances_valid, window_size);
total_time = time_seconds(end);
max_distance = max(distances_valid);
min_distance = min(distances_valid);
avg_distance = mean(distances_valid);
figure('Name', 'ToF Sensor Distance Over Time', 'NumberTitle', 'off', 'Position', [100, 100, 1000,
600]);
plot(time_valid, distances_valid, 'b-', 'LineWidth', 1, 'DisplayName', 'Raw Data');
hold on;
plot(time_valid, distances_smoothed, 'r-', 'LineWidth', 2, 'DisplayName', 'Smoothed Data');
plot(time_valid(1), distances_valid(1), 'go', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName',
'Start');
plot(time_valid(end), distances_valid(end), 'ro', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName',
'End');
plot([0 total_time], [min_distance min_distance], 'k--', 'LineWidth', 1, 'DisplayName', 'Min
Distance');
plot([0 total_time], [avg_distance avg_distance], 'k--', 'LineWidth', 1, 'DisplayName', 'Avg
Distance');
plot([0 total_time], [max_distance max_distance], 'k--', 'LineWidth', 1, 'DisplayName', 'Max
Distance');
% Display text annotations for min, avg, and max distances
text(total_time/2, min_distance + 0.1, sprintf('Min: %.3f m', min_distance),
'HorizontalAlignment', 'center');
text(total_time/2, avg_distance + 0.1, sprintf('Avg: %.3f m', avg_distance),
'HorizontalAlignment', 'center');
text(total_time/2, max_distance + 0.1, sprintf('Max: %.3f m', max_distance),
'HorizontalAlignment', 'center');
plot([0 total_time], [1.5 1.5], 'g-', 'LineWidth', 1.5, 'DisplayName', 'Ruler Length (1.5 m)');
title('ToF Sensor Distance Measurement Over Time');
xlabel('Time (s)');
ylabel('Distance (m)');
legend('Location', 'best');
grid on;
axis([0 total_time min_distance - 0.2 max_distance + 0.2]);
axis square;
fprintf('Total Duration: %.2f seconds\n', total_time);
fprintf('Minimum Distance: %.3f meters\n', min_distance);
fprintf('Maximum Distance: %.3f meters\n', max_distance);
fprintf('Average Distance: %.3f meters\n', avg_distance);