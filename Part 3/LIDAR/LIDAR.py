import numpy as np
import open3d as o3d
import pickle
import matplotlib.pyplot as plt

pcd = o3d.io.read_point_cloud("scan_team_common.pcd")
points = np.asarray(pcd.points)

with open("scan_vector_team_common.pkl", "rb") as f:
    pkl_data = pickle.load(f)

if isinstance(pkl_data, np.ndarray):
    points_pkl = pkl_data
else:
    points_pkl = np.array(pkl_data)

all_points = np.vstack((points, points_pkl))

x = all_points[:, 0]
y = all_points[:, 1]

plt.figure(figsize=(10, 8))
plt.scatter(x, y, s=1, c='blue', label='LIDAR Points')
plt.title("2D Outline Map of Scanned Environment")
plt.xlabel("X (meters)")
plt.ylabel("Y (meters)")
plt.grid(True)
plt.legend()
plt.axis('equal')
plt.savefig("2d_outline_map.png")
plt.show()