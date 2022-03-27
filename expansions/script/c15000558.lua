local m=15000558
local cm=_G["c"..m]
cm.name="零场记忆-『两种苦痛』"
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.drcon)
	e1:SetCost(cm.drcost)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not tc1 or not tc2 then return false end
	local scl1=tc1:GetLeftScale()
	local scl2=tc2:GetRightScale()
	return scl1==0 and scl2==0
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_PZONE,0,nil)
	if chk==0 then return g:GetCount()==2 end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thfilter(c,tp)
	return c:IsSetCard(0xf3b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end