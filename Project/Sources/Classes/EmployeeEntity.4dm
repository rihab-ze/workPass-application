Class extends Entity

//local Function $aws()->$result : Object
//$result:=Null
//If (Session.storage.users=Null)
//ds.Employee.getCurrentUser()
//End if 
//If (Session.storage.users#Null)
//$result:=Session.storage.users.query("email = :1"; This.email).at(0)
//End if 

exposed Function get fullname()->$fullName : Text
	$fullName:=(This:C1470.firstname && This:C1470.lastname) ? (This:C1470.firstname+" "+Uppercase:C13(This:C1470.lastname; *)) : (Uppercase:C13(This:C1470.lastname; *) || This:C1470.firstname) || ""
	
exposed Function get onSite()->$result : Integer
	var $status : cs:C1710.StatusSelection
	var $obj : Object
	var $startDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.startDate : Current date:C33()
	var $endDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.endDate : Add to date:C393(Current date:C33(); 0; 0; 7)
	$status:=This:C1470.status.query("sDate >= :1 & sDate <= :2"; $startDate; $endDate)
	$result:=($status.length#0) ? ($status.query("label = :1"; "onSite").length/$status.length)*100 : 0
	
exposed Function get remote()->$result : Integer
	var $status : cs:C1710.StatusSelection
	var $obj : Object
	var $startDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.startDate : Current date:C33()
	var $endDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.endDate : Add to date:C393(Current date:C33(); 0; 0; 7)
	$status:=This:C1470.status.query("sDate >= :1 & sDate <= :2"; $startDate; $endDate)
	$result:=($status.length#0) ? ($status.query("label = :1"; "remote").length/$status.length)*100 : 0
	
exposed Function get vacay()->$result : Integer
	var $status : cs:C1710.StatusSelection
	var $obj : Object
	var $startDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.startDate : Current date:C33()
	var $endDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.endDate : Add to date:C393(Current date:C33(); 0; 0; 7)
	$status:=This:C1470.status.query("sDate >= :1 & sDate <= :2"; $startDate; $endDate)
	$result:=($status.length#0) ? ($status.query("label = :1"; "vacay").length/$status.length)*100 : 0
	
exposed Function get sick()->$result : Integer
	var $status : cs:C1710.StatusSelection
	var $obj : Object
	var $startDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.startDate : Current date:C33()
	var $endDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.endDate : Add to date:C393(Current date:C33(); 0; 0; 7)
	$status:=This:C1470.status.query("sDate >= :1 & sDate <= :2"; $startDate; $endDate)
	$result:=($status.length#0) ? ($status.query("label = :1"; "sick").length/$status.length)*100 : 0
	
exposed Function get onSiteDays() : Integer  //to get the employee's presence by days
	var $startDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.startDate : Current date:C33()
	var $endDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.endDate : Add to date:C393(Current date:C33; 0; 0; 7)
	If (This:C1470.status#Null:C1517)
		return This:C1470.status.query("sDate >= :1 & sDate <= :2 & label = onSite"; $startDate; $endDate).length
	Else 
		return 0
	End if 
	
exposed Function get remoteDays() : Integer
	var $startDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.startDate : Current date:C33()
	var $endDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.endDate : Add to date:C393(Current date:C33(); 0; 0; 7)
	If (This:C1470.status#Null:C1517)
		return This:C1470.status.query("sDate >= :1 & sDate <= :2 & label = remote"; $startDate; $endDate).length
	Else 
		return 0
	End if 
	
exposed Function get vacayDays() : Integer
	var $startDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.startDate : Current date:C33()
	var $endDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.endDate : Add to date:C393(Current date:C33(); 0; 0; 7)
	If (This:C1470.status#Null:C1517)
		return This:C1470.status.query("sDate >= :1 & sDate <= :2 & label = vacay"; $startDate; $endDate).length
	Else 
		return 0
	End if 
	
exposed Function get sickDays() : Integer
	var $startDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.startDate : Current date:C33()
	var $endDate : Date:=(Storage:C1525.filterDate#Null:C1517) ? Storage:C1525.filterDate.endDate : Add to date:C393(Current date:C33(); 0; 0; 7)
	If (This:C1470.status#Null:C1517)
		return This:C1470.status.query("sDate >= :1 & sDate <= :2 & label = sick"; $startDate; $endDate).length
	Else 
		return 0
	End if 
	
exposed Function get dontHaveTeam()->$isNew : Boolean
	$isNew:=(This:C1470.team=Null:C1517)
	
exposed Function getStatusByMonth($param : Variant)->$status : cs:C1710.StatusEntity
	var $formulaObject : Object
	var $myParams : Collection
	$myParams:=($param.value#Null:C1517) ? Split string:C1554($param.value; "/") : ""
	$myParams:=$myParams.map(Formula:C1597(Num:C11($1.value)))
	$formulaObject:=Formula:C1597((Month of:C24(This:C1470.sDate)=$myParams.at(0)) && (Year of:C25(This:C1470.sDate)=$myParams.at(1)))
	return ($param.value#Null:C1517) ? (($myParams.length=2) ? This:C1470.status.query($formulaObject) : Null:C1517) : This:C1470.status