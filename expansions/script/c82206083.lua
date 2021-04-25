local m=82206083
local cm=_G["c"..m]
cm.name="邪界幻灵·艾夏拉"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),7,2)  
	c:EnableReviveLimit()  
	--overlay  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)
	--direct attack  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetCountLimit(1)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCondition(cm.datcon)  
	e2:SetCost(cm.cost)  
	e2:SetOperation(cm.datop)  
	c:RegisterEffect(e2) 
	--destroy replace  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_DESTROY_REPLACE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetTarget(cm.reptg)  
	e3:SetValue(cm.repval)  
	c:RegisterEffect(e3)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)  
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_REMOVED,1,e:GetHandler()) end  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)  
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_REMOVED,1,1,c)  
	if g:GetCount()>0 then
		local og=g:GetFirst():GetOverlayGroup()  
		if og:GetCount()>0 then  
			Duel.SendtoGrave(og,REASON_RULE)  
		end  
		Duel.Overlay(c,g)  
	end  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=800
	if Duel.IsPlayerAffectedByEffect(tp,82206075) then lp=400 end
	if chk==0 then return Duel.CheckLPCost(tp,lp) end  
	Duel.PayLPCost(tp,lp)  
end  
function cm.datcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()==PHASE_MAIN1  
end  
function cm.datop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_DIRECT_ATTACK)  
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e1)  
	end  
end  
function cm.repfilter(c,tp)  
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)  
end  
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) end  
	local oc=c:GetOverlayGroup()
	if oc:IsExists(Card.IsAbleToRemove,1,nil) and Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then  
		Duel.Remove(oc:Select(tp,1,1,nil),POS_FACEUP,REASON_EFFECT)
		return true  
	end  
	return false  
end  
function cm.repval(e,c)  
	return cm.repfilter(c,e:GetHandlerPlayer())  
end  