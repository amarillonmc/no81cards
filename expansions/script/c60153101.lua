--甜食派对 百江渚
Duel.LoadScript("c60152900.lua")
local s,id,o = GetID()
function s.initial_effect(c)
	local ge1 = Scl.SetGlobalFieldTriggerEffect(0, "BeSpecialSummoned", id,
		nil, s.regop)
	local e1 = Scl.CreateIgnitionEffect(c, "SpecialSummon", nil, "SpecialSummon",
		nil, "Hand,MonsterZone", s.spcon, { "Cost", s.rfilter, "Tribute" },
		{"~Target", s.spfilter, "SpecialSummon", "Deck,GY"}, s.spop)
	local e2 = Scl.CreateQuickOptionalEffect_NegateActivation(c, "Dummy", nil,
		"GY", s.rmcon, aux.bfgcost)
	s.LimitCost(e1, e2)
end
function s.LimitCost(...)
	for _,e in pairs({...}) do
		local cost = e:GetCost()
		e:SetCost(s.cost(cost))
	end
end
function s.cost(cost)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk == 0 then 
			return cost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.GetFlagEffect(tp,id) == 0
		end
		cost(e,tp,eg,ep,ev,re,r,rp,1) 
		local e1 = Scl.CreatePlayerBuffEffect({e:GetHandler(), tp}, "!SpecialSummon", 1, s.limtg, {1, 0}, nil, nil, RESET_EP_SCL)
	end
end
function s.limtg(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end
function s.regop(e,tp,eg)
	for tc in aux.Next(eg) do
		if not tc:IsType(TYPE_XYZ) and tc:IsSummonLocation(LOCATION_EXTRA) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(), id, RESETS_EP_SCL, 0, 1)
		end
	end
end
function s.rfilter(c,e,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c,tp) > 0
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function s.spcon(e,tp)
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.spfilter(c,e,tp)
	return Scl.IsCanBeSpecialSummonedNormaly(c,e,tp) and c:IsType(TYPE_NORMAL)
end
function s.spop(e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE) <= 0 then return end
	Scl.SelectAndOperateCards("SpecialSummon",tp,aux.NecroValleyFilter(s.spfilter),tp,"Deck,GY",0,1,1,nil,e,tp)()
end
function s.cfilter2(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_NORMAL)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil) and rp ~= tp and Duel.IsChainNegatable(ev)
end