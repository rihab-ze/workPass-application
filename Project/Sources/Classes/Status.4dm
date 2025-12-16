Class extends DataClass

Function event restrict()->$result : cs:C1710.StatusSelection
	var $currentUser : cs:C1710.EmployeeEntity:=ds:C1482.Employee.getCurrentUser()
	Case of 
		: (Session:C1714.hasPrivilege("Admin"))
			return Null:C1517
		: (Session:C1714.hasPrivilege("Employees"))
			return This:C1470.query("employee.UUID = :1"; $currentUser.UUID)
		: (Session:C1714.hasPrivilege("Manager"))
			return This:C1470.query("employee.UUID = :1 or employee.team.manager.UUID = :1"; ds:C1482.Employee.getCurrentUser().UUID)
	End case 
	
exposed Function applyStatus($sDate : Date; $eDate : Date; $onSiteEmployees : cs:C1710.EmployeeSelection; $remoteEmployees : cs:C1710.EmployeeSelection)
	var $employee : cs:C1710.EmployeeEntity
	var $dates : Collection:=New collection:C1472($sDate; $eDate)
	var $status : cs:C1710.StatusEntity:=This:C1470.new()
	var $status2 : cs:C1710.StatusEntity:=This:C1470.new()
	var $stat : cs:C1710.StatusEntity
	var $result : Object
	var $selectedDates; $selectedDates2 : Collection
	var $isDeleted : Boolean:=False:C215
	var $isChanged : Boolean:=False:C215
	var $remoteOnsiteStatus; $vacaySickStatus; $existedStatus : cs:C1710.StatusSelection
	var $label : Text:=$onSiteEmployees.length#0 ? "onSite" : "remote"
	
	For each ($employee; $onSiteEmployees.length#0 ? $onSiteEmployees : $remoteEmployees)
		$existedStatus:=$employee.status.query("(sDate  <= :1 && eDate  >= :1) || (sDate  <= :2 && eDate  >= :2) || (sDate >= :1 && eDate <= :2) "; $sDate; $eDate)
		$remoteOnsiteStatus:=$existedStatus.query("label = 'remote' || label = 'onSite' ")
		For each ($stat; $remoteOnsiteStatus)
			If (($stat.sDate>=$sDate) && ($stat.eDate<=$eDate) && ($stat.label#("vacay" || "sick")))
				$isDeleted:=True:C214
				$stat.drop()
			End if 
			If (($stat.eDate>=$eDate) && ($stat.label#("vacay" || "sick")) && Not:C34($isDeleted))
				$stat.sDate:=$eDate+1
				$stat.save()
			End if 
			If (($stat.eDate<=$sDate) && ($stat.label#("vacay" || "sick")) && Not:C34($isDeleted))
				$stat.eDate:=$sDate-1
				$stat.save()
			End if 
		End for each 
		$vacaySickStatus:=$existedStatus.query("label = 'vacay' || label = 'sick' ")
		For each ($stat; $vacaySickStatus)
			If ($eDate>=$stat.eDate)
				$selectedDates2:=New collection:C1472($stat.eDate+1; $eDate)
				$status.label:=$label
				$status.create($selectedDates2; $employee)
				$isChanged:=True:C214
				Web Form:C1735.setMessage("the status has been declared")
			End if 
			If ($sDate<=$stat.sDate)
				$selectedDates:=New collection:C1472($sDate; $stat.sDate-1)
				$status2.label:=$label
				$status2.create($selectedDates; $employee)
				$isChanged:=True:C214
				Web Form:C1735.setMessage("the status has been declared")
				
			End if 
		End for each 
		If (Not:C34($isChanged))
			$status.label:=$label
			$status.create($dates; $employee)
			Web Form:C1735.setMessage("the status has been declared")
			
		End if 
	End for each 
	return ds:C1482.Status.all().query("employee.UUID = :1"; ds:C1482.Employee.getCurrentUser().UUID)
	
	
	
	