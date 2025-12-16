Class extends Entity
exposed alias rooms floors.rooms

exposed function get occupied()->$result : integer
	var $floorOccupation: integer
	$floorOccupation := this.floors.sum("occupied")
	$result := $floorOccupation/this.floors.length
	
exposed function get free()->$result : integer
	$result := 100-this.occupied
	
exposed function create()
	var $info: object
	this.company := ds.Company.all().first()
	$info := this.save()
	if ($info.success)
		web Form.setMessage("Your local was saved successfully!")
	else 
		web Form.setError("An error occured while saving your local!")
	end if 
	
