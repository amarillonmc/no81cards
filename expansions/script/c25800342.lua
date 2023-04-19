--MATE舰-皇家方舟
local m=25800342
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
		aux.AddXyzProcedureLevelFree(c,cm.mfilter,nil,2,2,cm.ovfilter,aux.Stringid(m,0),cm.xyzop)
	--remove spell/trap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2,m)
	e1:SetCondition(cm.remcon2)
	e1:SetOperation(cm.remop2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,m)
	e2:SetCost(cm.discost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.reptg)
	c:RegisterEffect(e3)

end
function cm.mfilter(c)
	return c:IsRank(4)
end
function cm.cfilter(c)
	return c:IsSetCard(0x95) and c:IsDiscardable()
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
---e1
function cm.remcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return  re:GetHandler():IsRelateToEffect(re) and (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) 
	or  re:GetHandler():IsAttribute(ATTRIBUTE_WATER)) and rc~=c
end
function cm.remop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if  c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and rc:IsCanOverlay() and c:IsType(TYPE_XYZ) then
		local og=rc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		rc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(rc))
	end
end
----e2
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function cm.filter(c)
	return c:IsCanOverlay()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		tc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
----3
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end

