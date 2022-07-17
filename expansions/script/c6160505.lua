--破碎世界 纷争
function c6160505.initial_effect(c)
	--to hand  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160505,0))  
	e1:SetCategory(CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)   
	e1:SetCountLimit(1,6160505)
	e1:SetCondition(c6160505.thcon)  
	e1:SetTarget(c6160505.thtg)  
	e1:SetOperation(c6160505.thop)  
	c:RegisterEffect(e1)
	--negate 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_DISABLE)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,6160505)
	e2:SetCondition(c6160505.condition)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c6160505.target)  
	e2:SetOperation(c6160505.activate)  
	c:RegisterEffect(e2) 
end
function c6160505.cfilter(c)  
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsRace(RACE_SPELLCASTER)
end  
function c6160505.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(c6160505.cfilter,tp,LOCATION_MZONE,0,1,nil)  
end  
function c6160505.thfilter(c)  
	return c:IsAbleToHand()  
end  
function c6160505.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c6160505.thfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c6160505.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)  
	local g=Duel.SelectTarget(tp,c6160505.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end  
function c6160505.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  
function c6160505.rfilter(c)  
	return c:IsFaceup()  and c:IsType(TYPE_FUSION) and c:IsRace(RACE_SPELLCASTER)
end  
function c6160505.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(c6160505.rfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end  
function c6160505.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c6160505.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end