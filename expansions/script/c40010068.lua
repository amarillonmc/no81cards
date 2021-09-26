--虚空的击退者
local m=40010068
local cm=_G["c"..m]
cm.named_with_Revenger=1
function cm.Revenger(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Revenger
end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.retg)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1) 
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)   
end
function cm.refilter(c)
	return c:IsFaceup() and (cm.Revenger(c) or c:IsCode(40010072)) and c:IsReleasableByEffect()
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.refilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsReleasableByEffect,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectTarget(tp,cm.refilter,tp,LOCATION_MZONE,0,1,6,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectTarget(tp,Card.IsReleasableByEffect,tp,0,LOCATION_ONFIELD,#g1,#g1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g1,g1:GetCount(),0,0)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Release(tg,REASON_EFFECT)
	end
end
function cm.refilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsType(TYPE_MONSTER)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.refilter,3,nil,tp)
end
function cm.thfilter(c)
	return cm.Revenger(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
end