Class extends DataStoreImplementation

exposed Function authentify($login : Text; $psw : Text) : Boolean
	var $users : cs:C1710.EmployeeSelection
	var $user : cs:C1710.EmployeeEntity
	If (($login="") && ($psw=""))
		return Session:C1714.setPrivileges(["guest"; "guestPromoted"])
	End if 
	$users:=ds:C1482.Employee.query("email = :1"; $login)
	If ($users.length=1)
		$user:=$users.first()
		If (Verify password hash:C1534($psw; String:C10($user.password)))
			Session:C1714.setPrivileges(String:C10($user.role))
			Use (Session:C1714.storage)
				Session:C1714.storage.clientInfo:=New shared object:C1526("UUID"; $user.UUID)
			End use 
			Web Form:C1735.setMessage("Login successfull")
		Else 
			Web Form:C1735.setError("Unknown User")
			//throw({message: "Unknown User"})
		End if 
	Else 
		Web Form:C1735.setError("Unknown User")
		//throw({message: "Unknown User"})
	End if 
	
exposed Function currentDate()->$crtDate : Text
	$crtDate:=String:C10(Current date:C33(); 2)
	
exposed Function getRangeDate($sDate; $eDate)->$rangeDate : Collection
	$rangeDate:=[]
	$rangeDate.push($sDate; $eDate)
	
exposed Function initDate($startDate : Date; $endDate : Date)->$result : Object
	var $varDate; $firstDayMonth; $lastDayMonth : Date
	var $currentDay : Integer
	
	If (($startDate#!00-00-00!) && ($endDate#!00-00-00!))
		Use (Storage:C1525)
			Storage:C1525.filterDate:=New shared object:C1526("startDate"; $startDate; "endDate"; $endDate)
		End use 
		$result:=Storage:C1525.filterDate
	Else 
		$varDate:=Current date:C33()
		$currentDay:=Day of:C23($varDate)
		$firstDayMonth:=Add to date:C393($varDate; 0; 0; -$currentDay+1)
		$lastDayMonth:=Add to date:C393($varDate; 0; 1; -$currentDay)
		$result:=New object:C1471("startDate"; $firstDayMonth; "endDate"; $lastDayMonth)
		Use (Storage:C1525)
			Storage:C1525.filterDate:=New shared object:C1526("startDate"; $firstDayMonth; "endDate"; $lastDayMonth)
		End use 
		$result:=Storage:C1525.filterDate
	End if 
	
exposed Function getCountries() : Collection
	var $jsonFile : 4D:C1709.File
	var $text : Text
	var $fileContent : Collection
	var $countries : Collection
	var $element; $formulaCol : Object
	$jsonFile:=File:C1566("/PROJECT/Sources/Shared/assets/data/countries.json")
	text:=$jsonFile.getText()
	$fileContent:=JSON Parse:C1218(text; 42)
	$formulaCol:=Formula:C1597({value: $1.value.name})
	$countries:=$fileContent.map($formulaCol)
	return $countries
	
exposed Function selectedLocalCountry($local : cs:C1710.LocalEntity) : Object
	var $countries : Collection
	$countries:=This:C1470.getCountries()
	return $countries.find(Formula:C1597($1.value.value=$2); $local.country)
	
exposed Function getManifestObject() : Object
	var $manifestFile : 4D:C1709.File
	var $manifestObject : Object
	$manifestFile:=File:C1566("/PACKAGE/Project/Sources/Shared/manifest.json")
	$manifestObject:=JSON Parse:C1218($manifestFile.getText())
	return $manifestObject
	
exposed Function generateDate()
	var $generateData : cs:C1710.data:=cs:C1710.data.new()
	$generateData.dropData()
	$generateData.createData()
	Web Form:C1735.setMessage("Data generated!")