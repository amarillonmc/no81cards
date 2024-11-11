--幻想铁处女
local m=77096022
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
--Effect 1 
function cm.cf(c) 
	return c:IsCode(77096021)
end 
function cm.f(c) 
	return c:IsFaceup() and cm.cf(c) 
end  
function cm.descon(e)
	local g=Duel.GetMatchingGroup(cm.f,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return #g>0 
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Recover(tp,2000,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(cm.f,tp,LOCATION_MZONE,0,nil)
		if #g==0 then return false end
		Duel.Hint(HINT_CARD,0,m) 
		for tc in aux.Next(g) do 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(200)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end