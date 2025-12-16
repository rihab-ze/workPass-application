Class extends Entity

exposed Function create($participants : cs:C1710.EmployeeSelection)
	var $participation : cs:C1710.ParticipationEntity
	var $participant : cs:C1710.EmployeeEntity
	var $meetSaving : Object
	var $currentUser : cs:C1710.EmployeeEntity:=ds:C1482.Employee.getCurrentUser()
	var $myMeetings : cs:C1710.MeetingSelection:=ds:C1482.Meeting.query("participations.employee.UUID  = :1 "; $currentUser.UUID)
	var $output : cs:C1710.MeetingSelection:=$myMeetings.copy()
	Case of 
		: (This:C1470.subject=Null:C1517)
			Web Form:C1735.setWarning("Please enter a meeting subject!")
		: (This:C1470.type=Null:C1517)
			Web Form:C1735.setWarning("Please select a meeting type!")
		: (This:C1470.mDate=Null:C1517)
			Web Form:C1735.setWarning("Please select a meeting starting date!")
		: ((Day number:C114(This:C1470.mDate)=1) || (Day number:C114(This:C1470.mDate)=7))
			Web Form:C1735.setWarning("Please select a working day")
		: (This:C1470.startTime=Null:C1517)
			Web Form:C1735.setWarning("Please select a meeting starting hour!")
		: (This:C1470.endTime=Null:C1517)
			Web Form:C1735.setWarning("Please select a meeting ending hour!")
		: (This:C1470.mDate<Current date:C33())
			Web Form:C1735.setWarning("Please select a futuristic meeting date!")
		: (This:C1470.startTime>This:C1470.endTime)
			Web Form:C1735.setWarning("Please select a logical time range!")
			
		Else 
			This:C1470.createdBy:=$currentUser
			$meetSaving:=This:C1470.save()
			Use (Session:C1714.storage)
				Session:C1714.storage.createdMeeting:=New shared object:C1526("UUID"; This:C1470.UUID)
			End use 
			For each ($participant; $participants)
				$participation:=ds:C1482.Participation.new()
				$participation.employee:=$participant
				$participation.meeting:=This:C1470
				$participation.status:="waiting"
				$participation.save()
			End for each 
			If ($meetSaving.success)
				$currentUser.code:=Storage:C1525.code.code
				$currentUser.save()
				Web Form:C1735.setMessage("Your meeting was created successfully!")
				Web Form:C1735["newMeeting"].hide()
				ds:C1482.Notice.create($participant; This:C1470; Null:C1517; Null:C1517; ($participant.UUID=This:C1470.createdBy.UUID) ? "You created a new meeting on the "+String:C10(This:C1470.mDate; 2)+" " : "You've been invited by "+(This:C1470.createdBy.fullname)+" to a "+(This:C1470.type || "")+" meeting on the "+String:C10(This:C1470.mDate; 2)+"")
				$output:=$myMeetings.copy()
				$output.add(This:C1470)
				return $output
			Else 
				Web Form:C1735.setWarning("An error has occured while saving your meeting!")
			End if 
	End case 
	return $output
	
exposed Function createTeamsMeeting($accessToken : Text) : Text
	var $meetingDetails : Object
	var $res:=4D:C1709.OutgoingMessage.new()
	
	$meetingDetails:={subject: This:C1470.subject; startDateTime: String:C10(This:C1470.mDate; ISO date GMT:K1:10; Time:C179(This:C1470.startTime)); endDateTime: String:C10(This:C1470.mDate; ISO date GMT:K1:10; Time:C179(This:C1470.endTime))}
	
	var $headers:=New object:C1471("Authorization"; "Bearer "+$accessToken+""; "Content-Type"; "application/json")
	
	var $Request:=4D:C1709.HTTPRequest.new("https://graph.microsoft.com/v1.0/me/onlineMeetings"; \
		{method: "POST"; headers: $headers; body: $meetingDetails})
	
	$Request.wait()
	
	If ($Request.response.status=201)
		$res.setBody("Meeting created! Join URL: "+$Request.response.body.joinUrl)
		return $Request.response.body.joinUrl
	Else 
		$res.setBody("Error creating meeting: "+$Request.response.body)
		$res.setStatus(400)
	End if 
	