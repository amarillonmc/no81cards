--创圣钢战-AQUARION
function c82557915.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),8,2,nil,nil,3)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetDescription(aux.Stringid(82557915,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c82557915.descost)
	e2:SetTarget(c82557915.destg)
	e2:SetOperation(c82557915.desop)
	c:RegisterEffect(e2)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c82557915.negcon)
	e4:SetOperation(c82557915.negop)
	c:RegisterEffect(e4)
end
function c82557915.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=2 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82557915.tgfilter(c)
	return c:IsFaceup()
end
function c82557915.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82557915.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c82557915.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c82557915.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	 if tc:IsRelateToEffect(e) then
				  local e3=Effect.CreateEffect(e:GetHandler())
				  e3:SetType(EFFECT_TYPE_SINGLE)
				  e3:SetCode(EFFECT_DISABLE)
				  e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				  tc:RegisterEffect(e3)
				  local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end
function c82557915.negcon(e,tp,eg,ep,ev,re,r,rp)
	return  rp==1-tp and (re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_SPELL))  and Duel.IsChainDisablable(ev)
		and e:GetHandler():GetFlagEffect(82557915)<=0 
	   and e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=3
end
function c82557915.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(82557915,0)) then
		Duel.Hint(HINT_CARD,0,82557915)
		if Duel.NegateEffect(ev) then 
		e:GetHandler():RegisterFlagEffect(82557915,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	end
end