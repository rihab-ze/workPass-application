Class extends Entity

exposed Alias onSitePeople employees.status

exposed Function get occupied()->$result : Integer
	var $onsiteStatus : cs:C1710.StatusSelection
	var $currentStatus : cs:C1710.StatusSelection
	var $obj : Object
	var $startDate : Date:=Storage:C1525 ? Storage:C1525.filterDate.startDate : Current date:C33()
	var $endDate : Date:=Storage:C1525 ? Storage:C1525.filterDate.endDate : Add to date:C393(Current date:C33(); 0; 0; 7)
	$onsiteStatus:=This:C1470.onSitePeople.query("sDate >= :1 & sDate <= :2 and label = :3"; $startDate; $endDate; "onSite")
	$currentStatus:=This:C1470.employees.status.query("sDate >= :1 & sDate <= :2 "; $startDate; $endDate)
	$result:=($onsiteStatus.length#0) ? Round:C94(($onsiteStatus.length)/($currentStatus.length)*100; 2) : 0
	
exposed Function get free()->$result : Integer
	$result:=100-This:C1470.occupied
	