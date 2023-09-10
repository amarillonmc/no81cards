--曙光之圣刻印
function c98920501.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c98920501.discon)
	e3:SetOperation(c98920501.disop)
	c:RegisterEffect(e3)
end
function c98920501.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_MONSTER) and re:GetCode()==EVENT_RELEASE and re:GetHandler():IsSetCard(0x69)
		and e:GetHandler():GetFlagEffect(98920501)<=0 and not re:GetHandler():IsCode(98920633)
end
function c98920501.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(98920501,2)) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c98920501.repop)
		e:GetHandler():RegisterFlagEffect(98920501,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98920501,3))
	end
end
function c98920501.repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if e:GetHandler():IsType(TYPE_PENDULUM) then
	   local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920501.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	   local tc=g:GetFirst()
	   if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_SET_ATTACK)
		  e1:SetValue(0)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		  tc:RegisterEffect(e1)
		  local e2=e1:Clone()
		  e2:SetCode(EFFECT_SET_DEFENSE)
		  tc:RegisterEffect(e2)
	   end
	   Duel.SpecialSummonComplete()
	elseif e:GetHandler():IsCode(98920501) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920501.spfilter2),tp,0x13,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if not tc then return end
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_SET_ATTACK)
		   e1:SetValue(0)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc:RegisterEffect(e1)
		   local e2=e1:Clone()
		   e2:SetCode(EFFECT_SET_DEFENSE)
		   tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	else
	   local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920501.spfilter),tp,0x13,0,1,1,nil,e,tp)
	   local tc=g:GetFirst()
	   if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_SET_ATTACK)
		  e1:SetValue(0)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		  tc:RegisterEffect(e1)
		  local e2=e1:Clone()
		  e2:SetCode(EFFECT_SET_DEFENSE)
		  tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end   
end
function c98920501.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and not c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920501.spfilter2(c,e,tp)
	return c:IsSetCard(0x69) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end