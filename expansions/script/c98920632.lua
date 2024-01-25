--斩机 未知西格玛
function c98920632.initial_effect(c)
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98920632.spcon)
	c:RegisterEffect(e1) 
	--special summon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920632,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c98920632.spcost)
	e2:SetTarget(c98920632.sptg)
	e2:SetOperation(c98920632.spop)
	c:RegisterEffect(e2)
end
function c98920632.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c98920632.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920632.filter(c,e,tp)
	return c:IsSetCard(0x132) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920632.fselect(g,tp)
	return g:GetClassCount(Card.GetCode)==g:GetCount() and (Duel.IsExistingMatchingCard(c98920632.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g,2,2) or Duel.IsExistingMatchingCard(c98920632.synfilter,tp,LOCATION_EXTRA,0,1,nil,g))
end
function c98920632.synfilter(c,g)
	return c:IsSetCard(0x132) and c:IsSynchroSummonable(nil,g)
end
function c98920632.xyzfilter(c,g)
	return c:IsSetCard(0x132) and c:IsXyzSummonable(g,2,2)
end
function c98920632.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98920632.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:GetCount()>0 and g:CheckSubGroup(c98920632.fselect,2,2,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920632.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98920632.filter),tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c98920632.fselect,false,2,2,tp)
	if sg and sg:GetCount()==2 then
		local tc1=sg:GetFirst()
		local tc2=sg:GetNext()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
		local e2=e1:Clone()
		tc2:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e3)
		local e4=e3:Clone()
		tc2:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
		Duel.AdjustAll()
		if sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
		local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,sg,2,2)
		local tg=Duel.GetMatchingGroup(c98920632.synfilter,tp,LOCATION_EXTRA,0,nil,sg)
		if xyzg:GetCount()>0 and (tg:GetCount()==0 or Duel.SelectOption(tp,1165,1164)==0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,sg)
		elseif tg:GetCount()>0  then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			 local rg=tg:Select(tp,1,1,nil)
			 Duel.SynchroSummon(tp,rg:GetFirst(),nil,og)
		end
	end
end