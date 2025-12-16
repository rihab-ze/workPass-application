Class extends DataClass

Function event restrict()->$result : cs:C1710.SettingSelection
	Case of 
		: (Session:C1714.hasPrivilege("Admin"))
			return Null:C1517
		: (Session:C1714.hasPrivilege("Employees"))
			return This:C1470.newSelection()
		: (Session:C1714.hasPrivilege("Manager"))
			return This:C1470.newSelection()
	End case 
	
exposed Function getKey($key : Text) : Text
	var $record:=This:C1470.query("label =: 1"; $key).first()
	return record ? record.value : ""
	