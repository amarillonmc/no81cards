--闪刀术士 音速突破
function c11513051.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c11513051.condition)
	e1:SetTarget(c11513051.target)
	e1:SetOperation(c11513051.operation)
	c:RegisterEffect(e1)
end
function c11513051.cfilter(c)
	return c:GetSequence()<5
end
function c11513051.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c11513051.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11513051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) 
end 
function c11513051.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(1000) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
		if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,3,nil,TYPE_SPELL) and g:GetCount()>0 then 
			local tc=g:GetFirst() 
			while tc do 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(-1500) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1) 
			tc=g:GetNext() 
			end 
		end 
	end 
end  







