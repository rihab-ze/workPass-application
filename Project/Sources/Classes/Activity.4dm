Class extends DataClass

function create($activityType : text; $meeting : cs.MeetingEntity; $status : cs.StatusEntity; $activityMessage : text)
	var $activitySave: object
	var $activity: cs.ActivityEntity
	$activity := this.new()
	$activity.type := $activityType
	$activity.message := $activityMessage
	$activity.meeting := $meeting
	$activity.status := $status
	$activity.creationDate := current Date()
	$activity.creationHour := current Time()
	$activity.employee := ds.Employee.getCurrentUser()
	$activitySave := $activity.save()
	if ($activitySave.success)
		web Form.setMessage("Notification accepted!")
	else 
		web Form.setError("An error occured while accepting this notification")
	end if 
	
exposed function accept($notif : cs.NoticeEntity)
	var $participation: cs.ParticipationEntity
	if ($notif.meeting # null)  //change the $participation $status
		$participation := $notif.employee.participations.query("meeting.UUID = :1"; $notif.meeting.UUID).first()
		$participation.status := "accepted"
		$participation.save()
		this.create("meeting"; $notif.meeting; null; string($participation.employee.fullname+" has accepted the meeting "+$notif.meeting.subject+" taking place the "+string($notif.meeting.mDate; 2)))
	else 
		$notif.status.isAccepted := true
		if ($notif.attachment # null)
			$notif.status.label := $notif.attachment.label
			$notif.status.sDate := $notif.attachment.sDate
			$notif.status.eDate := $notif.attachment.eDate
		end if 
		$notif.status.save()
		this.create("status"; null; $notif.status; string($notif.status.employee.fullname+" has accepted the status "+$notif.status.label+" declared for the "+string($notif.status.sDate; 2)))
	end if 
	$notif.isAccepted := true
	$notif.save()
	
exposed function refuse($notif : cs.NoticeEntity; $excuse : text)
	var $participation: cs.ParticipationEntity
	if ($notif.meeting # null)  //change the $participation $status
		$participation := $notif.employee.participations.query("meeting.UUID = :1"; $notif.meeting.UUID).first()
		$participation.status := "refused"
		$participation.save()
		this.create("meeting"; $notif.meeting; null; string($participation.employee.fullname+" has refused the meeting "+$notif.meeting.subject+" taking place the "+string($notif.meeting.mDate; 2)))
	else 
		$notif.status.isAccepted := false
		$notif.status.save()
		this.create("status"; null; $notif.status; string($notif.status.employee.fullname+" has refused the status "+$notif.status.label+" declared for the "+string($notif.status.sDate; 2)))
	end if 
	$notif.excuse := $excuse
	$notif.isAccepted := false
	$notif.save()
	web Form["declineInvitation"].hide()