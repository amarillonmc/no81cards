--方舟骑士-瑕光
c115025.named_with_Arknight=1
function c115025.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,115025)
	e1:SetCost(c115025.thcost)
	e1:SetTarget(c115025.thtg)
	e1:SetOperation(c115025.thop)
	c:RegisterEffect(e1)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,115026)
	e3:SetTarget(c115025.sttg)
	e3:SetOperation(c115025.stop)
	c:RegisterEffect(e3)
end
function c115025.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c115025.thfil(c)
	return c:IsAbleToHand() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM)
end
function c115025.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c115025.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c115025.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c115025.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	local tg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(tg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	local tc=tg:GetFirst()
	Duel.Recover(tp,tc:GetAttack()/2,REASON_EFFECT)
end
function c115025.stfil(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c115025.xgfilter(c)
	return c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)
end
function c115025.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c115025.xgfilter,tp,LOCATION_PZONE,0,1,nil) and ep==tp and (re:GetHandler():IsSetCard(0x87af) or (_G["c"..re:GetHandler():GetCode()] and  _G["c"..re:GetHandler():GetCode()].named_with_Arknight)) and Duel.IsExistingMatchingCard(c115025.stfil,tp,LOCATION_DECK,0,2,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,tp,LOCATION_PZONE)
end
function c115025.stop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g1=Duel.GetMatchingGroup(c115025.stfil,tp,LOCATION_DECK,0,nil)
	if Duel.Destroy(g,REASON_EFFECT) and g1:GetCount()>1 then
	local tg=g1:Select(tp,2,2,nil)
	local tc=tg:GetFirst()
	while tc do
	Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	tc=tg:GetNext()
	end
	end
end