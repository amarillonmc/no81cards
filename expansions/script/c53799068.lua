local m=53799068
local cm=_G["c"..m]
cm.name="萤火虫之巢 SNNM"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,6,2,nil,nil,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.mtop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.ovfilter(c,e)
	return c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e))
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then Duel.Overlay(c,g) end
end
function cm.filter(c)
	return c:GetDefense()>=0
end
function cm.val(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.filter,nil)
	return g:GetSum(Card.GetDefense)
end
