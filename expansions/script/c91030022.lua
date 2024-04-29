--神碑の牙フレーキ
local m=91030022
local cm=c91030022
function c91030022.initial_effect(c)
	--fusion material
	 c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91030022,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c91030022.rmcon)
	e1:SetTarget(c91030022.rmtg)
	e1:SetOperation(c91030022.rmop)
	c:RegisterEffect(e1)
	--damage val
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(91030022,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,91030022)
	e4:SetCondition(c91030022.thcon)
	e4:SetTarget(c91030022.thtg)
	e4:SetOperation(c91030022.thop)
	c:RegisterEffect(e4)
end
function cm.matfilter(c)
	return c:IsLinkSetCard(0x9d3) and c:IsLinkAttribute(ATTRIBUTE_ALL&~ATTRIBUTE_WIND)
end
function c91030022.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
		and c:GetSequence()>4
end
function c91030022.tgfilter(c)
	return c:IsSetCard(0x9d3) and c:IsAbleToGrave()
end
function c91030022.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91030022.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c91030022.rmop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c91030022.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c91030022.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c91030022.thfilter(c)
	return c:IsSetCard(0x9d3) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c91030022.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c91030022.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c91030022.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c91030022.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c91030022.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
