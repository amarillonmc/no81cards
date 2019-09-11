--巴卡兹监狱的最终试炼
function c9950039.initial_effect(c)
	 aux.AddRitualProcGreater2(c,c9950039.ritual_filter,LOCATION_HAND+LOCATION_DECK)
end
function c9950039.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsRace(RACE_AQUA)
end