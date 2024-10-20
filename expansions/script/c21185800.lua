--救赎的圣歌
function c21185800.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,21185800)
	e2:SetCost(c21185800.secost)
	e2:SetTarget(c21185800.setarget)
	e2:SetOperation(c21185800.seoperation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1,21185801)
	e3:SetCondition(c21185800.condition)
	e3:SetTarget(c21185800.target)
	e3:SetOperation(c21185800.operation)
	c:RegisterEffect(e3)	
end
function c21185800.discheck(c)
	return c:IsCode(21185800) and c:IsDiscardable()
end
function c21185800.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c21185800.discheck,tp,LOCATION_HAND,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(21185800,1)) then
		Duel.Hint(3,tp,HINTMSG_DISCARD)
		Duel.DiscardHand(tp,c21185800.discheck,1,1,REASON_COST,nil)
		e:SetLabel(100)
	end
end
function c21185800.addcheck(c)
	return c:IsCode(21185805) and c:IsAbleToHand() and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end
function c21185800.setarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21185800.addcheck,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	if e:GetLabel()==100 then
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+0x200)
	else 
		e:SetProperty(0) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c21185800.seoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21185800.addcheck,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21185800.codecheck(c)
	return c:IsFacedown() or c:GetFlagEffect(21185805)<1 
end
function c21185800.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21185800.codecheck,tp,LOCATION_MZONE,0,nil)
	return ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and #g==0
end
function c21185800.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		local activate_type=re:GetHandler():GetType()
		--setable
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MONSTER_SSET)
		e1:SetValue(activate_type)
		c:RegisterEffect(e1)
		local res=not c:IsStatus(STATUS_CHAINING)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and c:IsSSetable() 
		e1:Reset()
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c21185800.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		local activate_type=re:GetHandler():GetType()
		--setable
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MONSTER_SSET)
		e1:SetValue(activate_type)
		c:RegisterEffect(e1)
		local res=not c:IsStatus(STATUS_CHAINING)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and c:IsSSetable() 
		if Duel.Destroy(eg,REASON_EFFECT) and c:IsRelateToEffect(e) and res then
			Duel.BreakEffect()
			local activate_type=re:GetHandler():GetType()
			if Duel.SSet(tp,c) then
				e1:Reset()
				c:SetCardData(CARDDATA_TYPE,activate_type)
				c:CopyEffect(re:GetHandler():GetOriginalCodeRule(),RESET_EVENT+RESETS_REDIRECT,1)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e1:SetValue(LOCATION_HAND)
				c:RegisterEffect(e1)
				local ge=Effect.CreateEffect(c)
				ge:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				ge:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				ge:SetCode(EVENT_LEAVE_FIELD_P)
				ge:SetOperation(c21185800.leaveop)
				c:RegisterEffect(ge)
			end
		end
	end
end
function c21185800.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetCardData(CARDDATA_TYPE,TYPE_PENDULUM+TYPE_MONSTER+TYPE_EFFECT+TYPE_TUNER)
	e:Reset()
end