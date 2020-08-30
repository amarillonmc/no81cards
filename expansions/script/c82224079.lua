local m=82224079
local cm=_G["c"..m]
cm.name="磐岩龙 费尔森"
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)  
	c:EnableReviveLimit() 
	--equip  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_EQUIP)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetCost(cm.eqcost)
	e1:SetCondition(cm.eqcon)  
	e1:SetTarget(cm.eqtg)  
	e1:SetOperation(cm.eqop)  
	c:RegisterEffect(e1)  
end
function cm.cfilter(c)  
	return c:IsRace(RACE_DINOSAUR) and c:IsAbleToRemoveAsCost()  
end  
function cm.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,2,c) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,2,2,c)  
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end  
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)  
end  
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0  
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)  
		and e:GetHandler():IsRelateToEffect(e) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)  
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)  
end  
function cm.eqlimit(e,c)  
	return e:GetOwner()==c  
end  
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) then  
		Duel.Equip(tp,c,tc)  
		--Add Equip limit  
		local e1=Effect.CreateEffect(tc)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_EQUIP_LIMIT)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		e1:SetValue(cm.eqlimit)  
		c:RegisterEffect(e1) 
		--atk up  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_EQUIP)  
		e2:SetCode(EFFECT_UPDATE_ATTACK)  
		e2:SetValue(500)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
		c:RegisterEffect(e2) 
		--Negate  
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e3:SetCode(EVENT_CHAIN_SOLVING) 
		e3:SetRange(LOCATION_SZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetCondition(cm.negcon)
		e3:SetOperation(cm.negop)  
		c:RegisterEffect(e3) 
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetFlagEffect(m)==0 and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and rp~=tp and Duel.IsChainDisablable(ev)
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then  
		Duel.Hint(HINT_CARD,0,m)  
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)  
		if Duel.NegateEffect(ev) then  
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)  
		end  
	end  
end 
