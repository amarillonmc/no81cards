--执迷布道烬灵
function c9911811.initial_effect(c)
	--sset
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,9911811)
	e1:SetTarget(c9911811.ssettg)
	e1:SetOperation(c9911811.ssetop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9911812)
	e3:SetTarget(c9911811.settg)
	e3:SetOperation(c9911811.setop)
	c:RegisterEffect(e3)
end
function c9911811.ssetfilter(c)
	return c:IsSetCard(0xa957) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
		and (c:IsType(TYPE_FIELD) or Duel.GetSZoneCount(0)+Duel.GetSZoneCount(1)>0
		or Duel.IsExistingMatchingCard(c9911811.unlockfilter,0,LOCATION_SZONE,LOCATION_SZONE,1,nil))
end
function c9911811.unlockfilter(c)
	return c:GetSequence()<5 and Duel.GetSZoneCount(c:GetControler(),c)>Duel.GetSZoneCount(c:GetControler())
end
function c9911811.ssettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911811.ssetfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9911811.ssetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c9911811.ssetfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	local toplayer=0
	if tc:IsType(TYPE_FIELD) then
		toplayer=aux.SelectFromOptions(tp,{true,aux.Stringid(9911811,0),tp},{true,aux.Stringid(9911811,1),1-tp})
		local fc=Duel.GetFieldCard(toplayer,LOCATION_FZONE,0)
		if fc then Duel.Destroy(fc,REASON_RULE) end
		Duel.SSet(tp,tc,toplayer)
	else
		local b1=Duel.GetSZoneCount(tp)>0 or Duel.IsExistingMatchingCard(c9911811.unlockfilter,tp,LOCATION_SZONE,0,1,nil)
		local b2=Duel.GetSZoneCount(1-tp)>0 or Duel.IsExistingMatchingCard(c9911811.unlockfilter,tp,0,LOCATION_SZONE,1,nil)
		toplayer=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911811,0),tp},{b2,aux.Stringid(9911811,1),1-tp})
		local b3=Duel.GetSZoneCount(toplayer)>0
		local b4=Duel.IsExistingMatchingCard(c9911811.unlockfilter,toplayer,LOCATION_SZONE,0,1,nil)
		if b4 and (not b3 or Duel.SelectYesNo(tp,aux.Stringid(9911811,2))) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911811,3))
			local sc=Duel.SelectMatchingCard(tp,c9911811.unlockfilter,toplayer,LOCATION_SZONE,0,1,1,nil):GetFirst()
			local zone=1<<sc:GetSequence()
			Duel.Destroy(sc,REASON_RULE)
			Duel.MoveToField(tc,tp,toplayer,LOCATION_SZONE,POS_FACEDOWN,false,zone)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		elseif b3 then
			Duel.SSet(tp,tc,toplayer)
		end
	end
end
function c9911811.setfilter(c)
	return c:IsSetCard(0xa957) and c:IsRace(RACE_PYRO) and not c:IsForbidden()
end
function c9911811.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911811.setfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c9911811.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c9911811.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
