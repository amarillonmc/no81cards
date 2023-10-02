--灵械姬 零
local m=77003520
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3eec),8,2,nil,nil,99)
	c:EnableReviveLimit()
	--Effect 1
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e02:SetCode(EFFECT_DESTROY_REPLACE)
	e02:SetRange(LOCATION_MZONE)
	e02:SetTarget(cm.reptg)
	e02:SetValue(cm.repval)
	e02:SetOperation(cm.repop)
	c:RegisterEffect(e02)
	--Effect 2 
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EFFECT_UPDATE_ATTACK)
	e12:SetValue(cm.atkval)
	c:RegisterEffect(e12) 
	--Effect 3 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.xtg)
	e2:SetOperation(cm.xop)
	c:RegisterEffect(e2)
end
--Effect 1
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_MACHINE) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,m)
end
--Effect 2
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsRace,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,RACE_MACHINE)*200
end
--Effect 3 
function cm.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsCanOverlay() and chkc~=c end
	if chk==0 then return c:IsType(TYPE_XYZ) and Duel.IsExistingTarget(Card.IsCanOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,Card.IsCanOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end
function cm.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		tc:CancelToGrave()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end  
