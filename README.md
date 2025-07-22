# Mechatronics System Design Project

A comprehensive mechatronics system design project featuring CAD mechanism design, multi-sensor data fusion for vehicle trajectory reconstruction, and advanced sensor analysis including LIDAR, stereo vision, and Time-of-Flight sensors.

## Project Overview

This project contains three major components of modern mechatronic systems:

1. **Four-Bar Linkage Design** - CAD modeling and kinematic analysis
2. **Ground Vehicle Trajectory Reconstruction** - Multi-sensor fusion approach
3. **Advanced Sensor Analysis** - LIDAR, ZED Stereo Camera, and ToF sensor data processing

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Results](#results)

## Features

### Part 1: Four-Bar Linkage Mechanism
- ✅ Crank-rocker configuration design
- ✅ Grashof's condition compliance
- ✅ Fusion 360 CAD modeling
- ✅ Kinematic simulation and analysis
- ✅ Complete 360° rotation capability

### Part 2: Ground Vehicle Navigation
- ✅ Multi-sensor data fusion (Encoders + IMU + Magnetometer)
- ✅ Wheel encoder-based odometry
- ✅ IMU-based motion estimation
- ✅ Magnetometer heading correction
- ✅ Trajectory reconstruction and visualization
- ✅ Real-time sensor fusion algorithms

### Part 3: Advanced Sensor Processing
- ✅ LIDAR point cloud visualization and analysis
- ✅ ZED stereo camera 3D reconstruction
- ✅ Time-of-Flight sensor distance measurement
- ✅ Black object detection analysis
- ✅ Multi-modal sensor comparison

## Technologies Used

### Software & Platforms
- **Fusion 360** - CAD design and simulation
- **MATLAB** - Sensor fusion and data analysis
- **Python** - Point cloud processing and visualization
- **Open3D** - 3D computer vision library
- **OpenCV** - Computer vision operations

### Key Libraries
```
MATLAB: Signal Processing, Computer Vision
Python: NumPy, OpenCV, Open3D, Matplotlib, Pickle
```

## Results

### Trajectory Reconstruction Performance
- **Path 1**: Complex curved trajectory successfully reconstructed
- **Path 2**: Multi-turn path with high accuracy
- **Fusion Benefit**: Reduced drift by 60% compared to single-sensor

### 3D Reconstruction Quality
- **Point Density**: 50,000+ points per scene
- **Color Accuracy**: Full RGB preservation
- **Depth Range**: 0.1m - 10.0m effective range

### Sensor Comparison
| Sensor | Accuracy | Range | Update Rate |
|--------|----------|-------|-------------|
| Encoder | ±0.1mm | Unlimited | 100Hz |
| IMU | ±0.5° | N/A | 100Hz |
| LIDAR | ±2cm | 0.1-100m | 10Hz |
| ToF | ±2cm | 0.03-2m | 50Hz |

More detailed results are mentioned in the Report.

---
