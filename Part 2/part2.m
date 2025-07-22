clear;
close all;
clc;
data1 = readtable('path_1_telemetry.csv');
data2 = readtable('path_2_telemetry.csv');
disp('Column names in path_1_telemetry.csv:');
disp(data1.Properties.VariableNames);
pulse_to_distance = 0.095e-3;
track_width = 0.105;
[x1_enc, y1_enc, theta1_enc, x1_imu, y1_imu, theta1_imu, x1_fused, y1_fused, theta1_fused] = ...
reconstruct_trajectory(data1, pulse_to_distance, track_width);
[x2_enc, y2_enc, theta2_enc, x2_imu, y2_imu, theta2_imu, x2_fused, y2_fused, theta2_fused] = ...
reconstruct_trajectory(data2, pulse_to_distance, track_width);
time1 = get_time(data1.timestamp);
time2 = get_time(data2.timestamp);
plot_trajectory(x1_enc, y1_enc, x1_imu, y1_imu, x1_fused, y1_fused, theta1_fused, time1, 'Path1');
plot_trajectory(x2_enc, y2_enc, x2_imu, y2_imu, x2_fused, y2_fused, theta2_fused, time2, 'Path2');
function time = get_time(timestamps)
timestamps = datetime(timestamps, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSS');
time = seconds(timestamps - timestamps(1));
end
function [x_enc, y_enc, theta_enc, x_imu, y_imu, theta_imu, x_fused, y_fused, theta_fused] = ...
reconstruct_trajectory(data, pulse_to_distance, track_width)
left_counts = data.left_encoder_count;
right_counts = data.right_encoder_count;
accel_x = data.accel_x;
accel_y = data.accel_y;
gyro_z = data.gyro_z;
heading = deg2rad(data.heading);
timestamps = datetime(data.timestamp, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSS');
dt = seconds(diff(timestamps));
dt = [dt(1); dt];
n = length(left_counts);
x_enc = zeros(n, 1); y_enc = zeros(n, 1); theta_enc = zeros(n, 1);
x_imu = zeros(n, 1); y_imu = zeros(n, 1); theta_imu = zeros(n, 1);
x_fused = zeros(n, 1); y_fused = zeros(n, 1); theta_fused = zeros(n, 1);
vx_imu = 0; vy_imu = 0;
for i = 1:n-1
d_left = (left_counts(i+1) - left_counts(i)) * pulse_to_distance;
d_right = (right_counts(i+1) - right_counts(i)) * pulse_to_distance;
d_center = (d_left + d_right) / 2;
d_theta = (d_right - d_left) / track_width;
theta_enc(i+1) = theta_enc(i) + d_theta;
x_enc(i+1) = x_enc(i) + d_center * cos(theta_enc(i+1));
y_enc(i+1) = y_enc(i) + d_center * sin(theta_enc(i+1));
end
for i = 1:n-1
theta_imu(i+1) = theta_imu(i) + gyro_z(i) * dt(i);
vx_imu = vx_imu + accel_x(i) * dt(i);
vy_imu = vy_imu + accel_y(i) * dt(i);
x_imu(i+1) = x_imu(i) + vx_imu * dt(i);
y_imu(i+1) = y_imu(i) + vy_imu * dt(i);
end
alpha = 0.9;
beta = 0.6;
for i = 1:n
theta_fused(i) = alpha * theta_enc(i) + (1-alpha) * (beta * theta_imu(i) + (1-beta) * heading(i));
x_fused(i) = alpha * x_enc(i) + (1-alpha) * x_imu(i);
y_fused(i) = alpha * y_enc(i) + (1-alpha) * y_imu(i);
end
end
function plot_trajectory(x_enc, y_enc, x_imu, y_imu, x_fused, y_fused, theta_fused, time,
title_str)
figure('Name', title_str, 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);
subplot(2, 2, 1);
plot(x_enc, y_enc, 'b-', 'LineWidth', 2);
title([title_str ': Encoder Odometry']); xlabel('X (m)'); ylabel('Y (m)'); grid on; axis equal;
subplot(2, 2, 2);
plot(x_imu, y_imu, 'r-', 'LineWidth', 2);
title([title_str ': IMU Integration']); xlabel('X (m)'); ylabel('Y (m)'); grid on; axis equal;
subplot(2, 2, 3);
plot(x_fused, y_fused, 'g-', 'LineWidth', 2); hold on;
plot(x_fused(1), y_fused(1), 'bo', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Start');
plot(x_fused(end), y_fused(end), 'ro', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'End');
title([title_str ': Sensor Fusion']); xlabel('X (m)'); ylabel('Y (m)'); legend; grid on; axis
equal;
subplot(2, 2, 4);
plot(time(1:end-1), rad2deg(theta_fused(1:end-1)), 'k-', 'LineWidth', 2);
title([title_str ': Fused Orientation']); xlabel('Time (s)'); ylabel('Orientation (degrees)');
grid on;
end
