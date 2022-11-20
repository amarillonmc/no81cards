--欢迎来到南瓜乐园！
function c10173039.initial_effect(c)
	--c:EnableCounterPermit(0x2f)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c10173039.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c10173039.destg)
	e4:SetValue(c10173039.value)
	e4:SetOperation(c10173039.desop)
	c:RegisterEffect(e4)
	--tuner
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCost(c10173039.tuncost)
	e5:SetTarget(c10173039.tuntg)
	e5:SetOperation(c10173039.tunop)
	c:RegisterEffect(e5)
end
function c10173039.tuncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x2f,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x2f,5,REASON_COST)
end
function c10173039.filter(c)
	return c:IsFaceup() and (not c:IsType(TYPE_TUNER) or not c:IsRace(RACE_SPELLCASTER))
end
function c10173039.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10173039.tuntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsOnField() and c10173039.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10173039.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10173039.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10173039.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c10173039.tunop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if tc:IsRelateToEffect(e) and c10173039.filter(tc) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_SPELLCASTER)
		tc:RegisterEffect(e2)
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c10173039.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	   local tc=g:GetFirst()
	   if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		  local e3=Effect.CreateEffect(c)
		  e3:SetType(EFFECT_TYPE_SINGLE)
		  e3:SetCode(EFFECT_DISABLE)
		  e3:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e3,true)
		  local e4=Effect.CreateEffect(c)
		  e4:SetType(EFFECT_TYPE_SINGLE)
		  e4:SetCode(EFFECT_DISABLE_EFFECT)
		  e4:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e4,true)
		  Duel.SpecialSummonComplete()
	   end
	end
end
function c10173039.dfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp) and c:GetCounter(0x2f)>0
end
function c10173039.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10173039.dfilter,nil,1,tp) and Duel.IsCanRemoveCounter(tp,1,0,0x2f,3,REASON_COST) end
	return Duel.SelectYesNo(tp,aux.Stringid(10173039,1))
end
function c10173039.value(e,c)
	return c:IsOnField() and c:IsControler(tp)
end
function c10173039.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10173039)
	Duel.RemoveCounter(tp,1,0,0x2f,3,REASON_COST)
end
function c10173039.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re and re:GetHandler()==e:GetHandler() then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_COUNTER_PERMIT+0x2f)
			e1:SetValue(c:GetLocation())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc:AddCounter(0x2f,1,REASON_EFFECT)
			tc=g:GetNext()
		end 
	end
end