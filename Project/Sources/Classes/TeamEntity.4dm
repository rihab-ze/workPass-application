Class extends Entity
exposed function get onSite()->$result : integer
	var $status: cs.StatusSelection
	var $startDate: date := storage ? storage.filterDate.startDate : current Date()
	var $endDate: date := storage ? storage.filterDate.endDate : add to Date(current Date(); 0; 0; 7)
	if (this.employees.length # 0)
		$status := this.employees.status.query("sDate >= :1 & sDate <= :2"; $startDate; $endDate)
		$result := ($status.length # 0) ? ($status.query("label = :1"; "onSite").length/$status.length)*100 : 0
	else 
		$result := 0
	end if 
	
exposed function get remote()->$result : integer
	var $status: cs.StatusSelection
	var $startDate: date := storage ? storage.filterDate.startDate : current Date()
	var $endDate: date := storage ? storage.filterDate.endDate : add to Date(current Date(); 0; 0; 7)
	if (this.employees.length # 0)
		$status := this.employees.status.query("sDate >= :1 & sDate <= :2"; $startDate; $endDate)
		$result := ($status.length # 0) ? ($status.query("label = :1"; "remote").length/$status.length)*100 : 0
	else 
		$result := 0
	end if 
exposed function get vacay()->$result : integer
	var $status: cs.StatusSelection
	var $startDate: date := storage ? storage.filterDate.startDate : current Date()
	var $endDate: date := storage ? storage.filterDate.endDate : add to Date(current Date(); 0; 0; 7)
	if (this.employees.length # 0)
		$status := this.employees.status.query("sDate >= :1 & sDate <= :2"; $startDate; $endDate)
		$result := ($status.length # 0) ? ($status.query("label = :1"; "vacay").length/$status.length)*100 : 0
	else 
		$result := 0
	end if 
exposed function get sick()->$result : integer
	var $status: cs.StatusSelection
	var $startDate: date := storage ? storage.filterDate.startDate : current Date()
	var $endDate: date := storage ? storage.filterDate.endDate : add to Date(current Date(); 0; 0; 7)
	if (this.employees.length # 0)
		$status := this.employees.status.query("sDate >= :1 & sDate <= :2"; $startDate; $endDate)
		$result := ($status.length # 0) ? ($status.query("label = :1"; "sick").length/$status.length)*100 : 0
	else 
		$result := 0
	end if 
exposed function create($members : cs.EmployeeSelection)
	var $member: cs.EmployeeEntity
	var $teamSaving: object
	case of 
		: (this.title = null)
			web Form.setWarning("Enter the team title!")
		: (this.manager.UUID = null)
			web Form.setWarning("Enter the team manager!")
		: ($members.length = 0)
			web Form.setWarning("Enter the team members!")		
		else 
			$teamSaving := this.save()
			for Each ($member; $members)
				$member.team := this
				$member.save()
			end for each 
			if ($teamSaving.success)
				web Form.setMessage("Your team was saved successfully!")
				web Form["newTeam"].hide()
				web Form["editTeam"].hide()
			else 
				web Form.setWarning("An error occured while saving your team!")
			end if 
	end case 
	
