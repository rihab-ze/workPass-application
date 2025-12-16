Class extends DataClass

function create($employee : cs.EmployeeEntity; $meeting : cs.MeetingEntity; $status : cs.StatusEntity; $attachment : object; $message : text)
	var $notification: cs.NoticeEntity
	$notification := this.new()
	$notification.employee := $employee
	$notification.createdAt := current Date()
	$notification.comment := ""
	$notification.attachment := $attachment
	$notification.message := $message
	$notification.meeting := $meeting
	$notification.status := $status
	$notification.save()
	
exposed function searchByType($searchType : text) : cs.NoticeSelection
	var $currentUser: cs.EmployeeEntity
	$currentUser := ds.Employee.getCurrentUser()
	if ($currentUser # null)
		if ($searchType = "")
			return $currentUser.notifications.query("isAccepted = null")
		end if 
		if ("m me mee meet meeti meetin meeting"%$searchType) // ??!!
			return $currentUser.notifications.query("meeting.UUID # null")
		end if 
		if ("s st sta stat statu status"%$searchType) // ??!!
			return $currentUser.notifications.query("status.UUID # null")
		end if 
	end if