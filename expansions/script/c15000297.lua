local m=15000297
local cm=_G["c"..m]
cm.name="青眼圣祭龙"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),8,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	c:RegisterEffect(e2)
end
function cm.disfilter(c)
	return c:IsFaceup() and not c:IsStatus(STATUS_DISABLED)
end
function cm.desfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.disfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(cm.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,cm.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not c:IsStatus(STATUS_DISABLED) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		Duel.BreakEffect()
		if tc:IsStatus(STATUS_DISABLED) and c:GetOverlayGroup() and c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xdd) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			local ag=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc:GetCode())
			if ag:GetCount()~=0 then
				Duel.Destroy(ag,REASON_EFFECT)
			end
		end
	end
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0xdd) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	end
	return false
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end