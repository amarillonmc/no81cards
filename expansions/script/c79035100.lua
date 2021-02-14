--后巴别塔·瑕光
function c79035100.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79035100)
	e1:SetCost(c79035100.thcost)
	e1:SetTarget(c79035100.thtg)
	e1:SetOperation(c79035100.thop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c79035100.efcon)
	e2:SetOperation(c79035100.efop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,214010)
	e3:SetTarget(c79035100.sttg)
	e3:SetOperation(c79035100.stop)
	c:RegisterEffect(e3)
end
function c79035100.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c79035100.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0xca3)
end
function c79035100.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79035100.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c79035100.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79035100.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	local tg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(tg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	local tc=tg:GetFirst()
	Duel.Recover(tp,tc:GetAttack()/2,REASON_EFFECT)
end
function c79035100.efcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return r==REASON_FUSION and ec:IsSetCard(0xca3)
end
function c79035100.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79035100)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.indoval)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e5)
	rc:RegisterFlagEffect(79035100,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79035100,0))
end
function c79035100.stfil(c)
	return c:IsSetCard(0xca3) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c79035100.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0xca3) and ep==tp and re:GetHandler():IsSetCard(0xca3) and Duel.IsExistingMatchingCard(c79035100.stfil,tp,LOCATION_DECK,0,2,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,tp,LOCATION_PZONE)
end
function c79035100.stop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g1=Duel.GetMatchingGroup(c79035100.stfil,tp,LOCATION_DECK,0,nil)
	if Duel.Destroy(g,REASON_EFFECT) and g1:GetCount()>1 then
	local tg=g1:Select(tp,2,2,nil)
	local tc=tg:GetFirst()
	while tc do
	Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	tc=tg:GetNext()
	end
	end
end
















