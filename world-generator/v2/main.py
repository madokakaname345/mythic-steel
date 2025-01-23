import tkinter as tk
import matplotlib.pyplot as plt
import numpy as np
from opensimplex import OpenSimplex

# Map dimensions
MAP_WIDTH = 256
MAP_HEIGHT = 256

# Default parameters
DEFAULTS = {
    "seed": 42,
    "scale": 0.05,
    "octaves": 4,
    "persistence": 0.5,
    "lacunarity": 2.0,
}

def generate_noise_map(width, height, scale, seed, octaves, persistence, lacunarity):
    """
    Generate a 2D noise map using OpenSimplex noise.
    """
    simplex = OpenSimplex(seed=seed)
    noise_map = np.zeros((width, height))

    for x in range(width):
        for y in range(height):
            amplitude = 1.0
            frequency = 1.0
            noise_value = 0.0
            for _ in range(octaves):
                nx = x * scale * frequency / width
                ny = y * scale * frequency / height
                noise_value += simplex.noise2(nx, ny) * amplitude
                amplitude *= persistence
                frequency *= lacunarity
            noise_map[x, y] = noise_value

    # Normalize values to 0.0 - 1.0
    noise_map = (noise_map - noise_map.min()) / (noise_map.max() - noise_map.min())
    return noise_map

def render_maps(elevation_map, moisture_map):
    """
    Render elevation map, moisture map, and their combination.
    """
    # Combined map
    combined_map = (elevation_map + moisture_map) / 2.0

    # Plot maps
    fig, axs = plt.subplots(1, 3, figsize=(18, 6))

    # Elevation map
    axs[0].imshow(elevation_map, cmap="terrain", interpolation="nearest")
    axs[0].set_title("Elevation Map")
    axs[0].axis("off")

    # Moisture map
    axs[1].imshow(moisture_map, cmap="Blues", interpolation="nearest")
    axs[1].set_title("Moisture Map")
    axs[1].axis("off")

    # Combined map
    axs[2].imshow(combined_map, cmap="viridis", interpolation="nearest")
    axs[2].set_title("Combined Map")
    axs[2].axis("off")

    plt.tight_layout()
    plt.show()

def update_maps():
    """
    Generate and render the maps with user-defined parameters.
    """
    seed = int(seed_var.get())
    scale = scale_var.get()
    octaves = int(octaves_var.get())
    persistence = persistence_var.get()
    lacunarity = lacunarity_var.get()

    elevation_map = generate_noise_map(
        MAP_WIDTH, MAP_HEIGHT, scale, seed, octaves, persistence, lacunarity
    )
    moisture_map = generate_noise_map(
        MAP_WIDTH, MAP_HEIGHT, scale, seed + 1, octaves, persistence, lacunarity
    )

    render_maps(elevation_map, moisture_map)

# Initialize GUI
root = tk.Tk()
root.title("Map Generator")

# Seed Entry
tk.Label(root, text="Seed:").grid(row=0, column=0, sticky="w")
seed_var = tk.StringVar(value=str(DEFAULTS["seed"]))
tk.Entry(root, textvariable=seed_var).grid(row=0, column=1)

# Scale Slider
tk.Label(root, text="Scale:").grid(row=1, column=0, sticky="w")
scale_var = tk.DoubleVar(value=DEFAULTS["scale"])
tk.Scale(root, from_=0.01, to=0.1, resolution=0.01, orient="horizontal", variable=scale_var).grid(row=1, column=1)

# Octaves Slider
tk.Label(root, text="Octaves:").grid(row=2, column=0, sticky="w")
octaves_var = tk.IntVar(value=DEFAULTS["octaves"])
tk.Scale(root, from_=1, to=8, resolution=1, orient="horizontal", variable=octaves_var).grid(row=2, column=1)

# Persistence Slider
tk.Label(root, text="Persistence:").grid(row=3, column=0, sticky="w")
persistence_var = tk.DoubleVar(value=DEFAULTS["persistence"])
tk.Scale(root, from_=0.1, to=1.0, resolution=0.1, orient="horizontal", variable=persistence_var).grid(row=3, column=1)

# Lacunarity Slider
tk.Label(root, text="Lacunarity:").grid(row=4, column=0, sticky="w")
lacunarity_var = tk.DoubleVar(value=DEFAULTS["lacunarity"])
tk.Scale(root, from_=1.0, to=3.0, resolution=0.1, orient="horizontal", variable=lacunarity_var).grid(row=4, column=1)

# Generate Button
tk.Button(root, text="Generate Maps", command=update_maps).grid(row=5, column=0, columnspan=2)

# Run the GUI loop
root.mainloop()
