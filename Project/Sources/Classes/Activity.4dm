Class extends DataClass

Function create($activityType : Text; $meeting : cs:C1710.MeetingEntity; $status : cs:C1710.StatusEntity; $activityMessage : Text)
	var $activitySave : Object
	var $activity : cs:C1710.ActivityEntity
	$activity:=This:C1470.new()
	$activity.type:=$activityType
	$activity.message:=$activityMessage
	$activity.meeting:=$meeting
	$activity.status:=$status
	$activity.creationDate:=Current date:C33()
	$activity.creationHour:=Current time:C178()
	$activity.employee:=ds:C1482.Employee.getCurrentUser()
	$activitySave:=$activity.save()
	If ($activitySave.success)
		Web Form:C1735.setMessage("Notification accepted!")
	Else 
		Web Form:C1735.setError("An error occured while accepting this notification")
	End if 
	
exposed Function accept($notif : cs:C1710.NoticeEntity)
	var $participation : cs:C1710.ParticipationEntity
	If ($notif.meeting#Null:C1517)
		$participation:=$notif.employee.participations.query("meeting.UUID = :1"; $notif.meeting.UUID).first()
		$participation.status:="accepted"
		$participation.save()
		This:C1470.create("meeting"; $notif.meeting; Null:C1517; String:C10($participation.employee.fullname+" has accepted the meeting "+$notif.meeting.subject+" taking place the "+String:C10($notif.meeting.mDate; 2)))
	Else 
		$notif.status.isAccepted:=True:C214
		If ($notif.attachment#Null:C1517)
			$notif.status.label:=$notif.attachment.label
			$notif.status.sDate:=$notif.attachment.sDate
			$notif.status.eDate:=$notif.attachment.eDate
		End if 
		$notif.status.save()
		This:C1470.create("status"; Null:C1517; $notif.status; String:C10($notif.status.employee.fullname+" has accepted the status "+$notif.status.label+" declared for the "+String:C10($notif.status.sDate; 2)))
	End if 
	$notif.isAccepted:=True:C214
	$notif.save()
	
exposed Function refuse($notif : cs:C1710.NoticeEntity; $excuse : Text)
	var $participation : cs:C1710.ParticipationEntity
	If ($notif.meeting#Null:C1517)  //change the $participation $status
		$participation:=$notif.employee.participations.query("meeting.UUID = :1"; $notif.meeting.UUID).first()
		$participation.status:="refused"
		$participation.save()
		This:C1470.create("meeting"; $notif.meeting; Null:C1517; String:C10($participation.employee.fullname+" has refused the meeting "+$notif.meeting.subject+" taking place the "+String:C10($notif.meeting.mDate; 2)))
	Else 
		$notif.status.isAccepted:=False:C215
		$notif.status.save()
		This:C1470.create("status"; Null:C1517; $notif.status; String:C10($notif.status.employee.fullname+" has refused the status "+$notif.status.label+" declared for the "+String:C10($notif.status.sDate; 2)))
	End if 
	$notif.excuse:=$excuse
	$notif.isAccepted:=False:C215
	$notif.save()
	Web Form:C1735["declineInvitation"].hide()