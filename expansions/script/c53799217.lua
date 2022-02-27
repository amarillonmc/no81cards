local m=53799217
local cm=_G["c"..m]
cm.name="垂钓者 原发"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,3,2,nil,nil,99)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+50)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return eg:GetCount()==1 end)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.thfilter(c,mct)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(mct) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetOverlayCount()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.thfilter(chkc,ct) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil,ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,ct)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and e:GetHandler():GetOverlayCount()>0 then
		Duel.BreakEffect()
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=eg:GetFirst()
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and ec and ec:IsCanOverlay() and Duel.IsPlayerCanDraw(ec:GetControler(),1) end
	Duel.SetTargetPlayer(ec:GetControler())
	Duel.SetTargetParam(1)
	e:SetLabelObject(ec)
	ec:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,ec:GetControler(),1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or not tc or not tc:IsRelateToEffect(e) or not tc:IsCanOverlay() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Overlay(c,tc)
	Duel.Draw(p,d,REASON_EFFECT)
end
