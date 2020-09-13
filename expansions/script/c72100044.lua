--​帝王的羽化
function c72100044.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c72100044.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EVENT_CHAIN_SOLVING)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCondition(c72100044.negcon)  
	e3:SetOperation(c72100044.negop)  
	c:RegisterEffect(e3)  
end
function c72100044.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_FIELD) and (   c:IsSetCard(0xf9) or c:IsSetCard(0xbe)   ) and c:IsAbleToHand() and not c:IsCode(72100044)
end
function c72100044.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c72100044.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(72100044,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
-------
function c72100044.cfilter(c)  
	return c:IsFaceup() and c:IsAttackAbove(2400) and c:IsDefense(1000) 
end  
function c72100044.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetFlagEffect(72100044)==0 and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_MONSTER)) and rp~=tp and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(c72100044.cfilter,tp,LOCATION_MZONE,0,1,nil)
end  
function c72100044.negop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then  
		Duel.Hint(HINT_CARD,0,72100044)  
		e:GetHandler():RegisterFlagEffect(72100044,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)  
		if Duel.NegateEffect(ev) then  
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)  
		end  
	end  
end 