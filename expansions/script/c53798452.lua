local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id+4)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function s.ritfilter(c)
	return c:IsCode(id+4) and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function s.ritlevel(c)
	return 5
end
function s.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk,sg)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(s.rcheck,1,lv,tp,c,lv,greater_or_equal,sg)
	aux.GCheckAdditional=nil
	return res
end
function s.rcheck(g,tp,c,lv,greater_or_equal,sg)
	return aux.RitualCheck(g,tp,c,lv,greater_or_equal) and sg:FilterCount(aux.IsInGroup,nil,g)==#sg
end
function s.fselect(sg,tp,e,rc,mc)
	if sg:FilterCount(Card.IsRace,nil,rc)>0 or sg:FilterCount(Card.IsAttribute,nil,mc)>0 then return false end
	if sg:GetClassCount(Card.GetRace)~=#sg or sg:GetClassCount(Card.GetAttribute)~=#sg then return false end
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
	mg:Merge(sg)
	local effs={}
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		table.insert(effs,e1)
	end
	local res=Duel.IsExistingMatchingCard(s.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,s.ritfilter,e,tp,mg,nil,s.ritlevel,"Greater",true,sg)
	for _,e1 in ipairs(effs) do
		e1:Reset()
	end
	return res
end
function s.costfilter(c,e,tp)
	if not c:IsType(TYPE_MONSTER) or c:IsPublic() then return false end
	local rc=c:GetRace()
	local mc=c:GetAttribute()
	local mg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=math.min(ft,3)
	return mg:CheckSubGroup(s.fselect,1,ct,tp,e,rc,mc)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(tc)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return true
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or not tc:IsLocation(LOCATION_HAND) then return end
	local rc=tc:GetRace()
	local mc=tc:GetAttribute()
	local mg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=math.min(ft,3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=mg:SelectSubGroup(tp,s.fselect,false,1,ct,tp,e,rc,mc)
	if not sg or sg:GetCount()==0 then return end
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		Duel.ConfirmCards(1-tp,sg)
		local rmg=Duel.GetRitualMaterial(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,s.ritfilter,e,tp,rmg,nil,s.ritlevel,"Greater",true,sg)
		local rtc=tg:GetFirst()
		if rtc then
			Duel.BreakEffect()
			rmg=rmg:Filter(Card.IsCanBeRitualMaterial,rtc,rtc)
			if rtc.mat_filter then
				rmg=rmg:Filter(rtc.mat_filter,rtc,tp)
			else
				rmg:RemoveCard(rtc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(rtc,5,"Greater")
			local mat=rmg:SelectSubGroup(tp,s.rcheck,true,1,5,tp,rtc,5,"Greater",sg)
			aux.GCheckAdditional=nil
			if mat then
				rtc:SetMaterial(mat)
				Duel.ReleaseRitualMaterial(mat)
				Duel.BreakEffect()
				if Duel.SpecialSummon(rtc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
					rtc:CompleteProcedure()
					if tc:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
						if Duel.Equip(tp,tc,rtc,true) then
							local e1=Effect.CreateEffect(e:GetHandler())
							e1:SetType(EFFECT_TYPE_SINGLE)
							e1:SetCode(EFFECT_EQUIP_LIMIT)
							e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
							e1:SetReset(RESET_EVENT+RESETS_STANDARD)
							e1:SetValue(s.eqlimit)
							e1:SetLabelObject(rtc)
							tc:RegisterEffect(e1)
						end
					end
				end
			end
		end
	end
end
function s.eqlimit(e,c)
	return e:GetLabelObject()==c
end

