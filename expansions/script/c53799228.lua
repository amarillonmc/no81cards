local m=53799228
local cm=_G["c"..m]
cm.name="物理演算莓战车"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	return e:GetHandler():GetOwner()~=e:GetHandler():GetControler() and #g>0 and g:IsExists(aux.FilterEqualFunction(Card.GetOriginalCode,re:GetHandler():GetOriginalCode()),1,nil) 
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and re:GetHandler():IsLocation(LOCATION_MZONE) and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetSequence()<5
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or rc:GetSequence()>=5 or rc:IsControler(c:GetControler()) or not rc:IsCanOverlay(1-tp) or rc:IsImmuneToEffect(e) then return end
	local seq=rc:GetSequence()
	if not c:IsControlerCanBeChanged(true) or Duel.GetMZoneCount(1-tp,rc,tp,LOCATION_REASON_CONTROL,1<<seq)<=0 then return end
	local og=rc:GetOverlayGroup()
	if og:GetCount()>0 then Duel.SendtoGrave(og,REASON_RULE) end
	Duel.Overlay(c,Group.FromCards(rc))
	Duel.GetControl(c,1-tp,0,0,1<<seq)
end
