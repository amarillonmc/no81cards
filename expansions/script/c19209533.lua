--判决牢狱的囚犯 08桃濑遍
function c19209533.initial_effect(c)
	aux.AddCodeList(c,19209511)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum effect
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,19209533)
	e1:SetCondition(c19209533.thcon)
	e1:SetTarget(c19209533.thtg)
	e1:SetOperation(c19209533.thop)
	c:RegisterEffect(e1)
	--monster effect
	--to pzone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19209534)
	e2:SetTarget(c19209533.pztg)
	e2:SetOperation(c19209533.pzop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1,19209535)
	e4:SetCondition(c19209533.negcon)
	e4:SetCost(c19209533.negcost)
	e4:SetTarget(c19209533.negtg)
	e4:SetOperation(c19209533.negop)
	c:RegisterEffect(e4)
end
function c19209533.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,e:GetHandler(),19209511)
end
function c19209533.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b50) and not c:IsCode(19209533) and c:IsAbleToHand()
end
function c19209533.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209533.thfilter,tp,LOCATION_EXTRA,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c19209533.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoHand(c,nil,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c19209533.thfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c19209533.pfilter(c)
	return c:IsCode(19209511) and not c:IsForbidden()
end
function c19209533.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and Duel.IsExistingMatchingCard(c19209533.pfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c19209533.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.CheckLocation(tp,LOCATION_PZONE,0)
		and Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c19209533.pfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c19209533.chkfilter(c)
	return c:IsCode(19209511) and c:IsFaceup()
end
function c19209533.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	return Duel.IsExistingMatchingCard(c19209533.chkfilter,tp,LOCATION_ONFIELD,0,1,nil) and ex and tg~=nil and tc+tg:FilterCount(Card.IsLocation,nil,0x30)-#tg>0 and Duel.IsChainNegatable(ev)
end
function c19209533.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function c19209533.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c19209533.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
