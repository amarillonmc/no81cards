local m=53799196
local cm=_G["c"..m]
cm.name="奏者 HNS"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(cm.rmcon)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.oltg)
	e2:SetOperation(cm.olop)
	c:RegisterEffect(e2)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d==e:GetHandler() then d=Duel.GetAttacker() end
	e:SetLabelObject(d)
	return d~=nil
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local d=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,d,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d:GetBaseAttack())
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=e:GetLabelObject()
	local dam=d:GetBaseAttack()
	if d:IsRelateToBattle() and Duel.Remove(d,POS_FACEUP,REASON_EFFECT)~=0 and dam>0 then
		if Duel.Damage(1-tp,dam,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsChainAttackable(0) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
			Duel.ChainAttack()
		end
	end
end
function cm.olfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function cm.oltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.olfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.olfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,cm.olfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,2,nil)
end
function cm.olop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
			local ct=Duel.GetOperatedGroup():GetCount()
			if ct~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(ct*800)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
			end
		end
	end
end
