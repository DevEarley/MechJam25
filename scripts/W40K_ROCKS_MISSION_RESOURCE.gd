extends Resource
class_name MISSIONS

enum environments
{
	beach,
	swamp,
	urban,
	jungle
}

enum results
{
	not_started,
	started,
	success,
	failed
}

var id : int #1
var title : String #"Find Jill's Mech"
var flavor_text : String #"Jack wants to find Jill. He needs you to set his location to her last known whereabouts."
var icon : Texture2D #maps to a "rescue" icon.
var odds_success : float #1/ODDS so in this case 1/1 = 1, or 100% success rate
var environment : int

var allowed_mech_types : Array[int] #only these types are allowed for this mission, regardless of environment
var location : int #location_ID
var time_to_complete #[DATETIME] 
var result : int
