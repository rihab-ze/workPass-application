Class extends EntitySelection

//Returns percentage distribution of employee statuses for the selected date range
exposed Function stats()->$result : Object
	var $status : cs:C1710.StatusSelection
	$status:=This:C1470.employees.status.query("sDate >= :1 & sDate <= :2"; Storage:C1525.filterDate.startDate; Storage:C1525.filterDate.endDate)
	$result:={}
	$result.onSite:=($status.length#0) ? Round:C94(($status.query("label = :1"; "onSite").length/$status.length)*100; 0) : 0
	$result.remote:=($status.length#0) ? Round:C94(($status.query("label = :1"; "remote").length/$status.length)*100; 0) : 0
	$result.vacay:=($status.length#0) ? Round:C94(($status.query("label = :1"; "vacay").length/$status.length)*100; 0) : 0
	$result.sick:=($status.length#0) ? Round:C94(($status.query("label = :1"; "sick").length/$status.length)*100; 0) : 0