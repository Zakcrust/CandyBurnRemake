extends Resource

class_name SpawnerData


# Enemies - Stage 1
const JELLY_KERING = "JELLY KERING"
const GULA_GAIT = "GULA GAIT"
const TINTING_KACANG = "TINTING KACANG"
#Boss Stage 1
const PERMEN_KACAMATA = "PERMEN_KACAMATA"

######## WAVE DATA TEMPLATE ##################
# Parameters
# - Spawner ID [1 to 6] (int)
# - Amount of instance to spawn (int)
# - Enemy Constant (String)

#WAVE_NUMBER : {
#		1 : Wave.new(1,0, ENEMY_CONST),
#		2 : Wave.new(2,0, ENEMY_CONST),
#		3 : Wave.new(3,0, ENEMY_CONST),
#		4 : Wave.new(4,0, ENEMY_CONST),
#		5 : Wave.new(5,0, ENEMY_CONST),
#		6 : Wave.new(6,0, ENEMY_CONST)
#	},
##############################################


var wave_data = {
	1 : {
		1 : Wave.new(1),
		2 : Wave.new(2),
		3 : Wave.new(3),
		4 : Wave.new(4),
		5 : Wave.new(5),
		6 : Wave.new(6,1, PERMEN_KACAMATA)
	},
	2 : {
		1 : Wave.new(1,6, JELLY_KERING),
		2 : Wave.new(2,7, JELLY_KERING),
		3 : Wave.new(3,7, JELLY_KERING),
		4 : Wave.new(4),
		5 : Wave.new(5),
		6 : Wave.new(6)
	},
	3 : {
		1 : Wave.new(1,3, GULA_GAIT),
		2 : Wave.new(2,3, GULA_GAIT),
		3 : Wave.new(3,3, GULA_GAIT),
		4 : Wave.new(4),
		5 : Wave.new(5),
		6 : Wave.new(6)
	},
	4 : {
		1 : Wave.new(1,8, JELLY_KERING),
		2 : Wave.new(2,8, JELLY_KERING),
		3 : Wave.new(3,8, JELLY_KERING),
		4 : Wave.new(4),
		5 : Wave.new(5),
		6 : Wave.new(6)
	},
	5 : {
		1 : Wave.new(1,10, JELLY_KERING),
		2 : Wave.new(2,10, JELLY_KERING),
		3 : Wave.new(3,10, JELLY_KERING),
		4 : Wave.new(4,5, GULA_GAIT),
		5 : Wave.new(5,5, GULA_GAIT),
		6 : Wave.new(6)
	},
	6 : {
		1 : Wave.new(1,3, TINTING_KACANG),
		2 : Wave.new(2,3, TINTING_KACANG),
		3 : Wave.new(3,3, TINTING_KACANG),
		4 : Wave.new(4),
		5 : Wave.new(5),
		6 : Wave.new(6)
	},
	7 : {
		1 : Wave.new(1,5, TINTING_KACANG),
		2 : Wave.new(2,5, TINTING_KACANG),
		3 : Wave.new(3,5, TINTING_KACANG),
		4 : Wave.new(4,3, GULA_GAIT),
		5 : Wave.new(5,3, GULA_GAIT),
		6 : Wave.new(6)
	},
	8 : {
		1 : Wave.new(1,7, JELLY_KERING),
		2 : Wave.new(2,7, JELLY_KERING),
		3 : Wave.new(3,7, JELLY_KERING),
		4 : Wave.new(4,3, GULA_GAIT),
		5 : Wave.new(5,3, GULA_GAIT),
		6 : Wave.new(6)
	},
	9 : {
		1 : Wave.new(1,5, TINTING_KACANG),
		2 : Wave.new(2),
		3 : Wave.new(3),
		4 : Wave.new(4,5, GULA_GAIT),
		5 : Wave.new(5,5, GULA_GAIT),
		6 : Wave.new(6)
	},
	10 : {
		1 : Wave.new(1),
		2 : Wave.new(2),
		3 : Wave.new(3),
		4 : Wave.new(4),
		5 : Wave.new(5),
		6 : Wave.new(6, 1, PERMEN_KACAMATA)
	},
}


func get_jelly_kering() -> String:
	return JELLY_KERING

func get_gula_gait() -> String:
	return GULA_GAIT

func get_tinting_kacang() -> String:
	return TINTING_KACANG

func get_wave_by_id(wave_count : int, spawner_id : int) -> Wave:
	if wave_data.has(wave_count):
		if wave_data[wave_count].has(spawner_id):
			return wave_data[wave_count][spawner_id]
	return Wave.new()
