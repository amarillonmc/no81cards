--夏乡净梦 复仇之魂
function c67210111.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67210111,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67210111)
	e1:SetTarget(c67210111.pltg)
	e1:SetOperation(c67210111.plop)
	c:RegisterEffect(e1) 
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	e2:SetCondition(c67210111.effcon)
	e2:SetLabel(3)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1600)
	e3:SetCondition(c67210111.effcon)
	e3:SetLabel(2)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67210111,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c67210111.discon)
	e4:SetTarget(c67210111.distg)
	e4:SetOperation(c67210111.disop)
	e4:SetLabel(4)
	c:RegisterEffect(e4)
end
--P effect
function c67210111.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67210111.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Exile(c,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67210111,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOEXTRA)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCountLimit(1)
		e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e2:SetTarget(c67210111.thtg)
		e2:SetOperation(c67210111.thop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
	end
end
function c67210111.thfilter(c)
	return c:IsSetCard(0x567e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c67210111.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67210111.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c67210111.filter(c)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)==TYPE_PENDULUM
end
function c67210111.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67210111.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		if Duel.ConfirmCards(1-tp,g)~=0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67210111,0))
			local gg=Duel.SelectMatchingCard(tp,c67210111.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			if gg:GetCount()>0 then
				Duel.SendtoExtraP(gg,nil,REASON_EFFECT)
			end
		end
	end
end
--
function c67210111.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x567e) and bit.band(c:GetOriginalType(),TYPE_PENDULUM)==TYPE_PENDULUM
end
function c67210111.effcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c67210111.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local ct=g:GetClassCount(Card.GetCode)  
	return ct>=e:GetLabel()
end
function c67210111.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c67210111.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local ct=g:GetClassCount(Card.GetCode)   
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ct>=e:GetLabel()
end
function c67210111.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(67210111,3))
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c67210111.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

