--超·Ｎｏ．８１服务器吉祥物 卡戎
local m=33703370
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.retga)
	e1:SetOperation(cm.reopa)
	c:RegisterEffect(e1)
end
--Effect 1
function cm.retga(e,tp,eg,ep,ev,re,r,rp,chk)
	local hcta=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local hctb=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	local ct
	local hck
	if hcta==hctb then return false end
	if hcta>hctb then
		ct=hcta-hctb
		hck=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,ct,nil)
	else
		ct=hctb-hcta
		hck=Duel.IsPlayerCanDraw(tp,ct)
	end
	if chk==0 then return hck end
	if hcta>hctb then
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,ct)
	else
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	end
end
function cm.reopa(e,tp,eg,ep,ev,re,r,rp)
	local hcta=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local hctb=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	local ct
	local hck
	if hcta==hctb then return end
	if hcta>hctb then
		ct=hcta-hctb
		hck=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,ct,nil)
	else
		ct=hctb-hcta
		hck=Duel.IsPlayerCanDraw(tp,ct)
	end
	if not hck then return false end
	if hcta>hctb then
		Duel.DiscardHand(tp,nil,ct,ct,REASON_EFFECT+REASON_DISCARD)
	else
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
	Duel.AdjustAll()
	local hga=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local hgb=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)	
	Duel.BreakEffect()
	if Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,1))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))		
		Duel.ConfirmCards(tp,hgb)
		Duel.ConfirmCards(1-tp,hga)
		Duel.SendtoHand(hga,1-tp,REASON_EFFECT)
		Duel.SendtoHand(hgb,tp,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	end
end
