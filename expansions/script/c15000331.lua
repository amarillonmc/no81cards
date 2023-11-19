local m=15000331
local cm=_G["c"..m]
cm.name="内核控制 虚空"
function cm.initial_effect(c)
	--disable  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)  
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)   
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	--e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,15000331)  
	e2:SetCondition(aux.exccon)
	e2:SetCost(cm.atkcost)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
end
function cm.tfilter(c,tp)  
	return c:IsOnField() and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0xf39) 
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()  
	if ep==tp then return false end  
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end  
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)  
	return tg and tg:IsExists(cm.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()  
	Duel.NegateEffect(ev)
end
function cm.costfilter(c)  
	return c:IsAbleToGraveAsCost() and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()  
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())  
	Duel.SendtoGrave(g,REASON_COST)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)  
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local dc=dg:GetFirst()
	while dc do
		if aux.NegateEffectMonsterFilter(dc) then
			Duel.NegateRelatedChain(dc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			dc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			dc:RegisterEffect(e2)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(cm.atkval)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		dc:RegisterEffect(e3)
		dc=dg:GetNext()
	end
end
function cm.atkval(e,c)
	return c:GetBaseAttack()*2
end