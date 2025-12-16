shared singleton Class constructor()
	
Function encodeURI($text : Text)
	text:=Replace string:C233(text; "/"; "%2F")  // / backslash
	text:=Replace string:C233(text; "?"; "%3F")  // ? question mark
	text:=Replace string:C233(text; ":"; "%3A")  // : colon
	text:=Replace string:C233(text; "@"; "%40")  // @ at
	text:=Replace string:C233(text; "&"; "%26")  // & ampersand
	text:=Replace string:C233(text; "="; "%3D")  // = equal
	text:=Replace string:C233(text; "+"; "%2B")  // + plus sign
	text:=Replace string:C233(text; ","; "%2C")  // , comma
	text:=Replace string:C233(text; "$"; "%24")
	return text
	
Function teamsAuthCallback($req : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	var $meeting : cs:C1710.MeetingEntity:=ds:C1482.Meeting.get(Session:C1714.storage.createdMeeting.UUID)
	var $token : Text
	var $request : 4D:C1709.HTTPRequest
	var $res:=4D:C1709.OutgoingMessage.new()
	
	var $clientId : Text:=ds:C1482.Setting.getKey("MICROSOFT_CLIENT_ID")
	var $clientSecret : Text:=ds:C1482.Setting.getKey("MICROSOFT_CLIENT_SECRET")
	var $redirectUri : Text:=ds:C1482.Setting.getKey("MICROSOFT_REDIRECT_URI")
	var $tenantId : Text:=ds:C1482.Setting.getKey("MICROSOFT_TENANT_ID")
	var $tokenUrl:="https://login.microsoftonline.com/"+$tenantId+"/oauth2/v2.0/token"
	
	If ($req.urlQuery.error#Null:C1517)
		$res.setBody("Error: "+$req.urlQuery.error)
		$res.setStatus(400)
		return $res
	End if 
	
	var $headers:=New object:C1471("Content-Type"; "application/x-www-form-urlencoded")
	var $body:="client_id="+$clientId
	$body+="&client_secret="+$clientSecret
	$body+="&grant_type=authorization_code"
	$body+="&code="+$req.urlQuery.code
	$body+="&redirect_uri="+$redirectUri
	$request:=4D:C1709.HTTPRequest.new($tokenUrl; {method: "POST"; headers: $headers; body: $body})
	$request.wait()
	
	If ($request.response.status#200)
		$res.setBody("Error getting token: "+$request.response.body)
		$res.setStatus(400)
		return $res
	End if 
	Use (Storage:C1525)
		Storage:C1525.code:=New shared object:C1526("code"; $req.urlQuery.code)
	End use 
	
	$token:=$request.response.body.access_token
	$meeting.link:=$meeting.createTeamsMeeting($token)
	$meeting.save()
	
	$res.setStatus(302)
	$res.setHeader("Location"; "/$lib/renderer?w=index")
	
	return res
	
Function teamsAuth($rep : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	var $res:=4D:C1709.OutgoingMessage.new()
	var $url:=""
	var $clientId : Text:=ds:C1482.Setting.getKey("MICROSOFT_CLIENT_ID")
	var $redirectUri : Text:=ds:C1482.Setting.getKey("MICROSOFT_REDIRECT_URI")
	var $tenantId : Text:=ds:C1482.Setting.getKey("MICROSOFT_TENANT_ID")
	var $scope:="OnlineMeetings.ReadWrite openid profile offline_access"
	
	var $authUrl:="https://login.microsoftonline.com/"+$tenantId+"/oauth2/v2.0/authorize"
	$authUrl+="?client_id="+$clientId
	$authUrl+="&response_type=code"
	$authUrl+="&redirect_uri="+$redirectUri
	$authUrl+="&scope="+This:C1470.encodeURI($scope)
	$authUrl+="&response_mode=query"
	
	$res.setStatus(302)
	$res.setHeader("Location"; $authUrl)
	
	return $res
	
	
	