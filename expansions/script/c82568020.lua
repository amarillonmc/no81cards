--画中人
function c82568020.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(82568020,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c82568020.target1)
	e1:SetOperation(c82568020.activate1)
	e1:SetCountLimit(1,82568020)
	c:RegisterEffect(e1)
	--add code
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_ADD_CODE)
	e5:SetValue(82567785)
	c:RegisterEffect(e5)
end
function c82568020.rtfilter1(c,e,tp)
	return (c:IsLevelBelow(6) and c:IsSetCard(0x825)  and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false) 
		   and  Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_EFFECT)) or 
		   (c:IsLevelBelow(8) and c:IsSetCard(0x825)  and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false) 
		   and  Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_EFFECT)) or
		   (c:IsLevelBelow(10) and c:IsSetCard(0x825) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false) 
		   and  Duel.IsCanRemoveCounter(tp,1,0,0x5825,3,REASON_EFFECT)) 
end
function c82568020.rtfilterlv6(c,e,tp)
	return c:IsLevelBelow(6) and c:IsSetCard(0x825)  and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false) 
		   and  Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_EFFECT) and not Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_EFFECT)
end
function c82568020.rtfilterlv8(c,e,tp)
	return c:IsLevelBelow(8) and c:IsSetCard(0x825)  and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false) 
		   and  Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_EFFECT) and not Duel.IsCanRemoveCounter(tp,1,0,0x5825,3,REASON_EFFECT)
end
function c82568020.rtfilterlv10(c,e,tp)
	return c:IsLevelBelow(10) and c:IsSetCard(0x825)  and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false) 
		   and  Duel.IsCanRemoveCounter(tp,1,0,0x5825,3,REASON_EFFECT)
end
function c82568020.rtfilter2(c,e,tp,ct)
	if ct==1 then
	return c:IsLevelBelow(6) and c:IsSetCard(0x825)  and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false)  
	elseif ct==2 then
	return c:IsLevelBelow(8) and c:IsSetCard(0x825)  and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false) 
	elseif ct==3 then
	return c:IsLevelBelow(10) and c:IsSetCard(0x825) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false) 
	else return false end
end
function c82568020.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c82568020.rtfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c82568020.activate1(e,tp,eg,ep,ev,re,r,rp,ft,lv)
	local ct=0
	if Duel.IsExistingMatchingCard(c82568020.rtfilterlv10,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) then
	ct=Duel.AnnounceNumber(tp,1,2,3)
	elseif  Duel.IsExistingMatchingCard(c82568020.rtfilterlv8,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) then
	ct=Duel.AnnounceNumber(tp,1,2)
	elseif  Duel.IsExistingMatchingCard(c82568020.rtfilterlv6,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) then
	ct=Duel.AnnounceNumber(tp,1)
	else return false end
	if Duel.RemoveCounter(tp,1,0,0x5825,ct,REASON_EFFECT)~=0 then
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c82568020.rtfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,ct)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(82568020,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c82568020.descon)
		e1:SetOperation(c82568020.desop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	 if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c82568020.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
   end 
end
end
end
function c82568020.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(82568020)~=0
end
function c82568020.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function c82568020.splimit(e,c)
	return c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_EXTRA)
end