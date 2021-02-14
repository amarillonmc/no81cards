--后巴别塔·清流
function c79035101.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79035101)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c79035101.rectg)
	e1:SetOperation(c79035101.recop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,214011)
	e2:SetTarget(c79035101.thtg)
	e2:SetOperation(c79035101.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,214011)
	e4:SetTarget(c79035101.thtg1)
	e4:SetOperation(c79035101.thop1)
	c:RegisterEffect(e4)
end
function c79035101.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c79035101.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c79035101.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0xca3) and c:IsType(TYPE_MONSTER)
end
function c79035101.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79035101.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,100)
end
function c79035101.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79035101.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	local tg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(tg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	Duel.BreakEffect()
	Duel.Recover(tp,100,REASON_EFFECT)
end
function c79035101.thfil1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xca3) and c:IsType(TYPE_SPELL)
end
function c79035101.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79035101.thfil1,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsReason(REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79035101.thop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79035101.thfil1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	local tg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(tg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end




