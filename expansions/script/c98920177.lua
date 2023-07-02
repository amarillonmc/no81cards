--三形金字塔的化身
function c98920177.initial_effect(c)
		--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ROCK),3,2)
	c:EnableReviveLimit()   
	 --search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920177)
	e1:SetCondition(c98920177.thcon)
	e1:SetTarget(c98920177.thtg)
	e1:SetOperation(c98920177.thop)
	c:RegisterEffect(e1)	
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920177,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c98920177.damcost)
	e1:SetTarget(c98920177.damtg)
	e1:SetOperation(c98920177.damop)
	c:RegisterEffect(e1)  
  --field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920177,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c98920177.condition)
	e2:SetTarget(c98920177.target)
	e2:SetOperation(c98920177.operation)
	c:RegisterEffect(e2)
end
function c98920177.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c98920177.thfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c98920177.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920177.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920177.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920177.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920177.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920177.damfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function c98920177.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920177.damfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c98920177.damfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*400)
end
function c98920177.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c98920177.damfilter,tp,LOCATION_GRAVE,0,nil)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,ct*400,REASON_EFFECT)
end
function c98920177.filter(c,tp,code)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0xe2) and c:GetActivateEffect():IsActivatable(tp,true,true) and not c:IsCode(code)
end
function c98920177.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c98920177.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if chkc then return false end
	if chk==0 then return tc and tc:IsFaceup() and tc:IsSetCard(0xe2) and tc:IsAbleToGrave() and tc:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c98920177.filter,tp,LOCATION_DECK,0,1,nil,tp,tc:GetCode()) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
end
function c98920177.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c98920177.filter,tp,LOCATION_DECK,0,1,1,nil,tp,tc:GetCode())
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end