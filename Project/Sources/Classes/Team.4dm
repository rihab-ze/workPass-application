Class extends DataClass

Function event restrict()->$result : cs:C1710.TeamSelection
	Case of 
		: (Session:C1714.hasPrivilege("Admin"))
			return Null:C1517
		: (Session:C1714.hasPrivilege("Employees"))
			return This:C1470.newSelection()
		: (Session:C1714.hasPrivilege("Manager"))
			return This:C1470.query("manager.UUID = :1"; ds:C1482.Employee.getCurrentUser().UUID)
		: (Session:C1714.hasPrivilege("guestPromoted"))
			return Null:C1517
	End case 
	
exposed Function getByTitle($search : Text) : cs:C1710.TeamSelection
	If ($search=Null:C1517 || $search="")  // do we need both of those conditions
		return This:C1470.all()
	Else 
		return This:C1470.query("title = :1"; "@"+$search+"@")
	End if 
	
	