## Residence slot
- Every building has a max number of residence
- A pop is assigned to a residence slot of a certain building (pop resides in a building)

## Assignment rules
- If Pop does not reside in a building by the end of turn (for example building was destroyed or pop was just born in this turn or resettled from other settlement etc), then
	- If exists a building in the same settlement with a free pop slot - settle there
	- If exists an open slot - build slums there (free) and reside there
	- If slot not exists - kill pop (if there are no other options like auto resettlement etc)
