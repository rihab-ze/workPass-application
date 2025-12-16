Class extends DataClass

exposed function showBuildings($country : variant) ->$result : cs.LocalSelection
	if($country # null)
		$result := this.query("country = :1"; $country)
	else
		$result := this.all()
	end if