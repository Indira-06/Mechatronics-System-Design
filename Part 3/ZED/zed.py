import numpy as np
import cv2
import open3d as o3d
import matplotlib.pyplot as plt

fx = 957.08
fy = 957.08
cx = 649.15
cy = 370.98

min_depth = 0.1
max_depth = 10.

def heatmap_to_depth(heatmap):
    gray = cv2.cvtColor(heatmap, cv2.COLOR_BGR2GRAY)
    depth = (gray / 255.0) * (max_depth - min_depth) + min_depth
    return depth

def reconstruct_point_cloud(depth, color_image, fx, fy, cx, cy):
    height, width = depth.shape
    points = []
    colors = []

    color_image = cv2.cvtColor(color_image, cv2.COLOR_BGR2RGB)

    for v in range(height):
        for u in range(width):
            Z = depth[v, u]
            if Z < min_depth or Z > max_depth:
                continue
            X = (u - cx) * Z / fx
            Y = (v - cy) * Z / fy
            points.append([X, Y, Z])
            colors.append(color_image[v, u] / 255.0)

    pcd = o3d.geometry.PointCloud()
    pcd.points = o3d.utility.Vector3dVector(np.array(points))
    pcd.colors = o3d.utility.Vector3dVector(np.array(colors))
    return pcd

def visualize_depth(depth, output_heatmap_path, output_matrix_path):
    # Normalize depth for visualization (heatmap)
    depth_norm = (depth - min_depth) / (max_depth - min_depth) * 255
    depth_norm = np.clip(depth_norm, 0, 255).astype(np.uint8)
    depth_heatmap = cv2.applyColorMap(depth_norm, cv2.COLORMAP_JET)

    cv2.imwrite(output_heatmap_path, depth_heatmap)

    plt.figure(figsize=(6, 4))
    plt.imshow(depth, cmap='jet')
    plt.axis('on')
    plt.savefig(output_matrix_path)
    plt.close()

def process_dataset(color_path, heatmap_path, depth_matrix_path, output_ply_path, output_heatmap_path, output_matrix_path):
    # 1. Load the data
    color_image = cv2.imread(color_path)
    depth_heatmap = cv2.imread(heatmap_path)
    depth_matrix = np.load(depth_matrix_path)

    # Method 1: Reconstruct point cloud using depth matrix
    pcd_matrix = reconstruct_point_cloud(depth_matrix, color_image, fx, fy, cx, cy)
    o3d.io.write_point_cloud(output_ply_path + "_method1.ply", pcd_matrix)

    # Method 2: Reconstruct point cloud using depth heatmap
    depth_from_heatmap = heatmap_to_depth(depth_heatmap)
    pcd_heatmap = reconstruct_point_cloud(depth_from_heatmap, color_image, fx, fy, cx, cy)
    o3d.io.write_point_cloud(output_ply_path + "_method2.ply", pcd_heatmap)

    visualize_depth(depth_matrix, output_heatmap_path, output_matrix_path)

    plt.figure(figsize=(15, 5))

    plt.subplot(1, 3, 1)
    plt.title("Color Image")
    plt.imshow(cv2.cvtColor(color_image, cv2.COLOR_BGR2RGB))
    plt.axis('on')

    plt.subplot(1, 3, 2)
    plt.title("Depth Heatmap")
    plt.imshow(cv2.cvtColor(cv2.imread(output_heatmap_path), cv2.COLOR_BGR2RGB))
    plt.axis('on')

    plt.subplot(1, 3, 3)
    plt.title("Depth Matrix")
    plt.imshow(depth_matrix, cmap='jet')
    plt.axis('on')

    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    # Dataset 1: lab
    process_dataset(
        color_path="lab_color.png",
        heatmap_path="lab_depth_heatmap.png",
        depth_matrix_path="lab_depth_matrix.npy",
        output_ply_path="lab_point_cloud",
        output_heatmap_path="lab_depth_heatmap_output.png",
        output_matrix_path="lab_depth_matrix_output.png"
    )

    # Dataset 2: lab2
    process_dataset(
        color_path="lab2_color.png",
        heatmap_path="lab2_depth_heatmap.png",
        depth_matrix_path="lab2_depth_matrix.npy",
        output_ply_path="lab2_point_cloud",
        output_heatmap_path="lab2_depth_heatmap_output.png",
        output_matrix_path="lab2_depth_matrix_output.png"
    )