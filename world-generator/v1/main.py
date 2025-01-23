import tkinter as tk
from tkinter import ttk
from map_generator import generate_map, generate_temperature_map, place_all_resources, generate_combined_map
from render import render_map

# Map dimensions
MAP_WIDTH = 256
MAP_HEIGHT = 256

DEFAULTS = {
    "seed": "42",
    "scale": 0.02,
    "octaves": 4,
    "persistence": 0.5,
    "lacunarity": 2.0,
    "redistribution": 1.0,
}

def update_map():
    # Get the values from the GUI
    e_seed = e_seed_var.get()
    e_scale = e_scale_var.get()
    e_octaves = e_octaves_var.get()
    e_persistence = e_persistence_var.get()
    e_lacunarity = e_lacunarity_var.get()
    e_redistribution = e_redistribution_var.get()

    m_seed = m_seed_var.get()
    m_scale = m_scale_var.get()
    m_octaves = m_octaves_var.get()
    m_persistence = m_persistence_var.get()
    m_lacunarity = m_lacunarity_var.get()
    m_redistribution = m_redistribution_var.get()

    # Generate maps
    elevation_map = generate_map(MAP_WIDTH, MAP_HEIGHT, e_scale, e_seed, e_octaves, e_persistence, e_lacunarity, e_redistribution, False)
    moisture_map = generate_map(MAP_WIDTH, MAP_HEIGHT, m_scale, m_seed, m_octaves, m_persistence, m_lacunarity, m_redistribution, False)
    temperature_map = generate_temperature_map(MAP_WIDTH, MAP_HEIGHT, elevation_map)
    resources = place_all_resources(elevation_map, temperature_map)

    combined_map = generate_combined_map(elevation_map, moisture_map, temperature_map, resources)

    # Render maps
    # render_map(elevation_map, moisture_map, temperature_map)
    render_map(combined_map)

# Initialize the main GUI window
root = tk.Tk()
root.title("Map Generator")

### ELEVATION SETTINGS ###

# Elevation Seed Entry
tk.Label(root, text="Elevation Seed:").grid(row=0, column=0, sticky="w")
e_seed_var = tk.StringVar(value=DEFAULTS["seed"])
tk.Entry(root, textvariable=e_seed_var).grid(row=0, column=1)

# Elevation Scale Slider
tk.Label(root, text="Elevation Scale:").grid(row=1, column=0, sticky="w")
e_scale_var = tk.DoubleVar(value=DEFAULTS["scale"])
tk.Scale(root, from_=0.01, to=0.1, resolution=0.01, orient="horizontal", variable=e_scale_var).grid(row=1, column=1)

# Elevation Octaves Slider
tk.Label(root, text="Elevation Octaves:").grid(row=2, column=0, sticky="w")
e_octaves_var = tk.IntVar(value=DEFAULTS["octaves"])
tk.Scale(root, from_=1, to=8, resolution=1, orient="horizontal", variable=e_octaves_var).grid(row=2, column=1)

# Elevation Persistence Slider
tk.Label(root, text="Elevation Persistence:").grid(row=3, column=0, sticky="w")
e_persistence_var = tk.DoubleVar(value=DEFAULTS["persistence"])
tk.Scale(root, from_=0.1, to=1.0, resolution=0.1, orient="horizontal", variable=e_persistence_var).grid(row=3, column=1)

# Elevation Lacunarity Slider
tk.Label(root, text="Elevation Lacunarity:").grid(row=4, column=0, sticky="w")
e_lacunarity_var = tk.DoubleVar(value=DEFAULTS["lacunarity"])
tk.Scale(root, from_=1.0, to=3.0, resolution=0.1, orient="horizontal", variable=e_lacunarity_var).grid(row=4, column=1)

# Elevation Redistribution Slider
tk.Label(root, text="Elevation Redistribution:").grid(row=5, column=0, sticky="w")
e_redistribution_var = tk.DoubleVar(value=DEFAULTS["redistribution"])
tk.Scale(root, from_=1, to=10, resolution=1, orient="horizontal", variable=e_redistribution_var).grid(row=5, column=1)

### MOISTURE SETTINGS ###

# Moisture Seed Entry
tk.Label(root, text="Moisture Seed:").grid(row=0, column=2, sticky="w")
m_seed_var = tk.StringVar(value=DEFAULTS["seed"])
tk.Entry(root, textvariable=m_seed_var).grid(row=0, column=3)

# Moisture Scale Slider
tk.Label(root, text="Moisture Scale:").grid(row=1, column=2, sticky="w")
m_scale_var = tk.DoubleVar(value=DEFAULTS["scale"])
tk.Scale(root, from_=0.01, to=0.1, resolution=0.01, orient="horizontal", variable=m_scale_var).grid(row=1, column=3)

# Moisture Octaves Slider
tk.Label(root, text="Moisture Octaves:").grid(row=2, column=2, sticky="w")
m_octaves_var = tk.IntVar(value=DEFAULTS["octaves"])
tk.Scale(root, from_=1, to=8, resolution=1, orient="horizontal", variable=m_octaves_var).grid(row=2, column=3)

# Moisture Persistence Slider
tk.Label(root, text="Moisture Persistence:").grid(row=3, column=2, sticky="w")
m_persistence_var = tk.DoubleVar(value=DEFAULTS["persistence"])
tk.Scale(root, from_=0.1, to=1.0, resolution=0.1, orient="horizontal", variable=m_persistence_var).grid(row=3, column=3)

# Moisture Lacunarity Slider
tk.Label(root, text="Moisture Lacunarity:").grid(row=4, column=2, sticky="w")
m_lacunarity_var = tk.DoubleVar(value=DEFAULTS["lacunarity"])
tk.Scale(root, from_=1.0, to=3.0, resolution=0.1, orient="horizontal", variable=m_lacunarity_var).grid(row=4, column=3)

# Moisture Redistribution Slider
tk.Label(root, text="Moisture Redistribution:").grid(row=5, column=2, sticky="w")
m_redistribution_var = tk.DoubleVar(value=DEFAULTS["redistribution"])
tk.Scale(root, from_=1, to=10, resolution=1, orient="horizontal", variable=m_redistribution_var).grid(row=5, column=3)



# Generate Button
tk.Button(root, text="Generate Map", command=update_map).grid(row=6, column=0, columnspan=2)

# Run the GUI loop
root.mainloop()
