Class extends EntitySelection

Exposed function $TodayMeeting()->$TodayMeeting:cs.MeetingEntity
	$TodayMeeting := this.query("mDate = :1" ; current Date()).first()