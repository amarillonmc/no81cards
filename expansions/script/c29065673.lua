--灵知隐者 暗耀之翼
function c29065673.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x87aa),2,2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,29065673)
	e1:SetTarget(c29065673.fatg)
	e1:SetOperation(c29065673.faop)
	c:RegisterEffect(e1)
	--Destroy Remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,29000034)	
	e2:SetTarget(c29065673.drtg)
	e2:SetOperation(c29065673.drop)
	c:RegisterEffect(e2)
	--to hand 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,29000035)
	e3:SetCondition(c29065673.thcon)
	e3:SetTarget(c29065673.thtg)
	e3:SetOperation(c29065673.thop)
	c:RegisterEffect(e3)
end
function c29065673.filter(c,tp)
	return c:IsCode(29065666) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c29065673.fatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065673.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c29065673.faop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c29065673.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		end
		Duel.BreakEffect()
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c29065673.desfil(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x87aa)
end
function c29065673.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c29065673.desfil,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end   
	local g=Duel.SelectTarget(tp,c29065673.desfil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,1,1-tp,0)
end
function c29065673.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Destroy(tc,REASON_EFFECT)
	local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
function c29065673.tkfil(c,e,tp)
	return c:GetOwner()==1-tp
end
function c29065673.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29065673.tkfil,1,nil,e,tp)
end
function c29065673.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x87aa) and c:IsType(TYPE_MONSTER)
end
function c29065673.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065673.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065673.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29065673.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	dg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(dg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,dg)
end

















