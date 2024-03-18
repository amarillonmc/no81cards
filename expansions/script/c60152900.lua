--LaBil的外包，很新很亮
Duel.LoadScript("c10100000.lua")
local s = {}
--What a fvvvvvck nice new library, it seems soooooooooooo cooooooool!
B2Sayaka = {}
B2Sayaka.Name = "Miki Sayaka"
--miki sayaka ritual monster check
function B2Sayaka.RitualMonster(c)
	return c:IsSetCard(0x3b29) and c:GetType() & (TYPE_MONSTER + TYPE_RITUAL) == (TYPE_MONSTER + TYPE_RITUAL)
end
--miki sayaka ritual summon function
function B2Sayaka.RitualSummon(c, id, zone)
	local zone2 = Scl.GetNumFormatZone(zone)
	--local e1 = aux.AddRitualProcGreater2(c,s.sayaka_ritual_filter, zone2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCondition(B2Sayaka.ExtraLimit)
	e1:SetTarget(s.sayaka_ritual_tg)
	e1:SetOperation(s.sayaka_ritual_op)
	c:RegisterEffect(e1)
	e1:SetLabel(zone2)
	return e1
end
function s.sayaka_ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x3b29)
end
function s.sayaka_exfilter0(c)
	return c:IsLevelAbove(1) and c:IsReleasableByEffect(e) and c:IsCanBeRitualMaterial(nil)
end
function s.sayaka_ritual_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local sg=nil
		if Duel.IsPlayerAffectedByEffect(tp,60152927) then
			sg=Duel.GetMatchingGroup(s.sayaka_exfilter0,tp,LOCATION_DECK,0,nil)
		end
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,e:GetLabel(),0,1,nil,s.sayaka_ritual_filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,e:GetLabel())
end
function s.sayaka_ritual_op(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local sg=nil
	if Duel.IsPlayerAffectedByEffect(tp,60152927) then
		sg=Duel.GetMatchingGroup(s.sayaka_exfilter0,tp,LOCATION_DECK,0,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,e:GetLabel(),0,1,1,nil,s.sayaka_ritual_filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,60152927) and mat:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then 
			local ae = ({Duel.IsPlayerAffectedByEffect(tp,60152927)})[1]
			local ac = ae:GetHandler()
			ac:RegisterFlagEffect(60152927,RESETS_EP_SCL,0,1)
		end
		tc:SetMaterial(mat)
		local mat_deck = mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if #mat_deck > 0 then 
			mat:Sub(mat_deck)
			Duel.SendtoGrave(mat_deck,REASON_EFFECT+REASON_RELEASE+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--damage to both 2 players
function B2Sayaka.Damage(tp)
	local ct1 = Duel.Damage(tp, 1000, REASON_EFFECT, true)
	local ct2 = Duel.Damage(1 - tp, 1000, REASON_EFFECT, true)
	Duel.RDComplete()
	return ct1 >= 0 or ct2 >= 0
end
--limit ritual monster's effect 2's condition
function B2Sayaka.Effect2Condition(id, e, event1, op, ...)
	local event_arr = { event1, ... }
	for _, event in pairs(event_arr) do 
		Scl.SetGlobalFieldTriggerEffect(0, event, id, 
		nil, op)
	end
	e:SetCondition(s.sayaka_e2_limit_condition(id))
	B2Sayaka[id] = B2Sayaka[id] or e
end
function s.sayaka_e2_limit_condition(id)
	return function(e,tp)
		return Duel.GetFlagEffect(tp, id) > 0 and B2Sayaka.ExtraLimit(e, tp)
	end
end
--for every 1000 points difference between your LP and your opponent's.
function B2Sayaka.LPDifferent()
	return math.floor(math.abs(Duel.GetLP(0) - Duel.GetLP(1)) / 1000)
end
function B2Sayaka.LPDifferentChk()
	local ct = math.floor(math.abs(Duel.GetLP(0) - Duel.GetLP(1)) / 1000)
	return ct > 0 and 1 or 0
end
--for every 1000 points difference between your LP and your opponent's + 1
function B2Sayaka.LPDifferentAdd1000Chk(e, tp)
	local ct = math.floor(math.abs(Duel.GetLP(tp) + 1000 - Duel.GetLP(1 - tp)) / 1000)
	return ct > 0 and 1 or 0
end
--for every 2000 points difference between your LP and your opponent's.
function B2Sayaka.LPDifferent2()
	return math.floor(math.abs(Duel.GetLP(0) - Duel.GetLP(1)) / 2000)
end
function B2Sayaka.LPDifferent2Chk()
	local ct = math.floor(math.abs(Duel.GetLP(0) - Duel.GetLP(1)) / 2000)
	return ct > 0 and 1 or 0
end
--Banish from GY and damage
function B2Sayaka.BanishFromGYandDamage(c)
	local e1 = Scl.CreateIgnitionEffect(c, "Damage", nil,
		"Damage", nil, "GY",
		nil, aux.bfgcost, 
		{ "PlayerTarget", "Damage", 1000, 1000}, 
		s.sayaka_banish_damage_op)  
	return 
end
function s.sayaka_banish_damage_op(e,tp)
	B2Sayaka.Damage(tp)
end
function B2Sayaka.ExtraLimit(e, tp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown, tp, LOCATION_EXTRA, 0, nil) == 0
end