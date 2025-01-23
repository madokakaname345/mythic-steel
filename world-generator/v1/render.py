import matplotlib.pyplot as plt
import numpy as np

biome_colors = {
        0: [0.0, 0.0, 0.5],   # OCEAN
        1: [0.9, 0.8, 0.6],   # BEACH
        2: [0.5, 0.5, 0.5],   # SCORCHED
        3: [0.6, 0.6, 0.6],   # BARE
        4: [0.8, 0.8, 0.8],   # TUNDRA
        5: [1.0, 1.0, 1.0],   # SNOW
        6: [0.9, 0.85, 0.55], # TEMPERATE_DESERT
        7: [0.5, 0.7, 0.5],   # SHRUBLAND
        8: [0.3, 0.6, 0.6],   # TAIGA
        9: [0.5, 0.8, 0.3],   # GRASSLAND
        10: [0.2, 0.6, 0.2],  # TEMPERATE_DECIDUOUS_FOREST
        11: [0.1, 0.4, 0.1],  # TEMPERATE_RAIN_FOREST
        12: [0.4, 0.7, 0.3],  # TROPICAL_SEASONAL_FOREST
        13: [0.2, 0.5, 0.2],  # TROPICAL_RAIN_FOREST
    }

# def render_map(elevation_map, moisture_map, temperature_map):
#     """
#     Render three maps: elevation-only, moisture-only, and combined biome map in a single window.
    
#     Args:
#         elevation_map (numpy.ndarray): 2D array of elevation values.
#         moisture_map (numpy.ndarray): 2D array of moisture values.
#     """
#     # Create a combined biome map
#     biome_map = np.zeros((elevation_map.shape[0], elevation_map.shape[1], 3))
#     for x in range(elevation_map.shape[0]):
#         for y in range(elevation_map.shape[1]):
#             e = elevation_map[x, y]
#             m = moisture_map[x, y]
#             t = temperature_map[x, y]
#             biome_map[x, y] = biome2(e, m, t)

#     # Plot all maps in one window
#     fig, axs = plt.subplots(1, 4, figsize=(18, 6))

#     # Elevation map
#     axs[0].imshow(elevation_map, cmap="terrain", interpolation="nearest")
#     axs[0].set_title("Elevation Map")
#     axs[0].axis("off")

#     # Moisture map
#     axs[1].imshow(moisture_map, cmap="Blues", interpolation="nearest")
#     axs[1].set_title("Moisture Map")
#     axs[1].axis("off")

#     # Biome map
#     axs[2].imshow(biome_map, interpolation="nearest")
#     axs[2].set_title("Biome Map")
#     axs[2].axis("off")

#         # Temperature map
#     axs[3].imshow(temperature_map, cmap="coolwarm", interpolation="nearest")
#     axs[3].set_title("Temperature Map")
#     axs[3].axis("off")

#     plt.tight_layout()
#     plt.show()

def render_map(combined_map, biome_colors=biome_colors):
    """
    Render all maps from the combined_map, including elevation, moisture, temperature, biome, and resources.

    Args:
        combined_map (numpy.ndarray): 3D array containing elevation, moisture, temperature, biome, and resources.
        biome_colors (dict): Dictionary mapping biome enums to RGB colors.
    """
    elevation_map = combined_map[:, :, 0]
    moisture_map = combined_map[:, :, 1]
    temperature_map = combined_map[:, :, 2]
    biome_map = combined_map[:, :, 3].astype(int)
    resource_layers = combined_map[:, :, 4:]

    # Plot maps
    num_maps = 4 + resource_layers.shape[2]  # Elevation, Moisture, Temperature, Biome + Resources
    fig, axs = plt.subplots(1, num_maps, figsize=(6 * num_maps, 6))

    # Elevation map
    axs[0].imshow(elevation_map, cmap="terrain", interpolation="nearest")
    axs[0].set_title("Elevation Map")
    axs[0].axis("off")

    # Moisture map
    axs[1].imshow(moisture_map, cmap="Blues", interpolation="nearest")
    axs[1].set_title("Moisture Map")
    axs[1].axis("off")

    # Temperature map
    axs[2].imshow(temperature_map, cmap="coolwarm", interpolation="nearest")
    axs[2].set_title("Temperature Map")
    axs[2].axis("off")

    # Biome map
    height, width = biome_map.shape
    biome_image = np.zeros((height, width, 3))
    for biome, color in biome_colors.items():
        biome_image[biome_map == biome] = color

    axs[3].imshow(biome_image, interpolation="nearest")
    axs[3].set_title("Biome Map")
    axs[3].axis("off")

    # Resource maps
    resource_names = ["Resource {i}" for i in range(resource_layers.shape[2])]
    for i in range(resource_layers.shape[2]):
        axs[4 + i].imshow(biome_image, interpolation="nearest")  # Background based on biome
        axs[4 + i].scatter(
            *np.where(resource_layers[:, :, i] > 0)[::-1],  # Reverse x and y for scatter
            c="black",
            s=10,  # Size of resource markers
            label=resource_names[i]
        )
        axs[4 + i].set_title(f"{resource_names[i]} Map")
        axs[4 + i].axis("off")

    plt.tight_layout()
    plt.show()