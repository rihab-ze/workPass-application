Class extends Entity

exposed function create($dates : collection; $employee : cs.EmployeeEntity)
	var $result: object
	var $oldStatus; $newStatus; $output: cs.StatusSelection
	var $currentUser: cs.EmployeeEntity := ds.Employee.getCurrentUser()
	var $myStatus: cs.StatusSelection := ds.Status.all().query("employee.UUID = :1"; $currentUser.UUID)
	if ($dates.length = 1)
		$dates[1] = $dates[0]
	end if 
	// why you need 2 queries ??!! 
	$oldStatus := ($dates.length > 0) ? $myStatus.query("sDate  <= :1 && eDate  >= :1"; $dates[0]) : null
	$newStatus := ($dates.length > 0) ? $myStatus.query("eDate  >= :1 && sDate  <= :1 "; $dates[1]) : null
	case of 
		: ($dates.length = 0)
			web Form.setWarning("Please select a date")
		: (($oldStatus.length > 0) || ($newStatus.length > 0))
			web Form.setWarning("You already have a declared status in this date")
		: ((this.label = null) || (this.label = ""))
			web Form.setWarning("Please select a label")
		: ($dates[0] < current Date())
			web Form.setWarning("Please select a futuristic date!")
		else 
			this.sDate := $dates[0]
			this.eDate := $dates[1]
			this.employee := $employee
			this.createdBy := $currentUser
			//this.label = $statusLabel
			$result := this.save()
			if ($result.success)
				if (this.employee.UUID = this.createdBy.UUID && this.employee.manager_of = null)
					ds.Notice.create(this.employee.team.manager; null; this; null; this.createdBy.fullname+" declared a new status "+this.label+" from the  "+string(this.sDate; 2)+" to "+string(this.eDate; 2)+" ")
					web Form.setMessage("Your status has been sent for review!")
					web Form["addStatus"].hide()
				end if 
				if (this.employee.UUID = this.createdBy.UUID && this.employee.manager_of # null)
					web Form.setMessage("Your status was created successfully !")
					web Form["addStatus"].hide()
				else 
					ds.Notice.create(this.employee; null; this; null; this.createdBy.fullname+" declared your status "+this.label+" from the  "+string(this.sDate; 2)+" to "+string(this.eDate; 2)+" ")
				end if 
			else 
				web Form.setWarning("An error has occured!")
			end if 
	end case 
	$output := $myStatus.copy()
	$output.add(this)
	return $output
	
	
exposed function noticeUpdate($dates : collection; $employee : cs.EmployeeEntity; $statusLabel : text)
	var $result: object
	if ($dates.length = 1)
		$dates[1] = $dates[0]
	end if 
	// why you need 2 queries ??!! 
	var $oldStatus: cs.StatusSelection := ds.Status.all().query("sDate  >= :1 && eDate  <= :1 && employee = :2"; $dates[0]; ds.Employee.getCurrentUser())
	var $newStatus: cs.StatusSelection := ds.Status.all().query("eDate  <= :1 && sDate  >= :1 && employee = :2"; $dates[1]; ds.Employee.getCurrentUser())
	case of 
		: (($oldStatus.length > 0) || ($newStatus.length > 0))
			web Form.setWarning("You already have a declared status in this date")
		: ((this.sDate < current Date()))
			web Form.setWarning("You can not edit an old status")
			
		else 
			ds.Notice.create(this.employee.team.manager; null; this; new Object("label"; $statusLabel; "sDate"; $dates[0]; "eDate"; $dates[1]); this.createdBy.fullname+" updated the status "+this.label+" from the  "+string(this.sDate; 2)+" to "+string(this.eDate; 2)+" ")
			web Form.setMessage("Your status has been sent for review!")
			web Form["editStatus"].hide()
	end case 
