--夏乡净梦 衿坂美冬
function c67210119.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67210119,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67210119)
	e1:SetTarget(c67210119.pltg)
	e1:SetOperation(c67210119.plop)
	c:RegisterEffect(e1) 
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67210119,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,67210120)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c67210119.condition)
	e2:SetTarget(c67210119.target)
	e2:SetOperation(c67210119.activate)
	c:RegisterEffect(e2)	
end
--P effect
function c67210119.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67210119.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Exile(c,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67210119,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_TOEXTRA)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCountLimit(1)
		e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e2:SetTarget(c67210119.destg)
		e2:SetOperation(c67210119.desop)
		c:RegisterEffect(e2)
	end
end
--
function c67210119.filter22(c)
	return c:IsSetCard(0x567e) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c67210119.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67210119.filter22,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c67210119.filter(c)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)==TYPE_PENDULUM
end
function c67210119.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67210119.filter22),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67210112,0))
		local gg=Duel.SelectMatchingCard(tp,c67210112.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if gg:GetCount()>0 then
			Duel.SendtoExtraP(gg,nil,REASON_EFFECT)
		end
	end
end
--moster effect
function c67210119.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and not e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c67210119.filter2(c)
	return c:IsCode(67210121) and c:IsSSetable()
end
function c67210119.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67210119.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c) end
end
function c67210119.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67210119.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

