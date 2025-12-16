Class extends DataClass

exposed Function getCurrentUser() : cs:C1710.EmployeeEntity
	var $currentUser : Object
	var $success : Boolean
	If ((Session:C1714.storage.clientInfo#Null:C1517) && (Session:C1714.storage.clientInfo.UUID#Null:C1517))
		$user:=ds:C1482.Employee.get(Session:C1714.storage.clientInfo.UUID)
		return $user
	End if 
	
exposed Function getByFullName($search : Text; $team : cs:C1710.TeamEntity) : cs:C1710.EmployeeSelection
	If ($search=Null:C1517 || $search="")
		return This:C1470.query("team.UUID = :1"; $team.UUID)
	Else 
		return This:C1470.query("fullname = :1 && team.UUID = :2"; "@"+$search+"@"; $team.UUID)
	End if 
	
exposed Function searchByFullName($search) : cs:C1710.EmployeeSelection
	TRACE:C157
	If ($search=Null:C1517 || $search="")
		return This:C1470.query("dontHaveTeam = true")
	Else 
		return This:C1470.query("fullname = :1 && dontHaveTeam = true"; "@"+$search+"@")
	End if 