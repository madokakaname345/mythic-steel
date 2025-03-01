Settlement is a core entity which consists of buildings, residents, cells


## Cells
Settlement has assigned cells. It is possible to build buildings in these cells
## Residents (Pops)
Settlement has assigned residents (pops). They reside in residential slots of settlement structures and work in worker slots in settlement structures
## Buildings
Settlement has buildings, which are assigned to cells of this settlement
## Resources
Settlement resources are resources stored/produced in the settlement's buildings. These resources are available for settlement pops and  buildings
## End turn actions
When turn ends: 
- every settlement building processes the end turn function (produces resources etc)
- The city spares resources on every pop
- If pop's basic needs >= pop's max basic needs, new pop is created
	- Assignment rules:  [[Pop Residence#Assignment rules]], [[Pop Occupation#Assignment rules]]