import numpy as np
from opensimplex import OpenSimplex
import math
import random


def cylinder_noise(nx, ny, simplex):
    TAU = 0.2 * math.pi
    angle_x = nx * TAU
    return simplex.noise3(math.cos(angle_x)/TAU, math.sin(angle_x)/TAU, ny)


def generate_map(width, height, scale, seed, octaves, persistence, lacunarity, redistribution, boundary_noise=False):
    """
    Generate a 2D noise map using OpenSimplexNoise.
    """
    simplex = OpenSimplex(seed=int(seed))
    map = np.zeros((width, height))

    for x in range(width):
        for y in range(height):
            amplitude = 1.0
            frequency = 1.0
            noise_value = 0.0
            for _ in range(octaves):
                nx = x * scale * frequency
                ny = y * scale * frequency
                if boundary_noise:
                    noise_value += cylinder_noise(ny, nx, simplex) * amplitude
                else:
                    noise_value += simplex.noise2(nx, ny) * amplitude
                amplitude *= persistence
                frequency *= lacunarity
            map[x, y] = noise_value ** redistribution

    # Normalize values to 0.0 - 1.0
    map = (map - map.min()) / (map.max() - map.min())
    return map

def place_all_resources(elevation_map, temperature_map, num_samples=1000, min_distance=5):
    """
    Place all resources using Poisson Disk Sampling, weighted by elevation and temperature.

    Args:
        elevation_map (numpy.ndarray): 2D array of elevation values.
        temperature_map (numpy.ndarray): 2D array of temperature values.
        num_samples (int): The number of candidate points to try.
        min_distance (int): The minimum distance between placed resources.

    Returns:
        dict: A dictionary containing 2D arrays for each resource type (e.g., "iron_ore", "peat").
    """
    height, width = elevation_map.shape

    def suitability(x, y, resource_type):
        """
        Calculate the suitability score for placing a resource at a given tile.
        """
        e = elevation_map[x, y]
        t = temperature_map[x, y]

        if resource_type == "iron_ore":
            return max(0, e - 0.5) * (1 - abs(t - 0.5))  # Prefers high elevation and moderate temp
        elif resource_type == "peat":
            return max(0, 0.5 - t) * (1 - abs(e - 0.3))  # Prefers low temp and moderate elevation
        return 0

    resources = {"iron_ore": np.zeros((height, width)), "peat": np.zeros((height, width))}

    for resource_type in resources:
        samples = []
        for _ in range(num_samples):
            x, y = random.randint(0, height - 1), random.randint(0, width - 1)

            # Check if the point is far enough from existing resources of the same type
            if any(np.linalg.norm(np.array([x, y]) - np.array([sx, sy])) < min_distance for sx, sy in samples):
                continue

            # Determine suitability and decide placement
            if random.random() < suitability(x, y, resource_type):
                resources[resource_type][x, y] = 1
                samples.append((x, y))

    return resources

def generate_temperature_map(height, width, elevation_map):
    """
    Generate a temperature map based on latitude and elevation.
    
    Args:
        height (int): Map height.
        width (int): Map width.
        elevation_map (numpy.ndarray): 2D array of elevation values (0.0 to 1.0).
    
    Returns:
        numpy.ndarray: 2D array of temperature values (0.0 to 1.0).
    """
    temperature_map = np.zeros((height, width))
    for y in range(height):
        latitude_factor = np.sin((np.pi * y) / height)  # Latitude-based temperature
        for x in range(width):
            elevation = elevation_map[y, x]
            temperature = latitude_factor - elevation * 0.2  # Elevation cools temperature
            temperature_map[y, x] = temperature
    
    # Normalize temperature to 0.0 - 1.0
    temperature_map = (temperature_map - temperature_map.min()) / (temperature_map.max() - temperature_map.min())
    return temperature_map

def generate_combined_map(elevation_map, moisture_map, temperature_map, resources):
    """
    Combine elevation, moisture, temperature, and resources into a single map.

    Args:
        elevation_map (numpy.ndarray): 2D array of elevation values.
        moisture_map (numpy.ndarray): 2D array of moisture values.
        temperature_map (numpy.ndarray): 2D array of temperature values.
        resources (dict): Dictionary containing resource maps (e.g., "iron_ore", "peat").

    Returns:
        numpy.ndarray: 3D array where each cell contains elevation, moisture, temperature, and resource data.
    """
    height, width = elevation_map.shape
    combined_map = np.zeros((height, width, 4 + len(resources)))

    # Add elevation, moisture, and temperature layers
    combined_map[:, :, 0] = elevation_map
    combined_map[:, :, 1] = moisture_map
    combined_map[:, :, 2] = temperature_map

    # Build biome map
    combined_map[:, :, 3] = build_biome_map(elevation_map, moisture_map, temperature_map)

    # Add resource layers
    for i, (resource_name, resource_map) in enumerate(resources.items(), start=4):
        combined_map[:, :, i] = resource_map

    return combined_map

def build_biome_map(elevation_map, moisture_map, temperature_map):
    """
    Build a biome map based on elevation, moisture, and temperature.

    Args:
        elevation_map (numpy.ndarray): 2D array of elevation values.
        moisture_map (numpy.ndarray): 2D array of moisture values.
        temperature_map (numpy.ndarray): 2D array of temperature values.

    Returns:
        numpy.ndarray: 2D array of biome enums.
    """
    height, width = elevation_map.shape
    biome_map = np.zeros((height, width))

    for x in range(height):
        for y in range(width):
            e = elevation_map[x, y]
            m = moisture_map[x, y]
            t = temperature_map[x, y]

            # Biome classification logic (returns integer for enum)
            if e < 0.4:
                biome_map[x, y] = 0  # OCEAN
            elif e < 0.42:
                biome_map[x, y] = 1  # BEACH
            elif e > 0.8:
                if m < 0.1:
                    biome_map[x, y] = 2  # SCORCHED
                elif m < 0.2:
                    biome_map[x, y] = 3  # BARE
                elif m < 0.5:
                    biome_map[x, y] = 4  # TUNDRA
                else:
                    biome_map[x, y] = 5  # SNOW
            elif e > 0.65:
                if m < 0.33:
                    biome_map[x, y] = 6  # TEMPERATE_DESERT
                elif m < 0.66:
                    biome_map[x, y] = 7  # SHRUBLAND
                else:
                    biome_map[x, y] = 8  # TAIGA
            elif e > 0.47:
                if m < 0.16:
                    biome_map[x, y] = 6  # TEMPERATE_DESERT
                elif m < 0.50:
                    biome_map[x, y] = 9  # GRASSLAND
                elif m < 0.83:
                    biome_map[x, y] = 10  # TEMPERATE_DECIDUOUS_FOREST
                else:
                    biome_map[x, y] = 11  # TEMPERATE_RAIN_FOREST
            else:
                if m < 0.16:
                    biome_map[x, y] = 6  # SUBTROPICAL_DESERT
                elif m < 0.33:
                    biome_map[x, y] = 9  # GRASSLAND
                elif m < 0.66:
                    biome_map[x, y] = 12  # TROPICAL_SEASONAL_FOREST
                else:
                    biome_map[x, y] = 13  # TROPICAL_RAIN_FOREST

    return biome_map

def biome(e, m):
    """
    Determine the biome type based on elevation (e) and moisture (m).
    """
    if e < 0.4:
        return [0.0, 0.0, 0.5]  # OCEAN
    if e < 0.42:
        return [0.9, 0.8, 0.6]  # BEACH

    if e > 0.8:
        if m < 0.1:
            return [0.5, 0.5, 0.5]  # SCORCHED
        if m < 0.2:
            return [0.6, 0.6, 0.6]  # BARE
        if m < 0.5:
            return [0.8, 0.8, 0.8]  # TUNDRA
        return [1.0, 1.0, 1.0]  # SNOW

    if e > 0.65:
        if m < 0.33:
            return [0.9, 0.85, 0.55]  # TEMPERATE_DESERT
        if m < 0.66:
            return [0.5, 0.7, 0.5]  # SHRUBLAND
        return [0.3, 0.6, 0.6]  # TAIGA

    if e > 0.47:
        if m < 0.16:
            return [0.9, 0.85, 0.55]  # TEMPERATE_DESERT
        if m < 0.50:
            return [0.5, 0.8, 0.3]  # GRASSLAND
        if m < 0.83:
            return [0.2, 0.6, 0.2]  # TEMPERATE_DECIDUOUS_FOREST
        return [0.1, 0.4, 0.1]  # TEMPERATE_RAIN_FOREST

    if m < 0.16:
        return [0.9, 0.85, 0.55]  # SUBTROPICAL_DESERT
    if m < 0.33:
        return [0.5, 0.8, 0.3]  # GRASSLAND
    if m < 0.66:
        return [0.2, 0.6, 0.2]  # TROPICAL_SEASONAL_FOREST
    return [0.1, 0.4, 0.1]  # TROPICAL_RAIN_FOREST


def biome2(e, m, t):
    """
    Determine the biome type based on elevation (e), moisture (m), and temperature (t).
    """
    if e < 0.4:
        return [0.0, 0.0, 0.5]  # OCEAN
    if e < 0.42:
        return [0.9, 0.8, 0.6]  # BEACH

    if e > 0.8:
        if t < 0.2:
            return [1.0, 1.0, 1.0]  # SNOW
        if m < 0.1:
            return [0.5, 0.5, 0.5]  # SCORCHED
        if m < 0.2:
            return [0.6, 0.6, 0.6]  # BARE
        if m < 0.5:
            return [0.8, 0.8, 0.8]  # TUNDRA
        return [1.0, 1.0, 1.0]  # GLACIAL

    if e > 0.65:
        if t > 0.7 and m < 0.16:
            return [1.0, 0.8, 0.3]  # HOT DESERT
        if m < 0.33:
            return [0.9, 0.85, 0.55]  # TEMPERATE_DESERT
        if m < 0.66:
            return [0.5, 0.7, 0.5]  # SHRUBLAND
        return [0.3, 0.6, 0.6]  # TAIGA

    if e > 0.47:
        if t > 0.8 and m < 0.16:
            return [1.0, 0.8, 0.3]  # HOT DESERT
        if m < 0.16:
            return [0.9, 0.85, 0.55]  # TEMPERATE_DESERT
        if m < 0.50:
            return [0.5, 0.8, 0.3]  # GRASSLAND
        if m < 0.83:
            return [0.2, 0.6, 0.2]  # TEMPERATE_DECIDUOUS_FOREST
        return [0.1, 0.4, 0.1]  # TEMPERATE_RAIN_FOREST

    if t > 0.8:
        if m < 0.16:
            return [1.0, 0.8, 0.3]  # SUBTROPICAL_DESERT
        if m < 0.33:
            return [0.8, 0.9, 0.4]  # SAVANNA
        if m < 0.66:
            return [0.4, 0.7, 0.3]  # TROPICAL_SEASONAL_FOREST
        return [0.2, 0.5, 0.2]  # TROPICAL_RAIN_FOREST

    if m < 0.16:
        return [0.9, 0.85, 0.55]  # SUBTROPICAL_DESERT
    if m < 0.33:
        return [0.5, 0.8, 0.3]  # GRASSLAND
    if m < 0.66:
        return [0.2, 0.6, 0.2]  # TROPICAL_SEASONAL_FOREST
    return [0.1, 0.4, 0.1]  # TROPICAL_RAIN_FOREST