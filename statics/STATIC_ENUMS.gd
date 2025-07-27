class_name ENUMS

#Mech Types
#Mech Theme
#Mech Status
#Pilot Theme
#Pilot Status
#Odds Criteria
#Mission Flavor Type
#Mission Status
#Environments (Location Types)
#Part Type (Equipable or Not)
#Part Status

enum MECH_TYPE {
	UNDECIDED = -1
}

enum MECH_THEME {
	UNDECIDED = -1,
	RED = 0,
	BLUE = 0,
	DARK = 0,
}

enum MECH_STATUS {
	UNDECIDED = -1,
	FOR_SALE = 0,
	IN_GARAGE = 1,
	ON_MISSION = 2,
	NOT_AVAILABLE =3 # Destroyed or sold
}

enum ODDS_CRITERIA {
	UNDECIDED = -1
}

enum MISSION_FLAVOR_TYPE {
	UNDECIDED = -1,
	RESCUE = 0,
	DESTROY = 1,
	DELIVERY = 2
}

enum MISSION_STATUS {
	UNDECIDED = -1,
	LOCKED = 0,
	UNLOCKED = 1,
	IN_PROGRESS = 2,
	SUCCESS = 3,
	FAILED = 4
}
enum MISSION_REWARD_TYPE {
	UNDECIDED = -1,
	CREDITS = 0,
	RECYCLE_POINTS =1,
	PART = 2,
	MECH = 3,
	PILOT = 4
}


enum ENVIRONMENT {
	UNDECIDED = -1,
	SAND_DUNES = 0,
	SWAMP = 1,
	URBAN = 2,
	JUNGLE = 3,
	SPACE = 4,
	UNDERWATER_FROZEN = 5,
	UNDERWATER = 6,
	UNDERWATER_BOILING = 7,
	TUNDRA = 8,
	UNDERGROUND = 9,
	ENVIRONMENT_NEW_10 = 10,
}

enum PART_TYPE {
	UNDECIDED = -1,
	NOT_EQUIPABLE =0,
	EQUIPABLE = 1,
	#CONSUMABLE = 2
}

enum PART_STATUS {
	UNDECIDED = -1,
	FOR_SALE = 0,
	PURCHASED = 1,
	EQUIPT = 2,
	NOT_AVAILABLE = 3, #Destroyed, sold or recycled.

}

enum PART_THEME{
	UNDECIDED = -1,
	RED =0,
	BLUE =0,

}
enum PILOT_STATUS{
	UNDECIDED = -1,
	FOR_HIRE = 0,
	HIRED = 1,
	ON_MISSION = 2,
	DEAD = 3
}
enum PILOT_THEME{
	UNDECIDED = -1,
	RED_FEMALE = 0,
	BLUE_FEMALE = 1,
	RED_MALE = 2,
	BLUE_MALE = 3
}
