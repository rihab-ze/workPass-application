Function dropData()
	var trash : Object
	// $local
	trash=ds:C1482.Company.all().drop()
	// $local
	trash=ds:C1482.Local.all().drop()
	// $local
	trash=ds:C1482.Floor.all().drop()
	// $room
	trash=ds:C1482.Room.all().drop()
	// $team
	trash=ds:C1482.Team.all().drop()
	// $employee
	trash=ds:C1482.Employee.all().drop()
	// $meeting
	trash=ds:C1482.Meeting.all().drop()
	// $participation
	trash=ds:C1482.Participation.all().drop()
	// $status
	trash=ds:C1482.Status.all().drop()
	// $notification
	trash=ds:C1482.Notice.all().drop()
	// activity
	trash=ds:C1482.Activity.all().drop()
	
Function createData()
	This:C1470.newCompany()
	This:C1470.newLocal()
	This:C1470.newFloor()
	This:C1470.newRoom()
	This:C1470.newTeam()
	//This.newEmployee()
	This:C1470.generateFakeUsers()
	This:C1470.linkEmployeeToTeam()
	This:C1470.linkEmployeeToRoom()
	This:C1470.newMeeting()
	This:C1470.newStatus()
	This:C1470.newStatusByLeader()
	This:C1470.newActivities()
	This:C1470.linkemployeetocompany()
	
	
	
	
	
	
Function newCompany()
	var $company : Object
	$company:=ds:C1482.Company.all().first()
	If ($company=Null:C1517)
		$company:=ds:C1482.Company.new()
		$company.name:="4D"
		$company.address:="Rabat Morocco"
		$company.save()
	End if 
	
	
Function linkemployeetocompany()
	var $Employees : cs:C1710.EmployeeSelection:=ds:C1482.Employee.all()
	var $emp : cs:C1710.EmployeeEntity
	For each ($emp; $Employees)
		$emp.company:=ds:C1482.Company.all().first()
		$emp.save()
	End for each 
	
Function newLocal()
	//get the all.first.company and link them to 3 $local
	var $company : Object
	var $local : cs:C1710.LocalEntity
	var $startIndex : Integer
	var $locals : Collection
	var $image : Picture
	var $request : 4D:C1709.HTTPRequest
	
	$locals:=[New object:C1471("label"; "4D France"; "country"; "France"; "city"; "Paris"); New object:C1471\
		("label"; "4D Morocco"; "country"; "Morocco"; "city"; "Rabat"); New object:C1471\
		("label"; "4D USA"; "country"; "United States of America"; "city"; "San Jose")]
	
	$startIndex:=0
	$company:=ds:C1482.Company.all().first()
	If ($company#Null:C1517)
		While ($startIndex<3)
			$local:=ds:C1482.Local.new()
			$local.label:=$locals.at($startIndex).label
			$local.country:=$locals.at($startIndex).country
			$local.city:=$locals.at($startIndex).city
			$local.company:=$company
			$local.save()
			$startIndex+=1
		End while 
	End if 
	
Function newFloor()
	//get all the $locals and to each one create 1 to 3 $floors
	var $locals : cs:C1710.LocalSelection
	var $local : cs:C1710.LocalEntity
	var $floor : cs:C1710.FloorEntity
	var $startIndex; $endIndex : Integer
	$locals:=ds:C1482.Local.all()
	For each ($local; $locals)
		$startIndex:=0
		$endIndex:=(Random:C100%7)+1
		While ($startIndex<$endIndex)
			$floor:=ds:C1482.Floor.new()
			$floor.label:="Floor "+String:C10($startIndex)  //unique, Floor+i won't work
			$floor.number:=$startIndex
			$floor.local:=$local
			$floor.save()
			$startIndex+=1
		End while 
	End for each 
	
Function newRoom()
	//get all the $floors and to each link 5 to 10 $rooms 
	var $floors : cs:C1710.FloorSelection
	var $floor : cs:C1710.FloorEntity
	var $room : cs:C1710.RoomEntity
	var $roomTypes : Collection
	var $meetingRooms; $meetingRoomsAux : Collection
	$meetingRooms:=["Springfield"; "Paris"; "Rabat"; "London"; "New York"; "Tokyo"; "Dubai"; "Rome"; "Madrid"; "Singapore"; "Rio"; "Berlin"; "Geneva"; "Copenhagen"; "Lima"; "Nairobi"; "Prague"; "Seoul"; "Shanghai"; "Ottawa"; "New Delhi"; "Bruxelles"]
	$roomTypes:=["Meeting space"; "Office"; "Conference room"; "Coworking space"; "Breakout space"]
	var $startIndex; $endIndex; $index; $indexRoom : Integer
	$floors:=ds:C1482.Floor.all()
	For each ($floor; $floors)
		$indexRoom:=1
		$startIndex:=0
		$endIndex:=(Random:C100%6)+5
		$meetingRoomsAux:=$meetingRooms.copy()
		While ($startIndex<$endIndex)
			$room:=ds:C1482.Room.new()
			$room.type:=$roomTypes.at(Random:C100%$roomTypes.length)
			If ($room.type="Meeting room" || $room.type="Conference room")
				$index:=Random:C100%$meetingRoomsAux.length
				$room.label:=$meetingRoomsAux.at($index)
				$meetingRoomsAux.remove($index)
			Else 
				$room.label:=$room.type+" "+String:C10($indexRoom)
				$indexRoom+=1
			End if 
			$room.floor:=$floor
			$room.save()
			$startIndex+=1
		End while 
	End for each 
	
Function newTeam()
	var $teams : Collection
	var $item : Text
	var $team : cs:C1710.TeamEntity
	$teams:=["Quality Assurance"; "Customer Support"; "Human Resources"; "Sales"; "Marketing"; "Technology"; "Engineering"; "Business Unit"; "Purchase"]
	For each ($item; $teams)
		$team:=ds:C1482.Team.new()
		$team.title:=$item
		$team.save()
	End for each 
	
Function generateFakeUsers()
	var $user : Object
	var $newUser : cs:C1710.EmployeeEntity
	var $fakeUsers : Collection:=[{email: "john.doe@gmail.com"; firstName: "John"; lastName: "Doe"}; {email: "jane.smith@yahoo.com"; firstName: "Jane"; lastName: "Smith"}; \
		{email: "michael.jones@hotmail.com"; firstName: "Michael"; lastName: "Jones"}; {email: "emily.davis@gmail.com"; firstName: "Emily"; lastName: "Davis"}; \
		{email: "daniel.brown@outlook.com"; firstName: "Daniel"; lastName: "Brown"}; {email: "sophia.miller@gmail.com"; firstName: "Sophia"; lastName: "Miller"}; \
		{email: "william.wilson@yahoo.com"; firstName: "William"; lastName: "Wilson"}; {email: "olivia.moore@hotmail.com"; firstName: "Olivia"; lastName: "Moore"}; \
		{email: "james.taylor@gmail.com"; firstName: "James"; lastName: "Taylor"}; {email: "ava.anderson@outlook.com"; firstName: "Ava"; lastName: "Anderson"}; \
		{email: "ethan.harris@yahoo.com"; firstName: "Ethan"; lastName: "Harris"}; {email: "mia.clark@gmail.com"; firstName: "Mia"; lastName: "Clark"}; \
		{email: "alexander.lewis@hotmail.com"; firstName: "Alexander"; lastName: "Lewis"}; {email: "isabella.walker@outlook.com"; firstName: "Isabella"; lastName: "Walker"}; \
		{email: "logan.martin@gmail.com"; firstName: "Logan"; lastName: "Martin"}; {email: "chloe.robinson@yahoo.com"; firstName: "Chloe"; lastName: "Robinson"}; \
		{email: "lucas.young@hotmail.com"; firstName: "Lucas"; lastName: "Young"}; {email: "emma.king@gmail.com"; firstName: "Emma"; lastName: "King"}; \
		{email: "jack.wright@yahoo.com"; firstName: "Jack"; lastName: "Wright"}; {email: "amelia.scott@outlook.com"; firstName: "Amelia"; lastName: "Scott"}]
	var $roles : Collection:=["Admin"; "Employee"; "Manager"]
	var $company : cs:C1710.CompanyEntity:=ds:C1482.Company.all().first()
	
	
	For each ($user; $fakeUsers)
		$newUser:=ds:C1482.Employee.new()
		$newUser.email:=$user.email
		$newUser.firstname:=$user.firstName
		$newUser.lastname:=$user.lastName
		$newUser.company:=$company
		$newUser.role:=$roles.at(Random:C100%($roles.length))
		$newUser.password:=Generate password hash:C1533($user.firstName)
		$newUser.save()
	End for each 
	
Function linkEmployeeToTeam()
	var $employees : cs:C1710.EmployeeSelection
	var $employee : cs:C1710.EmployeeEntity
	var $team : cs:C1710.TeamEntity
	var $teams : cs:C1710.TeamSelection
	var $ran : Integer
	
	$teams:=ds:C1482.Team.all()
	$employees:=ds:C1482.Employee.all()
	
	For each ($employee; $employees)
		If (Random:C100%8#7)
			$ran:=Random:C100%$teams.length
			$team:=$teams.at($ran)  // random
			$employee.team:=$team
			$employee.save()
			If (($employee.role#"Employee") && ($team.manager=Null:C1517))
				$team.manager:=$employee
				$team.save()
			End if 
		End if 
	End for each 
	
Function newMeeting()
	var $teams : cs:C1710.TeamSelection
	var $rooms : cs:C1710.RoomSelection
	var $employee : cs:C1710.EmployeeEntity
	var $meeting : cs:C1710.MeetingEntity
	var $startDate; $endDate : Date
	$teams:=ds:C1482.Team.all()
	$rooms:=ds:C1482.Room.query("type in :1"; ["Meeting space"; "Conference room"; "Coworking space"])
	For each ($employee; $teams.manager)
		$startDate:=Current date:C33()-60
		$endDate:=Current date:C33()+60
		While ($startDate<=$endDate)
			If ((Day number:C114($startDate)#1) && (Day number:C114($startDate)#7))
				$meeting:=ds:C1482.Meeting.new()
				$meeting.createdBy:=$employee
				$meeting.subject:=(Random:C100%2=1) ? "Qodly Team Meeting" : "Qodly Brainstorming Meeting"
				Case of 
					: (Random:C100%4=1)  // "remote"
						$meeting.type:="remote"
					: (Random:C100%4=2)  // "hybrid"
						$meeting.type:="hybrid"
						$meeting.room:=$rooms.at(Random:C100%$rooms.length)
					Else   // "onSite"
						$meeting.type:="onSite"
						$meeting.room:=$rooms.at(Random:C100%$rooms.length)
				End case 
				$meeting.mDate:=$startDate
				$meeting.startTime:=?10:00:00?
				$meeting.endTime:=?11:00:00?
				$meeting.save()
				// this.newParticipatiant($meeting, $employee.team.employees)
			End if 
			$startDate+=(Random:C100%2=0) ? 2 : 3
		End while 
	End for each 
	
	
	
	
	
Function linkEmployeeToRoom()
	var $employees : cs:C1710.EmployeeSelection
	var $employee : cs:C1710.EmployeeEntity
	var $room : cs:C1710.RoomEntity
	var $rooms : cs:C1710.RoomSelection
	var $ran : Integer
	$rooms:=ds:C1482.Room.query("type = :1"; "Office")
	$employees:=ds:C1482.Employee.all()
	
	For each ($employee; $employees)
		$ran:=Random:C100%$rooms.length
		$room:=$rooms.at($ran)  // random
		$employee.room:=$room
		$employee.save()
	End for each 
	
Function newStatus()
	var $employees : cs:C1710.EmployeeSelection
	var $employee : cs:C1710.EmployeeEntity
	var $status : cs:C1710.StatusEntity
	var $startDate; $endDate : Date
	var $rndm : Integer
	$employees:=ds:C1482.Employee.all()
	For each ($employee; $employees)
		$startDate:=Current date:C33()-60
		$endDate:=Current date:C33()+9
		While ($startDate<=$endDate)
			If ((Day number:C114($startDate)#1) && (Day number:C114($startDate)#7))
				$status:=ds:C1482.Status.new()
				$status.employee:=$employee
				$status.createdBy:=$employee
				$status.sDate:=$startDate
				$status.eDate:=$startDate
				$rndm:=Random:C100%10
				Case of 
					: ($rndm=1)
						$status.label:="vacay"
					: ($rndm=2)
						$status.label:="sick"
					: (($rndm=3) || ($rndm=4))
						$status.label:="remote"
					Else 
						$status.label:="onSite"
				End case 
				$status.isAccepted:=True:C214
				$status.save()
			End if 
			$startDate+=1
		End while 
	End for each 
	
Function newStatusByLeader()
	var $teams : cs:C1710.TeamSelection
	var $team : cs:C1710.TeamEntity
	var $employee : cs:C1710.EmployeeEntity
	var $status : cs:C1710.StatusEntity
	var $startDate; $endDate; $switchDate : Date
	var $rndm : Integer
	var $attachment : Object
	$teams:=ds:C1482.Team.all()
	For each ($team; $teams)
		If ($team.manager#Null:C1517)
			For each ($employee; $team.employees)
				$startDate:=Current date:C33()+10
				$switchDate:=Current date:C33()+20
				$endDate:=Current date:C33()+180
				While ($startDate<=$endDate)
					$rndm:=Random:C100%2
					$attachment:=New object:C1471("status"; []; "startDate"; $startDate; "endDate"; $switchDate)
					While ($startDate<=$switchDate)
						If ((Day number:C114($startDate)#1) && (Day number:C114($startDate)#7))
							$status:=ds:C1482.Status.new()
							$status.employee:=$employee
							$status.sDate:=$startDate
							$status.eDate:=$startDate
							$status.label:=($rndm=1) ? "remote" : "onSite"
							$status.isAccepted:=False:C215
							$status.createdBy:=$team.manager
							$status.save()
							$attachment.status.push($status.UUID)
						End if 
						$startDate+=1
					End while 
					$switchDate+=10
				End while 
			End for each 
		End if 
	End for each 
	
	
	
Function newActivities()
	
	var $participation : cs:C1710.ParticipationEntity
	var $participations : cs:C1710.ParticipationSelection
	$participations:=ds:C1482.Participation.all()
	For each ($participation; $participations)
		If (Random:C100%50=1)
			If (Random:C100%2=0)
				ds:C1482.Activity.create("meeting"; $participation.meeting; Null:C1517; String:C10($participation.employee.fullname+" has accepted the meeting "+$participation.meeting.subject+" taking place the "+String:C10($participation.meeting.mDate; 2)))
			Else 
				ds:C1482.Activity.create("meeting"; $participation.meeting; Null:C1517; String:C10($participation.employee.fullname+" has refused the meeting "+$participation.meeting.subject+" taking place the "+String:C10($participation.meeting.mDate; 2)))
			End if 
		End if 
	End for each 
	
	var $status : cs:C1710.StatusSelection
	var $stat : cs:C1710.StatusEntity
	$status:=ds:C1482.Status.all()
	For each ($stat; $status)
		If (Random:C100%50=1)
			If (Random:C100%2=0)
				ds:C1482.Activity.create("status"; Null:C1517; $stat; String:C10($stat.employee.fullname+" has accepted the status "+$stat.label+" declared for the "+String:C10($stat.sDate; 2)))
			Else 
				ds:C1482.Activity.create("status"; Null:C1517; $stat; String:C10($stat.employee.fullname+" has refused the status "+$stat.label+" declared for the "+String:C10($stat.sDate; 2)))
			End if 
		End if 
	End for each 
	
Function newParticipatiant($meeting : cs:C1710.MeetingEntity; $employees : cs:C1710.EmployeeSelection)
	
	var $employee : cs:C1710.EmployeeEntity
	var $notification : cs:C1710.NoticeEntity
	var $part : cs:C1710.ParticipationEntity
	
	For each ($employee; $employees)
		$part:=ds:C1482.Participation.new()
		$part.employee:=$employee
		$part.meeting:=$meeting
		$part.status:=Random:C100%2=1 ? "accepted" : "waiting"
		$part.save()
		$notification:=ds:C1482.Notice.create($employee; $meeting; Null:C1517; Null:C1517; ($employee.UUID=$meeting.createdBy.UUID) ? "You created a new meeting on the "+String:C10($meeting.mDate; 2)+" " : "You've been invited by "+($meeting.createdBy.fullname)+" to a "+($meeting.type || "")+" meeting on the "+String:C10($meeting.mDate; 2)+"")
		
	End for each 
	