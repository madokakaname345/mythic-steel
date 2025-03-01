# Game Design Document

## **Game Title**
*Mythic Steel*

## **Core Concept**
A strategy-RPG hybrid set in an ancient/medieval world. Players manage settlements, resources, and exploration while progressing through technological ages (e.g., Copper, Bronze, Iron, Steel). The focus is on resource production, trade, and survival in a dynamic, procedurally generated world.

---

## **Core Mechanics**

### **1. Settlements and Cities**
Full design: [[Settlement]]
#### **City System**
- Cities are central to gameplay and have the following features:
  - **Leveling Up**: Cities level up based on population and production, unlocking additional building slots.
  - **Building Slots**: Divided into:
    - **Generic Slots**: Any building can be placed.
    - **Specialized Slots**: Specific buildings like mines or farms.
    - **Residential Slots**: For population housing.
  - **Terrain-Based Areas**: Each city has a maximum area, divided into terrain types (e.g., plains, hills, mountains, river-adjacent).

#### **Population System**
- **Growth**: Population grows based on surplus food.
- **Assignment**: Population is automatically assigned to buildings requiring workers.
- **Overcrowding**: Exceeding residential capacity reduces efficiency.

---

### **2. Resource Management**
#### **Resource Categories**
1. **Raw Resources**: Timber, clay, iron ore, copper ore, tin ore, skins, fiber, stone.
2. **Processed Resources**: Copper, iron, tin, steel, charcoal, leather, linen/yarn, building materials.
3. **Final Products**: Weapons, armor, tools, ceramics, furniture, ships, battleships.
4. **Food**: Initially a single resource, later expanded into grain, meat, fruits, dairy, seafood, etc.

#### **Food Mechanics**
- **Spoilage**: Food has an expiration date based on type (e.g., meat: 1 turn, grain: 6 turns).
- **Preservation**: Granaries and other buildings reduce spoilage rates.

#### **Resource Production**
- Resources are produced by specific buildings:
  - Mines for ore.
  - Farms for food.
  - Refineries for processed goods.
- Resource clusters spawn logically (e.g., ores in mountains, peat in swamps).

---

### **3. Exploration and Map**
#### **Region-Based Map**
- **Regions**: Divided by biomes (plains, forests, deserts, etc.) and natural features (mountains, rivers).
- **Generation Process**:
  1. Mountains → Rivers → Biomes (temperature-based).
  2. Resources placed in clusters, often spanning multiple regions.

#### **Expedition System**
- **Resource-Based Operation**: Expeditions require food and tools.
- **Player-Controlled Routes**: Players set routes turn-by-turn.
- **Dynamic Events**:
  - Encounters with native villages, resource discoveries, or hazards.
- **Specialists**:
  - **Prospectors**: Discover resources.
  - **Surveyors**: Assess fertility.
  - **Scouts**: Detect hazards.
  - **Naturalists**: Find rare flora/fauna.
  - **Negotiators**: Handle diplomacy with natives.
- **End Conditions**: Expeditions end when food runs out; discoveries are automatically recorded.

---

### **4. Economy and Trade**
#### **Resource-Based Economy**
- **Barter System**:
  - Resources are traded directly without a traditional currency.
  - Base values for resources with optional dynamic adjustments.
- **Gold/Silver**:
  - Act as universal trade items.
  - Example: 1 Gold = 20, 1 Silver = 10.

#### **Trade Routes**
- **Connection Requirement**: Cities must be connected by roads or rivers to trade.
- **Transport Costs**: Goods incur small transportation penalties.

#### **Revenue Generation**
- **Taxation**: Based on population and production.
- **Trade Profits**: Based on trade route activity.
- **Building Output**: Specialized goods generate passive income.

---

### **5. Technology Progression**
#### **Technology Groups**
- **Examples**: Mining, Agriculture, Fishing (Shipbuilding), Architecture, Philosophy.
- **Experience Points (XP)**:
  - Buildings and actions generate group-specific XP.
  - Example: Mines produce mining XP and general science XP.

#### **Unlocking Technologies**
- **Randomized Options**: Players unlock 3 random technologies per group.
- **Requirements**:
  - Other technologies.
  - Buildings (e.g., Granary for crop rotation).
  - Trade routes or specific resources.

#### **Generic Research Points**
- Convert to group-specific XP via educational buildings (e.g., Libraries).
- Use to bypass randomness and select specific technologies.

---

### **6. War Mechanics**
#### **Army System**
- **Units**:
  - Represent groups of warriors, stationed in settlements or given orders (attack, defend).
  - Movement restricted to roads.
- **Resources for War**:
  - Food, armor, weapons, horses, supplies.
  - Armies near friendly cities draw food from local storage.

#### **Raiding**
- Armies can raid enemy settlements to steal food and supplies.
- Raiding damages enemy production temporarily.

#### **City Capture**
- Players can capture cities with associated penalties (e.g., unrest, reduced productivity).

---

### **7. Victory Conditions**
#### **Paths to Victory**
1. **Economic Dominance**:
   - Accumulate wealth, control trade, or monopolize resources.
2. **Cultural Dominance**:
   - Build landmarks, spread cultural influence.
3. **Technological Dominance**:
   - Advance to the highest age (e.g., Steel Age).
4. **Territorial Control**:
   - Dominate the map through expansion and control.

---

### **8. Late-Game Challenges**
- **World Events**:
  - Natural disasters, resource shortages, or invasions.
- **AI Competitors**:
  - Rival civilizations grow and adapt.
- **Market Saturation**:
  - Overproduction devalues resources, encouraging diversification.

---

## **Next Steps**
1. **Finalize Exploration Mechanics**:
   - Design specific event types and rewards.
2. **Refine Trade Systems**:
   - Simplify dynamic pricing and route logistics.
3. **Develop Prototype**:
   - Focus on settlement building, resource management, and exploration.

